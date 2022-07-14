

bool validNumber(String number){
  if(number.length!=9){
    return false;
  }
  if(number.substring(0,1)=="0"){
    return false;
  }
  return true;
}