import Foundation
import Vapor

public protocol KairosProvider: Service {
  func check(on container: Container) throws -> Future<Response>
}

public struct Kairos: KairosProvider {
  
  var text = "Hello, World!"
  
  let demoBaseUrlPath = "http://localhost:8081/api/v1"
  
  
  public init() {
    
  }

  public func textii(on container: Container) -> String {
    return text
  }
  
  public func check(on container: Container) throws -> Future<Response> {
    return try getRequest(endpoint: "health/status", on: container)
  }

}


extension Kairos {
  
  func getRequest(endpoint: String, on container: Container) throws -> Future<Response> {
    
    let checkUrlPath = "\(demoBaseUrlPath)/\(endpoint)"
    
    let client = try container.make(Client.self)
    
    return client.get(checkUrlPath)
  }
}
