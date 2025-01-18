//
//  AdventureItem.swift
//  AdventurePlanner
//
//  Created by Nicholas Emig on 4/30/24.
//  Copyright © 2024 Nicholas Emig. All rights reserved.
//

import SwiftUI

struct AdventureItem: View {
    
    let adv: Adventure
    
    var body: some View {
        HStack {
            Spacer()
            Text(adv.name)
            Spacer()
        }
    }
}
