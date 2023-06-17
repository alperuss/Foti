//
//  CameraController.swift
//  InstagramClone
//
//  Created by Alper Us on 2023-06-17.
//

import UIKit
import AVFoundation
import JGProgressHUD
class CameraController : UIViewController {
    let btnBack : UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "Arrow_Right")?.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(btnBackPressed), for: .touchUpInside)
        return btn
    }()
    @objc func btnBackPressed(){
        dismiss(animated: true)
    }
    let btnTakePhoto : UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "Take_Photo")?.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(btnTakePhotoPressed), for: .touchUpInside)
        return btn
    }()
    @objc func btnTakePhotoPressed(){
        let settings = AVCapturePhotoSettings()
        output.capturePhoto(with: settings, delegate: self)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        
        takePhoto()
        editView()
        
    }
    fileprivate func editView() {
        view.addSubview(btnTakePhoto)
        btnTakePhoto.anchor(top: nil, bottom: view.bottomAnchor , leading: nil, trailing: nil, paddingTop: 0, paddingBottom: -25, paddingLeft: 0, paddingRight: 0, width: 80, height: 80)
        btnTakePhoto.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        view.addSubview(btnBack)
        btnBack.anchor(top: view.topAnchor , bottom: nil , leading: nil, trailing: view.trailingAnchor, paddingTop: 25, paddingBottom: 0, paddingLeft: 0, paddingRight: -15, width: 50, height: 50)
        btnTakePhoto.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    let output = AVCapturePhotoOutput()
    fileprivate func takePhoto(){
        
        let captureSession = AVCaptureSession()
        
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else {return}
        do{
            let enter = try AVCaptureDeviceInput(device: device)
            
            if captureSession.canAddInput(enter){
                captureSession.addInput(enter)
            }
                
        } catch let error {
            print("Camera cannot be accessed", error.localizedDescription)
        }
        
        if captureSession.canAddOutput(output){
            captureSession.addOutput(output)
        }
        let preview = AVCaptureVideoPreviewLayer(session: captureSession)
        preview.frame = view.frame
        view.layer.addSublayer(preview)
        captureSession.startRunning()
    }
    
}
extension CameraController : AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else {return}
        
        let imagePreview = UIImage(data: imageData)
        
        let photoPreviewView = PhotoPreviewView()
        photoPreviewView.imgPhotoPreview.image = imagePreview
        
        view.addSubview(photoPreviewView)
        photoPreviewView.anchor(top: view.topAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        
            
    }
}
