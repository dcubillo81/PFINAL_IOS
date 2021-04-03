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
    @State var uploading = false
    @ObservedObject var commentsVM = CommentsViewModel()
    @AppStorage("username") var userlogged=""
    
    
    var body: some View {
        VStack {
            if let image = self.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            }
            Spacer()
            
            if uploading == false {
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
            }else{
                ProgressView("Guardando…")
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
            commentsVM.load_quote() //carga API comentario random
            commentsVM.load_r_users() //carga API usuarios random
            showImageSelector.toggle()
        }
    }//photobutton
    
    func cancelbutton(){
        self.image = nil
    }//cancelbutton
    
    func upload(_ image: UIImage) {
        
        self.uploading = true
        
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        let key = UUID().uuidString + ".jpg"
        
        _ = Amplify.Storage.uploadData(key: key, data: imageData) { result in
            switch result {
            case .success:
                print("Uploaded image")
                
                let number = Int.random(in: 0..<1000)
                // Save image to a Post
                let post = Todo(imagekey: key, coment1: commentsVM.singlequote, author1: commentsVM.r_users[0].first, coment2: commentsVM.singlequote, author2: commentsVM.r_users[1].first, coment3: commentsVM.singlequote, author3: commentsVM.r_users[2].first, likes: "\(number)",user:userlogged)
                save(post)
                
            case .failure(let error):
                print("Failed to upload - \(error)")
            }
        }
    }//upload image
    
    func save(_ post: Todo) {
        Amplify.DataStore.save(post) { result in
            switch result {
            case .success:
                print("post saved")
                self.image = nil
                self.uploading=false
                
            case .failure(let error):
                print("failed to save post - \(error)")
                self.uploading=false
            }
        }
    }//save database
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}
