//
//  DetailViewController.swift
//  Cryptrack
//
//  Created by Bora A.  on 31.05.2018.
//  Copyright © 2018 Bora A. ONUR. All rights reserved.
//

import UIKit
import SwiftChart

class DetailViewController: UIViewController {

    var currency: Currency!
    let bittrexClient = BittrexClient.shared
    @IBOutlet var navigationBar: UINavigationItem!
    @IBOutlet var pairLabel: UILabel!
    @IBOutlet var yesterdayLabel: UILabel!
    @IBOutlet var highLabel: UILabel!
    @IBOutlet var lowLabel: UILabel!
    @IBOutlet var volumeLabel: UILabel!
    @IBOutlet var volumeBTCLabel: UILabel!
    @IBOutlet var bidTableView: UITableView!
    @IBOutlet var askTableView: UITableView!
    var bidArray = [Order]()
    var askArray = [Order]()
    @IBOutlet var chart: Chart!
    @IBOutlet var chartLoadingIndicator: UIActivityIndicatorView!
    @IBOutlet var touchedPrice: UILabel!
    @IBOutlet var askLoadingIndicator: UIActivityIndicatorView!
    @IBOutlet var infoLoadingIndicator: UIActivityIndicatorView!
    @IBOutlet var bidLoadingIndicator: UIActivityIndicatorView!
    var selected = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chart.delegate = self
        setupTableView(tableView: bidTableView)
        setupTableView(tableView: askTableView)
        askTableView.rowHeight = 20
        bidTableView.rowHeight = 20
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        touchedPrice.layer.zPosition = 1
        chartLoadingIndicator.layer.zPosition = 1
        
        infoLoadingIndicator.startAnimating()
        bittrexClient.getCurrencyData(currency) { (currencyData, error) in
            if error != nil {
                self.displayError(message: error!)
            } else {
                DispatchQueue.main.async {
                    if let pair = currencyData?.marketName {
                        self.pairLabel.text = "Pair: \(pair)"
                    }
                    
                    if let yesterday = currencyData?.yesterday {
                        self.yesterdayLabel.text = "Yesterday: \(yesterday)"
                    }
                    
                    if let high = currencyData?.high {
                        self.highLabel.text = "24h High: \(high)"
                    }
                    
                    if let low = currencyData?.low {
                        self.lowLabel.text = "24h Low: \(low)"
                    }
                    
                    if let volume = currencyData?.volume {
                        self.volumeLabel.text = "24h Volume: \(volume)"
                    }
                    
                    if let volumeBTC = currencyData?.btcVolume {
                        self.volumeBTCLabel.text = "24h Volume(BTC): \(volumeBTC)"
                    }
                }
                DispatchQueue.main.async {
                    self.infoLoadingIndicator.stopAnimating()
                }
            }
        }
        
        bidLoadingIndicator.startAnimating()
        bittrexClient.getOrderbook(currency, type: "buy") { (orderList, error) in
            if error != nil {
                self.displayError(message: error!)
            } else {
                for i in orderList! {
                    let rate = i["Rate"] as! Double
                    let quantity = i["Quantity"] as! Double
                    let bid = Order(rate: rate, quantity: quantity)
                    self.bidArray.append(bid)
                }
                DispatchQueue.main.async {
                    self.bidTableView.reloadData()
                    self.bidLoadingIndicator.stopAnimating()
                }
            }
        }
        
        askLoadingIndicator.startAnimating()
        bittrexClient.getOrderbook(currency, type: "sell") { (orderList, error) in
            if error != nil {
                self.displayError(message: error!)
            } else {
                for i in orderList! {
                    let rate = i["Rate"] as! Double
                    let quantity = i["Quantity"] as! Double
                    let ask = Order(rate: rate, quantity: quantity)
                    self.askArray.append(ask)
                }
                DispatchQueue.main.async {
                    self.askTableView.reloadData()
                    self.askLoadingIndicator.stopAnimating()
                }
            }
        }
        
