//
//  Agent.swift
//  BuildboxKit
//
//  Created by Matthew Delves on 15/11/2014.
//  Copyright (c) 2014 Matthew Delves. All rights reserved.
//

import Foundation

public struct Agent {
  public var id: String
  public var url: String
  public var name: String
  public var connection_state: String
  public var ip_address: String
  public var access_token: String
  public var hostname: String
  public var creator: Dictionary<String, String>
  public var created_at: String
}