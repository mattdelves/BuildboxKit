//
//  BuildboxURL.swift
//  BuildboxKit
//
//  Created by Matthew Delves on 6/09/2014.
//  Copyright (c) 2014 Matthew Delves. All rights reserved.
//

import Foundation

public enum BuildboxURL {
  case Account(username:String)
  case Accounts
  case Project(username:String, project:String)
  case Projects(username:String)
  case Build(username:String, project:String, build:Int)
  case Builds(username:String, project:String)
  case Agents(username:String)
}

public protocol Path {
  var baseURL: NSURL { get }
  var apiVersion: String { get }
  var path:String { get }
}

extension BuildboxURL:Path {
  public var apiVersion: String {
    return "v1"
  }
  public var baseURL:NSURL {
    return NSURL(string: "api.buildbox.io")
  }
  public var path:String {
    switch self {
    case .Account(let username): return "/\(apiVersion)/accounts/\(username)"
    case .Accounts: return "/\(apiVersion)/accounts"
    case .Project(let username, let project): return "/\(apiVersion)/accounts/\(username)/projects/\(project)"
    case .Projects(let username): return "/\(apiVersion)/accounts/\(username)/projects"
    case .Build(let username, let project, let build): return "/\(apiVersion)/accounts/\(username)/projects/\(project)/builds/\(build)"
    case .Builds(let username, let project): return "/\(apiVersion)/accounts/\(username)/projects/\(project)/builds"
    case .Agents(let username): return "/\(apiVersion)/accounts/\(username)/agents"
      }
  }
}

public func buildboxEndpoint(route:BuildboxURL) -> NSURL {
  var computedURL:NSURL = route.baseURL.URLByAppendingPathComponent(route.path)
  // computedURL.setQuery(route.apiKey)
  return computedURL
}