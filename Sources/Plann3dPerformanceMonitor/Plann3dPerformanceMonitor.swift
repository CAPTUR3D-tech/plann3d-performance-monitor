// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import DebugSwift

public class PerformanceMonitor {
    @MainActor public static let shared = PerformanceMonitor()
    private let memoryQueue = DispatchQueue(label: "com.plann3d.memoryMonitoring")
    
    private init() {}
    
    public func start() {
        print("Performance monitoring started")
    }
    
    public func stop() {
        print("Performance monitoring stopped")
    }

    // Get available memory in bytes
    public func getAvailableMemory() -> Int {
        return os_proc_available_memory()
    }
    
    // Convert to human-readable format
    public func getFormattedAvailableMemory() -> String {
        let bytes = getAvailableMemory()
        let megabytes = Double(bytes) / (1024 * 1024)
        
        return String(format: "%.2f MB", megabytes)
    }
    
    public func trackEvent(_ name: String, block: () -> Void) {
        let startTime = CFAbsoluteTimeGetCurrent()
        block()
        let duration = (CFAbsoluteTimeGetCurrent() - startTime) * 1000
        print("Event '\(name)' took \(duration)ms")
    }
}
