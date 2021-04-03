//
//  GaleryView.swift
//  PFINAL
//
//  Created by Daniel Cubillo on 2/4/21.
//

import SwiftUI
import Amplify
import Combine

struct UserReseults: Identifiable {
    let id : String
    let imagekey: String
    let com1: String
    let aut1: String
//    let com2: String
//    let aut2: String
//    let com3: String
//    let aut3: String
    let like: String
}


struct MyPhotosView: View {
    @State var imageCache = [String: UIImage?]()
    @State var UserList = [UserReseults]()
    @State var downloading = false
    @AppStorage("username") var userlogged=""
    
    var body: some View {
        
        VStack{
        List(imageCache.sorted(by: { $0.key > $1.key }), id:\.key) { key, image in
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            }
        }.onAppear {getPosts()
                observePosts()
        }
        if downloading==true{
            ProgressView("Cargando…")
        }
        }
    }
    
    func getPosts() {
        Amplify.DataStore.query(Todo.self) { result in
            switch result {
            case .success(let posts):
                // download images
                downloadImages(for: posts)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func downloadImages(for posts: [Todo]) {
        downloading=true
        
        for post in posts {
            if post.user==userlogged {
            _ = Amplify.Storage.downloadData(key: post.imagekey) { result in
                switch result {
                case .success(let imageData):
                    let image = UIImage(data: imageData)
                    
                    DispatchQueue.main.async {
                        imageCache[post.imagekey] = image
                        let append = UserReseults(id: post.id, imagekey: post.imagekey, com1: post.coment1 ?? "", aut1: post.author1 ?? "", like: post.likes ?? "")
                        UserList.append(append)
                        print("UseList")
                        print(UserList)
                        print("End userlist")
                        downloading=false
                    }
                    
                case .failure(let error):
                    print("Failed to download image data - \(error)")
                    downloading=false
                }
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
