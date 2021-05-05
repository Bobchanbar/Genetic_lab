//
//  ViewController.swift
//  GeneticLab
//
//  Created by Vladimir Barus on 22.04.2021.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var popSize: UITextField!
    @IBOutlet weak var genSize: UITextField!
    @IBOutlet weak var mutChance: UITextField!
    @IBOutlet weak var crossOptions: UIPickerView!
    @IBOutlet weak var resultView: UITextView!
    @IBOutlet weak var workingTypeChanger: UISegmentedControl!
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var tapButton: UIButton!
    
    @IBOutlet weak var generationSlider: UISlider!
    
    var population: [Creature] = []
    var crossoverType: CrossoverType = .onePoint
    let crossoverTypes = ["One point crossover", "Two points crossover", "Single gene crossover"]

    let startGene = Gene.a
    let endGene = Gene.g
    let creatureLenght = 30
    
    var generations: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func selection(generationCount: Int, populationSize: Int, mutationRate: Double) {
        DispatchQueue.global().async {
            for i in 0..<generationCount {
                
                for creature in self.population {
                    let randomNumber = Int.random(in: 0...100)
                    if Double(randomNumber) / 100.0 < mutationRate {
                        creature.mutating()
                    }
                }
                
                let originalPopulation = self.population
                
                for _ in 0..<self.population.count {
                    let firstCreature = originalPopulation.randomElement()!
                    let secondCreature = originalPopulation.randomElement()!
                    
                    if firstCreature !== secondCreature {
                        switch self.crossoverType {
                        case .onePoint:
                            self.singlePointCrossover(firstCreature, secondCreature, creatureLenght: self.creatureLenght)
                        case .twoPoint:
                            self.doublePointCrossover(firstCreature, secondCreature, creatureLenght: self.creatureLenght)
                        case .singleGene:
                            self.singleGeneCrossover(firstCreature, secondCreature, creatureLenght: self.creatureLenght)
                        }
                        
                    }
                }
                
                self.population.sort {
                    $0.weight < $1.weight
                }
                
                self.population = Array(self.population[0..<populationSize])
                
                var resultText = "Gen \(i + 1)"
                print("Gen \(i)")
                for creature in self.population {
                    resultText += "\n\(creature)"
                }
                self.generations.append(resultText)
                DispatchQueue.main.async {
                    self.resultView.text = resultText
                }
                
            }
            DispatchQueue.main.async {
                self.generationSlider.isHidden = false
            }
        }
        
    }
    
    func singlePointCrossover(_ firstCreature: Creature, _ secondCreature: Creature, creatureLenght: Int) {
        
        let crossIndex = Int.random(in: 1..<creatureLenght-1)
        
        let firstFCPart = Array(firstCreature.genes[0..<crossIndex])
        let secondFCPart = Array(firstCreature.genes[crossIndex..<firstCreature.genes.count])
        
        let firstSCPart = Array(secondCreature.genes[0..<crossIndex])
        let secondSCPart = Array(secondCreature.genes[crossIndex..<secondCreature.genes.count])
        
        let firstNewCreature = Creature(firstHalf: firstFCPart, secondHalf: secondSCPart)
        let secondNewCreature = Creature(firstHalf: firstSCPart, secondHalf: secondFCPart)
        
        population.append(firstNewCreature)
        population.append(secondNewCreature)
        
    }
    
    func doublePointCrossover(_ firstCreature: Creature, _ secondCreature: Creature, creatureLenght: Int) {
        
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
        
        population.append(firstNewCreature)
        population.append(secondNewCreature)
    }
    
    func singleGeneCrossover(_ firstCreature: Creature, _ secondCreature: Creature, creatureLenght: Int) {
        
        let crossIndex = Int.random(in: 1..<creatureLenght-1)
        
        let firstCreatureGene = firstCreature.genes[crossIndex]
        let secondCreatureGene = secondCreature.genes[crossIndex]
        
        var firstCreatureGenes = firstCreature.genes
        firstCreatureGenes[crossIndex] = secondCreatureGene
        
        let newFirstCreature = Creature(genes: firstCreatureGenes)
        population.append(newFirstCreature)
        
        var secondCreatureGenes = secondCreature.genes
        secondCreatureGenes[crossIndex] = firstCreatureGene
        
        let newSecondCreature = Creature(genes: secondCreatureGenes)
        population.append(newSecondCreature)
        
        
    }
    
    @IBAction func algorithmStarter(_ sender: UIButton) {
        guard let popSize = popSize.text, let genSize = genSize.text, let mutChance = mutChance.text else {
            return
        }
        guard let popSize = Int(popSize), let genSize = Int(genSize), let mutChance = Double(mutChance) else {
            return
        }
        
        self.populationSize = popSize
        self.mutationRate = mutChance
        self.genSizeNumber = genSize
        
        // first generation
        var firstGenOutput = "Generation 0"
        for _ in 0..<popSize {
            let creature = Creature(startGene: startGene, endGene: endGene, lenght: creatureLenght)
            print(creature)
            firstGenOutput += "\n\(creature)"
            
            population.append(creature)
        }
        
        resultView.text = firstGenOutput
        generations.append(firstGenOutput)
        
        generationSlider.minimumValue = 0
        generationSlider.maximumValue = Float(genSize)
        generationSlider.value = Float(genSize)
        
        if workingTypeChanger.selectedSegmentIndex == 0 {
            
            selection(generationCount: genSize, populationSize: popSize, mutationRate: mutChance)
            
            startButton.isHidden = true

        } else {
            tapButton.isHidden = false
            startButton.isHidden = true
            workingTypeChanger.isEnabled = false
        }
        
    }
    
    var genSizeNumber = 0
    var mutationRate = 0.0
    var populationSize = 0
    var generationNumber = 0
    
    @IBAction func stepByStepWorking(_ sender: UIButton) {
        // selection
        for creature in self.population {
            let randomNumber = Int.random(in: 0...100)
            if Double(randomNumber) / 100.0 < mutationRate {
                creature.mutating()
            }
        }
        
        let originalPopulation = self.population
        
        for _ in 0..<self.population.count {
            let firstCreature = originalPopulation.randomElement()!
            let secondCreature = originalPopulation.randomElement()!
            
            if firstCreature !== secondCreature {
                switch self.crossoverType {
                case .onePoint:
                    self.singlePointCrossover(firstCreature, secondCreature, creatureLenght: self.creatureLenght)
                case .twoPoint:
                    self.doublePointCrossover(firstCreature, secondCreature, creatureLenght: self.creatureLenght)
                case .singleGene:
                    self.singleGeneCrossover(firstCreature, secondCreature, creatureLenght: self.creatureLenght)
                }
                
            }
        }
        
        self.population.sort {
            $0.weight < $1.weight
        }
        
        self.population = Array(self.population[0..<populationSize])
        
        generationNumber += 1
        var resultText = "Gen \(generationNumber)"
        print("Gen \(generationNumber)")
        for creature in self.population {
            resultText += "\n\(creature)"
        }
        self.generations.append(resultText)
        DispatchQueue.main.async {
            self.resultView.text = resultText
        }
        
        if generationNumber == genSizeNumber {
            tapButton.isHidden = true
            generationSlider.isHidden = false
        }
        
    }
    
    @IBAction func showGeneration(_ sender: UISlider) {
        let generationIndex = Int(sender.value)
        
        resultView.text = generations[generationIndex]
    }
}

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return crossoverTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return crossoverTypes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch row {
        case 0:
            crossoverType = .onePoint
        case 1:
            crossoverType = .twoPoint
        case 2:
            crossoverType = .singleGene
        default:
            break
        }
        print (crossoverType)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
}
