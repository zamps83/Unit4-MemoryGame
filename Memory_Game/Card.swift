import Foundation

struct Card: Identifiable {
    var id: Int
    var value: String
    var isFaceUp: Bool = false
    var isMatched: Bool = false
    
    // This method generates a shuffled deck of cards
    static func generateCards(pairsCount: Int) -> [Card] {
        var cards: [Card] = []
        
        // Create card pairs
        for i in 1...pairsCount {
            let card = Card(id: i, value: String(i))
            cards.append(card)
            cards.append(card)
        }
        
        // Shuffle the cards
        cards.shuffle()
        
        return cards
    }
}
