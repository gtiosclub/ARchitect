//
//  EnvironmentModel.swift
//  ARchitect
//
//  Created by Dhairya Patel on 4/6/25.
//

import Foundation

struct EnvironmentModel {
    let id: UUID
    let name: String

    init(forPostID id: UUID) {
        self.id = id
        self.name = "Living Room AR"
    }
}
