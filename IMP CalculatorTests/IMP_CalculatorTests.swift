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
        XCTAssertEqual(cb.contractScoreCalc(vulnNum: 1, suit: "N1Minor", result: 0, double: 0), 70)
    }

    func testPartScoreMajorMakingExactlyVulnerableUndoubled() {
        // 1H/1S making exactly, vulnerable: 30 trick pts + 50 partscore bonus
        XCTAssertEqual(cb.contractScoreCalc(vulnNum: 2, suit: "V1Major", result: 0, double: 0), 80)
    }

    func testPartScoreDoubledIncludesInsultBonus() {
        // 1C doubled, making exactly, not vulnerable: 40 trick pts + 50 insult + 50 partscore
        XCTAssertEqual(cb.contractScoreCalc(vulnNum: 1, suit: "N1Minor", result: 0, double: 1), 140)
    }

    func testPartScoreRedoubledIncludesDoubleInsultBonus() {
        // 1C redoubled, making exactly, not vulnerable: 80 trick pts + 100 insult + 50 partscore
        XCTAssertEqual(cb.contractScoreCalc(vulnNum: 1, suit: "N1Minor", result: 0, double: 2), 230)
    }

    // MARK: - contractScoreCalc: game contracts

    func testGameMajorMakingExactlyNotVulnerable() {
        // 4H/4S making exactly, not vulnerable: 120 trick pts + 300 game bonus
        XCTAssertEqual(cb.contractScoreCalc(vulnNum: 1, suit: "N4Major", result: 0, double: 0), 420)
    }

    func testGameMajorMakingExactlyVulnerable() {
        // 4H/4S making exactly, vulnerable: 120 trick pts + 500 game bonus
        XCTAssertEqual(cb.contractScoreCalc(vulnNum: 2, suit: "V4Major", result: 0, double: 0), 620)
    }

    func testGameNoTrumpMakingExactlyNotVulnerable() {
        // 3NT making exactly, not vulnerable: 100 trick pts + 300 game bonus
        XCTAssertEqual(cb.contractScoreCalc(vulnNum: 1, suit: "N3NT", result: 0, double: 0), 400)
    }

    func testMinorBelowGameStillGetsOnlyPartscoreBonus() {
        // 4C/4D making exactly, not vulnerable (game in a minor needs 5-level):
        // 80 trick pts + 50 partscore bonus, not the 300 game bonus
        XCTAssertEqual(cb.contractScoreCalc(vulnNum: 1, suit: "N4Minor", result: 0, double: 0), 130)
    }

    func testGameWithOvertricks() {
        // 4S making 2 overtricks (9 tricks), not vulnerable: 120 + 2*30 trick pts + 300 game bonus
        XCTAssertEqual(cb.contractScoreCalc(vulnNum: 1, suit: "N4Major", result: 2, double: 0), 480)
    }

    // MARK: - contractScoreCalc: slams

    func testSmallSlamMajorNotVulnerable() {
        // 6H/6S making exactly, not vulnerable: 180 trick pts + 300 game + 500 slam bonus
        XCTAssertEqual(cb.contractScoreCalc(vulnNum: 1, suit: "N6Major", result: 0, double: 0), 980)
    }

    func testSmallSlamMajorVulnerable() {
        // 6H/6S making exactly, vulnerable: 180 trick pts + 500 game + 750 slam bonus
        XCTAssertEqual(cb.contractScoreCalc(vulnNum: 2, suit: "V6Major", result: 0, double: 0), 1430)
    }

    func testGrandSlamNoTrumpVulnerable() {
        // 7NT making exactly, vulnerable: 220 trick pts + 500 game + 1500 grand slam bonus
        XCTAssertEqual(cb.contractScoreCalc(vulnNum: 2, suit: "V7NT", result: 0, double: 0), 2220)
    }

    // MARK: - contractScoreCalc: down contracts

    func testDownOneNotVulnerableUndoubled() {
        XCTAssertEqual(cb.contractScoreCalc(vulnNum: 1, suit: "N1Major", result: -1, double: 0), -50)
    }

    func testDownOneVulnerableDoubled() {
        XCTAssertEqual(cb.contractScoreCalc(vulnNum: 2, suit: "V4Major", result: -1, double: 1), -200)
    }

    func testDownOneVulnerableRedoubled() {
        XCTAssertEqual(cb.contractScoreCalc(vulnNum: 2, suit: "V4Major", result: -1, double: 2), -400)
    }

    func testDownFourNotVulnerableDoubledCrossesPenaltyTier() {
        // Doubled undertrick penalties (not vulnerable) step from 200 to 300 at the 4th undertrick:
        // 100 + 200 + 200 + 300 = 800
        XCTAssertEqual(cb.contractScoreCalc(vulnNum: 1, suit: "N4Major", result: -4, double: 1), -800)
    }

    func testDownThreeVulnerableDoubled() {
        // Doubled undertrick penalties (vulnerable): 200 first, 300 each after: 200 + 300 + 300 = 800
        XCTAssertEqual(cb.contractScoreCalc(vulnNum: 2, suit: "V4Major", result: -3, double: 1), -800)
    }

    // MARK: - expectedScoreCalc

    func testExpectedScoreAtExactlyTwentyHCPIsZero() {
        XCTAssertEqual(cb.expectedScoreCalc(result: 0, hcp: 20, vulnNum: 1), 0)
        XCTAssertEqual(cb.expectedScoreCalc(result: 0, hcp: 20, vulnNum: 2), 0)
    }

    func testExpectedScoreIsAntisymmetricAroundTwentyHCP() {
        // Holding 25 HCP mirrors the opponents holding 40-25=15 HCP; the table should
        // treat those as equal-magnitude, opposite-sign expected outcomes.
        let above = cb.expectedScoreCalc(result: 0, hcp: 25, vulnNum: 1)
        let below = cb.expectedScoreCalc(result: 0, hcp: 15, vulnNum: 1)
        XCTAssertEqual(above, -below)
    }

    // MARK: - impPoints (IMP conversion)

    func testImpPointsPositiveWhenActualBeatsExpected() {
        // expectedScoreCalc must run first: it populates cb.expectedScore, which
        // impPoints() reads as a side effect rather than accepting as a parameter.
        _ = cb.expectedScoreCalc(result: 0, hcp: 25, vulnNum: 1) // expected = 400
        let imps = cb.impPoints(suit: "N4Major", result: 0, vulnNum: 1, double: 0) // actual = 420, diff = 20
        XCTAssertEqual(imps, "1")
    }

    func testImpPointsNegativeWhenActualUnderperformsExpected() {
        _ = cb.expectedScoreCalc(result: 0, hcp: 25, vulnNum: 1) // expected = 400
        let imps = cb.impPoints(suit: "N1Major", result: -1, vulnNum: 1, double: 0) // actual = -50, diff = 450
        XCTAssertEqual(imps, "-10")
    }

    func testImpPointsSmallDifferenceRoundsToFewImps() {
        _ = cb.expectedScoreCalc(result: 0, hcp: 20, vulnNum: 1) // expected = 0
        let imps = cb.impPoints(suit: "N1Minor", result: 0, vulnNum: 1, double: 0) // actual = 70, diff = 70
        XCTAssertEqual(imps, "2")
    }

    func testImpPointsWithoutPriorExpectedScoreCalcUsesStaleDefault() {
        // Known footgun: impPoints() does not call expectedScoreCalc() itself, so on a
        // freshly constructed CalculatorBrain it reads the struct's default
        // expectedScore of -1 instead of a real expected score. Since -1 is not a
        // multiple of 10 (every real bridge score is), the resulting score
        // difference falls into a gap the IMP table never intended to cover, and
        // findMinElement silently falls back to its initial value of 24 -
        // the maximum IMP swing - rather than a value reflecting the true difference.
        let freshBrain = CalculatorBrain()
        var mutableBrain = freshBrain
        let imps = mutableBrain.impPoints(suit: "N4Major", result: 0, vulnNum: 1, double: 0)
        XCTAssertEqual(imps, "24", "documents the current (incorrect) fallback behavior when expectedScoreCalc isn't called first")
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
