//
//  Stack.swift
//  RPNCalculator
//
//  Created by Umidjon Fayzimatov on 18/03/25.
//

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

    var isEmpty: Bool {
        return elements.isEmpty
    }

    var count: Int {
        return elements.count
    }
}
