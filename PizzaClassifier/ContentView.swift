//
//  ContentView.swift
//  PizzaClassifier
//
//  Created by Edward Arenberg on 3/9/25.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
  @State private var selectedImage: UIImage?
  @State private var isImagePickerPresented = false
  @State private var classificationResult: String = ""
  
  var body: some View {
    VStack {
      if let selectedImage = selectedImage {
        Image(uiImage: selectedImage)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 300, height: 300)
          .padding()
      } else {
        Rectangle()
          .fill(Color.gray.opacity(0.5))
          .frame(width: 300, height: 300)
          .padding()
      }
      
      Button(action: {
        isImagePickerPresented = true
      }) {
        Text("Select Image")
          .padding()
          .background(Color.blue)
          .foregroundColor(.white)
          .cornerRadius(10)
      }
      .padding()
      
      Text(classificationResult)
        .font(.title)
        .padding()
    }
    .sheet(isPresented: $isImagePickerPresented) {
      ImagePicker(selectedImage: $selectedImage, classificationResult: $classificationResult)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
