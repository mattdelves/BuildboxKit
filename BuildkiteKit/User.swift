//
//  User.swift
//  BuildkiteKit
//
//  Created by Matthew Delves on 15/11/2014.
//  Copyright (c) 2014 Matthew Delves. All rights reserved.
//

import Foundation

public struct User {
  public var id : String = ""
  public var name : String = ""
  public var email : String = ""
  public var created_at : String = ""
  
  public init(_ jsonObject: [String: AnyObject]) {
    if let id = jsonObject["id"] as? String {
      self.id = id
    }
    if let name = jsonObject["name"] as? String {
      self.name = name
    }
    if let email = jsonObject["email"] as? String {
      self.email = email
    }
    if let created_at = jsonObject["created_at"] as? String {
      self.created_at = created_at
    }
  }
}