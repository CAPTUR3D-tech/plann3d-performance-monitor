// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import DebugSwift

public class PerformanceMonitor {
    @MainActor public static let shared = PerformanceMonitor()
    
    private init() {}
    
    public func start() {
        print("Performance monitoring started")
    }
    
    public func stop() {
        print("Performance monitoring stopped")
    }
    
    public func trackEvent(_ name: String, block: () -> Void) {
        let startTime = CFAbsoluteTimeGetCurrent()
        block()
        let duration = (CFAbsoluteTimeGetCurrent() - startTime) * 1000
        print("Event '\(name)' took \(duration)ms")
    }
}
