//
//  Emoji.swift
//  BuildkiteKit
//
//  Created by Matthew Delves on 2/06/2015.
//  Copyright (c) 2015 Matthew Delves. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

public class Emoji: Object {
  public dynamic var name: String = ""
  public dynamic var url: String = ""

  public required init() {
    // do stuff
    super.init()
  }

  public override init(realm: RLMRealm, schema: RLMObjectSchema) {
    super.init(realm: realm, schema: schema)
  }

  public init(_ jsonObject: [String: AnyObject]) {
    super.init()

    if let name = jsonObject["name"] as? String {
      self.name = name
    }

    if let url = jsonObject["url"] as? String {
      self.url = url
    }
  }
}