//
//  Message.swift
//  Async
//
//  Created by Tommi Kivimäki on 28/08/2019.
//

import Foundation
import Vapor

extension Kairos {
  
  public struct Message: Content {
    
    public let start_Absolute: Int
    public let end_absolute: Int
    public let metrics: [Metric]
  }
  
  
  public struct Metric: Content {
    
    public let name: String
    public let limit: Int
  }
}


