//
//  ExchangeViewController.swift
//  Exchange
//
//  Created by Anton Kovalkov on 06.04.2021.


import UIKit

class ExchangeViewController: UIViewController {
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private var currencyData: Currency? {
        didSet {
            DispatchQueue.main.async {
                self.scrollToFirstRow()
                self.tableView.reloadData()
            }
        }
    }
    
    private let headerID = "CustomHeaderView"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableViewConfig()

        ServerRequest.getData { [weak self] (data, error ) in
            guard error == nil else {self?.showError(error: error!); return }
            self?.currencyData = data
        }
    }
    
    
    private func tableViewConfig() {
        let nib = UINib(nibName: headerID, bundle: nil)
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: headerID)
        tableView.sectionHeaderHeight = 80
    }
    
    private func showError(error: NetworkError) {
        DispatchQueue.main.async {
            self.tableView.isHidden = true
            self.errorLabel.text = error.rawValue
        }
        
    }
    
}


extension ExchangeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let date = currencyData?.date, let base = currencyData?.base else { return nil }
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerID) as? CustomHeaderView else { return nil }
        
        header.currencyLabel.text = base
        header.dateLabel.text = date
        
        return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencyData?.currencyArray.count ?? 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "exchangeCell") as? ExchangeTableViewCell else { return ExchangeTableViewCell()}
        guard let currencyData = currencyData else { return ExchangeTableViewCell() }
        
        cell.currencyLabel.text = currencyData.currencyArray[indexPath.row].first?.key
        cell.valueLabel.text = currencyData.currencyArray[indexPath.row].first?.value
        
        return cell
    }
    
    
}

extension ExchangeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let base = currencyData?.currencyArray[indexPath.row].first?.key else { return }
        tableView.deselectRow(at: indexPath, animated: true)
        
        ServerRequest.getData(base: base) { [weak self] (data, error) in
            guard error == nil else {self?.showError(error: error!); return }
            self?.currencyData = data
        }
    }
    
    private func scrollToFirstRow() {
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
}
