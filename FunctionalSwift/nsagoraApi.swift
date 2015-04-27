//
//  nsagoraApi.swift
//  FunctionalSwift
//
//  Created by Ionel Lescai on 16/04/2015.
//  Copyright (c) 2015 iosnsagora. All rights reserved.
//

import Foundation

public typealias JSON = AnyObject
public typealias JSONDictionary = Dictionary<String, JSON>
public typealias JSONArray = Array<JSON>

public class User:Printable {
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

public final class Box<A> {
    let value: A
    
    init(_ value: A) {
        self.value = value
    }
    
    var unbox:A {
        get{
            return value
        }
    }
}

public enum Result<A> {
    case Success(Box<A>)
    case Error(NSError)
}

public func parseUser(dictionary:JSONDictionary) -> Result<User> {
    return .Success(Box(User(json: dictionary)))
}

public func parseUsers(jsonArray:JSONArray) -> Result<[User]> {
    var users = [User]()
    for json in jsonArray {
        if let jsonDict = json as? JSONDictionary {
            users.append(User(json: jsonDict))
        }
    }
    return .Success(Box(users))
}

public func parseJsonObject(data:NSData) -> Result<JSONDictionary> {
    return parseJson(data)
}

public func parseJsonArray(data:NSData) -> Result<JSONArray> {
    return parseJson(data)
}

public func parseJson<T>(data:NSData) -> Result<T> {
    var error: NSError? = nil
    if let value = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: &error) as? T {
        return .Success(Box(value))
    } else {
        return .Error(error!)
    }
}

public func getData(url:NSURL) -> Result<NSData> {
    var error: NSError? = nil
    if let data = NSData(contentsOfURL: url, options: NSDataReadingOptions.allZeros, error: &error) {
        return .Success(Box(data))
    } else {
        return .Error(error!)
    }
}

infix operator >>> {associativity left}
func >>><A,B>(value:Result<A>,f:A->Result<B>) -> Result<B> {
    switch value {
    case .Error(let e):
        return .Error(e)
    case .Success(let boxed):
        return f(boxed.unbox)
    }
}

func getResult<A>(value:Result<A>,inout error:NSError?) -> A? {
    switch value {
    case .Error(let e):
        error = e
        return nil
    case .Success(let boxed):
        return boxed.unbox
    }
}

public func getMe() -> User? {
    let url = NSURL(string: "http://localhost:8080/me")
    let sequence = getData(url!) >>> parseJson >>> parseUser
    var error: NSError? = nil
    if let user = getResult(sequence, &error) {
        return user
    } else {
        println(error!.localizedDescription)
        return nil
    }
}

public func getUsers() -> [User]? {
    let url = NSURL(string: "http://localhost:8080/users")
    let sequence = getData(url!) >>> parseJsonArray >>> parseUsers
    var error: NSError? = nil
    if let users = getResult(sequence, &error) {
        return users
    } else {
        println(error?.localizedDescription)
        return nil
    }
}



