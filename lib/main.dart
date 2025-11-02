import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:dotted_line/dotted_line.dart';


void main() {
  runApp(const MyApp());
}

double minWeight = 68; // can be dynamic
double maxWeight = 70; // can be dynamic
int horizontalLines = 4; // number of lines including min and max
double interval = (maxWeight - minWeight) / (horizontalLines - 1);


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool hasNotification = false;
  Widget waterLabel(String time, String amount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          time,
          style: GoogleFonts.poppins(
            fontSize: 10,
            color: Colors.grey,
          ),
        ),
        Text(
          amount,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            foreground: Paint()
              ..shader = const LinearGradient(
                colors: [
                  Color(0xFFD4DBFF), // start (darker lavender)
                  Color(0xFF8C9BFF), // end (darker bluish purple)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(Rect.fromLTWH(0, 0, 200, 70)),
          ),
        ),
      ],
    );
  }

  Widget intakeCircle(bool current, String time) {
    return
      Row(
        children: [
          Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: current
                  ? [
                Color(0xFFCC75FF), // deeper pink-lavender start
                Color(0xFFB65DF2), // rich pinkish-purple middle
                Color(0xFF9B50E9), // dark violet end
              ]
                  : [
                Color(0xFFF0B7FF), // soft pink-lavender start
                Color(0xFFE6A4F4), // pinkish middle tone
                Color(0xFFD7A0FF), // pink-purple end
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              if (current)
                BoxShadow(
                  color: Color(0xFFF0B7FF),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
            ],
          ),
              ),
        // SizedBox(width: 10,),
        // Text(time,
        // style: GoogleFonts.poppins(
        //   color: Colors.grey,
        //   fontSize: 10
        // ))
        ],
      );
  }

  Widget dottedLineWater() {
    return DottedLine(
      direction: Axis.vertical, // or Axis.vertical
      lineLength: 20, // full width
      lineThickness: 1.5,
      dashLength: 3.0,
      dashColor: Color(0xFFE4C6F7),
      dashGapLength: 4.0,
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: const Color(0xFFF7F7F7),
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 👤 Welcome Row
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
                          ),
                        ),
                        Text(
                          "Stefani Wong",
                          style: GoogleFonts.poppins(
                            fontSize: 25,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Stack(
                      children: [
                        IconButton(
                          icon: Image.asset(
                            'assets/notification.png',
                            width: 30,
                            height: 30,
                          ),
                          onPressed: () {
                            setState(() {
                              hasNotification = !hasNotification;
                            });
                          },
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
                                  width: 1,
                                  color: Colors.white,
                                ),
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // 📊 Weight Chart
                Container(
                  height: 320,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFEAF0FE), Color(0xFFE9EDFF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Chart Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Weight",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  "Last 90 days",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: Text(
                                "+",
                                style: GoogleFonts.poppins(fontSize: 25),
                              ),
                              onPressed: () {
                                print("Increment Weight");
                              },
                            ),
                          ],
                        ),

                        // Chart
                        SizedBox(
                          height: 200,
                          width: double.infinity,
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
                                getDrawingHorizontalLine: (value) =>
                                const FlLine(
                                  color: Color(0x809CB0FD),
                                  strokeWidth: 2,
                                ),
                                checkToShowHorizontalLine: (value) {
                                  if ((value - minWeight) % interval == 0 ||
                                      value == minWeight ||
                                      value == maxWeight) {
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
                                    getTitlesWidget: (value, meta) =>
                                        Text(value.toStringAsFixed(1)),
                                  ),
                                ),
                                topTitles: AxisTitles(
                                    sideTitles:
                                    SideTitles(showTitles: false)),
                                rightTitles: AxisTitles(
                                    sideTitles:
                                    SideTitles(showTitles: false)),
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
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0x809CB0FD),
                                        Color(0x805D82F8),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // 💧 Second Row (Water, Calories, Sleep)
                SizedBox(
                  height: 320,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Water Intake
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        height: double.infinity,
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              RotatedBox(
                                quarterTurns: -1, // Makes it vertical
                                child: SizedBox(
                                  width: double.infinity, // vertical height (since it's rotated)
                                  height: 25, // thickness
                                  child: Stack(
                                    children: [
                                      // Background bar
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                      ),
                                      // Foreground gradient bar (progress)
                                      FractionallySizedBox(
                                        alignment: Alignment.centerLeft,
                                        widthFactor: 0.7, // progress value (70%)
                                        child: Container(
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                              colors: [
                                                Color(0xFFBAAAF9), // start
                                                Color(0xFFB4BDFD),
                                                Color(0xFFB3BFFD), // end
                                              ],
                                            ),
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(20),
                                              bottomRight: Radius.circular(0),
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(0)
                                            )
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            SizedBox(width:10),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    "Water Intake",
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500
                                    )
                                ),
                                SizedBox(height: 5,),
                                Text(
                                  "4 Liters",
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    foreground: Paint()
                                      ..shader = const LinearGradient(
                                        colors: [
                                          Color(0xFFD4DBFF), // start (darker lavender)
                                          Color(0xFF8C9BFF), // end (darker bluish purple)
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ).createShader(Rect.fromLTWH(0, 0, 200, 70)),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                    "Real Time updates",
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Colors.black54
                                    )
                                ),
                                SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      children: [
                                        intakeCircle(false, '6am - 8am'),
                                        SizedBox(height: 5,),
                                        dottedLineWater(),
                                        SizedBox(height: 5,),
                                        intakeCircle(false, '8am - 10am'),
                                        SizedBox(height: 5,),
                                        dottedLineWater(),
                                        SizedBox(height: 5,),
                                        intakeCircle(false, '10am - 12pm'),
                                        SizedBox(height: 5,),
                                        dottedLineWater(),
                                        SizedBox(height: 5,),
                                        intakeCircle(false, '12pm - 2pm'),
                                        SizedBox(height: 5,),
                                        dottedLineWater(),
                                        SizedBox(height: 5,),
                                        intakeCircle(true, '2pm - now'),
                                      ],
                                    ),
                                    SizedBox(width: 10),
                                    Column(
                                      children:[
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          waterLabel('6am-8am', '600ml'),
                                          SizedBox(height:5),
                                          waterLabel('9am-11am', '500ml'),
                                          SizedBox(height:5),
                                          waterLabel('11am-2pm', '1000ml'),
                                          SizedBox(height:8),
                                          waterLabel('2pm-4pm', '700ml'),
                                          SizedBox(height:9),
                                          waterLabel('4pm-now', '900ml')
                                        ],
                                      )
                                      ]
                                    )
                                  ]
                                )
                              ],
                            )
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(width: 20),

                      // Calories + Sleep
                      Expanded(
                        child: Column(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              flex: 4,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
