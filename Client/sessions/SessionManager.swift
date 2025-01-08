import Foundation

class SessionManager {
    static let shared = SessionManager()
    private let defaults = UserDefaults.standard

    // Keys for UserDefaults
    private let loggedInUserKey = "loggedInUser"
    
    private init() {}

    // Save user session
    func saveUserSession(user: User) {
        // Encode the user object to Data
        if let encodedUser = try? JSONEncoder().encode(user) {
            defaults.set(encodedUser, forKey: loggedInUserKey)
            defaults.synchronize()
            print("User Session: ",defaults.data(forKey: loggedInUserKey))
        }
    }

    // Retrieve user session (returns User object)
    func retrieveUserSession() -> User? {
        if let savedUserData = defaults.data(forKey: loggedInUserKey),
           let decodedUser = try? JSONDecoder().decode(User.self, from: savedUserData) {
            print("User Session: ",defaults.data(forKey: loggedInUserKey))
            return decodedUser
        }
        return nil
    }

    // Clear user session
    func clearUserSession() {
        defaults.removeObject(forKey: loggedInUserKey)
        print("User Session: ",defaults.data(forKey: loggedInUserKey))
    }
}
