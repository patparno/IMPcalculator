//
//  ViewController.swift
//  IMP Calculator
//
//  Created by Patrick Parno on 2024-03-14.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var cb = CalculatorBrain()
    let tables = Tables()
    
    var hcpList = (15...40).map {$0}
    var resultList = (-7...7).map {$0}
    var contractLevel = 1
    var minorMajor = "Major"
    var double = 0
    var vuln = "N"
    var vulnNum = 1
    var totalHCP = 25
    var tricksTaken = 10
    
    @IBOutlet weak var hcpPicker: UIPickerView!
    @IBOutlet weak var tricksTakenPicker: UIPickerView!

    @IBOutlet weak var contractSelector: UISegmentedControl!
    @IBOutlet weak var suitSelector: UISegmentedControl!
    @IBOutlet weak var doubleSelector: UISegmentedControl!
    @IBOutlet weak var vulnSelector: UISegmentedControl!
    
    @IBOutlet weak var expectedScore: UILabel!
    @IBOutlet weak var actualScore: UILabel!
    @IBOutlet weak var impPoints: UILabel!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hcpPicker.dataSource = self
        self.hcpPicker.delegate = self
        self.tricksTakenPicker.delegate = self
        self.tricksTakenPicker.dataSource = self
        contractSelector.selectedSegmentIndex = 0
        suitSelector.selectedSegmentIndex = 0
        doubleSelector.selectedSegmentIndex = 0
    }
    
    @IBAction func calculateButton(_ sender: UIButton) {
        let suit = String(vuln) + String(contractLevel) + minorMajor
        print("suit \(suit)")
        expectedScore.text = String(cb.expectedScoreCalc(result: tricksTaken, hcp: totalHCP, vulnNum: vulnNum))
        print("vuln: \(vuln), suit: \(suit), result \(tricksTaken), double \(double)")
        actualScore.text = String(cb.contractScoreCalc(vulnNum: vulnNum, suit: suit, result: tricksTaken, double: double))
        impPoints.text = cb.impPoints(suit: suit, result: tricksTaken, vulnNum: vulnNum, double: double)
    }
    
    
    @IBAction func contractSelector(_ sender: UISegmentedControl) {
        contractLevel = contractSelector.selectedSegmentIndex + 1
        print("contractLevel \(contractLevel)")
    }
    
    @IBAction func suitSelector(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: minorMajor = "Minor"
        case 1: minorMajor = "Minor"
        case 2: minorMajor = "Major"
        case 3: minorMajor = "Major"
        case 4: minorMajor = "NT"
            
        default: break
        }
        print("minorMajor = \(minorMajor)")
    }
    
    @IBAction func doubleSelector(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            double = 0
        case 1:
            double = 1
        case 2:
            double = 2
        default: break
        }
        print ("double = \(double)")
    }
    
    @IBAction func vulnSelector(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            vuln = "N"
            vulnNum = 1
        case 1:
            vuln = "V"
            vulnNum = 2
        default: break
        }
        print ("vuln = \(vuln)")
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var answer = 0
        switch pickerView.tag {
        case  0:
            answer =  hcpList.count
        case 1:
            answer =  resultList.count
        default:  break
        }
        return answer
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        switch pickerView.tag {
        case  0:
            totalHCP = hcpList[row]
        case 1:
            tricksTaken = resultList[row]
        default:
            print("you messed up")
        }
       
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case  0:
            return String(hcpList[row])
        case 1:
            return String(resultList[row])
        default:
            return nil
        }

    }
    
    
    
}
