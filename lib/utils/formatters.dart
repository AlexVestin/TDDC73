import 'package:flutter/services.dart';

class CreditCardFormatter extends TextInputFormatter{
  String imageName;
  CreditCardFormatter(this.imageName);

  var maxAllowed = {"mastercard.png" : 16, "visa.png": 16, "amex.png" : 15,
    "discover.png": 16, "dinersclub.png" : 14};

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue,
      TextEditingValue newValue) {
    // TODO: implement formatEditUpdate
    int howManyNumbers = RegExp(r'[0-9]')
        .allMatches(newValue.text)
        .length;

    if(howManyNumbers > maxAllowed[imageName]) return oldValue;

    if(RegExp(r'[A-z]').allMatches(newValue.text).length > 0){
      return oldValue;
    }
    if(newValue.text.length >= oldValue.text.length) {

      String updated = newValue.text;
      int selectionIndex = newValue.selection.end;
      if (howManyNumbers % 4 == 0) {
        //String store = "${updated[howManyNumbers-1]}";
        print(newValue.text);
        updated += " ";
        selectionIndex++;
      }
      return newValue.copyWith(text: updated,
          selection: TextSelection.collapsed(offset: selectionIndex));
    }
    return newValue;
  }

}