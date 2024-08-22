//
//  AddTransactionViewControllerRepresentable.swift
//  piggy
//
//  Created by Eric Fernando on 22/08/24.
//

import Foundation
import SwiftUI

struct AddTransactionViewControllerRepresentable: UIViewControllerRepresentable {
    
    @EnvironmentObject private var addTransactionWrapper: AddTransactionWrapper
    
    typealias UIViewControllerType = AddTransactionViewController
    
    func makeUIViewController(context: Context) -> AddTransactionViewController {
        let viewController = AddTransactionViewController()
        viewController.addTransactionWrapper = addTransactionWrapper
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: AddTransactionViewController, context: Context) {}
}
