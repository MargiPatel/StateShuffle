//
//  ViewExtensions.swift
//  ScrambledStates
//
//  Created by Margi Patel on 1/28/26.

//  Utility extensions for SwiftUI views
//

import SwiftUI
import UIKit

// MARK: - Corner Radius Extension

extension View {
    /// Applies corner radius to specific corners
    /// - Parameters:
    ///   - radius: The radius to apply
    ///   - corners: Which corners to round
    /// - Returns: Modified view with rounded corners
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

/// Custom shape for rounding specific corners
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
