import XCTest
@testable import Git

class TestExtension: XCTestCase {
    private var url: URL!
    
    override func setUp() {
        url = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(UUID().uuidString)
        try! FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
    }
    
    override func tearDown() {
        try! FileManager.default.removeItem(at: url)
    }
    
    func testExtensionSubtree() {
        let expect = expectation(description: "")
        let a = url.appendingPathComponent("a")
        let b = a.appendingPathComponent("b")
        let c = a.appendingPathComponent("c")
        try! FileManager.default.createDirectory(at: b, withIntermediateDirectories: true)
        try! FileManager.default.createDirectory(at: c, withIntermediateDirectories: true)
        let file1 = b.appendingPathComponent("myfile1.txt")
        let file2 = c.appendingPathComponent("myfile2.txt")
        try! Data("hello world\n".utf8).write(to: file1)
        try! Data("lorem ipsum\n".utf8).write(to: file2)
        var repository: Repository!
        Git.create(url) {
            repository = $0
            repository.user.name = "asd"
            repository.user.email = "my@email.com"
            repository.commit([file1, file2], message: "hello") {
                let index = Index(self.url)
                XCTAssertEqual(4, index?.directories.count)
                if index?.directories.count == 4 {
                    XCTAssertEqual(self.url, index?.directories[0].url)
                    XCTAssertEqual(2, index?.directories[0].sub)
                    XCTAssertEqual(2, index?.directories[0].entries)
                    XCTAssertEqual(a, index?.directories[1].url)
                    XCTAssertEqual(2, index?.directories[1].entries)
                    XCTAssertEqual(1, index?.directories[1].sub)
                    XCTAssertEqual(b, index?.directories[2].url)
                    XCTAssertEqual(0, index?.directories[2].sub)
                    XCTAssertEqual(1, index?.directories[2].entries)
                    XCTAssertEqual(c, index?.directories[3].url)
                    XCTAssertEqual(0, index?.directories[3].sub)
                    XCTAssertEqual(1, index?.directories[3].entries)
                    expect.fulfill()
                }
            }
        }
        waitForExpectations(timeout: 1)
    }
}
