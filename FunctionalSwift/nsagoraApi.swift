//
//  nsagoraApi.swift
//  FunctionalSwift
//
//  Created by Ionel Lescai on 16/04/2015.
//  Copyright (c) 2015 iosnsagora. All rights reserved.
//

import Foundation

public typealias JSON = AnyObject
public typealias JSONDictionary = [String:JSON]
public typealias JSONArray = [JSON]

public class User:CustomStringConvertible {
    public var name:String
    public var pictureUrl:NSURL?
    
    public init(json:JSONDictionary){
        name = json["name"] as! String
        pictureUrl = NSURL(string: json["pictureUrl"] as! String)
    }
    
    public var description: String {
        get {
            return name
        }
    }
}

public enum Result<A> {
    case Success(A)
    case Error(NSError)
}

public func parseUser(dictionary:JSONDictionary) -> Result<User> {
    return .Success(User(json: dictionary))
}

public func parseUsers(jsonArray:JSONArray) -> Result<[User]> {
    var users = [User]()
    for json in jsonArray {
        if let jsonDict = json as? JSONDictionary {
            users.append(User(json: jsonDict))
        }
    }
    return .Success(users)
}

public func parseJsonObject(data:NSData) -> Result<JSONDictionary> {
    return parseJson(data)
}

public func parseJsonArray(data:NSData) -> Result<JSONArray> {
    return parseJson(data)
}

public func parseJson<T>(data:NSData) -> Result<T> {
    do {
        let value = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as! T
        return Result.Success(value)
    } catch let error as NSError {
        return .Error(error)
    }
}

public func getData(url:NSURL) -> Result<NSData> {
    do {
        let data = try NSData(contentsOfURL: url, options: NSDataReadingOptions())
        return .Success(data)
    } catch let error as NSError {
        return .Error(error)
    }
}

infix operator >>> {associativity left}
func >>><A,B>(value:Result<A>,f:A->Result<B>) -> Result<B> {
    switch value {
    case .Error(let e):
        return .Error(e)
    case .Success(let x):
        return f(x)
    }
}

func getResult<A>(value:Result<A>) throws -> A {
    switch value {
    case .Error(let e):
        throw e
    case .Success(let x):
        return x
    }
}

public func getMe() -> User? {
    let url = NSURL(string: "http://localhost:8080/me")
    let sequence = getData(url!) >>> parseJson >>> parseUser
    do {
        let user = try getResult(sequence)
        return user
    } catch let error as NSError {
        print(error.localizedDescription)
        return nil
    }
}

public func getUsers() -> [User]? {
    let url = NSURL(string: "http://localhost:8080/users")
    let sequence = getData(url!) >>> parseJsonArray >>> parseUsers
    do {
        let users = try getResult(sequence)
        return users
    } catch let error as NSError {
        print(error.localizedDescription)
        return nil
    }
}



