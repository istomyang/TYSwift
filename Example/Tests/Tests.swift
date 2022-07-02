// https://github.com/Quick/Quick

import Quick
import Nimble
import TYSwift
import XCTest

// BUG：quick Executed 0 tests
// 试试去掉Podfile里面的版本，提高项目的构建版本，然后Pod update, Pod install，说不定就好了。

class BananaTests: XCTestCase {
  func testPeel() {
    
    let a = false
    XCTAssertTrue(a)
  }
  func testSome() {
    expect(1 + 1).to(equal(2))
  }
}

class TableOfContentsSpec: QuickSpec {
  override func spec() {
    describe("these will fail") {
      
      it("can do maths") {
        expect(1) == 2
        
        let a = false
        XCTAssertTrue(a)
      }
      
      it("can read") {
        expect("number") == "string"
      }
      
      it("will eventually fail") {
        expect("time").toEventually( equal("done") )
      }
      
      context("these will pass") {
        
        it("can do maths") {
          expect(23) == 23
        }
        
        it("can read") {
          expect("🐮") == "🐮"
        }
        
        it("will eventually pass") {
          var time = "passing"
          
          DispatchQueue.main.async {
            time = "done"
          }
          
          waitUntil { done in
            Thread.sleep(forTimeInterval: 0.5)
            expect(time) == "done"
            
            done()
          }
        }
      }
    }
  }
}
