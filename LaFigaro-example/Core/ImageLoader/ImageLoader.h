
#import <Foundation/Foundation.h>

@protocol ImageLoaderProtocol <NSObject>

- (void)didLoadImage:(UIImage *)image fromUrlString:(NSString *)urlString;

@end

@interface ImageLoader : NSObject

+ (ImageLoader *)sharedLoader;

- (void)downloadImage:(NSString *) URLString to:(id<ImageLoaderProtocol>)delegate;
- (void)preloadImage:(NSString *)urlString;

- (UIImage *)miniImageForImage:(UIImage *)image;
- (UIImage *)imageFromDiskCacheWithURL:(NSString *)urlString;

- (void)clearCacheForDownloads;
- (void)suspendDownloads:(BOOL)suspend;
- (void)cancelDownloadsInProgress;
- (void)cancelDownloadsForDelegate:(id)delegate;

@end
