//
//  CommentsViewModel.swift
//  Proyecto_final
//
//  Created by Daniel Cubillo on 8/3/21.
//

import Foundation

class CommentsViewModel: ObservableObject {
    
    @Published var r_users = [RandomUser]()
    
    @Published var quote = [Quote]()
    
    @Published var singlequote = ""
    
    
    func load_r_users() {
        let url = ( "https://randomapi.com/api/6de6abfedb24f889e0b5f675edc50deb?fmt=raw&sole")
        //print(url)
        guard let urlObj = URL(string: url) else {return }

        URLSession.shared.dataTask(with: urlObj) {(data, response, error) in
            guard let data = data else {return }

            do {
                let ruser = try JSONDecoder().decode([RandomUser].self, from: data)
                self.r_users=ruser
                print(self.r_users)
            } catch let jsonErr{
                print("Error serializing JSON: ", jsonErr)
            }
        }.resume()
    }
    
    func load_quote() {
        let url = ( "https://quotes.rest/qod.json")
        //print(url)
        guard let urlObj = URL(string: url) else {return }

        URLSession.shared.dataTask(with: urlObj) {(data, response, error) in
            guard let data = data else {return }

            do {
                let rquote = try JSONDecoder().decode(Quotesresponse.self, from: data)
                self.quote=rquote.contents.quotes
                self.singlequote=rquote.contents.quotes[0].quote
                print(self.singlequote)
            } catch let jsonErr{
                print("Error serializing JSON: ", jsonErr)
            }
        }.resume()
    }
}
