class Animal {
  void animal() {}
}

class Fly {
  String className = "carton";

  void fly() {}
}

class Swim {
  void swimming() {}
}

class Eat {
  void eat() {}
}

class Draink {
  void drink() {}
}

class AAA extends Animal with Eat, Draink implements Fly, Swim {
  @override
  String className = "AAA";

  @override
  void animal() {
    // TODO: implement animal
    super.animal();
  }

  void turnOn() {
    super.animal();
    _test();
    eat();
    drink();
  }

  void _test() {}

  @override
  void fly() {
    // TODO: implement Fly
  }

  @override
  void swimming() {
    // TODO: implement Swim
  }
}
