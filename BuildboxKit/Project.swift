//
//  Project.swift
//  BuildboxKit
//
//  Created by Matthew Delves on 15/11/2014.
//  Copyright (c) 2014 Matthew Delves. All rights reserved.
//

import Foundation

public struct Project {
  public var id: String
  public var url: String
  public var name: String
  public var repository: String
  public var builds_url: String
  public var created_at: String
  public var builds: [Build]?
}