//
//  UserDefaults.swift
//  EmotionLine
//
//  Created by 강민석 on 2022/01/08.
//

import Foundation

protocol UserDefaultsServiceProtocol {
    func getToken() -> String?
    func setToken(token: String)
    func deleteToken()
    func setUser(user: User)
    func getUser() -> User?
    func deleteUser()
}

final class UserDefaultsService: UserDefaultsServiceProtocol {
    private let tokenKey: String = "Token"
    private let userKey: String = "User"
    
    func getToken() -> String? {
        return UserDefaults.standard.value(forKey: tokenKey) as? String
    }
    
    func setToken(token: String) {
        UserDefaults.standard.setValue(token, forKey: tokenKey)
    }
    
    func deleteToken() {
        UserDefaults.standard.setValue(nil, forKey: tokenKey)
    }
    
    func setUser(user: User) {
        do {
            let jsonData = try JSONEncoder().encode(user)
            UserDefaults.standard.set(jsonData, forKey: userKey)
        } catch {
            print(error.localizedDescription)
            return
        }
    }
    
    func getUser() -> User? {
        let jsonData = UserDefaults.standard.value(forKey: userKey) as? Data
        return try? JSONDecoder().decode(User.self, from: jsonData ?? Data())
    }
    
    func deleteUser() {
        UserDefaults.standard.set(nil, forKey: userKey)
    }
}
