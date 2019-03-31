//
//  ViewController.swift
//  NapoleonTestTask
//
//  Created by Артем Жорницкий on 25/03/2019.
//  Copyright © 2019 Артем Жорницкий. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UISearchBarDelegate {
    var offers = [Offer]()
    var dicton = [String : [Offer]]()
    
    struct Sections {
        var sectionName: String!
        var sectionObjects : [Offer]!
    }
    
    var sectionArray = [Sections]()
    
    let colorForSegment = #colorLiteral(red: 0.7203173905, green: 0.8411524608, blue: 1, alpha: 1)
    
    func getData(){
        guard let offerJsonUrl = Bundle.main.url(forResource: "offers", withExtension: ".json") else { return }
        URLSession.shared.dataTask(with: offerJsonUrl) { (data, response, error) in
            do {
                if error == nil {
                    let downloadOffers = try JSONDecoder().decode([Offer].self, from: data!)
                    DispatchQueue.main.async {
                        self.offers = downloadOffers
                        var groupedDict = Dictionary(grouping: self.offers, by: {$0.groupName})
                        for (key, value) in groupedDict {
                            self.sectionArray.append(Sections(sectionName: key, sectionObjects: value))
                        }
                        for offer in self.offers{
                            print(offer.groupName)
                        }
                        self.tableView.reloadData()
                    }
                }
            }
            catch {
                print("error")
            }
        }.resume()
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            // tableView.delegate = self
            tableView.dataSource = self
            
            tableView.register(UINib(nibName: "ProductTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductTableViewCellIdentifier")
        }
    }
    
    @IBOutlet weak var sbSearchBar: UISearchBar!
    
    @IBOutlet weak var topTenButton: UIButton! {
        didSet {
            topTenButton.layer.cornerRadius = topTenButton.frame.size.height / 2
            topTenButton.layer.borderWidth = 1
            topTenButton.layer.borderColor = UIColor.white.cgColor
        }
    }
    @IBOutlet weak var itemsButton: UIButton! {
        didSet {
            itemsButton.layer.cornerRadius = itemsButton.frame.size.height / 2
            itemsButton.layer.borderWidth = 1
            itemsButton.layer.borderColor = UIColor.white.cgColor

        }
    }
    @IBOutlet weak var shopsButton: UIButton! {
        didSet {
            shopsButton.layer.cornerRadius = shopsButton.frame.size.height / 2
            shopsButton.layer.borderWidth = 1
            shopsButton.layer.borderColor = UIColor.white.cgColor

        }
    
    }
    
    override func viewDidLoad() {
        getData()
        setupSearchBarStyle()
        //making an observer to work wit h keyboard appearance
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        let point = CGPoint(x: 0, y: keyboardSize.height)
        var bottomStuff: CGFloat = 0
        if #available (iOS 11.0, *) {
            bottomStuff += view.safeAreaInsets.bottom
        }
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height - bottomStuff, right: 0)
        tableView.setContentOffset(point, animated: true)
        }
    
    
    @objc func keyboardWillHide(notification: Notification) {
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    
    @IBAction func firstSegmentTapped(_ sender: Any) {
        filterIsTapped(button: topTenButton)
        filterIsUnTapped(button: shopsButton)
        filterIsUnTapped(button: itemsButton)
        
    }
    
    @IBAction func secondSegmentTapped(_ sender: Any) {
        filterIsTapped(button: shopsButton)
        filterIsUnTapped(button: itemsButton)
        filterIsUnTapped(button: topTenButton)
    }
    
    @IBAction func thirdSegmentTapped(_ sender: Any) {
        filterIsTapped(button: itemsButton)
        filterIsUnTapped(button: shopsButton)
        filterIsUnTapped(button: topTenButton)
    }
    
    func filterIsTapped(button: UIButton) {
        button.layer.backgroundColor = colorForSegment.cgColor
        button.layer.borderColor = UIColor.blue.cgColor
    }
    
    func filterIsUnTapped(button: UIButton) {
        button.layer.backgroundColor = UIColor.white.cgColor
        button.layer.borderColor = UIColor.white.cgColor
    }
    
    func setupSearchBarStyle() {
        sbSearchBar.delegate = self
        sbSearchBar.barTintColor = UIColor.white
        if let textfield = sbSearchBar.value(forKey: "searchField") as? UITextField {
            textfield.backgroundColor = UIColor.lightGray
        }
        sbSearchBar.placeholder = "Поиск"
        sbSearchBar.backgroundImage = UIImage()
    }
    //keyboard dismissing by tapping search button
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder() // hides the keyboard.
    }
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionArray.count
        //return dicton.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return dicton[Array(dicton.keys)[section]]!.count
        return sectionArray[section].sectionObjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTableViewCellIdentifier", for: indexPath) as! ProductTableViewCell
    
        cell.ProductNameLabel.text =  sectionArray[indexPath.section].sectionObjects[indexPath.row].name!
        
        if let  discount = sectionArray[indexPath.section].sectionObjects[indexPath.row].discount {
            let price = sectionArray[indexPath.section].sectionObjects[indexPath.row].price!
            cell.priceLabel.text = "-\(Int(discount*100))%"
            cell.setup(with: String(sectionArray[indexPath.section].sectionObjects[indexPath.row].price!))
            cell.newPriceLabel.text = "\(Int(Float(price) - discount * Float(price)))₽"
        }
            
        else {
            cell.oldPrice.text = nil
            cell.newPriceLabel.text = nil
            cell.priceLabel.text = nil
            cell.priceLabel.backgroundColor = UIColor.white
        }
        
        if let itemDescription = sectionArray[indexPath.section].sectionObjects[indexPath.row].desc {
            cell.descriptionLabel.text = itemDescription
        }
        else {
            cell.descriptionLabel.text = nil
        }

        cell.bucketImage.image = UIImage(named: "newBucketList")
        
        if let image = sectionArray[indexPath.section].sectionObjects[indexPath.row].image {
            let imageUrl = URL(string: image)
            DispatchQueue.global().async {
                do{
                    let data = try Data(contentsOf: imageUrl!)
                    DispatchQueue.main.sync{
                        cell.productImage?.image = UIImage(data: data)
                    }
                }
                catch {
                    print("kek")
                }
            }
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "Avenir-Black", size: 17)!
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Удалить"
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionArray[section].sectionName
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
}

extension ViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 109.5
    }
}




