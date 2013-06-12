//
//  WSViewController.h
//  Color Sounds
//

#import <UIKit/UIKit.h>

@interface WSViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *cameraImageView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *cameraButton;

@property (weak, nonatomic) IBOutlet UISwitch *cl2soundSwitch;


- (IBAction)firstViewReturnActionForSegue:(UIStoryboardSegue*)segue;
- (IBAction)captureImage:(id)sender;
- (IBAction)switchChagned:(id)sender forEvent:(UIEvent *)event;

@end
