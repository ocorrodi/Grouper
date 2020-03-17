//
//  GroupsTableViewController.swift
//  Grouper
//
//  Created by Olivia Corrodi on 12/2/17.
//  Copyright © 2017 Olivia Corrodi. All rights reserved.
//

import UIKit

class GroupsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
/*
 override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "groupCell")
        let index = indexPath
        let row = indexPath.row
        groups = sort()
        let individualCell = groups[indexPath][row]
 
        
    }*/

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }
    var name: String = ""
    //let dueDate: Date;  Maybe put in later. You will need to modify the
    //initializer groups, Due date, class size, students, avg/total, name, param
    //of the important thing (math/science/creativity/etc)
    var classSize: Int = 0
    var studentsPerGroup: Int = 0
    var averageScore: Float = 0
    var students: [Member] = []
    var studentsArray: [[Member]] = [[]]
    var param: [Bool] = []
    var groups: [[Member]] = [[]]
    var largerGroups: Int = 0
    var standardDev: Float = 0
    var priorityIndex: Int = 0
    /*
    init(name: String, classSize: Int, students: [Member], param: [Bool], numGroups: Int) {
        super.init()
        self.name = name
        self.classSize = classSize
        self.students = students
        // students.remove(at: 0) //REMOVE THE HARDCODED DINGUS
        self.studentsPerGroup = numGroups
        self.priorityIndex = param.index(of: true)!
        // self.averageScore = averageScore
    }
 
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
*/
    
    func calculateAverage() -> Double{
        averageScore = 0
        for student in students {
            averageScore += student.ability[priorityIndex] / Float(students.count)
        }
        return Double(averageScore)
    }
    
    func organizeGroups() ->[[Member]] {
        //Create  array of array of null elements
        groups = Array(repeating: [], count: students.count / studentsPerGroup)
        return groups
    }
    func splitArrays(arr:[Member]) -> [[Member]]{
        var newArr : [Double] = []
        for mem in arr {
            newArr.append(Double(mem.ability[priorityIndex]))
        }
        var stdDev = standardDeviation(arr: newArr)
        var studentsArray = [[],[],[]]
        var indexA: Int
        var indexB: Int
        for stud in arr{
            if (stud.ability[priorityIndex] < averageScore-Float(stdDev)){
                studentsArray[0].append(stud)
            }
            else if (stud.ability[priorityIndex] > averageScore+Float(stdDev)){
                studentsArray[2].append(stud)
            }
            else{
                studentsArray[1].append(stud)
            }
        }
        return studentsArray as! [[Member]]
    }
    func standardDeviation(arr : [Double]) -> Double{
        let length = Double(arr.count)
        let avg = arr.reduce(0, {$0 + $1}) / length
        let sumOfSquaredAvgDiff = arr.map { pow($0 - avg, 2.0)}.reduce(0, {$0 + $1})
        return sqrt(sumOfSquaredAvgDiff / length)
    }
    
    func sort() -> [[Member]]{
        averageScore = Float(calculateAverage())
        var primarySort: [Member]
        var index = arc4random_uniform(3)
        var studentsArray = splitArrays(arr: students)
        var index2 = 0
        // var groups = organizeGroups()
        var groupScore: Float = 0.0
        var groupsize = studentsPerGroup
        for index in 0...(groups.count - 1) {
            groupsize = 0
            if (index >= (groups.count - 1 - largerGroups)) { //add one to group if there would be a remainder of students
                groupsize += 1
            }
            //first student
            index2 = Int(arc4random_uniform(UInt32(studentsArray[index].count))) //only used for the first student
            groups[index].append(studentsArray[index][index2])
            studentsArray[index].remove(at: index2)
            //other students
            while groups[index].count < groupsize {
                groupScore = 0
                for student in groups[index] {
                    groupScore += student.ability[priorityIndex]
                }
                if (groupScore > (averageScore+standardDev)*Float(groups[index].count)) { // above average and standard deviation
                    var index4 = Int(arc4random_uniform(UInt32(studentsArray[2].count)))
                    groups[index].append(studentsArray[2][index4])
                    studentsArray[2].remove(at: index2)
                }
                else if (groupScore < (averageScore-standardDev)*Float(groups[index].count)) { // above average and standard deviation
                    var index3 = Int(arc4random_uniform(UInt32(studentsArray[0].count)))
                    groups[index].append(studentsArray[0][index])
                    studentsArray[0].remove(at: index2)
                }
                else { // within standard deviation from average
                    var index5 = Int(arc4random_uniform(UInt32(studentsArray[1].count)))
                    groups[index].append(studentsArray[1][index5])
                    studentsArray[1].remove(at: index2)
                }
            }
        }
        return groups
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath)
        let section = indexPath.section
        let row = indexPath.row
        var list = [["mike","ella"],["david","vicky"]]
        // Configure the cell...
        cell.textLabel?.text = list[section][row]
        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
