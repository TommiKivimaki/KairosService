//
//  Message.swift
//  Async
//
//  Created by Tommi Kivimäki on 28/08/2019.
//

import Foundation
import Vapor

public extension Kairos {
  
  public struct Message: Content {
    public let startAbsolute: Int?
    public let endAbsolute: Int?
    public let startRelative: Int?
    public let endRelative: Int?
    public let metrics: [Metric]
    
    private enum CodingKeys: String, CodingKey {
      case startAbsolute = "start_absolute"
      case endAbsolute = "end_absolute"
      case startRelative = "start_relative"
      case endRelative = "end_relative"
      case metrics
    }
    

    public init(startAbsolute: Int? = nil, startRelative: Int? = nil,
                endAbsolute: Int? = nil, endRelative: Int? = nil, metrics: [Metric]) {
      self.startAbsolute = startAbsolute
      self.endAbsolute = endAbsolute
      self.startRelative = startRelative
      self.endRelative = endRelative
      self.metrics = metrics
    }
    
    
    public struct Metric: Content {
//      public let tags: String?
      public let tags: [String:[String]]?
      public let name: String?
      public let limit: Int?
      public let aggregators: [Aggregator]?
      
//      public init(tags: Tags? = nil, name: String? = nil, limit: Int? = nil, aggregators: [Aggregator]? = nil) {
      public init(tags: [String:[String]]? = nil, name: String? = nil, limit: Int? = nil, aggregators: [Aggregator]? = nil) {
        self.tags = tags
        self.name = name
        self.limit = limit
        self.aggregators = aggregators
      }
    }
    
    //
    // Structs for metrics
    //
    
    // Aggregators
    public struct Aggregator: Content {
      public let name: String
      public let sampling: Sampling
      
      public init(name: String, sampling: Sampling) {
        self.name = name
        self.sampling = sampling
      }
    }
    
    public struct Sampling: Content {
      public let value: Int
      public let unit: String
      
      public init(value: Int, unit: String) {
        self.value = value
        self.unit = unit
      }
    }
  }
  
}
