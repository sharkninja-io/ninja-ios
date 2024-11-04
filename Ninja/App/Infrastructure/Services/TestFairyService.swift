import Foundation
import TestFairy

final class TestFairyService {

    public static let shared = TestFairyService()

    /// Get TestFairy API key from plist
    private func getApiKey() -> String? {
        var testFairyApiKey : String?
        if let plistKey = Bundle.main.object(forInfoDictionaryKey: "testfairy") as? Dictionary<String,AnyObject> {
            testFairyApiKey = plistKey["apiKey"] as? String
        }
        return testFairyApiKey
    }

    /// Start a TestFairy monitoring session
    public func startSession() {
        #if DEBUG
            if let token = getApiKey() {
                Logger.Debug("Starting TestFairy Session")
                TestFairy.begin(token)
            } else {
                Logger.Error("Failed to find TestFairy API Key")
            }
        #endif
    }

    /// Stop a TestFairy monitoring session
    public func stopSession() {
        Logger.Debug("Stopping TestFairy Session")
        TestFairy.stop()
    }

    /// Get the session url for the current TestFairy session
    /// If session has not started, will return nil
    public func getSessionURL() -> String? {
        return TestFairy.sessionUrl()
    }
    
    public func log(_ message: String) {
        TestFairy.log(message)
    }
}
