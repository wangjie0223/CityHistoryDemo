//
//  CitySearchManager.swift
//  JiangSuWeather
//
//  Created by 王杰 on 2024/10/12.
//

import UIKit
import SwifterSwift

struct SearchHistoryUserDefaultsModel: Codable {
    var name: String?
}

let searchHistoryUserDefaultsKey = "searchHistoryUserDefaultsKey"

class CitySearchManager {
    static let shared = CitySearchManager()

    private init() {}
    
    /// 增
    @discardableResult
    func appendHistory(name: String) -> Bool {
        if name.isEmpty { return false }
        
        let model = SearchHistoryUserDefaultsModel(name: name)
        var history = retrieveRecords()
        // history.insert(model, at: 0)
        history.prepend(model)
        UserDefaults.standard.set(object: history, forKey: searchHistoryUserDefaultsKey)
        return true
    }
    
    /// 删
    func removeAll() {
        let emptyArr: [SearchHistoryUserDefaultsModel] = []
        UserDefaults.standard.set(object: emptyArr, forKey: searchHistoryUserDefaultsKey)
    }
    
    /// 查
    func retrieveRecords() -> [SearchHistoryUserDefaultsModel] {
        let arr = UserDefaults.standard.object([SearchHistoryUserDefaultsModel].self, with: searchHistoryUserDefaultsKey) ?? []
        print("CitySearchManager_查询历史记录", arr)
        return arr
    }
    
    /// 查询前几个数据
    private func retrieveRecords(maxCount: Int) -> [SearchHistoryUserDefaultsModel] {
        let arr = retrieveRecords()
        return Array(arr.prefix(maxCount))
    }
    
    @discardableResult
    func arrWithoutDuplicates() -> [SearchHistoryUserDefaultsModel] {
        let arr = retrieveRecords()
        let res = arr.withoutDuplicates(transform: { $0.name ?? "" })
        UserDefaults.standard.set(object: res, forKey: searchHistoryUserDefaultsKey)
        return retrieveRecords(maxCount: 7)
    }
     
}
