//
//  NoteStruct.swift
//  AdventurePlanner
//
//  Created by Keming Liang on 4/28/24.
//  Copyright © 2024 Keming Liang. All rights reserved.
//

import SwiftUI

struct NoteStruct: Decodable, Encodable {
    var id: Int
    var note: String
    var date: String
}
