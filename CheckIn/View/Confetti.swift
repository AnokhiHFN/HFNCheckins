import SwiftUI

struct ConfettiView: View {
    let colors: [Color]
    let number: Int
    let speed: Double
    
    var body: some View {
        ZStack {
            ForEach(0..<number, id: \.self) { _ in
                Group {
                    if Bool.random() {
                        CircleConfettiPiece(colors: colors, speed: speed)
                    } else {
                        RectangleConfettiPiece(colors: colors, speed: speed)
                    }
                }
            }
        }
    }
}

struct CircleConfettiPiece: View {
    let colors: [Color]
    let speed: Double
    
    @State private var rotation: Double = .random(in: 0...360)
    @State private var position: CGPoint = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 3) // Center
    
    var body: some View {
        ZStack {
            Circle()
                .fill(colors.randomElement() ?? .red) // Fill with a random color from your array
                .frame(width: 4, height: 4) // Adjust the size of the circle
                .rotationEffect(.degrees(rotation))
                .position(position)
        }
        .background(Color.clear) // Set the ZStack's background color to clear
        .onAppear {
            withAnimation(Animation.linear(duration: speed).repeatForever(autoreverses: false)) {
                self.rotation += .random(in: -360...360) // Random rotation
                self.position.x = .random(in: 0...UIScreen.main.bounds.width) // Random horizontal position
                self.position.y = .random(in: 0...UIScreen.main.bounds.height) // Random vertical position
            }
        }
    }
}

struct RectangleConfettiPiece: View {
    let colors: [Color]
    let speed: Double
    
    @State private var rotation: Double = .random(in: 0...360)
    @State private var position: CGPoint = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 3) // Center
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(colors.randomElement() ?? .red) // Fill with a random color from your array
                .frame(width: 8, height: 8) // Adjust the size of the rectangle
                .rotationEffect(.degrees(rotation))
                .position(position)
        }
        .background(Color.clear) // Set the ZStack's background color to clear
        .onAppear {
            withAnimation(Animation.linear(duration: speed).repeatForever(autoreverses: false)) {
                self.rotation += .random(in: -360...360) // Random rotation
                self.position.x = .random(in: 0...UIScreen.main.bounds.width) // Random horizontal position
                self.position.y = .random(in: 0...UIScreen.main.bounds.height) // Random vertical position
            }
        }
    }
}

