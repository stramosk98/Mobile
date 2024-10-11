import 'dart:io';

void main() {
  print('Enter a number:');
  
  int number = int.parse(stdin.readLineSync()!);

  print('The predecessor number of $number is: ${--number}');
}
