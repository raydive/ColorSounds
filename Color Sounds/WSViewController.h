//
//  WSViewController.h
//  Color Sounds
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface WSViewController : UIViewController <AVCaptureVideoDataOutputSampleBufferDelegate>
{
    AVCaptureDevice* device;
    AVCaptureVideoDataOutput* videoDataOutput;
    AVCaptureDeviceInput* videoInput;
    AVCaptureSession* session;
    AVCaptureVideoPreviewLayer* captureLayer;
}

@property (strong, nonatomic) IBOutlet UIView *rootView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cameraButton;
@property (weak, nonatomic) IBOutlet UIView* cameraImageView;
@property (weak, nonatomic) IBOutlet UISwitch* cl2soundSwitch;


- (IBAction)firstViewReturnActionForSegue:(UIStoryboardSegue*)segue;
- (IBAction)switchChaigned:(id)sender forEvent:(UIEvent *)event;

@end
