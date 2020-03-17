//
//  GroupsViewController.swift
//  
//
//  Created by Olivia Corrodi on 12/2/17.
//
//

import UIKit

class GroupsViewController: UIViewController {
    var groups: [[Member]]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    let name: String
    //let dueDate: Date;  Maybe put in later. You will need to modify the
    //initializer groups, Due date, class size, students, avg/total, name, param
    //of the important thing (math/science/creativity/etc)
    var classSize: Int
    var studentsPerGroup: Int
    var averageScore: Float
    var studentsArray: [[Member]]
    var param: [Bool]
    var groups: [[Member]]
    var largerGroups: Int
    var standardDev: Float
    let priorityIndex: Int
    var students: [Member]
    
    init(name: String, classSize: Int, students:[Member], param: [Bool], numGroups: Int) {
        self.name = name
        self.classSize = classSize
        self.students = students
        students.remove(at: 0) //REMOVE THE HARDCODED DINGUS
        self.studentsPerGroup = numGroups
        self.priorityIndex = index(of: true)
        averageScore = Float(calculateAverage())
    }
    
    func calculateAverage() -> Double{
        averageScore = 0
        for student in students {
            averageScore += student.ability[priorityIndex] / students.count
        }
        return Double(averageScore)
    }
    
    func organizeGroups() ->[[Member]] {
        //Create  array of array of null elements
        groups = Array(repeating: [], count: students.count / studentsPerGroup);
        return groups
    }
    func splitArrays(arr: [Member]) -> [[Member]]{
        var stdDev = standardDeviation(arr: arr)
        var studentsArray = [[],[],[]];
        var indexA: Int
        var indexB: Int
        for stud in arr{
            if (stud.ability[priorityIndex] < averageScore-stdDev){
                studentsArray[0].append(stud)
            }
            else if (stud.ability[priorityIndex] > averageScore+stdDev){
                studentsArray[2].append(stud)
            }
            else{
                studentsArray[1].append(stud)
            }
        }
        return studentsArray
    }
    func standardDeviation(arr : [Member]) -> Double{
        let length = Double(arr.count)
        let avg = arr.ability[priorityIndex].reduce(0, {$0 + $1}) / length
        let sumOfSquaredAvgDiff = arr.map { pow($0 - avg, 2.0)}.reduce(0, {$0 + $1})
        return sqrt(sumOfSquaredAvgDiff / length)
    }
    
    func sort() -> [[Member]]{
        var primarySort: [Member]
        index = 0;
        var index2 = 0;
        var groups = organizeGroups();
        var groupScore = 0
        var groupsize = studentsPerGroup
        for index in 0...(groups.count - 1) {
            groupsize = 0
            if (index >= (groups.count - 1 - largerGroups)) { //add one to group if there would be a remainder of students
                groupsize += 1
            }
            //first student
            index = arc4random_uniform(3)
            index2 = arc4random_uniform(students[index].count) //only used for the first student
            group.add(students[index][index2])
            students[index].remove(at: index2)
            //other students
            while groups[index].count < groupsize {
                groupScore = 0
                for student in groups {
                    groupScore += student.ability[priorityIndex]
                }
                if (groupScore > (averageScore+standardDev)*groups[index].count) { // above average and standard deviation
                    index = arc4random_uniform(students[2].count)
                    group.add(students[2][index])
                    students[2].remove(at: index2)
                }
                else if (groupScore < (averageScore-standardDev)*groups[index].count) { // above average and standard deviation
                    index = arc4random_uniform(students[0].count)
                    group.add(students[0][index])
                    students[0].remove(at: index2)
                }
                else { // within standard deviation from average
                    index = arc4random_uniform(students[1].count)
                    group.add(students[1][index])
                    students[1].remove(at: index2)
                }
            }
        }
        self.groups = groups
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
