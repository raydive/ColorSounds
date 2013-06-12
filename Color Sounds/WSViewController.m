//
//  WSViewController.m
//  Color Sounds
//
//

#import "WSViewController.h"

@interface WSViewController ()

@end

@implementation WSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)firstViewReturnActionForSegue:(UIStoryboardSegue *)segue
{
    NSLog(@"Return from Setting View");
}

- (IBAction)captureImage:(id)sender {
    NSLog(@"Image Captured!");
}

- (IBAction)switchChagned:(id)sender forEvent:(UIEvent *)event {
    NSLog(@"Switch Changed!");
}

@end
