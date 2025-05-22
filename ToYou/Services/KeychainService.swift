//
//  KeychainService.swift
//  ToYou
//
//  Created by 이승준 on 3/4/25.
//

import Foundation

final class KeychainService {
    
    let shared = KeychainService()
    
    static func add(key: String, value: String) -> Bool {
        let addQuery: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                         kSecAttrAccount: key,
                                         kSecValueData: (value as AnyObject).data(using: String.Encoding.utf8.rawValue) as Any]
        
        let result: Bool = {
            let status = SecItemAdd(addQuery as CFDictionary, nil)
            if status == errSecSuccess {
                return true
            } else if status == errSecDuplicateItem {
                return update(key: key, value: value)
            }
            
            print("KeychainService AddItem Error : \(status.description))")
            return false
        }()
        
        return result
    }
    
    static func get(key: String) -> String? {
        let getQuery: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                      kSecAttrAccount: key,
                                      kSecReturnAttributes: true,
                                      kSecReturnData: true]
        var item: CFTypeRef?
        let result = SecItemCopyMatching(getQuery as CFDictionary, &item)
        
        if result == errSecSuccess {
            if let existingItem = item as? [String: Any],
               let data = existingItem[kSecValueData as String] as? Data,
               let password = String(data: data, encoding: .utf8) {
                return password
            }
        }
        
        print("KeychainService GetItem Error : \(result.description)")
        return nil
    }
    
    static func update(key: String, value: String) -> Bool {
        let prevQuery: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                        kSecAttrAccount: key]
        let updateQuery: [CFString: Any] = [kSecValueData: (value as AnyObject).data(using: String.Encoding.utf8.rawValue) as Any]
        
        let result: Bool = {
            let status = SecItemUpdate(prevQuery as CFDictionary, updateQuery as CFDictionary)
            if status == errSecSuccess { return true }
            
            print("KeychainService UpdateItem Error : \(status.description)")
            return false
        }()
        
        return result
    }
    
    static func delete(key: String) -> Bool {
        let deleteQuery: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                            kSecAttrAccount: key]
        let status = SecItemDelete(deleteQuery as CFDictionary)
        if status == errSecSuccess { return true }
        
        print("KeychainService DeleteItem Error : \(status.description)")
        return false
    }
    
    static func deleteAll() -> Bool {
        return KeychainService.delete(key: K.Key.accessToken) &&
                KeychainService.delete(key: K.Key.refreshToken) &&
                KeychainService.delete(key: K.Key.fcmToken)
        
    }
    
}
