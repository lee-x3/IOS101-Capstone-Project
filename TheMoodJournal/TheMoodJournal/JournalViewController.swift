//
//  JournalViewController.swift
//  TheMoodJournal
//
//  Created by Xia Mey Lee on 4/8/25.
//


import UIKit

// Enhanced Journal Entry struct to include mood value
struct JournalEntrySimple {
    let date: Date
    let mood: JournalMood
    let activities: [String]
    let journalText: String
}

// Mood enum to match the color coding from InsightsViewController
enum JournalMood: Int {
    case noMood = 0
    case veryPoor = 1
    case poor = 2
    case neutral = 3
    case good = 4
    case excellent = 5
    
    var emoji: String {
        switch self {
        case .noMood: return "❓"
        case .veryPoor: return "😞"
        case .good: return "😊"
        case .neutral: return "😒"
        case .poor: return "😡"
        case .excellent: return "😭"
        }
    }
    
    var color: UIColor {
        switch self {
        case .noMood:
            return .systemGray5
        case .veryPoor:
            return .systemRed.withAlphaComponent(0.7)
        case .poor:
            return .systemOrange.withAlphaComponent(0.7)
        case .neutral:
            return .systemYellow.withAlphaComponent(0.7)
        case .good:
            return .systemGreen.withAlphaComponent(0.7)
        case .excellent:
            return .systemTeal.withAlphaComponent(0.7)
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .noMood, .neutral:
            return .darkGray
        default:
            return .white
        }
    }
}

class JournalViewController: UIViewController {
    
    // TableView created programmatically - no outlet needed
    private var tableView: UITableView!
    
