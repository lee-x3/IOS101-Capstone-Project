//
//  QuotesViewController.swift
//  TheMoodJournal
//
//  Created by Xia Mey Lee on 4/14/25.
//

import UIKit

// MARK: - Quote Models
struct Quote: Codable {
    let id: String
    let author: String
    let text: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case author
        case text
    }
}

// Response model for ZenQuotes API
struct ZenQuoteResponse: Codable {
    let q: String  // The quote text
    let a: String  // The author
    let h: String  // HTML version (we'll ignore this)
    
    // Custom init to generate an ID since ZenQuotes doesn't provide one
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        q = try container.decode(String.self, forKey: .q)
        a = try container.decode(String.self, forKey: .a)
        h = try container.decode(String.self, forKey: .h)
    }
    
    enum CodingKeys: String, CodingKey {
        case q, a, h
    }
}

class QuotesViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var quoteCardView: UIView!
    @IBOutlet weak var quoteTextLabel: UILabel!
    @IBOutlet weak var quoteAuthorLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var moodRelatedLabel: UILabel!
    
    // MARK: - Properties
    private var currentQuote: Quote?
    private var favoriteQuotes: [Quote] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchRandomQuote()
    }
    
    // MARK: - Setup
    private func setupUI() {
        // Configure title
        //title = "Daily Quote"
        
        // Configure quote card
        quoteCardView.backgroundColor = .systemBackground
        quoteCardView.layer.cornerRadius = 12
        quoteCardView.layer.shadowColor = UIColor.black.cgColor
        quoteCardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        quoteCardView.layer.shadowRadius = 6
        quoteCardView.layer.shadowOpacity = 0.1
        
        // Configure quote text
        quoteTextLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        quoteTextLabel.textColor = .label
        quoteTextLabel.numberOfLines = 0
        
        // Configure author
        quoteAuthorLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        quoteAuthorLabel.textColor = .secondaryLabel
        
        // Configure mood related label
        moodRelatedLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        moodRelatedLabel.textColor = .tertiaryLabel
        moodRelatedLabel.text = "Finding the right words for your mood"
        
        // Configure activity indicator
        activityIndicator.hidesWhenStopped = true
        
        // Configure refresh button
        refreshButton.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        refreshButton.tintColor = .systemBlue
        
        // Configure favorite button
        favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        favoriteButton.tintColor = .systemPink
        updateFavoriteButtonState()
        
        // Tab bar setup
        self.tabBarItem = UITabBarItem(title: "Quote", image: UIImage(systemName: "quote.bubble"), tag: 3)
    }
    
    // MARK: - Data Fetching
    private func fetchRandomQuote() {
        // Show loading state
        activityIndicator.startAnimating()
        quoteTextLabel.text = "Loading..."
        quoteAuthorLabel.text = ""
        
        // Create URL for ZenQuotes API
               guard let url = URL(string: "https://zenquotes.io/api/random") else {
                   showError("Invalid URL")
                   return
               }
               
               // Create request
               var request = URLRequest(url: url)
               request.httpMethod = "GET"
               
               // Create task
               let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                   guard let self = self else { return }
                   
                   // Check for errors
                   if let error = error {
                       self.showError(error.localizedDescription)
                       return
                   }
                   
                   // Check response
                   guard let httpResponse = response as? HTTPURLResponse,
                         (200...299).contains(httpResponse.statusCode) else {
                       self.showError("Server error")
                       return
                   }
                   
                   // Check data
                   guard let data = data else {
                       self.showError("No data received")
                       return
                   }
                   
                   // Parse data
                   do {
                       // ZenQuotes returns an array with a single quote
                       let zenQuotes = try JSONDecoder().decode([ZenQuoteResponse].self, from: data)
                       
                       guard let zenQuote = zenQuotes.first else {
                           self.showError("No quote found in response")
                           return
                       }
                       
                       // Map to our Quote model
                       let quote = Quote(
                           id: UUID().uuidString, // Generate a unique ID
                           author: zenQuote.a,
                           text: zenQuote.q
                       )
                       
                       // Update UI on main thread
                       DispatchQueue.main.async {
                           self.updateUI(with: quote)
                       }
                   } catch {
                       print("Parse error: \(error)")
                       self.showError("Failed to parse quote: \(error.localizedDescription)")
                   }
               }
               
               // Start task
               task.resume()
           }
           
    // MARK: - UI Updates
    private func updateUI(with quote: Quote) {
        activityIndicator.stopAnimating()
        
        self.currentQuote = quote
        
        // Update labels
        quoteTextLabel.text = "\"\(quote.text)\""
        quoteAuthorLabel.text = "— \(quote.author.isEmpty ? "Unknown" : quote.author)"
        
        // Update favorite button
        updateFavoriteButtonState()
        
        // Animate the appearance
        quoteCardView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.quoteCardView.alpha = 1
        }
    }
    
    private func showError(_ message: String) {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.quoteTextLabel.text = "Something went wrong"
            self.quoteAuthorLabel.text = message
            
            // Show alert
            let alert = UIAlertController(
                title: "Error",
                message: message,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
    
    // MARK: - Favorites Management
    private func updateFavoriteButtonState() {
        guard let currentQuote = currentQuote else { return }
        
        let isFavorite = favoriteQuotes.contains { $0.id == currentQuote.id }
        let imageName = isFavorite ? "heart.fill" : "heart"
        favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    private func toggleFavorite() {
        guard let currentQuote = currentQuote else { return }
        
        if let index = favoriteQuotes.firstIndex(where: { $0.id == currentQuote.id }) {
            // Remove from favorites
            favoriteQuotes.remove(at: index)
        } else {
            // Add to favorites
            favoriteQuotes.append(currentQuote)
        }
        
        updateFavoriteButtonState()
        
        // Show confirmation
        let isNowFavorite = favoriteQuotes.contains { $0.id == currentQuote.id }
        let message = isNowFavorite ? "Added to favorites" : "Removed from favorites"
        
        let banner = UILabel()
        banner.text = message
        banner.textAlignment = .center
        banner.backgroundColor = .systemGray6
        banner.textColor = .label
        banner.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        banner.layer.cornerRadius = 16
        banner.clipsToBounds = true
        banner.alpha = 0
        
        view.addSubview(banner)
        banner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            banner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            banner.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            banner.widthAnchor.constraint(equalToConstant: 200),
            banner.heightAnchor.constraint(equalToConstant: 32)
        ])
        
        UIView.animate(withDuration: 0.3, animations: {
            banner.alpha = 1
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: 1.5, options: [], animations: {
                banner.alpha = 0
            }) { _ in
                banner.removeFromSuperview()
            }
        }
    }
    
    // MARK: - Actions
    @IBAction func refreshButtonTapped(_ sender: UIButton) {
        fetchRandomQuote()
    }
    
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        toggleFavorite()
    }
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        guard let quoteText = quoteTextLabel.text,
              let authorText = quoteAuthorLabel.text else { return }
        
        let textToShare = "\(quoteText)\n\(authorText)\n\nShared from The Mood Journal"
        let activityViewController = UIActivityViewController(
            activityItems: [textToShare],
            applicationActivities: nil
        )
        
        // Present the view controller
        present(activityViewController, animated: true)
    }
}
