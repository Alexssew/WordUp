//
//  ContentView.swift
//  WordUp
//
//  Created by Alex on 09/03/2022.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var vm = ViewModel()
    /*V1.
    //    @State private var usedWords = [String]()
    //    @State private var rootWord = ""
    //    @State private var newWord = ""
    //
    //    @State private var errorTitle = ""
    //    @State private var errorMessage = ""
    //    @State private var showError = false
    //
    //    @State private var score = 0
    //
    //    @State var animate = false
    //
    //    @State var showHelp = false
     */
    
    var body: some View {
        NavigationView {
            
            AngularGradient(colors: [Color.purple.opacity(0.7), Color.blue.opacity(0.3), Color.red.opacity(0.6)], center: .topLeading, angle: .degrees(140))
                .ignoresSafeArea().overlay {
                    List {
                        Section {
                            TextField("Enter your word here ...", text: $vm.newWord)
                                .textInputAutocapitalization(.never)
                                .padding()
                                .onSubmit {
                                    vm.save()
                                }
                            
                        }
                        HStack(spacing: 100) {
                            VStack {
                                VStack(alignment: .leading){
                                    ForEach(vm.usedWords, id: \.self) { word in
                                        HStack(alignment: .top) {
                                            VStack {
                                                Image(systemName: "\(word.count).circle")
                                            }
                                            VStack {
                                                Text(word)
                                            }
                                        }// making better accessibility options
                                        .accessibilityElement()
                                        .accessibilityLabel(word)
                                        .accessibilityHint("\(word.count) letters")
                                    }
                                    
                                }
                            }
                            VStack (alignment: .center) {
                                Text("Your Score")
                                    .font(.subheadline).bold()
                                    .foregroundColor(.purple)
                                    .padding(2)
                                Text("\(vm.score)")
                                    .foregroundColor(vm.score > 50 ? .green : .red)
                                    .animation(.easeInOut)
                                    .font( vm.score > 50 ? .headline : .subheadline)
                                    .padding(3)
                                    .overlay(
                                        Circle()
                                            .stroke()
                                        
                                    )
                                    .padding(3)
                                Capsule()
                                    .fill(Color.black)
                                    .frame(width: 100, height: 2)
                                Text("Top Score")
                                    .font(.subheadline).bold()
                                    .foregroundColor(.blue)
                                    .padding(2)
                                Text("\(vm.topScore)")
                                    .font(.headline).bold()
                                    .foregroundColor(.blue)
                                    .padding(3)
                                    .overlay(
                                        Circle()
                                            .stroke()
                                        
                                    )
                            }
                        }
                        VStack(spacing: 20.0){
                            if vm.score > 49, vm.score < 100 {
                                VStack {
                                    Text("Good... keep going" )
                                        .foregroundColor(.blue)
                                        .fontWeight(.semibold)
                                    Text("💪🏼 👌🏽")
                                }
                            }else if vm.score > 99, vm.score < 110 {
                                Text("Well Done! 🎉 🥳  ")
                                    .foregroundColor(.green)
                                    .bold()
                                    .onTapGesture(perform: vm.startGame)
                            }else if vm.score > 109 {
                                Text("Splendid! 🎉 🥳 🤗 ")
                                    .foregroundColor(.green)
                                    .bold()
                                    .onTapGesture(perform: vm.startGame)
                            }else if vm.score > 40 {
                                Text("You can do this...")
                                    .foregroundColor(.cyan)
                                
                            }else if vm.score > vm.topScore {
                                Text("Great! You have a new Top Score!!...")
                                    .foregroundColor(.cyan)
                                
                            }else {
                                Text("Test Your Limits 😇")
                            }
                            
                            
                        }  .frame(height: 100)
                            .frame(maxWidth: vm.animate ? UIScreen.main.bounds.width : 300)
                            .background( vm.animate ? .purple.opacity(0.2) : Color.white)
                            .cornerRadius(15)
                            .padding(.horizontal, vm.animate ? 30 : 70)
                            .shadow(
                                color: vm.animate ? Color.accentColor.opacity(0.6) : .purple.opacity(0.7),
                                radius: vm.animate ? 25 : 15,
                                x: 0, y: vm.animate ? 40 : 30)
                            .scaleEffect(vm.animate ? 1.1 : 1.0)
                            .offset(x: 0, y: vm.animate ? -6 : 0)
                        
                    }.confirmationDialog("Help", isPresented: $vm.showHelp) {
                        Button("Create words from the given word") {
                            //no code here
                        }
                        Button("Have fun! 🤪") {
                            //no code here
                        }
                        
                    }
                }
            
                .navigationTitle(vm.rootWord)
            
                .onSubmit {
                    vm.addNewWord()
                    vm.calScore()
                }
                .onAppear(perform: vm.startGame)
                .onAppear(perform: vm.addAnimation)
                .alert(isPresented: $vm.showError) {
                    Alert(title: Text(vm.errorTitle), message: Text(vm.errorMessage), dismissButton: .cancel(Text("OK")))
                }
                .toolbar {
                    Button {
                        vm.startGame()
                    } label: {
                        HStack {
                            Text("Another Word")
                                .foregroundColor(.blue).bold()
                            Image(systemName: "shuffle.circle.fill")
                        }
                        
                    }
                    
                }
                .toolbar {
                    ToolbarItem(placement: .bottomBar, content: {
                        Button {
                            vm.showHelp = true
                        } label: {
                            Image(systemName: "questionmark.circle")
                            
                        }
                    })
                }
            
        }
        
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
