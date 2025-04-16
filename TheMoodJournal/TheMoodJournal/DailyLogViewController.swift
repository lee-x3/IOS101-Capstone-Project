//
//  DailyLogViewController.swift
//  TheMoodJournal
//
//  Created by Xia Mey Lee on 4/8/25.
//


import UIKit



class DailyLogViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var moodQuestionLabel: UILabel!
    @IBOutlet weak var emojiStackView: UIStackView!
    @IBOutlet weak var energyLabel: UILabel!
    @IBOutlet weak var energySlider: UISlider!
    @IBOutlet weak var activitiesLabel: UILabel!
    @IBOutlet weak var activitiesCollectionView: UICollectionView!
    @IBOutlet weak var journalEntryButton: UIButton!
    
    // MARK: - Properties
    private var selectedDate = Date()
    private var selectedMood: Int? // 1-5 corresponding to emoji index
    private var energyLevel: Float = 0.5 // 0.0-1.0
    private var selectedActivities: Set<String> = []
    
    private let emojiOptions = ["😞", "😊", "😒", "😡", "😭",]
    
    private let activityOptions = ["Work", "Social", "Exercise", "Family", "Hobby", "Study", "Rest"]
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionView()
    }
    
    // MARK: - Setup
    private func setupUI() {
        // Configure title
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        
        // Configure date button
        updateDateButton()
        dateButton.backgroundColor = .systemGray6
        dateButton.layer.cornerRadius = 8
        
        // Configure mood question
        moodQuestionLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        
        // Configure energy slider
        energyLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        energySlider.value = 0.5
        
        // Configure activities
        activitiesLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        
        // Configure journal entry button
        journalEntryButton.backgroundColor = .systemGray6
        journalEntryButton.layer.cornerRadius = 8
        journalEntryButton.contentHorizontalAlignment = .left
        journalEntryButton.contentEdgeInsets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        journalEntryButton.setTitleColor(.systemGray, for: .normal)
    }
    
    private func setupCollectionView() {
        activitiesCollectionView.delegate = self
        activitiesCollectionView.dataSource = self
        activitiesCollectionView.register(ActivityCell.self, forCellWithReuseIdentifier: "ActivityCell")
        activitiesCollectionView.register(AddActivityCell.self, forCellWithReuseIdentifier: "AddActivityCell")
        
        // Configure collection view layout
        if let flowLayout = activitiesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .vertical
            flowLayout.minimumInteritemSpacing = 10
            flowLayout.minimumLineSpacing = 10
        }
    }
    
    private func updateDateButton() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateButton.setTitle(dateFormatter.string(from: selectedDate), for: .normal)
        
        // Add dropdown indicator
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 14, weight: .medium)
        let image = UIImage(systemName: "chevron.down", withConfiguration: imageConfig)
        dateButton.setImage(image, for: .normal)
        dateButton.semanticContentAttribute = .forceRightToLeft
        dateButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
    }
    
    // MARK: - Actions
    @IBAction func dateButtonTapped(_ sender: UIButton) {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.date = selectedDate
        
        let alertController = UIAlertController(title: "Select Date", message: nil, preferredStyle: .actionSheet)
        
        // Add container view for the date picker
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 250))
        containerView.addSubview(datePicker)
        datePicker.frame = CGRect(x: 0, y: 0, width: containerView.frame.width, height: containerView.frame.height)
        alertController.view.addSubview(containerView)
        
        // Adjust size of alert controller
        let height: NSLayoutConstraint = NSLayoutConstraint(
            item: alertController.view as Any,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1,
            constant: 350
        )
        alertController.view.addConstraint(height)
        
        // Add buttons
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.addAction(UIAlertAction(title: "Done", style: .default, handler: { [weak self] _ in
            self?.selectedDate = datePicker.date
            self?.updateDateButton()
        }))
        
        present(alertController, animated: true)
    }
    
    @IBAction func emojiButtonTapped(_ sender: UIButton) {
        // Reset all emoji buttons
        for case let button as UIButton in emojiStackView.arrangedSubviews {
            button.backgroundColor = .systemGray6
            button.layer.borderWidth = 0
        }
        
        // Highlight selected emoji
        sender.backgroundColor = .systemGray5
        sender.layer.borderWidth = 2
        sender.layer.borderColor = UIColor.systemBlue.cgColor
        
        // Store selected mood (1-5)
        selectedMood = sender.tag + 1
    }
    
    @IBAction func energySliderChanged(_ sender: UISlider) {
        energyLevel = sender.value
    }
    
    @IBAction func journalEntryButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "showNewEntry", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showNewEntry" {
            if let newEntryVC = segue.destination as? NewEntryViewController {
                newEntryVC.configure(with: selectedDate, mood: selectedMood, energy: energyLevel, activities: Array(selectedActivities))
            }
        }
    }
}

// MARK: - UICollectionView Extensions
extension DailyLogViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return activityOptions.count + 1 // +1 for "Add" button
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item < activityOptions.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActivityCell", for: indexPath) as! ActivityCell
            let activity = activityOptions[indexPath.item]
            let isSelected = selectedActivities.contains(activity)
            cell.configure(with: activity, isSelected: isSelected)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddActivityCell", for: indexPath) as! AddActivityCell
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item < activityOptions.count {
            // For activity cells, size based on text width
            let activity = activityOptions[indexPath.item]
            let width = activity.size(withAttributes: [.font: UIFont.systemFont(ofSize: 14)]).width + 40
            return CGSize(width: width, height: 36)
        } else {
            // For add button
            return CGSize(width: 36, height: 36)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item < activityOptions.count {
            let activity = activityOptions[indexPath.item]
            
            // Toggle selection
            if selectedActivities.contains(activity) {
                selectedActivities.remove(activity)
            } else {
                selectedActivities.insert(activity)
            }
            
            collectionView.reloadItems(at: [indexPath])
        } else {
            // Handle "Add" button tap - show alert to add new activity
            let alertController = UIAlertController(title: "Add Activity", message: "Enter a new activity", preferredStyle: .alert)
            
            alertController.addTextField { textField in
                textField.placeholder = "Activity name"
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
                if let text = alertController.textFields?.first?.text, !text.isEmpty {
                    // For this example, we'll just show an alert
                    // In a real app, you would add this to your activityOptions array
                    let alert = UIAlertController(title: "Activity Added", message: "Added: \(text)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self?.present(alert, animated: true)
                }
            }
            
            alertController.addAction(cancelAction)
            alertController.addAction(addAction)
            
            present(alertController, animated: true)
        }
    }
}

// MARK: - Custom Cells
class ActivityCell: UICollectionViewCell {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -8)
        ])
        
        layer.cornerRadius = 18
        clipsToBounds = true
    }
    
    func configure(with title: String, isSelected: Bool) {
        titleLabel.text = title
        
        if isSelected {
            backgroundColor = .systemBlue
            titleLabel.textColor = .white
        } else {
            backgroundColor = .systemGray6
            titleLabel.textColor = .label
        }
    }
}

class AddActivityCell: UICollectionViewCell {
    private let plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(plusButton)
        
        NSLayoutConstraint.activate([
            plusButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            plusButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        layer.cornerRadius = 18
        clipsToBounds = true
        backgroundColor = .systemGray6
    }
}
