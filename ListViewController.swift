//
//  ListViewController.swift
//  PayMeApp
//
//  Created by suriya taothongkom on 3/1/2566 BE.
//

import UIKit

class ListViewController: UIViewController  , UITableViewDelegate , UITableViewDataSource {
   

    private let mytableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return table
    }()
    private let items: [String]
    
    init(items: [String]) {
    
        self.items = items
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
  
        view.addSubview(mytableView)
        
        mytableView.delegate = self
        mytableView.dataSource = self
    }
//
    
    override func viewDidLayoutSubviews() {
         super.viewDidLayoutSubviews()
        mytableView.frame = view.bounds
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mytableView.dequeueReusableCell(withIdentifier: "Cell", for:  indexPath )
        cell.textLabel?.text = items[indexPath.row]
        return cell
        
    }
    
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mytableView.deselectRow(at: indexPath, animated: true)
        
        print(items[indexPath.row])
        
        
        var moreItems = [String]()
        for x in 0...10 {
            moreItems.append(" Items \(x)")
        }
        
        let anoterList = ListViewController(items: moreItems)
        anoterList.title = "More Items"
        navigationController?.pushViewController(anoterList, animated: true)
        
    }


}
