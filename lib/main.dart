import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:dotted_line/dotted_line.dart';
import 'dart:math';

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
                  Color(0xFFF0B7FF), // soft pink-lavender start
                  Color(0xFFE6A4F4), // pinkish middle tone
                  Color(0xFFD7A0FF), // pink-purple end
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
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: current
                  ? [
                Color(0xFFCC75FF),
                Color(0xFFB65DF2),
                Color(0xFF9B50E9),
              ]
                  : [
                Color(0xFFF0B7FF),
                Color(0xFFE6A4F4),
                Color(0xFFD7A0FF),
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
      ],
    );
  }

  Widget dottedLineWater() {
    return DottedLine(
      direction: Axis.vertical,
      lineLength: 20,
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
                                getDrawingHorizontalLine: (value) => const FlLine(
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
                                quarterTurns: -1,
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 25,
                                  child: Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                      ),
                                      FractionallySizedBox(
                                        alignment: Alignment.centerLeft,
                                        widthFactor: 0.7,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                              colors: [
                                                Color(0xFFBAAAF9),
                                                Color(0xFFB4BDFD),
                                                Color(0xFFB3BFFD),
                                              ],
                                            ),
                                            borderRadius: const BorderRadius.only(
                                              bottomLeft: Radius.circular(20),
                                              bottomRight: Radius.circular(0),
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(0),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Water Intake",
                                      style: GoogleFonts.poppins(
                                          fontSize: 14, fontWeight: FontWeight.w500)),
                                  const SizedBox(height: 5),
                                  Text(
                                    "4 Liters",
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      foreground: Paint()
                                        ..shader = const LinearGradient(
                                          colors: [
                                            Color(0xFFD4DBFF),
                                            Color(0xFF8C9BFF),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ).createShader(Rect.fromLTWH(0, 0, 200, 70)),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text("Real Time updates",
                                      style: GoogleFonts.poppins(
                                          fontSize: 12, color: Colors.black54)),
                                  const SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        children: [
                                          intakeCircle(false, '6am - 8am'),
                                          const SizedBox(height: 5),
                                          dottedLineWater(),
                                          const SizedBox(height: 5),
                                          intakeCircle(false, '8am - 10am'),
                                          const SizedBox(height: 5),
                                          dottedLineWater(),
                                          const SizedBox(height: 5),
                                          intakeCircle(false, '10am - 12pm'),
                                          const SizedBox(height: 5),
                                          dottedLineWater(),
                                          const SizedBox(height: 5),
                                          intakeCircle(false, '12pm - 2pm'),
                                          const SizedBox(height: 5),
                                          dottedLineWater(),
                                          const SizedBox(height: 5),
                                          intakeCircle(true, '2pm - now'),
                                        ],
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          waterLabel('6am-8am', '600ml'),
                                          const SizedBox(height: 5),
                                          waterLabel('9am-11am', '500ml'),
                                          const SizedBox(height: 5),
                                          waterLabel('11am-2pm', '1000ml'),
                                          const SizedBox(height: 8),
                                          waterLabel('2pm-4pm', '700ml'),
                                          const SizedBox(height: 9),
                                          waterLabel('4pm-now', '900ml')
                                        ],
                                      )
                                    ],
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
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Calories",
                                          style: GoogleFonts.poppins(
                                              fontSize: 12, fontWeight: FontWeight.w500)),
                                      const SizedBox(height: 2),
                                      Text(
                                        "760 kCal",
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          foreground: Paint()
                                            ..shader = const LinearGradient(
                                              colors: [
                                                Color(0xFFD4DBFF),
                                                Color(0xFF8C9BFF),
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ).createShader(Rect.fromLTWH(0, 0, 200, 70)),
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Expanded(
                                        child: Center(
                                          child: SizedBox(
                                            width: 100,
                                            height: 100,
                                            child: CustomPaint(
                                              painter: _CircularProgressPainter(0.7),
                                              child: Center(
                                                child: Text(
                                                  "230kCal \nleft",
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 8,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
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

class _CircularProgressPainter extends CustomPainter {
  final double progress;

  _CircularProgressPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    double strokeWidth = 8;
    double radius = (size.width / 2 - strokeWidth / 2) * 0.8; // smaller circle
    Offset center = Offset(size.width / 2, size.height / 2);

    // Draw center gradient
// Draw center gradient (left to right)
    Rect centerRect = Rect.fromCircle(center: center, radius: radius);
    Paint centerPaint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0xFF9AC3FE), // soft blue-lavender (left)
          Color(0xFF92A5FD), // deeper lavender (right)
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(centerRect);

    canvas.drawCircle(center, radius * 0.75, centerPaint); // inner gradient circle
 // inner gradient circle

    // Draw background circle
    Paint backgroundPaint = Paint()
      ..color = Colors.grey[200]!
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius, backgroundPaint);

    // Draw progress circle
    Rect rect = Rect.fromCircle(center: center, radius: radius);
    Paint progressPaint = Paint()
      ..shader = const SweepGradient(
        startAngle: -pi / 2,
        endAngle: 3 * pi / 2,
        colors: [
          Color(0xFFBAA7F8), // pinkish-purple start
          Color(0xFFB3B9FC), // middle
          Color(0xFFAEBCFD), // end
        ],
      ).createShader(rect)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;


    double sweepAngle = 2 * pi * progress;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2,
        sweepAngle, false, progressPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

