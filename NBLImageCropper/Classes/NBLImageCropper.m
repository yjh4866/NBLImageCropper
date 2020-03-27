//
//  NBLImageCropper.m
//  Pods
//
//  Created by HTJT-yangjh on 2019/1/21.
//

#import "NBLImageCropper.h"
#import "NBLImageCropperVC.h"

@interface NBLImageCropper () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, strong) void (^blockPickImage)(UIImage *image);
@end

@implementation NBLImageCropper

+ (instancetype)sharedInstance
{
    static NBLImageCropper *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[NBLImageCropper alloc] init];
    });
    return sharedInstance;
}

- (void)selectImageOn:(UIViewController *)viewController
             callback:(void(^)(UIImage *image))callback
{
    self.blockPickImage = callback;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:self.title message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    // 相机
    __weak typeof(self) weakSelf = self;
    [alertController addAction:[UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf openImagePicker:UIImagePickerControllerSourceTypeCamera on:viewController];
    }]];
    // 相册
    [alertController addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf openImagePicker:UIImagePickerControllerSourceTypePhotoLibrary on:viewController];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [viewController presentViewController:alertController animated:YES completion:nil];
}


#pragma mark - UINavigationControllerDelegate


#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info
{
    // 加载Bundle
    NSBundle *bundle = [NSBundle bundleForClass:NBLImageCropper.class];
    // 获取视图控制器
    NBLImageCropperVC *imageCropperVC = [[UIStoryboard storyboardWithName:@"NBLImageCropper.bundle/NBLImageCropper" bundle:bundle] instantiateInitialViewController];
    // 进入剪裁页面
    imageCropperVC.originalImage = info[UIImagePickerControllerOriginalImage];
    imageCropperVC.targetSize = self.targetSize;
    imageCropperVC.blockPickImage = self.blockPickImage;
    [picker pushViewController:imageCropperVC animated:YES];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Private

- (void)openImagePicker:(UIImagePickerControllerSourceType)sourceType on:(UIViewController *)viewController
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = sourceType;
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        imagePicker.cameraDevice = self.cameraDevice;
    }
//    imagePicker.allowsEditing = YES;
    imagePicker.delegate = self;
    [viewController presentViewController:imagePicker animated:YES completion:nil];
}

@end
