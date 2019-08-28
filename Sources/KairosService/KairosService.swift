import Foundation
import HTTP
import Vapor

public protocol KairosProvider: Service {
  func healthStatus(on container: Container) throws -> Future<Response>
  func healthCheck(on container: Container) throws -> Future<Response>
}

public struct Kairos: KairosProvider {
  
  let text = "Kairos Service is alive!"
  
  let demoBaseUrlPath = "http://localhost:8090/api/v1"
  
  
  public init() {
    
  }

  public func alive(on container: Container) -> String {
    return text
  }
  
  public func healthStatus(on container: Container) throws -> Future<Response> {
    return try getRequest(endpoint: "health/status", on: container)
  }
  
  public func healthCheck(on container: Container) throws -> Future<Response> {
    return try getRequest(endpoint: "health/check", on: container)
  }
  


}


extension Kairos {
  
  func getRequest(endpoint: String, on container: Container) throws -> Future<Response> {
    
    let checkUrlPath = "\(demoBaseUrlPath)/\(endpoint)"
    print(checkUrlPath)
    
    // Headers to send to remote API
    var headers: HTTPHeaders = [:]
    // Copy from client request or if missing use defaults
    headers.add(name: .accept, value: "application/json")
    headers.add(name: .acceptEncoding, value: "deflate")
    
    let client = try container.make(Client.self)
    
    return client.get(checkUrlPath)

  }
  
}
