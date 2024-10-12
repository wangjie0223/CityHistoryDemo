//
//  ViewController.swift
//  CityHistoryDemo
//
//  Created by 王杰 on 2024/10/12.
/*
 test
 */

import UIKit

class ViewController: UIViewController {
    
    var myWidth: CGFloat { view.frame.width - 40 }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        createUI()
    }
    
    func createUI() {
        let myStackView = UIStackView(frame: .init(x: 20, y: view.frame.midY, width: myWidth, height: 50))
        view.addSubview(myStackView)
        myStackView.axis = .horizontal
        myStackView.spacing = 20
        myStackView.distribution = .fillEqually
        
        let btn0 = configButton(btnTitle: "增加", tag: 1)
        let btn1 = configButton(btnTitle: "删除全部", tag: 2)
        let btn2 = configButton(btnTitle: "查询全部", tag: 3)
        let btn3 = configButton(btnTitle: "去重", tag: 4)
        
        myStackView.addArrangedSubviews([btn0, btn1, btn2, btn3])
        
        view.addSubview(cityLabel)
        
    }
    
    lazy var cityLabel: UILabel = {
        let lab = UILabel(frame: .init(x: 20, y: 100, width: myWidth, height: 100))
        lab.font = .systemFont(ofSize: 15)
        lab.textColor = .blue
        lab.numberOfLines = 0
        lab.backgroundColor = .lightGray
        return lab
    }()
    
    func configButton(btnTitle: String?, tag: Int) -> UIButton {
        let btn = UIButton()
        btn.tag = tag
        btn.backgroundColor = .red
        btn.setTitle(btnTitle, for: .normal)
        btn.addTarget(self, action: #selector(clickBtn(sender:)), for: .touchUpInside)
        return btn
    }
    
    @objc func clickBtn(sender: UIButton) {
        switch sender.tag {
        case 1: addCity()
        case 2: removeAllHistoryCity()
        case 3: querryAllHistoryCity()
        case 4: removeDuplicates()
        default: break
        }
    }
    
    
    func addCity() {
        let alert = UIAlertController.init(title: "添加", message: nil, preferredStyle: .alert)
        alert.addTextField(text: nil, placeholder: "添加", editingChangedTarget: self, editingChangedSelector: #selector(addTextField(tf:)))
        alert.addAction(title: "取消", style: .cancel).titleColor = .lightGray
        alert.addAction(title: "确定", style: .default, isEnabled: true) { ac in
            // alert.textFields?.first?.text
            print("点击确定:", alert.textFields?[0].text)
            let cityName = alert.textFields?[0].text ?? ""
            
            let isOk = CitySearchManager.shared.appendHistory(name: cityName)

            if isOk {
                self.showCityData()
            } else {
                
            }
            
            
        }
        alert.show()
    }
    
    func removeAllHistoryCity() {
        CitySearchManager.shared.removeAll()
        showCityData()
    }
    
    func querryAllHistoryCity() {
        showCityData()
    }
    
    func removeDuplicates() {
        CitySearchManager.shared.arrWithoutDuplicates()
        showCityData()
    }
    
    func showCityData() {
        let arr = CitySearchManager.shared.retrieveRecords()
        let res = arr.map { item in
            item.name ?? ""
        }.joined(separator: ",\n")
        cityLabel.text = res
        
        if res.isEmpty {
            title = "暂无数据!"
        } else {
            title = "测试页面"
        }
    }
    
    @objc func addTextField(tf: UITextField) {
        print("addTextField", tf.text)
    }


}

extension UIAlertAction {
    
    func setTitleColor(_ color: UIColor) {
        setValue(color, forKey: "titleTextColor")
    }
    
    /// 作者:王杰 设置 UIAlertAction 文字颜色
    var titleColor: UIColor  {
        get {
            value(forKey: "titleTextColor") as? UIColor ?? .red
        }
        set {
            setValue(newValue, forKey: "titleTextColor")
        }
    }
}
