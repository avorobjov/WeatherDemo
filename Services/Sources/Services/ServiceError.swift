//
//  File.swift
//  
//
//  Created by Alexander Vorobjov on 1/17/21.
//

import Foundation

public enum ServiceError: Error {
    case parseError
    case loadError
    case noInternetConnection
    case notFound
}
