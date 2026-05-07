import Foundation

struct RingBuffer<Element> {
    private(set) var elements: [Element] = []
    private let capacity: Int

    init(capacity: Int) {
        self.capacity = max(1, capacity)
    }

    mutating func append(_ item: Element) {
        elements.append(item)
        if elements.count > capacity {
            elements.removeFirst(elements.count - capacity)
        }
    }
}
