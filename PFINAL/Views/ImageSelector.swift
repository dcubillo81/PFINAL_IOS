//
//  ImagePicker.swift
//  PFINAL
//
//  Created by Daniel Cubillo on 2/4/21.
//

import Foundation
import SwiftUI

struct ImageSelector: UIViewControllerRepresentable {
    
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    typealias UIViewControllerType = UIImagePickerController
    
    func makeCoordinator() -> ImagePickerCoordinator {
        ImagePickerCoordinator(imagePicker: self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let controller = UIImagePickerController()
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}

class ImagePickerCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    let imagePicker: ImageSelector
    
    init(imagePicker: ImageSelector) {
        self.imagePicker = imagePicker
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.presentationMode.wrappedValue.dismiss()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.presentationMode.wrappedValue.dismiss()
        
        guard let image = info[.originalImage] as? UIImage else { return }
        imagePicker.image = image
    }
}
