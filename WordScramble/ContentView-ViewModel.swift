//
//  ContentView-ViewModel.swift
//  BucketList
//
//  Created by Alex on 02/04/2022.
//
// private(set) means that now the class is the only one to write changes to that property but the view can read ..but not write.

import Foundation
import SwiftUI

extension ContentView {
    class ViewModel: ObservableObject {
        
        @Published var topScore: Int
        
        @Published var usedWords = [String]()
        @Published var rootWord = ""
        @Published var newWord = ""
        
        @Published var errorTitle = ""
        @Published var errorMessage = ""
        @Published var showError = false
        
        @Published var score = 0
        
        @Published var animate = false
        
        @Published var showHelp = false
        
        let savePath = FileManager.documentsDirectory.appendingPathComponent("TopScore")
        
        init() {
            
            UITableView.appearance().backgroundColor = UIColor.clear // Uses UIColor
            UITableViewCell.appearance().backgroundColor = .clear
            
            do {
                let data = try Data(contentsOf: savePath)
                topScore = try JSONDecoder().decode(Int.self, from: data)
                print("\(topScore)")
            } catch {
                topScore = 0
                print("error getting topscore from filemanager\(error.localizedDescription)")
            }
        }
        
        func save() {
            do {
                let data = try JSONEncoder().encode(topScore)
                try data.write(to: savePath, options: [.atomic])
                print(savePath.path)
            } catch {
                print("unable to save top score")
            }
        }
        
        func addNewWord(){
            //lowercase and trim the word to make sure we dont add duplicates of different cases
            let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
            
            //exit if the remaining string is empty
            guard answer.count > 0 else {return}
            
            //extra validation
            guard isOriginal(word: answer) else {
                wordError(title: "Word used already", message: "Ooops!")
                return
            }
            guard isPossible(word: answer) else {
                wordError(title: "word not possible", message: "You can not spell that word from '\(rootWord)'")
                return
            }
            guard isReal(word: answer) else {
                wordError(title: "Word not recognised", message: "😂 You can't just make them up, you know!")
                return
            }
            guard isLongEnough(word: answer) else {
                wordError(title: "Not a word", message: "Please write a word having atleast 3 letters")
                return
            }
            
            withAnimation {
                usedWords.insert(answer, at: 0)
            }
            newWord = ""
        }
        
        func calScore() {
            //put logic here to cacuate the score
            let numberOfWords = usedWords.count
            let allCharacters = usedWords.joined(separator: "")
            let trimmedCharacters = allCharacters.trimmingCharacters(in: .whitespacesAndNewlines)
            score = trimmedCharacters.count + (numberOfWords * 10)
            
            if score > topScore {
                topScore = score
                save()
            }
            
         
        }
        
        func startGame(){
            // 1. find the URL for start.txt in our app bundle
            if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
                // 2. load start.txt into a string
                if let startWords = try? String(contentsOf: startWordsURL) {
                    //3. split the string into an array of strings splitting on line breaks
                    let allWords = startWords.components(separatedBy: "\n")
                    
                    // 4. pick one random word or use "silkworm" as a sensible default
                    rootWord = allWords.randomElement() ?? "silkworm"
                    
                    // if we are here, all worked and so we can exit
                    // set these values below back to start to avoid adding scores and words of old word to the new word
                    usedWords = []
                    score = 0
                    self.topScore = topScore
                    
                    return
                }
            }
            
            // if we are here, then there was a problem - trigger a crash and report the error
            fatalError("could not load start.txt from bundle")
        }
        
        // functions to checks on user input regularity
        
        func isOriginal(word: String) -> Bool {
            !usedWords.contains(word)
        }
        func isPossible(word: String) -> Bool {
            var tempWord = rootWord
            
            for letter in word {
                if let pos = tempWord.firstIndex(of: letter) {
                    tempWord.remove(at: pos)
                } else {
                    return false
                }
            }
            
            return true
        }
        func isReal(word: String) -> Bool {
            let checker = UITextChecker()
            let range = NSRange(location: 0, length: word.utf16.count)
            let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
            
            return misspelledRange.location == NSNotFound
        }
        func isLongEnough(word: String) -> Bool {
            if word.count < 3 {
                return false
            }
            return true
        }
        //func to set error titles and mesages based on parameters it receives
        func wordError(title: String, message: String) {
            errorTitle = title
            errorMessage = message
            showError.toggle() //showError = true
            
        }
        
        func addAnimation(){
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation(
                    Animation
                        .easeInOut(duration: 2.0)
                        .repeatForever()
                ){
                    self.animate.toggle()
                }
            }
            
        }
       
    }
}

