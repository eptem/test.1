//
//  GroupedOffers.swift
//  NapoleonTestTask
//
//  Created by Артем Жорницкий on 28/03/2019.
//  Copyright © 2019 Артем Жорницкий. All rights reserved.
//

import Foundation

class groupedOffer {
    var name : String
    var offer : [Offer]
    init(name : String, offer : [Offer])
    {
        self.name = name
        self.offer = offer
    }
}
