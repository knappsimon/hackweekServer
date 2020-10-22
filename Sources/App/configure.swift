
import Fluent
import FluentMongoDriver
import Leaf
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    app.views.use(.leaf)

//    var middleware = MiddlewareConfig.default()
//    middleware.use(FileMiddleware.self)
//    services.register(middleware)

    app.migrations.add(CreatePoll())
    app.migrations.add(CreateQuiz())
    try app.databases.use(.mongo(connectionString: connectionString), as: .mongo)
    // register routesrxdr
    try routes(app)
}


struct CreatePoll: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("poll")
            .id()
            .field("poll_title", .string)
            .field("poll_description", .string)
            .field("poll_options", .array(of: .custom(PollOption.self)))
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("poll").delete()
    }
}

struct CreateQuiz: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("quiz")
            .id()
            .field("quiz_title", .string)
            .field("quiz_description", .string)
            .field("quiz_options", .array(of: .custom(QuizOption.self)))
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("quiz").delete()
    }
}


let connectionString = "mongodb+srv://dbuser:Qwerty123@cluster0.ywkkl.mongodb.net/HackweekServer?retryWrites=true&w=majority"
