//
//  Account.swift
//  BuildkiteKit
//
//  Created by Matthew Delves on 13/09/2014.
//  Copyright (c) 2014 Matthew Delves. All rights reserved.
//

import Foundation

public struct Account {
  public var id: String
  public var url: String
  public var name: String
  public var projects_url: String
  public var agents_url: String
  public var created_at: String
  
  init(_ jsonObject: [String: AnyObject]) {
    self.id = jsonObject["id"] as String
    self.url = jsonObject["url"] as String
    self.name = jsonObject["name"] as String
    self.projects_url = jsonObject["projects_url"] as String
    self.agents_url = jsonObject["agents_url"] as String
    self.created_at = jsonObject["created_at"] as String
  }
}