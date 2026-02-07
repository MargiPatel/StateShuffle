//
//  USMapView.swift
//  ScrambledStates
//
// Created by Margi Patel on 2/3/26.
//
//  Interactive US Map for Go the Distance mode
//

import SwiftUI
import MapKit

/// Interactive, kid-friendly US map view
struct USMapView: View {
    @ObservedObject var viewModel: GameViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.5, longitude: -96.0),
        span: MKCoordinateSpan(latitudeDelta: 25.0, longitudeDelta: 40.0)
    )
    
    @State private var selectedState: StateCard?
    @State private var showStateInfo = false
    
    var body: some View {
        ZStack {
            // Map with state borders - Modern iOS 17+ API
            Map(initialPosition: .region(region)) {
                ForEach(viewModel.allStates) { state in
                    Annotation(state.abbreviation, coordinate: state.coordinates) {
                        StateMapAnnotation(
                            state: state,
                            isInHand: viewModel.playerHand.contains(state),
                            isSelected: viewModel.selectedCorrectCards.contains(state.id)
                        ) {
                            selectedState = state
                            showStateInfo = true
                        }
                    }
                }
            }
            .onMapCameraChange { context in
                region = context.region
            }
            .mapStyle(.standard(elevation: .flat, pointsOfInterest: .excludingAll))
            .ignoresSafeArea(edges: .bottom)
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 28))
                            Text("Close")
                                .font(.custom("Baloo2-SemiBold", size: 18))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(
                            Capsule()
                                .fill(Color.red.opacity(0.9))
                                .shadow(color: .black.opacity(0.3), radius: 5)
                        )
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 2) {
                        Text("🗺️ USA Map")
                            .font(.custom("Baloo2-Bold", size: 24))
                            .foregroundColor(.white)
                        
                        Text("Pinch to zoom")
                            .font(.custom("Baloo2-Regular", size: 12))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    
                    Spacer()
                    
                    // Zoom buttons
                    VStack(spacing: 10) {
                        Button(action: zoomIn) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 28))
                                .foregroundColor(.white)
                        }
                        
                        Button(action: zoomOut) {
                            Image(systemName: "minus.circle.fill")
                                .font(.system(size: 28))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal, 8)
                }
                .padding()
                .background(
                    LinearGradient(
                        colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.8)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                
                Spacer()
                
                // Challenge info and legend
                VStack(spacing: 12) {
                    // Challenge info
                    if let challenge = viewModel.currentChallenge {
                        VStack(spacing: 8) {
                            Text("Current Challenge")
                                .font(.custom("Baloo2-Regular", size: 14))
                                .foregroundColor(.white.opacity(0.9))
                            
                            Text(challenge.description)
                                .font(.custom("Baloo2-Bold", size: 16))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .lineLimit(3)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.purple.opacity(0.9))
                                .shadow(color: .black.opacity(0.3), radius: 10)
                        )
                    }
                    
                    // Legend
                    HStack(spacing: 15) {
                        LegendItem(color: .green, text: "In Your Hand")
                        LegendItem(color: .blue, text: "Selected")
                        LegendItem(color: .gray, text: "Other States")
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.white.opacity(0.95))
                            .shadow(color: .black.opacity(0.2), radius: 10)
                    )
                }
                .padding()
            }
            
            // State info popup
            if showStateInfo, let state = selectedState {
                StateInfoPopup(state: state, isInHand: viewModel.playerHand.contains(state)) {
                    showStateInfo = false
                    selectedState = nil
                }
            }
        }
    }
    
    // MARK: - Zoom Functions
    
    private func zoomIn() {
        withAnimation {
            region.span.latitudeDelta *= 0.7
            region.span.longitudeDelta *= 0.7
        }
    }
    
    private func zoomOut() {
        withAnimation {
            region.span.latitudeDelta = min(region.span.latitudeDelta * 1.3, 50.0)
            region.span.longitudeDelta = min(region.span.longitudeDelta * 1.3, 70.0)
        }
    }
}

// MARK: - State Map Annotation Component

/// State abbreviation annotation with color coding
struct StateMapAnnotation: View {
    let state: StateCard
    let isInHand: Bool
    let isSelected: Bool
    let action: () -> Void
    
    @State private var pulse = false
    
    var body: some View {
        Button(action: action) {
            ZStack {
                // Background circle
                Circle()
                    .fill(backgroundColor)
                    .frame(width: 40, height: 40)
                    .shadow(color: .black.opacity(0.3), radius: 4)
                    .overlay(
                        Circle()
                            .stroke(borderColor, lineWidth: isInHand ? 3 : 2)
                    )
                    .scaleEffect(pulse && isInHand ? 1.15 : 1.0)
                
                // State abbreviation
                Text(state.abbreviation)
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                    .foregroundColor(textColor)
                
                // Checkmark for selected
                if isSelected {
                    VStack {
                        HStack {
                            Spacer()
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 16))
                                .foregroundColor(.blue)
                                .background(
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 18, height: 18)
                                )
                        }
                        Spacer()
                    }
                    .frame(width: 40, height: 40)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .onAppear {
            if isInHand {
                withAnimation(Animation.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                    pulse = true
                }
            }
        }
    }
    
