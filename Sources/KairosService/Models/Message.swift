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
    public let start_absolute: Int
    public let end_absolute: Int
    public let metrics: [Metric]
    
    public init(start_absolute: Int, end_absolute: Int, metrics: [Metric]) {
      self.start_absolute = start_absolute
      self.end_absolute = end_absolute
      self.metrics = metrics
    }
  }
  
  
  public struct Metric: Content {
    public let name: String
    public let limit: Int
    
    public init(name: String, limit: Int) {
      self.name = name
      self.limit = limit
    }
  }
}
