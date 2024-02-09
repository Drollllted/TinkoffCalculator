//
//  ViewController.swift
//  TinkoffCalculator
//
//  Created by Drolllted on 08.02.2024.
//

import UIKit


enum CalculationError: Error{
    case dividedZero
}

//MARK: Создание перечислений для работы с названием опепаций и перечисление с разницей между числами и операциями
enum Operation: String{
    case add = "+"
    case substract = "-"
    case multiply = "x"
    case divide = "/"
    
    func calculate(_ number1: Double, _ number2: Double) throws -> Double{
        switch self{
        case .add:
            return number1 + number2
        case .substract:
            return number1 - number2
        case .multiply:
            return number1 * number2
        case .divide:
            if number2 == 0{
                throw CalculationError.dividedZero
            }
            return number1 / number2
        }
        
    }
}

enum CalculationHistoryItem{
    case number(Double)
    case operation (Operation)
}



class ViewController: UIViewController {
    
    var currentValue: Double?
    
    
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        guard let buttonPressed = sender.titleLabel?.text else {return}
        
        if buttonPressed == "," && resultLabel.text?.contains(",") == true{
            return
        }
        
        if resultLabel.text == "0"{
            resultLabel.text = buttonPressed
        }else{
            resultLabel.text?.append(buttonPressed)
        }
        
        //MARK: Изменение1 = При нажатии на кнопку "," добавлялось "0,"
        if resultLabel.text == ","{
            resultLabel.text = "0,"
        }
        
        //MARK: Изменение2 - Если нажать любую кнопку с числом(или например ",") - то "Ошибка" меняется на то число, которое было нажато

        
        
    }
    
    @IBAction func operationButtonPressed(_ sender: UIButton) {
        
        guard let buttonPressed = sender.titleLabel?.text,
              let buttonOperation = Operation(rawValue: buttonPressed)
        else
        {return}
        
        guard let labelText = resultLabel.text,
              let labelNumber =  numberFormatter.number(from: labelText)?.doubleValue
        else
        {return }
        
        calculationHistory.append(.number(labelNumber))
        calculationHistory.append(.operation(buttonOperation))
        
        resetLabelText()
        
    }
    
    @IBAction func clearButton() {
        calculationHistory.removeAll()
        
        resetLabelText()
    }
    
    @IBAction func calculateButtonPressed(){
        guard let labelText = resultLabel.text,
              let labelNumber =  numberFormatter.number(from: labelText)?.doubleValue
              
        else
        {return }
        
        calculationHistory.append(.number(labelNumber))
        
        do{
            let result = try calculated()
            
            resultLabel.text = numberFormatter.string(from: NSNumber(value: result))
        }catch{
            resultLabel.text = "Ошибка"
            
        }
 
        
        calculationHistory.removeAll()
    }
    
    
    var calculationHistory: [CalculationHistoryItem] = []
    
    
    lazy var numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        
        numberFormatter.usesGroupingSeparator = false
        numberFormatter.locale = Locale(identifier: "ru_RU")
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: Есть желание попробовать поработать именно через констрейнты кодом
        
        view.backgroundColor = .gray
    }
    
    func calculated() throws -> Double{
        guard case .number(let firstNumber) = calculationHistory[0] else {return 0 }
        
        var currentResult = firstNumber
        
        for index in stride(from: 1, to: calculationHistory.count - 1, by: 2){
            guard case .operation(let operation) = calculationHistory[index],
                  case .number(let number) = calculationHistory[index + 1] else { break}
            
            currentResult = try operation.calculate(currentResult, number)
        }
        
        return currentResult
    }
    
    
    func resetLabelText() {
        resultLabel.text = "0"
    }
}

