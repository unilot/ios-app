//
//  ScannerReader.swift
//  Unilot
//
//  Created by Alyona2013 on 11/22/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//

import AVFoundation
import UIKit

class ScannerViewController: PopUpCore, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    @IBOutlet weak var viewQR : UIView!
    
    class func create() -> ScannerViewController {
        let myClassNib = UINib(nibName: "ScannerReader", bundle: nil)
        return myClassNib.instantiate(withOwner: nil, options: nil)[0] as! ScannerViewController
    }
    
    override func setInitBorders() {
        self.backgroundColor = UIColor.white
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = viewQR.bounds
        viewQR.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
    }
    
    
    func failed() {
        delegate?.onQRAnswer(nil)
    }
    override func onX(_ duration: Double = 0.4) {
 
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
        
        super.onX(duration)
    }
    
    func metadataOutput(_ captureOutput: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            delegate?.onQRAnswer(stringValue)
        }
        
        onX()
        
    }
    
 
}

