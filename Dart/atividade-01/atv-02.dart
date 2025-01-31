import 'dart:io';

void main() {
  print('Enter a number of voters:');
  int voters = int.parse(stdin.readLineSync()!);
 
  print('Enter a number of valid votes:');
  int valid = int.parse(stdin.readLineSync()!);
 
  print('Enter a number of null votes:');
  int nullable = int.parse(stdin.readLineSync()!);
 
  print('Enter a number of blank votes:');
  int blank = int.parse(stdin.readLineSync()!);

  print('The percentage of valid votes is: ${((valid / voters) * 100).toStringAsFixed(2)}%');
  print('The percentage of null votes is: ${((nullable / voters) * 100).toStringAsFixed(2)}%');
  print('The percentage of blank votes is: ${((blank / voters) * 100).toStringAsFixed(2)}%');
}
