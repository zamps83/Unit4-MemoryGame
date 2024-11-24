import SwiftUI

struct ContentView: View {
    
    // State variables for managing game state
    @State private var cards: [Card] = []
    @State private var firstCardIndex: Int? = nil
    @State private var secondCardIndex: Int? = nil
    @State private var gameOver = false
    @State private var pairsCount = 2 // Default to 2 pairs
    
    let cardWidth: CGFloat = 80
    let cardHeight: CGFloat = 120
    
    // This will reset the game state
    func resetGame() {
        cards = Card.generateCards(pairsCount: pairsCount)
        firstCardIndex = nil
        secondCardIndex = nil
        gameOver = false
    }
    
    // Check if two cards match
    func checkForMatch() {
        if let firstIndex = firstCardIndex, let secondIndex = secondCardIndex {
            if cards[firstIndex].id == cards[secondIndex].id {
                // Cards match, set them as "matched"
                cards[firstIndex].isMatched = true
                cards[secondIndex].isMatched = true
                // Check if game is over
                gameOver = cards.allSatisfy { $0.isMatched }
            } else {
                // Delay and flip cards back down if they don't match
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    cards[firstIndex].isFaceUp = false
                    cards[secondIndex].isFaceUp = false
                }
            }
            // Reset for next turn
            firstCardIndex = nil
            secondCardIndex = nil
        }
    }
    
    var body: some View {
        VStack {
            // Game title and reset button
            Text("Memory Game")
                .font(.largeTitle)
                .bold()
                .padding()
            
            // Picker to choose number of pairs
            Picker("Select Number of Pairs", selection: $pairsCount) {
                ForEach(2..<7) { num in
                    Text("\(num) pairs").tag(num)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            // Grid layout of cards
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: cardWidth))], spacing: 20) {
                    ForEach(0..<cards.count, id: \.self) { index in
                        // Only show cards that aren't matched
                        if !cards[index].isMatched {
                            CardView(card: cards[index], width: cardWidth, height: cardHeight, isFaceUp: cards[index].isFaceUp) {
                                // Only flip the card if fewer than 2 cards are face up
                                if firstCardIndex == nil {
                                    firstCardIndex = index
                                    cards[index].isFaceUp.toggle()
                                } else if secondCardIndex == nil, index != firstCardIndex {
                                    secondCardIndex = index
                                    cards[index].isFaceUp.toggle()
                                    checkForMatch() // Check if the cards match after the second flip
                                }
                            }
                            .padding(5)
                        }
                    }
                }
                .padding()
            }
            
            // Reset button to start a new game
            Button("Reset Game") {
                resetGame()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.bottom, 20)
        }
        .onAppear {
            resetGame()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
