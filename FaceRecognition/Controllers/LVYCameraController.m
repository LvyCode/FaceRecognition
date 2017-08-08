
#import "LVYCameraController.h"
#import <AVFoundation/AVFoundation.h>

@interface LVYCameraController ()<AVCaptureMetadataOutputObjectsDelegate>
@property(nonnull,strong)AVCaptureMetadataOutput *metaDataOutput;

@end

@implementation LVYCameraController

- (BOOL)setupSessionOutputs:(NSError **)error {

    self.metaDataOutput = [[AVCaptureMetadataOutput alloc]init];
    
    if ([self.captureSession canAddOutput:self.metaDataOutput]) {
        //将输出添加到捕捉回话中
        [self.captureSession addOutput:self.metaDataOutput];
        
        NSArray *metaDataObjectTypes = @[AVMetadataObjectTypeFace];
        /*
         摄像头在捕捉数据时，会对人脸数据感兴趣
         */
        self.metaDataOutput.metadataObjectTypes = metaDataObjectTypes;
        //获取主队列，因为人脸检测用到硬件加速，而且很多任务都是在主线程执行，所以需要主队
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        
        //设置代理&队列
        [self.metaDataOutput setMetadataObjectsDelegate:self queue:mainQueue];
        
        return YES;
        
    }else{
        //打印错误信息
        
    }

    return NO;
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputMetadataObjects:(NSArray *)metadataObjects
       fromConnection:(AVCaptureConnection *)connection {

    for (AVMetadataFaceObject *face in metadataObjects) {
        NSLog(@"faceID %li",(long)face.faceID);
        NSLog(@"bounds %@",NSStringFromCGRect(face.bounds));
        
    }
    //将捕捉的数据通过代理传递给 THPreview
    [self.faceDetectionDelegate didDetectFaces:metadataObjects];
    
}

@end

