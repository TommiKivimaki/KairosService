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
    public let start_absolute: Int?
    public let end_absolute: Int?
    public let start_relative: Int?
    public let end_relative: Int?
    public let metrics: [Metric]
    
    //
    public init(start_absolute: Int?, start_relative: Int?, end_absolute: Int?, end_relative: Int?, metrics: [Metric]) {
      self.start_absolute = start_absolute
      self.end_absolute = end_absolute
      self.start_relative = start_relative
      self.end_relative = end_relative
      self.metrics = metrics
    }
    
    
    
    public struct Metric: Content {
      public let name: String
      public let limit: Int
      public let aggregators: [Aggregator]?
      
      public init(name: String, limit: Int, aggregators: [Aggregator]?) {
        self.name = name
        self.limit = limit
        self.aggregators = aggregators
      }
    }
  }
  
  
  // Aggregators
  struct Aggregators: Content {
    let aggregator: [Aggregator]
  }
  
  struct Aggregator: Content {
    let name: String
    let sampling: Sampling
  }
  
  struct Sampling: Content {
    let value: Int
    let unit: String
  }
  
}
