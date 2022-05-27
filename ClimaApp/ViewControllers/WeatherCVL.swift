//
//  WeatherCVL.swift
//  ClimaApp
//
//  Created by Yassine DAOUDI on 26/5/2022.
//

import UIKit

class WeatherCVL: UIViewController {
    
    enum Section { case main }
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, WeatherModel>!

    weak var coordinator: MainCoordinator?
    
    var citiesList = ["Casablanca", "Rabat", "Marrakech", "Fes", "Tanger"]
    var weatherModelList = [WeatherModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        WeatherManager.shared.delegate = self
        
        configureNavigationBar()
        configureCollectionView()
        configureDataSource()
        initList()
    }
    
    private func initList() {
        citiesList.forEach {
            WeatherManager.shared.fetchWeather(cityName: $0)
        }
    }
    
    private func configureNavigationBar() {
        let image = UIImage(systemName: "plus.circle")
        let addButton = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(addNewCity))
        navigationItem.rightBarButtonItem = addButton
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.leftBarButtonItem?.primaryAction = UIAction(title:"Edit") { _ in
            self.setEditing(!self.isEditing, animated: true)
        }
    }
    
    @objc func addNewCity() {
        let ac = UIAlertController(title: "Enter the name of the city", message: nil, preferredStyle: .alert)
           ac.addTextField()

           let submitAction = UIAlertAction(title: "Add", style: .default) { [unowned ac] _ in
               let answer = ac.textFields![0]
               if let city = answer.text {
                   self.citiesList.append(city)
                   WeatherManager.shared.fetchWeather(cityName: city)
               }
           }

           ac.addAction(submitAction)
           present(ac, animated: true)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated:animated)
        collectionView.isEditing = editing
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.delegate = self
        view.addSubview(collectionView)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let sectionProvider = {(sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            var config = UICollectionLayoutListConfiguration(appearance: .sidebar)
            config.trailingSwipeActionsConfigurationProvider = { ip in
                let delete = UIContextualAction(style: .destructive, title: "Delete") { action, view, completion in
                    self.delete(at: ip)
                    self.citiesList.remove(at: ip.item)
                    self.weatherModelList.remove(at: ip.item)
                    completion(true)
                }
                let swipe = UISwipeActionsConfiguration(actions: [delete])
                return swipe
            }
            
            let section = NSCollectionLayoutSection.list(using: config, layoutEnvironment: layoutEnvironment)
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10)
            return section
        }
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
    }
    
    private func createCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, WeatherModel> {
        return UICollectionView.CellRegistration<UICollectionViewListCell, WeatherModel> { (cell, indexPath, item) in
            var content = cell.defaultContentConfiguration()
            content.text = item.cityName
            content.textProperties.adjustsFontSizeToFitWidth = true
            content.textProperties.adjustsFontForContentSizeCategory = true
            content.secondaryText = "\(item.temperatureString) °C"
            content.secondaryTextProperties.adjustsFontForContentSizeCategory = true
            content.secondaryTextProperties.adjustsFontSizeToFitWidth = true
            content.image = UIImage(systemName: item.conditionName)
            cell.accessories = [.disclosureIndicator(), .delete()]
            cell.contentConfiguration = content
        }
    }
    
    private func configureDataSource() {
        let cellRegistration = createCellRegistration()
        dataSource = UICollectionViewDiffableDataSource<Section, WeatherModel>(collectionView: collectionView, cellProvider: {
            (collectionView, indexPath, city) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: city)
        })
    }
    
    private func updateData(with cities: [WeatherModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, WeatherModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(cities)
        dataSource.apply(snapshot)
    }
    
    func delete(at ip: IndexPath) {
        var snap = self.dataSource.snapshot()
        if let ident = self.dataSource.itemIdentifier(for: ip) {
            snap.deleteItems([ident])
        }
        self.dataSource.apply(snap)
    }
}

extension WeatherCVL: WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        self.weatherModelList.append(weather)
        self.updateData(with: weatherModelList)
    }
    
    func didFailWithError(error: CAError) {
        print(error.rawValue)
    }
}

extension WeatherCVL: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = self.dataSource.itemIdentifier(for: indexPath) else {
            collectionView.deselectItem(at: indexPath, animated: true)
            return
        }
        
        let vc = WeatherDetailsVC()
        vc.weather = item
        navigationController?.pushViewController(vc, animated: true)
    }
}
