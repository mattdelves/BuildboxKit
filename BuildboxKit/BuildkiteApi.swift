//
//  BuildkiteApi.swift
//  BuildboxKit
//
//  Created by Matthew Delves on 6/09/2014.
//  Copyright (c) 2014 Matthew Delves. All rights reserved.
//

import Foundation

public struct BuildkiteApiError {
  public var code : Int
  public var reason : String
}

public class BuildkiteApi {
  public var apiKey: String
  public var scheme: String
  var session: NSURLSession
  
  public init (_ apiKey: String, scheme: String = "https", configuration: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()) {
    self.apiKey = apiKey
    self.scheme = scheme

    self.session = NSURLSession(configuration: configuration)
  }
  
  public func getAccounts(completion: (accounts: [Account], error: BuildkiteApiError?) -> Void) {
    let url = buildkiteEndpoint(BuildkiteURL.Accounts, apiKey, scheme: scheme)
    
    ArrayOfJSONDataForEndpoint(url) { json, error in
      var accounts: [Account] = [Account]()
      
      if let error : BuildkiteApiError = error {
        completion(accounts: accounts, error: error)
      } else {
        for accountData:[String: AnyObject] in json! as [[String: AnyObject]]{
          accounts.append(Account(accountData))
        }
        
        completion(accounts: accounts, error: nil)
      }
    }
  }
  
  public func getAccount(name: String, completion: (account: Account?, error: BuildkiteApiError?) -> Void) {
    let url = buildkiteEndpoint(BuildkiteURL.Account(account: name), apiKey, scheme: scheme)
    
    JSONDataForEndpoint(url) { json, error in
      var account : Account?
      
      if error == nil {
        account = Account(json! as [String: AnyObject])
      }
      
      completion(account: account, error: error)
    }
  }
  
  public func getProjects(account: String, completion: (projects: [Project], error: BuildkiteApiError?) -> Void) {
    let url = buildkiteEndpoint(BuildkiteURL.Projects(account: account), apiKey, scheme: scheme)
    ArrayOfJSONDataForEndpoint(url) { json, error in
      var projects: [Project] = [Project]()
      
      if let error : BuildkiteApiError = error {
        completion(projects: projects, error: error)
      } else {
        for projectData: [String: AnyObject] in json! as [[String: AnyObject]]{
          projects.append(Project(projectData))
        }
        
        completion(projects: projects, error: nil)
      }
    }
  }
  
  public func getProject(account: String, projectName: String, completion: (project: Project?, error: BuildkiteApiError?) -> Void) {
    let url = buildkiteEndpoint(BuildkiteURL.Project(account: account, project: projectName), apiKey, scheme: scheme)
    
    JSONDataForEndpoint(url) { json, error in
      var project : Project?
      
      if error == nil {
        project = Project(json! as [String: AnyObject])
      }
      
      completion(project: project, error: error)
    }
  }
  
  public func getBuilds(completion: (builds: [Build], error: BuildkiteApiError?) -> Void) {
    let url = buildkiteEndpoint(BuildkiteURL.AllBuilds, apiKey, scheme: scheme)
    
    ArrayOfJSONDataForEndpoint(url) { jsonArray, error in
      var builds: [Build] = [Build]()

      if let error : BuildkiteApiError = error {
        completion(builds: builds, error: error)
      } else {
        for buildData : [String: AnyObject] in jsonArray! as [[String: AnyObject]] {
          builds.append(Build(buildData))
        }
        
        completion(builds: builds, error: nil)
      }
    }
  }
  
  public func getBuilds(account: String, projectName: String, completion: (builds: [Build], error: BuildkiteApiError?) -> Void) {
    let url = buildkiteEndpoint(BuildkiteURL.Builds(account: account, project: projectName), apiKey, scheme: scheme)
    
    ArrayOfJSONDataForEndpoint(url) { jsonArray, error in
      var builds: [Build] = [Build]()
      
      if let error : BuildkiteApiError = error {
        completion(builds: builds, error: error)
      } else {
        for buildData : [String: AnyObject] in jsonArray! as [[String: AnyObject]] {
          builds.append(Build(buildData))
        }
        
        completion(builds: builds, error: nil)
      }
    }
  }
  
  public func getBuild(account: String, projectName: String, number: Int, completion: (build: Build?, error: BuildkiteApiError?) -> Void) {
    let url = buildkiteEndpoint(BuildkiteURL.Build(account: account, project: projectName, build: number), apiKey, scheme: scheme)
    
    JSONDataForEndpoint(url) { json, error in
      var build : Build?
      
      if error == nil {
        build = Build(json! as [String: AnyObject])
      }
      
      completion(build: build, error: error)
    }
  }
  
  public func getAgents(account: String, completion: (agents: [Agent], error: BuildkiteApiError?) -> Void) {
    let url = buildkiteEndpoint(BuildkiteURL.Agents(account: account), apiKey, scheme: scheme)
    
    ArrayOfJSONDataForEndpoint(url) { jsonArray, error in
      var agents: [Agent] = [Agent]()
      
      if let error : BuildkiteApiError = error {
        completion(agents: agents, error: error)
      } else {
        for agentData: [String: AnyObject] in jsonArray! as [[String: AnyObject]] {
          agents.append(Agent(agentData))
        }
        
        completion(agents: agents, error: nil)
      }
    }
  }
  
  public func getUser(completion: (user: User?, error: BuildkiteApiError?) -> Void) {
    let url = buildkiteEndpoint(BuildkiteURL.User, apiKey, scheme: scheme)
    
    JSONDataForEndpoint(url) { json, error in
      var user : User?
      
      if error == nil {
        user = User(json! as [String: AnyObject])
      }
      
      completion(user: user, error: error)
    }
  }
  
  func ArrayOfJSONDataForEndpoint(url: NSURL, completion: ([NSDictionary]?, BuildkiteApiError?) -> Void) {
    let task = session.dataTaskWithURL(url) { data, response, error in
      if let theResponse : NSHTTPURLResponse = response as? NSHTTPURLResponse {
        let code = theResponse.statusCode
        var error : BuildkiteApiError?
        var nserror: NSError?
        var jsonArray: [[String: AnyObject]]?
        
        if(code != 200) {
          var body : [String: AnyObject] = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &nserror) as [String: AnyObject]
          error = BuildkiteApiError(code: code, reason: body["message"] as String)
        } else {
          // Need to be able to distinguish between array and dict returns
          jsonArray = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &nserror) as [[String: AnyObject]]?
          
        }
        
        completion(jsonArray, error)
      }
    }
    
    task.resume()
  }
  
  func JSONDataForEndpoint(url: NSURL, completion: (NSDictionary?, BuildkiteApiError?) -> Void) {
    let task = session.dataTaskWithURL(url) { data, response, error in
      if let theResponse : NSHTTPURLResponse = response as? NSHTTPURLResponse {
        let code = theResponse.statusCode
        var error : BuildkiteApiError?
        var nserror : NSError?
        var json : [String: AnyObject]?
        if(code != 200) {
          var body : [String: AnyObject] = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &nserror) as [String: AnyObject]
          error = BuildkiteApiError(code: code, reason: body["message"] as String)
        } else {
          // Need to be able to distinguish between array and dict returns
          json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &nserror) as [String: AnyObject]?
        }
        
        completion(json, error)
      }
    }
    
    task.resume()
  }

}