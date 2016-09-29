import Foundation
import XCTest
import Omise

class OmiseObjectTest: OmiseTestCase {
    class Parent: OmiseObject {
        var foo: String? {
            get { return get("foo", StringConverter.self) }
            set { set("foo", StringConverter.self, toValue: newValue) }
        }
        
        var child: Child? {
            get { return getChild("child", Child.self) }
            set { setChild("child", Child.self, toValue: newValue) }
        }
    }
    
    class Child: OmiseObject {
        var bar: String? {
            get { return get("bar", StringConverter.self) }
            set { set("bar", StringConverter.self, toValue: newValue) }
        }
        
        var grand: Grandchild? {
            get { return getChild("grand", Grandchild.self) }
            set { setChild("grand", Grandchild.self, toValue: newValue) }
        }
    }
    
    class Grandchild: OmiseObject {
        var baz: String? {
            get { return get("baz", StringConverter.self) }
            set { set("baz", StringConverter.self, toValue: newValue) }
        }
    }
    
    func testTopDownNormalizing() {
        let parent = Parent()
        parent.foo = "one"
        parent.child?.bar = "two"
        parent.child?.grand?.baz = "three"
        
        let attributes = parent.normalizedAttributes
        XCTAssertEqual("one", attributes["foo"] as? String)
        XCTAssertEqual("two", attributes["child[bar]"] as? String)
        XCTAssertEqual("three", attributes["child[grand][baz]"] as? String)
    }
    
    func testBottomUpNormalizing() {
        let grand = Grandchild()
        grand.baz = "three"
        
        let child = Child()
        child.bar = "two"
        child.grand = grand
        
        let parent = Parent()
        parent.foo = "one"
        parent.child = child
        
        let attributes = parent.normalizedAttributes
        XCTAssertEqual("one", attributes["foo"] as? String)
        XCTAssertEqual("two", attributes["child[bar]"] as? String)
        XCTAssertEqual("three", attributes["child[grand][baz]"] as? String)
    }
    
    func testNestedObjectDeconstruction() {
        let inner2: JSONAttributes = ["baz": "three"]
        let inner: JSONAttributes = [
            "bar": "two",
            "grand": inner2
        ]
        let attributes: JSONAttributes = [
            "foo": "one",
            "child": inner
        ]
        
        let parent = Parent(attributes: attributes)
        XCTAssertEqual("one", parent.foo)
        XCTAssertEqual("two", parent.child?.bar)
        XCTAssertEqual("three", parent.child?.grand?.baz)
    }
}
