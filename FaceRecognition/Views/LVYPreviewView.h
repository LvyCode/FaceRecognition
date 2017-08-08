
#import <AVFoundation/AVFoundation.h>
#import "LVYFaceDetectionDelegate.h"

@interface LVYPreviewView : UIView <LVYFaceDetectionDelegate>

@property (strong, nonatomic) AVCaptureSession *session;

@end
