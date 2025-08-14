//
//  CategorySelectionViewController.swift
//  MoneyTogether
//
//  Created by Heeoh Son on 8/14/25.
//

import Foundation
import UIKit

#warning("TODO: 카테고리 선택, 카테고리 리스트 가져오기, done action")
final class CategorySelectionViewController: UIViewController {
    
    private var dataSource: [Category] = Category.createDummyList()
    
    var onBackBtnTapped: (() -> Void)?
    
    var onSelect: ((Category) -> Void)?
    
    // MARK: Sub Views
    
    private var navigationBar: CustomNavigationBar!
    
    private var collectionView: UICollectionView!
    
    // MARK: Init & Set up
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        
        dataSource[6].name = "매우매우긴이름인데몇자까지할지는모르겠어"
        dataSource[7].name = "매우매우긴이름인데몇자까지할지는모르겠어"
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
            title: "카테고리를 선택해주세요",
            backBtnMode: .modal,
            backAction: {
                print(#fileID, #function, #line, "back")
                self.onBackBtnTapped?()
            }
        )
    }
    
    private func setupCollectionView() {
        // layout
        let gridLayout = GridCollectionViewFlowLayout()
        gridLayout.ratioHeightToWidth = 1.2
        gridLayout.numberOfColumns = 3
        gridLayout.cellSpacing = 4
        
        // collection view
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: gridLayout).disableAutoresizingMask()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        self.collectionView.backgroundColor = .moneyTogether.background
        self.collectionView.contentInset = .init(top: 20, left: Layout.side, bottom: Layout.bottom, right: Layout.side)
        
        // register cell
        self.collectionView.register(CategorySelectionCell.self, forCellWithReuseIdentifier: CategorySelectionCell.reuseId)
    }
}

extension CategorySelectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let data = dataSource[indexPath.item]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategorySelectionCell.reuseId, for: indexPath) as? CategorySelectionCell
        
        cell?.configure(with: data)
        
        return cell ?? UICollectionViewCell()
    }
}

extension CategorySelectionViewController: UICollectionViewDelegateFlowLayout {
    
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

extension CategorySelectionViewController: UICollectionViewDelegate {
    
    /// cell이 선택되었을 때 호출되는 메서드
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.onSelect?(dataSource[indexPath.row])
    }
}

#Preview {
    CategorySelectionViewController()
}
