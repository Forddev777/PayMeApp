//
//  ListViewController.swift
//  PayMeApp
//
//  Created by suriya taothongkom on 3/1/2566 BE.
//

import UIKit
//

class ListViewController: UITableViewCell {
    
    lazy var rightImage: UIImageView = {
            let imgView = UIImageView()
            imgView.contentMode = .scaleAspectFit
            imgView.translatesAutoresizingMaskIntoConstraints = false
            return imgView
        }()

        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            backgroundColor = .red
            addSubview(rightImage)
            NSLayoutConstraint.activate([
                rightImage.topAnchor.constraint(equalTo: topAnchor),
                rightImage.bottomAnchor.constraint(equalTo: bottomAnchor),
                rightImage.rightAnchor.constraint(equalTo: rightAnchor),
                rightImage.widthAnchor.constraint(equalTo: rightImage.heightAnchor)
            ])
        }
        
        func setupCell(image: String) {
            rightImage.image = UIImage(named: image)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
//class ListViewController: UIViewController  , UITableViewDelegate , UITableViewDataSource {
//
//
    private let mytableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
//    private let items: [String]
//
//    init(items: [String]) {
//
//        self.items = items
//
//        super.init(nibName: nil, bundle: nil)
//
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        view.addSubview(mytableView)
//
//        mytableView.delegate = self
//        mytableView.dataSource = self
//    }
////
//
//    override func viewDidLayoutSubviews() {
//         super.viewDidLayoutSubviews()
//        mytableView.frame = view.bounds
//
//    }
//
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = mytableView.dequeueReusableCell(withIdentifier: "Cell", for:  indexPath )
//        cell.textLabel?.text = items[indexPath.row]
//        return cell
//
//    }
//
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return items.count
//
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        mytableView.deselectRow(at: indexPath, animated: true)
//
//        print(items[indexPath.row])
//
//
//        var moreItems = [String]()
//        for x in 0...10 {
//            moreItems.append(" Items \(x)")
//        }
//
//        let anoterList = ListViewController(items: moreItems)
//        anoterList.title = "More Items"
//        navigationController?.pushViewController(anoterList, animated: true)
//    }


}
