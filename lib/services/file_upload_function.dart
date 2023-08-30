import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;

Future<void> uploadFile(File file, String url) async {
  var request = http.MultipartRequest('POST', Uri.parse(url));

  // Attach the file to the request
  var fileStream = http.ByteStream(file.openRead());
  var fileLength = await file.length();

  var multipartFile = http.MultipartFile(
    'file',
    fileStream,
    fileLength,
    filename: file.path.split('/').last,
  );

  request.files.add(multipartFile);

  // Send the request and get the response
  var response = await request.send();

  if (response.statusCode == 200) {
    print('File uploaded successfully');
  } else {
    print('File upload failed with status: ${response.statusCode}');
  }
}
