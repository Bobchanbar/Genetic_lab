//
//  ViewController.swift
//  GeneticLab
//
//  Created by Vladimir Barus on 22.04.2021.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var populationSizeTextField: UITextField!
    @IBOutlet weak var generationSizeTextField: UITextField!
    @IBOutlet weak var mutationChanceTextField: UITextField!
    @IBOutlet weak var crossOptionsPickerView: UIPickerView!
    @IBOutlet weak var resultTextView: UITextView!
    @IBOutlet weak var workingTypeSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var tapButton: UIButton!
    
    @IBOutlet weak var generationSlider: UISlider!
    
    // MARK: Properties
    var population: [Creature] = []
    var crossoverType: CrossoverType = .onePoint
    let crossoverTypes = ["One point crossover", "Two points crossover", "Single gene crossover"]

    let startGene = Gene.a
    let endGene = Gene.g
    let creatureLenght = 30
    
    var generations: [String] = []
    
    let crossoverService = CrossoverService()
    
    var newCreaturesSaveComplition: ((Creature, Creature) -> Void)?
    
    var genSizeNumber = 0
    var mutationRate = 0.0
    var populationSize = 0
    var generationNumber = 0
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newCreaturesSaveComplition = { creature1, creature2 in
            self.population.append(creature1)
            self.population.append(creature2)
        }
    }
    
    // MARK: Helpers
    
    func selection() {
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
                    self.crossoverService.singlePointCrossover(firstCreature, secondCreature, complition: self.newCreaturesSaveComplition!)
                case .twoPoint:
                    self.crossoverService.doublePointCrossover(firstCreature, secondCreature, complition: self.newCreaturesSaveComplition!)
                case .singleGene:
                    self.crossoverService.singleGeneCrossover(firstCreature, secondCreature, complition: self.newCreaturesSaveComplition!)
                }
                
            }
        }
        
        self.population.sort {
            $0.weight < $1.weight
        }
        
        self.population = Array(self.population[0..<populationSize])
        
        self.generationNumber += 1
        var resultText = "Generation \(self.generationNumber)"
        for creature in self.population {
            resultText += "\n\(creature)"
        }
        self.generations.append(resultText)
        
        DispatchQueue.main.async {
            self.resultTextView.text = resultText
        }
    }
    
    func cycleAlgorithm(generationCount: Int, populationSize: Int, mutationRate: Double) {
        DispatchQueue.global().async {
            for _ in 0..<generationCount {
                self.selection()
            }
            DispatchQueue.main.async {
                self.generationSlider.isHidden = false
            }
        }
        
    }

    // MARK: Actions
    
    @IBAction func algorithmStarter(_ sender: UIButton) {
        guard let popSize = populationSizeTextField.text, let genSize = generationSizeTextField.text, let mutChance = mutationChanceTextField.text else {
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
        
        resultTextView.text = firstGenOutput
        generations.append(firstGenOutput)
        
        generationSlider.minimumValue = 0
        generationSlider.maximumValue = Float(genSize)
        generationSlider.value = Float(genSize)
        
        if workingTypeSegmentedControl.selectedSegmentIndex == 0 {
            
            cycleAlgorithm(generationCount: genSize, populationSize: popSize, mutationRate: mutChance)
            
            startButton.isHidden = true

        } else {
            tapButton.isHidden = false
            startButton.isHidden = true
            workingTypeSegmentedControl.isEnabled = false
        }
        
    }

    @IBAction func stepByStepWorking(_ sender: UIButton) {
        selection()
        
        if generationNumber == genSizeNumber {
            tapButton.isHidden = true
            generationSlider.isHidden = false
        }
    }
    
    @IBAction func showGeneration(_ sender: UISlider) {
        let generationIndex = Int(sender.value)
        
        resultTextView.text = generations[generationIndex]
    }
}

// MARK: - UIPickerViewDataSource & UIPickerViewDelegate
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
