//
//  AssetSelectionViewController.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 8/20/25.
//

import Foundation
import UIKit
import UICollectionViewLeftAlignedLayout

/// 자산 선택 뷰
class AssetSelectionViewController: UIViewController {

    private var assets: [UserAsset] = []
    
    var onSelect: ((UserAsset) -> Void)?
    
    
    // MARK: Sub Views
    
    private var navigationBar: CustomNavigationBar!
    
    private var doneBtn: CustomIconButton!
    
    private var collectionView: UICollectionView!
    

    // MARK: Init & Set up
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set dummy data
        assets = Array(1...10).map { _ in
            UserAsset.createDummyData()
        }
        assets[1].title = "제일긴자산이름은열자"
        assets[2].title = "englishhhh"
        assets[3].title = "o"
        assets[4].title = "1234567890"
        assets[5].title = "자산 이름"
        assets[6].title = "농협"
    
        setUI()
        setLayout()
    }
    
    private func setUI() {
        view.backgroundColor = .moneyTogether.background
        
        self.setupNavigationBar()
        self.setupCollectionView()
        
        self.view.addSubview(navigationBar)
        self.view.addSubview(collectionView)
        
    }
    
    private func setLayout() {
        
        NSLayoutConstraint.activate([
            self.navigationBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.navigationBar.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.navigationBar.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            
            self.collectionView.topAnchor.constraint(equalTo: self.navigationBar.bottomAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
}

// MARK: Set Up Sub Views
extension AssetSelectionViewController {
    private func setupNavigationBar() {
        self.navigationBar = CustomNavigationBar(
            title: "자산을 선택하세요."
        )
    }
    
    private func setupCollectionView() {
        
        // collection view
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLeftAlignedLayout()).disableAutoresizingMask()
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        self.collectionView.backgroundColor = .moneyTogether.background
        self.collectionView.contentInset = .init(top: 20, left: Layout.side, bottom: Layout.bottom, right: Layout.side)
        
        // register cell
        self.collectionView.register(AssetSelectionCell.self, forCellWithReuseIdentifier: AssetSelectionCell.reuseId)
    }
    
}

// MARK: Layout
extension AssetSelectionViewController: UICollectionViewDelegateLeftAlignedLayout {
    
    /// cell size
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let assetName = assets[indexPath.item].title
        let label = UILabel.make(
            text: assetName,
            font: .moneyTogetherFont(style: .b2),
            numberOfLines: 1
        )
        let labelWidth = label.intrinsicContentSize.width
        
        let cellWidth: CGFloat = labelWidth + (AssetSelectionCell.horizontalPadding * 2)
        
        return CGSize(width: cellWidth, height: AssetSelectionCell.cellHeight)
    }
    
    
    /// cell 간 spacing
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt index: Int) -> CGFloat {
        return 8
    }
}

// MARK: DataSource
extension AssetSelectionViewController: UICollectionViewDataSource {

    /// datasource count
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assets.count
    }
    
    /// configure cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = assets[indexPath.item]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AssetSelectionCell.reuseId, for: indexPath) as? AssetSelectionCell
        
        cell?.configure(name: data.title)
        
        return cell ?? UICollectionViewCell()

    }
}

// MARK: Delegate
extension AssetSelectionViewController: UICollectionViewDelegate {
    /// handle cell selection
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.onSelect?(assets[indexPath.item])
    }
}


#if DEBUG

import SwiftUI

#Preview {
    return AssetSelectionViewController()
}

#endif

