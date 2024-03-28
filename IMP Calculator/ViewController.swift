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
    
    var hcpList = (10...40).map {$0}
    var resultList = (-7...1).map {String($0)}
    var contractLevel = 1
    var minorMajor = "Major"
    var double = 0
    var vuln = "N"
    var vulnNum = 1
    var totalHCP = 15
    var tricksTaken = 1
    var tricksTakenText = "10"
    
    @IBOutlet weak var hcpPicker: UIPickerView!
    @IBOutlet weak var tricksTakenPicker: UIPickerView!

    @IBOutlet weak var contractSelector: UISegmentedControl!
    @IBOutlet weak var suitSelector: UISegmentedControl!
    @IBOutlet weak var doubleSelector: UISegmentedControl!
    @IBOutlet weak var vulnSelector: UISegmentedControl!
    
    @IBOutlet weak var expectedScore: UILabel!
    @IBOutlet weak var actualScore: UILabel!
    @IBOutlet weak var impPoints: UILabel!
    
    @IBOutlet weak var calculateButton: UIButton!
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hcpPicker.dataSource = self
        self.hcpPicker.delegate = self
        self.tricksTakenPicker.delegate = self
        self.tricksTakenPicker.dataSource = self
    }

    func resetSuits () {
        suitSelector.setImage(UIImage(named: "clubs1024"), forSegmentAt: 0)
        suitSelector.setImage(UIImage(named: "diamonds1024"), forSegmentAt: 1)
        suitSelector.setImage(UIImage(named: "hearts1024"), forSegmentAt: 2)
        suitSelector.setImage(UIImage(named: "spades1024"), forSegmentAt: 3)
        suitSelector.setImage(UIImage(named: "No Trump1024"), forSegmentAt: 4)
    }
    
    @IBAction func calculateButton(_ sender: UIButton) {
        let suit = String(vuln) + String(contractLevel) + minorMajor
        print("suit \(suit), tricksTaken \(tricksTaken), vul \(vuln), double \(double)")
        expectedScore.text = String(cb.expectedScoreCalc(result: tricksTaken, hcp: totalHCP, vulnNum: vulnNum))
        print("expected score went ok")
        actualScore.text = String(cb.contractScoreCalc(vulnNum: vulnNum, suit: suit, result: tricksTaken, double: double))
        print("actual score went ok")
        impPoints.text = cb.impPoints(suit: suit, result: tricksTaken, vulnNum: vulnNum, double: double)
        print("imp points went ok")
    }
    
    
    @IBAction func contractSelector(_ sender: UISegmentedControl) {
        contractLevel = contractSelector.selectedSegmentIndex + 1
       
        let leftEdge = -(contractLevel + 6)
        let rightEdge = 7 - contractLevel
        resultList = (leftEdge...rightEdge).map { String($0 > 0 ? "+\($0)" : "\($0)") }
        //self.tricksTakenPicker.isUserInteractionEnabled = true
        self.tricksTakenPicker.reloadAllComponents()

    }
    
    @IBAction func suitSelector(_ sender: UISegmentedControl) {

        switch sender.selectedSegmentIndex {
        case 0: 
            minorMajor = "Minor"
            resetSuits()
            suitSelector.setImage(UIImage(named: "clubs1024white"), forSegmentAt: 0)
        case 1:
            minorMajor = "Minor"
            resetSuits()
            suitSelector.setImage(UIImage(named: "diamonds1024blue"), forSegmentAt: 1)
        case 2:
            minorMajor = "Major"
            resetSuits()
            suitSelector.setImage(UIImage(named: "hearts1024blue"), forSegmentAt: 2)
        case 3:
            minorMajor = "Major"
            resetSuits()
            suitSelector.setImage(UIImage(named: "spades1024white"), forSegmentAt: 3)
        case 4:
            minorMajor = "NT"
            resetSuits()
            suitSelector.setImage(UIImage(named: "No Trump1024black"), forSegmentAt: 4)
        default: break
        }
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
            tricksTaken = Int(resultList[row])!
            calculateButton.backgroundColor = UIColor.yellow
            self.calculateButton.isEnabled = true
            self.calculateButton.isUserInteractionEnabled = true
        default:
            print("you messed up")
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case  0:
            return String(hcpList[row])

        case 1:
            let equalAddedList = (resultList.map {$0 == "0" ? "=" : $0 })

            return equalAddedList[row]
        default:
            return nil
        }

    }
    
    
    
}
