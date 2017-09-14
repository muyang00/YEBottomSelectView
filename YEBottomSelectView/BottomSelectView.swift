//
//  BottomSelectView.swift
//  YEBottomSelectView
//
//  Created by yongen on 2017/9/13.
//  Copyright © 2017年 yongen. All rights reserved.
//

import UIKit

//标题，取消按钮， 高度
private let DefaultHeight : CGFloat = 50
//取消按钮的间隔
private let CancelButtonPadding : CGFloat = 8
//cell 高度
private let CellH : CGFloat = 50
// cell 推荐个数
private let CellCount : CGFloat = 4
//默认字体
private let DefaultFont = UIFont.systemFont(ofSize: 16)

public struct SelectViewInfo {
    public var title: String
    public var color: UIColor?
    public init(title: String, color: UIColor?) {
        self.title = title
        self.color = color
    }
}


open class BottomSelectView: UIView {

    var coverView: UIView!
    var contentView: UIView!
    var titleLabel: UILabel!
    var optionTabelView: UITableView!
    
    var title: String?
    var cancelTitle: SelectViewInfo?
    var contentViewH: CGFloat!
    var tableViewH: CGFloat!
    var options: [SelectViewInfo]!
    
    var selectCallBack: ((_ index: Int) -> Swift.Void)?
    var cancelCallBack: (() -> Swift.Void)?
    
    init(title: String?, options: [SelectViewInfo], cancelTitle:SelectViewInfo?, selectCallBack: ((_ index: Int) ->Swift.Void)?, cancelCallBack:(() -> Swift.Void)?) {
        super.init(frame: UIScreen.main.bounds)
        self.title = title
        self.options = options
        self.cancelTitle = cancelTitle
        self.selectCallBack = selectCallBack
        self.cancelCallBack = cancelCallBack
        
        let count = CGFloat(options.count)
        tableViewH = (count <= CellCount ? count : 4) * CellH
        contentViewH = CancelButtonPadding + CGFloat(tableViewH) + (title == nil ? DefaultHeight : DefaultHeight * 2)
        setupView()
        
    }
    
    class open func show(title: String?, options: [SelectViewInfo], cancelTitle: SelectViewInfo?, selectCallBack: ((_ index: Int) -> Swift.Void)?){
        BottomSelectView(title: title, options: options, cancelTitle: cancelTitle, selectCallBack: selectCallBack, cancelCallBack: nil).showSelectView()
    }
    
    class open func show(title: String?, options: [SelectViewInfo], cancelTitle: SelectViewInfo?, selectCallBack: ((_ index: Int) -> Swift.Void)?, cancelCallBack:(()-> Swift.Void)?){
        BottomSelectView(title: title, options: options, cancelTitle: cancelTitle, selectCallBack: selectCallBack, cancelCallBack: cancelCallBack).showSelectView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
       // fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - 初始化
private extension BottomSelectView {
    func setupView() {
       //设置背景
        coverView = UIView(frame: self.bounds)
        coverView.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        coverView.alpha = 0
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapBgViewOrCancel))
        coverView.addGestureRecognizer(tap)
        addSubview(coverView)
        
        //内容
        contentView = UIView(frame: CGRect(x: 0, y: frame.height, width: frame.width, height: contentViewH))
        contentView.backgroundColor = UIColor.groupTableViewBackground
        addSubview(contentView)
        
        if let title = title {
            let titleBgView = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: DefaultHeight))
            titleBgView.backgroundColor = UIColor.groupTableViewBackground
            titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: DefaultHeight - 0.5))
            titleLabel.text = title
            titleLabel.font = UIFont.systemFont(ofSize: 13)
            titleLabel.textColor = UIColor.lightGray
            titleLabel.textAlignment = .center
            titleBgView.addSubview(titleLabel)
            contentView.addSubview(titleBgView)
        }
        
        //设置选项列表
        let tableViewY = titleLabel == nil ? 0 : DefaultHeight
        let optionTableViewF = CGRect(x: 0, y: tableViewY, width: frame.width, height: CGFloat(tableViewH))
        optionTabelView = UITableView(frame: optionTableViewF, style: .grouped)
        let nib = UINib(nibName: "BottomSelectCell", bundle: Bundle(for: BottomSelectView.self))
        optionTabelView.register(nib, forCellReuseIdentifier: "BottomSelectCell")
        optionTabelView.showsVerticalScrollIndicator = false
        optionTabelView.showsHorizontalScrollIndicator = false
        optionTabelView.delegate = self
        optionTabelView.dataSource = self
        optionTabelView.separatorStyle = .none
        optionTabelView.bounces = false
        optionTabelView.isScrollEnabled = CGFloat(options.count) > CellCount
        contentView.addSubview(optionTabelView)
        
        //cancel
        let cancelButton = UIButton(frame: CGRect(x: 0, y: contentView.bounds.height - DefaultHeight, width: frame.width, height: DefaultHeight))
        cancelButton.setTitle(cancelTitle == nil ? "取消" : cancelTitle?.title, for: .normal)
        cancelButton.setTitleColor(cancelTitle == nil ? UIColor.darkGray : cancelTitle?.color, for: .normal)
        cancelButton.titleLabel?.font = DefaultFont
        cancelButton.backgroundColor = UIColor.white
        cancelButton.addTarget(self, action: #selector(tapBgViewOrCancel), for: .touchUpInside)
        contentView.addSubview(cancelButton)
    }
    func showSelectView() {
      UIApplication.shared.keyWindow?.addSubview(self)
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.7, options: .curveEaseInOut, animations: {
            self.coverView.alpha = 1.0
            self.contentView.transform = CGAffineTransform(translationX: 0, y: -self.contentView.bounds.height)
        }, completion: nil)
    }
    
    @objc func tapBgViewOrCancel() {
        if cancelCallBack != nil {
            cancelCallBack!()
        }
        close()
    }
    @objc func close() {
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.7, options: .curveEaseInOut, animations: {
            self.coverView.alpha = 0.0
            self.contentView.transform = CGAffineTransform.identity
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }

    
}


extension BottomSelectView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CellH
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if selectCallBack != nil{
            selectCallBack!(indexPath.row)
        }
        close()
    }
    
}

extension BottomSelectView : UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return options.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BottomSelectCell", for: indexPath) as! BottomSelectCell
        cell.titleLabel.text = options[indexPath.row].title
        if let color = options[indexPath.row].color {
            cell.titleLabel.textColor = color
        }
        return cell
    }
}

