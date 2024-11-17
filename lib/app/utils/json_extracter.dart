import 'dart:convert';
import 'dart:developer';

Map<String, dynamic>? extractFirstJson(String input) {
  try{
    int startIndex = input.indexOf('{');
    int endIndex = input.lastIndexOf('}');

    if (startIndex == -1 || endIndex == -1 || startIndex > endIndex) {
      return jsonDecode(input);
    }

    String jsonString = input.substring(startIndex, endIndex + 1);
    return jsonDecode(jsonString.replaceAll('\n', '\\n'));
  }catch(e){
    print(e);
    return null;
  }
}