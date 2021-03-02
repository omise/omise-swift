//
//  BankStatus.swift
//  OmiseSwift
//
//  Created by ponpol on 1/3/2564 BE.
//  Copyright © 2564 BE Omise. All rights reserved.
//

import Foundation

public struct BankStatus: Codable, Hashable {
   public let code: String
   public let name: String
   public let active: Bool
}
