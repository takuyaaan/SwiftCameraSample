//
//  CameraViewController.swift
//  CameraSample
//
//  Created by TakuyaMano on 2017/10/06.
//  Copyright © 2017年 TakuyaMano. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    
    var delegate: PageViewControllerDelegate!

    fileprivate var input:AVCaptureDeviceInput!
    fileprivate var output:AVCapturePhotoOutput!
    fileprivate var session:AVCaptureSession!
    fileprivate var camera:AVCaptureDevice!
    fileprivate var preViewSize = CGRect.zero

    @IBOutlet weak var cameraControllView: UIView!
    @IBOutlet weak var shutterBtn: UIButton!

    @IBAction func takeCapture(_ sender: UIButton) {
        
        let photoSettings = AVCapturePhotoSettings()
        photoSettings.flashMode = .auto
        photoSettings.isAutoStillImageStabilizationEnabled = true
        photoSettings.isHighResolutionPhotoEnabled = false
        // get capture data to output
        output?.capturePhoto(with: photoSettings, delegate: self)
    }
    
    fileprivate func setupDisplay(){
        
        let screenWidth = UIScreen.main.bounds.size.width
        preViewSize = CGRect(x: 0.0, y: 0.0, width: screenWidth, height: screenWidth)
    }
    
    fileprivate func setupCamera(){
        
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        if status == AVAuthorizationStatus.authorized {
            // access permission
        }
        else if status == AVAuthorizationStatus.restricted {
            // not access permission
            return
        }
        else if status == AVAuthorizationStatus.notDetermined {
            // not heared the permission yet
        }
        else if status == AVAuthorizationStatus.denied {
            // access denid
            return
        }
        session = AVCaptureSession()
        // select camera type
        camera = AVCaptureDevice.default(.builtInWideAngleCamera,
                                         for: AVMediaType.video,
                                         position: .back) // position: .front
        
        do {
            // create input instance
            input = try AVCaptureDeviceInput(device: camera)
        }
        catch let error as NSError {
            print(error)
        }
        
        // add input to session
        if(session.canAddInput(input)) {
            session.addInput(input)
        }
        
        // create output instance
        output = AVCapturePhotoOutput()
        // iOS9以前
        //        output = AVCaptureStillImageOutput()
        
        // add output to session
        if(session.canAddOutput(output)) {
            session.addOutput(output)
            // iOS9以前
            //            session.addOutput(output as! AVCaptureStillImageOutput)
        }
        
        // get preview from session
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = preViewSize
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        // add preview-layer to view
        self.view.layer.insertSublayer(previewLayer, at: 0)
        
        // start session
        session.startRunning()
    }
    
    func savePhoto(_ image: UIImage!) {
        
        guard let imageOriginal = image else {
            return
        }
        UIGraphicsBeginImageContextWithOptions(imageOriginal.size, false, 0.0)
        imageOriginal.draw(in: CGRect(x: 0, y: 0, width: imageOriginal.size.width, height: imageOriginal.size.height))
        let originImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        if (delegate?.transitionViewController(viewController: self))! {
            ImageFilter.shared.originalImage = originImage
            stopSession()
        }
    }
    
    func stopSession() {
        
        session.stopRunning()
        for output in session.outputs {
            session.removeOutput(output)
        }
        for input in session.inputs {
            session.removeInput(input)
        }
        session = nil
        camera = nil
        self.view.layer.sublayers![0].removeFromSuperlayer()
    }
    
// MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        shutterBtn.setBackgroundImage(UIImage(named: "btn_circle"), for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {

        guard let _ = session else {
            // set screen
            setupDisplay()
            // set camera
            setupCamera()
            return
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        cameraControllView.translatesAutoresizingMaskIntoConstraints = true
        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height
        cameraControllView.frame.size = CGSize(width: screenWidth, height: (screenHeight - screenWidth) - kBottomBarHeight)
        cameraControllView.frame.origin = CGPoint(x: 0, y: preViewSize.origin.y+preViewSize.size.height)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: AVCapturePhotoCaptureDelegate
extension CameraViewController: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ captureOutput: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?,
                     previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?,
                     resolvedSettings: AVCaptureResolvedPhotoSettings,
                     bracketSettings: AVCaptureBracketedStillImageSettings?,
                     error: Error?) {

        if let error = error {
            print(error.localizedDescription)
            return
        }
        if let imageData =
            AVCapturePhotoOutput.jpegPhotoDataRepresentation(
                forJPEGSampleBuffer: photoSampleBuffer!,
                previewPhotoSampleBuffer: nil),
            let photo = UIImage(data: imageData) {
                savePhoto(photo)
            }
    }
    
}
