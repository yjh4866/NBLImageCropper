//
//  NBLImageCropper.h
//  Pods
//
//  Created by HTJT-yangjh on 2019/1/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NBLImageCropper : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) CGSize targetSize;

+ (instancetype)sharedInstance;

- (void)selectImageOn:(UIViewController *)viewController
             callback:(void(^)(UIImage *image))callback;

@end

NS_ASSUME_NONNULL_END
