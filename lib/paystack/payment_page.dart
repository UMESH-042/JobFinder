import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:vuna__gigs/paystack/payment_success.dart';



class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

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

  @override
  void initState() {
    super.initState();
    plugin.initialize(publicKey: publicKey);
  }

  // void makePayment() async {
  //   int price = int.parse(amountController.text) * 100;
  //   Charge charge = Charge()
  //     ..amount = price
  //     ..reference = 'ref_${DateTime.now()}'
  //     ..email = emailController.text
  //     ..currency = 'GHS';

  //   CheckoutResponse response = await plugin.checkout(
  //     context,
  //     method: CheckoutMethod.card,
  //     charge: charge,
  //   );

  //   if (response.status == true) {
  //     message = 'Payment was successful. Ref: ${response.reference}';
  //     if (mounted) {}
  //     Navigator.pushAndRemoveUntil(
  //         context,
  //         MaterialPageRoute(
  //             builder: (context) => PaymentSuccess(message: message)),
  //         ModalRoute.withName('/'));
  //   } else {
  //     print(response.message);
  //   }
  // }
  void makePayment() async {
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
    message = 'Payment was successful. Ref: ${response.reference}';
    if (mounted) {}
    Navigator.pop(context, true); // Return payment status as true
  } else {
    print(response.message);
    Navigator.pop(context, false); // Return payment status as false
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: amountController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the amount';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  prefix: Text('GHS'),
                  hintText: '1000',
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: TextFormField(
                  controller: emailController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the email';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'example@gmail.com',
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: ElevatedButton(
                  onPressed: () {
                    makePayment();
                  },
                  child: const Text('Make Payment'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}