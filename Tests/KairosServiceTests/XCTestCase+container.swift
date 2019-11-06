//
//  XCTestCase+container.swift
//  Async
//
//  Created by Tommi Kivimäki on 04/09/2019.
//

import XCTest
import Vapor
import KairosService

extension XCTestCase {
  
  internal func container() throws -> Container {
    var services = Services.default()
    services.register(Kairos(dbPath: "http://localhost:8090/api/v1"), as: Kairos.self)
    let worker = EmbeddedEventLoop()
    
    return BasicContainer(
      config: Config.default(),
      environment: .testing,
      services: services,
      on: worker
    )
  }
}
