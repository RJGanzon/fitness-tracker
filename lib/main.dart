import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(const MyApp());
}
double minWeight = 68; // can be dynamic
double maxWeight = 70; // can be dynamic
int horizontalLines = 4; // number of lines you want including min and max

double interval = (maxWeight - minWeight) / (horizontalLines - 1);
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool hasNotification = false;



  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "Welcome Back",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.grey,

                          )),
                      Text(
                          "Stefani Wong",
                            style: GoogleFonts.poppins(
                              fontSize: 25,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            )),
                    ]
                  ),
                  Stack(
                    children: [
                      IconButton(
                      icon: Image.asset('assets/notification.png', width: 30, height: 30,),
                      onPressed: () {
                        setState(() {
                          hasNotification = !hasNotification;
                        });
                      }
                    ),
                    if (hasNotification)
                      Positioned(
                      right: 15,
                      top: 10,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width:1,
                            color: Colors.white,
                          ),
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      )
                    )
                    ],
                  )
                ]
              )
            ,
            Container(
              height: 320,
              width: 350,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [const Color(0xFFEAF0FE), const Color(0xFFE9EDFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight
                )
              )
            ,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Weight",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                          )),
                          Text("Last 90 days",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w300,
                            fontSize: 10
                          ))
                        ]
                      ),
                      IconButton(
                        icon: Text("+",
                        style: GoogleFonts.poppins(
                          fontSize: 25,
                        )),
                        onPressed: (){
                          print("Increment Weight");
                        },
                      )
                    ]
                  ),
                  Container(
                    height:200,
                    width:double.infinity,
                    child: LineChart(
                      LineChartData(
                        minX: 0,
                        maxX: 90,
                        minY: minWeight,
                        maxY: maxWeight,
                        borderData: FlBorderData(show: false),
                        gridData: FlGridData(
                          drawVerticalLine: false,
                          drawHorizontalLine: true,
                          getDrawingHorizontalLine: (value) => FlLine(
                            color: const Color(0x809CB0FD),
                            strokeWidth: 2,
                          ),
                          checkToShowHorizontalLine: (value) {
                            // Show line if it's min, max, or on the interval
                            if ((value - minWeight) % interval == 0 || value == minWeight || value == maxWeight) {
                              return true;
                            }
                            return false;
                          },
                        ),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 30,
                              getTitlesWidget: (value, meta) {
                                switch (value.toInt()) {
                                  case 0:
                                    return const Text('1');
                                  case 30:
                                    return const Text('30');
                                  case 60:
                                    return const Text('60');
                                  case 90:
                                    return const Text('90');
                                  default:
                                    return const Text('');
                                }
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: interval,
                              reservedSize: 40,
                              getTitlesWidget: (value, meta) => Text(value.toStringAsFixed(1)),
                            ),
                          ),
                          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        lineBarsData: [
                          LineChartBarData(
                            spots: const [
                              FlSpot(0, 70),
                              FlSpot(30, 69.5),
                              FlSpot(60, 68.5),
                              FlSpot(90, 68),
                            ],
                            isCurved: true,
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF9CB0FD),
                                Color(0xFF5D82F8),
                              ],
                            ),
                            barWidth: 3,
                            isStrokeCapRound: true,
                            dotData: FlDotData(show: true),
                            belowBarData: BarAreaData(
                              show: true,
                              gradient: LinearGradient(
                                colors: [
                                  Color(0x809CB0FD),
                                  Color(0x805D82F8),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )

                    ,
                  )
                ]
              ),
            ))],
          ),
        )
      ),
    );
  }
}
