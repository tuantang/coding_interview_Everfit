//
//  CTHomeViewModel.swift
//  CodingTest
//
//  Created by Tang Tuan on 8/7/20.
//  Copyright © 2020 Tang Tuan. All rights reserved.
//

import RxSwift
import RxCocoa
import RxRelay

protocol CTHomeViewModelInputs {
    func refresh()
    var loadPageTrigger: PublishSubject<Void> { get }
}

protocol CTHomeViewModelOutputs {
    var isLoading: Driver<Bool> { get }
    var elements: BehaviorRelay<[CTWorkout]> { get }
}

protocol CTHomeViewModelType {
    var inputs: CTHomeViewModelInputs { get  }
    var outputs: CTHomeViewModelOutputs { get }
}

@available(iOS 13.0, *)
class CTHomeViewModel: CTHomeViewModelInputs, CTHomeViewModelOutputs, CTHomeViewModelType {
    
    var pageIndex: Int = 1
    private let disposeBag = DisposeBag()
    let error = PublishSubject<Swift.Error>()
    
    var isLoading: Driver<Bool>
    var elements: BehaviorRelay<[CTWorkout]>
    
    var loadPageTrigger: PublishSubject<Void>
    
    var inputs: CTHomeViewModelInputs { return self }
    var outputs: CTHomeViewModelOutputs { return self }
    
    init() {
        
        let Loading = CTActivityIndicator()
        self.isLoading = Loading.asDriver()
        
        self.loadPageTrigger = PublishSubject<Void>()
        
        
        let getWorkouts = { (daysOfWeek: [Date]) -> [CTWorkout] in
            var workouts: [CTWorkout] = []
            daysOfWeek.forEach { workouts.append(CTWorkout(date: $0)) }
            return workouts
        }
        self.elements = BehaviorRelay<[CTWorkout]>(value: getWorkouts(Date().daysOfWeek))
        
        let loadRequest = self.isLoading.asObservable()
            .sample(self.loadPageTrigger)
            .flatMap { isLoading -> Observable<[CTWorkout]> in
                if isLoading {
                    return Observable.empty()
                } else {
                    return CTAPI.shared.fetchWorkouts()
                        .trackActivity(Loading)
                }
        }
        
        let request = Observable.of(loadRequest)
            .merge()
            .share(replay: 1)

        Observable
            .combineLatest(request, elements.asObservable()) { request, elements in
                return request
            }
            .sample(request)
            .bind(to: elements)
            .disposed(by: disposeBag)
        
//        self.saveCoreData()
    }
    
    func refresh() {
        self.loadPageTrigger
        .onNext(())
    }
    
    func saveCoreData() {
        self.elements.asObservable().subscribe(onNext: { [weak self] workouts in
            guard let _ = self else { return }
            workouts.forEach { workout in
                guard let id = workout.id,
                    let day = workout.day else { return }
                let workoutMO = WorkoutMO.insertNewWorkOut(id: id, day: Int16(day))
                var assignmentsMO = Set<AssignmentMO>()
                if let assignments = workout.assignments, assignments.count > 0 {
                    assignments.forEach { assignment in
                        guard let id = assignment.id,
                            let title = assignment.title,
                            let stauts = assignment.status,
                            let totalExercise = assignment.totalExercise else { return }
                        let assignmentMO = AssignmentMO.insertNewAssignment(id: id, title: title, status: Int16(stauts.rawValue), totalExercise: Int16(totalExercise))
                        assignmentMO?.workout = workoutMO
                        assignmentsMO.insert(assignmentMO!)
                    }
                    workoutMO?.addToAssignments(assignmentsMO as NSSet)
                }
            }
        }).disposed(by: disposeBag)
    }

}

