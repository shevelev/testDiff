//
//  ViewController.swift
//  collectionView
//
//  Created by Сергей Шевелев on 19.07.2022.
//

import UIKit


class ViewController: UIViewController {
    
    fileprivate typealias UserDataSource = UICollectionViewDiffableDataSource<ViewController.Section, TestObject>
    fileprivate typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<ViewController.Section, TestObject>

    enum Section {
        case main
    }
    
    var testArray = [TestObject]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var snapshot = DataSourceSnapshot()
    private var dataSource: UserDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        
        collectionView.collectionViewLayout = configCL()
        configDataSource()
        setupUIRefreshControl(with: collectionView)
    }
    
    func setupUIRefreshControl(with collectionView: UICollectionView) {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        refreshControl.tintColor = .green
        collectionView.refreshControl = refreshControl
    }
    
    @objc func handleRefresh() {
        
        NetworkService.shared.downloadContactsFromServer { (done,   fetched) in
            if !done {
                print("-----------------------------------------")
                print("- Error while fetching data from server -")
                print("-----------------------------------------")
            }else {
                DispatchQueue.main.async {
                    self.snapshot.deleteAllItems()
                    self.snapshot.appendSections([Section.main])
                    self.snapshot.appendItems(fetched)
                    self.dataSource.apply(self.snapshot, animatingDifferences: true)
                }
            }
            DispatchQueue.main.async{
                self.collectionView.refreshControl?.endRefreshing()
            }
        }
    }
    
    func configCL() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(0.2))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func configDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, TestObject>(collectionView: collectionView) { (collectionView, indexPath, itemIdentifier) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NumberCell.reuseIdentifier, for: indexPath) as! NumberCell
            
            cell.test = itemIdentifier

            return cell
        }
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let test = dataSource.itemIdentifier(for: indexPath) else {return}
        print("artist: \(test.artistName) -> collection: \(test.collectionName) -> track: \(test.trackCount)")
    }
}
