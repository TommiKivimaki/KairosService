import Foundation
import HTTP
import Vapor

public protocol KairosProvider: Service {
  func healthStatus(on container: Container) throws -> Future<Response>
  func healthCheck(on container: Container) throws -> Future<Response>
  func queryMetrics(_ content: Kairos.Message, on container: Container) throws -> Future<Response>
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
  
  public func queryMetrics(_ content: Message, on container: Container) throws -> Future<Response> {
    return try postRequest(content, endpoint: "datapoints/query", on: container)
  }

}


extension Kairos {
  
  private func process(_ response: Response) throws -> Response {
    switch true {
    case response.http.status.code == HTTPStatus.ok.code:
      return response
    default:
      throw Abort(.internalServerError)
    }
  }
  
  private func getRequest(endpoint: String, on container: Container) throws -> Future<Response> {
    let urlPath = "\(demoBaseUrlPath)/\(endpoint)"
    print(urlPath)
    
    // Headers to send to remote API
    var headers: HTTPHeaders = [:]
    // Copy from client request or if missing use defaults
    headers.add(name: .accept, value: "application/json")
    headers.add(name: .acceptEncoding, value: "deflate")
    
    let client = try container.make(Client.self)
    
    return client
      .get(urlPath, headers: headers)
      .map { response in
        try self.process(response)
    }
  }
  
  
  private func postRequest(_ content: Message, endpoint: String, on container: Container) throws -> Future<Response> {
    let urlPath = "\(demoBaseUrlPath)/\(endpoint)"
    print(urlPath)
    
    // Headers to send to remote API
    var headers: HTTPHeaders = [:]
    // Copy from client request or if missing use defaults
    headers.add(name: .accept, value: "application/json")
    headers.add(name: .acceptEncoding, value: "deflate")
    
    let client = try container.make(Client.self)
    
    return client
      .post(urlPath, headers: headers) { req in
        try req.content.encode(content)
      }
      .map { response in
        try self.process(response)
    }
  }
  
}
