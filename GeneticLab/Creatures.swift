//
//  Creations.swift
//  GeneticLab
//
//  Created by Vladimir Barus on 30.04.2021.
//

import Foundation

class Creature {
    
    var genes: [Gene]
    
    var weight: Int {
        
        var w = 0
        
        for (index, gene) in genes.enumerated() {
            
            if index + 1 == genes.count {
                break
            }
            
            w += gene.computeWeight(genes[index + 1])
        }
        
        return w
    }
    
    init(startGene: Gene, endGene: Gene, lenght: Int) {
        genes = []
        genes.append(startGene)
        
        // fill
        for _ in 0..<lenght-2 {
            let randNumber = Int.random(in: 0..<Gene.count)
            let gene = Gene(rawValue: randNumber)!
            genes.append(gene)
        }
        
        genes.append(endGene)
    }
    
    // cross initialization
    init(firstHalf: [Gene], secondHalf: [Gene]) {
        genes = firstHalf + secondHalf
    }
    
    init(firstPart: [Gene], secondPart: [Gene], thirdPart: [Gene]) {
        genes = firstPart + secondPart + thirdPart
    }
    
    init(genes: [Gene]) {
        self.genes = genes
    }
    
    func mutating() {
        let index = Int.random(in: 1..<genes.count-1)
        
        genes[index] = Gene.randomGene()
    }
}

extension Creature: CustomStringConvertible {
    var description: String {
        var desc = "[ "
        
        for gene in genes {
            desc += "\(gene) "
        }
        desc += "] - with weight \(weight)"
        
        return desc
    }
}
