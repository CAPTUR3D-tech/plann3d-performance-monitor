# Plann3d Performance Monitor

A Swift performance monitor to be used to track cpu, memory, etc inside iOS projects

## Installation

### Swift Package Manager

1. In Xcode, select **File > Add Packages...**
2. Enter the repository URL:
   ```
   https://github.com/CAPTUR3D-tech/plann3d-performance-monitor.git
   ```
3. Select the version rule (e.g., "Up to Next Major" version)
4. Click **Add Package**

### Dependencies

This package requires [GDPerformanceView-Swift](https://github.com/dani-gavrilov/GDPerformanceView-Swift) which will be automatically installed with Swift Package Manager.

## Usage

```swift
import Plann3dPerformanceMonitor

// Start monitoring
PerformanceTracker.shared.startMonitoring()

// Take snapshots at key points in your app
let snapshot = PerformanceTracker.shared.takeSnapshot(metadata: ["scanTime": "10"])

// Log snapshot
print(snapshot.toString())
// Output: [14:32:05] FPS: 58, CPU: 23.7%, Mem: 128/4000MB (screen:HomeView)

// Export all collected snapshots to CSV
PerformanceTracker.shared.writeSnapshotsToFile(filePath: "/path/to/performance_log.csv")

// Stop monitoring when finished
PerformanceTracker.shared.stopMonitoring()
```
