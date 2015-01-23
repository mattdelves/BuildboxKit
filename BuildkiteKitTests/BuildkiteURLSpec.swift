//
//  BuildkiteURLSpec.swift
//  BuildkiteKit
//
//  Created by Matthew Delves on 6/09/2014.
//  Copyright (c) 2014 Matthew Delves. All rights reserved.
//

import Quick
import Nimble
import BuildkiteKit

class BuildkiteURLSpec: QuickSpec {
  override func spec() {
    describe("constructing the path") {
      it("for all accounts") {
        var endpoint = BuildkiteURL.Organizations
        expect(endpoint.path).to(equal("/v1/organizations"))
      }
      it("for a specified account") {
        var endpoint = BuildkiteURL.Organization(organization: "foo")
        expect(endpoint.path).to(equal("/v1/organizations/foo"))
      }
      it("for all projects on an account") {
        var endpoint = BuildkiteURL.Projects(organization: "foo")
        expect(endpoint.path).to(equal("/v1/organizations/foo/projects"))
      }
      it("for a specified project") {
        var endpoint = BuildkiteURL.Project(organization: "foo", project: "bar")
        expect(endpoint.path).to(equal("/v1/organizations/foo/projects/bar"))
      }
      it("for all builds in a project") {
        var endpoint = BuildkiteURL.Builds(organization: "foo", project: "bar")
        expect(endpoint.path).to(equal("/v1/organizations/foo/projects/bar/builds"))
      }
      it("for a specified build in a project") {
        var endpoint = BuildkiteURL.Build(organization: "foo", project: "bar", build: 1)
        expect(endpoint.path).to(equal("/v1/organizations/foo/projects/bar/builds/1"))
      }
      
      it("for all agents") {
        var endpoint = BuildkiteURL.Agents(organization: "foo")
        expect(endpoint.path).to(equal("/v1/organizations/foo/agents"))
      }
      
      it("for all builds") {
        var endpoint = BuildkiteURL.AllBuilds
        expect(endpoint.path).to(equal("/v1/builds"))
      }

      it("for access tokens") {
        var endpoint = BuildkiteURL.AccessTokens
        expect(endpoint.path).to(equal("/v1/access_tokens"))
      }
      
      it("for the current user") {
        var endpoint = BuildkiteURL.User
        expect(endpoint.path).to(equal("/v1/user"))
      }
    }
    
    describe("constructs an URL") {
      it("when using default https scheme") {
        var endpoint = BuildkiteURL.Organizations
        var url = buildkiteEndpoint(endpoint, "123abc")
        expect(url.absoluteString).to(equal("https://api.buildkite.com/v1/organizations?api_key=123abc"))
      }
      
      it("when specifying a scheme") {
        var endpoint = BuildkiteURL.Organizations
        var url = buildkiteEndpoint(endpoint, "123abc", scheme: "mock")
        expect(url.absoluteString).to(equal("mock://api.buildkite.com/v1/organizations?api_key=123abc"))
      }
    }
  }
}
