//
//  Build.swift
//  BuildboxKit
//
//  Created by Matthew Delves on 15/11/2014.
//  Copyright (c) 2014 Matthew Delves. All rights reserved.
//


import Foundation

public struct Build {
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
}