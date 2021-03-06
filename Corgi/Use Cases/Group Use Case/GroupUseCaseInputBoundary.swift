//
//  GroupUseCaseInputBoundary.swift
//  Corgi
//
//  Created by 서상의 on 2021/10/30.
//

import Foundation

protocol GroupUseCaseInputBoundary {
    func read()
    func update(group: Group)
    func delete(uuid: UUID)
    func clear()
}
