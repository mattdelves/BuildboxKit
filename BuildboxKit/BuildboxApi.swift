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
          accounts.append(self.extractAccount(accountData))
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
        account = self.extractAccount(json!)
      }
      
      completion(account: account, error: error)
    }
  }
  
  func extractAccount(jsonObject: NSDictionary) -> Account {
    return Account(
      id: jsonObject["id"] as String,
      url: jsonObject["url"] as String,
      name: jsonObject["name"] as String,
      projects_url: jsonObject["projects_url"] as String,
      agents_url: jsonObject["agents_url"] as String,
      users_url: jsonObject["users_url"] as String,
      created_at: jsonObject["created_at"] as String)
  }
  
  public func getProjects(account: String, completion: (projects: [Project], error: BuildboxApiError?) -> Void) {
    let url = buildboxEndpoint(BuildboxURL.Projects(account: account), apiKey, scheme: scheme)
    ArrayOfJSONDataForEndpoint(url) { json, error in
      var projects: [Project] = [Project]()
      
      if let error : BuildboxApiError = error {
        completion(projects: projects, error: error)
      } else {
        for projectData: NSDictionary in json! {
          projects.append(self.extractProject(projectData))
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
        project = self.extractProject(json!)
      }
      
      completion(project: project, error: error)
    }
  }
  
  func extractProject(jsonObject: NSDictionary) -> Project {
    return Project(
      id: jsonObject["id"] as String,
      url: jsonObject["url"] as String,
      name: jsonObject["name"] as String,
      repository: jsonObject["repository"] as String,
      builds_url: jsonObject["builds_url"] as String,
      created_at: jsonObject["created_at"] as String,
      builds: [Build]()
    )
  }
  
  public func getBuilds(completion: (builds: [Build], error: BuildboxApiError?) -> Void) {
    let url = buildboxEndpoint(BuildboxURL.AllBuilds, apiKey, scheme: scheme)
    
    ArrayOfJSONDataForEndpoint(url) { jsonArray, error in
      var builds: [Build] = [Build]()

      if let error : BuildboxApiError = error {
        completion(builds: builds, error: error)
      } else {
        for buildData : NSDictionary in jsonArray! {
          let build = self.extractBuild(buildData)
          builds.append(build)
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
          let build = self.extractBuild(buildData)
          builds.append(build)
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
        build = self.extractBuild(json!)
      }
      
      completion(build: build, error: error)
    }
  }
  
  func extractBuild(jsonObject: NSDictionary) -> Build {
    var started_at = ""
    if let started_at_value : String = jsonObject["started_at"] as? String {
      started_at = started_at_value
    }
    
    var finished_at = ""
    if let finished_at_value : String = jsonObject["finished_at"] as? String {
      finished_at = finished_at_value
    }
    
    return Build(
      id: jsonObject["id"] as String,
      url: jsonObject["url"] as String,
      number: jsonObject["number"] as Int,
      branch: jsonObject["branch"] as String,
      state: jsonObject["state"] as String,
      message: jsonObject["message"] as String,
      commit: jsonObject["commit"] as String,
      env: jsonObject["env"] as NSDictionary,
      jobs: jsonObject["jobs"] as [NSDictionary],
      created_at: jsonObject["created_at"] as String,
      scheduled_at: jsonObject["scheduled_at"] as String,
      started_at: started_at,
      finished_at: finished_at,
      meta_data: jsonObject["meta_data"] as NSDictionary,
      project: jsonObject["project"] as Dictionary<String, String>
    )
  }
  
  public func getAgents(account: String, completion: (agents: [Agent], error: BuildboxApiError?) -> Void) {
    let url = buildboxEndpoint(BuildboxURL.Agents(account: account), apiKey, scheme: scheme)
    
    ArrayOfJSONDataForEndpoint(url) { jsonArray, error in
      var agents: [Agent] = [Agent]()
      
      if let error : BuildboxApiError = error {
        completion(agents: agents, error: error)
      } else {
        for agentData: NSDictionary in jsonArray! {
          agents.append(self.extractAgent(agentData))
        }
        
        completion(agents: agents, error: nil)
      }
    }
  }
  
  func extractAgent(jsonData: NSDictionary) -> Agent {
    return Agent(
      id: jsonData["id"] as String,
      url: jsonData["url"] as String,
      name: jsonData["name"] as String,
      connection_state: jsonData["connection_state"] as String,
      ip_address: jsonData["ip_address"] as String,
      access_token: jsonData["access_token"] as String,
      hostname: jsonData["hostname"] as String,
      creator: jsonData["creator"] as Dictionary<String, String>,
      created_at: jsonData["created_at"] as String
    )
  }
  
  public func getUser(completion: (user: User?, error: BuildboxApiError?) -> Void) {
    let url = buildboxEndpoint(BuildboxURL.User, apiKey, scheme: scheme)
    
    JSONDataForEndpoint(url) { json, error in
      var user : User?
      
      if error == nil {
        user = self.extractUser(json!)
      }
      
      completion(user: user, error: error)
    }
  }
  
  func extractUser(jsonData: NSDictionary) -> User {
    return User(
      id: jsonData["id"] as String,
      name: jsonData["name"] as String,
      email: jsonData["email"] as String,
      created_at: jsonData["created_at"] as String
    )
  }
  
  func ArrayOfJSONDataForEndpoint(url: NSURL, completion: ([NSDictionary]?, BuildboxApiError?) -> Void) {
    let task = session.dataTaskWithURL(url) { data, response, error in
      if let theResponse : NSHTTPURLResponse = response as? NSHTTPURLResponse {
        let code = theResponse.statusCode
        var error : BuildboxApiError?
        var nserror: NSError?
        var jsonArray: [NSDictionary]?
        
        if(code != 200) {
          println("I didn't get a valid response back. Instead I got \(code)")
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
          println("I didn't get a valid response back. Instead I got \(code)")
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