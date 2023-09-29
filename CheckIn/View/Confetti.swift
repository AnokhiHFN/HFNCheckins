import SwiftUI

struct ConfettiView: View {
    let colors: [Color]
    let number: Int
    let speed: Double
    
    var body: some View {
        ZStack {
            ForEach(0..<number, id: \.self) { _ in
                ConfettiPiece(colors: colors, speed: speed)
            }
        }
    }
}

struct ConfettiPiece: View {
    let colors: [Color]
    let speed: Double
    
    @State private var rotation: Double = .random(in: 0...360)
    @State private var position: CGPoint = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2) // Center
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.clear) // Set the background color to clear
                .frame(width: 10, height: 20)
                .rotationEffect(.degrees(rotation))
                .position(position)
            
            // Add the confetti shape (you can replace this with your desired shape)
            Image(systemName: "sparkles")
                .foregroundColor(colors.randomElement() ?? .red)
                .frame(width: 10, height: 20)
                .rotationEffect(.degrees(rotation))
                .position(position)
        }
        .background(Color.clear) // Set the ZStack's background color to clear
        .onAppear {
            withAnimation(Animation.linear(duration: speed).repeatForever(autoreverses: false)) {
                self.rotation += .random(in: -45...45) // Random rotation
                self.position.x = .random(in: 0...UIScreen.main.bounds.width) // Random horizontal position
                self.position.y = .random(in: 0...UIScreen.main.bounds.height) // Random vertical position
            }
        }
    }
}
