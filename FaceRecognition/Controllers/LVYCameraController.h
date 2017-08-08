
#import <AVFoundation/AVFoundation.h>
#import "LVYBaseCameraController.h"
#import "LVYFaceDetectionDelegate.h"

@interface LVYCameraController : LVYBaseCameraController

@property (weak, nonatomic) id <LVYFaceDetectionDelegate> faceDetectionDelegate;

@end
