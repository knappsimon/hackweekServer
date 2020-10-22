import Foundation
import Leaf
import SwiftGD
import Vapor

func routes(_ app: Application) throws {

//    let rootDirectory = DirectoryConfiguration.detect().workingDirectory
//    let uploadDirectory = URL(fileURLWithPath: "\(rootDirectory)Public/uploads")
//    let originalsDirectory = uploadDirectory.appendingPathComponent("originals")
////    let thumbsDirectory = uploadDirectory.appendingPathComponent("thumbs")

    app.get { req in
        return req.view.render("home", [
            "title": "Trvia Hub",
            "body": "Hello world!"
        ])
    }

    app.post("setupquiz") { req -> EventLoopFuture<Quiz> in
        let quiz  = try req.content.decode(Quiz.self)
        return quiz.create(on: req.db)
            .map { quiz }
    }

    app.post("setuppoll") { req -> EventLoopFuture<Poll> in
        let poll = try req.content.decode(Poll.self)
        return poll.create(on: req.db)
            .map { poll }
    }

    app.get("poll") { req in
        Poll.query(on: req.db).all()
    }

    app.post("polls", "vote") { req -> EventLoopFuture<Poll> in
        guard let id = try? req.content.get(String.self, at: "id"),
              let votedForId = try? req.content.get(Int.self, at: "votedForId") else { throw Abort(.badRequest) }
        let uuid = UUID(uuidString: id)

        return Poll.find(uuid, on: req.db)
            .flatMap { poll in
                guard let poll = poll else { fatalError() }
                poll.pollOptions[votedForId].totalVotes += 1
                return poll.save(on: req.db).map { poll }
            }

    }

    app.get("quiz") { req in
        Quiz.query(on: req.db).all()
    }

//    app.get("images") { req -> EventLoopFuture<View> in
//        let fileManager = FileManager()
//
//        guard let files = try? fileManager.contentsOfDirectory(at: originalsDirectory, includingPropertiesForKeys: nil) else {
//            throw Abort(.internalServerError)
//        }
//
//        let allFiles = files.map { $0.lastPathComponent }
//        let visibleFiles = allFiles.filter { !$0.hasPrefix(".") }
//        let context = ["files": visibleFiles]
//        return req.view.render("files", context)
//    }

    app.get("newpoll") { req -> EventLoopFuture<View> in

        struct Index: Codable {
            var title: String
            var description: String
        }

        struct Page: Codable {
            var content: String
        }

        struct Context: Codable {
            var index: Index
            var page: Page
        }

        let context = Context(index: .init(title: "Trivia Hub", description: "This is the place to dump your trivia into Flagship"), page: .init(content: "Welcome to the iHeart Trivia hub"))
        return req.view.render("upload", context)
    }

    app.post("newquiz") { req -> EventLoopFuture<Quiz> in
        let quiz  = try req.content.decode(Quiz.self)
        return quiz.create(on: req.db)
            .map { quiz }
    }

    app.get("newquiz") { req -> EventLoopFuture<Quiz> in
        let quiz  = try req.content.decode(Quiz.self)
        return quiz.create(on: req.db)
            .map { quiz }
    }




    

//    app.post("upload") { req -> EventLoopFuture<Response> in
//        struct UserFile: Content {
//            var upload: [File]
//        }
//
//        return try req.content.decode(UserFile.self).upload.flatMap(Response.self) { data in
//            let acceptableTypes = [HTTPMediaType.jpeg, HTTPMediaType.png]
//
//            for file in data.upload {
//                guard let mimeType = file.contentType, acceptableTypes.contains(mimeType) else { continue }
//                let cleanedFilename = file.filename.replacingOccurances(of: " ", with: "-")
//                let newURL = originalsDirectory.appendingPathComponent(cleanedFilename)
//
//                _ = try? file.data.write(to: newURL)
//                let thumbURL = thumbsDirectory.appendingPathComponent(cleanedFilename)
//
//                if let image = Image(url: newURL) {
//                    if let resized = image.resizedTo(width: 300) {
//                        resized.write(to: thumbURL)
//                    }
//                }
//            }
//            return Response()
//        }
//    }
}
