//
//  BuildboxApi.swift
//  BuildboxKit
//
//  Created by Matthew Delves on 6/09/2014.
//  Copyright (c) 2014 Matthew Delves. All rights reserved.
//

import Foundation

public class BuildboxApi {
  public var apiKey: String
  public var scheme: String
  var session: NSURLSession
  
  public init (_ apiKey: String, scheme: String = "https", configuration: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()) {
    self.apiKey = apiKey
    self.scheme = scheme

    self.session = NSURLSession(configuration: configuration)
  }
  
  public func getAccounts(completion: (data: [Account]) -> Void) {
    let url = buildboxEndpoint(BuildboxURL.Accounts, apiKey, scheme: scheme)
    
    ArrayOfJSONDataForEndpoint(url) { json in
      var accounts: [Account] = [Account]()
      
      for accountData:NSDictionary in json {
        accounts.append(self.extractAccount(accountData))
      }

      completion(data: accounts)
    }
  }
  
  public func getAccount(name: String, completion: (account: Account) -> Void) {
    let url = buildboxEndpoint(BuildboxURL.Account(username: name), apiKey, scheme: scheme)
    
    JSONDataForEndpoint(url) { json in
      completion(account: self.extractAccount(json))
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
  
  func ArrayOfJSONDataForEndpoint(url: NSURL, completion: [NSDictionary] -> Void) {
    let task = session.dataTaskWithURL(url) { data, response, error in
      var code = (response as NSHTTPURLResponse).statusCode
      if(code != 200) {
        println("I didn't get a valid response back. Instead I got \(code)")
        return
      }
      var error: NSError?
      // Need to be able to distinguish between array and dict returns
      var jsonArray: [NSDictionary] = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as [NSDictionary]
      
      completion(jsonArray)
    }
    
    task.resume()
  }
  
  func JSONDataForEndpoint(url: NSURL, completion: NSDictionary -> Void) {
    let task = session.dataTaskWithURL(url) { data, response, error in
      var code = (response as NSHTTPURLResponse).statusCode
      if(code != 200) {
        println("I didn't get a valid response back. Instead I got \(code)")
        return
      }
      var error: NSError?
      // Need to be able to distinguish between array and dict returns
      var json: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as NSDictionary
      
      completion(json)
    }
    
    task.resume()
  }

}