    var backgroundColor: Color {
        if isSelected {
            return Color.blue.opacity(0.3)
        } else if isInHand {
            return Color.green.opacity(0.3)
        } else {
            return Color.white.opacity(0.8)
        }
    }
    
    var borderColor: Color {
        if isSelected {
            return .blue
        } else if isInHand {
            return .green
        } else {
            return .gray
        }
    }
    
    var textColor: Color {
        if isSelected || isInHand {
            return .black
        } else {
            return .gray
        }
    }
}

// MARK: - State Info Popup

/// Kid-friendly popup showing state information
struct StateInfoPopup: View {
    let state: StateCard
    let isInHand: Bool
    let onClose: () -> Void
    
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0
    
    var body: some View {
        ZStack {
            // Semi-transparent backdrop
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation {
                        opacity = 0
                        scale = 0.8
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        onClose()
                    }
                }
            
            VStack(spacing: 20) {
                // State emoji and abbreviation
                HStack(spacing: 15) {
                    Text(state.character)
                        .font(.system(size: 60))
                    
                    Text(state.abbreviation)
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                }
                
                // State name
                Text(state.name)
                    .font(.custom("Baloo2-Bold", size: 28))
                    .foregroundColor(.primary)
                
                // Nickname
                Text("\"\(state.nickname)\"")
                    .font(.custom("Baloo2-Regular", size: 16))
                    .foregroundColor(.secondary)
                    .italic()
                
                Divider()
                
                // Info grid
                VStack(spacing: 12) {
                    InfoRow(icon: "🏛️", label: "Capital", value: state.capital)
                    InfoRow(icon: "🗺️", label: "Region", value: state.region)
                    InfoRow(icon: "🌊", label: "Coastal", value: state.isCoastal ? "Yes" : "No")
                    InfoRow(icon: "🔢", label: "Syllables", value: "\(state.syllables)")
                }
                
                // Status badge
                if isInHand {
                    HStack(spacing: 8) {
                        Image(systemName: "hand.raised.fill")
                        Text("In Your Hand")
                            .font(.custom("Baloo2-Bold", size: 16))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(
                        Capsule()
                            .fill(Color.green)
                    )
                }
                
                // Close button
                Button(action: {
                    withAnimation {
                        opacity = 0
                        scale = 0.8
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        onClose()
                    }
                }) {
                    Text("Close")
                        .font(.custom("Baloo2-Bold", size: 18))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.blue)
                        )
                }
            }
            .padding(30)
            .frame(maxWidth: 400)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color(uiColor: .systemBackground))
                    .shadow(color: .black.opacity(0.3), radius: 20)
            )
            .scaleEffect(scale)
            .opacity(opacity)
            .padding(40)
        }
        .onAppear {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                scale = 1.0
                opacity = 1.0
            }
        }
    }
}

// MARK: - Helper Components

/// Info row in state popup
struct InfoRow: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(icon)
                .font(.system(size: 20))
            Text(label + ":")
                .font(.custom("Baloo2-SemiBold", size: 16))
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.custom("Baloo2-Bold", size: 16))
                .foregroundColor(.primary)
        }
    }
}

/// Legend item
struct LegendItem: View {
    let color: Color
    let text: String
    
    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(color)
                .frame(width: 14, height: 14)
                .overlay(
                    Circle()
                        .stroke(color.opacity(0.5), lineWidth: 2)
                )
            Text(text)
                .font(.custom("Baloo2-Regular", size: 13))
                .foregroundColor(.primary)
        }
    }
}

// MARK: - StateCard Extension for Abbreviations

extension StateCard {
    var abbreviation: String {
        let abbreviations: [String: String] = [
            "Alabama": "AL", "Alaska": "AK", "Arizona": "AZ", "Arkansas": "AR",
            "California": "CA", "Colorado": "CO", "Connecticut": "CT", "Delaware": "DE",
            "Florida": "FL", "Georgia": "GA", "Hawaii": "HI", "Idaho": "ID",
            "Illinois": "IL", "Indiana": "IN", "Iowa": "IA", "Kansas": "KS",
            "Kentucky": "KY", "Louisiana": "LA", "Maine": "ME", "Maryland": "MD",
            "Massachusetts": "MA", "Michigan": "MI", "Minnesota": "MN", "Mississippi": "MS",
            "Missouri": "MO", "Montana": "MT", "Nebraska": "NE", "Nevada": "NV",
            "New Hampshire": "NH", "New Jersey": "NJ", "New Mexico": "NM", "New York": "NY",
            "North Carolina": "NC", "North Dakota": "ND", "Ohio": "OH", "Oklahoma": "OK",
            "Oregon": "OR", "Pennsylvania": "PA", "Rhode Island": "RI", "South Carolina": "SC",
            "South Dakota": "SD", "Tennessee": "TN", "Texas": "TX", "Utah": "UT",
            "Vermont": "VT", "Virginia": "VA", "Washington": "WA", "West Virginia": "WV",
            "Wisconsin": "WI", "Wyoming": "WY"
        ]
        return abbreviations[name] ?? "??"
    }
}

// MARK: - Preview

struct USMapView_Previews: PreviewProvider {
    static var previews: some View {
        USMapView(viewModel: GameViewModel())
    }
}
