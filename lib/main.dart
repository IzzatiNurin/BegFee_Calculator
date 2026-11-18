
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const AeriqApp());
}

class AeriqApp extends StatelessWidget {
  const AeriqApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AERIQ',
      
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF101824),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF86CFFF),
          primary: const Color(0xFF86CFFF),
          onPrimary: const Color(0xFF101824),
          surface: const Color(0xFF202F40),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF101824),
          foregroundColor: Color(0xFFDCE7F0),
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
        title: const Row(
          children: [
            Icon(
              Icons.flight_takeoff_rounded,
              color: Color(0xFF86CFFF),
            ),
            SizedBox(width: 10),
            Text(
              'AERIQ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),

      // NAVIGATION DRAWER
      drawer: Drawer(
        backgroundColor: const Color(0xFF202F40),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF101824),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  Icons.flight_takeoff_rounded,
                  size: 45,
                  color: Color(0xFF86CFFF),
                ),
                SizedBox(height: 10),
                Text(
                  'AERIQ',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Color(0xFFDCE7F0),
                  ),
                ),
                Text(
                  'Travel smarter. Fly lighter.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF8B9AAA),
                  ),
                ),
              ],
            ),
          ),

            
            ListTile(
              leading: const Icon(
                Icons.home_outlined,
                color: Color(0xFF86CFFF),
              ),
              title: const Text(
                'Home',
                style: TextStyle(color: Color(0xFFDCE7F0)),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            
            ListTile(
              leading: const Icon(
                Icons.info_outline,
                color: Color(0xFF86CFFF),
              ),
              title: const Text(
                'About',
                style: TextStyle(color: Color(0xFFDCE7F0)),
              ),
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
            
            // WELCOME SECTION
            const Text(
              'YOUR JOURNEY.\nYOUR WEIGHT.\nYOUR BUDGET.',
              style: TextStyle(
                fontSize: 27,
                height: 1.3,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
                color: Color(0xFFDCE7F0),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Travel smarter. Fly lighter.',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF86CFFF),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Know your baggage cost before take-off.',
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF8B9AAA),
              ),
            ),

            const SizedBox(height: 25),

            
            // BAGGAGE WEIGHT INPUT
            const Text(
              'CHECKED BAGGAGE WEIGHT',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                letterSpacing: 1,
                color: Color(0xFFDCE7F0),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: weightController,
              style: const TextStyle(
                color: Color(0xFFDCE7F0),
                fontSize: 16,
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                hintText: 'e.g. 25',
                hintStyle: const TextStyle(
                  color: Color(0xFF8B9AAA),
                ),
                prefixIcon: const Icon(
                  Icons.luggage_outlined,
                  color: Color(0xFF86CFFF),
                ),
                suffixText: 'KG',
                suffixStyle: const TextStyle(
                  color: Color(0xFF86CFFF),
                  fontWeight: FontWeight.bold,
                ),
                filled: true,
                fillColor: const Color(0xFF202F40),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),


            const SizedBox(height: 20),

            
            // TICKET CLASS SELECTION
            const Text(
              'TRAVEL CLASS',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                letterSpacing: 1,
                color: Color(0xFFDCE7F0),
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              initialValue: selectedClass,
              dropdownColor: const Color(0xFF202F40),
              style: const TextStyle(
                color: Color(0xFFDCE7F0),
              ),
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.airplane_ticket_outlined,
                  color: Color(0xFF86CFFF),
                ),
                filled: true,
                fillColor: const Color(0xFF202F40),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
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
              'EXCESS BAGGAGE RATE',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                letterSpacing: 1,
                color: Color(0xFFDCE7F0),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: rateController,
              style: const TextStyle(
                color: Color(0xFFDCE7F0),
                fontSize: 16,
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                hintText: 'Enter airline rate, e.g. 15',
                hintStyle: const TextStyle(
                  color: Color(0xFF8B9AAA),
                ),
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(left: 12, right: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.payments_outlined,
                        color: Color(0xFF86CFFF),
                      ),
                      SizedBox(width: 6),
                      Text(
                        'RM',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF86CFFF),
                        ),
                      ),
                    ],
                  ),
                ),
                filled: true,
                fillColor: const Color(0xFF202F40),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Enter the airline charge for each additional kilogram.',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF8B9AAA),
              ),
            ),


            const SizedBox(height: 25),

            // CALCULATE BUTTON
           
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: calculateFee,
                icon: const Icon(Icons.calculate_outlined),
                label: const Text(
                  'CALCULATE FLIGHT COST',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    fontSize: 14,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF86CFFF),
                  foregroundColor: const Color(0xFF101824),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),


            const SizedBox(height: 25),

            
            // CALCULATION RESULTS
            if (totalPayable != null)
              Card(
                color: const Color(0xFF202F40),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(
                    color: Color(0xFF34495E),
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.receipt_long_outlined,
                            color: Color(0xFF86CFFF),
                          ),
                          SizedBox(width: 10),
                          Text(
                            'FLIGHT COST SUMMARY',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                              color: Color(0xFFDCE7F0),
                            ),
                          ),
                        ],
                      ),
                      const Divider(
                        height: 30,
                        color: Color(0xFF43566A),
                      ),
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
                      const Divider(
                        height: 30,
                        color: Color(0xFF43566A),
                      ),
                      resultRow(
                        'TOTAL AMOUNT PAYABLE',
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
  
Widget resultRow(String label,
 String value, 
 {bool isTotal = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 14 : 13,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal
                  ? const Color(0xFF86CFFF)
                  : const Color(0xFFDCE7F0),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 20 : 14,
            fontWeight: FontWeight.bold,
            color: isTotal
                ? const Color(0xFF86CFFF)
                : const Color(0xFFDCE7F0),
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

  static final Uri githubUrl = Uri.parse('https://github.com/IzzatiNurin/AERIQ-Baggage-Calculator');

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
          'About',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

  // NAVIGATION DRAWER
  drawer: Drawer(
    backgroundColor: const Color(0xFF202F40),
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        const DrawerHeader(
          decoration: BoxDecoration(
            color: Color(0xFF101824),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                Icons.flight_takeoff_rounded,
                size: 45,
                color: Color(0xFF86CFFF),
              ),
              SizedBox(height: 10),
              Text(
                'AERIQ',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  color: Color(0xFFDCE7F0),
                ),
              ),
              Text(
                'Travel smarter. Fly lighter.',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF8B9AAA),
                ),
              ),
            ],
          ),
        ),
        ListTile(
          leading: const Icon(
            Icons.home_outlined,
            color: Color(0xFF86CFFF),
          ),
          title: const Text(
            'Home',
            style: TextStyle(color: Color(0xFFDCE7F0)),
          ),
          onTap: () {
            Navigator.popUntil(context, (route) => route.isFirst);
          },
        ),
        ListTile(
          leading: const Icon(
            Icons.info_outline,
            color: Color(0xFF86CFFF),
          ),
          title: const Text(
            'About',
            style: TextStyle(color: Color(0xFFDCE7F0)),
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ],
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
                color: const Color(0xFF202F40),
                borderRadius: BorderRadius.circular(25),
                border:Border.all(
                  color: const Color(0xFF34495E),
                ),
              ),
              child: const Icon(
                Icons.flight_takeoff_rounded,
                size: 75,
                color: Color(0xFF86CFFF),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'AERIQ',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: Color(0xFF86CFFF),
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Travel Smarter. Fly Lighter',
              style: TextStyle(
                color: Color(0xFF86CFFF),
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
                    Text('Course: CS251 - BACHELOR OF COMPUTER SCIENCE (HONS.) NETCENTRIC COMPUTING'),
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
                color: Color(0xFF86CFFF),
              ),
            ),

            const SizedBox(height: 10),

            InkWell(
              onTap: openGitHub,
              child: const Text(
                'Visit My GitHub Repository',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF86CFFF),
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              '© 2026 AERIQ. All rights reserved.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF86CFFF),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
