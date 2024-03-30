//
//  Tables.swift
//  IMPBridge
//
//  Created by Patrick Parno on 2023-12-16.
//

import Foundation

struct Tables {
    // tables are N or V for vulnerable? then number for contract level (1 = 9 tricks)
    // each set of numbers stands for how many tricks you got; only if you made contract or better
    // first is not doubled, second is doubled, third is redoubled; so if you are down 3 and doubled, you get -500
    
    let N1Minor = [[70,140,230],[90,240,430],[110,340,630],[130,440,830],[150,540,1030],[170,640,1230],[190,740,1430]]
    let V1Minor = [[70,140,230],[90,340,630],[110,540,1030],[130,740,1430],[150,940,1830],[170,1140,2230],[190,1340,2630]]
    
    let N1Major = [[80,160,520],[110,260,720],[140,360,920],[170,460,1120],[200,560,1320],[230,660,1520],[260,760,1720]]
    let V1Major = [[80,160,720],[110,360,1120],[140,560,1520],[170,760,1920],[200,960,2320],[230,1160,2720],[260,1360,3120]]
    
    let N1NT = [[90,180,560],[120,280,760],[150,380,960],[180,480,1160],[210,580,1360],[240,680,1560],[270,780,1760]]
    let V1NT = [[90,180,760],[120,380,1160],[150,580,1560],[180,780,1960],[210,980,2360],[240,1180,2760],[270,1380,3160]]
    
    let N2Minor = [[90,180,560],[110,280,760],[130,380,960],[150,480,1160],[170,580,1360],[190,680,1560]]
    let V2Minor = [[90,180,760],[110,380,1160],[130,580,1560],[150,780,1960],[170,980,2360],[190,1180,2760]]
    
    let N2Major = [[110,470,640],[140,570,840],[170,670,1040],[200,770,1240],[230,870,1440],[260,970,1640]]
    let V2Major = [[110,670,840],[140,870,1240],[170,1070,1640],[200,1270,2040],[230,1470,2440],[260,1670,2840]]
    
    let N2NT = [[120,490,680],[150,590,880],[180,690,1080],[210,790,1280],[240,890,1480],[270,990,1680]]
    let V2NT = [[120,690,880],[150,890,1280],[180,1090,1680],[210,1290,2080],[240,1490,2480],[270,1690,2880]]
    
    let N3Minor = [[110,470,640],[130,570,840],[150,670,1040],[170,770,1240],[190,870,1440]]
    let V3Minor = [[110,670,840],[130,870,1240],[150,1070,1640],[170,1270,2040],[170,1470,2440]]
    
    let N3Major = [[140,530,760],[170,630,960],[200,730,1160],[230,830,1360],[260,930,1560]]
    let V3Major = [[140,730,960],[170,930,1360],[200,1130,1760],[230,1330,2160],[260,1530,2560]]
    
    let N3NT = [[400,550,800],[430,650,1000],[460,750,1200],[490,850,1400],[520,950,1600]]
    let V3NT = [[600,750,1000],[630,950,1400],[660,1150,1800],[690,1350,2200],[720,1550,2600]]
    
    let N4Minor = [[130,510,720],[150,610,920],[170,710,1120],[190,810,1320]]
    let V4Minor = [[130,710,920],[150,910,1320],[170,1110,1720],[190,1310,2120]]
    
    let N4Major = [[420,590,880],[450,690,1080],[480,790,1280],[510,890,1480]]
    let V4Major = [[620,790,1080],[650,990,1480],[680,1190,1880],[710,1390,2280]]
    
    let N4NT = [[430,610,920],[460,710,1120],[490,810,1320],[520,910,1520]]
    let V4NT = [[630,810,1120],[660,1010,1520],[690,1210,1920],[720,1410,2320]]
    
    let N5Minor = [[400,550,800],[420,650,1000],[440,750,1200]]
    let V5Minor = [[600,750,1000],[620,950,1400],[640,1150,1800]]
    
    let N5Major = [[450,650,1000],[480,750,1200],[510,850,1400]]
    let V5Major = [[650,850,1200],[680,1050,1600],[710,1250,2000]]
    
    let N5NT = [[460,670,1040],[490,770,1240],[520,870,1440]]
    let V5NT = [[660,870,1240],[690,1070,1640],[720,1270,2040]]
    
    let N6Minor = [[920,1090,1380],[940,1190,1580]]
    let V6Minor = [[1370,1540,1830],[1390,1740,2230]]
    
    let N6Major = [[980,1210,1620],[1010,1310,1820]]
    let V6Major = [[1430,1660,2070],[1460,1860,2470]]
    
    let N6NT = [[990,1230,1660],[1020,1330,1860]]
    let V6NT = [[1440,1680,2110],[1470,1880,2510]]
    
    let N7Minor = [[1440,1630,1960]]
    let V7Minor = [[2140,2330,2660]]
    
    let N7Major = [[1510,1770,2240]]
    let V7Major = [[2210,2470,2940]]
    
    let N7NT = [[1520,1790,2280]]
    let V7NT = [[2220,2490,2980]]
    
    // in this case, the contract is set
    let downN = [[50,100,200],[100,300,600],[150,500,1000],[200,800,1600],[250,1100,2200],[300,1400,2200],[350,1700,3400],[400,2000,4000],[450,2300,4600],[500,2600,5200],[550,2900,5800],[600,3200,6400],[650,3500,7000]]
    let downV = [[100,200,400],[200,500,1000],[300,800,1600],[400,1100,2200],[500,1400,2800],[600,1700,3400],[700,2000,4000],[800,2300,4600],[900,2600,5200],[1000,2900,5800],[1100,3200,6400],[1200,3500,7000],[1300,3800,7600]]
     
    // first number is hcp > 20, second is not vulnerable, third is vulnerable
    let expectedScoreDifference = [[0,0,0],[1,50,50],[2,90,90],[3,120,120],[4,140,140],[5,400,600],[6,420,620],[7,420,620],[8,430,630],[9,450,650],[10,450,850],[11,460,660],[12,920,1370],[13,950,1400],[14,980,1430],[15,980,1430],[16,1440,2140],[17,1010,1460],[18,1480,2180],[19,1500,2200],[20,1520,2220]]
    
    let impPoints = [[0,10,0],[20,40,1],[50,80,2],[90,120,3],[130,160,4],[170,210,5],[220,260,6],[270,310,7],[320,360,8],[370,420,9],[430,490,10],[500,590,11],[600,740,12],[750,890,13],[900,1090,14],[1100,1290,15],[1300,1490,16],[1500,1740,17],[1750,1990,18],[2000,2240,19],[2250,2490,20],[2500,2990,21],[3000,3490,22],[3500,3990,23],[4000,10000,24]]
    
    let suit = ["Clubs","Diamonds","Hearts","Spades","No Trump"]
    
    
}
