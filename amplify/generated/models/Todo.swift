// swiftlint:disable all
import Amplify
import Foundation

public struct Todo: Model {
  public let id: String
  public var imagekey: String
  public var coment1: String?
  public var author1: String?
  public var coment2: String?
  public var author2: String?
  public var coment3: String?
  public var author3: String?
  public var likes: String?
  public var user: String?
  
  public init(id: String = UUID().uuidString,
      imagekey: String,
      coment1: String? = nil,
      author1: String? = nil,
      coment2: String? = nil,
      author2: String? = nil,
      coment3: String? = nil,
      author3: String? = nil,
      likes: String? = nil,
      user: String? = nil) {
      self.id = id
      self.imagekey = imagekey
      self.coment1 = coment1
      self.author1 = author1
      self.coment2 = coment2
      self.author2 = author2
      self.coment3 = coment3
      self.author3 = author3
      self.likes = likes
      self.user = user
  }
}