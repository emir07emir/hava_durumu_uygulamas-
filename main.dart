import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hava_durumu_uygulamasi/my_flutter_app_icons.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hava Durumu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.montserratTextTheme(),
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple, secondary: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: Anasayfa(),
    );
  }
}

class Anasayfa extends StatefulWidget {
  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  var tfcontrol = TextEditingController();
  double? latitude;
  double? longitude;
  Future<Map<String, dynamic>>? havaDurumuFuture;
  bool resimVarMi=false;
  bool gorunuyorMu=true;
  int saat=DateTime.now().hour;//güncel saati alır
  String? resimUrl;
  bool resimYukleniyor=false;


  Future<Map<String, dynamic>> tumVeriler(double latitude, double longitude) async {
    var url = Uri.parse(
        "https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&daily=temperature_2m_max,temperature_2m_min,weathercode&current_weather=true&timezone=Europe%2FIstanbul");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("VERİ ALINAMADI");
    }
  }

  Icon getHavaIkon(int weatherCode) {
      if (weatherCode >= 0 && weatherCode<=2) {
        return Icon(Icons.sunny, color: Colors.orange, size: 50);
      } else if (weatherCode == 3) {
        return Icon(MyFlutterApp.cloud_sun_inv, color: Colors.orange, size: 50);
      } else if (weatherCode == 4) {
        return Icon(Icons.cloud, color: Colors.grey, size: 50); // yağmur için örnek
      } else if (weatherCode >= 45 && weatherCode <= 48) {
        return Icon(Icons.foggy, color: Colors.white, size: 50); // kar
      } else if (weatherCode >= 51 && weatherCode <= 55) {
        return Icon(MyFlutterApp.cloud_sun_rain, color: Colors.amber, size: 50); // fırtına
      }else if (weatherCode >= 61 && weatherCode <= 65) {
        return Icon(MyFlutterApp.rain_inv, color: Colors.blue, size: 50); // fırtına
      }else if (weatherCode >= 66 && weatherCode <= 67) {
        return Icon(MyFlutterApp.snow_inv, color: Colors.grey, size: 50); // fırtına
      }else if (weatherCode >= 71 && weatherCode <= 75) {
        return Icon(Icons.ac_unit_sharp, color: Colors.blue, size: 50); // fırtına
      }else if (weatherCode == 77) {
        return Icon(MyFlutterApp.snow_inv, color: Colors.grey, size: 50); // fırtına
      } else if (weatherCode >= 80 && weatherCode <= 82) {
        return Icon(MyFlutterApp.rain_inv, color: Colors.grey, size: 50); // fırtına
      }else if (weatherCode >= 85 && weatherCode <= 86) {
        return Icon(MyFlutterApp.snow_heavy_inv, color: Colors.white, size: 50); // fırtına
      }else if (weatherCode == 95) {
        return Icon(MyFlutterApp.poo_storm, color: Colors.yellow, size: 50); // fırtına
      }else if (weatherCode >= 96 && weatherCode <= 99) {
        return Icon(Icons.flash_on, color: Colors.yellow, size: 50); // fırtına
      }else {
        return Icon(Icons.sunny, color: Colors.orange, size: 50);
      }
  }

  Icon anlikgetHavaIkon(int weatherCode) {
    if(saat<19){
      if (weatherCode >= 0 && weatherCode<=2) {
        return Icon(Icons.sunny, color: Colors.orange, size: 70);
      } else if (weatherCode == 3) {
        return Icon(MyFlutterApp.cloud_sun_inv, color: Colors.orange, size: 70);
      } else if (weatherCode == 4) {
        return Icon(Icons.cloud, color: Colors.grey, size: 70); // bulutlu
      } else if (weatherCode >= 45 && weatherCode <= 48) {
        return Icon(Icons.foggy, color: Colors.white, size: 70); // sisli
      } else if (weatherCode >= 51 && weatherCode <= 55) {
        return Icon(MyFlutterApp.cloud_sun_rain, color: Colors.amber, size: 70); // bulutlu güneşli
      }else if (weatherCode >= 61 && weatherCode <= 65) {
        return Icon(MyFlutterApp.rain_inv, color: Colors.blue, size: 70); // yağmurlu
      }else if (weatherCode >= 66 && weatherCode <= 67) {
        return Icon(MyFlutterApp.snow_inv, color: Colors.grey, size: 70); // karlı
      }else if (weatherCode >= 71 && weatherCode <= 75) {
        return Icon(Icons.ac_unit_sharp, color: Colors.blue, size: 70); // kar taneli
      }else if (weatherCode == 77) {
        return Icon(MyFlutterApp.snow_inv, color: Colors.grey, size: 70); // karlı
      } else if (weatherCode >= 80 && weatherCode <= 82) {
        return Icon(MyFlutterApp.rain_inv, color: Colors.grey, size: 70); // yağmurlu
      }else if (weatherCode >= 85 && weatherCode <= 86) {
        return Icon(MyFlutterApp.snow_heavy_inv, color: Colors.white, size: 70); // sağanak kar
      }else if (weatherCode == 95) {
        return Icon(MyFlutterApp.poo_storm, color: Colors.yellow, size: 70); // fırtına
      }else if (weatherCode >= 96 && weatherCode <= 99) {
        return Icon(Icons.flash_on, color: Colors.yellow, size: 70); // fırtına
      }else {
        return Icon(Icons.sunny, color: Colors.orange, size: 70); //güneşli
      }
    }else{
      return Icon(Icons.nightlight_round,size: 65,);
    }

  }

  String tarihVeGun(String tarih){
    DateTime dt=DateTime.parse(tarih);
    List<String> gunler = ["Pazar","Pazartesi","Salı","Çarşamba","Perşembe","Cuma","Cumartesi"];
    return "${gunler[dt.weekday %7]} - ${dt.day}/${dt.month}";
  }
  
  Future<void> resimGetir(String sehir) async{
    setState(() {
      resimYukleniyor=true;
    });
    var url = Uri.parse("https://api.unsplash.com/photos/random?query=${sehir}+landscape+cityscape&orientation=portrait&w=1080&h=1920&client_id=WPomJFIP6h8wCFXhFyguTEuDHFyE4giF8gisv8zaDPk");
    var response = await http.get(url);
    if(response.statusCode==200){
      var data=jsonDecode(response.body);
      setState(() {
        resimUrl=data["urls"]["raw"] + "&w=1080&h=1920&fit=crop";
        resimVarMi = true;
      });
    }else{
      setState(() {
        resimVarMi=false;
      });
    }

    setState(() {
      resimYukleniyor=false;
    });
  }


  Future<void> sehirdenKoordinatAl(String sehir) async {
    var url = Uri.parse(
        "https://geocoding-api.open-meteo.com/v1/search?name=$sehir&count=1&language=tr&format=json");
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data["results"] != null && data["results"].isNotEmpty) {
        latitude = data["results"][0]["latitude"];
        longitude = data["results"][0]["longitude"];

        setState(() {
          havaDurumuFuture = tumVeriler(latitude!, longitude!);
        });
      } else {
        throw Exception("Şehir Bulunamadı");
      }
    } else {
      throw Exception("Koordinatlar Alınamadı");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.9,
              child:resimYukleniyor ?Center(
                child:CircularProgressIndicator(),):
              resimVarMi ? Image.network(
                resimUrl!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ):Image.asset(
                "resimler/stock.jpg",
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TextField
              Padding(
                padding: const EdgeInsets.only(top: 50, left: 8, right: 8),
                child: TextField(
                  style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                  controller: tfcontrol,
                  inputFormatters: [
                    FilteringTextInputFormatter.singleLineFormatter,
                  ],
                  cursorColor: Color(0xff0838A3),
                  cursorWidth: 2,
                  cursorHeight: 30,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Şehir Giriniz",
                    hintStyle: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,fontFeatures:[FontFeature("smcp")] ),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.1),
                      borderSide: BorderSide(color: Colors.black, width: 3),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.1),
                      borderSide: BorderSide(color: Colors.black54, width: 2),
                    ),
                    suffixIcon: IconButton(
                      style: IconButton.styleFrom(
                        elevation: 5,
                        iconSize:30,
                      ),
                      color: Colors.black,
                      onPressed: () {
                        if(tfcontrol.text.trim().isEmpty){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Arama Kutusu Boş Bırakılamaz!"),
                              duration: Duration(seconds: 3),
                          ));
                          setState(() {
                            resimVarMi=false;
                            gorunuyorMu=false;
                          });
                        }else{
                          sehirdenKoordinatAl(tfcontrol.text);
                          resimGetir(tfcontrol.text);
                          setState(() {
                            resimVarMi=true;
                          });
                        }


                      },
                      icon: Icon(Icons.search),
                    ),
                  ),
                ),
              ),

              // FutureBuilder
              Expanded(
                child: FutureBuilder<Map<String, dynamic>>(
                  future: havaDurumuFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Hata: ${snapshot.error}"));
                    } else if (snapshot.hasData) {
                      var data = snapshot.data!;
                      var daily = data["daily"];
                      var current = data["current_weather"];
                      var maxSicaklikList = daily["temperature_2m_max"];
                      var minSicaklikList = daily["temperature_2m_min"];
                      var tarihList = daily["time"];
                      var anlikHavaDurumu = current["temperature"];
                      var sehirAdi = tfcontrol.text;
                      var anlikHavaKodu = current["weathercode"];
                      Icon anlikhavaIkon = anlikgetHavaIkon(anlikHavaKodu);
                      print("Saat: ${saat+3}");

                      



                      return Visibility(
                        visible: gorunuyorMu,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              // Anlık Hava Durumu Kartı
                              Card(
                                color: Colors.white.withOpacity(0.7),
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    children: [
                                      // Şehir adı
                                      Text(sehirAdi, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 16),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          // Anlık sıcaklık
                                          Text(
                                            "${anlikHavaDurumu}°C",
                                            style: TextStyle(
                                                fontSize: 50, fontWeight: FontWeight.bold),
                                          ),
                                          // Hava durumu ikonu
                                          anlikhavaIkon

                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              // 7 Günlük Hava Durumu
                              Expanded(
                                child: ListView.builder(
                                  itemCount: tarihList.length,
                                  itemBuilder: (context, index) {
                                    int gunlukHavaKodu = daily["weathercode"][index];
                                    Icon gunlukHavaIcon = getHavaIkon(gunlukHavaKodu);

                                    return Card(
                                      elevation: 5,
                                      color: Colors.white.withOpacity(0.5),
                                      child: ListTile(
                                        leading: gunlukHavaIcon,
                                        title: Text("${tarihVeGun(tarihList[index])}",style: TextStyle(fontSize: 19,fontWeight: FontWeight.bold),),
                                        subtitle: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                        Text("Max: ${maxSicaklikList[index]}°C",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Color(0xff161459)),),
                                        Text("Min: ${minSicaklikList[index]}°C",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Color(0xff161459)),),

                                          ],
                                        )
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("HEMEN BAŞLA",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 15)),
                          ),
                          Icon(Icons.search_rounded,size: 45,),

                        ],
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
