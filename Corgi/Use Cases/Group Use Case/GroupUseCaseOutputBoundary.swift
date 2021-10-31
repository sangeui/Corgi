//
//  GroupUseCaseOutputBoundary.swift
//  Corgi
//
//  Created by 서상의 on 2021/10/30.
//

import Foundation

enum GroupUseCaseMessage {
    case success(GroupUseCase)
    case failure(GroupUseCase)
}

enum GroupUseCase {
    case create(String? = nil),
         read(String? = nil),
         update(String? = nil),
         delete(String? = nil),
         clear(String? = nil)
}

protocol GroupUseCaseOutputBoundary: AnyObject {
    func send(groups: [Group])
    func message(_ message: GroupUseCaseMessage)
}

extension GroupUseCaseOutputBoundary {
    func send(groups: [Group]) { }
    func message(_ message: GroupUseCaseMessage) { }
}
