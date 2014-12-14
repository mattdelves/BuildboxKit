//
//  Project.swift
//  BuildkiteKit
//
//  Created by Matthew Delves on 15/11/2014.
//  Copyright (c) 2014 Matthew Delves. All rights reserved.
//

import Foundation

public class Project {
  public var id: String
  public var url: String
  public var name: String
  public var repository: String
  public var builds_url: String
  public var created_at: String
  public var featured_build: Build
  public var builds: [Build]?
  
  init(_ jsonObject: [String: AnyObject]) {
    self.id = jsonObject["id"] as String
    self.url = jsonObject["url"] as String
    self.name = jsonObject["name"] as String
    self.repository = jsonObject["repository"] as String
    self.builds_url = jsonObject["builds_url"] as String
    self.created_at = jsonObject["created_at"] as String
    self.featured_build = Build(jsonObject["featured_build"] as [String: AnyObject])
    self.builds = [Build]()
  }
}