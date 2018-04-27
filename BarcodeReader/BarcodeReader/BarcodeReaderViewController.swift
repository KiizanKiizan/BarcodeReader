//
//  BarcodeReaderViewController.swift
//  BarcodeReader
//
//  Created by 岩井 宏晃 on 2018/04/24.
//  Copyright © 2018年 kiizan-kiizan. All rights reserved.
//

import UIKit
import AVFoundation

protocol BarcodeReaderViewControllerDelegate: class {
    func barcodeReaderViewController(_ vc: BarcodeReaderViewController, DidReadBarcode number: String)
}

class BarcodeReaderViewController: UIViewController {

    private let captureSession = AVCaptureSession()
    fileprivate var readBarcodeNumber = ""
    
    weak var delegate: BarcodeReaderViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        captureSession.startRunning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        captureSession.stopRunning()
    }
    
    private func setup() {
        do {
            let captureDevice = AVCaptureDevice.default(for: .video)!
            
            let captureInput = try AVCaptureDeviceInput(device: captureDevice)
            let captureOutput = AVCaptureMetadataOutput()
            captureOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
            captureSession.addInput(captureInput)
            captureSession.addOutput(captureOutput)
            
            captureOutput.metadataObjectTypes = [.ean8, .ean13]
            
            let capturePreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            
            capturePreviewLayer.frame = view.bounds
            capturePreviewLayer.videoGravity = .resizeAspectFill
            view.layer.addSublayer(capturePreviewLayer)
            
        } catch let error as NSError {
            print(error)
        }
    }
}

extension BarcodeReaderViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        if let barcodeObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
            let number = barcodeObject.stringValue ?? ""
            if readBarcodeNumber == number {
                return
            }
            readBarcodeNumber = number
            if !readBarcodeNumber.isEmpty {
                DispatchQueue.main.async {
                    self.delegate?.barcodeReaderViewController(self, DidReadBarcode: self.readBarcodeNumber)
                }
            }
        }
    }
}

