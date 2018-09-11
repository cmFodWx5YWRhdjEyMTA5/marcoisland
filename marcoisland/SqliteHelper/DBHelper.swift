//
//  DBHelper.swift
//  marcoisland
//
//  Created by Kalyan Mohan Paul on 9/10/18.
//  Copyright © 2018 Infologic. All rights reserved.
//

import UIKit
import SQLite3

class DBHelper: NSObject {
    static let DATABASE_NAME = "marco.sqlite"
    static let DATABASE_VERSION = "1"
    static let TBL_USER_MST = "tbl_user_mst"
    static let TBL_CMS_MST = "tbl_cms_mst"
    static let TBL_DASHBOARD_MST = "tbl_dashboard_mst"
    static let TBL_PRODUCT_MST = "tbl_product_mst"
    var db: OpaquePointer?
    var arrResults: [AnyHashable] = []
    var arrColumnNames: [AnyHashable] = []
    var affectedRows: Int = 0
    var lastInsertedRowID: Int64 = 0
    let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
    
    override init() {
        super.init()
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(DBHelper.DATABASE_NAME)
        
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
    }
    
    func initializeDatabase() -> Void {
        
        
        let sqla = "CREATE TABLE IF NOT EXISTS "+DBHelper.TBL_USER_MST+"(" +
            "id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, " +
            "member_id VARCHAR(50), " +
            "mr_email VARCHAR(50), " +
            "mr_full_name VARCHAR(100), " +
            "mr_profile_image VARCHAR(100), " +
            "mr_activation_code VARCHAR(50), " +
            "mr_valid_from VARCHAR(20), " +
            "mr_valid_to VARCHAR(20), " +
            "checkstatus VARCHAR(20), " +
            "created_at DATETIME DEFAULT (datetime('now','localtime'))"+")";
        
        let sqlb = "CREATE TABLE IF NOT EXISTS "+DBHelper.TBL_CMS_MST+"(" +
            "id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, " +
            "post_id VARCHAR(10), " +
            "post_title VARCHAR(100), " +
            "post_content TEXT, " +
            "created_at DATETIME DEFAULT (datetime('now','localtime'))"+")";
        
        
        let sqlc = "CREATE TABLE IF NOT EXISTS "+DBHelper.TBL_DASHBOARD_MST+"(" +
            "id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, " +
            "cms_id VARCHAR(10), " +
            "cms_title VARCHAR(100), " +
            "cms_image_thumb VARCHAR(200), " +
            "cms_image_large VARCHAR(200), " +
            "cms_des TEXT, " +
            "top_image VARCHAR(200), " +
            "scroll_text TEXT, " +
            "created_at DATETIME DEFAULT (datetime('now','localtime'))"+")";
        
        let sqld = "CREATE TABLE IF NOT EXISTS "+DBHelper.TBL_PRODUCT_MST+"(" +
            "id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, " +
            "product_id VARCHAR(50), " +
            "item_name VARCHAR(100), " +
            "item_des TEXT, " +
            "item_price DECIMAL(10,2), " +
            "item_image1 VARCHAR(100), " +
            "item_image2 VARCHAR(100), " +
            "created_at DATETIME DEFAULT (datetime('now','localtime'))"+")";
        
        if sqlite3_exec(db, sqla, nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table A: \(errmsg)")
        }
        if sqlite3_exec(db, sqlb, nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table B: \(errmsg)")
        }
        if sqlite3_exec(db, sqlc, nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table C: \(errmsg)")
        }
        if sqlite3_exec(db, sqld, nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table D: \(errmsg)")
        }
    }
    
