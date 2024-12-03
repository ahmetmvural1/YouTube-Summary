//
//  MainViewController.swift
//  Video Summarize
//
//  Created by Ahmet Muhammet VURAL on 25.11.2024.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.registerCell(type: ListTableViewCell.self)
        }
    }
    
    private let emptyStateView: UIView = {
        let view = UIView()
        view.isHidden = true // Varsayılan olarak gizlenmiş
        return view
    }()
    
    private let emptyStateImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "tray") // SF Symbol veya özel bir görsel
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = Text.emptyMessage
        label.textColor = .gray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var responses: [SummarizerResponse] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        if !UserDefaults.standard.bool(forKey: "isOnboarded") {
            let initialViewController = UIStoryboard(name: "FirstOnboard", bundle: .main).instantiateViewController(withIdentifier: "FirstOnboardViewController") as! FirstOnboardViewController
            initialViewController.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(initialViewController, animated: false)
        }
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupEmptyStateView()
        loadResponses()
    }
    
    private func setupEmptyStateView() {
        view.addSubview(emptyStateView)
        emptyStateView.addSubview(emptyStateImageView)
        emptyStateView.addSubview(emptyStateLabel)
        
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            emptyStateImageView.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            emptyStateImageView.topAnchor.constraint(equalTo: emptyStateView.topAnchor),
            emptyStateImageView.widthAnchor.constraint(equalToConstant: 80),
            emptyStateImageView.heightAnchor.constraint(equalToConstant: 80),
            
            emptyStateLabel.topAnchor.constraint(equalTo: emptyStateImageView.bottomAnchor, constant: 16),
            emptyStateLabel.leadingAnchor.constraint(equalTo: emptyStateView.leadingAnchor),
            emptyStateLabel.trailingAnchor.constraint(equalTo: emptyStateView.trailingAnchor),
            emptyStateLabel.bottomAnchor.constraint(equalTo: emptyStateView.bottomAnchor)
        ])
    }
    
    func loadResponses() {
        responses = ResponseManager.shared.getResponses()
        tableView.reloadData()
        updateEmptyState()
    }

    private func updateEmptyState() {
        let isEmpty = responses.isEmpty
        emptyStateView.isHidden = !isEmpty
        tableView.isHidden = isEmpty
    }

    @IBAction func addButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let addViewController = storyboard.instantiateViewController(withIdentifier: "AddViewController") as? AddViewController {
            self.navigationController?.pushViewController(addViewController, animated: true)
        }
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return responses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ListTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        let data = responses[indexPath.row]
        cell.refreshCell(title: data.title)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let data = responses[indexPath.row]
        if let detailViewController = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            detailViewController.data = data
            self.navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
    
    // Arka planı şeffaf ve simgesi yuvarlak bir aksiyon
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: nil) { [weak self] _, _, completionHandler in
            guard let self = self else { return }
            
            let alert = UIAlertController(
                title: Text.removeTitle,
                message: Text.removeMessage,
                preferredStyle: .actionSheet
            )
            
            let confirmAction = UIAlertAction(title: Text.yesButton, style: .destructive) { _ in
                ResponseManager.shared.removeResponse(at: indexPath.row)
                self.responses.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                self.updateEmptyState()
            }
            
            let cancelAction = UIAlertAction(title: Text.noButton, style: .cancel, handler: nil)
            alert.addAction(confirmAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
            
            completionHandler(true)
        }
        
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .background
        
        if let trashImage = UIImage(systemName: "trash") {
            let size = CGSize(width: 40, height: 40)
            let renderer = UIGraphicsImageRenderer(size: size)
            let roundedImage = renderer.image { context in
                let rect = CGRect(origin: .zero, size: size)
                UIColor.red.setFill()
                context.cgContext.fillEllipse(in: rect)
                trashImage.withTintColor(.white).draw(in: rect.insetBy(dx: 10, dy: 10))
            }
            deleteAction.image = roundedImage
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = Bundle.main.loadNibNamed("MainHeaderTableViewCell", owner: self, options: nil)?.first as! MainHeaderTableViewCell
        let data = ResponseManager.shared.getResponsesStatistics()
        headerView.refreshCell(summarCount: responses.count, wordCount: data.totalWordCountInSummary, timeCount: data.totalDurationInMinutes)
        return headerView
    }
}
