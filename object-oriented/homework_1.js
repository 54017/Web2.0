function Base(instanceVar) {
    this.instanceVariable = instanceVar;  //每个实例一个
}

Base.staticVariable = 'Base';  //静态变量 （唯一）

Base.staticMethod = function() {
    console.log("This is from Base class static-method, static-variable is: " + this.staticVariable);
}

Base.prototype.instanceMethod = function() {
    console.log("This is from Base class instance-method, instance-variable is: " + this.instanceVariable);
}

Derived.staticMethod = function() {
    console.log("This is from Derived class static-method, static-variable is: " + this.staticVariable);
}

function Derived(instanceVar) {
    this.instanceVariable = instanceVar;
}

Derived.staticVariable = 'Derived';

Derived.prototype.instanceMethod = function() {
    console.log("This is from Derived class instance-method, instance-variable is: " + this.instanceVariable)
}

function link(a, b) {
    return function() {
        a.call(this);
        b.call(this);
    }
}

function extend(base, derived) {
    var baseProto = base.prototype;
    var derivedProto = derived.prototype;
    for (var i in baseProto) {
        if (typeof(baseProto[i]) === "function" && typeof(derivedProto[i]) === "function") {
            var temp = derivedProto[i];
            derivedProto[i] = function (base, derived) {
                return function () {
                    base.call(this);
                    derived.call(this);
                }
            }(baseProto[i], temp);
        }
    }
    var b = base;
    var d = derived;
    for (var i in b) {
        if (typeof(b[i]) === "function" && typeof(d[i]) === "function") {
            var temp = d[i];
            d[i] = function (base, derived) {
                return function () {
                    base.call(this);
                    derived.call(this);
                }
            }(b[i], temp);
        }
    }
}

extend(Base, Derived);
console.log("this is the test 1");
example = new Derived('example');
Derived.staticMethod();
example.instanceMethod();

console.log("this is the test 2");
example = new Derived('example');
otherExample = new Derived('other-example');
Derived.staticMethod();
example.instanceMethod();
otherExample.instanceMethod();