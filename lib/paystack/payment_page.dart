import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';

class PaymentPage extends StatefulWidget {
  final String salary;
  const PaymentPage({super.key, required this.salary});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController amountController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  String publicKey = 'pk_test_8b8c061e04cc4294ba49f2f6b8fb045c30a87098';
  final plugin = PaystackPlugin();
  String message = '';
  bool _isInitComplete = false;
  @override
  void initState() {
    super.initState();
    plugin.initialize(publicKey: publicKey);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showPaymentInstructionsDialog();
      _isInitComplete = true;
    });
     amountController.text = widget.salary; 
  }

  int currentInstruction = 1;

  void _showPaymentInstructionsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Payment Instructions',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      currentInstruction == 1
                          ? '1). To ensure that a job posting is genuine and to give applicants confidence that they will be paid after the project is completed, recruiters must pay the entire sum beforehand.'
                          : '2). Please notify the administrator so that they can proceed with the next stages once the task is finished or a qualified applicant has been found.',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (currentInstruction == 2)
                          TextButton(
                            onPressed: () {
                              setState(() {
                                currentInstruction = 1;
                              });
                            },
                            child: Text('Back'),
                          ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              if (currentInstruction == 1)
                                currentInstruction = 2;
                              else
                                Navigator.pop(context); // Close the dialog
                            });
                          },
                          child: Text(currentInstruction == 1 ? 'Next' : 'OK'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void showSuccessDialog(String reference) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle,
                  size: 64,
                  color: Colors.green,
                ),
                SizedBox(height: 16),
                Text(
                  'Payment Successful',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Reference Number: $reference',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                    Navigator.pop(
                        context, true); // Return payment status as true
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                  ),
                  child: Text(
                    'OK',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void makePayment() async {
    if (_formKey.currentState!.validate()) {
      int price = int.parse(amountController.text) * 100;
      Charge charge = Charge()
        ..amount = price
        ..reference = 'ref_${DateTime.now()}'
        ..email = emailController.text
        ..currency = 'GHS';

      CheckoutResponse response = await plugin.checkout(
        context,
        method: CheckoutMethod.card,
        charge: charge,
      );

      if (response.status == true) {
        String? reference = response.reference;
        showSuccessDialog(reference!);
      } else {
        print(response.message);
        Navigator.pop(context, false); // Return payment status as false
      }
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Page'),
        backgroundColor:
            Color.fromARGB(255, 76, 175, 142), // Greenish-blue app bar color
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16.0),
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Payment instructions banner
                if (_isInitComplete) // Check if initState is completed before building the banner
                  Container(
                    padding: EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(
                          255, 76, 175, 142), // Greenish-blue background color
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Text(
                      'Please read the following instructions carefully:',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                SizedBox(height: 12),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // TextFormField(
                      //   controller: amountController,
                      //   autovalidateMode: AutovalidateMode.onUserInteraction,
                      //   validator: (value) {
                      //     if (value == null || value.isEmpty) {
                      //       return 'Please enter the amount';
                      //     }
                      //     return null;
                      //   },
                      //   decoration: InputDecoration(
                      //     prefixIcon: Icon(Icons.attach_money),
                      //     hintText: 'Enter amount',
                      //     labelText: 'Amount',
                      //     border: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(10.0),
                      //     ),
                      //   ),
                      // ),
                      TextFormField(
                        controller: amountController,
                        enabled: false, // Make the field read-only
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.attach_money),
                          hintText: 'Enter amount',
                          labelText: 'Amount',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: emailController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the email';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email),
                          hintText: 'example@gmail.com',
                          labelText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          makePayment();
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(
                              255, 76, 175, 142), // Greenish-blue button color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: const Text(
                          'Make Payment',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
