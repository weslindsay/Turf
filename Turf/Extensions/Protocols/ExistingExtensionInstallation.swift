public struct ExistingExtensionInstallation {
    public let version: UInt64
    public let turfVersion: UInt64
    public let data: NSData
}

extension ExistingExtensionInstallation: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "v\(version)[\(version)] - data: \(data)"
    }
}