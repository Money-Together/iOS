//
//  CategoryColorSelectionViewController.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 9/1/25.
//

import Foundation
import UIKit

/// 컬러 선택 뷰
class ColorSelectionViewController: UIViewController {

    private var dataSource: [PaletteColor] = ColorPalette.presets
    
    var onSelect: ((PaletteColor) -> Void)?
    
    // MARK: Sub Views
    
    private var navigationBar: CustomNavigationBar!
    
    private var collectionView: UICollectionView!
    
    // MARK: Init & Set up
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
    }
    
    private func setUI() {
        view.backgroundColor = .moneyTogether.background
        
        self.setupNavigationBar()
        self.setupCollectionView()
        
        self.view.addSubview(self.navigationBar)
        self.view.addSubview(self.collectionView)
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
    
    private func setupNavigationBar() {
        self.navigationBar = CustomNavigationBar(
            title: "색상을 선택해주세요"
        )
    }
    
    private func setupCollectionView() {
        // layout
        let gridLayout = GridCollectionViewFlowLayout()
        gridLayout.ratioHeightToWidth = 1
        gridLayout.numberOfColumns = 5
        gridLayout.cellSpacing = 4
        
        // collection view
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: gridLayout).disableAutoresizingMask()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        self.collectionView.backgroundColor = .moneyTogether.background
        self.collectionView.contentInset = .init(top: 20, left: Layout.side, bottom: Layout.bottom, right: Layout.side)
        
        // register cell
        self.collectionView.register(ColorSelectionCell.self, forCellWithReuseIdentifier: ColorSelectionCell.reuseId)
    }
}

extension ColorSelectionViewController: UICollectionViewDataSource {
    /// datasource(color palette) count
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    /// ColorSelectionCell configure
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let data = dataSource[indexPath.item]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorSelectionCell.reuseId, for: indexPath) as? ColorSelectionCell
        
        cell?.configure(with: data)
        
        return cell ?? UICollectionViewCell()
    }
}

extension ColorSelectionViewController: UICollectionViewDelegateFlowLayout {
    
    /// grid layout cell 사이즈 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let layout = collectionViewLayout as? GridCollectionViewFlowLayout,
              layout.numberOfColumns > 0 else {
            fatalError()
        }
        
        // collectionview content width
        // 한 줄에 들어가는 모든 cell + spacing 총합
        let widthOfContent = collectionView.bounds.width - (collectionView.contentInset.left + collectionView.contentInset.right)
        
        // spacing 총합
        let widthOfSpacing = CGFloat(layout.numberOfColumns - 1) * layout.cellSpacing
        
        // Cell 하나의 width
        let widthOfCell = (widthOfContent - widthOfSpacing) / CGFloat(layout.numberOfColumns)
        
        return CGSize(width: widthOfCell, height: widthOfCell * layout.ratioHeightToWidth)
    }
}

extension ColorSelectionViewController: UICollectionViewDelegate {
    
    /// cell이 선택되었을 때 호출되는 메서드
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.onSelect?(dataSource[indexPath.item])
    }
}

#if DEBUG

import SwiftUI

#Preview {
    return ColorSelectionViewController()
}

#endif
