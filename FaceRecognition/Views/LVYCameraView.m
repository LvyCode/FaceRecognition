
#import "LVYCameraView.h"

@interface LVYCameraView ()
@property (weak, nonatomic) IBOutlet LVYPreviewView *previewView;
@end

@implementation LVYCameraView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor blackColor];
}

@end
