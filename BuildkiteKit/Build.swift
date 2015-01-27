//
//  Build.swift
//  BuildkiteKit
//
//  Created by Matthew Delves on 15/11/2014.
//  Copyright (c) 2014 Matthew Delves. All rights reserved.
//


import Foundation

public enum BuildStatus {
  case Running;
  case Scheduled;
  case Passed;
  case Failed;
  case Canceled;
  case Skipped;
  case NotRun;

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

public struct BuildJob {
  public var id: String
  public var name: String
  public var type: String
  public var state: BuildStatus
  public var log_url: String
  public var script_path: String
  public var exit_status: Int?
  public var artifact_paths: String
  public var agent: [String: AnyObject]?
  public var created_at: String
  public var scheduled_at: String
  public var started_at: String?
  public var finished_at: String?

  public init(_ jsonObject: [String: AnyObject]) {
    self.id = jsonObject["id"] as String
    self.name = jsonObject["name"] as String
    self.type = jsonObject["type"] as String
    self.state = buildStatusFromString(jsonObject["state"] as String)
    self.log_url = jsonObject["log_url"] as String
    self.script_path = jsonObject["script_path"] as String
    self.artifact_paths = jsonObject["artifact_paths"] as String
    if let agent = jsonObject["agent"] as? [String: AnyObject] {
      self.agent = agent
    }
    self.created_at = jsonObject["created_at"] as String
    self.scheduled_at = jsonObject["scheduled_at"] as String
    if let started_at = jsonObject["started_at"] as? String {
      self.started_at = started_at
    }
    if let finished_at = jsonObject["finished_at"] as? String {
      self.finished_at = finished_at
    }
    if let exit_status = jsonObject["exit_status"] as? Int {
      self.exit_status = exit_status
    }
  }
}

public struct Build {
  public var id: String
  public var url: String
  public var number: Int
  public var branch: String
  public var state: BuildStatus?
  public var message: String
  public var commit: String
  public var env: [String: AnyObject]
  public var jobs: [BuildJob]?
  public var created_at: String
  public var scheduled_at: String
  public var started_at: String
  public var finished_at: String
  public var meta_data: [String: AnyObject]
  public var project: [String: AnyObject]?

  public init(_ jsonObject: [String: AnyObject]) {
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
    self.message = jsonObject["message"] as String
    self.commit = jsonObject["commit"] as String
    self.env = jsonObject["env"] as [String: AnyObject]
    self.created_at = jsonObject["created_at"] as String
    self.scheduled_at = jsonObject["scheduled_at"] as String
    self.started_at = started_at
    self.finished_at = finished_at
    self.meta_data = jsonObject["meta_data"] as [String: AnyObject]

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

    self.state = buildStatusFromString(jsonObject["state"] as String)
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
