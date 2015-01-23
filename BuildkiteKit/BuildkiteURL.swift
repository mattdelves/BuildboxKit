//
//  BuildkiteURL.swift
//  BuildkiteKit
//
//  Created by Matthew Delves on 6/09/2014.
//  Copyright (c) 2014 Matthew Delves. All rights reserved.
//

import Foundation

public enum BuildkiteURL {
  case Organization(organization:String)
  case Organizations
  case Project(organization:String, project:String)
  case Projects(organization:String)
  case Build(organization:String, project:String, build:Int)
  case Builds(organization:String, project:String)
  case AllBuilds
  case Agents(organization:String)
  case AccessTokens
  case User
}

public protocol Path {
  var host: String { get }
  var apiVersion: String { get }
  var path:String { get }
}

extension BuildkiteURL:Path {
  public var apiVersion: String {
    return "v1"
  }
  public var host:String {
    return "api.buildkite.com"
  }
  public var path:String {
    switch self {
    case .Organization(let organization): return "/\(apiVersion)/organizations/\(organization)"
    case .Organizations: return "/\(apiVersion)/organizations"
    case .Project(let organization, let project): return "/\(apiVersion)/organizations/\(organization)/projects/\(project)"
    case .Projects(let organization): return "/\(apiVersion)/organizations/\(organization)/projects"
    case .Build(let organization, let project, let build): return "/\(apiVersion)/organizations/\(organization)/projects/\(project)/builds/\(build)"
    case .Builds(let organization, let project): return "/\(apiVersion)/organizations/\(organization)/projects/\(project)/builds"
    case .AllBuilds: return "/\(apiVersion)/builds"
    case .Agents(let organization): return "/\(apiVersion)/organizations/\(organization)/agents"
    case .AccessTokens: return "/\(apiVersion)/access_tokens"
    case .User: return "/\(apiVersion)/user"
      }
  }
}

public func buildkiteEndpoint(route:BuildkiteURL, apiKey:String, scheme:String = "https") -> NSURL {
  let components:NSURLComponents = NSURLComponents()
  components.scheme = scheme
  components.host = route.host
  components.path = "\(route.path)"
  switch route {
  case .AccessTokens:
    components.query = nil
  default:
    components.query = "api_key=\(apiKey)"
  }
  return components.URL!
}