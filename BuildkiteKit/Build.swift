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

public struct BuildJob {
  public var type: String
  public var id: String?
  public var name: String?
  public var state: BuildStatus?
  public var log_url: String?
  public var script_path: String?
  public var exit_status: Int?
  public var artifact_paths: String?
  public var agent: [String: AnyObject]?
  public var created_at: String?
  public var scheduled_at: String?
  public var started_at: String?
  public var finished_at: String?

  public init(_ jsonObject: [String: AnyObject]) {
    self.type = jsonObject["type"] as String

    if self.type == "waiter" {
      return
    }
    if let job_id = jsonObject["id"] as? String {
      self.id = job_id
    }
    if let name = jsonObject["name"] as? String {
      self.name = name
    }
    if let job_state = jsonObject["state"] as? String {
      self.state = buildStatusFromString(job_state)
    }
    if let log_url = jsonObject["log_url"] as? String {
      self.log_url = log_url
    }
    if let script_path = jsonObject["script_path"] as? String {
      self.script_path = script_path
    }
    if let artifact_paths = jsonObject["artifact_paths"] as? String {
      self.artifact_paths = artifact_paths
    }
    if let agent = jsonObject["agent"] as? [String: AnyObject] {
      self.agent = agent
    }
    if let created_at = jsonObject["created_at"] as? String {
      self.created_at = created_at
    }
    if let scheduled_at = jsonObject["scheduled_at"] as? String {
      self.scheduled_at = scheduled_at
    }
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

public enum BuildJobState {
  case Pending
  case Waiting
  case WaitingFailed
  case Blocked
  case BlockedFailed
  case Unblocked
  case UnblockedFailed
  case Scheduled
  case Assigned
  case Accepted
  case Running
  case Finished
  case Cancelling
  case Canceled
  case TimingOut
  case TimedOut
  case Skipped

  public var text:String {
    switch self {
    case .Pending: return "pending"
    case .Waiting: return "waiting"
    case .WaitingFailed: return "waiting failed"
    case .Blocked: return "blocked"
    case .BlockedFailed: return "blocked failed"
    case .Unblocked: return "unblocked"
    case .UnblockedFailed: return "unblocked failed"
    case .Scheduled: return "scheduled"
    case .Assigned: return "assigned"
    case .Accepted: return "accepted"
    case .Running: return "running"
    case .Finished: return "finished"
    case .Cancelling: return "cancelling"
    case .Canceled: return "canceled"
    case .TimingOut: return "timing out"
    case .TimedOut: return "timed out"
    case .Canceled: return "canceled"
    case .Skipped: return "skipped"
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
  public var created_at: String?
  public var scheduled_at: String?
  public var started_at: String?
  public var finished_at: String?
  public var meta_data: [String: AnyObject]
  public var project: [String: AnyObject]?

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

    self.id = jsonObject["id"] as String
    self.url = jsonObject["url"] as String
    self.number = jsonObject["number"] as Int
    self.branch = jsonObject["branch"] as String
    self.message = jsonObject["message"] as String
    self.commit = jsonObject["commit"] as String
    self.env = jsonObject["env"] as [String: AnyObject]
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

func buildJobStateFromString(status: String) -> BuildJobState {
  var retval: BuildJobState
  switch status {
  case "pending": retval = .Pending
  case "waiting": retval = .Waiting
  case "waiting_failed": retval = .WaitingFailed
  case "blocked": retval = .Blocked
  case "blocked_failed": retval = .BlockedFailed
  case "unblocked": retval = .Unblocked
  case "unblocked_failed": retval = .UnblockedFailed
  case "scheduled": retval = .Scheduled
  case "assigned": retval = .Assigned
  case "accepted": retval = .Accepted
  case "running": retval = .Running
  case "finished": retval = .Finished
  case "cancelling": retval = .Cancelling
  case "canceled": retval = .Canceled
  case "timing out": retval = .TimingOut
  case "timed out": retval = .TimedOut
  case "canceled": retval = .Canceled
  case "skipped": retval = .Skipped
  default: retval = .Pending
  }

  return retval
}
