//
//  WSViewController.m
//  Color Sounds
//
//

#import "WSViewController.h"

/*!
    WSViewControllerクラス
    privateメソッド用
 */
@interface WSViewController (Private)

- (void)startAVCapture;
- (UIImage*)imageFrameSampleBuffer:(CMSampleBufferRef)sampleBuffer;

@end



/*!
    WSViewControllerクラス
 */
@implementation WSViewController

#pragma mark -
#pragma mark private

- (void)startAVCapture
{
    // カメラキャプチャの準備
    device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    NSError* error = nil;
    videoInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    videoDataOutput = [AVCaptureVideoDataOutput new];
    videoDataOutput.videoSettings =
        @{ (id)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_32BGRA)};
    
    // ビデオ出力のキャプチャの画像情報キューを設定
    videoDataOutput.alwaysDiscardsLateVideoFrames = TRUE;
    dispatch_queue_t queue = dispatch_queue_create("VideoQueu", DISPATCH_QUEUE_SERIAL);
    [videoDataOutput setSampleBufferDelegate:self queue:queue];
    
    // セッションの作成
    session = [AVCaptureSession new];
    [session setSessionPreset:AVCaptureSessionPreset640x480];
    if ([session canAddInput:videoInput]) {
        [session addInput:videoInput];
    } else {
        return;
    }
    
    if ([session canAddOutput:videoDataOutput]) {
        [session addOutput:videoDataOutput];
    } else {
        return;
    }
    
    AVCaptureConnection* videoConnection = [videoDataOutput connectionWithMediaType:AVMediaTypeVideo];
    videoConnection.enabled = NO;
    videoConnection.videoMaxFrameDuration = CMTimeMake(1, 30);
    
    [session startRunning];
    
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        CALayer* previewLayer = _cameraImageView.layer;
        captureLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
        captureLayer.frame = previewLayer.bounds;
        captureLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        previewLayer.masksToBounds = YES;
        [previewLayer addSublayer:captureLayer];
    });
}


/*!
    
 */
- (UIImage*)imageFrameSampleBuffer:(CMSampleBufferRef)sampleBuffer
{
    UIImage* image = nil;
    
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    uint8_t* baseAddress = (uint8_t*)CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
 
    // RBGの色空間
    CGColorSpaceRef colorSapce = CGColorSpaceCreateDeviceRGB();
    CGContextRef newContext = CGBitmapContextCreate(baseAddress,
                                                    width, height, 8, bytesPerRow, colorSapce,
                                                    kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    
    CGImageRef cgImage = CGBitmapContextCreateImage(newContext);
    
    CGContextRelease(newContext);
    CGColorSpaceRelease(colorSapce);
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    
    image = [UIImage imageWithCGImage:cgImage scale:1.0 orientation:UIImageOrientationRight];
    CGImageRelease(cgImage);
    
    return image;
}

#pragma mark -
#pragma mark public

/*!
    Viewがロードされたときに呼び出される。
    Videoキャプチャを開始する。
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // キャプチャスタート
    [self startAVCapture];
}


/*
    メモリ逼迫したときに処理
 */
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*!
    Exitセグエ用
 */
- (IBAction)firstViewReturnActionForSegue:(UIStoryboardSegue *)segue
{
    NSLog(@"Return from Setting View");
}

/*!
    メロディを流すために使用
 */
- (IBAction)switchChaigned:(id)sender forEvent:(UIEvent *)event {
    NSLog(@"Switch Changed!");
}


#pragma mark -
#pragma mark <AVCaptureVideoDataOutputSampleBufferDelegate>

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    // TODO: キャプチャされた画像
}

@end
