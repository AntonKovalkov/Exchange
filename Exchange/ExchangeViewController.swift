//
//  ExchangeViewController.swift
//  Exchange
//
//  Created by Anton Kovalkov on 06.04.2021.


import UIKit

class ExchangeViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var currencyData: CurrencyData? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableView.isHidden = false
                self.loadIndicator(isLoading: false)
            }
        }
    }
    
    
    private let headerID = "CustomHeaderView"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadIndicator(isLoading: true)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableViewConfig()

        ServerRequest.getData { [weak self] (data, error ) in
            guard error == nil else {self?.showError(error: error!); return }
            self?.currencyData = data
        }
    }
    
    private func loadIndicator(isLoading: Bool) {
        switch isLoading {
        case true:
            activityIndicator.startAnimating()
            activityIndicator.isHidden = false
        case false:
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            scrollToFirstRow()
        }
    }
    
    
    private func tableViewConfig() {
        let nib = UINib(nibName: headerID, bundle: nil)
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: headerID)
        tableView.sectionHeaderHeight = 80
        tableView.isHidden = true
    }
    
    private func showError(error: NetworkError) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Error", message: error.rawValue, preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alertController.addAction(action)
            self.tableView.isHidden = true
            self.loadIndicator(isLoading: false)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
}


extension ExchangeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let date = currencyData?.date, let base = currencyData?.baseCurrency else { return nil }
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerID) as? CustomHeaderView else { return nil }
        
        header.currencyLabel.text = base
        header.dateLabel.text = date
        
        return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencyData?.currencyArray.count ?? 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "exchangeCell") as? ExchangeTableViewCell else { return UITableViewCell() }
        guard let currencyData = currencyData else { return cell }
        
        cell.currencyLabel.text = currencyData.currencyArray[indexPath.row].first?.key
        cell.valueLabel.text = currencyData.currencyArray[indexPath.row].first?.value
        
        return cell
    }
    
    
}

extension ExchangeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let base = currencyData?.currencyArray[indexPath.row].first?.key else { return }
        tableView.deselectRow(at: indexPath, animated: true)
        loadIndicator(isLoading: true)
        
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
