//
//  NewEntryViewController.swift
//  TheMoodJournal
//
//  Created by Xia Mey Lee on 4/12/25.
//

import UIKit

class NewEntryViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var moodEmojiLabel: UILabel!
    @IBOutlet weak var activitiesStackView: UIStackView!
    @IBOutlet weak var journalTextView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    
    // MARK: - Properties
    private var selectedDate: Date!
    private var selectedMood: Int?
    private var energyLevel: Float!
    private var selectedActivities: [String]!
    
    private let emojiOptions = ["😞", "😊", "😒", "😡", "😭"]
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        activitiesStackView.distribution = .fillEqually
        
        setupUI()
        displayEntryData()
    }
    
    // MARK: - Setup
    private func setupUI() {
        // Configure title
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        
        // Configure text view
        journalTextView.layer.borderColor = UIColor.systemGray4.cgColor
        journalTextView.layer.borderWidth = 1
        journalTextView.layer.cornerRadius = 8
        journalTextView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        journalTextView.text = "Today was a productive day..."
        journalTextView.textColor = .placeholderText
        journalTextView.delegate = self
        
        // Configure save button
        saveButton.backgroundColor = .systemBlue
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.cornerRadius = 8
    }
    
    // MARK: - Configuration
    func configure(with date: Date, mood: Int?, energy: Float, activities: [String]) {
        selectedDate = date
        selectedMood = mood
        energyLevel = energy
        selectedActivities = activities
    }
    
    private func displayEntryData() {
        // Display date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateLabel.text = dateFormatter.string(from: selectedDate)
        
        // Display mood emoji
        if let mood = selectedMood, mood >= 1 && mood <= 5 {
            moodEmojiLabel.text = emojiOptions[mood - 1]
        } else {
            moodEmojiLabel.text = "🙂" // Default emoji
        }
        
        // Display activities
        for activity in selectedActivities {
            let activityLabel = createActivityLabel(with: activity)
            activitiesStackView.addArrangedSubview(activityLabel)
        }
    }
    
    private func createActivityLabel(with text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.backgroundColor = .systemBlue
        label.textColor = .white
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        
        let fixedWidth = 40
        
        
        label.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                label.widthAnchor.constraint(equalToConstant: CGFloat(fixedWidth)),
                label.heightAnchor.constraint(equalToConstant: 30)
            ])
        
        // Apply padding
        let paddingInsets = UIEdgeInsets(top: 6, left: 20, bottom: 6, right: 20)
        let size = text.size(withAttributes: [.font: UIFont.systemFont(ofSize: 14)])
        label.frame.size = CGSize(
            width: size.width + paddingInsets.left + paddingInsets.right,
            height: size.height + paddingInsets.top + paddingInsets.bottom
        )
        
        return label
    }
    
    // MARK: - Actions
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        
        guard let journalText = journalTextView.text,
                  journalText != "Today was a productive day..." else {
                let alert = UIAlertController(
                    title: "Empty Journal",
                    message: "Please write something about your day.",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                present(alert, animated: true)
                return
            }
            
            // Convert mood to JournalMood
            let mood: JournalMood
            if let selectedMood = selectedMood, selectedMood >= 1 && selectedMood <= 5 {
                switch selectedMood {
                case 1: mood = .veryPoor
                case 2: mood = .poor
                case 3: mood = .neutral
                case 4: mood = .good
                case 5: mood = .excellent
                default: mood = .neutral
                }
            } else {
                mood = .neutral
            }
            
            // Create new journal entry
            let newEntry = JournalEntrySimple(
                date: selectedDate,
                mood: mood,
                activities: selectedActivities,
                journalText: journalText
            )
            
            // Post notification to add the entry
            NotificationCenter.default.post(
                name: NSNotification.Name("NewJournalEntryAdded"),
                object: newEntry
            )
            
            // Show save confirmation and then go back
            let alert = UIAlertController(
                title: "Entry Saved",
                message: "Your journal entry has been saved.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }))
            present(alert, animated: true)
    }
}

// MARK: - UITextView Delegate
extension NewEntryViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .placeholderText {
            textView.text = nil
            textView.textColor = .label
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Today was a productive day..."
            textView.textColor = .placeholderText
        }
    }
}
