//
//  Calculator.swift
//  IMPBridge
//
//  Created by Patrick Parno on 2023-12-16.
//

import Foundation

enum Vulnerability: Int {
    case notVulnerable = 1
    case vulnerable = 2

    var tablePrefix: String {
        switch self {
        case .notVulnerable: return "N"
        case .vulnerable: return "V"
        }
    }
}

enum Strain: String {
    case minor = "Minor"
    case major = "Major"
    case notrump = "NT"
}

enum DoubleState: Int {
    case undoubled = 0
    case doubled = 1
    case redoubled = 2
}

struct   CalculatorBrain {
    var tables = Tables()

    func impPoints (expectedScore:Int,vuln:Vulnerability,level:Int,strain:Strain,result:Int,double:DoubleState) -> String {
        let contractScore = contractScoreCalc(vuln:vuln,level:level,strain:strain,result:result,double:double)

        let scoreDiff = abs(contractScore - expectedScore)
        var impPoints = findMinElement(scoreDiff: scoreDiff)

        if (contractScore - expectedScore) < 0 { impPoints = -impPoints}
        return String(impPoints)
    }

    func expectedScoreCalc (hcp:Int,vuln:Vulnerability) ->Int {

        let hcpMoreThanTwenty = hcp - 20 //tables are set up for hcp>20
        if hcpMoreThanTwenty >= 0 {
            return tables.expectedScoreDifference[hcpMoreThanTwenty][vuln.rawValue]
        } else {
            let otherTeamScoreAbove20 = -hcpMoreThanTwenty // what the other team has (and should have declared
            return -tables.expectedScoreDifference[otherTeamScoreAbove20][vuln.rawValue]
        }
    }

    func contractScoreCalc (vuln:Vulnerability,level:Int,strain:Strain,result:Int,double:DoubleState) -> Int {

         if result >= 0 {
             return bridgeScoreLookup(vuln: vuln, level: level, strain: strain, result: result, double: double)
        } else {
            let downTable = vuln == .notVulnerable ? tables.downN : tables.downV
            return -downTable[abs(result + 1)][double.rawValue]
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

    func bridgeScoreLookup(vuln:Vulnerability,level:Int,strain:Strain,result:Int,double:DoubleState) -> Int {
        let suit = "\(vuln.tablePrefix)\(level)\(strain.rawValue)"
        guard let contractTable = tables.allContracts[suit] else {
            fatalError("No score table for contract key '\(suit)'")
        }
        return contractTable[result][double.rawValue]
    }

}
