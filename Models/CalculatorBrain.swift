//
//  Calculator.swift
//  IMPBridge
//
//  Created by Patrick Parno on 2023-12-16.
//

import Foundation

struct   CalculatorBrain {
    var tables = Tables()
    var expectedScore = -1
    var contractScore = -1

    
    mutating func impPoints (suit:String,result:Int,vulnNum:Int,double:Int) -> String {
      //  expectedScore = expectedScoreCalc(result:result,hcp:hcp,vulnNum:vulnNum)
        contractScore = contractScoreCalc(vulnNum:vulnNum,suit:suit,result:result,double:double)

        let scoreDiff = abs(contractScore - expectedScore)
        var impPoints = findMinElement(scoreDiff: scoreDiff)
        
        if (contractScore - expectedScore) < 0 { impPoints = -impPoints}
        return String(impPoints)
    }
    
    mutating func expectedScoreCalc (result:Int,hcp:Int,vulnNum:Int) ->Int {

        let hcpMoreThanTwenty = hcp - 20 //tables are set up for hcp>20
        if hcpMoreThanTwenty >= 0 {
            expectedScore = tables.expectedScoreDifference[hcpMoreThanTwenty][vulnNum]
        } else {
            let otherTeamScoreAbove20 = -hcpMoreThanTwenty // what the other team has (and should have declared
            expectedScore = tables.expectedScoreDifference[otherTeamScoreAbove20][vulnNum]
            expectedScore = -expectedScore
        }
        print("expected score is \(expectedScore)")
        return expectedScore
    }
    
    mutating func contractScoreCalc (vulnNum:Int,suit:String,result:Int,double:Int) -> Int {

         if result >= 0 {
             contractScore = bridgeScoreLookup(suit: suit, result: result, double: double)
        } else {
            print("result was \(result), so abs result + 1 is \(abs(result-1))")
            if vulnNum == 1 {
                 contractScore = tables.downN[abs(result + 1)][double]
            } else {
                contractScore = tables.downV[abs(result + 1)][double]
            }
            contractScore = -contractScore
        }
        print("contract score is \(contractScore)")
        return contractScore
    }
    
    
    func findMinElement (scoreDiff:Int) -> Int {
        var minValue = 24
        for array in tables.impPoints {
            if scoreDiff >= array[0] && scoreDiff <= array[1] {
                minValue = array[2]
            }
        }
        return minValue
    }

    func bridgeScoreLookup(suit:String,result:Int,double:Int) -> Int {
        let bridgeScore :  Int
        switch suit {
            case "N1Minor" : bridgeScore = tables.N1Minor[result][double]
            case "V1Minor" : bridgeScore = tables.V1Minor[result][double]
            case "N1Major" : bridgeScore = tables.N1Major[result][double]
            case "V1Major": bridgeScore = tables.V1Major[result][double]
            case "N1NT": bridgeScore = tables.N1NT[result][double]
            case "V1NT": bridgeScore = tables.V1NT[result][double]
            case "N2Minor": bridgeScore = tables.N2Minor[result][double]
            case "V2Minor": bridgeScore = tables.V2Minor[result][double]
            case "N2Major": bridgeScore = tables.N2Major[result][double]
            case "V2Major": bridgeScore = tables.V2Major[result][double]
            case "N2NT": bridgeScore = tables.N2NT[result][double]
            case "V2NT": bridgeScore = tables.V2NT[result][double]
            case "N3Minor": bridgeScore = tables.N3Minor[result][double]
            case "V3Minor": bridgeScore = tables.V3Minor[result][double]
            case "N3Major": bridgeScore = tables.N3Major[result][double]
            case "V3Major": bridgeScore = tables.V3Major[result][double]
            case "N3NT": bridgeScore = tables.N3NT[result][double]
            case "V3NT": bridgeScore = tables.V3NT[result][double]
            case "N4Minor": bridgeScore = tables.N4Minor[result][double]
            case "V4Minor": bridgeScore = tables.V4Minor[result][double]
            case "N4Major": bridgeScore = tables.N4Major[result][double]
            case "V4Major": bridgeScore = tables.V4Major[result][double]
            case "N4NT": bridgeScore = tables.N4NT[result][double]
            case "V4NT": bridgeScore = tables.V4NT[result][double]
            case "N5Minor": bridgeScore = tables.N5Minor[result][double]
            case "V5Minor": bridgeScore = tables.V5Minor[result][double]
            case "N5Major": bridgeScore = tables.N5Major[result][double]
            case "V5Major": bridgeScore = tables.V5Major[result][double]
            case "N5NT": bridgeScore = tables.N5NT[result][double]
            case "V5NT": bridgeScore = tables.V5NT[result][double]
            case "N6Minor": bridgeScore = tables.N6Minor[result][double]
            case "V6Minor": bridgeScore = tables.V6Minor[result][double]
            case "N6Major": bridgeScore = tables.N6Major[result][double]
            case "V6Major": bridgeScore = tables.V6Major[result][double]
            case "N6NT": bridgeScore = tables.N6NT[result][double]
            case "V6NT": bridgeScore = tables.V6NT[result][double]
            case "N7Minor": bridgeScore = tables.N7Minor[result][double]
            case "V7Minor": bridgeScore = tables.V7Minor[result][double]
            case "N7Major": bridgeScore = tables.N7Major[result][double]
            case "V7Major": bridgeScore = tables.V7Major[result][double]
            case "N7NT": bridgeScore = tables.N7NT[result][double]
            case "V7NT": bridgeScore = tables.V7NT[result][double]
            default :  bridgeScore = 0
        }
        return bridgeScore
    }
    
}
