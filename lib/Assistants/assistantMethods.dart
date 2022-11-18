import 'package:geolocator/geolocator.dart';
import 'package:ubberapp/Assistants/requestAssistant.dart';

class AssistantMethods {
  //perform geocoding request
  static Future<String> searchCordinateAddress(Position position) async {
    String PlaceAddress = "";
    var url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=AIzaSyAINHQ2ZTUf3comgnPaABibAJCaBLFHQ2g";
    var response = await RequestAssistant.getRequest(url);
    if (response != "failed") {
      PlaceAddress = response["results"][0]["formatted_address"];
    }
    return PlaceAddress;
  }
}
