// Dart 中没有 byte 惊了
List<int> convertIntToByte(int num){
  var bytes = <int>[];
  bytes.add(num & 0xFF);
  bytes.add((num & 0xFF00) >> 8);
  bytes.add((num & 0xFF0000) >> 16);
  bytes.add((num >> 24) & 0xFF);
  return bytes;
}