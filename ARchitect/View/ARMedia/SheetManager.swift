//
//  SheetManager.swift
//  ARchitect
//
//  Created by Meherika Majumdar on 19/2/25.
//

import Foundation

@Observable
final class SheetManager: ObservableObject{
    enum Action{
        case na
        case present
        case dismiss
    }
    private(set) var action: Action = .na
    
    func present(){
        guard action != .present else { return } //to ensure we don't have multiple pop ups
        self.action = .present
    }
    
    func dismiss(){
        self.action = .dismiss
    }
    
    var isPresented: Bool { self.action == .present }
}

