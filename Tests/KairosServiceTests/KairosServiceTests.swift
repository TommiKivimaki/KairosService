import XCTest
import Vapor
@testable import KairosService

final class KairosServiceTests: XCTestCase {
  
  var app: Application!
  var kairos: Kairos!
  var container: Container!
  
  static var allTests = [
    ("testAlive", testAlive),
    ("testHealthStatus", testHealthStatus),
    ("testHealthCheck", testHealthCheck),
    ("testFeatures", testFeatures),
    ("testMetricNames", testMetricNames),
    ("testTagNames", testTagNames),
    ("testTagValues", testTagValues),
    ("testVersion", testVersion),
    ("testRollups", testRollups)
  ]
  
  override func setUp() {
    let config = Config.default()
    var services = Services.default()
    kairos = Kairos(dbPath: "http://localhost:8090/api/v1")
    services.register(kairos)
    
    app = try! Application(config: config, services: services)
    
    // We need a container to execute queries
    container = try! self.container()
  }
  
  override func tearDown() {
    kairos = nil
    app = nil
  }
  
  
  func testAlive() {

    let response = kairos.alive(on: container)
    
    XCTAssertEqual(response, "Kairos Service is alive!")
  }

  
  func testHealthStatus() throws {

    let expectedResponse = "[\"JVM-Thread-Deadlock: OK\",\"Datastore-Query: OK\"]"

    let response = try! kairos.healthStatus(on: container).wait()

    XCTAssertEqual(response.http.body.description, expectedResponse)
  }
  
  
  func testHealthCheck() throws {

    let response = try! kairos.healthCheck(on: container).wait()

    XCTAssertEqual(response.http.status, HTTPResponseStatus.noContent)
  }
 
  
  func testFeatures() throws {
  
    let response = try! kairos.features(on: container).wait()
    
    XCTAssertEqual(response.http.status, HTTPResponseStatus.ok)
    XCTAssertNotNil(response.http.body)
  }
  
  
  func testMetricNames() throws {
    
    let response = try! kairos.metricNames(on: container).wait()
    
    XCTAssertEqual(response.http.status, HTTPResponseStatus.ok)
    XCTAssertNotNil(response.http.body)
    XCTAssertTrue(response.http.body.description.contains("results"))
  }
  
  
  func testTagNames() throws {
    
    let response = try! kairos.tagNames(on: container).wait()
    
    XCTAssertEqual(response.http.status, HTTPResponseStatus.ok)
    XCTAssertNotNil(response.http.body)
  }
  
  
  func testTagValues() throws {
    
    let response = try! kairos.tagValues(on: container).wait()
    
    XCTAssertEqual(response.http.status, HTTPResponseStatus.ok)
    XCTAssertNotNil(response.http.body)
  }
  
  
  func testVersion() throws {
    
    let response = try! kairos.version(on: container).wait()
    
    XCTAssertEqual(response.http.status, HTTPResponseStatus.ok)
    XCTAssertNotNil(response.http.body.description)
  }
  
  
  func testRollups() throws {
    
//    let response = try! kairos.getRollups(on: container).wait()
//
//    XCTAssertEqual(response.http.status, HTTPResponseStatus.ok)
//    XCTAssertNotNil(response.http.body.description)
  }
  
  
  func testAggregatorQuery() throws {
    
    let countAggregator =
      Kairos.Message.Aggregator(name: "count",
                                sampling: Kairos.Message.Sampling(value: 10,
                                              unit: "seconds"))
    let metric = Kairos.Message.Metric(name: "example_metric1", limit: 100, aggregators: [countAggregator])
    
    let message = Kairos.Message(startAbsolute: 1564056000000, startRelative: nil,
                                 endAbsolute: 1564066600000, endRelative: nil,
                                 metrics: [metric])
    
    let response = try! kairos.queryMetrics(message, on: container).wait()
   
    print(response.http.body)
    XCTAssertEqual(response.http.status, HTTPResponseStatus.ok)
    XCTAssertNotNil(response.http.body.description)
  }
  
  
  func testAbsoluteMetricQuery() throws {
    
    let metric = Kairos.Message.Metric(tags: nil, name: "example_metric1", limit: 10, aggregators: nil)
    let message = Kairos.Message(startAbsolute: 1566646250000, startRelative: nil,
                                 endAbsolute: 1566647999000, endRelative: nil,
                                 metrics: [metric])
    
    let response = try! kairos.queryMetrics(message, on: container).wait()
    
    print(response.http.body.description)
    XCTAssertEqual(response.http.status, HTTPResponseStatus.ok)
    XCTAssertNotNil(response.http.body)
  }
  
  
  func testRelativeMetricQuery() throws {
    
    let metric = Kairos.Message.Metric(tags: nil, name: "example_metric2", limit: 10, aggregators: nil)
    let startRelative = Kairos.Message.RelativeTime(value: "74", unit: "days")
    let endRelative = Kairos.Message.RelativeTime(value: "73", unit: "days")
    let message = Kairos.Message(startRelative: startRelative, endRelative: endRelative, metrics: [metric])
  
    let response = try! kairos.queryMetrics(message, on: container).wait()
    
    print(response.http.body.description)
    XCTAssertEqual(response.http.status, HTTPResponseStatus.ok)
    XCTAssertNotNil(response.http.body)
  }
  
  
  func testRelativeMetricQueryWithoutEndTime() throws {
    
    let metric = Kairos.Message.Metric(tags: nil, name: "example_metric2", limit: 10, aggregators: nil)
    let startRelative = Kairos.Message.RelativeTime(value: "74", unit: "days")
    let message = Kairos.Message(startRelative: startRelative, endRelative: nil, metrics: [metric])
  
    let response = try! kairos.queryMetrics(message, on: container).wait()
    
    print(response.http.body.description)
    XCTAssertEqual(response.http.status, HTTPResponseStatus.ok)
    XCTAssertNotNil(response.http.body)
  }
  
  
  func testAbsoluteMetricQueryFilteredByTags() throws {
    
    let metric = Kairos.Message.Metric(tags: ["unitId" : ["example_unit2"]], name: "example_metric2", limit: 10)
    let message = Kairos.Message(startAbsolute: 1566635048000, endAbsolute: 1566647999000, metrics: [metric])
    
    let response = try! kairos.queryMetrics(message, on: container).wait()
    
    print(response.http.body.description)
    XCTAssertEqual(response.http.status, HTTPResponseStatus.ok)
    XCTAssertNotNil(response.http.body)
  }
  
  
  func testAbsoluteMetricQueryGroupedByTags() throws {
    
    let groupBy = Kairos.Message.GroupByTag(tags: ["unitId"])
    let metric = Kairos.Message.Metric(name: "example_metric1", limit: 10, groupBy: [groupBy])
    let message = Kairos.Message(startAbsolute: 1566635048000, endAbsolute: 1566647999000, metrics: [metric])
    
    let response = try! kairos.queryMetrics(message, on: container).wait()
    
    print(response.http.body.description)
    XCTAssertEqual(response.http.status, HTTPResponseStatus.ok)
    XCTAssertNotNil(response.http.body)
  }
  
  func testQueryMetricTags() throws {
    
    
    let tags: [String: [String]] = ["unitId": ["example_unit1"]]
    let metric = Kairos.Message.Metric(tags: tags,
                                       name: "example_metric1",
                                       limit: 30,
                                       aggregators: nil)
    
    let message = Kairos.Message(startAbsolute: 1566195599000,
                                 endAbsolute: 1566647999000,
                                 metrics: [metric])
    
    let response = try! kairos.queryMetricTags(message, on: container).wait()
    
    print(response.http.body.description)
    XCTAssertEqual(response.http.status, HTTPResponseStatus.ok)
    XCTAssertNotNil(response.http.body.description)
    
  }
}





