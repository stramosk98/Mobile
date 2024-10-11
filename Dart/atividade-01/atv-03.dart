import 'dart:io';

void main() {
  print('Enter a salary:');
  double salary = double.parse(stdin.readLineSync()!);
 
  print('Enter a discount percentage in relation to the salary:');
  double discount = double.parse(stdin.readLineSync()!);

  double d = (discount / 100) * salary;
 
  print('Initial salary is: \$$salary, and the new salary is: \$${(salary - d).toStringAsFixed(2)}');
}
