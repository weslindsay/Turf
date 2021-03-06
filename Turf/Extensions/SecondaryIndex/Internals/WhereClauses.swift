internal struct WhereClauses {
    static func equals<Value: SQLiteType>(name name: String, value: Value) -> WhereClause {
        return WhereClause(sql: "\(name)=?",
            bindStatements: { (stmt, firstColumnIndex) -> Int32 in
                value.sqliteBind(stmt, index: firstColumnIndex)
                return 1
        })
    }

    static func notEquals<Value: SQLiteType>(name name: String, value: Value) -> WhereClause {
        return WhereClause(sql: "\(name)!=?",
            bindStatements: { (stmt, firstColumnIndex) -> Int32 in
                value.sqliteBind(stmt, index: firstColumnIndex)
                return 1
        })
    }

    static func like(name name: String, value: String, negate: Bool = false) -> WhereClause {
        return WhereClause(sql: "\(name) \(negate ? "NOT" : "") LIKE ?",
            bindStatements: { (stmt, firstColumnIndex) -> Int32 in
                value.sqliteBind(stmt, index: firstColumnIndex)
                return 1
        })
    }

    static func regexp(name name: String, regex: String, negate: Bool = false) -> WhereClause {
        return WhereClause(sql: "\(name) \(negate ? "NOT" : "") REGEXP ?",
            bindStatements: { (stmt, firstColumnIndex) -> Int32 in
                regex.sqliteBind(stmt, index: firstColumnIndex)
                return 1
        })
    }

    static func IN<Value: SQLiteType>(name name: String, values: [Value], negate: Bool = false) -> WhereClause {
        precondition(values.count < Int(Int32.max))

        let placeholders = [String](count: values.count, repeatedValue: "?").joinWithSeparator(",")

        return WhereClause(sql: "\(name) \(negate ? "NOT" : "") IN [\(placeholders)]",
            bindStatements: { (stmt, firstColumnIndex) -> Int32 in
                for (index, value) in values.enumerate() {
                    value.sqliteBind(stmt, index: firstColumnIndex + index)
                }
                return Int32(values.count)
        })
    }

    static func between<Value: SQLiteType>(name name: String, left: Value, right: Value) -> WhereClause {
        return WhereClause(sql: "\(name) BETWEEN ? AND ?",
            bindStatements: { (stmt, firstColumnIndex) -> Int32 in
                left.sqliteBind(stmt, index: firstColumnIndex)
                right.sqliteBind(stmt, index: firstColumnIndex + 1)
                return 2
        })
    }

    static func lessThan<Value: SQLiteType>(name name: String, value: Value) -> WhereClause {
        return WhereClause(sql: "\(name) < ?",
            bindStatements: { (stmt, firstColumnIndex) -> Int32 in
                value.sqliteBind(stmt, index: firstColumnIndex)
                return 1
        })
    }

    static func lessThanOrEqual<Value: SQLiteType>(name name: String, value: Value) -> WhereClause {
        return WhereClause(sql: "\(name) <= ?",
            bindStatements: { (stmt, firstColumnIndex) -> Int32 in
                value.sqliteBind(stmt, index: firstColumnIndex)
                return 1
        })
    }

    static func greaterThan<Value: SQLiteType>(name name: String, value: Value) -> WhereClause {
        return WhereClause(sql: "\(name) > ?",
            bindStatements: { (stmt, firstColumnIndex) -> Int32 in
                value.sqliteBind(stmt, index: firstColumnIndex)
                return 1
        })
    }

    static func greaterThanOrEqual<Value: SQLiteType>(name name: String, value: Value) -> WhereClause {
        return WhereClause(sql: "\(name) > ?",
            bindStatements: { (stmt, firstColumnIndex) -> Int32 in
                value.sqliteBind(stmt, index: firstColumnIndex)
                return 1
        })
    }

    static func isNull(name name: String, negate: Bool = false) -> WhereClause {
        return WhereClause(sql: "\(name) \(negate ? "NOT" : "") IS NULL",
            bindStatements: { (stmt, firstColumnIndex) -> Int32 in
                return 0
        })
    }
}