    func insertDataIntoUsermaster(rowId: Int, member_id: String, mr_email: String, mr_full_name: String,
                                  mr_profile_image: String, mr_activation_code: String, mr_valid_from: String,
                                  mr_valid_to: String, checkstatus: String) -> Bool {
        
        var stmt: OpaquePointer?
        
        let queryString = "INSERT INTO '\(DBHelper.TBL_USER_MST)' (member_id, mr_email, mr_full_name, mr_profile_image, mr_activation_code, mr_valid_from, mr_valid_to, checkstatus) VALUES (?,?,?,?,?,?,?,?)"
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_text(stmt, 1, member_id, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_text(stmt, 2, mr_email, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_text(stmt, 3, mr_full_name, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return false
        }
        if sqlite3_bind_text(stmt, 4, mr_profile_image, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_text(stmt, 5, mr_activation_code, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_text(stmt, 6, mr_valid_from, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return false
        }
        if sqlite3_bind_text(stmt, 7, mr_valid_to, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return false
        }
        if sqlite3_bind_text(stmt, 8, checkstatus, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return false
        }
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting: \(errmsg)")
            return false
        }
        return true;
    }
    
    func insertDataIntoCMSmaster(rowId: Int, post_id: String, post_title: String, post_content: String) -> Bool {
        
        var stmt: OpaquePointer?
        
        let queryString = "INSERT INTO '\(DBHelper.TBL_CMS_MST)' (post_id, post_title, post_content) VALUES (?,?,?)"
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_text(stmt, 1, post_id, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return false
        }
        if sqlite3_bind_text(stmt, 2, post_title, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return false
        }
        if sqlite3_bind_text(stmt, 3, post_content, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return false
        }
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting: \(errmsg)")
            return false
        }
        return true;
    }
    
    func insertDataIntoDashboardmaster(rowId: Int, cms_id: String, cms_title: String, cms_image_thumb: String, cms_image_large: String, cms_des: String, top_image: String,
                                       scroll_text: String) -> Bool {
        
        var stmt: OpaquePointer?
    
        let queryString = "INSERT INTO tbl_dashboard_mst (cms_id, cms_title, cms_image_thumb, cms_image_large, cms_des, top_image, scroll_text) VALUES (?,?,?,?,?,?,?)"
        
        //let queryString = "INSERT INTO '\(DBHelper.TBL_DASHBOARD_MST)' VALUES (null, '\(cms_id)',  '\(cms_title)', '\(cms_image_thumb)', '\(cms_image_large)', '\(cms_des)','\(top_image)','\(scroll_text)' )"
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_text(stmt, 1, cms_id, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_text(stmt, 2, cms_title, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_text(stmt, 3, cms_image_thumb, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return false
        }
        if sqlite3_bind_text(stmt, 4, cms_image_large, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return false
        }
        if sqlite3_bind_text(stmt, 5, cms_des, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return false
        }
        if sqlite3_bind_text(stmt, 6, top_image, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_text(stmt, 7, scroll_text, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return false
        }
        
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting: \(errmsg)")
            return false
        }
        return true;
    }
    
    func insertDataIntoProductdmaster(rowId: Int, product_id: String, item_name: String, item_des: String, item_price: String, item_image1: String, item_image2: String) -> Bool {
        
        var stmt: OpaquePointer?
        
        let queryString = "INSERT INTO '\(DBHelper.TBL_PRODUCT_MST)' VALUES (null, '\(product_id)',  '\(item_name)', '\(item_des)', '\(item_price)', '\(item_image1)','\(item_image2)' )"
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return false
        }
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting: \(errmsg)")
            return false
        }
        return true;
    }
    
    
    func truncateTable(TABLE_NAME: String) -> Bool {
        var stmt1: OpaquePointer?
        var stmt2: OpaquePointer?
        
        let deleteQuery1 = "delete from '\(TABLE_NAME)' "
        let deleteQuery2 = "delete from sqlite_sequence WHERE name='\(TABLE_NAME)' "
        
        if sqlite3_prepare(db, deleteQuery1, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return false
        }
        
        if sqlite3_step(stmt1) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting: \(errmsg)")
            return false
        }
        
        if sqlite3_prepare(db, deleteQuery2, -1, &stmt2, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return false
        }
        
        if sqlite3_step(stmt2) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting: \(errmsg)")
            return false
        }
        
        
        return true;
    }
    
    
    
    
    
