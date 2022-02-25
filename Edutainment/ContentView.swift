//
//  ContentView.swift
//  Edutainment
//
//  Created by Yosef Ben Zaken on 25/02/2022.
//

import SwiftUI

struct ContentView: View {
    @State private var maxNumber: Int = 2
    @State private var questions: [Int] = [5, 10, 20]
    @State private var selectQuestion: Int = 5
    @State private var gameStart: Bool = false
    @State private var listOfQuestion: [Question] = []
    @State private var listOfAnswer: [Bool] = []
    @State private var questionNumber: Int = 0
    @State private var answer: String = ""
    @State private var showGameOver: Bool = false
    @State private var animal: Int = Int.random(in: 0...29)
    let animals: [String] = ["bear", "buffalo", "chick", "chicken", "cow", "crocodile", "dog", "duck", "elephant", "frog", "giraffe", "goat", "gorilla", "hippo", "horse", "monkey", "moose", "narwhal", "owl", "panda", "parrot", "penguin", "pig", "rabbit", "rhino", "sloth", "snake", "walrus", "whale", "zebra"]
    var body: some View {
        NavigationView {
            
            if gameStart {
                Group {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Image(animals[animal])
                                .resizable()
                                .renderingMode(.original)
                                .frame(width: 100, height: 100, alignment: .center)
                                .shadow(radius: 5)
                            Spacer()
                        }
                        Spacer()
                        Text("Question number \(questionNumber + 1)")
                            .font(.title)
                        listOfQuestion[questionNumber]
                            .font(.headline)
                            .frame(maxWidth:.infinity, alignment: .center)
                        TextField("Your answer", text: $answer)
                            .textFieldStyle(.roundedBorder)
                            .padding(50)
                            .onSubmit {
                                if listOfQuestion[questionNumber].correctAnswer(Int(answer) ?? 0) {
                                    listOfAnswer[questionNumber] = true
                                }
                                if questionNumber < selectQuestion - 1 {
                                    questionNumber += 1
                                } else {
                                    showGameOver = true
                                }
                                animal = Int.random(in: 0...29)
                                answer = ""
                            }
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                    }
                }
                .navigationTitle("Edutainment")
                .navigationBarTitleDisplayMode(.inline)
                .alert("GameOver", isPresented: $showGameOver) {
                    Button("Restart Game") {
                        gameStart.toggle()
                    }
                } message: {
                    Text("Answer correct: \(listOfAnswer.filter { $0 }.count)/\(selectQuestion)")
                }
            } else {
                Group {
                    VStack {
                        
                        Text("Welcome to Edutainment Game")
                            .font(.headline)
                        HStack {
                            Spacer()
                            Image(animals[animal])
                                .resizable()
                                .renderingMode(.original)
                                .frame(width: 100, height: 100, alignment: .center)
                                .shadow(radius: 5)
                            Spacer()
                        }
                        Spacer()
                        Stepper("Max number up to \(maxNumber)", value: $maxNumber, in: 2...12,step: 1)
                    
                        Picker("How much question", selection: $selectQuestion) {
                            ForEach(questions, id: \.self) {
                                Text($0,format: .number)
                            }
                        }
                        .pickerStyle(.segmented)
                        Spacer()
                        Spacer()
                        Spacer()
                    }
                    .padding(50)
                }
                .navigationTitle("Edutainment")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    if !gameStart {
                        Button("Start Game") {
                            withAnimation {
                                startGame()
                            }
                        }
                    }
                }
            }
        }
    }
    func startGame() {
        animal = Int.random(in: 0...29)
        questionNumber = 0
        listOfQuestion = []
        listOfAnswer = []
        for _ in 0..<selectQuestion {
            let firstNum = Int.random(in: 0...maxNumber)
            let secNum = Int.random(in: 0...maxNumber)
            listOfQuestion.append(Question(text: "\(firstNum) * \(secNum) = ?", answer: firstNum * secNum))
            listOfAnswer.append(false)
        }
        gameStart.toggle()
        print(listOfQuestion)
    }
}
struct Question: View {
    let text: String
    let answer: Int
    var body: some View {
        Text(text)
    }
    func correctAnswer(_ ans: Int) -> Bool {
        ans == answer
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
