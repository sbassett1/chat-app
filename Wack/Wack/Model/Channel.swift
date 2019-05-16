//
//  Channel.swift
//  Wack
//
//  Created by Stephen Bassett on 5/16/19.
//  Copyright © 2019 Stephen Bassett. All rights reserved.
//

import Foundation

struct Channel: Decodable {

    // For Swift 4 Decoder
    // Must include all elements expected in response
    // And they must be in the correct order as well

    public private(set) var _id: String
    public private(set) var name: String
    public private(set) var description: String
    public private(set) var __v: Int?

//    public private(set) var name: String
//    public private(set) var description: String
//    public private(set) var id: String
}
