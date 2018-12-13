//
//  ViewController.swift
//  ImageToPdf
//
//  Created by Marcelo Sampaio on 13/12/18.
//  Copyright © 2018 Marcelo Sampaio. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    // MARK: - Properties
    private var imagePicker: UIImagePickerController!
    
    // Enums
    enum ImageSource {
        case photoLibrary
        case camera
    }
    
    // MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var convertImageButton: UIBarButtonItem!

    
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        convertImageButton.isEnabled = false
        
    }

    // MARK: - UI Action
    @IBAction func takePicture(_ sender: Any) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            selectImageFrom(.photoLibrary)
            return
        }
        selectImageFrom(.camera)
    }
    
    @IBAction func converImageToPdf(_ sender: Any) {
        print("✅ conver to pdf action")
        _ = createPDFDataFromImage(image: imageView.image!)
    }
    
    
    
    
    // MARK: - Capture Image Helper
    func selectImageFrom(_ source: ImageSource){
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        switch source {
        case .camera:
            imagePicker.sourceType = .camera
        case .photoLibrary:
            imagePicker.sourceType = .photoLibrary
        }
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    // MARK: - Image-PDF Converter Helper
    func createPDFDataFromImage(image: UIImage) -> NSMutableData {
        let pdfData = NSMutableData()
        let imgView = UIImageView.init(image: image)
        let imageRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        UIGraphicsBeginPDFContextToData(pdfData, imageRect, nil)
        UIGraphicsBeginPDFPage()
        let context = UIGraphicsGetCurrentContext()
        imgView.layer.render(in: context!)
        UIGraphicsEndPDFContext()
        
        //try saving in doc dir to confirm:
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
        let path = dir?.appendingPathComponent("imageTaken.pdf")
        
        print("👉 pdf path: \(String(describing: path))")
        
        
        do {
            try pdfData.write(to: path!, options: NSData.WritingOptions.atomic)
        } catch {
            print("❌ error saving image to disk!")
        }
        
        return pdfData
    }
    
    
    // MARK: - Image Picker Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        imagePicker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[.originalImage] as? UIImage else {
            print("❌ Image not found!")
            return
        }
        self.imageView.image = selectedImage
        convertImageButton.isEnabled = true
    }
    
    

}

