//
//  DeviceManager.swift
//  TraceMe
//
//  Created by Akhilesh Singh on 07/07/19.
//  Copyright © 2019 Akhilesh Singh. All rights reserved.
//

import UIKit

class DeviceManager: NSObject {



    /// This func used to get cpu load info
    ///https://izziswift.com/get-cpu-usage-percentage-of-single-ios-app-in-swift-4-x/
    func getCPULoadInfo() -> String {
        var cpuUsageInfo = ""
        var cpuInfo: processor_info_array_t!
        var prevCpuInfo: processor_info_array_t?
        var numCpuInfo: mach_msg_type_number_t = 0
        var numPrevCpuInfo: mach_msg_type_number_t = 0
        var numCPUs: uint = 0
        let CPUUsageLock: NSLock = NSLock()
        var usage:Float32 = 0

        let mibKeys: [Int32] = [ CTL_HW, HW_NCPU ]
        mibKeys.withUnsafeBufferPointer() { mib in
            var sizeOfNumCPUs: size_t = MemoryLayout<uint>.size
            let status = sysctl(processor_info_array_t(mutating: mib.baseAddress), 2, &numCPUs, &sizeOfNumCPUs, nil, 0)
            if status != 0 {
                numCPUs = 1
            }
        }

        var numCPUsU: natural_t = 0
        let err: kern_return_t = host_processor_info(mach_host_self(), PROCESSOR_CPU_LOAD_INFO, &numCPUsU, &cpuInfo, &numCpuInfo);
        if err == KERN_SUCCESS {
            CPUUsageLock.lock()

            for i in 0 ..< Int32(numCPUs) {
                var inUse: Int32
                var total: Int32
                if let prevCpuInfo = prevCpuInfo {
                    inUse = cpuInfo[Int(CPU_STATE_MAX * i + CPU_STATE_USER)]
                        - prevCpuInfo[Int(CPU_STATE_MAX * i + CPU_STATE_USER)]
                        + cpuInfo[Int(CPU_STATE_MAX * i + CPU_STATE_SYSTEM)]
                        - prevCpuInfo[Int(CPU_STATE_MAX * i + CPU_STATE_SYSTEM)]
                        + cpuInfo[Int(CPU_STATE_MAX * i + CPU_STATE_NICE)]
                        - prevCpuInfo[Int(CPU_STATE_MAX * i + CPU_STATE_NICE)]
                    total = inUse + (cpuInfo[Int(CPU_STATE_MAX * i + CPU_STATE_IDLE)]
                        - prevCpuInfo[Int(CPU_STATE_MAX * i + CPU_STATE_IDLE)])
                } else {
                    inUse = cpuInfo[Int(CPU_STATE_MAX * i + CPU_STATE_USER)]
                        + cpuInfo[Int(CPU_STATE_MAX * i + CPU_STATE_SYSTEM)]
                        + cpuInfo[Int(CPU_STATE_MAX * i + CPU_STATE_NICE)]
                    total = inUse + cpuInfo[Int(CPU_STATE_MAX * i + CPU_STATE_IDLE)]
                }
                let coreInfo = Float(inUse) / Float(total)
                usage += coreInfo
                print(String(format: "Core: %u Usage: %f", i, Float(inUse) / Float(total)))
            }
            cpuUsageInfo = String(format:"%.2f",100 * Float(usage) / Float(numCPUs))
            CPUUsageLock.unlock()

            if let prevCpuInfo = prevCpuInfo {
                let prevCpuInfoSize: size_t = MemoryLayout<integer_t>.stride * Int(numPrevCpuInfo)
                vm_deallocate(mach_task_self_, vm_address_t(bitPattern: prevCpuInfo), vm_size_t(prevCpuInfoSize))
            }

            prevCpuInfo = cpuInfo
            numPrevCpuInfo = numCpuInfo

            cpuInfo = nil
            numCpuInfo = 0
        } else {
            print("Error!")
        }

        return cpuUsageInfo
    }

    /// This func is used to get memory status
    ///https://stackoverflow.com/a/47354072
    func getMemoryStatus() -> String {
        var pagesize: vm_size_t = 0

        let host_port: mach_port_t = mach_host_self()
        var host_size: mach_msg_type_number_t = mach_msg_type_number_t(MemoryLayout<vm_statistics_data_t>.stride / MemoryLayout<integer_t>.stride)
        host_page_size(host_port, &pagesize)

        var vm_stat: vm_statistics = vm_statistics_data_t()
        withUnsafeMutablePointer(to: &vm_stat) { (vmStatPointer) -> Void in
            vmStatPointer.withMemoryRebound(to: integer_t.self, capacity: Int(host_size)) {
                if (host_statistics(host_port, HOST_VM_INFO, $0, &host_size) != KERN_SUCCESS) {
                    Logger.log.info("Error: Failed to fetch vm statistics")
                }
            }
        }

        /* Stats in bytes */
        let mem_used: Int64 = Int64(vm_stat.active_count +
            vm_stat.inactive_count +
            vm_stat.wire_count) * Int64(pagesize)
        let mem_free: Int64 = Int64(vm_stat.free_count) * Int64(pagesize)

        let usagePer = (mem_used/mem_free) % 100

        let percentage = String(format: "%ld", usagePer)

        return percentage.appending("%")
    }

    /// This func is used to get battery level
    func getBatteryLevel() -> String {

        let level = Int(UIDevice.current.batteryLevel) * 100
        let percentage = String(format: "%d", level)
        return percentage.appending("%")
    }

    /// This func is used get device info
    func getDeviceInfo() -> String {
        let info = [UIDevice.current.model, UIDevice.current.systemName, UIDevice.current.systemVersion]
        let joinedString = info.joined(separator: ", ")
        return joinedString
    }

}
