
#import "LVYPreviewView.h"

@interface LVYPreviewView ()

@property (nonatomic, strong) CALayer *overLayer;

@property (nonatomic, strong) NSMutableDictionary *faceLayers;
//返回相机
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;


@end

@implementation LVYPreviewView

+ (Class)layerClass {

   
    return [AVCaptureVideoPreviewLayer class];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {

    //初始化字典
    self.faceLayers = [NSMutableDictionary dictionary];
    
    //videoGravity：显示样式
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    //
    self.overLayer = [CALayer layer];
    self.overLayer.frame = self.bounds;
    
    //子图层形变
    self.overLayer.sublayerTransform = CATransform3DMakePerspective(1000);
    
    [self.previewLayer addSublayer:self.overLayer];
    
    

}

- (AVCaptureSession*)session {

    return self.previewLayer.session;
}

- (void)setSession:(AVCaptureSession *)session {

    self.previewLayer.session = session;
    
}

- (AVCaptureVideoPreviewLayer *)previewLayer {

    return (AVCaptureVideoPreviewLayer *)self.layer;
}

- (void)didDetectFaces:(NSArray *)faces {

    //保存转换后的人脸数据
    NSArray *transformedFaces = [self transformedFacesFromFaces:faces];
    //获取faceLayers的all key
    NSMutableArray *lostFaces = [self.faceLayers.allKeys mutableCopy];
    
    for (AVMetadataFaceObject *face in transformedFaces) {
        NSNumber *faceID = @(face.faceID);
        //将对象key从lostFaces 移除
        [lostFaces removeObject:faceID];
        
        CALayer *layer = self.faceLayers[faceID];
        
        if (!layer) {
            
            //makeFaceLayer 新建一个人脸的图层
            layer = [self makeFaceLayer];
            //将人脸图层添加到overlayer上
            [self.overLayer addSublayer:layer];
            
            //将layer加入到字典中
            self.faceLayers[faceID] = layer;
            
            
        }
        layer.transform = CATransform3DIdentity;
        //指定图层的位置
        layer.frame = face.bounds;
        
        //人脸斜倾角
        if (face.hasRollAngle) {
            
            //如果为yes，则获取
            CATransform3D t = [self transformForRollAngle:face.rollAngle];
            
            layer.transform = CATransform3DConcat(layer.transform, t);
            
        }
        
        if (face.hasYawAngle) {
            
            CATransform3D t = [self transformForYawAngle:face.yawAngle];
            layer.transform = CATransform3DConcat(layer.transform, t);
            
        }
        
        
    }
    
    for (NSNumber *faceID in lostFaces) {
        
        CALayer *layer = self.faceLayers[faceID];
        [layer removeFromSuperlayer];
        [self.faceLayers removeObjectForKey:faceID];
        
        
    }

}

- (NSArray *)transformedFacesFromFaces:(NSArray *)faces {

    NSMutableArray *transformedFaces = [NSMutableArray array];
    
    for (AVMetadataObject *face in faces) {
        //将摄像头的_>屏幕
        AVMetadataObject *tranformFace = [self.previewLayer transformedMetadataObjectForMetadataObject:face];
        [transformedFaces addObject:tranformFace];
        
        
    }
    return transformedFaces;
    
}

- (CALayer *)makeFaceLayer {

    CALayer *layer = [CALayer layer];
    layer.borderWidth = 5.0f;
    layer.borderColor = [UIColor redColor].CGColor;
    layer.contents =(id)[UIImage imageNamed:@"551.png"].CGImage;
    
    
    return layer;
}



- (CATransform3D)transformForRollAngle:(CGFloat)rollAngleInDegrees {

    //将弧度-》度数
    CGFloat rollAngleInRaidians = THDegreesToRadians(rollAngleInDegrees);
    
    //围着z轴转
    return CATransform3DMakeRotation(rollAngleInRaidians, 0.0f, 0.0f, 1.0f);
    ;
}

- (CATransform3D)transformForYawAngle:(CGFloat)yawAngleInDegrees {

    CGFloat yawAngleInRaians = THDegreesToRadians(yawAngleInDegrees);
    CATransform3D yawTransform = CATransform3DMakeRotation(yawAngleInRaians, 0.0f, -1.0f, 0.0f);
    
    return CATransform3DConcat(yawTransform, [self orientationTransform]);
}

- (CATransform3D)orientationTransform {

    CGFloat angle = 0.0;
    switch ([UIDevice currentDevice].orientation) {
        //获取设备方向
        case UIDeviceOrientationPortraitUpsideDown://朝下
            angle = M_PI;
            
            break;
        case UIDeviceOrientationLandscapeRight:
            angle = -M_PI/2.0f;
            break;
        case UIDeviceOrientationFaceUp:
            angle = M_PI/2.0f;
            break;
        
        default:
            angle = 0.0f;
            break;
    }
    
    return CATransform3DMakeRotation(angle, 0.0f, 0.0f, 1.0f);
}

// The clang pragmas can be removed when you're finished with the project.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused"

static CGFloat THDegreesToRadians(CGFloat degrees) {

    //弧度转度数
    
    return degrees * M_PI/180;
}

static CATransform3D CATransform3DMakePerspective(CGFloat eyePosition) {

    CATransform3D transform = CATransform3DIdentity;
    
    //m34 透视效果
    transform.m34 = -1.0/eyePosition;
    
    return transform;

}
#pragma clang diagnostic pop

@end
