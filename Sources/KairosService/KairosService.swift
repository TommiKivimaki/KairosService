import Foundation
import Vapor

public protocol KairosProvider: Service {
  func check(on container: Container) throws -> Future<Response>
}

public struct Kairos: KairosProvider {
  
  let text = "Kairos Service is alive!"
  
  let demoBaseUrlPath = "http://localhost:8090/api/v1"
  
  
  public init() {
    
  }

  public func alive(on container: Container) -> String {
    return text
  }
  
  public func check(on container: Container) throws -> Future<Response> {
    return try getRequest(endpoint: "health/status", on: container)
  }

}


extension Kairos {
  
  func getRequest(endpoint: String, on container: Container) throws -> Future<Response> {
    
    let checkUrlPath = "\(demoBaseUrlPath)/\(endpoint)"
    print(checkUrlPath)
    
    let client = try container.make(Client.self)
    
    return client.get(checkUrlPath)
  }
}
