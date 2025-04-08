//
//  furniture.swift
//  ARchitect
//
//  Created by Ivan Li on 3/31/25.
//
import SwiftUI

public struct FurnitureItem: Identifiable {
	public let id = UUID()
	public let name: String
	public let type: String
	public let tags: [String]
	public let imageName: String
}
