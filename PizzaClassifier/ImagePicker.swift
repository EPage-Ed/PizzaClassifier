//
//  ImagePicker.swift
//  PizzaClassifier
//
//  Created by Edward Arenberg on 3/9/25.
//

import SwiftUI
import UIKit
import CoreML
import Vision

struct ImagePicker: UIViewControllerRepresentable {
  @Binding var selectedImage: UIImage?
  @Binding var classificationResult: String
  
  class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var parent: ImagePicker
    
    init(parent: ImagePicker) {
      self.parent = parent
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
      if let uiImage = info[.originalImage] as? UIImage {
        parent.selectedImage = uiImage
        parent.classifyImage(uiImage)
      }
      picker.dismiss(animated: true)
    }
  }
  
  func makeCoordinator() -> Coordinator {
    Coordinator(parent: self)
  }
  
  func makeUIViewController(context: Context) -> UIImagePickerController {
    let picker = UIImagePickerController()
    picker.delegate = context.coordinator
    return picker
  }
  
  func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
  
  func classifyImage(_ image: UIImage) {
    guard let model = try? VNCoreMLModel(for: PizzaClassifier().model) else {
      classificationResult = "Failed to load model"
      return
    }
    
    let request = VNCoreMLRequest(model: model) { request, error in
      guard let results = request.results as? [VNClassificationObservation],
            let firstResult = results.first else {
        classificationResult = "Failed to classify image"
        return
      }
      
      if firstResult.identifier.lowercased() == "pizza" {
        classificationResult = "It's a pizza!"
      } else {
        classificationResult = "Not a pizza"
      }
    }
    
    guard let ciImage = CIImage(image: image) else {
      classificationResult = "Failed to convert image"
      return
    }
    
    let handler = VNImageRequestHandler(ciImage: ciImage)
    DispatchQueue.global(qos: .userInitiated).async {
      do {
        try handler.perform([request])
      } catch {
        classificationResult = "Failed to perform classification"
      }
    }
  }
}
