//
//  IMP_CalculatorTests.swift
//  IMP CalculatorTests
//
//  Created by Patrick Parno on 2024-03-14.
//

import XCTest
@testable import IMP_Calculator

final class IMP_CalculatorTests: XCTestCase {

    var cb: CalculatorBrain!

    override func setUpWithError() throws {
        cb = CalculatorBrain()
    }

    // MARK: - contractScoreCalc: made contracts, part score

    func testPartScoreMinorMakingExactlyNotVulnerableUndoubled() {
        // 1C/1D making exactly, not vulnerable: 20 trick pts + 50 partscore bonus
        XCTAssertEqual(cb.contractScoreCalc(vuln: .notVulnerable, level: 1, strain: .minor, result: 0, double: .undoubled), 70)
    }

    func testPartScoreMajorMakingExactlyVulnerableUndoubled() {
        // 1H/1S making exactly, vulnerable: 30 trick pts + 50 partscore bonus
        XCTAssertEqual(cb.contractScoreCalc(vuln: .vulnerable, level: 1, strain: .major, result: 0, double: .undoubled), 80)
    }

    func testPartScoreDoubledIncludesInsultBonus() {
        // 1C doubled, making exactly, not vulnerable: 40 trick pts + 50 insult + 50 partscore
        XCTAssertEqual(cb.contractScoreCalc(vuln: .notVulnerable, level: 1, strain: .minor, result: 0, double: .doubled), 140)
    }

    func testPartScoreRedoubledIncludesDoubleInsultBonus() {
        // 1C redoubled, making exactly, not vulnerable: 80 trick pts + 100 insult + 50 partscore
        XCTAssertEqual(cb.contractScoreCalc(vuln: .notVulnerable, level: 1, strain: .minor, result: 0, double: .redoubled), 230)
    }

    // MARK: - contractScoreCalc: game contracts

    func testGameMajorMakingExactlyNotVulnerable() {
        // 4H/4S making exactly, not vulnerable: 120 trick pts + 300 game bonus
        XCTAssertEqual(cb.contractScoreCalc(vuln: .notVulnerable, level: 4, strain: .major, result: 0, double: .undoubled), 420)
    }

    func testGameMajorMakingExactlyVulnerable() {
        // 4H/4S making exactly, vulnerable: 120 trick pts + 500 game bonus
        XCTAssertEqual(cb.contractScoreCalc(vuln: .vulnerable, level: 4, strain: .major, result: 0, double: .undoubled), 620)
    }

    func testGameNoTrumpMakingExactlyNotVulnerable() {
        // 3NT making exactly, not vulnerable: 100 trick pts + 300 game bonus
        XCTAssertEqual(cb.contractScoreCalc(vuln: .notVulnerable, level: 3, strain: .notrump, result: 0, double: .undoubled), 400)
    }

    func testMinorBelowGameStillGetsOnlyPartscoreBonus() {
        // 4C/4D making exactly, not vulnerable (game in a minor needs 5-level):
        // 80 trick pts + 50 partscore bonus, not the 300 game bonus
        XCTAssertEqual(cb.contractScoreCalc(vuln: .notVulnerable, level: 4, strain: .minor, result: 0, double: .undoubled), 130)
    }

    func testGameWithOvertricks() {
        // 4S making 2 overtricks (9 tricks), not vulnerable: 120 + 2*30 trick pts + 300 game bonus
        XCTAssertEqual(cb.contractScoreCalc(vuln: .notVulnerable, level: 4, strain: .major, result: 2, double: .undoubled), 480)
    }

    // MARK: - contractScoreCalc: slams

    func testSmallSlamMajorNotVulnerable() {
        // 6H/6S making exactly, not vulnerable: 180 trick pts + 300 game + 500 slam bonus
        XCTAssertEqual(cb.contractScoreCalc(vuln: .notVulnerable, level: 6, strain: .major, result: 0, double: .undoubled), 980)
    }

    func testSmallSlamMajorVulnerable() {
        // 6H/6S making exactly, vulnerable: 180 trick pts + 500 game + 750 slam bonus
        XCTAssertEqual(cb.contractScoreCalc(vuln: .vulnerable, level: 6, strain: .major, result: 0, double: .undoubled), 1430)
    }

    func testGrandSlamNoTrumpVulnerable() {
        // 7NT making exactly, vulnerable: 220 trick pts + 500 game + 1500 grand slam bonus
        XCTAssertEqual(cb.contractScoreCalc(vuln: .vulnerable, level: 7, strain: .notrump, result: 0, double: .undoubled), 2220)
    }

    // MARK: - contractScoreCalc: down contracts

    func testDownOneNotVulnerableUndoubled() {
        XCTAssertEqual(cb.contractScoreCalc(vuln: .notVulnerable, level: 1, strain: .major, result: -1, double: .undoubled), -50)
    }

