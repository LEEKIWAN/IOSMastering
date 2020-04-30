//
//  StickyHeaderViewController.swift
//  TableView
//
//  Created by 이기완 on 2020/03/29.
//  Copyright © 2020 Keun young Kim. All rights reserved.
//

import UIKit

class StickyHeaderViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var image: UIImage?
    var category: String?
    let comments = Comment.allComments()
    
    // MARK - Private
    
    private let tableHeaderViewHeight: CGFloat = 500.0  // CODE CHALLENGE: make this height dynamic with the height of the VC - 3/4 of the height
    private let tableHeaderViewCutaway: CGFloat = 40.0
    
    var headerView: DetailHeaderView2!
    var headerMaskLayer: CAShapeLayer!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = category
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        headerView = DetailHeaderView2(frame: .zero)
        
        tableView.tableHeaderView = nil
        tableView.addSubview(headerView)
        
        
//
        headerView.backgroundColor = .blue
        headerView.image = UIImage(named: "Unknown-14")
        
        tableView.contentInset = UIEdgeInsets(top: tableHeaderViewHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -tableHeaderViewHeight + 64)
        
        // cut away the header view
        headerMaskLayer = CAShapeLayer()
        headerMaskLayer.fillColor = UIColor.black.cgColor
        headerView.layer.mask = headerMaskLayer
        
        let effectiveHeight = tableHeaderViewHeight - tableHeaderViewCutaway/2
        tableView.contentInset = UIEdgeInsets(top: effectiveHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -effectiveHeight)
        
        updateHeaderView()
    }
    
    func updateHeaderView()
    {
        let effectiveHeight = tableHeaderViewHeight - tableHeaderViewCutaway/2
        var headerRect = CGRect(x: 0, y: -effectiveHeight, width: tableView.bounds.width, height: tableHeaderViewHeight)
        
        if tableView.contentOffset.y < -effectiveHeight {
            headerRect.origin.y = tableView.contentOffset.y
            headerRect.size.height = -tableView.contentOffset.y + tableHeaderViewCutaway/2
        }
        
        print(tableView.contentOffset)
        
        headerView.frame = headerRect
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: headerRect.width, y: 0))
        path.addLine(to: CGPoint(x: headerRect.width, y: headerRect.height))
        path.addLine(to: CGPoint(x: 0, y: headerRect.height - tableHeaderViewCutaway))
        
        headerMaskLayer?.path = path.cgPath
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentTableViewCell
        
        cell.comment = comments[indexPath.row]
        
        return cell
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateHeaderView()
    }
}














