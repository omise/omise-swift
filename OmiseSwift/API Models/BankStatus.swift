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

   private enum CodingKeys: String, CodingKey {
        case code
        case name
        case active
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        name = try container.decode(String.self, forKey: .name)
        code = try container.decode(String.self, forKey: .code)
        active = try container.decode(Bool.self, forKey: .active)

    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(name, forKey: .name)
        try container.encode(code, forKey: .code)
        try container.encode(active, forKey: .active)
    }
}