        // 30min - Daily (Default)
        chartLoadingIndicator.startAnimating()
        bittrexClient.getHistoricalData(currency, tickInterval: "thirtyMin", count: 48) { (data, error) in
            if error != nil {
                self.displayError(message: error!)
                self.chartLoadingIndicator.stopAnimating()
            } else {
                if data != nil {
                    var tupleArray: [(x: Double, y: Double)] = [(x: Double, y: Double)]()
                    var a: Double = 0
                    let count = data?.count
                    print(count!)
                    for i in 0...(count! - 1) {
                        let tuple = (a, data![i])
                        tupleArray.append(tuple)
                        a += 1
                    }
                    let series = ChartSeries(data: tupleArray)
                    self.chart.gridColor = .white
                    self.chart.showXLabelsAndGrid = false
                    self.chart.showYLabelsAndGrid = false
                    series.area = true
                    series.color = ChartColors.greenColor()
                    DispatchQueue.main.async {
                        self.chart.add(series)
                        self.chartLoadingIndicator.stopAnimating()
                    }
                } else {
                    print("no historical data for selected coin")
                }
            }
        }
    }
    
    func chartData(tickInterval: String, count: Int) {
        chartLoadingIndicator.startAnimating()
        bittrexClient.getHistoricalData(currency, tickInterval: tickInterval, count: count) { (data, error) in
            if error != nil {
                self.displayError(message: error!)
                self.chartLoadingIndicator.stopAnimating()
            } else {
                if data != nil {
                    var tupleArray: [(x: Double, y: Double)] = [(x: Double, y: Double)]()
                    var a: Double = 0
                    for i in 0...(count-1) {
                        print(data![i])
                        let tuple = (a, data![i])
                        tupleArray.append(tuple)
                        a += 1
                    }
                    let series = ChartSeries(data: tupleArray)
                    self.chart.gridColor = .white
                    self.chart.showXLabelsAndGrid = false
                    self.chart.showYLabelsAndGrid = false
                    series.area = true
                    series.color = ChartColors.greenColor()
                    DispatchQueue.main.async {
                        self.chart.add(series)
                        self.chartLoadingIndicator.stopAnimating()
                    }
                } else {
                    print("no historical data for selected coin")
                }
                
            }
        }
    }
    
    @IBAction func showLast4HourClicked(_ sender: UIBarButtonItem) {
        highlightButton(sender: sender)
        chart.removeAllSeries()
        chartData(tickInterval: "fiveMin", count: 48) // show last 4h
    }
    
    @IBAction func showLast1DayClicked(_ sender: UIBarButtonItem) {
        highlightButton(sender: sender)
        chart.removeAllSeries()
        chartData(tickInterval: "thirtyMin", count: 48) // show last 24h
    }
    
    @IBAction func showLast1WeekClicked(_ sender: UIBarButtonItem) {
        highlightButton(sender: sender)
        chart.removeAllSeries()
        chartData(tickInterval: "hour", count: 168) // show 1 week
    }
    
    @IBAction func showLast1MonthClicked(_ sender: UIBarButtonItem) {
        highlightButton(sender: sender)
        chart.removeAllSeries()
        chartData(tickInterval: "day", count: 30) // show 1 month
    }
    
    @IBAction func showLast6MonthClicked(_ sender: UIBarButtonItem) {
        highlightButton(sender: sender)
        chart.removeAllSeries()
        chartData(tickInterval: "day", count: 180) // 6 month
        
        
    }
    
    func highlightButton(sender: UIBarButtonItem) {
        let buttons = sender.buttonGroup?.barButtonItems
        for i in buttons! {
            i.tintColor = UIColor.blue
        }
        sender.tintColor = .black
    }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.askTableView {
            return askArray.count
        } else {
            return bidArray.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.bidTableView {
            let cell = UITableViewCell(style: .value1, reuseIdentifier: "bidCell")
            cell.textLabel?.font = UIFont(name: "HelveticaNeue", size: 8)
            cell.textLabel?.text = String(self.bidArray[indexPath.row].quantity!)
            cell.detailTextLabel?.font = UIFont(name: "HelveticaNeue", size: 8)
            cell.detailTextLabel?.text = String(self.bidArray[indexPath.row].rate!)
            cell.detailTextLabel?.textColor = .black
            cell.backgroundColor = UIColor(red: 128.0/255.0, green: 206.0/255.0, blue: 160.0/255.0, alpha: 1.0)
            return cell
        } else {
            let cell = UITableViewCell(style: .value1, reuseIdentifier: "askCell")
            cell.textLabel?.font = UIFont(name: "HelveticaNeue", size: 11)
            cell.textLabel?.text = String(self.askArray[indexPath.row].quantity!)
            cell.detailTextLabel?.font = UIFont(name: "HelveticaNeue", size: 11)
            cell.detailTextLabel?.text = String(self.askArray[indexPath.row].rate!)
            cell.detailTextLabel?.textColor = .black
            cell.backgroundColor = UIColor(red: 232.0/255.0, green: 136.0/255.0, blue: 131.0/255.0, alpha: 1.0)
            return cell
        }
    }
    
    func setupTableView(tableView: UITableView) {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
}

extension DetailViewController: ChartDelegate {
    func didTouchChart(_ chart: Chart, indexes: [Int?], x: Float, left: CGFloat) {
        for (seriesIndex, dataIndex) in indexes.enumerated() {
            if dataIndex != nil {
                // The series at `seriesIndex` is that which has been touched
                let value = chart.valueForSeries(seriesIndex, atIndex: dataIndex)
                touchedPrice.text = String(value!)
            }
        }
    }
    
    func didFinishTouchingChart(_ chart: Chart) {
        // Do something when finished
    }
    
    func didEndTouchingChart(_ chart: Chart) {
        // Do something when ending touching chart
    }
}
