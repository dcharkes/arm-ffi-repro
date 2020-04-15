import 'dart:ffi';

class SomeStruct extends Struct {}

typedef test_1_native = Int32 Function(
    Pointer<Uint8>, Pointer<Pointer<SomeStruct>>, Int32, Pointer<Uint8>);
typedef test_1 = int Function(
    Pointer<Uint8>, Pointer<Pointer<SomeStruct>>, int, Pointer<Uint8>);

typedef test_2_native = Int32 Function(Pointer<SomeStruct>, Int32, Int64);
typedef test_2 = int Function(Pointer<SomeStruct>, int, int);

DynamicLibrary _libForDart;

void runCheck() {
  _libForDart ??= DynamicLibrary.open('libfordart.so');

  final test1 = _libForDart.lookupFunction<test_1_native, test_1>('test_1');
  final test2 = _libForDart.lookupFunction<test_2_native, test_2>('test_2');

  for (var i = 0; i < 32; i++) {
    var input = 1 << i;
    var expectedOutput = (~input) & 0xffffffff;

    var result = test1(Pointer.fromAddress(0xdeadbeef),
            Pointer.fromAddress(0x3123daf), input, nullptr) &
        0xffffffff;

    if (result != expectedOutput) {
      throw 'test_1($input) = $result. Expected $expectedOutput';
    }
  }

  for (var i = 0; i < 64; i++) {
    var input = 1 << i;
    var expectedOutput = input >> 32;

    var result = test2(Pointer.fromAddress(0xdeadbeef), 123, input);

    if (result != expectedOutput) {
      throw 'test_2($input) = $result. Expected $expectedOutput';
    }
  }
}
