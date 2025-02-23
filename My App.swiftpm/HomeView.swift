import SwiftUI

struct HomeView: View {
    
    // List of audio titles
    let audioOptions = [
        "Deep Meditation to Relax",
        "Complete Focus of Mind",
        "Relaxing Meditation to Soul",
        "Deep Sleep of Mind"
    ]
    
    var body: some View {
        ZStack {
            // Subtle gradient background
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
                Text("For a better YOU!")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.top, 40)
                
                // Simple cards for each audio option
                ForEach(audioOptions, id: \.self) { audioTitle in
                    NavigationLink(destination: MeditateView(selectedAudio: audioTitle)) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 25)
                                .fill(Color.white.opacity(0.2))
                                .background(.ultraThinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 25))
                                .shadow(color: .white.opacity(0.1), radius: 10, x: 0, y: 5)
                            
                            HStack {
                                Text(audioTitle)
                                    .foregroundColor(.white)
                                    .font(.headline)
                                Spacer()
                                Image(systemName: "play.circle.fill")
                                    .foregroundColor(.white)
                                    .font(.title2)
                            }
                            .padding()
                        }
                        .frame(height: 60)
                        .padding(.horizontal)
                    }
                }
                
                Spacer()
            }
        }
    }
}
