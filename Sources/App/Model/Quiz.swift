//
//  Quiz.swift
//
//
//  Created by Simon Knapp on 10/19/20.
//

import Fluent
import FluentMongoDriver
import Foundation
import Vapor

struct QuizOption: Content, Codable {
    var answer: String
    var isCorrect: Bool
    var mediaURL: String?
}

final class Quiz: Model, Content {
    static let schema = "quiz"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "quiz_title")
    var quizTitle: String

    @Field(key: "quiz_description")
    var quizDescription: String

    @Field(key: "station_id")
    var stationId: String

    @Field(key: "restricted_to_station")
    var restrictedToStation: Bool
    
    @Field(key: "quiz_options")
    var quizOptions: [QuizOption]

    init() { }

    init(id: UUID? = nil, quizTitle: String, quizDescription: String, stationId: String, restrictedToStation:Bool = false, quizOptions: [QuizOption]) {
        self.id = id
        self.quizTitle = quizTitle
        self.quizDescription = quizDescription
        self.stationId = stationId
        self.restrictedToStation = restrictedToStation
        self.quizOptions = quizOptions
    }
}
