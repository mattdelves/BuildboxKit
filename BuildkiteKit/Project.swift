//
//  Project.swift
//  BuildkiteKit
//
//  Created by Matthew Delves on 15/11/2014.
//  Copyright (c) 2014 Matthew Delves. All rights reserved.
//

import Foundation

public struct Project {
  public var id: String = ""
  public var url: String = ""
  public var name: String = ""
  public var repository: String = ""
  public var builds_url: String = ""
  public var created_at: String = ""
  public var featured_build: Build? = nil
  public var builds: [Build]? = nil
  public var slug: String = ""
  
  public init(_ jsonObject: [String: AnyObject]) {
    if let id = jsonObject["id"] as? String {
      self.id = id
    }
    if let url = jsonObject["url"] as? String {
      self.url = url
    }
    if let name = jsonObject["name"] as? String {
      self.name = name
    }
    if let repository = jsonObject["repository"] as? String {
      self.repository = repository
    }
    if let builds_url = jsonObject["builds_url"] as? String {
      self.builds_url = builds_url
    }
    if let created_at = jsonObject["created_at"] as? String {
      self.created_at = created_at
    }
    if let featured_build = jsonObject["featured_build"] as? [String: AnyObject] {
      self.featured_build = Build(featured_build)
    }
    if let slug = jsonObject["slug"] as? String {
      self.slug = slug
    }
    self.builds = [Build]()
  }
}