//
//  GaleryView.swift
//  PFINAL
//
//  Created by Daniel Cubillo on 2/4/21.
//

import SwiftUI
import Amplify
import Combine

struct MyPhotosView: View {
    @State var imageCache = [String: UIImage?]()
    
    var body: some View {
        List(imageCache.sorted(by: { $0.key > $1.key }), id: \.key) { key, image in
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            }
        }
        .onAppear {
            getPosts()
            observePosts()
        }
    }
    
    func getPosts() {
        Amplify.DataStore.query(Todo.self) { result in
            switch result {
            case .success(let posts):
                print(posts)
                
                // download images
                downloadImages(for: posts)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func downloadImages(for posts: [Todo]) {
        for post in posts {
            
            _ = Amplify.Storage.downloadData(key: post.imagekey) { result in
                switch result {
                case .success(let imageData):
                    let image = UIImage(data: imageData)
                    
                    DispatchQueue.main.async {
                        imageCache[post.imagekey] = image
                    }
                    
                case .failure(let error):
                    print("Failed to download image data - \(error)")
                }
            }
            
        }
    }
    
    @State var token: AnyCancellable?
    func observePosts() {
        token = Amplify.DataStore.publisher(for: Todo.self).sink(
            receiveCompletion: { print($0) },
            receiveValue: { event in
                do {
                    let post = try event.decodeModel(as: Todo.self)
                    downloadImages(for: [post])
                    
                } catch {
                    print(error)
                }
            }
        )
    }
    
}

struct GaleryView_Previews: PreviewProvider {
    static var previews: some View {
        MyPhotosView()
    }
}
