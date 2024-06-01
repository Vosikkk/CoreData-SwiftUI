//
//  SearchConfig.swift
//  ElseCoreData
//
//  Created by Саша Восколович on 01.06.2024.
//

import Foundation


struct SearchConfig: Equatable {
    
    enum Filter: CaseIterable {
        case all, fave
        
        var displayName: String {
            switch self {
            case .all:
                "All"
            case .fave:
                "Favourites"
            }
        }
    }
    
    var query: String = ""
    var filter: Filter = .all
        
}

enum Sort: CaseIterable {
    case asc, desc
    
    var displayName: String {
        switch self {
        case .asc:
            "Asc"
        case .desc:
            "Desc"
        }
    }
    
    var systemImage: String {
        switch self {
        case .asc:
            "arrow.up"
        case .desc:
            "arrow.down"
        }
    }
}
