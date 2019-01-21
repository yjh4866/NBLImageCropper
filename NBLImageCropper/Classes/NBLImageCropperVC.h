//
//  NBLImageCropperVC.h
//  Pods
//
//  Created by HTJT-yangjh on 2019/1/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NBLImageCropperVC : UIViewController

@property (nonatomic, strong) UIImage *originalImage;
@property (nonatomic, assign) CGSize targetSize;

@property (nonatomic, strong) void (^blockPickImage)(UIImage *image);

@end

NS_ASSUME_NONNULL_END
