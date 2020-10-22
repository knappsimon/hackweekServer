//
//  Poll.swift
//  
//
//  Created by Simon Knapp on 10/19/20.
//

import Fluent
import FluentMongoDriver
import Foundation
import Vapor

struct PollOption: Codable {
    var id: String
    var answer: String
    var totalVotes: Int
    var mediaURL: String?
}

final class Poll: Model, Content {
    static let schema = "poll"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "poll_title")
    var pollTitle: String

    @Field(key: "poll_description")
    var pollDescription: String

    @Field(key: "station_id")
    var stationId: String

    @Field(key: "restricted_to_station")
    var restrictedToStation: Bool

    @Field(key: "poll_options")
    var pollOptions: [PollOption]

    init() { }

    init(id: UUID? = nil, pollTitle: String, pollDescription: String, stationId: String, restrictedToStation:Bool = false, pollOptions: [PollOption]) {
        self.id = id
        self.pollTitle = pollTitle
        self.pollDescription = pollDescription
        self.stationId = stationId
        self.restrictedToStation = restrictedToStation
        self.pollOptions = pollOptions
    }
}
