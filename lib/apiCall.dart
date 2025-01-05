import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

const String _baseURL = 'flutterstickynotes.atwebpages.com';

dynamic getStickyNotes(Function(bool success) update) async {
  try {
    final url = Uri.http(_baseURL, 'getStickyNotes.php');
    final response = await http.get(url).timeout(const Duration(seconds: 5));

    if (response.statusCode == 200) {
      final jsonResponse = convert.jsonDecode(response.body);

      update(true);
      return jsonResponse;
    }
  } catch (e) {
    update(false);
  }
}

dynamic updateStickyNotesPos(
  Function(bool success) update,
  int id,
  double x,
  double y,
) async {
  try {
    final url = Uri.http(_baseURL, 'updateStickyNotesPos.php',
        {"id": id.toString(), "x": x.toString(), "y": y.toString()});
    final response = await http.get(url).timeout(const Duration(seconds: 5));

    if (response.statusCode == 200) {
      update(true);
    }
  } catch (e) {
    print(e);
    update(false);
  }
}

dynamic deleteStickyNote(
  Function(bool success) update,
  int id,
) async {
  try {
    final url =
        Uri.http(_baseURL, 'deleteStickyNote.php', {"id": id.toString()});
    final response = await http.get(url).timeout(const Duration(seconds: 5));

    if (response.statusCode == 200) {
      update(true);
    }
  } catch (e) {
    update(false);
  }
}

dynamic insertStickyNote(
    Function(bool success) update, String text, String color) async {
  try {
    final url = Uri.http(
        _baseURL, 'insertStickyNote.php', {"text": text, "color": color});
    final response = await http.get(url).timeout(const Duration(seconds: 5));

    if (response.statusCode == 200) {
      update(true);
    }
  } catch (e) {
    update(false);
  }
}
