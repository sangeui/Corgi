//
//  AppearanceUseCaseOutputBoundary.swift
//  Corgi
//
//  Created by 서상의 on 2021/10/30.
//

import Foundation

protocol AppearanceUseCaseOutputBoundary: AnyObject {
    func send(appearance: Int)
}
