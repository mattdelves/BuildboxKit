//
//  Agent.swift
//  BuildkiteKit
//
//  Created by Matthew Delves on 15/11/2014.
//  Copyright (c) 2014 Matthew Delves. All rights reserved.
//

import Foundation

public enum AgentConnectionState {
  case Connected
  case NeverConnected
  case Disconnected
  case Unknown

  public var text:String {
    switch self {
    case .Connected: return "connected"
    case .NeverConnected: return "never connected"
    case .Disconnected: return "disconnected"
    case .Unknown: return "unknown"
    }
  }
}

public struct Agent {
  public var id: String = ""
  public var url: String = ""
  public var name: String = ""
  public var connection_state: AgentConnectionState = AgentConnectionState.Unknown
  public var access_token: String = ""
  public var hostname: String? = nil
  public var user_agent: String? = nil
  public var ip_address: String? = nil
  public var created_at: String = ""
  
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
    if let connection = jsonObject["connection_state"] as? String {
      self.connection_state = agentConnectionStatusFromString(connection)
    }
    if let access_token = jsonObject["access_token"] as? String {
      self.access_token = access_token
    }
    if let hostname = jsonObject["hostname"] as? String {
      self.hostname = hostname
    }
    if let user_agent = jsonObject["user_agent"] as? String {
      self.user_agent = user_agent
    }
    if let ip_address = jsonObject["ip_address"] as? String {
      self.ip_address = ip_address
    }
    if let created_at = jsonObject["created_at"] as? String {
      self.created_at = created_at
    }
  }
}

func agentConnectionStatusFromString(status: String) -> AgentConnectionState {
  switch status {
    case "connected": return .Connected
    case "disconnected": return .Disconnected
    case "never_connected": return .NeverConnected
    default: return .Unknown
  }
}