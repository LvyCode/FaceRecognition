
#import "LVYViewController.h"
#import "LVYCameraController.h"
#import "LVYPreviewView.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface LVYViewController ()

@property (strong, nonatomic) LVYCameraController *cameraController;
@property (weak, nonatomic) IBOutlet LVYPreviewView *previewView;

@end

@implementation LVYViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.cameraController = [[LVYCameraController alloc] init];

    NSError *error;
    if ([self.cameraController setupSession:&error]) {

        [self.cameraController switchCameras];
        [self.previewView setSession:self.cameraController.captureSession];
        self.cameraController.faceDetectionDelegate = self.previewView;

        [self.cameraController startSession];
    } else {
        NSLog(@"Error: %@", [error localizedDescription]);
    }

}

- (IBAction)swapCameras:(id)sender {
    [self.cameraController switchCameras];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
