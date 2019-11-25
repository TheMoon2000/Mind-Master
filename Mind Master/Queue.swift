//
//  Queue.swift
//  Data Structures
//
//  Created by Jia Rui Shan on 2019/11/17.
//  Copyright © 2019 Calpha Dev. All rights reserved.
//

import Foundation

public class Queue<T>: CustomStringConvertible, Sequence {

    class Node: NSObject {
        var item: T
        var prev: Node?
        var next: Node?

        init(_ value: T) {
            self.item = value
        }
        
        override var description: String {
            return "Node<\(item)>"
        }
    }

    private(set) var head: Node?
    private(set) var tail: Node?
    public private(set) var count: Int
    
    public init() {
        count = 0
    }

    public func enqueue(_ value: T) {
        let new = Node(value)
        if let tail = tail {
            tail.next = new
            new.prev = tail
            new.next = head
            self.tail = new
            head?.prev = new
        } else {
            new.prev = new
            new.next = new
            tail = new
            head = tail
        }
        count += 1
    }
    
    @discardableResult
    public func dequeue() -> T? {
        if let removed = head?.item {
            if count == 1 {
                head = nil
                tail = nil
            } else {
                head = head?.next
                head?.prev = tail
                tail?.next = head
            }
            
            count -= 1
            return removed
        }
        
        return nil
    }
    
    public var description: String {
        var list = [T]()
        var current = head
        while current != nil {
            list.append(current!.item)
            current = current?.next
            if current == head { break }
        }
        
        return list.description + "(\(count))"
    }
    
    public __consuming func makeIterator() -> Queue<T>.QueueIterator {
        return QueueIterator(queue: self)
    }
    
    
    
    public class QueueIterator: IteratorProtocol {
        
        var queue: Queue<T>
        var current: Node?
        var remaining = 0
            
        init(queue: Queue<T>) {
            self.queue = queue
            current = queue.head
            remaining = queue.count
        }
        
        public func next() -> T? {
            if current == nil { return nil }
            if remaining == 0 { return nil }
            remaining -= 1
            
            defer {
                current = current?.next
            }
            
            return current!.item
        }
        
    }
}
