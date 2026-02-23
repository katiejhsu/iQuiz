//
//  Quiz.swift
//  iQuiz
//
//  Created by Katie Hsu on 2/23/26.
//

import Foundation

struct QuizTopic: Codable {
    let title: String
    let desc: String
    let questions: [Question]
}

struct Question: Codable {
    let text: String
    let answer: String 
    let answers: [String]
}
