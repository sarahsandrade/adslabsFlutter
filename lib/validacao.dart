bool validarString (String text){
  final regex = RegExp(r'^[a-zA-Z\s]+$');
  if (text.length<3){
    return false;
  }
  if (!regex.hasMatch(text)){
    return false;
  }
  return true;
}