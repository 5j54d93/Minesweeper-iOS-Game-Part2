//
//  View+Extension.swift
//  Minesweeper-iOS-Game
//
//  Created by 莊智凱 on 2022/5/29.
//

import SwiftUI

extension View {
    func snapshot() -> UIImage {
        let controller = UIHostingController(
            rootView: self.ignoresSafeArea()
                .fixedSize(horizontal: true, vertical: true)
        )
        let view = controller.view
        
        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear
        
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        
        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}

