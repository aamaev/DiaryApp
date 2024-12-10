//
//  AddTaskViewController.swift
//  Diary
//
//  Created by Артём Амаев on 06.12.2024.
//

import UIKit
import SnapKit

class AddTaskViewController: UIViewController {

    weak var delegate: MainViewController?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "New Task ToDo"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var taskNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Title Task"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private lazy var taskNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Add Task Name.."
        textField.borderStyle = .none
        textField.backgroundColor = UIColor.lightGray1
        textField.layer.cornerRadius = 12
        textField.textColor = .black
        textField.attributedPlaceholder = NSAttributedString(
            string: "Add Task Name..",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black,
                         NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .medium)]
        )
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(15, 0, 0)
        return textField
    }()

    private lazy var taskDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Description"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private lazy var taskDescriptionTextView: UITextView = {
        let textView = UITextView()
        textView.layer.borderWidth = 0
        textView.layer.cornerRadius = 12
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.backgroundColor = UIColor.lightGray1
        textView.textContainerInset = UIEdgeInsets(top: 15, left: 10, bottom: 12, right: 10)
        textView.text = "Add Description.."
        textView.textColor = .black
        textView.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return textView
    }()

    private lazy var startTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "Start Time"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private lazy var startTimePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        datePicker.minimumDate = Date()
        return datePicker
    }()
    
    private lazy var endTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "End Time"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private lazy var endTimePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        datePicker.minimumDate = Date()
        return datePicker
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSAttributedString(
            string: "Cancel",
            attributes: [
                .font: UIFont.systemFont(ofSize: 16, weight: .bold),
                .foregroundColor: UIColor.systemBlue
            ]
        )
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.backgroundColor = UIColor(named: "backgroundColor")
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 8
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var createButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSAttributedString(
            string: "Create",
            attributes: [
                .font: UIFont.systemFont(ofSize: 16, weight: .bold),
                .foregroundColor: UIColor.white
            ]
        )
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(saveTask), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewController()
        setupUI()
    }
    
    private func setupViewController() {
        view.backgroundColor = UIColor(named: "backgroundColor")
    }
    
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(taskNameLabel)
        view.addSubview(taskNameTextField)
        view.addSubview(taskDescriptionLabel)
        view.addSubview(taskDescriptionTextView)
        view.addSubview(startTimeLabel)
        view.addSubview(startTimePicker)
        view.addSubview(endTimeLabel)
        view.addSubview(endTimePicker)
        view.addSubview(cancelButton)
        view.addSubview(createButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview().inset(20)
        }
        
        taskNameLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        taskNameTextField.snp.makeConstraints { make in
            make.top.equalTo(taskNameLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        taskDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(taskNameTextField.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        taskDescriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(taskDescriptionLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(100)
        }
        
        startTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(taskDescriptionTextView.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
        }
        
        startTimePicker.snp.makeConstraints { make in
            make.top.equalTo(startTimeLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().inset(20)
        }
        
        endTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(startTimePicker.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
        }
        
        endTimePicker.snp.makeConstraints { make in
            make.top.equalTo(endTimeLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().inset(20)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(endTimePicker.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(50)
            make.width.equalTo(view.frame.width / 2 - 30)
        }
        
        createButton.snp.makeConstraints { make in
            make.top.equalTo(endTimePicker.snp.bottom).offset(30)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(50)
            make.width.equalTo(view.frame.width / 2 - 30)
        }
    }
    
    @objc private func cancelAction() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func saveTask() {
        guard let name = taskNameTextField.text, !name.isEmpty else {
            showAlert(title: "Error", message: "Please enter a task name.")
            return
        }
        
        guard !taskDescriptionTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            showAlert(title: "Error", message: "Please enter a task description.")
            return
        }
        
        let startDate = startTimePicker.date
        let endDate = endTimePicker.date
        
        guard endDate > startDate else {
            showAlert(title: "Error", message: "End time must be after start time.")
            return
        }
        
        let task = Task(
            id: Int(Date().timeIntervalSince1970),
            dateStart: Int(startDate.timeIntervalSince1970),
            dateFinish: Int(endDate.timeIntervalSince1970),
            name: name,
            descriptionText: taskDescriptionTextView.text
        )
        
        TaskService().saveTask(task)
        delegate?.updateTasks()
        
        showAlert(
            title: "Success",
            message: "Task successfully created!",
            completion: { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            }
        )
    }

    private func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?()
        }))
        present(alert, animated: true)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}





