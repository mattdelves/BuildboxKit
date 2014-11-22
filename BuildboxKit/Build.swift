//
//  Build.swift
//  BuildboxKit
//
//  Created by Matthew Delves on 15/11/2014.
//  Copyright (c) 2014 Matthew Delves. All rights reserved.
//


import Foundation

public class Build {
  public var id: String
  public var url: String
  public var number: Int
  public var branch: String
  public var state: String
  public var message: String
  public var commit: String
  public var env: NSDictionary
  public var jobs: [NSDictionary]
  public var created_at: String
  public var scheduled_at: String
  public var started_at: String
  public var finished_at: String
  public var meta_data: NSDictionary
  public var project: Dictionary<String, String>
  
  init(_ jsonObject: NSDictionary) {
    var started_at = ""
    if let started_at_value : String = jsonObject["started_at"] as? String {
      started_at = started_at_value
    }
    
    var finished_at = ""
    if let finished_at_value : String = jsonObject["finished_at"] as? String {
      finished_at = finished_at_value
    }
    
    self.id = jsonObject["id"] as String
    self.url = jsonObject["url"] as String
    self.number = jsonObject["number"] as Int
    self.branch = jsonObject["branch"] as String
    self.state = jsonObject["state"] as String
    self.message = jsonObject["message"] as String
    self.commit = jsonObject["commit"] as String
    self.env = jsonObject["env"] as NSDictionary
    self.jobs = jsonObject["jobs"] as [NSDictionary]
    self.created_at = jsonObject["created_at"] as String
    self.scheduled_at = jsonObject["scheduled_at"] as String
    self.started_at = started_at
    self.finished_at = finished_at
    self.meta_data = jsonObject["meta_data"] as NSDictionary
    self.project = jsonObject["project"] as Dictionary<String, String>
  }
}