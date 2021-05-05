//
//  CrossoverService.swift
//  GeneticLab
//
//  Created by Kirill Varshamov on 05.05.2021.
//

import Foundation

class CrossoverService {
    func singlePointCrossover(_ firstCreature: Creature, _ secondCreature: Creature, complition: @escaping (Creature, Creature) -> Void) {
        
        let creatureLenght = firstCreature.genes.count
        
        let crossIndex = Int.random(in: 1..<creatureLenght-1)
        
        let firstFCPart = Array(firstCreature.genes[0..<crossIndex])
        let secondFCPart = Array(firstCreature.genes[crossIndex..<firstCreature.genes.count])
        
        let firstSCPart = Array(secondCreature.genes[0..<crossIndex])
        let secondSCPart = Array(secondCreature.genes[crossIndex..<secondCreature.genes.count])
        
        let firstNewCreature = Creature(firstHalf: firstFCPart, secondHalf: secondSCPart)
        let secondNewCreature = Creature(firstHalf: firstSCPart, secondHalf: secondFCPart)
        
        complition(firstNewCreature, secondNewCreature)
    }
    
    func doublePointCrossover(_ firstCreature: Creature, _ secondCreature: Creature, complition: @escaping (Creature, Creature) -> Void) {
        
        let creatureLenght = firstCreature.genes.count

        let crossIndex1 = Int.random(in: 1..<creatureLenght / 2)
        let crossIndex2 = Int.random(in: creatureLenght / 2..<creatureLenght - 1)
        
        let firstFCPart = Array(firstCreature.genes[0..<crossIndex1])
        let secondFCPart = Array(firstCreature.genes[crossIndex1..<crossIndex2])
        let thirdFCPart = Array(firstCreature.genes[crossIndex2..<firstCreature.genes.count])
        
        let firstSCPart = Array(secondCreature.genes[0..<crossIndex1])
        let secondSCPart = Array(secondCreature.genes[crossIndex1..<crossIndex2])
        let thirdSCPart = Array(secondCreature.genes[crossIndex2..<firstCreature.genes.count])
        
        let firstNewCreature = Creature(firstPart: firstFCPart, secondPart: secondSCPart, thirdPart: thirdFCPart)
        let secondNewCreature = Creature(firstPart: firstSCPart, secondPart: secondFCPart, thirdPart: thirdSCPart)
        
        complition(firstNewCreature, secondNewCreature)
    }
    
    func singleGeneCrossover(_ firstCreature: Creature, _ secondCreature: Creature, complition: @escaping (Creature, Creature) -> Void) {
        
        let creatureLenght = firstCreature.genes.count

        let crossIndex = Int.random(in: 1..<creatureLenght-1)
        
        let firstCreatureGene = firstCreature.genes[crossIndex]
        let secondCreatureGene = secondCreature.genes[crossIndex]
        
        var firstCreatureGenes = firstCreature.genes
        firstCreatureGenes[crossIndex] = secondCreatureGene
        
        let newFirstCreature = Creature(genes: firstCreatureGenes)
        
        var secondCreatureGenes = secondCreature.genes
        secondCreatureGenes[crossIndex] = firstCreatureGene
        
        let newSecondCreature = Creature(genes: secondCreatureGenes)
        
        complition(newFirstCreature, newSecondCreature)
    }
}
