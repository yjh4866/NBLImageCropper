//
//  NBLViewController.m
//  NBLImageCropper
//
//  Created by 杨建红 on 01/21/2019.
//  Copyright (c) 2019 杨建红. All rights reserved.
//

#import "NBLViewController.h"
#import <NBLImageCropper/NBLImageCropper.h>

@interface NBLViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView0;
@property (weak, nonatomic) IBOutlet UIImageView *imgView1;
@end

@implementation NBLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickButton0:(id)sender
{
    __weak typeof(self) weakSelf = self;
    //
    [NBLImageCropper sharedInstance].title = @"选择头像";
    [NBLImageCropper sharedInstance].targetSize = CGSizeMake(300, 300);
    [[NBLImageCropper sharedInstance] selectImageOn:self callback:^(UIImage * _Nonnull image) {
        weakSelf.imgView0.image = image;
    }];
}
- (IBAction)clickButton1:(id)sender
{
    __weak typeof(self) weakSelf = self;
    //
    [NBLImageCropper sharedInstance].title = @"选择照片";
    [NBLImageCropper sharedInstance].targetSize = CGSizeMake(400, 600);
    [[NBLImageCropper sharedInstance] selectImageOn:self callback:^(UIImage * _Nonnull image) {
        weakSelf.imgView1.image = image;
    }];
}

@end
