//
//  BuildboxURL.swift
//  BuildboxKit
//
//  Created by Matthew Delves on 6/09/2014.
//  Copyright (c) 2014 Matthew Delves. All rights reserved.
//

import Foundation

public enum BuildboxURL {
  case Account(account:String)
  case Accounts
  case Project(account:String, project:String)
  case Projects(account:String)
  case Build(account:String, project:String, build:Int)
  case Builds(account:String, project:String)
  case AllBuilds
  case Agents(account:String)
  case User
}

public protocol Path {
  var host: String { get }
  var apiVersion: String { get }
  var path:String { get }
}

extension BuildboxURL:Path {
  public var apiVersion: String {
    return "v1"
  }
  public var host:String {
    return "api.buildbox.io"
  }
  public var path:String {
    switch self {
    case .Account(let account): return "/\(apiVersion)/accounts/\(account)"
    case .Accounts: return "/\(apiVersion)/accounts"
    case .Project(let account, let project): return "/\(apiVersion)/accounts/\(account)/projects/\(project)"
    case .Projects(let account): return "/\(apiVersion)/accounts/\(account)/projects"
    case .Build(let account, let project, let build): return "/\(apiVersion)/accounts/\(account)/projects/\(project)/builds/\(build)"
    case .Builds(let account, let project): return "/\(apiVersion)/accounts/\(account)/projects/\(project)/builds"
    case .AllBuilds: return "/\(apiVersion)/builds"
    case .Agents(let account): return "/\(apiVersion)/accounts/\(account)/agents"
    case .User: return "/\(apiVersion)/user"
      }
  }
}

public func buildboxEndpoint(route:BuildboxURL, apiKey:String, scheme:String = "https") -> NSURL {
  let components:NSURLComponents = NSURLComponents()
  components.scheme = scheme
  components.host = route.host
  components.path = "\(route.path)"
  components.query = "api_key=\(apiKey)"
  // computedURL.setQuery(route.apiKey)
  return components.URL!
}