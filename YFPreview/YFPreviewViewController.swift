//
//  YFPreviewViewController.swift
//  YFPreview
//
//  Created by iCanong on 16/1/20.
//  Copyright © 2016年 yufan. All rights reserved.
//

import UIKit
import QuickLook

enum Type {
    case doc
    case pdf
    case ppt
    case pptx
    case docx
    case http
    case jpg
}

class YFPreviewViewController: UIViewController, QLPreviewControllerDataSource ,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.registerClass(PrviewTableViewCell.self, forCellReuseIdentifier: "cell")
        }
    }
    
    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            searchTextField.addTarget(self, action: "textFieldEditChanged:", forControlEvents: .EditingChanged)
        }
    }
    
    @IBOutlet weak var contentView: UIView!
    
    var fileList = [YFPreviewFile]()
    
    var searchList = [YFPreviewFile]()
    
    var currentFile = YFPreviewFile()
    
    let quickLookVC = QLPreviewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        currentFile = fileList[0]
        tableView.separatorStyle = .None
        
        quickLookVC.dataSource = self
        addChildViewController(quickLookVC)
        contentView.addSubview(quickLookVC.view)
        quickLookVC.view.hidden = true
        quickLookVC.view.frame = contentView.bounds
    }
    
    func loadData() {
        let file1 = YFPreviewFile()
        file1.name = "马原.doc"
        file1.type = .doc
        file1.url = NSBundle.mainBundle().URLForResource("马原", withExtension: "doc")
        fileList.append(file1)
        
        let file2 = YFPreviewFile()
        file2.name = "毛概.pdf"
        file2.type = .pdf
        file2.url = NSBundle.mainBundle().URLForResource("毛概", withExtension: "pdf")
        fileList.append(file2)
        
        let file3 = YFPreviewFile()
        file3.name = "嘻嘻嘻.pptx"
        file3.type = .ppt
        file3.url = NSBundle.mainBundle().URLForResource("嘻嘻嘻", withExtension: "pptx")
        fileList.append(file3)
        
        
        let file4 = YFPreviewFile()
        file4.name = "哈dddd.docx"
        file4.type = .docx
        file4.url = NSBundle.mainBundle().URLForResource("哈dddd", withExtension: "docx")
        fileList.append(file4)
        
        
        let file5 = YFPreviewFile()
        file5.name = "http://www.baidu.com"
        file5.type = .http
        file5.url =  NSURL(string: "http://www.baidu.com")
        fileList.append(file5)
        
        
        let file6 = YFPreviewFile()
        file6.name = "LOL.jpg"
        file6.type = .jpg
        file6.url = NSBundle.mainBundle().URLForResource("0", withExtension: "jpg")
        fileList.append(file6)
        
        let file7 = YFPreviewFile()
        file7.name = "LOL.jpg"
        file7.type = .jpg
        file7.url = NSBundle.mainBundle().URLForResource("56", withExtension: "jpg")
        fileList.append(file7)
        
    }
    
    func textFieldEditChanged(textfield: UITextField) {
        let selectedRange = textfield.markedTextRange
        if selectedRange == nil {
            searchData()
        }
    }
    
    func searchData() {
        let searchText = (searchTextField.text ?? "").stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        if !searchText.isEmpty {
            searchList =  fileList.filter(){ (file) -> Bool in
                if file.name!.rangeOfString(searchText) != nil {
                    return true
                }
                return false
            }
        }
        tableView.reloadData()
    }
    
    func chooseImageForType(type: Type)-> UIImage {
        let imageV = UIImageView()
        switch type {
        case .pdf:
            imageV.image = UIImage(named: "product-NewFeature-pdf")!
            break
        case .ppt:
            imageV.image = UIImage(named: "product-NewFeature-ppt")!
            break
        case .pptx:
            imageV.image = UIImage(named: "product-NewFeature-ppt")!
            break
        case .doc:
            imageV.image = UIImage(named: "product-NewFeature-doc")!
            break
        case .docx:
            imageV.image = UIImage(named: "product-NewFeature-doc")!
            break
        case .http:
            imageV.image = UIImage(named: "product-NewFeature-http")!
            break
        default:
            UIAlertView(title: "请上传正确的文件格式", message: nil, delegate: nil, cancelButtonTitle: "确定").show()
            break
        }
        return imageV.image!
    }

    
    // MARK: - UITableViewDataSource, UITableViewDelegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let text = (searchTextField.text ?? "") as NSString
        if text.length > 0 {
            return searchList.count
        }
        return fileList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell  {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! PrviewTableViewCell
        let text = (searchTextField.text ?? "") as NSString
        if text.length > 0 {
            let file = searchList[indexPath.row]
            cell.name = file.name
            if file.type == .jpg {
                cell.img = UIImage(data: NSData(contentsOfURL: file.url!)!)
            } else {
                cell.img = chooseImageForType(file.type!)
            }
            return cell
        }
    
        let file = fileList[indexPath.row]
        cell.name = file.name
        if file.type == .jpg {
            cell.img = UIImage(data: NSData(contentsOfURL: file.url!)!)
        } else {
            cell.img = chooseImageForType(file.type!)
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)  {
        let text = (searchTextField.text ?? "") as NSString
        if text.length > 0 {
            currentFile = searchList[indexPath.row]
            if currentFile.type == .http {
                quickLookVC.view.hidden = true
                UIApplication.sharedApplication().openURL(currentFile.url!)
            } else {
                quickLookVC.view.hidden = false
                quickLookVC.reloadData()
            }
        }
        
        currentFile = fileList[indexPath.row]
        if currentFile.type == .http {
            quickLookVC.view.hidden = true
            UIApplication.sharedApplication().openURL(currentFile.url!)
        } else {
            quickLookVC.view.hidden = false
            quickLookVC.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 65
    }
    
    // MARK: - QLPreviewControllerDataSource
    
    func numberOfPreviewItemsInPreviewController(controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(controller: QLPreviewController, previewItemAtIndex index: Int) -> QLPreviewItem {
        let url = currentFile.url
        return url!
    }


}
