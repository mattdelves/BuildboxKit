//
//  Build.swift
//  BuildkiteKit
//
//  Created by Matthew Delves on 15/11/2014.
//  Copyright (c) 2014 Matthew Delves. All rights reserved.
//


import Foundation

public enum BuildStatus {
  case Running
  case Scheduled
  case Passed
  case Failed
  case Canceled
  case Skipped
  case NotRun

  public var text:String {
    switch self {
    case .Running: return "running"
    case .Scheduled: return "scheduled"
    case .Passed: return "passed"
    case .Failed: return "failed"
    case .Canceled: return "canceled"
    case .Skipped: return "skipped"
    case .NotRun: return "not run"
    }
  }
}

public struct Build {
  public var id: String = ""
  public var url: String = ""
  public var number: Int = -1
  public var branch: String = ""
  public var state: BuildStatus = BuildStatus.NotRun
  public var message: String = ""
  public var commit: String = ""
  public var env: [String: AnyObject] = [String: AnyObject]()
  public var jobs: [BuildJob]? = nil
  public var created_at: String? = nil
  public var scheduled_at: String? = nil
  public var started_at: String? = nil
  public var finished_at: String? = nil
  public var meta_data: [String: AnyObject] = [String: AnyObject]()
  public var project: [String: AnyObject]? = nil

  public init(_ jsonObject: [String: AnyObject]) {
    if let started_at : String = jsonObject["started_at"] as? String {
      self.started_at = started_at
    }
    if let finished_at : String = jsonObject["finished_at"] as? String {
      self.finished_at = finished_at
    }
    if let scheduled_at = jsonObject["scheduled_at"] as? String {
      self.scheduled_at = scheduled_at
    }
    if let created_at = jsonObject["created_at"] as? String {
      self.created_at = created_at
    }
    if let buildID = jsonObject["id"] as? String {
      self.id = buildID
    }
    if let url = jsonObject["url"] as? String {
      self.url = url
    }
    if let number = jsonObject["number"] as? Int {
      self.number = number
    }
    if let branch = jsonObject["branch"] as? String {
      self.branch = branch
    }
    if let message = jsonObject["message"] as? String {
      self.message = message
    }
    if let commit = jsonObject["commit"] as? String {
      self.commit = commit
    }
    if let env = jsonObject["env"] as? [String: AnyObject] {
      self.env = env
    }
    if let meta_data = jsonObject["meta_data"] as? [String: AnyObject] {
      self.meta_data = meta_data
    }
    if let jobs : [[String: AnyObject]] = jsonObject["jobs"] as? [[String: AnyObject]] {
      var foundJobs = [BuildJob]()
      for job in jobs {
        foundJobs.append(BuildJob(job))
      }
      self.jobs = foundJobs
    }
    if let project : [String: AnyObject] = jsonObject["project"] as? [String: AnyObject] {
      self.project = project
    }
    if let state = jsonObject["state"] as? String {
      self.state = buildStatusFromString(state)
    }
  }
}

func buildStatusFromString(status: String) -> BuildStatus {
  var retval : BuildStatus
  switch status {
  case "running":
    retval = .Running
  case "scheduled":
    retval = .Scheduled
  case "passed":
    retval = .Passed
  case "failed":
    retval = .Failed
  case "canceled":
    retval = .Canceled
  case "skipped":
    retval = .Skipped
  case "not_run":
    retval = .NotRun
  default:
    retval = .NotRun
  }

  return retval
}
