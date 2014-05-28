
#import "ImageLoader.h"

const NSInteger kMaxCashedItemsInMemory = 20;
const CGFloat kImageScale = 2;
const NSInteger kMiniImageSize = 100;

#pragma mark - NSBlockOperation with weak userInfo

@interface NSBlockOperationWithWeakInfo : NSBlockOperation
@property(nonatomic, weak) id weakUserInfo;
@end

@implementation NSBlockOperationWithWeakInfo
@end

#pragma mark - ImageLoader

@interface ImageLoader ()
{
    NSMutableDictionary *_cacheForDownloads;
    NSOperationQueue *_operationQueue;
}

@end

@implementation ImageLoader

#pragma mark - Static Methods

+ (ImageLoader *)sharedLoader
{
    static dispatch_once_t once;
    static id sharedLoader;
    dispatch_once(&once, ^{
        sharedLoader = [[self alloc] init];
    });
    return sharedLoader;
}

#pragma mark - Init Methods

- (id)init
{
    self = [super init];
    if (self) {
        _cacheForDownloads = [[NSMutableDictionary alloc] init];
        _operationQueue = [[NSOperationQueue alloc] init];
        _operationQueue.maxConcurrentOperationCount = 3;
    }
    return self;
}

#pragma mark - Public Methods

- (UIImage *)imageFromDiskCacheWithURL:(NSString *)urlString
{
    NSString *imageFilePath = [self diskCachePathForURL:urlString];
    UIImage *image = [UIImage imageWithContentsOfFile:imageFilePath];
    return image;
}

- (UIImage *)miniImageForImage:(UIImage *)image
{
    CGFloat horizontalRatio = kMiniImageSize / image.size.width;
    CGFloat verticalRatio = kMiniImageSize / image.size.height;
    CGFloat ratio = MAX(horizontalRatio, verticalRatio);
    CGSize newSize = CGSizeMake(image.size.width * ratio, image.size.height * ratio);
    
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}

- (void)downloadImage:(NSString *)urlString to:(id<ImageLoaderProtocol>)delegate
{
    if (!urlString || [urlString isEqualToString:@""]) {
        return;
    }
    
    __block UIImage *image = [_cacheForDownloads objectForKey:urlString];
    if (image) {
        [delegate didLoadImage:image fromUrlString:urlString];
        
    } else if([self isImageInDiskCache:urlString]) {
        
        NSBlockOperationWithWeakInfo *downloadingOperation = [NSBlockOperationWithWeakInfo blockOperationWithBlock:^{
            NSString *imageFilePath = [self diskCachePathForURL:urlString];
            UIImage *image = [UIImage imageWithContentsOfFile:imageFilePath];
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^() {
                if (image) {
                    if (_cacheForDownloads.count > kMaxCashedItemsInMemory)
                    {
                        [self clearCacheForDownloads];
                    }
                    [_cacheForDownloads setObject:image forKey:urlString];
                }
                [delegate didLoadImage:image fromUrlString:urlString];
            }];
        }];
        downloadingOperation.weakUserInfo = delegate;
        [_operationQueue addOperation:downloadingOperation];
        
    }
    else {
        NSBlockOperationWithWeakInfo *downloadingOperation = [NSBlockOperationWithWeakInfo blockOperationWithBlock:^{
            
            image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]] scale:kImageScale];
            
            if(image) {
                if (_cacheForDownloads.count > kMaxCashedItemsInMemory)
                {
                    [self clearCacheForDownloads];
                }
                [_cacheForDownloads setValue:image forKey:urlString];
                [self saveImageToDiskCache:image URLstring:urlString];
            }
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^() {
                if(image) {
                    if (_cacheForDownloads.count > kMaxCashedItemsInMemory)
                    {
                        [self clearCacheForDownloads];
                    }
                    [_cacheForDownloads setValue:image forKey:urlString];
                }
                [delegate didLoadImage:image fromUrlString:urlString];
            }];
        }];
        downloadingOperation.weakUserInfo = delegate;
        [_operationQueue addOperation:downloadingOperation];
    }
}

- (void)cancelDownloadsForDelegate:(id)delegate
{
    for (NSBlockOperationWithWeakInfo *operation in _operationQueue.operations) {
        if (delegate == operation.weakUserInfo) {
            [operation cancel];
        }
    }
}

- (void)preloadImage:(NSString *)urlString
{
    NSString *imageFilePath = [self diskCachePathForURL:urlString];
	UIImage *image = [UIImage imageWithContentsOfFile:imageFilePath];
    if (image) {
        [_cacheForDownloads setObject:image forKey:urlString];
    }
}

- (void)clearCacheForDownloads
{
    [_cacheForDownloads removeAllObjects];
}

- (void)suspendDownloads:(BOOL)suspend
{
	[_operationQueue setSuspended:suspend];
}

- (void)cancelDownloadsInProgress
{
	[_operationQueue cancelAllOperations];
}

#pragma mark - Disk cache for downloaded images

- (NSString *)diskCachePath
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *cachePath = paths[0];
    
	if (![[NSFileManager defaultManager] fileExistsAtPath:cachePath isDirectory:nil]) {
		NSError *error;
		[[NSFileManager defaultManager] createDirectoryAtPath:cachePath withIntermediateDirectories:NO attributes:nil error:&error];
		if (error) {
			NSLog(@"ImageLoader can't create cache directory:%@", error.description);
			return nil;
		}
	}
	return cachePath;
}

- (NSString *)diskCachePathForURL:(NSString *)urlString
{
    NSString *originURL = [urlString stringByReplacingOccurrencesOfString:@"?" withString:@"-"];
	NSString *validName = [originURL  stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
	NSString *imageFileName = [validName stringByAppendingPathExtension:@"png"];
	return [[self diskCachePath] stringByAppendingPathComponent:imageFileName];
}

- (BOOL)isImageInDiskCache:(NSString *)urlString
{
	NSString *imageFilePath = [self diskCachePathForURL:urlString];
	return [[NSFileManager defaultManager] fileExistsAtPath:imageFilePath];
}

- (void)saveImageToDiskCache:(UIImage *)image URLstring:(NSString *)urlString
{
	NSString *imageFilePath = [self diskCachePathForURL:urlString];
    
	if (![self isImageInDiskCache:urlString]) {
        NSData *imageData = UIImagePNGRepresentation(image);
		bool success = [[NSFileManager defaultManager] createFileAtPath:imageFilePath contents:imageData attributes:nil];
		if (!success) {
			NSLog(@"ImageLoader can't save image to cache. URL: %@ Path: %@", urlString, imageFilePath);
		}
	}
}

@end
