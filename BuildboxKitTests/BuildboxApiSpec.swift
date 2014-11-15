//
//  BuildboxApiSpec.swift
//  BuildboxKit
//
//  Created by Matthew Delves on 6/09/2014.
//  Copyright (c) 2014 Matthew Delves. All rights reserved.
//

import Quick
import Nimble
import DummySpit
import BuildboxKit

class BuildboxApiSpec: QuickSpec {
  override func spec() {
    var api: BuildboxApi?
    
    describe("All Accounts") {
      beforeEach {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let urlProtocolClass: AnyObject = ClassUtility.classFromType(DummySpitURLProtocol.self)
        configuration.protocolClasses = [urlProtocolClass]
        api = BuildboxApi("123abc", scheme: "mock", configuration: configuration)
        
        let filePath = NSBundle(forClass: BuildboxApiSpec.self).pathForResource("accounts", ofType: "json")
        let response = DummySpitServiceResponse(filePath: filePath!, header: ["Content-type": "application/json"], urlComponentToMatch: "accounts")
        DummySpitURLProtocol.cannedResponse(response)
      }
      
      afterEach {
        DummySpitURLProtocol.cannedResponse(nil)
      }
      
      it("can be retrieved") {
        var called = false
        
        api?.getAccounts({ accounts in
          called = true
        })
        
        expect{called}.toEventually(beTruthy())
      }
    }
    
    describe("An Account") {
      beforeEach {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let urlProtocolClass: AnyObject = ClassUtility.classFromType(DummySpitURLProtocol.self)
        configuration.protocolClasses = [urlProtocolClass]
        api = BuildboxApi("123abc", scheme: "mock", configuration: configuration)
        
        let filePath = NSBundle(forClass: BuildboxApiSpec.self).pathForResource("foobar_account", ofType: "json")
        let response = DummySpitServiceResponse(filePath: filePath!, header: ["Content-type": "application/json"], urlComponentToMatch: "foobar")
        DummySpitURLProtocol.cannedResponse(response)
      }
      
      afterEach {
        DummySpitURLProtocol.cannedResponse(nil)
      }
      
      it("can be retrieved") {
        var called = false
        
        api?.getAccount("foobar") { account in
          called = true
          expect(account.name).to(equal("foobar"))
        }
        
        expect{called}.toEventually(beTruthy())
      }
    }
    
    describe("All Projects") {
      beforeEach {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let urlProtocolClass: AnyObject = ClassUtility.classFromType(DummySpitURLProtocol.self)
        configuration.protocolClasses = [urlProtocolClass]
        api = BuildboxApi("123abc", scheme: "mock", configuration: configuration)
        
        let filePath = NSBundle(forClass: BuildboxApiSpec.self).pathForResource("projects", ofType: "json")
        let response = DummySpitServiceResponse(filePath: filePath!, header: ["Content-type": "application/json"], urlComponentToMatch: "projects")
        DummySpitURLProtocol.cannedResponse(response)
      }
      
      afterEach {
        DummySpitURLProtocol.cannedResponse(nil)
      }
      
      it("can be retrieved") {
        var called = false
        
        api?.getProjects("dummyspit") { projects in
          called = true
          expect(projects.count).to(equal(3))
        }

        expect{called}.toEventually(beTruthy())
      }
    }
    
    describe("A single Project") {
      beforeEach {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let urlProtocolClass: AnyObject = ClassUtility.classFromType(DummySpitURLProtocol.self)
        configuration.protocolClasses = [urlProtocolClass]
        api = BuildboxApi("123abc", scheme: "mock", configuration: configuration)
        
        let filePath = NSBundle(forClass: BuildboxApiSpec.self).pathForResource("foobar_project", ofType: "json")
        let response = DummySpitServiceResponse(filePath: filePath!, header: ["Content-type": "application/json"], urlComponentToMatch: "foobar")
        DummySpitURLProtocol.cannedResponse(response)
      }
      
      afterEach {
        DummySpitURLProtocol.cannedResponse(nil)
      }
      
      it("can be retrieved") {
        var called = false
        
        api?.getProject("dummyspit", projectName: "foobar") { project in
          called = true
          expect(project.name).to(equal("Project3"))
        }

        expect{called}.toEventually(beTruthy())
      }
    }
    
    describe("All Builds for a project") {
      beforeEach {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let urlProtocolClass: AnyObject = ClassUtility.classFromType(DummySpitURLProtocol.self)
        configuration.protocolClasses = [urlProtocolClass]
        api = BuildboxApi("123abc", scheme: "mock", configuration: configuration)
        
        let filePath = NSBundle(forClass: BuildboxApiSpec.self).pathForResource("builds", ofType: "json")
        let response = DummySpitServiceResponse(filePath: filePath!, header: ["Content-type": "application/json"], urlComponentToMatch: "builds")
        DummySpitURLProtocol.cannedResponse(response)
      }
      
      afterEach {
        DummySpitURLProtocol.cannedResponse(nil)
      }
      
      it("can be retrieved") {
        var called = false
        
        api?.getBuilds("foobar", projectName: "Project1") { builds in
          called = true
          expect(builds.count).to(equal(7))
        }
        
        expect{called}.toEventually(beTruthy())
      }
    }
    
    describe("All Builds for a user") {
      beforeEach {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let urlProtocolClass: AnyObject = ClassUtility.classFromType(DummySpitURLProtocol.self)
        configuration.protocolClasses = [urlProtocolClass]
        api = BuildboxApi("123abc", scheme: "mock", configuration: configuration)
        
        let filePath = NSBundle(forClass: BuildboxApiSpec.self).pathForResource("all_builds", ofType: "json")
        let response = DummySpitServiceResponse(filePath: filePath!, header: ["Content-type": "application/json"], urlComponentToMatch: "builds")
        DummySpitURLProtocol.cannedResponse(response)
      }
      
      afterEach {
        DummySpitURLProtocol.cannedResponse(nil)
      }
      
      it("can be retrieved") {
        var called = false
        
        api?.getBuilds { builds in
          called = true
          expect(builds.count).to(equal(30))
        }
        
        expect{called}.toEventually(beTruthy())
      }
    }
    
    describe("A single Build") {
      beforeEach {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let urlProtocolClass: AnyObject = ClassUtility.classFromType(DummySpitURLProtocol.self)
        configuration.protocolClasses = [urlProtocolClass]
        api = BuildboxApi("123abc", scheme: "mock", configuration: configuration)
        
        let filePath = NSBundle(forClass: BuildboxApiSpec.self).pathForResource("single_build", ofType: "json")
        let response = DummySpitServiceResponse(filePath: filePath!, header: ["Content-type": "application/json"], urlComponentToMatch: "1")
        DummySpitURLProtocol.cannedResponse(response)
      }
      
      afterEach {
        DummySpitURLProtocol.cannedResponse(nil)
      }
      
      it("can be retrieved") {
        var called = false
        
        api?.getBuild("foobar", projectName: "Project1", number: 1) { build in
          called = true
          expect(build.number).to(equal(1))
          expect(build.message).to(equal("add in buildbox script"))
        }
        
        expect{called}.toEventually(beTruthy())
      }
    }
    
    describe("All Agents") {
      beforeEach {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let urlProtocolClass: AnyObject = ClassUtility.classFromType(DummySpitURLProtocol.self)
        configuration.protocolClasses = [urlProtocolClass]
        api = BuildboxApi("123abc", scheme: "mock", configuration: configuration)
        
        let filePath = NSBundle(forClass: BuildboxApiSpec.self).pathForResource("agents", ofType: "json")
        let response = DummySpitServiceResponse(filePath: filePath!, header: ["Content-type": "application/json"], urlComponentToMatch: "agents")
        DummySpitURLProtocol.cannedResponse(response)
      }
      
      afterEach {
        DummySpitURLProtocol.cannedResponse(nil)
      }
      
      it("can be retrieved") {
        var called = false
        
        api?.getAgents("foobar") { agents in
          called = true
          expect(agents.count).to(equal(1))
        }
        
        expect{called}.toEventually(beTruthy())
      }
    }
  }
}
