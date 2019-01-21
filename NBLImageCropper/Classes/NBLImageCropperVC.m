//
//  NBLImageCropperVC.m
//  Pods
//
//  Created by HTJT-yangjh on 2019/1/21.
//

#import "NBLImageCropperVC.h"

@interface NBLImageCropperVC () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imgViewCover;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) UIView *imageContainer;
@property (strong, nonatomic) UIImageView *imageView;

@property (nonatomic, assign) CGRect rectCropper;
@property (nonatomic, assign) CGFloat scaleImageToCropper;
@end

@implementation NBLImageCropperVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    // Do any additional setup after loading the view.
    if (self.targetSize.width < 1 || self.targetSize.height < 1) {
        self.targetSize = self.view.bounds.size;
    }
    // 创建遮盖层图片
    self.imgViewCover.image = [self createCoverImage];
    // 计算剪裁框的位置
    CGFloat cropperScaleH = self.view.bounds.size.width / self.targetSize.width;
    CGFloat cropperScaleV = self.view.bounds.size.height / self.targetSize.height;
    CGFloat scaleCropper = cropperScaleH < cropperScaleV ? cropperScaleH : cropperScaleV;
    CGSize sizeCropper = CGSizeMake(scaleCropper * self.targetSize.width, scaleCropper * self.targetSize.height);
    self.rectCropper = CGRectMake((self.view.bounds.size.width-sizeCropper.width)/2, (self.view.bounds.size.height-sizeCropper.height)/2, sizeCropper.width, sizeCropper.height);
    // 图片显示的尺寸
    CGFloat imageScaleH = self.originalImage.size.width / self.rectCropper.size.width;
    CGFloat imageScaleV = self.originalImage.size.height / self.rectCropper.size.height;
    self.scaleImageToCropper = imageScaleH < imageScaleV ? imageScaleH : imageScaleV;
    CGSize sizeImage = CGSizeMake(self.originalImage.size.width / self.scaleImageToCropper, self.originalImage.size.height / self.scaleImageToCropper);
    
    // 设置滚动视图的滚动范围
    self.scrollView.contentSize = sizeImage;
    self.scrollView.contentInset = UIEdgeInsetsMake(self.rectCropper.origin.y, self.rectCropper.origin.x, self.rectCropper.origin.y, self.rectCropper.origin.x);
    self.scrollView.contentOffset = CGPointMake(-self.rectCropper.origin.x, -self.rectCropper.origin.y);
    // 滚动图片用的容器
    self.imageContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sizeImage.width, sizeImage.height)];
    [self.scrollView addSubview:self.imageContainer];
    // 显示图片
    self.imageView = [[UIImageView alloc] initWithImage:self.originalImage];
    self.imageView.frame = self.imageContainer.bounds;
    [self.imageContainer addSubview:self.imageView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}


#pragma mark - Event

- (IBAction)clickCancel:(id)sender
{
    [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)clickOK:(id)sender
{
    // 计算剪切位置及大小
    CGFloat imageScaleH = self.originalImage.size.width / self.targetSize.width;
    CGFloat imageScaleV = self.originalImage.size.height / self.targetSize.height;
    CGFloat imageScale = imageScaleH < imageScaleV ? imageScaleH : imageScaleV;
    CGRect rectCropper = CGRectMake(((self.scrollView.contentInset.left+self.scrollView.contentOffset.x)/self.scrollView.zoomScale)*self.scaleImageToCropper, ((self.scrollView.contentInset.top+self.scrollView.contentOffset.y)/self.scrollView.zoomScale)*self.scaleImageToCropper, self.targetSize.width*imageScale/self.scrollView.zoomScale, self.targetSize.height*imageScale/self.scrollView.zoomScale);
    // 剪裁图片
    UIGraphicsBeginImageContext(rectCropper.size);
    [self.originalImage drawInRect:CGRectMake(-rectCropper.origin.x, -rectCropper.origin.y, self.originalImage.size.width, self.originalImage.size.height)];
    UIImage *imageCropped = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // 绽放到目标大小
    UIGraphicsBeginImageContext(self.targetSize);
    [imageCropped drawInRect:CGRectMake(0, 0, self.targetSize.width, self.targetSize.height)];
    UIImage *imageTarget = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // 回传剪切到的图片
    if (self.blockPickImage) {
        self.blockPickImage(imageTarget);
    }
    //
    [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageContainer;
}


#pragma mark - Private

- (UIImage *)createCoverImage
{
    CGRect bounds = CGRectMake(0, 0, [UIScreen mainScreen].nativeScale * self.view.bounds.size.width, [UIScreen mainScreen].nativeScale * self.view.bounds.size.height);
    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 半透明层
    CGContextSetFillColorWithColor(context, [UIColor colorWithWhite:0 alpha:0.7f].CGColor);
    CGContextFillRect(context, bounds);
    // 扣掉一块
    CGFloat scaleH = bounds.size.width / self.targetSize.width;
    CGFloat scaleV = bounds.size.height / self.targetSize.height;
    CGFloat scale = scaleH < scaleV ? scaleH : scaleV;
    CGSize sizeCropper = CGSizeMake(scale * self.targetSize.width, scale * self.targetSize.height);
    CGRect rectCropper = CGRectMake(1+(bounds.size.width-sizeCropper.width)/2, 1+(bounds.size.height-sizeCropper.height)/2, sizeCropper.width-2, sizeCropper.height-2);
    CGContextClearRect(context, rectCropper);
    // 加个框
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextStrokeRectWithWidth(context, rectCropper, 1);
    // 提取生成的遮盖层图片
    UIImage *imageCover = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageCover;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
