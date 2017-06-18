//
//  SmashTweetTableViewController.swift
//  Smashtag
//
//  Created by Admin on 17.06.17.
//  Copyright © 2017 Michel Deiman. All rights reserved.
//

import UIKit
import Twitter
import CoreData

class SmashTweetTableViewController: TweetTableViewController {

    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    
    override func insertTweets(_ newTweets: [Twitter.Tweet]) {
        super.insertTweets(newTweets)
        updateDatabase(with: newTweets)
    }
    
    private func updateDatabase(with tweets: [Twitter.Tweet]) {
        print("startin database load")
        container?.performBackgroundTask({ [weak self] (context) in
            for twitterInfo in tweets {
                //add Tweet
                _ = try? Tweet.findOrCreateTweet(matching: twitterInfo, in: context)
            }
            try? context.save()
            print("done loading database")
            self?.printDatabaseStatistics()
        })

    }
    
    private func printDatabaseStatistics() {
        if let context = container?.viewContext {
            //perform context in a proper queue
            context.perform {
                if Thread.isMainThread {
                    print("on main thread")
                } else {
                    print("off the main thread")
                }
                
                if let tweetCount = (try? context.fetch(Tweet.fetchRequest()))?.count {
                    print(tweetCount, "tweets")
                }
                if let twitterCount = try? context.count(for: TwitterUser.fetchRequest()) {
                    print(twitterCount, "Twitter users")
                }
            }
        }
    }

}
