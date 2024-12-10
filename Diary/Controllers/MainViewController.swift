//
//  MainViewController.swift
//  Diary
//
//  Created by Артём Амаев on 05.12.2024.
//

import UIKit


class MainViewController: UIViewController {
    
    @IBOutlet weak var weekCollectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navigateTitle: UINavigationItem!
    
    var tasks: [Task] = []
    var selectedDate: Int?
    private let taskService = TaskService()
    private var selectedIndexPath: IndexPath?
    private var cells: [CellType] = []
    private var lastDate: Date?
    private var days: [(String, String, Int)] = []
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    private lazy var emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "Select a day to view tasks"
        label.textColor = .lightGray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.isHidden = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateWeekDays()
        updateTasks()
        
        setupCollectionView()
        setupTableView()
        setupEmptyStateLabel()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        navigateTitle.title = formattedDate()
    }
    
    private func setupCollectionView() {
        weekCollectionView.register(UINib(nibName: "WeekCell", bundle: nil), forCellWithReuseIdentifier: "WeekCell")
        weekCollectionView.dataSource = self
        weekCollectionView.delegate = self
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: "TimeCell", bundle: nil), forCellReuseIdentifier: "TimeCell")
        tableView.register(UINib(nibName: "TaskCell", bundle: nil), forCellReuseIdentifier: "TaskCell")
    }
    
    private func setupEmptyStateLabel() {
        view.addSubview(emptyStateLabel)
        
        emptyStateLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(tableView.snp.centerY)
        }
    }
    
    private func generateWeekDays() {
        let calendar = Calendar.current
        let startOfNextWeek = lastDate ?? calendar.startOfDay(for: Date())

        let nextWeekDays = (0..<7).compactMap { offset -> (String, String, Int)? in
            guard let day = calendar.date(byAdding: .day, value: offset, to: startOfNextWeek) else { return nil }
            
            dateFormatter.dateFormat = "E"
            let dayName = dateFormatter.string(from: day)
            
            dateFormatter.dateFormat = "dd"
            let dayNumber = dateFormatter.string(from: day)
            
            return (dayName, dayNumber, Int(day.timeIntervalSince1970))
        }
        
        days += nextWeekDays
        lastDate = calendar.date(byAdding: .day, value: 7, to: startOfNextWeek)
        weekCollectionView.reloadData()
    }


    func updateTasks() {
        guard let selectedDate = self.selectedDate else {
            tasks = []
            tableView.reloadData()
            return
        }

        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date(timeIntervalSince1970: TimeInterval(selectedDate)))

        tasks = taskService.tasks(for: startOfDay)

        let startingTime: Date
        if let firstTask = tasks.min(by: { $0.dateStart < $1.dateStart }) {
            let initialTime = calendar.date(byAdding: .hour, value: -1, to: Date(timeIntervalSince1970: TimeInterval(firstTask.dateStart))) ?? startOfDay
            startingTime = calendar.date(bySettingHour: calendar.component(.hour, from: initialTime), minute: 0, second: 0, of: initialTime) ?? startOfDay
        } else {
            let currentTime = Date()
            let initialTime = calendar.date(byAdding: .hour, value: -1, to: currentTime) ?? startOfDay
            startingTime = calendar.date(bySettingHour: calendar.component(.hour, from: initialTime), minute: 0, second: 0, of: initialTime) ?? startOfDay
        }

        let timeSlots = (0..<24).compactMap {
            calendar.date(byAdding: .hour, value: $0, to: startingTime)
        }

        cells = []

        for (_, slotStart) in timeSlots.enumerated() {
            let slotEnd = calendar.date(byAdding: .hour, value: 1, to: slotStart)!

            let tasksInSlot = tasks.filter { task in
                let taskStartDate = Date(timeIntervalSince1970: TimeInterval(task.dateStart))
                return taskStartDate >= slotStart && taskStartDate < slotEnd
            }

            if tasksInSlot.isEmpty {
                let timeFormatter = DateFormatter()
                timeFormatter.dateFormat = "HH:mm"
                let slotTime = "\(timeFormatter.string(from: slotStart))"
                cells.append(.time(slotTime))
            }
            
            for task in tasksInSlot {
                if !cells.contains(where: {
                    if case .task(let existingTask) = $0 {
                        return existingTask.id == task.id
                    }
                    return false
                }) {
                    cells.append(.task(task))
                }
            }
        }

        tableView.reloadData()
    }


    private func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter.string(from: Date())
    }
    
    @IBAction func addTask(_ sender: Any) {
        let addTaskVC = AddTaskViewController()
        addTaskVC.delegate = self
        let navController = UINavigationController(rootViewController: addTaskVC)
        present(navController, animated: true, completion: nil)
    }
    
    private func updateEmptyState() {
        emptyStateLabel.isHidden = true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == weekCollectionView else { return }
        
        let offsetX = scrollView.contentOffset.x
        let contentWidth = scrollView.contentSize.width
        let frameWidth = scrollView.frame.size.width
        
        if offsetX + frameWidth >= contentWidth - 10 {
            generateWeekDays()
        }
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return days.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeekCell", for: indexPath) as! WeekCell
        let day = days[indexPath.row]
        let isSelected = indexPath == selectedIndexPath
        cell.configure(dayName: day.0, dayNumber: day.1, isSelected: isSelected)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let day = days[indexPath.row]
        selectedDate = day.2
        updateTasks()
        updateEmptyState()
        
        if let previousIndexPath = selectedIndexPath, let previousCell = collectionView.cellForItem(at: previousIndexPath) as? WeekCell {
            previousCell.animateSelection(selected: false)
        }
        
        if let currentCell = collectionView.cellForItem(at: indexPath) as? WeekCell {
            currentCell.animateSelection(selected: true)
        }
        
        selectedIndexPath = indexPath
    }
}


// MARK: - UITableViewDataSource, UITableViewDelegate

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func navigateToDetail(task: Task) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailedTaskViewController") as? DetailedTaskViewController {
            detailVC.task = task
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellType = cells[indexPath.row]
        if case .time = cellType {
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }

        if case .task(let task) = cellType {
            navigateToDetail(task: task)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = cells[indexPath.row]
        switch cellType {
        case .time(let timeText):
            let cell = tableView.dequeueReusableCell(withIdentifier: "TimeCell", for: indexPath) as! TimeCell
            cell.configure(with: timeText)
            return cell
        case .task(let task):
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
            cell.configure(with: task)
            return cell
        }
    }
}











