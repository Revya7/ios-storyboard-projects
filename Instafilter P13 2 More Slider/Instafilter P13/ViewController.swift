//
//  ViewController.swift
//  Instafilter P13
//
//  Created by Rev on 22/02/2022.
//

import UIKit
import CoreImage

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    @IBOutlet var slider: UISlider!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var radiusSilder: UISlider!
    
    var currentImage : UIImage!
    
    var context : CIContext!
    var currentFilter : CIFilter!
    var currentFilterName : String = "" {
        didSet {
            title = "Instafilter \(currentFilterName)"
        }
    }
    
    var filtersArr = ["CISepiaTone", "CIBumpDistortion", "CIGaussianBlur", "CIPixellate", "CITwirlDistortion", "CIUnsharpMask", "CIVignette"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importImage))
        title = "Instafilter"
        
        context = CIContext()
        currentFilter = CIFilter(name: filtersArr[0])
        currentFilterName = filtersArr[0]
        
    }
    
    @objc func importImage() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        dismiss(animated: true)
        currentImage = image
        
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        
        applyProcessing()
    }
    
    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys
        let intensityValue = slider.value
        let radiusValue = radiusSilder.value
        
        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(intensityValue, forKey: kCIInputIntensityKey)
        }
        
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(radiusValue * 200, forKey: kCIInputRadiusKey)
        }
        
        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(intensityValue * 10, forKey: kCIInputScaleKey)
        }
        
        if inputKeys.contains(kCIInputCenterKey) {
            let ciVector = CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2)
            currentFilter.setValue(ciVector, forKey: kCIInputCenterKey)
        }
        
        guard let outputImage = currentFilter.outputImage else { return }
        
        if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            let processedImage = UIImage(cgImage: cgImage)
            imageView.image = processedImage
        }
    }

    
    @IBAction func changeFilter(_ sender: UIButton) {
        let ac = UIAlertController(title: "Choose Filter", message: nil, preferredStyle: .actionSheet)
        for filterName in filtersArr {
            ac.addAction(UIAlertAction(title: filterName, style: .default, handler: setFilter))
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        if let popoverController = ac.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
        }
        
        present(ac, animated: true)
    }
    
    func setFilter(_ action : UIAlertAction) {
        guard let filterName = action.title else { return }
        currentFilter = CIFilter(name: filterName)
        currentFilterName = filterName
        
        guard currentImage != nil else { return }
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        
        applyProcessing()
    }
    
    @IBAction func saveClicked(_ sender: Any) {
        guard let image = imageView.image else { missingImageError(); return }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(imageCb(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @IBAction func sliderChanged(_ sender: Any) {
        applyProcessing()
    }
    
    @objc func imageCb(_ image : UIImage, didFinishSavingWithError error : Error?, contextInfo : UnsafeRawPointer) {
        let acTitle : String
        let acMsg : String?
        
        if let error = error {
            acTitle = "Error"
            acMsg = error.localizedDescription
        } else {
            acTitle = "Saved!"
            acMsg = nil
        }
        
        let ac = UIAlertController(title: acTitle, message: acMsg, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(ac, animated: true)
    }
    
    func missingImageError() {
        let ac = UIAlertController(title: nil, message: "Please select an image first!", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    @IBAction func radiusSliderChanged(_ sender: Any) {
        applyProcessing()
    }
}

