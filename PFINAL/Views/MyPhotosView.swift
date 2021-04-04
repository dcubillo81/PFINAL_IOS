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
    let line: Todo
}


struct MyPhotosView: View {
    @State var imageCache = [String: UIImage?]()
    @State var UserList = [UserReseults]()
    @State var prevpost = [Todo]()
    @State var downloading = false
    @AppStorage("username") var userlogged=""
    
    var body: some View {
        
        VStack{
//            List(imageCache.sorted(by: { $0.key > $1.key }), id:\.key) { key, image in
//                if let image = image {
//                    Image(uiImage: image)
//                        .resizable()
//                        .scaledToFit()
//                }
            List {
                ForEach(UserList.sorted(by: { $0.imagekey > $1.imagekey }), id:\.id) {item in
                    VStack{
                        Image(uiImage: imageCache[item.imagekey]!!)
                            .resizable()
                            .scaledToFit()
                            //.frame(height: 300)
                        HStack{
                            Image(systemName: "heart.fill")
                                .font(.title2)
                                .foregroundColor(.red)
                            Text(item.like)
                        }.padding(.trailing, UIScreen.main.bounds.width - 120)
                        VStack{
                            Text(item.com1)
                                .font(.body)
                                .foregroundColor(.gray)
                            HStack{
                                Text("From: ")
                                    .font(.body)
                                    .foregroundColor(.gray)
                                Text(item.aut1)
                                    .font(.body)
                                    .foregroundColor(.gray)
                            }
                        }.padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                        
                        Button {
                            delete(imagekey: item.imagekey, database: item.line)
                                } label: {
                                    Text("delete")
                                }
                        
                    }.background(Color.blue.opacity(0.12))
                     .border(Color.blue.opacity(0.3))
                }
            }.onAppear {
                UserList = [UserReseults]()
                getPosts()
                //observePosts()
                
            }
            if downloading==true{
                ProgressView("Cargando…")
            }
        }//Vstack
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
        
        
        for post in posts {
            if post.user==userlogged {
            _ = Amplify.Storage.downloadData(key: post.imagekey) { result in
                switch result {
                case .success(let imageData):
                    let image = UIImage(data: imageData)
                    downloading=true
                    DispatchQueue.main.async {
                        imageCache[post.imagekey] = image
                        let append = UserReseults(id: post.id, imagekey: post.imagekey, com1: post.coment1 ?? "", aut1: post.author1 ?? "", like: post.likes ?? "", line: post)
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
    
    func delete(imagekey: String, database:Todo){
        
        print("Inicio Delete")
        Amplify.DataStore.delete(database) {
            switch $0 {
            case .success:
                print("Post deleted!")
            case .failure(let error):
                print("Error deleting post - \(error.localizedDescription)")
            }
        }
        
        Amplify.Storage.remove(key: imagekey) { event in
            switch event {
            case let .success(data):
                print("Completed: Deleted \(data)")
            case let .failure(storageError):
                print("Failed: \(storageError.errorDescription). \(storageError.recoverySuggestion)")
            }
        }
        
        UserList = [UserReseults]()
        getPosts()
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
