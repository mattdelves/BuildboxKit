//
//  Emoji.swift
//  BuildkiteKit
//
//  Created by Matthew Delves on 2/06/2015.
//  Copyright (c) 2015 Matthew Delves. All rights reserved.
//

import Foundation

public struct Emoji {
  public var name: String
  public var url: String
  public var aliases: [String]?

  public init(_ jsonObject: [String: AnyObject]) {
    if let name = jsonObject["name"] as? String {
      self.name = name
    } else {
      self.name = ""
    }

    if let url = jsonObject["url"] as? String {
      self.url = url
    } else {
      self.url = ""
    }

    if let aliases = jsonObject["aliases"] as? [String] {
      self.aliases = aliases
    }
  }
}