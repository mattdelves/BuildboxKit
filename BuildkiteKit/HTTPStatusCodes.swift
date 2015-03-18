//
//  HTTPStatusCodes.swift
//  BuildkiteKit
//
//  Created by Matthew Delves on 18/03/2015.
//  Copyright (c) 2015 Matthew Delves. All rights reserved.
//

import Foundation

public struct HTTPResponseCodes {
  static let Continue = 100

  static let Success = 200
  static let Created = 201
  static let Accepted = 202
  static let NonAuthoritativeInformation = 203
  static let NoContent = 204
  static let PartialContent = 206
  static let MultiStatus = 207
  static let AlreadyReported = 208
  static let IMUsed = 226

  static let MultipleChoices = 300
  static let MovedPermanently = 301
  static let Found = 302
  static let SeeOther = 303
  static let NotModified = 304
  static let UseProxy = 305
  static let SwitchProxy = 306
  static let TemporaryRedirect = 307
  static let PermanentRedirect = 308

  static let BadRequest = 400
  static let Unauthorized = 401
  static let PaymentRequired = 402
  static let Forbidden = 403
  static let NotFound = 404
  static let MethodNotAllowed = 405
  static let NotAcceptable = 406
  static let ProxyAuthenticationRequired = 407
  static let RequestTimeout = 408
  static let Conflict = 409
  static let Gone = 410
  static let LengthRequired = 411
  static let PreconditionFailed = 412
  static let RequestEntityTooLarge = 413
  static let ImATeapot = 418
  static let EnhanceYourCalm = 420
  static let UnprocessableEntity = 422
  static let Locked = 423
  static let FailedDependency = 424
  static let UnorderedCollection = 425
  static let UpgradeRequired = 426
  static let TooManyRequests = 429
  static let RequestHeaderFieldsTooLarge = 431
  static let NoResponse = 444
  static let BlockedByWindowsParentalControls = 450
  static let UnavailableForLegalReasons = 451
  static let RequestHeaderTooLarge = 494

  static let InternalServerError = 500
  static let NotImplemented = 501
  static let BadGateway = 502
  static let ServiceUnavailable = 503
  static let GatewayTimeout = 504
  static let VariantAlsoNegotiates = 506
  static let InsufficientStorage = 507
  static let LoopDetected = 508
  static let BandwidthLimitExceeded = 509
  static let NotExtended = 510
}
