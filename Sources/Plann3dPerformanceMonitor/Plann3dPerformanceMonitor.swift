//
//  PerformanceTracker.swift
//  RoomPlan 2D
//
//  Created by Ian (Captur3d) on 7/5/2025.
//  Copyright © 2025 PHORIA. All rights reserved.
//

import Foundation
import GDPerformanceView_Swift

public class PerformanceTracker: PerformanceMonitorDelegate {
    
    private var performanceMonitor: PerformanceMonitor?
    private var isMonitoring = false
    private var lastPerformanceReport: PerformanceReport? = nil
    
    // Store snapshots in memory
    private var snapshots: [PerformanceSnapshot] = []
    
    // Singleton for easy access
    nonisolated(unsafe) public static let shared = PerformanceTracker()
    
    private init() {
        performanceMonitor = PerformanceMonitor()
        performanceMonitor?.delegate = self
        
        // Hide the visual display since we're just collecting the data
        performanceMonitor?.hide()
    }

    public func startMonitoring() {
        guard !isMonitoring else { return }
        
        performanceMonitor?.start()
        isMonitoring = true
        print("Performance monitoring started.")
    }
    
    public func stopMonitoring() {
        guard isMonitoring else { return }
        
        performanceMonitor?.pause()
        isMonitoring = false
        print("Performance monitoring stopped")
    }
    
    public func takeSnapshot(metadata: [String:String]) -> PerformanceSnapshot? {
        guard let report = lastPerformanceReport else {
            print("Unable to capture performance report.")
            return nil
        }
        
        let memoryUsed = report.memoryUsage.used / 1024 / 1024  // Convert to MB
        let memoryTotal = report.memoryUsage.total / 1024 / 1024  // Convert to MB
 
        let snapshot = PerformanceSnapshot(
            fps: Int(report.fps),
            cpuUsage: Double(report.cpuUsage),
            memoryUsed: memoryUsed,
            memoryTotal: memoryTotal,
            metadata: metadata
        )
        
        // Store the snapshot
        snapshots.append(snapshot)
        
        return snapshot
    }
    
    /// Write all collected snapshots to a CSV file
    /// - Parameter filePath: Path where the CSV file should be saved
    /// - Returns: Boolean indicating success or failure
    public func writeSnapshotsToFile(filePath: String) -> Bool {
        guard !snapshots.isEmpty else {
            print("No snapshots to write to file")
            return false
        }
        
        do {
            // Create CSV content starting with the header
            let header = snapshots[0].csvHeader()
            var csvContent = header + "\n"
            
            // Add all snapshots as rows
            for snapshot in snapshots {
                csvContent += snapshot.toCSV() + "\n"
            }
            
            // Write to file
            try csvContent.write(to: URL(fileURLWithPath: filePath), atomically: true, encoding: .utf8)
            print("Performance data written to: \(filePath)")
            return true
        } catch {
            print("Error writing performance data to file: \(error.localizedDescription)")
            return false
        }
    }
    
    /// Clear all stored snapshots
    public func clearSnapshots() {
        snapshots.removeAll()
    }
    
    // MARK: - PerformanceMonitorDelegate
    
    public func performanceMonitor(didReport performanceReport: PerformanceReport) {
        lastPerformanceReport = performanceReport
    }
}

/// A simple struct that captures performance metrics
public struct PerformanceSnapshot {
    /// The timestamp when the snapshot was created
    public let timestamp: Date
    
    /// Frames per second
    public let fps: Int
    
    /// CPU usage percentage (0-100)
    public let cpuUsage: Double
    
    /// Memory used in bytes
    public let memoryUsed: UInt64
    
    /// Total available memory in bytes
    public let memoryTotal: UInt64
    
    /// Metadata string
    public let metadata: [String: String]
    
    /// Creates a new performance snapshot
    public init(
        fps: Int,
        cpuUsage: Double,
        memoryUsed: UInt64,
        memoryTotal: UInt64,
        metadata: [String: String] = [:],
        timestamp: Date = Date()
    ) {
        self.timestamp = timestamp
        self.fps = fps
        self.cpuUsage = cpuUsage
        self.memoryUsed = memoryUsed
        self.memoryTotal = memoryTotal
        self.metadata = metadata
    }

    public func toString() -> String {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss"
        
        var result = "[\(timeFormatter.string(from: timestamp))] FPS: \(Int(fps)), CPU: \(String(format: "%.1f", cpuUsage))%, Mem: \(memoryUsed)/\(memoryTotal)MB"
        
        if !metadata.isEmpty {
            let metadataStr = metadata.map {
                // Replace any newlines with spaces
                let value = $0.value.replacingOccurrences(of: "\n", with: " ")
                return "\($0.key):\(value)"
            }.joined(separator: ", ")
            
            result += " (\(metadataStr))"
        }
        
        return result
    }
    
    /// Convert snapshot to CSV format with metadata unwrapped as individual columns
    public func toCSV() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let timeString = formatter.string(from: timestamp)
        
        // Start with the basic metrics
        var csvParts = [
            timeString,
            String(fps),
            String(cpuUsage),
            String(memoryUsed),
            String(memoryTotal)
        ]
        
        // Add metadata key-value pairs
        for (key, value) in metadata {
            // Escape quotes in the value for CSV compatibility
            let escapedValue = value.replacingOccurrences(of: "\"", with: "\"\"")
            csvParts.append("\(key):\"\(escapedValue)\"")
        }
        
        return csvParts.joined(separator: ",")
    }
    
    /// Generate a dynamic CSV header based on the metadata keys
    public func csvHeader() -> String {
        var headerParts = [
            "Timestamp",
            "FPS",
            "CPU Usage (%)",
            "Memory Used (bytes)",
            "Memory Total (bytes)"
        ]
        
        // Add metadata keys as column headers
        for key in metadata.keys {
            headerParts.append(key)
        }
        
        return headerParts.joined(separator: ",")
    }
}
