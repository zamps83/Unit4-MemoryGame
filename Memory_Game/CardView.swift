import SwiftUI

struct CardView: View {
    let card: Card
    let width: CGFloat
    let height: CGFloat
    let isFaceUp: Bool
    let onTap: () -> Void
    
    var body: some View {
        ZStack {
            // Back side of the card
            Rectangle()
                .fill(Color.blue)
                .frame(width: width, height: height)
                .cornerRadius(10)
                .shadow(radius: 5)
            
            // Front side of the card (if face up)
            if isFaceUp {
                Text(card.value)
                    .font(.largeTitle)
                    .foregroundColor(.white)
            }
        }
        .onTapGesture {
            onTap()
        }
        .rotation3DEffect(
            .degrees(isFaceUp ? 0 : 180),
            axis: (x: 0, y: 1, z: 0)
        )
        .animation(.spring(), value: isFaceUp)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: Card(id: 1, value: "A", isFaceUp: false, isMatched: false), width: 80, height: 120, isFaceUp: false) {}
    }
}
