struct Foo {
  int field1;
  int field2;
};

void f1(void) {
  struct Foo foo = {
      .field1 = 0,

  };
}

void f2(void) {
  int arr[3] = {
      [0] = 0,

      [2] = 0,
  };
}