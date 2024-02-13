import 'package:flutter/services.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart' as shelf_router;


bool start_server = false;
bool start_ws = false;
var server;
var ws_conection;
String ws_message;
bool page_restart = false;
String recipe_timeline = '';
String scale_value= '{"type": "scale_value", "data": "0.0"}';

get_ip() async{
  return await NetworkInfo().getWifiIP();
}

void stopServer(){
  start_server = false;
  ws_conection.cancel();
  server = null;
}

startServer()async{
  if(!start_server){
    start_server = true;

    server = await shelf_io.serve(
      logRequests()
        .addHandler(_router),
      await get_ip(), // Allows external connections
      8080,
    );
  }
  print('Serving at http://${server.address.host}:${server.port}');
}

final _router = shelf_router.Router()
  ..get('/styles/index.css', (Request request) async{
    String data = await rootBundle.loadString("assets/page/styles/index.css");
    return Response.ok(data, headers: {'content-type': 'text/css'});
  })
  ..get('/', (Request request) async{
    page_restart = true;
    String data = await rootBundle.loadString("assets/page/index.html");
    return Response.ok(data, headers: {'content-type': 'text/html'});
  })
  ..get('/recipe', (Request request) async{
    print('recipe_timeline = '+ recipe_timeline);
    return Response.ok(recipe_timeline, headers: {'content-type': 'text/json'});
  })
  ..get('/scale_value', (Request request) async{
     print('scale_value = '+ scale_value);
    return Response.ok(scale_value, headers: {'content-type': 'text/json'});
  });
