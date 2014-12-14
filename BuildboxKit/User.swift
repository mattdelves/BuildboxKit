//
//  User.swift
//  BuildkiteKit
//
//  Created by Matthew Delves on 15/11/2014.
//  Copyright (c) 2014 Matthew Delves. All rights reserved.
//

import Foundation

public class User {
  public var id : String
  public var name : String
  public var email : String
  public var created_at : String
  
  init(_ jsonObject: [String: AnyObject]) {
    self.id = jsonObject["id"] as String
    self.name = jsonObject["name"] as String
    self.email = jsonObject["email"] as String
    self.created_at = jsonObject["created_at"] as String
  }
}