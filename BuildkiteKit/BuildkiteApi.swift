//
//  BuildkiteApi.swift
//  BuildkiteKit
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
  
  public func getOrganizations(completion: (organizations: [Organization], body: NSData?, error: BuildkiteApiError?) -> Void) {
    let url = buildkiteEndpoint(BuildkiteURL.Organizations, apiKey, scheme: scheme)
    
    ArrayOfJSONDataForEndpoint(url) { json, data, error in
      var organizations: [Organization] = [Organization]()
      
      if let error : BuildkiteApiError = error {
        completion(organizations: organizations, body: data, error: error)
      } else {
        for accountData:[String: AnyObject] in json! as [[String: AnyObject]]{
          organizations.append(Organization(accountData))
        }
        
        completion(organizations: organizations, body: data, error: nil)
      }
    }
  }
  
  public func getOrganization(name: String, completion: (organization: Organization?, body: NSData?, error: BuildkiteApiError?) -> Void) {
    let url = buildkiteEndpoint(BuildkiteURL.Organization(organization: name), apiKey, scheme: scheme)
    
    JSONDataForEndpoint(url) { json, data, error in
      var organization : Organization?
      
      if error == nil {
        organization = Organization(json! as [String: AnyObject])
      }
      
      completion(organization: organization, body: data, error: error)
    }
  }
  
  public func getProjects(account: String, completion: (projects: [Project], body: NSData?, error: BuildkiteApiError?) -> Void) {
    let url = buildkiteEndpoint(BuildkiteURL.Projects(organization: account), apiKey, scheme: scheme)
    ArrayOfJSONDataForEndpoint(url) { json, data, error in
      var projects: [Project] = [Project]()
      
      if let error : BuildkiteApiError = error {
        completion(projects: projects, body: data, error: error)
      } else {
        for projectData: [String: AnyObject] in json! as [[String: AnyObject]]{
          projects.append(Project(projectData))
        }
        
        completion(projects: projects, body: data, error: nil)
      }
    }
  }
  
  public func getProject(account: String, projectName: String, completion: (project: Project?, body: NSData?, error: BuildkiteApiError?) -> Void) {
    let url = buildkiteEndpoint(BuildkiteURL.Project(organization: account, project: projectName), apiKey, scheme: scheme)
    
    JSONDataForEndpoint(url) { json, data, error in
      var project : Project?
      
      if error == nil {
        project = Project(json! as [String: AnyObject])
      }
      
      completion(project: project, body: data, error: error)
    }
  }
  
  public func getBuilds(completion: (builds: [Build], body: NSData?, error: BuildkiteApiError?) -> Void) {
    let url = buildkiteEndpoint(BuildkiteURL.AllBuilds, apiKey, scheme: scheme)
    
    ArrayOfJSONDataForEndpoint(url) { jsonArray, data, error in
      var builds: [Build] = [Build]()

      if let error : BuildkiteApiError = error {
        completion(builds: builds, body: data, error: error)
      } else {
        for buildData : [String: AnyObject] in jsonArray! as [[String: AnyObject]] {
          builds.append(Build(buildData))
        }
        
        completion(builds: builds, body: data, error: nil)
      }
    }
  }
  
  public func getBuilds(account: String, projectName: String, completion: (builds: [Build], body: NSData?, error: BuildkiteApiError?) -> Void) {
    let url = buildkiteEndpoint(BuildkiteURL.Builds(organization: account, project: projectName), apiKey, scheme: scheme)
    
    ArrayOfJSONDataForEndpoint(url) { jsonArray, data, error in
      var builds: [Build] = [Build]()
      
      if let error : BuildkiteApiError = error {
        completion(builds: builds, body: data, error: error)
      } else {
        for buildData : [String: AnyObject] in jsonArray! as [[String: AnyObject]] {
          builds.append(Build(buildData))
        }
        
        completion(builds: builds, body: data, error: nil)
      }
    }
  }
  
  public func getBuild(account: String, projectName: String, number: Int, completion: (build: Build?, body: NSData?, error: BuildkiteApiError?) -> Void) {
    let url = buildkiteEndpoint(BuildkiteURL.Build(organization: account, project: projectName, build: number), apiKey, scheme: scheme)
    
    JSONDataForEndpoint(url) { json, data, error in
      var build : Build?
      
      if error == nil {
        build = Build(json! as [String: AnyObject])
      }
      
      completion(build: build, body: data, error: error)
    }
  }
  
  public func getAgents(account: String, completion: (agents: [Agent], body: NSData?, error: BuildkiteApiError?) -> Void) {
    let url = buildkiteEndpoint(BuildkiteURL.Agents(organization: account), apiKey, scheme: scheme)
    
    ArrayOfJSONDataForEndpoint(url) { jsonArray, data, error in
      var agents: [Agent] = [Agent]()
      
      if let error : BuildkiteApiError = error {
        completion(agents: agents, body: data, error: error)
      } else {
        for agentData: [String: AnyObject] in jsonArray! as [[String: AnyObject]] {
          agents.append(Agent(agentData))
        }
        
        completion(agents: agents, body: data, error: nil)
      }
    }
  }
  
  public func getAccessTokens(username: String, password: String, scopes: [String], client_id: String, completion: (token: AccessToken?, body: NSData?, error: BuildkiteApiError?) -> Void) {
    let details = [
      "client_id": client_id,
      "scopes": scopes
    ]
    let jsonDetails = NSJSONSerialization.dataWithJSONObject(details, options: .PrettyPrinted, error: nil)
    let url = buildkiteEndpoint(BuildkiteURL.AccessTokens, "", scheme: scheme)
    let request: NSMutableURLRequest = NSMutableURLRequest(URL: url)
    request.HTTPMethod = "POST"
    request.HTTPBody = jsonDetails

    let authStr = "\(username):\(password)"
    if let data = authStr.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: false) {
      let authData: NSData = data
      let encodedAuth = authData.base64EncodedStringWithOptions(nil)
      request.setValue("Basic \(encodedAuth)", forHTTPHeaderField: "Authorization")
    }

    JSONDataForRequest(request) { json, data, error in
      var token: AccessToken?

      if error == nil {
        token = AccessToken(json! as [String: AnyObject])
      }

      completion(token: token, body: data, error: error)
    }
  }

  public func getUser(completion: (user: User?, body: NSData?, error: BuildkiteApiError?) -> Void) {
    let url = buildkiteEndpoint(BuildkiteURL.User, apiKey, scheme: scheme)
    
    JSONDataForEndpoint(url) { json, data, error in
      var user : User?
      
      if error == nil {
        user = User(json! as [String: AnyObject])
      }
      
      completion(user: user, body: data, error: error)
    }
  }
  
  func ArrayOfJSONDataForEndpoint(url: NSURL, completion: ([[String: AnyObject]]?, NSData?, BuildkiteApiError?) -> Void) {
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
        
        completion(jsonArray, data, error)
      }
    }
    
    task.resume()
  }
  
  func JSONDataForRequest(request: NSURLRequest, completion: ([String: AnyObject]?, NSData?, BuildkiteApiError?) -> Void) {
    let task = session.dataTaskWithRequest(request) { data, response, error in
      if let theResponse: NSHTTPURLResponse = response as? NSHTTPURLResponse {
        let code = theResponse.statusCode
        var error: BuildkiteApiError?
        var nserror: NSError?
        var json: [String: AnyObject]? = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: &nserror) as [String: AnyObject]?

        if (code != 200) {
          if let json = json {
            error = BuildkiteApiError(code: code, reason: json["message"] as String)
          } else {
            error = BuildkiteApiError(code: code, reason: "unknown error")
          }
        }

        completion(json, data, error)
      }
    }

    task.resume()
  }

  func JSONDataForEndpoint(url: NSURL, completion: ([String: AnyObject]?, NSData?, BuildkiteApiError?) -> Void) {
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
        
        completion(json, data, error)
      }
    }
    
    task.resume()
  }

}