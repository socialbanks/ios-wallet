//
//  QRCodeReaderVC.swift
//  Social Wallet
//
//  Created by Mauricio de Oliveira on 5/2/15.
//  Copyright (c) 2015 SocialBanks. All rights reserved.
//

import UIKit
import AVFoundation

class QRCodeReaderVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
        // as the media type parameter.
        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        // Get an instance of the AVCaptureDeviceInput class using the previous device object.
        var error:NSError?
        let input: AnyObject! = AVCaptureDeviceInput.deviceInputWithDevice(captureDevice, error: &error)
        
        if (error != nil) {
            // If any error occurs, simply log the description of it and don't continue any more.
            println("\(error?.localizedDescription)")
            return
        }
        
        // Initialize the captureSession object.
        captureSession = AVCaptureSession()
        // Set the input device on the capture session.
        captureSession?.addInput(input as! AVCaptureInput)
    
        // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession?.addOutput(captureMetadataOutput)
        
        // Set delegate and use the default dispatch queue to execute the call back
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoPreviewLayer?.frame = cameraView.layer.frame
        //videoPreviewLayer!.frame.height = videoPreviewLayer.frame.width;
        cameraView.layer.addSublayer(videoPreviewLayer)
        
        // Start video capture.
        captureSession?.startRunning()
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            //qrCodeFrameView?.frame = CGRectZero
            //messageLabel.text = "No QR code is detected"
            //activityIndicator.startAnimating();
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObjectTypeQRCode {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObjectForMetadataObject(metadataObj as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
            qrCodeFrameView?.frame = barCodeObject.bounds;
            
            if metadataObj.stringValue != nil {
                if metadataObj.stringValue.hasPrefix("bitcoin:") {
                    let data:NSString = metadataObj.stringValue
                    let address:String = data.substringFromIndex(8)
                    messageLabel.text = address
                    NSNotificationCenter.defaultCenter().postNotificationName("QR-Code Scanned", object: nil, userInfo: ["address":address])
                    self.navigationController?.popViewControllerAnimated(true);
                }else{
                    messageLabel.text = "Não é um endereço bitcoin"
                }
                // MELHOR USAR ALERTVIEW.
            }
        }
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        (segue.destinationViewController as! PayVC).addressTextField.text = messageLabel.text
    }
    
}
