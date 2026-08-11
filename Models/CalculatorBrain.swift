//
//  Calculator.swift
//  IMPBridge
//
//  Created by Patrick Parno on 2023-12-16.
//

import Foundation

struct   CalculatorBrain {
    var tables = Tables()

    func impPoints (expectedScore:Int,suit:String,result:Int,vulnNum:Int,double:Int) -> String {
        let contractScore = contractScoreCalc(vulnNum:vulnNum,suit:suit,result:result,double:double)

        let scoreDiff = abs(contractScore - expectedScore)
        var impPoints = findMinElement(scoreDiff: scoreDiff)

        if (contractScore - expectedScore) < 0 { impPoints = -impPoints}
        return String(impPoints)
    }

    func expectedScoreCalc (result:Int,hcp:Int,vulnNum:Int) ->Int {

        let hcpMoreThanTwenty = hcp - 20 //tables are set up for hcp>20
        if hcpMoreThanTwenty >= 0 {
            return tables.expectedScoreDifference[hcpMoreThanTwenty][vulnNum]
        } else {
            let otherTeamScoreAbove20 = -hcpMoreThanTwenty // what the other team has (and should have declared
            return -tables.expectedScoreDifference[otherTeamScoreAbove20][vulnNum]
        }
    }

    func contractScoreCalc (vulnNum:Int,suit:String,result:Int,double:Int) -> Int {

         if result >= 0 {
             return bridgeScoreLookup(suit: suit, result: result, double: double)
        } else {
            let downScore: Int
            if vulnNum == 1 {
                 downScore = tables.downN[abs(result + 1)][double]
            } else {
                downScore = tables.downV[abs(result + 1)][double]
            }
            return -downScore
        }
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
        guard let contractTable = tables.allContracts[suit] else {
            fatalError("No score table for contract key '\(suit)'")
        }
        return contractTable[result][double]
    }
    
}
