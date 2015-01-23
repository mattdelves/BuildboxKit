//
//  AccessToken.swift
//  BuildkiteKit
//
//  Created by Matthew Delves on 14/01/2015.
//  Copyright (c) 2015 Matthew Delves. All rights reserved.
//

import Foundation

// "read_user","read_accounts","read_projects","read_builds","write_builds","read_build_logs","read_agents","write_agents"

public enum AccessScope {
  case ReadUser
  case ReadOrganizations
  case ReadProjects
  case ReadBuilds
  case WriteBuilds
  case ReadBuildLogs
  case ReadAgents
  case WriteAgents

  public var text:String {
    switch self {
    case ReadUser: return "read_user"
    case ReadOrganizations: return "read_organizations"
    case ReadProjects: return "read_projects"
    case ReadBuilds: return "read_builds"
    case WriteBuilds: return "write_builds"
    case ReadBuildLogs: return "read_build_logs"
    case ReadAgents: return "read_agents"
    case WriteAgents: return "write_agents"
    }
  }
}

public struct AccessToken {
  public var token : String
  public var type : String

  init(_ jsonObject: [String: AnyObject]) {
    self.token = jsonObject["access_token"] as String
    self.type  = jsonObject["type"] as String
  }
}