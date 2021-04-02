// swiftlint:disable all
import Amplify
import Foundation

extension Todo {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case imagekey
    case coment1
    case author1
    case coment2
    case author2
    case coment3
    case author3
    case likes
    case user
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let todo = Todo.keys
    
    model.pluralName = "Todos"
    
    model.fields(
      .id(),
      .field(todo.imagekey, is: .required, ofType: .string),
      .field(todo.coment1, is: .optional, ofType: .string),
      .field(todo.author1, is: .optional, ofType: .string),
      .field(todo.coment2, is: .optional, ofType: .string),
      .field(todo.author2, is: .optional, ofType: .string),
      .field(todo.coment3, is: .optional, ofType: .string),
      .field(todo.author3, is: .optional, ofType: .string),
      .field(todo.likes, is: .optional, ofType: .string),
      .field(todo.user, is: .optional, ofType: .string)
    )
    }
}