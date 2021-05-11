//
//  EntryError.swift
//  CloudKitJournal
//
//  Created by Tiffany Sakaguchi on 5/10/21.
//  Copyright © 2021 Zebadiah Watson. All rights reserved.
//

import Foundation

enum EntryError: LocalizedError {
    case ckError(Error)
    case couldNotUnwrap
    
    var errorDescription: String {
        switch self {
        case .ckError(let error):
            return error.localizedDescription
        case .couldNotUnwrap:
            return "Entry could not be unwrapped, which is not entry."
        }
    }
}
