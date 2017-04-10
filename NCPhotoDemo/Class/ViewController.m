//
//  ViewController.m
//  NCPhotoDemo
//
//  Created by Noah.C on 2017/3/29.
//

#import "ViewController.h"
#import "PhotoModel.h"
#import "PhotoAlbumController.h"

@interface ViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, assign) int index;
@property (nonatomic, assign) NSInteger photoCount;
@property (nonatomic, strong) UIImagePickerController *cameraContoller;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if ([PhotoModel hasImageData:[PhotoModel getSearchPath:0]] == YES) {
        self.showPhotoView.image = [PhotoModel wirteImageData:0];
    }
}

- (IBAction)openPhotoAlbum:(UIButton *)sender {
    if ([PhotoModel openPhotoAlbumAvailable] == YES) {
        PhotoAlbumController *pac = [[PhotoAlbumController alloc] init];
        [pac returnPhotosBlock:^(NSArray *photoArr) {
            //NSLog(@"照片数量---%lu",(unsigned long)photoArr.count);
            self.photoCount = photoArr.count;
            self.showPhotoView.image = photoArr[0];
            [PhotoModel saveImages:photoArr compressionQuality:1.0];
        }];
        [self.navigationController pushViewController:pac animated:YES];
    }
}

- (IBAction)takePhoto:(UIButton *)sender {
    if ([PhotoModel takePhotoAvailable] == YES) {
        self.cameraContoller = [[UIImagePickerController alloc] init];
        self.cameraContoller.delegate = self;
        self.cameraContoller.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.cameraContoller.editing = YES;
        self.cameraContoller.showsCameraControls = YES;
        [self presentViewController:self.cameraContoller animated:YES completion:nil];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.photoCount == 0) return;
    self.index++;
    if (self.index == self.photoCount) {
        self.index = 0;
    }
    self.showPhotoView.image = [PhotoModel wirteImageData:self.index];
    if (self.photoCount != 1) {
        [UIView transitionWithView:self.showPhotoView duration:1.0 options: UIViewAnimationOptionTransitionCurlUp animations:nil completion:nil];
    }
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
        [PhotoModel saveImage:image compressionQuality:1.0];
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
