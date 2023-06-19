//
//  ModelResource.swift
//  Desafio Mobile
//
//  Created by Arthur on 17/06/2023.
//  Copyright © 2023 Arthur. All rights reserved.
//

import Foundation

struct WelcomeElement: Codable {
    let resource: Resource
}

// MARK: - Resource
struct Resource: Codable {
    let createdAt, updatedAt: Int?
    let resourceID, moduleID, value, languageID: String
    
    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case resourceID = "resource_id"
        case moduleID = "module_id"
        case value
        case languageID = "language_id"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        createdAt = try container.decodeIfPresent(Int.self, forKey: .createdAt)
        updatedAt = try container.decodeIfPresent(Int.self, forKey: .updatedAt)
        resourceID = try container.decode(String.self, forKey: .resourceID)
        moduleID = try container.decode(String.self, forKey: .moduleID)
        value = try container.decode(String.self, forKey: .value)
        languageID = try container.decode(String.self, forKey: .languageID)
    }
}


