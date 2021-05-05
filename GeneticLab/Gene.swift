//
//  Gen.swift
//  GeneticLab
//
//  Created by Vladimir Barus on 30.04.2021.
//

import Foundation

enum Gene: Int {
    
    static let count = 8
    
    case a = 0
    case b = 1
    case c = 2
    case d = 3
    case e = 4
    case f = 5
    case g = 6
    case h = 7
    
    static func randomGene() -> Gene {
        let random = Int.random(in: 0..<count)
        
        return Gene(rawValue: random)!
    }
    
    func computeWeight(_ nextGene: Gene) -> Int {
   
        guard self != nextGene else {
            return 0
        }
        
        switch self {
        case .a:
            switch nextGene {
            case .b:
                return 1
            case .c:
                return 2
            case .d:
                return 3
            case .e:
                return 4
            case .f:
                return 5
            case .g:
                return 6
            case .h:
                return 7
            default:
                return 0
            }
        case .b:
            switch nextGene {
            case .a:
                return 1
            case .c:
                return 1
            case .d:
                return 2
            case .e:
                return 3
            case .f:
                return 4
            case .g:
                return 5
            case .h:
                return 6
            default:
                return 0
            }
        case .c:
            switch nextGene {
            case .a:
                return 2
            case .b:
                return 1
            case .d:
                return 1
            case .e:
                return 2
            case .f:
                return 3
            case .g:
                return 4
            case .h:
                return 5
            default:
                return 0
            }
        case .d:
            switch nextGene {
            case .a:
                return 3
            case .b:
                return 2
            case .c:
                return 1
            case .e:
                return 1
            case .f:
                return 2
            case .g:
                return 3
            case .h:
                return 4
            default:
                return 0
            }
        case .e:
            switch nextGene {
            case .a:
                return 4
            case .b:
                return 3
            case .c:
                return 2
            case .d:
                return 1
            case .f:
                return 1
            case .g:
                return 2
            case .h:
                return 3
            default:
                return 0
            }
        case .f:
            switch nextGene {
            case .a:
                return 5
            case .b:
                return 4
            case .c:
                return 3
            case .d:
                return 2
            case .e:
                return 1
            case .g:
                return 1
            case .h:
                return 2
            default:
                return 0
            }
        case .g:
            switch nextGene {
            case .a:
                return 6
            case .b:
                return 5
            case .c:
                return 4
            case .d:
                return 3
            case .e:
                return 2
            case .f:
                return 1
            case .h:
                return 1
            default:
                return 0
            }
        case .h:
            switch nextGene {
            case .a:
                return 7
            case .b:
                return 6
            case .c:
                return 5
            case .d:
                return 4
            case .e:
                return 3
            case .f:
                return 2
            case .g:
                return 1
            default:
                return 0
            }
        }
    }
}