    // Expanded mock journal entries with mood values
    private var journalEntries: [JournalEntrySimple] = [
        JournalEntrySimple(
            date: Date(), // Today
            mood: .good,
            activities: ["Work", "Exercise"],
            journalText: "Had a productive day at work. My morning run was refreshing and gave me energy for the day. Completed all my tasks ahead of schedule and felt really accomplished."
        ),
        JournalEntrySimple(
            date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, // Yesterday
            mood: .poor,
            activities: ["Social", "Stress"],
            journalText: "Feeling tired, didn't sleep well last night. Had coffee with friends which helped a bit. Work was challenging and I'm feeling a bit overwhelmed with recent projects."
        ),
        JournalEntrySimple(
            date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!, // 2 days ago
            mood: .good,
            activities: ["Family", "Hobby"],
            journalText: "Spent time with family and worked on my painting. It was a relaxing day overall. Had a wonderful dinner with my parents and shared lots of laughs."
        ),
        JournalEntrySimple(
            date: Calendar.current.date(byAdding: .day, value: -5, to: Date())!, // 5 days ago
            mood: .neutral,
            activities: ["Study", "Rest"],
            journalText: "Studied for a few hours then took some time to rest. Just an average day. Nothing spectacular happened, but nothing terrible either."
        ),
        // Additional entries to ensure scrollability
        JournalEntrySimple(
            date: Calendar.current.date(byAdding: .day, value: -7, to: Date())!,
            mood: .veryPoor,
            activities: ["Health", "Emotional"],
            journalText: "Struggling with some personal challenges. Feeling low and finding it hard to stay motivated. Need to focus on self-care and seek support from friends and family."
        ),
        JournalEntrySimple(
            date: Calendar.current.date(byAdding: .day, value: -10, to: Date())!,
            mood: .good,
            activities: ["Travel", "Adventure"],
            journalText: "Went on a short weekend trip. The change of scenery was exactly what I needed. Explored new hiking trails and tried some local cuisine. Feeling refreshed and inspired."
        ),
        JournalEntrySimple(
            date: Calendar.current.date(byAdding: .day, value: -14, to: Date())!,
            mood: .neutral,
            activities: ["Work", "Learning"],
            journalText: "Started a new online course. It's challenging but interesting. Work has been steady, nothing too exciting but also not stressful."
        ),
        JournalEntrySimple(
            date: Calendar.current.date(byAdding: .day, value: -20, to: Date())!,
            mood: .good,
            activities: ["Personal Growth", "Celebration"],
            journalText: "Achieved a major personal goal today! Months of hard work finally paid off. Celebrated with close friends and felt an incredible sense of accomplishment."
        ),
        JournalEntrySimple(
            date: Calendar.current.date(byAdding: .day, value: -25, to: Date())!,
            mood: .poor,
            activities: ["Setback", "Reflection"],
            journalText: "Faced a significant setback in my professional life. It's been tough to process, but I'm trying to view this as a learning opportunity and stay positive."
        )
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupUI()
        
        // Add observer for new journal entries
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(newEntryAdded(_:)),
            name: NSNotification.Name("NewJournalEntryAdded"),
            object: nil
        )
    }
    
    deinit {
        // Remove observer when view controller is deallocated
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    private func setupTableView() {
        // Create tableView programmatically
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(tableView)
        
        // Debug colors
        view.backgroundColor = .systemBackground
        tableView.backgroundColor = .systemBackground
        
        // Register custom cell
        tableView.register(JournalCustomCell.self, forCellReuseIdentifier: "JournalCell")
        
        // Setup delegate and dataSource
        tableView.delegate = self
        tableView.dataSource = self
        
        // Remove separators
        tableView.separatorStyle = .none
        
        // Enable scrolling
        tableView.alwaysBounceVertical = true
        
        // Force reload
        tableView.reloadData()
    }
    
    private func setupUI() {
        title = "Journal"
        
        // Add a search bar (optional)
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search entries..."
        searchBar.sizeToFit()
        tableView.tableHeaderView = searchBar
        
        // Add new entry button in the navigation bar
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .compose,
            target: self,
            action: #selector(addNewEntry)
        )
        navigationItem.rightBarButtonItem = addButton
        
        // Tab bar setup
        self.tabBarItem = UITabBarItem(title: "Journal", image: UIImage(systemName: "book"), tag: 2)
    }
    
    // MARK: - Actions
    
    @objc private func addNewEntry() {
        // Navigate to DailyLogViewController
        if let dailyLogVC = storyboard?.instantiateViewController(identifier: "DailyLogViewController") as? DailyLogViewController {
            navigationController?.pushViewController(dailyLogVC, animated: true)
        }
    }
    
    @objc private func newEntryAdded(_ notification: Notification) {
        // Check if the notification object is a JournalEntrySimple
        if let newEntry = notification.object as? JournalEntrySimple {
            // Add the new entry to the beginning of the array (most recent first)
            journalEntries.insert(newEntry, at: 0)
            
            // Reload the table view
            tableView.reloadData()
            
            // Scroll to the top to show the new entry
            if !journalEntries.isEmpty {
                tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }
        }
    }
    
    // MARK: - Detail View
    
    private func showDetailView(for entry: JournalEntrySimple) {
        let detailVC = JournalEntryDetailViewController()
        detailVC.configure(with: entry)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// Custom Cell for Mood-Coded Journal Entries
class JournalCustomCell: UITableViewCell {
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.1
        return view
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    private let summaryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 3
        return label
    }()
    
    private let activitiesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .darkGray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // Remove default background
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        // Add container view
        contentView.addSubview(containerView)
        containerView.addSubview(dateLabel)
        containerView.addSubview(activitiesLabel)
        containerView.addSubview(summaryLabel)
        
        NSLayoutConstraint.activate([
            // Container View
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            // Date Label
            dateLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            dateLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            dateLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            // Activities Label
            activitiesLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 4),
            activitiesLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            activitiesLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            // Summary Label
            summaryLabel.topAnchor.constraint(equalTo: activitiesLabel.bottomAnchor, constant: 8),
            summaryLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            summaryLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            summaryLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12)
        ])
    }
    
    func configure(with entry: JournalEntrySimple) {
        // Format date
        let dateFormatter = DateFormatter()
        let formattedDate: String
        
        if Calendar.current.isDateInToday(entry.date) {
            formattedDate = "Today"
        } else if Calendar.current.isDateInYesterday(entry.date) {
            formattedDate = "Yesterday"
        } else {
            dateFormatter.dateFormat = "MMM d, yyyy"
            formattedDate = dateFormatter.string(from: entry.date)
        }
        
        // Set content
        dateLabel.text = "\(entry.mood.emoji) \(formattedDate)"
        
        // Format activities
        if !entry.activities.isEmpty {
            activitiesLabel.text = entry.activities.joined(separator: ", ")
        } else {
            activitiesLabel.text = "No activities"
        }
        
        // Format text summary (truncate if too long)
        if entry.journalText.count > 200 {
            summaryLabel.text = entry.journalText.prefix(200) + "..."
        } else {
            summaryLabel.text = entry.journalText
        }
        
        // Color coding
        containerView.backgroundColor = entry.mood.color
        dateLabel.textColor = entry.mood.textColor
        activitiesLabel.textColor = entry.mood.textColor
        summaryLabel.textColor = entry.mood.textColor
    }
}

