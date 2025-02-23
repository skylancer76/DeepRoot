import SwiftUI

struct MeditateView: View {
    let selectedAudio: String
    
    // Time options in minutes
    let timeOptions = [15, 30, 45, 60]
    @State private var selectedTime = 15
    
    var body: some View {
        ZStack {
            // Gradient background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.blue.opacity(0.2),
                    Color.purple.opacity(0.3)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Text(selectedAudio)
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding(.top, 50)
                
                Text("Select Meditation Time")
                    .foregroundColor(.white.opacity(0.8))
                
                // Time picker
                Picker("Time (minutes)", selection: $selectedTime) {
                    ForEach(timeOptions, id: \.self) { time in
                        Text("\(time) min").tag(time)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                // Navigate to the player
                NavigationLink(destination: PlayerView(audioTitle: selectedAudio, duration: selectedTime)) {
                    Text("Play")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.opacity(0.6))
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                
                Spacer()
            }
        }
    }
}
