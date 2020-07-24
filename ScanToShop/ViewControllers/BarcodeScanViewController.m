//
//  BarcodeScanViewController.m
//  ScanToShop
//
//  Created by Joey R. Hernandez Perez on 7/13/20.
//  Copyright © 2020 joeyrhernandez1. All rights reserved.
//

#import "BarcodeScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MLKit.h>

@interface BarcodeScanViewController () <AVCaptureVideoDataOutputSampleBufferDelegate>

@property (weak, nonatomic) IBOutlet UIView *previewView;
@property (nonatomic) AVCaptureSession *captureSession;
@property (nonatomic) AVCaptureVideoDataOutput *videoDataOutput;
@property (nonatomic) AVCaptureVideoPreviewLayer *videoPreviewLayer;

@end

@implementation BarcodeScanViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.captureSession = [AVCaptureSession new];
    self.captureSession.sessionPreset = AVCaptureSessionPreset1280x720;
    
    AVCaptureDevice *backCamera = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (!backCamera) {
        NSLog(@"Unable to access back camera!");
        return;
    }
    
    NSError *error;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:backCamera error:&error];
    if (!error) {
        self.videoDataOutput = [AVCaptureVideoDataOutput new];
        NSDictionary *newSettings = @{(NSString *)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_32BGRA) };
        self.videoDataOutput.videoSettings = newSettings;
        [self.videoDataOutput setAlwaysDiscardsLateVideoFrames:YES];
        if ([self.captureSession canAddInput:input] && [self.captureSession canAddOutput:self.videoDataOutput]) {
            [self.captureSession addInput:input];
            [self.captureSession addOutput:self.videoDataOutput];
            dispatch_queue_t videoDataOutputQueue = dispatch_queue_create("VideoDataOutputQueue", DISPATCH_QUEUE_SERIAL);
            [self.videoDataOutput setSampleBufferDelegate:self queue:videoDataOutputQueue];
            [self setupLivePreview];
        }
    }
    else {
        NSLog(@"Error Unable to initialize back camera: %@", error.localizedDescription);
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.captureSession stopRunning];
}

- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    MLKVisionImage *image = [[MLKVisionImage alloc] initWithBuffer:sampleBuffer];
    image.orientation = [self imageOrientationFromDeviceOrientation:UIDevice.currentDevice.orientation cameraPosition:AVCaptureDevicePositionBack];
    MLKBarcodeScanner *barcodeScanner = [MLKBarcodeScanner barcodeScanner];
    [barcodeScanner processImage:image completion:^(NSArray<MLKBarcode *> * _Nullable barcodes, NSError * _Nullable error) {
        if (error) {
            return;
        }
        if (barcodes.count > 0) {
            [self.delegate didScanBarcode:barcodes.firstObject.rawValue];
            [self performSegueWithIdentifier:@"dealsSegue" sender:nil];
        }
        else {
            return;
        }
    }];
}

- (void)setupLivePreview {
    self.videoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
    if (self.videoPreviewLayer) {
        self.videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        self.videoPreviewLayer.connection.videoOrientation = AVCaptureVideoOrientationPortrait;
        [self.previewView.layer addSublayer:self.videoPreviewLayer];
        [self.view insertSubview:self.previewView atIndex:0];
        self.videoPreviewLayer.frame = self.previewView.bounds;
        if (!self.captureSession.isRunning) {
            [self.captureSession startRunning];
        }
    }
}

- (UIImageOrientation)imageOrientationFromDeviceOrientation:(UIDeviceOrientation)deviceOrientation cameraPosition:(AVCaptureDevicePosition)cameraPosition {
    switch (deviceOrientation) {
        case UIDeviceOrientationPortrait:
            return cameraPosition == AVCaptureDevicePositionFront ? UIImageOrientationLeftMirrored
            : UIImageOrientationRight;
        case UIDeviceOrientationLandscapeLeft:
            return cameraPosition == AVCaptureDevicePositionFront ? UIImageOrientationDownMirrored
            : UIImageOrientationUp;
        case UIDeviceOrientationPortraitUpsideDown:
            return cameraPosition == AVCaptureDevicePositionFront ? UIImageOrientationRightMirrored
            : UIImageOrientationLeft;
        case UIDeviceOrientationLandscapeRight:
            return cameraPosition == AVCaptureDevicePositionFront ? UIImageOrientationUpMirrored
            : UIImageOrientationDown;
        case UIDeviceOrientationUnknown:
        case UIDeviceOrientationFaceUp:
        case UIDeviceOrientationFaceDown:
            return UIImageOrientationUp;
    }
}

@end
