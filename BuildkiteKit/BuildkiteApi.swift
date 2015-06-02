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
  public var session: NSURLSession
  
  public init (_ apiKey: String, scheme: String = "https", configuration: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()) {
    self.apiKey = apiKey
    self.scheme = scheme
    self.session = NSURLSession(configuration: configuration)
  }
  
  public func getOrganizations(completion: (organizations: [Organization], body: NSData?, response: NSHTTPURLResponse?, error: BuildkiteApiError?) -> Void) {
    let url = buildkiteEndpoint(BuildkiteURL.Organizations, apiKey, scheme: scheme)
    JSONDataForEndpoint(url, validResponseCodes: [HTTPResponseCodes.Success]) { json, data, response, error in
      var organizations: [Organization] = [Organization]()
      if let json = json as? [[String: AnyObject]] {
        if error == nil {
          organizations = json.map { organization in
            Organization(organization)
          }
        }
      }
      completion(organizations: organizations, body: data, response: response, error: error)
    }
  }
  
  public func getOrganization(name: String, completion: (organization: Organization?, body: NSData?, response: NSHTTPURLResponse?, error: BuildkiteApiError?) -> Void) {
    let url = buildkiteEndpoint(BuildkiteURL.Organization(organization: name), apiKey, scheme: scheme)
    JSONDataForEndpoint(url, validResponseCodes: [HTTPResponseCodes.Success]) { json, data, response, error in
      var organization : Organization?
      if let json = json as? [String: AnyObject] {
        if error == nil {
          organization = Organization(json)
        }
      }
      completion(organization: organization, body: data, response: response, error: error)
    }
  }
  
  public func getProjects(account: String, completion: (projects: [Project], body: NSData?, response: NSHTTPURLResponse?, error: BuildkiteApiError?) -> Void) {
    let url = buildkiteEndpoint(BuildkiteURL.Projects(organization: account), apiKey, scheme: scheme)
    JSONDataForEndpoint(url, validResponseCodes: [HTTPResponseCodes.Success]) { json, data, response, error in
      var projects: [Project] = [Project]()
      if let json = json as? [[String: AnyObject]] {
        if error == nil {
          projects = json.map { project in
            Project(project)
          }
        }
      }
      completion(projects: projects, body: data, response: response, error: error)
    }
  }
  
  public func getProject(account: String, projectName: String, completion: (project: Project?, body: NSData?, response: NSHTTPURLResponse?, error: BuildkiteApiError?) -> Void) {
    let url = buildkiteEndpoint(BuildkiteURL.Project(organization: account, project: projectName), apiKey, scheme: scheme)
    JSONDataForEndpoint(url, validResponseCodes: [HTTPResponseCodes.Success]) { json, data, response, error in
      var project : Project?
      if let json = json as? [String: AnyObject] {
        if error == nil {
          project = Project(json)
        }
      }
      completion(project: project, body: data, response: response, error: error)
    }
  }
  
  public func getBuilds(completion: (builds: [Build], body: NSData?, response: NSHTTPURLResponse?, error: BuildkiteApiError?) -> Void) {
    let url = buildkiteEndpoint(BuildkiteURL.AllBuilds, apiKey, scheme: scheme)
    JSONDataForEndpoint(url, validResponseCodes: [HTTPResponseCodes.Success]) { json, data, response, error in
      var builds: [Build] = [Build]()
      if let json = json as? [[String: AnyObject]] {
        if error == nil {
          builds = json.map { build in
            Build(build)
          }
        }
      }
      completion(builds: builds, body: data, response: response, error: error)
    }
  }
  
  public func getBuilds(organization: String, projectName: String, completion: (builds: [Build], body: NSData?, response: NSHTTPURLResponse?, error: BuildkiteApiError?) -> Void) {
    let url = buildkiteEndpoint(BuildkiteURL.Builds(organization: organization, project: projectName), apiKey, scheme: scheme)
    JSONDataForEndpoint(url, validResponseCodes: [HTTPResponseCodes.Success]) { json, data, response, error in
      var builds: [Build] = [Build]()
      if let json = json as? [[String: AnyObject]] {
        if error == nil {
          builds = json.map { build in
            Build(build)
          }
        }
      }
      completion(builds: builds, body: data, response: response, error: error)
    }
  }
  
  public func getBuild(organization: String, projectName: String, number: String, completion: (build: Build?, body: NSData?, response: NSHTTPURLResponse?, error: BuildkiteApiError?) -> Void) {
    let url = buildkiteEndpoint(BuildkiteURL.Build(organization: organization, project: projectName, build: number), apiKey, scheme: scheme)
    JSONDataForEndpoint(url, validResponseCodes: [HTTPResponseCodes.Success]) { json, data, response, error in
      var build: Build?
      if let json = json as? [String: AnyObject] {
        if error == nil {
          build = Build(json)
        }
      }
      completion(build: build, body: data, response: response, error: error)
    }
  }
  
  public func createBuild(organization: String, projectName: String, details: AnyObject, completion: (build: Build?, body: NSData?, response: NSHTTPURLResponse?, error: BuildkiteApiError?) -> Void) {
    let jsonDetails = NSJSONSerialization.dataWithJSONObject(details, options: .PrettyPrinted, error: nil)
    let url = buildkiteEndpoint(BuildkiteURL.Builds(organization: organization, project: projectName), apiKey, scheme: scheme)
    let request: NSMutableURLRequest = NSMutableURLRequest(URL: url)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.HTTPMethod = "POST"
    request.HTTPBody = jsonDetails

    JSONDataForRequest(request, validResponseCodes: [HTTPResponseCodes.Created]) { json, data, response, error in
      var build: Build?
      if let json = json as? [String: AnyObject] {
        if error == nil {
          build = Build(json)
        }
      }
      completion(build: build, body: data, response: response, error: error)
    }
  }

  public func unlockJob(organization: String, projectName: String, buildNumber: String, jobID: String, completion: (job: BuildJob?, body: NSData?, response: NSHTTPURLResponse?, error: BuildkiteApiError?) -> Void) {
    let url = buildkiteEndpoint(BuildkiteURL.BuildJobUnblock(organization: organization, project: projectName, build: buildNumber, job: jobID), apiKey, scheme: scheme)
    let request: NSMutableURLRequest = NSMutableURLRequest(URL: url)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.HTTPMethod = "PUT"

    JSONDataForRequest(request, validResponseCodes: [HTTPResponseCodes.Success]) { json, data, response, error in
      var buildJob: BuildJob?
      if let json = json as? [String: AnyObject] {
        if error == nil {
          buildJob = BuildJob(json)
        }
      }
      completion(job: buildJob, body: data, response: response, error: error)
    }
  }

  public func getAgents(account: String, completion: (agents: [Agent], body: NSData?, response: NSHTTPURLResponse?, error: BuildkiteApiError?) -> Void) {
    let url = buildkiteEndpoint(BuildkiteURL.Agents(organization: account), apiKey, scheme: scheme)
    JSONDataForEndpoint(url, validResponseCodes: [HTTPResponseCodes.Success]) { json, data, response, error in
      var agents: [Agent] = [Agent]()
      if let json = json as? [[String: AnyObject]] {
        if error == nil {
          agents = json.map { agent in
            Agent(agent)
          }
        }
      }
      completion(agents: agents, body: data, response: response, error: error)
    }
  }
  
  public func getAccessTokens(scopes: [String], client_id: String, completion: (token: AccessToken?, body: NSData?, response: NSHTTPURLResponse?, error: BuildkiteApiError?) -> Void) {
    let details = [
      "client_id": client_id,
      "scopes": scopes
    ]
    let jsonDetails = NSJSONSerialization.dataWithJSONObject(details, options: .PrettyPrinted, error: nil)
    let url = buildkiteEndpoint(BuildkiteURL.AccessTokens, "", scheme: scheme)
    let request: NSMutableURLRequest = NSMutableURLRequest(URL: url)
    request.HTTPMethod = "POST"
    request.HTTPBody = jsonDetails

    JSONDataForRequest(request, validResponseCodes: [HTTPResponseCodes.Created, HTTPResponseCodes.Success]) { json, data, response, error in
      var token: AccessToken?
      if let json = json as? [String: AnyObject] {
        if error == nil {
          token = AccessToken(json)
        }
      }
      completion(token: token, body: data, response: response, error: error)
    }
  }

  public func getUser(completion: (user: User?, body: NSData?, response: NSHTTPURLResponse?, error: BuildkiteApiError?) -> Void) {
    let url = buildkiteEndpoint(BuildkiteURL.User, apiKey, scheme: scheme)
    JSONDataForEndpoint(url, validResponseCodes: [HTTPResponseCodes.Success]) { json, data, response, error in
      var user : User?
      if let json = json as? [String: AnyObject] {
        if error == nil {
          user = User(json)
        }
      }
      completion(user: user, body: data, response: response, error: error)
    }
  }

  public func getJobLog(organization: String, project: String, build: String, job: String, completion: (NSString?, BuildkiteApiError?) -> Void) {
    let endpoint = BuildkiteURL.BuildJobLog(organization: organization, project: project, build: build, job: job)
    let url = buildkiteEndpoint(endpoint, apiKey, scheme: scheme)
    let task = session.dataTaskWithURL(url) { data, response, error in
      var logString: NSString?
      var error: BuildkiteApiError?
      if let response: NSHTTPURLResponse = response as? NSHTTPURLResponse {
        if let log = NSString(data: data, encoding: NSUTF8StringEncoding) {
          logString = log
        } else {
          error = BuildkiteApiError(code: response.statusCode, reason: "Unable to pass log to attributed string")
        }
      } else {
        error = BuildkiteApiError(code: -1, reason: "Bad response from server")
      }
      completion(logString, error)
    }

    task.resume()
  }

  public func getJobLogHtml(organization: String, project: String, build: String, job: String, completion: (NSString?, BuildkiteApiError?) -> Void) {
    let endpoint = BuildkiteURL.BuildJobLog(organization: organization, project: project, build: build, job: job)
    let url = buildkiteEndpoint(endpoint, apiKey, scheme: scheme)
    let request = NSMutableURLRequest(URL: url)
    request.addValue("text/html", forHTTPHeaderField: "Accept")

    let task = session.dataTaskWithRequest(request) { data, response, error in
      var logString: NSString?
      var error: BuildkiteApiError?
      if let response: NSHTTPURLResponse = response as? NSHTTPURLResponse {
        if let log = NSString(data: data, encoding: NSUTF8StringEncoding) {
          logString = log
        } else {
          error = BuildkiteApiError(code: response.statusCode, reason: "Unable to pass log to attributed string")
        }
      } else {
        error = BuildkiteApiError(code: -1, reason: "Bad response from server")
      }
      completion(logString, error)
    }

    task.resume()
  }

  public func getEmojis(organization: String, completion: (emojis: [Emoji]?, body: NSData?, response: NSHTTPURLResponse?, error: BuildkiteApiError?) -> Void) {
    let endpoint = BuildkiteURL.Emoji(organization: organization)
    let url = buildkiteEndpoint(endpoint, apiKey, scheme: scheme)

    JSONDataForEndpoint(url, validResponseCodes: [HTTPResponseCodes.Success]) { json, data, response, error in
      var emojis: [Emoji] = [Emoji]()
      if let json = json as? [[String: AnyObject]] {
        if error == nil {
          emojis = json.map { emoji in
            Emoji(emoji)
          }
        }
      }
      completion(emojis: emojis, body: data, response: response, error: error)
    }
  }

  func JSONDataForRequest(request: NSURLRequest, validResponseCodes: [Int], completion: (AnyObject?, NSData?, NSHTTPURLResponse?, BuildkiteApiError?) -> Void) {
    let task = session.dataTaskWithRequest(request) { data, response, error in
      if let theResponse: NSHTTPURLResponse = response as? NSHTTPURLResponse {
        let code = theResponse.statusCode
        var error : BuildkiteApiError?
        var json: AnyObject? = self.extractJSON(data)
        if(!contains(validResponseCodes, code)) {
          error = self.extractError(json, code: code)
        }
        completion(json, data, theResponse, error)
      }
    }

    task.resume()
  }

  func JSONDataForEndpoint(url: NSURL, validResponseCodes: [Int], completion: (AnyObject?, NSData?, NSHTTPURLResponse?, BuildkiteApiError?) -> Void) {
    let task = session.dataTaskWithURL(url) { data, response, error in
      if let theResponse : NSHTTPURLResponse = response as? NSHTTPURLResponse {
        let code = theResponse.statusCode
        var error : BuildkiteApiError?
        var json: AnyObject? = self.extractJSON(data)
        if(!contains(validResponseCodes, code)) {
          error = self.extractError(json, code: code)
        }
        completion(json, data, theResponse, error)
      }
    }
    task.resume()
  }
  
  func extractError(json: AnyObject?, code: Int) -> BuildkiteApiError? {
    var error: BuildkiteApiError?
    if let json = json as? [String: AnyObject] {
      if let reason = json["message"] as? String {
        error = BuildkiteApiError(code: code, reason: reason)
      }
    }
    return error
  }

  func extractJSON(data: NSData) -> AnyObject? {
    var nserror: NSError?
    var json: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: &nserror)
    return json
  }
}