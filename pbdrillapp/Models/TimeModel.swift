//
//  TimeModel.swift
//  DrillTimers
//
//  Created by Yaroslav Tytarenko on 09.06.2020.
//  Copyright © 2020 Yaros H. All rights reserved.
//

import Foundation


struct TimeModel {
    let name: String
    let value: Int
    let range: ClosedRange<Int>
    let icon: String
}

extension TimeModel: Hashable {}

extension TimeModel: Codable {}