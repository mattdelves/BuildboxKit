//
//  BuildkiteApiSpec.swift
//  BuildkiteKit
//
//  Created by Matthew Delves on 6/09/2014.
//  Copyright (c) 2014 Matthew Delves. All rights reserved.
//

import Quick
import Nimble
import DummySpit
import BuildkiteKit

class BuildkiteApiSpec: QuickSpec {
  override func spec() {
    var api: BuildkiteApi?
    
    describe("All Organizations") {
      beforeEach {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let urlProtocolClass: AnyObject = ClassUtility.classFromType(DummySpitURLProtocol.self)
        configuration.protocolClasses = [urlProtocolClass]
        api = BuildkiteApi("123abc", scheme: "mock", configuration: configuration)
      }
      
      afterEach {
        DummySpitURLProtocol.cannedResponse(nil)
      }
      
      it("can be retrieved") {
        let filePath = NSBundle(forClass: BuildkiteApiSpec.self).pathForResource("accounts", ofType: "json")
        let response = DummySpitServiceResponse(filePath: filePath!, header: ["Content-type": "application/json"], urlComponentToMatch: "organizations")
        DummySpitURLProtocol.cannedResponse(response)
        var called = false
        
        api?.getOrganizations({ accounts, body, response, error in
          called = true
        })
        
        expect{called}.toEventually(beTruthy())
      }
      
      it("receives a 401 response") {
        let filePath = NSBundle(forClass: BuildkiteApiSpec.self).pathForResource("unauthorized", ofType: "json")
        let response = DummySpitServiceResponse(
          filePath: filePath!,
          header: ["Content-type": "application/json"],
          urlComponentToMatch: "organizations",
          statusCode: 401
        )
        
        DummySpitURLProtocol.cannedResponse(response)
        var called = false
        
        api?.getOrganizations { accounts, body, response, error in
          called = true
          expect(error).notTo(beNil())
        }
        
        expect{called}.toEventually(beTruthy())
      }
    }
    
    describe("An Organization") {
      beforeEach {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let urlProtocolClass: AnyObject = ClassUtility.classFromType(DummySpitURLProtocol.self)
        configuration.protocolClasses = [urlProtocolClass]
        api = BuildkiteApi("123abc", scheme: "mock", configuration: configuration)
      }
      
      afterEach {
        DummySpitURLProtocol.cannedResponse(nil)
      }
      
      it("can be retrieved") {
        let filePath = NSBundle(forClass: BuildkiteApiSpec.self).pathForResource("foobar_account", ofType: "json")
        let response = DummySpitServiceResponse(filePath: filePath!, header: ["Content-type": "application/json"], urlComponentToMatch: "foobar")
        DummySpitURLProtocol.cannedResponse(response)
        var called = false
        
        api?.getOrganization("foobar") { account, body, response, error in
          called = true
          expect(account?.name).to(equal("Foo and Bar"))
        }
        
        expect{called}.toEventually(beTruthy())
      }

      it("receives a 401 response") {
        let filePath = NSBundle(forClass: BuildkiteApiSpec.self).pathForResource("unauthorized", ofType: "json")
        let response = DummySpitServiceResponse(
          filePath: filePath!,
          header: ["Content-type": "application/json"],
          urlComponentToMatch: "foobar",
          statusCode: 401
        )
        
        DummySpitURLProtocol.cannedResponse(response)
        var called = false
        
        api?.getOrganization("foobar") { account, body, response, error in
          called = true
          expect(error).notTo(beNil())
          expect(account).to(beNil())
        }
        
        expect{called}.toEventually(beTruthy())
      }
    }
    
    describe("All Projects") {
      beforeEach {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let urlProtocolClass: AnyObject = ClassUtility.classFromType(DummySpitURLProtocol.self)
        configuration.protocolClasses = [urlProtocolClass]
        api = BuildkiteApi("123abc", scheme: "mock", configuration: configuration)
      }
      
      afterEach {
        DummySpitURLProtocol.cannedResponse(nil)
      }
      
      it("can be retrieved") {
        let filePath = NSBundle(forClass: BuildkiteApiSpec.self).pathForResource("projects", ofType: "json")
        let response = DummySpitServiceResponse(filePath: filePath!, header: ["Content-type": "application/json"], urlComponentToMatch: "projects")
        DummySpitURLProtocol.cannedResponse(response)
        var called = false
        
        api?.getProjects("dummyspit") { projects, body, response, error in
          called = true
          expect(projects.count).to(equal(3))
        }

        expect{called}.toEventually(beTruthy())
      }
      
      it("receives a 401 response") {
        let filePath = NSBundle(forClass: BuildkiteApiSpec.self).pathForResource("unauthorized", ofType: "json")
        let response = DummySpitServiceResponse(
          filePath: filePath!,
          header: ["Content-type": "application/json"],
          urlComponentToMatch: "projects",
          statusCode: 401
        )
        
        DummySpitURLProtocol.cannedResponse(response)
        var called = false
        
        api?.getProjects("dummyspit") { projects, body, response, error in
          called = true
          expect(error).notTo(beNil())
        }
        
        expect{called}.toEventually(beTruthy())
      }
    }
    
    describe("A single Project") {
      beforeEach {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let urlProtocolClass: AnyObject = ClassUtility.classFromType(DummySpitURLProtocol.self)
        configuration.protocolClasses = [urlProtocolClass]
        api = BuildkiteApi("123abc", scheme: "mock", configuration: configuration)
      }
      
      afterEach {
        DummySpitURLProtocol.cannedResponse(nil)
      }
      
      it("can be retrieved") {
        let filePath = NSBundle(forClass: BuildkiteApiSpec.self).pathForResource("foobar_project", ofType: "json")
        let response = DummySpitServiceResponse(filePath: filePath!, header: ["Content-type": "application/json"], urlComponentToMatch: "foobar")
        DummySpitURLProtocol.cannedResponse(response)
        var called = false
        
        api?.getProject("dummyspit", projectName: "foobar") { project, body, response, error in
          called = true
          expect(project?.name).to(equal("Project3"))
        }

        expect{called}.toEventually(beTruthy())
      }

      it("receives a 401 response") {
        let filePath = NSBundle(forClass: BuildkiteApiSpec.self).pathForResource("unauthorized", ofType: "json")
        let response = DummySpitServiceResponse(
          filePath: filePath!,
          header: ["Content-type": "application/json"],
          urlComponentToMatch: "foobar",
          statusCode: 401
        )
        
        DummySpitURLProtocol.cannedResponse(response)
        var called = false
        
        api?.getProject("dummyspit", projectName: "foobar") { project, body, response, error in
          called = true
          expect(error).notTo(beNil())
          expect(project).to(beNil())
        }
        
        expect{called}.toEventually(beTruthy())
      }
    }
    
    describe("All Builds for a project") {
      beforeEach {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let urlProtocolClass: AnyObject = ClassUtility.classFromType(DummySpitURLProtocol.self)
        configuration.protocolClasses = [urlProtocolClass]
        api = BuildkiteApi("123abc", scheme: "mock", configuration: configuration)
      }
      
      afterEach {
        DummySpitURLProtocol.cannedResponse(nil)
      }
      
      it("can be retrieved") {
        let filePath = NSBundle(forClass: BuildkiteApiSpec.self).pathForResource("builds", ofType: "json")
        let response = DummySpitServiceResponse(filePath: filePath!, header: ["Content-type": "application/json"], urlComponentToMatch: "builds")
        DummySpitURLProtocol.cannedResponse(response)
        var called = false
        
        api?.getBuilds("foobar", projectName: "Project1") { builds, body, response, error in
          called = true
          expect(builds.count).to(equal(7))
        }
        
        expect{called}.toEventually(beTruthy())
      }

      it("receives a 401 response") {
        let filePath = NSBundle(forClass: BuildkiteApiSpec.self).pathForResource("unauthorized", ofType: "json")
        let response = DummySpitServiceResponse(
          filePath: filePath!,
          header: ["Content-type": "application/json"],
          urlComponentToMatch: "builds",
          statusCode: 401
        )
        
        DummySpitURLProtocol.cannedResponse(response)
        var called = false
        
        api?.getBuilds("foobar", projectName: "Project1") { builds, body, response, error in
          called = true
          expect(error).notTo(beNil())
        }
        
        expect{called}.toEventually(beTruthy())
      }
    }
    
    describe("All Builds for a user") {
      beforeEach {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let urlProtocolClass: AnyObject = ClassUtility.classFromType(DummySpitURLProtocol.self)
        configuration.protocolClasses = [urlProtocolClass]
        api = BuildkiteApi("123abc", scheme: "mock", configuration: configuration)
      }
      
      afterEach {
        DummySpitURLProtocol.cannedResponse(nil)
      }
      
      it("can be retrieved") {
        let filePath = NSBundle(forClass: BuildkiteApiSpec.self).pathForResource("all_builds", ofType: "json")
        let response = DummySpitServiceResponse(filePath: filePath!, header: ["Content-type": "application/json"], urlComponentToMatch: "builds")
        DummySpitURLProtocol.cannedResponse(response)
        var called = false
        
        api?.getBuilds { builds, body, response, error in
          called = true
          expect(builds.count).to(equal(30))
        }
        
        expect{called}.toEventually(beTruthy())
      }

      it("receives a 401 response") {
        let filePath = NSBundle(forClass: BuildkiteApiSpec.self).pathForResource("unauthorized", ofType: "json")
        let response = DummySpitServiceResponse(
          filePath: filePath!,
          header: ["Content-type": "application/json"],
          urlComponentToMatch: "builds",
          statusCode: 401
        )
        
        DummySpitURLProtocol.cannedResponse(response)
        var called = false
        
        api?.getBuilds("foobar", projectName: "Project1") { builds, body, response, error in
          called = true
          expect(error).notTo(beNil())
        }
        
        expect{called}.toEventually(beTruthy())
      }
    }
    
    describe("A single Build") {
      beforeEach {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let urlProtocolClass: AnyObject = ClassUtility.classFromType(DummySpitURLProtocol.self)
        configuration.protocolClasses = [urlProtocolClass]
        api = BuildkiteApi("123abc", scheme: "mock", configuration: configuration)
      }
      
      afterEach {
        DummySpitURLProtocol.cannedResponse(nil)
      }
      
      it("can be retrieved") {
        let filePath = NSBundle(forClass: BuildkiteApiSpec.self).pathForResource("single_build", ofType: "json")
        let response = DummySpitServiceResponse(filePath: filePath!, header: ["Content-type": "application/json"], urlComponentToMatch: "1")
        DummySpitURLProtocol.cannedResponse(response)
        var called = false
        
        api?.getBuild("foobar", projectName: "Project1", number: "1") { build, body, response, error in
          called = true
          expect(build?.number).to(equal(1))
          expect(build?.message).to(equal("add in buildbox script"))
          expect(build?.jobs).toNot(beNil())
        }
        
        expect{called}.toEventually(beTruthy())
      }

      it("receives a 401 response") {
        let filePath = NSBundle(forClass: BuildkiteApiSpec.self).pathForResource("unauthorized", ofType: "json")
        let response = DummySpitServiceResponse(
          filePath: filePath!,
          header: ["Content-type": "application/json"],
          urlComponentToMatch: "1",
          statusCode: 401
        )
        
        DummySpitURLProtocol.cannedResponse(response)
        var called = false
        
        api?.getBuild("foobar", projectName: "Project1", number: "1") { build, body, response, error in
          called = true
          expect(error).notTo(beNil())
          expect(build).to(beNil())
        }
        
        expect{called}.toEventually(beTruthy())
      }
    }
    
    describe("Create Build") {
      beforeEach {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let urlProtocolClass: AnyObject = ClassUtility.classFromType(DummySpitURLProtocol.self)
        configuration.protocolClasses = [urlProtocolClass]
        api = BuildkiteApi("123abc", scheme: "mock", configuration: configuration)
      }

      afterEach {
        DummySpitURLProtocol.cannedResponse(nil)
      }

      it("can be created") {
        let filePath = NSBundle(forClass: BuildkiteApiSpec.self).pathForResource("single_build", ofType: "json")
        let response = DummySpitServiceResponse(filePath: filePath!, header: ["Content-type": "application/json"], urlComponentToMatch: "builds", statusCode: 201)
        DummySpitURLProtocol.cannedResponse(response)
        var called = false

        var details = [
          "commit": "master",
          "branch": "master",
          "author": [
            "name": "Liam Neeson",
            "email": "liam@evilbatmanvillans.com"
          ],
          "env": [
            "CUSTOM_ENV_VAR": "works"
          ],
          "message": "Testing all the things :rocket:",
          "meta_data": [
            "personal": true
          ]
        ]

        api?.createBuild("foobar", projectName: "barfoo", details: details) { build, data, response, error in
          called = true
          expect(build).notTo(beNil())
          expect(build?.number).to(equal(1))
          expect(build?.message).to(equal("add in buildbox script"))
          expect(build?.jobs).toNot(beNil())
        }

        expect(called).toEventually(beTrue())
      }

      it("401") {
        let filePath = NSBundle(forClass: BuildkiteApiSpec.self).pathForResource("unauthorized", ofType: "json")
        let response = DummySpitServiceResponse(
          filePath: filePath!,
          header: ["Content-type": "application/json"],
          urlComponentToMatch: "builds",
          statusCode: 401
        )
        DummySpitURLProtocol.cannedResponse(response)
        var called = false

        var details = [
          "commit": "master",
          "branch": "master",
          "author": [
            "name": "Liam Neeson",
            "email": "liam@evilbatmanvillans.com"
          ],
          "env": [
            "CUSTOM_ENV_VAR": "works"
          ],
          "message": "Testing all the things :rocket:",
          "meta_data": [
            "personal": true
          ]
        ]

        api?.createBuild("foobar", projectName: "barfoo", details: details) { build, data, response, error in
          called = true
          expect(error).notTo(beNil())
          expect(build).to(beNil())
        }

        expect(called).toEventually(beTrue())
      }
    }

    describe("Unblock job") {
      beforeEach {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let urlProtocolClass: AnyObject = ClassUtility.classFromType(DummySpitURLProtocol.self)
        configuration.protocolClasses = [urlProtocolClass]
        api = BuildkiteApi("123abc", scheme: "mock", configuration: configuration)
      }

      afterEach {
        DummySpitURLProtocol.cannedResponse(nil)
      }

      it("unblocks") {
        let filePath = NSBundle(forClass: BuildkiteApiSpec.self).pathForResource("job_unblock", ofType: "json")
        let response = DummySpitServiceResponse(filePath: filePath!, header: ["Content-type": "application/json"], urlComponentToMatch: "unblock", statusCode: 200, error: nil)
        DummySpitURLProtocol.cannedResponse(response)
        var called = false

        api?.unlockJob("foobar", projectName: "barfoo", buildNumber: "123-abc", jobID: "123abc") {job, data, response, error in
          called = true
          expect(job).notTo(beNil())
        }

        expect(called).toEventually(beTrue())
      }

      it("bad request") {
        let filePath = NSBundle(forClass: BuildkiteApiSpec.self).pathForResource("unblock_bad_request", ofType: "json")
        let response = DummySpitServiceResponse(filePath: filePath!, header: ["Content-type": "application/json"], urlComponentToMatch: "unblock", statusCode: 400, error: nil)
        DummySpitURLProtocol.cannedResponse(response)
        var called = false

        api?.unlockJob("foobar", projectName: "barfoo", buildNumber: "123-abc", jobID: "123abc") {job, data, response, error in
          called = true
          expect(job).to(beNil())
          expect(error).notTo(beNil())
          expect(error?.code).to(equal(400))
          expect(error?.reason).to(equal("This job type cannot be unblocked"))
        }

        expect(called).toEventually(beTrue())
      }

      it("unprocessable") {
        let filePath = NSBundle(forClass: BuildkiteApiSpec.self).pathForResource("unblock_unprocessable", ofType: "json")
        let response = DummySpitServiceResponse(filePath: filePath!, header: ["Content-type": "application/json"], urlComponentToMatch: "unblock", statusCode: 422, error: nil)
        DummySpitURLProtocol.cannedResponse(response)
        var called = false

        api?.unlockJob("foobar", projectName: "barfoo", buildNumber: "123-abc", jobID: "123abc") {job, data, response, error in
          called = true
          expect(job).to(beNil())
          expect(error).notTo(beNil())
          expect(error?.code).to(equal(422))
          expect(error?.reason).to(equal("Unblocker is not a valid user id for this account"))
        }

        expect(called).toEventually(beTrue())
      }
    }

    describe("All Agents") {
      beforeEach {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let urlProtocolClass: AnyObject = ClassUtility.classFromType(DummySpitURLProtocol.self)
        configuration.protocolClasses = [urlProtocolClass]
        api = BuildkiteApi("123abc", scheme: "mock", configuration: configuration)
      }
      
      afterEach {
        DummySpitURLProtocol.cannedResponse(nil)
      }
      
      it("can be retrieved") {
        let filePath = NSBundle(forClass: BuildkiteApiSpec.self).pathForResource("agents", ofType: "json")
        let response = DummySpitServiceResponse(filePath: filePath!, header: ["Content-type": "application/json"], urlComponentToMatch: "agents")
        DummySpitURLProtocol.cannedResponse(response)
        var called = false
        
        api?.getAgents("foobar") { agents, body, response, error in
          called = true
          expect(agents.count).to(equal(1))
          expect(agents[0].build).toNot(beNil())
          expect(agents[0].job).toNot(beNil())
        }
        
        expect{called}.toEventually(beTruthy())
      }
    }
    
    describe("Access Tokens") {
      beforeEach {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let urlProtocolClass: AnyObject = ClassUtility.classFromType(DummySpitURLProtocol.self)
        configuration.protocolClasses = [urlProtocolClass]
        api = BuildkiteApi("123abc", scheme: "mock", configuration: configuration)
      }

      afterEach {
        DummySpitURLProtocol.cannedResponse(nil)
      }

      it("authenticates correctly") {
        let filePath = NSBundle(forClass: BuildkiteApiSpec.self).pathForResource("access_token", ofType: "json")
        let response = DummySpitServiceResponse(filePath: filePath!, header: ["Content-type": "application/json"], urlComponentToMatch: "access_tokens")
        DummySpitURLProtocol.cannedResponse(response)
        var called = false

        api?.getAccessTokens(["a", "b"], client_id: "abc123") { token, body, response, error in
          called = true
        }

        expect{called}.toEventually(beTrue())
      }
      
    }

    describe("The current User") {
      beforeEach {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let urlProtocolClass: AnyObject = ClassUtility.classFromType(DummySpitURLProtocol.self)
        configuration.protocolClasses = [urlProtocolClass]
        api = BuildkiteApi("123abc", scheme: "mock", configuration: configuration)
      }
      
      afterEach {
        DummySpitURLProtocol.cannedResponse(nil)
      }
      
      it("can be retrieved") {
        let filePath = NSBundle(forClass: BuildkiteApiSpec.self).pathForResource("user", ofType: "json")
        let response = DummySpitServiceResponse(filePath: filePath!, header: ["Content-type": "application/json"], urlComponentToMatch: "user")
        DummySpitURLProtocol.cannedResponse(response)
        var called = false
        
        api?.getUser { user, body, response, error in
          called = true
          expect(user?.name).to(equal("Foo Bar"))
        }
        
        expect{called}.toEventually(beTruthy())
      }

      it("receives a 401 response") {
        let filePath = NSBundle(forClass: BuildkiteApiSpec.self).pathForResource("unauthorized", ofType: "json")
        let response = DummySpitServiceResponse(
          filePath: filePath!,
          header: ["Content-type": "application/json"],
          urlComponentToMatch: "user",
          statusCode: 401
        )
        
        DummySpitURLProtocol.cannedResponse(response)
        var called = false
        
        api?.getUser { user, body, response, error in
          called = true
          expect(error).notTo(beNil())
          expect(user).to(beNil())
        }
        
        expect{called}.toEventually(beTruthy())
      }
    }

    describe("log output") {
      beforeEach {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let urlProtocolClass: AnyObject = ClassUtility.classFromType(DummySpitURLProtocol.self)
        configuration.protocolClasses = [urlProtocolClass]
        api = BuildkiteApi("123abc", scheme: "mock", configuration: configuration)
      }

      it("txt") {
        let filePath = NSBundle(forClass: BuildkiteApiSpec.self).pathForResource("log", ofType: "txt")
        let result:NSString = NSString(contentsOfFile: filePath!, encoding: NSUTF8StringEncoding, error: nil)!
        var dataResponse: NSData?
        if let resultData = result.dataUsingEncoding(NSUTF8StringEncoding) {
          dataResponse = resultData
        }
        let response = DummySpitServiceResponse(data: dataResponse!, header: ["Content-type": "plain/txt"], urlComponentToMatch: "log")
        DummySpitURLProtocol.cannedResponse(response)
        var called = false

        api?.getJobLog("foo", project: "bar", build: "1", job: "123abc") { log, error in
          called = true
          expect(log).notTo(beNil())
        }

        expect{called}.toEventually(beTruthy())
      }

      it("html") {
        let filePath = NSBundle(forClass: BuildkiteApiSpec.self).pathForResource("log", ofType: "html")
        let result:NSString = NSString(contentsOfFile: filePath!, encoding: NSUTF8StringEncoding, error: nil)!
        var dataResponse: NSData?
        if let resultData = result.dataUsingEncoding(NSUTF8StringEncoding) {
          dataResponse = resultData
        }
        let response = DummySpitServiceResponse(data: dataResponse!, header: ["Content-type": "plain/txt"], urlComponentToMatch: "log")
        DummySpitURLProtocol.cannedResponse(response)
        var called = false

        api?.getJobLogHtml("foo", project: "bar", build: "1", job: "123abc") { log, error in
          called = true
          expect(log).notTo(beNil())
        }

        expect{called}.toEventually(beTruthy())
      }
    }
  }
}
