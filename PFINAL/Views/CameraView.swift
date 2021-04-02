//
//  CameraView.swift
//  PFINAL
//
//  Created by Daniel Cubillo on 2/4/21.
//

import SwiftUI
import Amplify

struct CameraView: View {
    
    @State var showImageSelector = false
    @State var image: UIImage?
    
    
    var body: some View {
        VStack {
            if let image = self.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            }
            Spacer()
            
            Button(action: photobutton, label: {
                let imageName = self.image == nil ? "camera.on.rectangle.fill" : "icloud.and.arrow.up.fill"
                Image(systemName: imageName)
                    .font(.largeTitle)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(Circle())
            })
            Spacer()
            
            if self.image != nil{
                Button(action: cancelbutton, label: {
                    Image(systemName: "xmark.icloud.fill")
                        .font(.largeTitle)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                })
                Spacer()
            }
            
            
        }
        .sheet(isPresented: $showImageSelector, content: {
            ImageSelector(image: $image)
        })
    }
    
    func photobutton() {
        if let image = self.image {
            // upload image
            upload(image)
            
        } else {
            showImageSelector.toggle()
        }
    }
    
    func cancelbutton(){
        self.image = nil
    }
    
    func upload(_ image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        let key = UUID().uuidString + ".jpg"
        
        _ = Amplify.Storage.uploadData(key: key, data: imageData) { result in
            switch result {
            case .success:
                print("Uploaded image")
                
                // Save image to a Post
                let post = Todo(imagekey: key)
                save(post)
                
            case .failure(let error):
                print("Failed to upload - \(error)")
            }
        }
    }
    
    func save(_ post: Todo) {
        Amplify.DataStore.save(post) { result in
            switch result {
            case .success:
                print("post saved")
                self.image = nil
                
            case .failure(let error):
                print("failed to save post - \(error)")
            }
        }
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}
