//
//  GroupSelectViewController.swift
//  Corgi
//
//  Created by 서상의 on 2021/10/08.
//

import UIKit
import Combine

class GroupSelectViewController: ViewController {
    var action: ((Group) -> Void)? = nil
    
    private let viewModel: GroupSelectViewModel
    private var subscriptions = Set<AnyCancellable>()
    
    init(viewModel: GroupSelectViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func loadView() {
        let groupSelectView = GroupSelectView(viewModel: self.viewModel)
        self.view = groupSelectView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.subscribe(to: self.viewModel.$group.eraseToAnyPublisher())
        self.viewModel.requestGroups()
    }
}

private extension GroupSelectViewController {
    func subscribe(to publisher: AnyPublisher<Group?, Never>) {
        publisher
            .receive(on: DispatchQueue.main)
            .compactMap({ $0 })
            .sink { [weak self] group in
                self?.action?(group)
                self?.dismiss(animated: .yes, completion: nil)
            }
            .store(in: &self.subscriptions)
    }
}
