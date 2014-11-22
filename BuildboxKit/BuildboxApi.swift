//
//  BuildboxApi.swift
//  BuildboxKit
//
//  Created by Matthew Delves on 6/09/2014.
//  Copyright (c) 2014 Matthew Delves. All rights reserved.
//

import Foundation

public struct BuildboxApiError {
  public var code : Int
  public var reason : String
}

public class BuildboxApi {
  public var apiKey: String
  public var scheme: String
  var session: NSURLSession
  
  public init (_ apiKey: String, scheme: String = "https", configuration: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()) {
    self.apiKey = apiKey
    self.scheme = scheme

    self.session = NSURLSession(configuration: configuration)
  }
  
  public func getAccounts(completion: (accounts: [Account], error: BuildboxApiError?) -> Void) {
    let url = buildboxEndpoint(BuildboxURL.Accounts, apiKey, scheme: scheme)
    
    ArrayOfJSONDataForEndpoint(url) { json, error in
      var accounts: [Account] = [Account]()
      
      if let error : BuildboxApiError = error {
        completion(accounts: accounts, error: error)
      } else {
        for accountData:NSDictionary in json! {
          accounts.append(Account(accountData))
        }
        
        completion(accounts: accounts, error: nil)
      }
    }
  }
  
  public func getAccount(name: String, completion: (account: Account?, error: BuildboxApiError?) -> Void) {
    let url = buildboxEndpoint(BuildboxURL.Account(account: name), apiKey, scheme: scheme)
    
    JSONDataForEndpoint(url) { json, error in
      var account : Account?
      
      if error == nil {
        account = Account(json!)
      }
      
      completion(account: account, error: error)
    }
  }
  
  public func getProjects(account: String, completion: (projects: [Project], error: BuildboxApiError?) -> Void) {
    let url = buildboxEndpoint(BuildboxURL.Projects(account: account), apiKey, scheme: scheme)
    ArrayOfJSONDataForEndpoint(url) { json, error in
      var projects: [Project] = [Project]()
      
      if let error : BuildboxApiError = error {
        completion(projects: projects, error: error)
      } else {
        for projectData: NSDictionary in json! {
          projects.append(Project(projectData))
        }
        
        completion(projects: projects, error: nil)
      }
    }
  }
  
  public func getProject(account: String, projectName: String, completion: (project: Project?, error: BuildboxApiError?) -> Void) {
    let url = buildboxEndpoint(BuildboxURL.Project(account: account, project: projectName), apiKey, scheme: scheme)
    
    JSONDataForEndpoint(url) { json, error in
      var project : Project?
      
      if error == nil {
        project = Project(json!)
      }
      
      completion(project: project, error: error)
    }
  }
  
  public func getBuilds(completion: (builds: [Build], error: BuildboxApiError?) -> Void) {
    let url = buildboxEndpoint(BuildboxURL.AllBuilds, apiKey, scheme: scheme)
    
    ArrayOfJSONDataForEndpoint(url) { jsonArray, error in
      var builds: [Build] = [Build]()

      if let error : BuildboxApiError = error {
        completion(builds: builds, error: error)
      } else {
        for buildData : NSDictionary in jsonArray! {
          builds.append(Build(buildData))
        }
        
        completion(builds: builds, error: nil)
      }
    }
  }
  
  public func getBuilds(account: String, projectName: String, completion: (builds: [Build], error: BuildboxApiError?) -> Void) {
    let url = buildboxEndpoint(BuildboxURL.Builds(account: account, project: projectName), apiKey, scheme: scheme)
    
    ArrayOfJSONDataForEndpoint(url) { jsonArray, error in
      var builds: [Build] = [Build]()
      
      if let error : BuildboxApiError = error {
        completion(builds: builds, error: error)
      } else {
        for buildData : NSDictionary in jsonArray! {
          builds.append(Build(buildData))
        }
        
        completion(builds: builds, error: nil)
      }
    }
  }
  
  public func getBuild(account: String, projectName: String, number: Int, completion: (build: Build?, error: BuildboxApiError?) -> Void) {
    let url = buildboxEndpoint(BuildboxURL.Build(account: account, project: projectName, build: number), apiKey, scheme: scheme)
    
    JSONDataForEndpoint(url) { json, error in
      var build : Build?
      
      if error == nil {
        build = Build(json!)
      }
      
      completion(build: build, error: error)
    }
  }
  
  public func getAgents(account: String, completion: (agents: [Agent], error: BuildboxApiError?) -> Void) {
    let url = buildboxEndpoint(BuildboxURL.Agents(account: account), apiKey, scheme: scheme)
    
    ArrayOfJSONDataForEndpoint(url) { jsonArray, error in
      var agents: [Agent] = [Agent]()
      
      if let error : BuildboxApiError = error {
        completion(agents: agents, error: error)
      } else {
        for agentData: NSDictionary in jsonArray! {
          agents.append(Agent(agentData))
        }
        
        completion(agents: agents, error: nil)
      }
    }
  }
  
  public func getUser(completion: (user: User?, error: BuildboxApiError?) -> Void) {
    let url = buildboxEndpoint(BuildboxURL.User, apiKey, scheme: scheme)
    
    JSONDataForEndpoint(url) { json, error in
      var user : User?
      
      if error == nil {
        user = User(json!)
      }
      
      completion(user: user, error: error)
    }
  }
  
  func ArrayOfJSONDataForEndpoint(url: NSURL, completion: ([NSDictionary]?, BuildboxApiError?) -> Void) {
    let task = session.dataTaskWithURL(url) { data, response, error in
      if let theResponse : NSHTTPURLResponse = response as? NSHTTPURLResponse {
        let code = theResponse.statusCode
        var error : BuildboxApiError?
        var nserror: NSError?
        var jsonArray: [NSDictionary]?
        
        if(code != 200) {
          var body : NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &nserror) as NSDictionary
          error = BuildboxApiError(code: code, reason: body["message"] as String)
        } else {
          // Need to be able to distinguish between array and dict returns
          jsonArray = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &nserror) as [NSDictionary]?
          
        }
        
        completion(jsonArray, error)
      }
    }
    
    task.resume()
  }
  
  func JSONDataForEndpoint(url: NSURL, completion: (NSDictionary?, BuildboxApiError?) -> Void) {
    let task = session.dataTaskWithURL(url) { data, response, error in
      if let theResponse : NSHTTPURLResponse = response as? NSHTTPURLResponse {
        let code = theResponse.statusCode
        var error : BuildboxApiError?
        var nserror : NSError?
        var json : NSDictionary?
        if(code != 200) {
          var body : NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &nserror) as NSDictionary
          error = BuildboxApiError(code: code, reason: body["message"] as String)
        } else {
          // Need to be able to distinguish between array and dict returns
          json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &nserror) as NSDictionary?
        }
        
        completion(json, error)
      }
    }
    
    task.resume()
  }

}