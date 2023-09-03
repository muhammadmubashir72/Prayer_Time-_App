import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../models/prayer_time.dart';

class PrayerTimeScreen extends StatefulWidget {
  const PrayerTimeScreen({super.key});

  @override
  State<PrayerTimeScreen> createState() => _PrayerTimeScreenState();
}

class _PrayerTimeScreenState extends State<PrayerTimeScreen> {
  PrayerTime time = PrayerTime();
  String CityName = "karachi";
  var citycontroller = TextEditingController();

  @override
  void initState() {
    getPrayerTime();
    super.initState();
  }

  Future<void> getPrayerTime() async {
    http.Response response = await http
        .get(Uri.parse("https://dailyprayer.abdulrcs.repl.co/api/${CityName}"));
    print(response.statusCode);
    print(response.body);

    setState(() {
      time = PrayerTime.fromJson(jsonDecode(response.body));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage("assets/bg.png"))),
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(
            height: 30,
          ),

          //--------------------------Search City-----------------------

          Container(
            // margin: const EdgeInsets.only(top: 15),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: TextField(
                cursorColor: const Color(0xff828282),
                controller: citycontroller,
                style: GoogleFonts.dmSans(),
                decoration: InputDecoration(
                    suffix: IconButton(
                        onPressed: () {
                          setState(() {
                            CityName = citycontroller.text;
                            getPrayerTime();
                            citycontroller.clear();
                          });
                        },
                        icon: const Icon(Icons.send),
                        color: Colors.white),
                    contentPadding: const EdgeInsets.all(25),
                    enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide:
                            BorderSide(width: 2, color: Color(0xff828282))),
                    focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide:
                            BorderSide(width: 1, color: Colors.blueAccent)),
                    labelText: "Enter City Name",
                    labelStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    )),
              ),
            ),
          ),

          Text(
            "${time.city ?? ("___")}",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "${time.date ?? ("___")}",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const Spacer(),
          _timeCard("Fajr", "${time.today?.fajr ?? ("___")}"),
          _timeCard("Sunrise", "${time.today?.sunrise ?? ("___")}"),
          _timeCard("Dhuhr", "${time.today?.dhuhr ?? ("___")}"),
          _timeCard("Asr", "${time.today?.asr ?? ("___")}"),
          _timeCard("Maghrib", "${time.today?.maghrib ?? ("___")}"),
          _timeCard("Isha'a", "${time.today?.ishaA ?? ("___")}"),
          const SizedBox(
            height: 20,
          ),
        ]),
      ),
    );
  }

  Widget _timeCard(String name, String time) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.black.withOpacity(0.4)),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(
          children: [
            const Icon(
              Icons.timer_outlined,
              color: Colors.white,
              size: 25,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              name,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
        Text(
          time,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ]),
    );
  }
}
