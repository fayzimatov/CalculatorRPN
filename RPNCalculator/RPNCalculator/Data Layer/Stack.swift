//
//  Stack.swift
//  RPNCalculator
//
//  Created by Umidjon on 18/03/25.
//

import Foundation

struct Stack<T> {
    private var elements: [T] = []
    
    mutating func push(_ item: T) {
        elements.append(item)
    }
    
    mutating func pop() -> T? {
        return elements.popLast()
    }
    
    func peek() -> T? {
        return elements.last
    }
    
    
}
