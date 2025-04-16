//
//  InsightsViewController.swift
//  TheMoodJournal
//
//  Created by Xia Mey Lee on 4/9/25.



import UIKit

class InsightsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    private let weekdayLabels = ["M", "T", "W", "T", "F", "S", "S"]
    private var weeklyMoodData = [4.0, 3.5, 5.0, 2.0, 4.5, 4.0, 3.0] // Example data (1-5 scale)
    
    // Monthly calendar data - using 0 (no data), 1 (poor) to 5 (excellent)
    private var monthlyMoodData = Array(repeating: 0, count: 31) // Will be filled with actual data
    
    // MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Insights"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let weeklyMoodLabel: UILabel = {
        let label = UILabel()
        label.text = "Weekly Mood"
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let barChartView: SimpleBarChartView = {
        let chartView = SimpleBarChartView()
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.backgroundColor = .systemBackground
        return chartView
    }()
    
    private let monthlyOverviewLabel: UILabel = {
        let label = UILabel()
        label.text = "Monthly Overview"
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var calendarCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 2
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CalendarCell.self, forCellWithReuseIdentifier: "CalendarCell")
        return collectionView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        loadMoodData()
        setupBarChart()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(titleLabel)
        view.addSubview(weeklyMoodLabel)
        view.addSubview(barChartView)
        view.addSubview(monthlyOverviewLabel)
        view.addSubview(calendarCollectionView)
        
        NSLayoutConstraint.activate([
            // Title Label
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            // Weekly Mood Label
            weeklyMoodLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            weeklyMoodLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            // Bar Chart View
            barChartView.topAnchor.constraint(equalTo: weeklyMoodLabel.bottomAnchor, constant: 8),
            barChartView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            barChartView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            barChartView.heightAnchor.constraint(equalToConstant: 200),
            
            // Monthly Overview Label
            monthlyOverviewLabel.topAnchor.constraint(equalTo: barChartView.bottomAnchor, constant: 24),
            monthlyOverviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            // Calendar Collection View
            calendarCollectionView.topAnchor.constraint(equalTo: monthlyOverviewLabel.bottomAnchor, constant: 8),
            calendarCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            calendarCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            calendarCollectionView.heightAnchor.constraint(equalToConstant: 300)  // Increased from 200
        ])
    }
    
    // MARK: - Data Loading
    private func loadMoodData() {
        // Dummy data for example - in a real app this would come from a database
        weeklyMoodData = [4.0, 3.5, 5.0, 2.0, 4.5, 4.0, 3.0]
        
        // Generate random mood data for the month (31 days)
        monthlyMoodData = (0..<31).map { _ in
            Int.random(in: 1...5)  // Generate values 1-5 (no empty cells)
        }
    }
    
    // MARK: - Charts Setup
    private func setupBarChart() {
        barChartView.configure(with: weeklyMoodData, labels: weekdayLabels)
    }
    
    // MARK: - Helper Methods
    private func getMoodColor(for value: Double) -> UIColor {
        switch value {
        case 0..<1:
            return .systemGray4 // No data
        case 1..<2:
            return .systemRed // Very bad mood
        case 2..<3:
            return .systemOrange // Poor mood
        case 3..<4:
            return .systemYellow // Neutral mood
        case 4..<5:
            return .systemGreen // Good mood
        case 5...:
            return .systemTeal // Excellent mood
        default:
            return .systemGray4
        }
    }
    
    // MARK: - UICollectionView DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return monthlyMoodData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
        
        let moodValue = monthlyMoodData[indexPath.item]
        cell.configure(day: indexPath.item + 1, moodValue: moodValue)
        
        return cell
    }
    
    // MARK: - UICollectionView Delegate Flow Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 12) / 7  // 7 columns with spacing
        return CGSize(width: width - 2, height: width - 2)  // Square cells with a bit of margin
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
    }
}