// MARK: - UITableView Extensions
extension JournalViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return journalEntries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JournalCell", for: indexPath) as! JournalCustomCell
        let entry = journalEntries[indexPath.row]
        
        cell.configure(with: entry)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Show the detail view for the selected entry
        let entry = journalEntries[indexPath.row]
        showDetailView(for: entry)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160 // Increased height to accommodate more text
    }
}

// MARK: - Detail View Controller
class JournalEntryDetailViewController: UIViewController {
    
    private var entry: JournalEntrySimple!
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private let moodEmojiLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 40)
        return label
    }()
    
    private let activitiesView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let activitiesTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Activities"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private let activitiesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 8
        stackView.alignment = .center
        //stackView.flexWrap = .wrap
        return stackView
    }()
    
    private let journalTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.isEditable = false
        textView.backgroundColor = .clear
        textView.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        textView.layer.cornerRadius = 8
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.systemGray4.cgColor
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        displayEntryData()
    }
    
    func configure(with entry: JournalEntrySimple) {
        self.entry = entry
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Journal Entry"
        
        // Add scroll view and content view
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Add subviews to content view
        contentView.addSubview(dateLabel)
        contentView.addSubview(moodEmojiLabel)
        contentView.addSubview(activitiesView)
        contentView.addSubview(journalTextView)
        
        // Add subviews to activities view
        activitiesView.addSubview(activitiesTitleLabel)
        activitiesView.addSubview(activitiesStackView)
        
        // Setup constraints
        NSLayoutConstraint.activate([
            // Scroll view
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Content view
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Date label
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Mood emoji label
            moodEmojiLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 12),
            moodEmojiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            // Activities view
            activitiesView.topAnchor.constraint(equalTo: moodEmojiLabel.bottomAnchor, constant: 20),
            activitiesView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            activitiesView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Activities title label
            activitiesTitleLabel.topAnchor.constraint(equalTo: activitiesView.topAnchor, constant: 12),
            activitiesTitleLabel.leadingAnchor.constraint(equalTo: activitiesView.leadingAnchor, constant: 16),
            
            // Activities stack view
            activitiesStackView.topAnchor.constraint(equalTo: activitiesTitleLabel.bottomAnchor, constant: 8),
            activitiesStackView.leadingAnchor.constraint(equalTo: activitiesView.leadingAnchor, constant: 16),
            activitiesStackView.trailingAnchor.constraint(equalTo: activitiesView.trailingAnchor, constant: -16),
            activitiesStackView.bottomAnchor.constraint(equalTo: activitiesView.bottomAnchor, constant: -12),
            
            // Journal text view
            journalTextView.topAnchor.constraint(equalTo: activitiesView.bottomAnchor, constant: 20),
            journalTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            journalTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            journalTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 200),
            journalTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    private func displayEntryData() {
        guard let entry = entry else { return }
        
        // Format date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateLabel.text = dateFormatter.string(from: entry.date)
        
        // Set mood emoji
        moodEmojiLabel.text = entry.mood.emoji
        
        // Display activities
        for activity in entry.activities {
            let activityLabel = createActivityLabel(with: activity)
            activitiesStackView.addArrangedSubview(activityLabel)
        }
        
        // If no activities, show a message
        if entry.activities.isEmpty {
            let noActivitiesLabel = UILabel()
            noActivitiesLabel.text = "No activities recorded"
            noActivitiesLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            noActivitiesLabel.textColor = .systemGray
            activitiesStackView.addArrangedSubview(noActivitiesLabel)
        }
        
        // Set journal text
        journalTextView.text = entry.journalText
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
        
        // Apply padding
        let paddingInsets = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
        let size = text.size(withAttributes: [.font: UIFont.systemFont(ofSize: 14)])
        label.frame.size = CGSize(
            width: size.width + paddingInsets.left + paddingInsets.right,
            height: size.height + paddingInsets.top + paddingInsets.bottom
        )
        
        return label
    }
}

// Extension to make UIStackView wrap its content
extension UIStackView {
    var flexWrap: Bool {
        get {
            return false
        }
        set {
            if newValue {
                self.alignment = .leading
            }
        }
    }
}