    func testDownOneVulnerableDoubled() {
        XCTAssertEqual(cb.contractScoreCalc(vuln: .vulnerable, level: 4, strain: .major, result: -1, double: .doubled), -200)
    }

    func testDownOneVulnerableRedoubled() {
        XCTAssertEqual(cb.contractScoreCalc(vuln: .vulnerable, level: 4, strain: .major, result: -1, double: .redoubled), -400)
    }

    func testDownFourNotVulnerableDoubledCrossesPenaltyTier() {
        // Doubled undertrick penalties (not vulnerable) step from 200 to 300 at the 4th undertrick:
        // 100 + 200 + 200 + 300 = 800
        XCTAssertEqual(cb.contractScoreCalc(vuln: .notVulnerable, level: 4, strain: .major, result: -4, double: .doubled), -800)
    }

    func testDownThreeVulnerableDoubled() {
        // Doubled undertrick penalties (vulnerable): 200 first, 300 each after: 200 + 300 + 300 = 800
        XCTAssertEqual(cb.contractScoreCalc(vuln: .vulnerable, level: 4, strain: .major, result: -3, double: .doubled), -800)
    }

    // MARK: - expectedScoreCalc

    func testExpectedScoreAtExactlyTwentyHCPIsZero() {
        XCTAssertEqual(cb.expectedScoreCalc(hcp: 20, vuln: .notVulnerable), 0)
        XCTAssertEqual(cb.expectedScoreCalc(hcp: 20, vuln: .vulnerable), 0)
    }

    func testExpectedScoreIsAntisymmetricAroundTwentyHCP() {
        // Holding 25 HCP mirrors the opponents holding 40-25=15 HCP; the table should
        // treat those as equal-magnitude, opposite-sign expected outcomes.
        let above = cb.expectedScoreCalc(hcp: 25, vuln: .notVulnerable)
        let below = cb.expectedScoreCalc(hcp: 15, vuln: .notVulnerable)
        XCTAssertEqual(above, -below)
    }

    // MARK: - impPoints (IMP conversion)

    func testImpPointsPositiveWhenActualBeatsExpected() {
        let expected = cb.expectedScoreCalc(hcp: 25, vuln: .notVulnerable) // expected = 400
        let imps = cb.impPoints(expectedScore: expected, vuln: .notVulnerable, level: 4, strain: .major, result: 0, double: .undoubled) // actual = 420, diff = 20
        XCTAssertEqual(imps, "1")
    }

    func testImpPointsNegativeWhenActualUnderperformsExpected() {
        let expected = cb.expectedScoreCalc(hcp: 25, vuln: .notVulnerable) // expected = 400
        let imps = cb.impPoints(expectedScore: expected, vuln: .notVulnerable, level: 1, strain: .major, result: -1, double: .undoubled) // actual = -50, diff = 450
        XCTAssertEqual(imps, "-10")
    }

    func testImpPointsSmallDifferenceRoundsToFewImps() {
        let expected = cb.expectedScoreCalc(hcp: 20, vuln: .notVulnerable) // expected = 0
        let imps = cb.impPoints(expectedScore: expected, vuln: .notVulnerable, level: 1, strain: .minor, result: 0, double: .undoubled) // actual = 70, diff = 70
        XCTAssertEqual(imps, "2")
    }

    func testImpPointsDoesNotDependOnPriorCallsOnTheSameInstance() {
        // Regression guard for a fixed bug: impPoints() used to read expectedScore
        // from mutable struct state that only got populated if expectedScoreCalc()
        // happened to be called first on that same instance. Now expectedScore is a
        // required parameter, so a brand-new instance that never ran
        // expectedScoreCalc() itself still produces the correct result.
        let expected = cb.expectedScoreCalc(hcp: 25, vuln: .notVulnerable) // expected = 400
        let freshBrain = CalculatorBrain()
        let imps = freshBrain.impPoints(expectedScore: expected, vuln: .notVulnerable, level: 4, strain: .major, result: 0, double: .undoubled)
        XCTAssertEqual(imps, "1")
    }

    // MARK: - findMinElement (IMP scale lookup)

    func testFindMinElementLowerBoundaryIsZeroImps() {
        XCTAssertEqual(cb.findMinElement(scoreDiff: 0), 0)
    }

    func testFindMinElementUpperBoundaryIsMaxImps() {
        XCTAssertEqual(cb.findMinElement(scoreDiff: 4000), 24)
        XCTAssertEqual(cb.findMinElement(scoreDiff: 10000), 24)
    }

    func testFindMinElementAtKnownMidRangeValue() {
        XCTAssertEqual(cb.findMinElement(scoreDiff: 600), 12)
        XCTAssertEqual(cb.findMinElement(scoreDiff: 740), 12)
    }
}
