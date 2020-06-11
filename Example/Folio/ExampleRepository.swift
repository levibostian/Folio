//
//  ExampleRepository.swift
//  Folio
//
//  Created by Levi Bostian on 6/11/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation

typealias ExampleData = OrderedDictionary<String, [String]>

class ExampleRepository {
    
    private var observer: ((ExampleDataResult) -> Void)?
    private var currentPageNumber: Int = 1
    private var lastPageNumber: Int = 3
    
    private var isOnLastPage: Bool {
        return currentPageNumber == lastPageNumber
    }
    
    func observeExampleData(_ observer: @escaping (ExampleDataResult) -> Void) {
        self.observer = observer
        
        self.resetToFirstPage()
    }
    
    func resetToFirstPage() {
        currentPageNumber = 1
        
        deliverPageToObserver()
    }
    
    func goToNextPage() {
        guard !isOnLastPage else {
            return
        }
        
        currentPageNumber += 1
        
        deliverPageToObserver()
    }
    
    private func deliverPageToObserver() {
        var data: ExampleData = firstPageExampleData
        var areMorePages = true
        
        if currentPageNumber >= 2 {
            secondPageExampleData.forEach { (key, value) in
                data.updateValue(value, forKey: key)
            }
        }
        
        if currentPageNumber >= 3 {
            thirdPageExampleData.forEach { (key, value) in
                data.updateValue(value, forKey: key)
            }
            
            areMorePages = false
        }
        
        observer?(ExampleDataResult(data: data, areMorePages: areMorePages))
    }
    
    struct ExampleDataResult {
        let data: ExampleData
        let areMorePages: Bool
    }
}

extension ExampleRepository {
    
    private var firstPageExampleData: ExampleData {
        return [
            "Section 1": ["🎑", "🐹", "✉️", "➿", "🌆", "🏵", "🏀", "🎽", "🎛", "🆔"],
            "Section 2": ["🈹", "🐙", "💞", "📻", "🗯", "📣", "🚾", "🔔", "💧", "🍻"],
            "Section 3": ["📋", "🏅", "☑️", "⏰", "🛍", "🚽", "🎌", "🐼", "🕉", "🌄"]
        ]
    }
    
    private var secondPageExampleData: ExampleData {
        return [
            "Section 4": ["🎣", "🔟", "❤️", "💩", "♊️", "😤", "👔", "❇️", "🔂", "💥"],
            "Section 5": ["〰️", "🈚️", "🕊", "🌑", "🍃", "😘", "👂", "⛰", "🙇", "🏣"],
            "Section 6": ["🏬", "💢", "👷", "🐮", "💦", "🏂", "🚿", "🌻", "🏉", "📐"]
        ]
    }
    
    private var thirdPageExampleData: ExampleData {
        return [
            "Section 7": ["🐋", "🔅", "🎱", "👇", "🍂", "😙", "📥", "♿️", "🌥", "😭"],
            "Section 8": ["📆", "👜", "🎋", "⚠️", "✏️", "💸", "💲", "🎳", "😣", "🐾"],
            "Section 9 (last)": ["🆙", "🏐", "📺", "🌗", "🚹", "🛰", "⌛️", "📯", "🏴", "🐢"]
        ]
    }
    
}
