import SwiftUI
import AVFoundation

struct PlayerView: View {
    
    // The audio title chosen on the previous screen
    let audioTitle: String
    
    // Total duration for the meditation (in minutes)
    let duration: Int
    
    // We’ll hold onto the audio player instance so we can control playback
    @State private var audioPlayer: AVAudioPlayer?
    
    // Quick flag to indicate if audio is currently playing
    @State private var isPlaying = false
    
    // We capture the moment playback started
    @State private var startTime = Date()
    
    // We'll use this to keep track of the current time, updated every second
    @State private var currentTime = Date()
    
    // A simple toggle to animate the pulsing circles on screen
    @State private var animateCircle = false
    
    // A timer to automatically stop the audio after the user’s chosen duration
    @State private var stopTimer: Timer?
    
    // This lets us dismiss the current view programmatically
    @Environment(\.dismiss) var dismiss
    
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
            
            VStack(spacing: 20) {
                // Show which audio track is currently playing
                Text("Playing: \(audioTitle)")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.top, 50)
                
                // The “pulsing circles” effect in the center
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 200, height: 200)
                        .scaleEffect(animateCircle ? 1.1 : 0.9)
                        .animation(
                            .easeInOut(duration: 1)
                            .repeatForever(autoreverses: true),
                            value: animateCircle
                        )
                    
                    Circle()
                        .stroke(Color.white.opacity(0.4), lineWidth: 4)
                        .frame(width: 220, height: 220)
                        .scaleEffect(animateCircle ? 1.2 : 0.8)
                        .animation(
                            .easeInOut(duration: 1.5)
                            .repeatForever(autoreverses: true),
                            value: animateCircle
                        )
                }
                .onAppear {
                    // Kick off the circle animation right away
                    animateCircle = true
                }
                
                // Calculate how many minutes/seconds remain and show them
                let (minutesLeft, secondsLeft) = timeRemaining()
                Text("Time left: \(minutesLeft) min \(secondsLeft) sec")
                    .font(.title3)
                    .foregroundColor(.white)
                
                Spacer()
                
                // The stop button at the bottom
                Button(action: {
                    stopAudio()
                    dismiss() // Return to the previous screen
                }) {
                    Text("Stop")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red.opacity(0.6))
                        .cornerRadius(10)
                }
                .padding(.bottom, 50)
            }
        }
        // Hide the default back button, so only the Stop button is available
        .navigationBarBackButtonHidden(true)
        
        .onAppear {
            // Start playing audio as soon as we arrive on this screen
            startAudioPlayback()
        }
        .onDisappear {
            // Stop everything when we leave
            stopAudio()
        }
        // Use a 1-second repeating timer so the text showing time left updates live
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
            currentTime = Date()
        }
    }
    
    /// Figure out how many minutes and seconds remain until the session ends.
    private func timeRemaining() -> (Int, Int) {
        // How many seconds have passed since we started?
        let elapsed = currentTime.timeIntervalSince(startTime)
        // Convert total duration (in minutes) to seconds
        let totalSeconds = Double(duration * 60)
        // Subtract elapsed from total
        let remaining = max(totalSeconds - elapsed, 0)
        
        // Break it down into minutes and leftover seconds
        let minutes = Int(remaining / 60)
        let seconds = Int(remaining.truncatingRemainder(dividingBy: 60))
        return (minutes, seconds)
    }
    
    /// Loads and starts playing the audio file, sets it to loop, and sets up a stop timer.
    private func startAudioPlayback() {
        // Convert the chosen track name into an actual .mp3 file in our bundle
        guard let url = Bundle.main.url(forResource: pickAudioFileName(), withExtension: "mp3") else {
            print("Audio file not found.")
            return
        }
        
        do {
            // Prepare the audio player
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            // Loop forever until we stop it (or the timer stops it)
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.play()
            isPlaying = true
            startTime = Date()
            
            // Schedule a timer to stop the audio after the chosen duration
            stopTimer = Timer.scheduledTimer(withTimeInterval: Double(duration * 60), repeats: false) { _ in
                stopAudio()
                dismiss() // Also dismiss automatically if the timer runs out
            }
        } catch {
            print("Error playing audio: \(error.localizedDescription)")
        }
    }
    
    /// Halts playback and resets related states/timers.
    private func stopAudio() {
        audioPlayer?.stop()
        audioPlayer = nil
        isPlaying = false
        
        // Cancel the stop timer if it’s still active
        stopTimer?.invalidate()
        stopTimer = nil
    }
    
    /// Maps the user’s chosen audio title to one of our .mp3 filenames.
    private func pickAudioFileName() -> String {
        switch audioTitle {
        case "Deep Meditation to Relax":
            return "relax1"
        case "Complete Focus of Mind":
            return "relax2"
        case "Relaxing Meditation to Soul":
            return "relax3"
        case "Deep Sleep of Mind":
            return "relax4"
        default:
            return "relax1"
        }
    }
}