// MARK: - Simple Bar Chart View
class SimpleBarChartView: UIView {
    private var values: [Double] = []
    private var labels: [String] = []
    
    func configure(with values: [Double], labels: [String]) {
        self.values = values
        self.labels = labels
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext(), !values.isEmpty else { return }
        
        let maxValue = values.max() ?? 5.0
        let width = rect.width / CGFloat(values.count)
        let scaleFactor = rect.height * 0.8 / CGFloat(maxValue) // 80% of height for bars
        
        // Draw horizontal lines (grid)
        let gridColor = UIColor.systemGray5.cgColor
        context.setStrokeColor(gridColor)
        context.setLineWidth(0.5)
        
        for i in 0...5 {
            let y = rect.height - CGFloat(i) * (rect.height * 0.8 / 5.0) - rect.height * 0.1
            context.move(to: CGPoint(x: 0, y: y))
            context.addLine(to: CGPoint(x: rect.width, y: y))
            context.strokePath()
        }
        
        // Draw bars
        for (index, value) in values.enumerated() {
            let barHeight = CGFloat(value) * scaleFactor
            let barRect = CGRect(
                x: CGFloat(index) * width + width * 0.1,
                y: rect.height - barHeight - rect.height * 0.1, // 10% padding at bottom
                width: width * 0.8,
                height: barHeight
            )
            
            // Choose color based on value
            let color = getMoodColor(for: value)
            context.setFillColor(color.cgColor)
            
            // Create rounded rectangle for bar
            let radius: CGFloat = 4.0
            let path = UIBezierPath(roundedRect: barRect, cornerRadius: radius)
            context.addPath(path.cgPath)
            context.fillPath()
            
            // Draw label if available
            if index < labels.count {
                let label = labels[index]
                let attributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont.systemFont(ofSize: 12),
                    .foregroundColor: UIColor.darkGray
                ]
                
                let labelSize = (label as NSString).size(withAttributes: attributes)
                let labelRect = CGRect(
                    x: CGFloat(index) * width + (width - labelSize.width) / 2,
                    y: rect.height - 15,
                    width: labelSize.width,
                    height: labelSize.height
                )
                
                (label as NSString).draw(in: labelRect, withAttributes: attributes)
            }
        }
    }
    
    private func getMoodColor(for value: Double) -> UIColor {
        switch value {
        case 0..<1:
            return .systemGray4 // No data
        case 1..<2:
            return .systemRed // Very bad mood
        case 2..<3:
            return .systemOrange // Poor mood
        case 3..<4:
            return .systemYellow // Neutral mood
        case 4..<5:
            return .systemGreen // Good mood
        case 5...:
            return .systemTeal // Excellent mood
        default:
            return .systemGray4
        }
    }
}

// MARK: - Calendar Cell
class CalendarCell: UICollectionViewCell {
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)  // Slightly larger font
        label.textColor = .darkGray
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
        layer.cornerRadius = 4
        contentView.addSubview(dayLabel)
        
        NSLayoutConstraint.activate([
            dayLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            dayLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(day: Int, moodValue: Int) {
        dayLabel.text = "\(day)"
        
        // Set background color based on mood
        switch moodValue {
        case 0:
            backgroundColor = .systemGray5 // No data
            dayLabel.textColor = .darkGray
        case 1:
            backgroundColor = .systemRed.withAlphaComponent(0.7)
            dayLabel.textColor = .white
        case 2:
            backgroundColor = .systemOrange.withAlphaComponent(0.7)
            dayLabel.textColor = .white
        case 3:
            backgroundColor = .systemYellow.withAlphaComponent(0.7)
            dayLabel.textColor = .darkGray
        case 4:
            backgroundColor = .systemGreen.withAlphaComponent(0.7)
            dayLabel.textColor = .white
        case 5:
            backgroundColor = .systemTeal.withAlphaComponent(0.7)
            dayLabel.textColor = .white
        default:
            backgroundColor = .systemGray5
        }
    }
}
