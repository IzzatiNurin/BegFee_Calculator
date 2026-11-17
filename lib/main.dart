
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const BagFeeApp());
}

class BagFeeApp extends StatelessWidget {
  const BagFeeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BagFee Calculator',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFCEEF2),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFD98CA5),
          primary: const Color(0xFFD98CA5),
          onPrimary: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF8DDE7),
          foregroundColor: Color(0xFF704B5A),
          centerTitle: false,
        ),
      ),
      home: const HomePage(),
    );
  }
}

// HOME PAGE
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController weightController = TextEditingController();
  final TextEditingController rateController = TextEditingController();

  String selectedClass = 'Economy';

  double? excessWeight;
  double? excessCharge;
  double? serviceTax;
  double? totalPayable;

  double get baggageAllowance {
    return selectedClass == 'Economy' ? 20 : 40;
  }

  void calculateFee() {
    final double? weight = double.tryParse(weightController.text);
    final double? rate = double.tryParse(rateController.text);

    if (weight == null || rate == null || weight < 0 || rate < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter valid, non-negative numbers.'),
        ),
      );
      return;
    }

    setState(() {
      excessWeight = (weight - baggageAllowance).clamp(0, double.infinity);
      excessCharge = excessWeight! * rate;
      serviceTax = excessCharge! * 0.08;
      totalPayable = excessCharge! + serviceTax!;
    });
  }

  @override
  void dispose() {
    weightController.dispose();
    rateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // APP BAR
      appBar: AppBar(
        title: const Text(
          'BagFee 🎀',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      // NAVIGATION DRAWER
      drawer: Drawer(
        backgroundColor: const Color(0xFFFFF8F3),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFFF8DDE7),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.luggage_rounded,
                    size: 45,
                    color: Color(0xFFD98CA5),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'BagFee 🎀',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF704B5A),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AboutPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),

      // HOME PAGE CONTENT
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Travel without surprises.',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF704B5A),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Calculate your excess baggage fee before you fly!',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF8C6B79),
              ),
            ),
            const SizedBox(height: 25),

            // BAGGAGE WEIGHT INPUT
            const Text(
              'Checked Baggage Weight (kg)',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF704B5A),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: weightController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                hintText: 'e.g. 25',
                prefixIcon: const Icon(Icons.luggage),
                filled: true,
                fillColor: const Color(0xFFFFF8F3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // TICKET CLASS SELECTION
            const Text(
              'Ticket Class',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF704B5A),
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: selectedClass,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.airplane_ticket),
                filled: true,
                fillColor: const Color(0xFFFFF8F3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Economy',
                  child: Text('Economy - 20 kg allowance'),
                ),
                DropdownMenuItem(
                  value: 'Business',
                  child: Text('Business - 40 kg allowance'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedClass = value;
                    excessWeight = null;
                    excessCharge = null;
                    serviceTax = null;
                    totalPayable = null;
                  });
                }
              },
            ),

            const SizedBox(height: 20),

            // EXCESS BAGGAGE RATE INPUT
            const Text(
              'Excess Baggage Rate (RM per kg)',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF704B5A),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: rateController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                hintText: 'Enter airline rate, e.g. 15',
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(left: 12, right: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.payments_outlined,
                        color: Color(0xFFD98CA5),
                      ),
                      SizedBox(width: 6),
                      Text(
                        'RM',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF704B5A),
                        ),
                      ),
                    ],
                  ),
                ),
                filled: true,
                fillColor: const Color(0xFFFFF8F3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 6),
            const Text(
              'Enter the amount charged by the airline for each extra kg.',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF8C6B79),
              ),
            ),

            const SizedBox(height: 25),

            // CALCULATE BUTTON
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: calculateFee,
                icon: const Icon(Icons.calculate_outlined),
                label: const Text(
                  'Calculate Fee',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD98CA5),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // CALCULATION RESULTS
            if (totalPayable != null)
              Card(
                color: const Color(0xFFFFF8F3),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Your Fee Summary 🎀',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF704B5A),
                        ),
                      ),
                      const Divider(height: 25),
                      resultRow(
                        'Excess Baggage Weight',
                        '${excessWeight!.toStringAsFixed(2)} kg',
                      ),
                      resultRow(
                        'Excess Baggage Charge',
                        'RM ${excessCharge!.toStringAsFixed(2)}',
                      ),
                      resultRow(
                        'Service Tax (8%)',
                        'RM ${serviceTax!.toStringAsFixed(2)}',
                      ),
                      const Divider(height: 25),
                      resultRow(
                        'Total Amount Payable',
                        'RM ${totalPayable!.toStringAsFixed(2)}',
                        isTotal: true,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // RESULT ROW WIDGET
  Widget resultRow(
    String label,
    String value, {
    bool isTotal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                color: const Color(0xFF704B5A),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isTotal ? 17 : 14,
              color: const Color(0xFFD98CA5),
            ),
          ),
        ],
      ),
    );
  }
}

// ABOUT PAGE
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  static final Uri githubUrl = Uri.parse('https://github.com/');

Future<void> openGitHub() async {
  if (!await launchUrl(
    githubUrl,
    mode: LaunchMode.externalApplication,
  )) {
    throw Exception('Could not open GitHub link');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'About BagFee',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 25),

            // APPLICATION ICON
            Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: const Color(0xFFF8DDE7),
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Icon(
                Icons.luggage_rounded,
                size: 75,
                color: Color(0xFFD98CA5),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'BagFee Calculator 🎀',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: Color(0xFF704B5A),
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Travel without surprises.',
              style: TextStyle(
                color: Color(0xFF8C6B79),
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 35),

            // AUTHOR INFORMATION
            Card(
              color: const Color(0xFFFFF8F3),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Author Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF704B5A),
                      ),
                    ),
                    Divider(height: 25),
                    Text('Name: NURIN IZZATI BINIT AHMAD ZAINI'),
                    SizedBox(height: 12),
                    Text('Matric No: 2025222766'),
                    SizedBox(height: 12),
                    Text('Course: CS2515B'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            // GITHUB REPOSITORY
            const Text(
              'Source Code',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF704B5A),
              ),
            ),

            const SizedBox(height: 10),

            InkWell(
              onTap: openGitHub,
              child: const Text(
                'Visit My GitHub Repository',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFD98CA5),
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              '© 2026 BagFee Calculator. All rights reserved.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF8C6B79),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
