//
//  ViewController.m
//  NCPhotoDemo
//
//  Created by Noah.C on 2017/3/29.
//

#import "ViewController.h"
#import "PhotoController.h"
#import "PhotoModel.h"
#import "PhotoManager.h"

@interface ViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, assign) int index;
@property (nonatomic, assign) NSInteger photoCount;
@property (nonatomic, strong) UIImagePickerController *cameraContoller;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
}

- (IBAction)openPhotoAlbum:(UIButton *)sender {
    [PhotoManager photoAlbumAvailableResponse:^(BOOL isEnabled) {
        if (isEnabled) {
            dispatch_async(dispatch_get_main_queue(), ^{
                PhotoController *pvc = [[PhotoController alloc] init];
                [pvc returnPhotosBlock:^(NSArray *photoArr) {
                    NSLog(@"照片---%@",photoArr);
                }];
                [self.navigationController pushViewController:pvc animated:YES];
            });
        } else {
            NSLog(@"不允许使用相册");
        }
    }];
}

- (IBAction)openCamera:(UIButton *)sender {
    
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    if (editedImage == nil){
        editedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    if (picker == self.cameraContoller) {
        UIImageWriteToSavedPhotosAlbum(editedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
    else if (picker == self.cameraContoller) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"image" object:editedImage];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (!error) {
        self.showPhotoView.image = image;
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"照片保存失败" message:@"请您检查相关设置" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
