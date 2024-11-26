import 'dart:io';

void main() {
  print('Enter the 1st integer number: ');
  int first = int.parse(stdin.readLineSync()!);
  print('Enter the 2st integer number: ');
  int second = int.parse(stdin.readLineSync()!);

  print('Enter the float number: ');
  double floatNumber = double.parse(stdin.readLineSync()!);

  print('Produto do dobro do primeiro com metade do segundo: ${((first * 2) * (second / 2))}');
  print('Soma do triplo do primeiro com o terceiro: ${((first * 3) + (floatNumber)).toStringAsFixed(2)}');
}