    /* func runQuery(_ query: UnsafePointer<Int8>?, isQueryExecutable queryExecutable: Bool) {
        // Create a sqlite object.
        var sqlite3Database: sqlite3?
        
        // Set the database file path.
        let databasePath = URL(fileURLWithPath: documentsDirectory).appendingPathComponent(databaseFilename).absoluteString
        
        // Initialize the results array.
        if arrResults != nil {
            arrResults.removeAll()
            arrResults = nil
        }
        arrResults = [AnyHashable]()
        
        // Initialize the column names array.
        if arrColumnNames != nil {
            arrColumnNames.removeAll()
            arrColumnNames = nil
        }
        arrColumnNames = [AnyHashable]()
        
        
        // Open the database.
        let openDatabaseResult = sqlite3_open(databasePath.utf8CString, &sqlite3Database)
        
        if openDatabaseResult == SQLITE_OK {
            // Declare a sqlite3_stmt object in which will be stored the query after having been compiled into a SQLite statement.
            var compiledStatement: sqlite3_stmt?
            
            // Load all data from database to memory.
            var prepareStatementResult: Int = sqlite3_prepare_v2(sqlite3Database, query, -1, &compiledStatement, nil)
            
            
            if prepareStatementResult == SQLITE_OK {
                // Check if the query is non-executable.
                if !queryExecutable {
                    // In this case data must be loaded from the database.
                    
                    // Declare an array to keep the data for each fetched row.
                    var arrDataRow: [AnyHashable] = []
                    
                    // Loop through the results and add them to the results array row by row.
                    while sqlite3_step(compiledStatement) == SQLITE_ROW {
                        // Initialize the mutable array that will contain the data of a fetched row.
                        arrDataRow = [AnyHashable]()
                        
                        // Get the total number of columns.
                        var totalColumns: Int = sqlite3_column_count(compiledStatement)
                        
                        for i in 0..<totalColumns {
                            // Convert the column data to text (characters).
                            var dbDataAsChars = Int8(sqlite3_column_text(compiledStatement, i))
                            
                            // If there are contents in the currenct column (field) then add them to the current row array.
                            if dbDataAsChars != nil {
                                // Convert the characters to string.
                                arrDataRow.append(String(utf8String: &dbDataAsChars) ?? "")
                            }
                            
                            // Keep the current column name.
                            if arrColumnNames.count != totalColumns {
                                dbDataAsChars = Int8(sqlite3_column_name(compiledStatement, i))
                                arrColumnNames.append(String(utf8String: &dbDataAsChars) ?? "")
                            }
                        }
                        
                        // Store each fetched data row in the results array, but first check if there is actually data.
                        if arrDataRow.count > 0 {
                            arrResults.append(arrDataRow)
                        }
                    }
                }
                    
                    
                else {
                    // This is the case of an executable query (insert, update, ...).
                    
                    // Execute the query.
                    
                    // This is the case of an executable query (insert, update, ...).
                    
                    // Execute the query.
                    var executeQueryResults: Int = sqlite3_step(compiledStatement)
                    if executeQueryResults == SQLITE_DONE {
                        // Keep the affected rows.
                        affectedRows = sqlite3_changes(sqlite3Database)
                        
                        // Keep the last inserted row ID.
                        lastInsertedRowID = sqlite3_last_insert_rowid(sqlite3Database)
                    } else {
                        // If could not execute the query show the error message on the debugger.
                        print("DB Error: \(sqlite3_errmsg(sqlite3Database))")
                    }
                    
                }
            }
            
        }
            
        else{
            // In the database cannot be opened then show the error message on the debugger.
            print("\(sqlite3_errmsg(sqlite3Database))")
        }
        
        sqlite3_close(sqlite3Database)
        
    }*/
    

    
}
