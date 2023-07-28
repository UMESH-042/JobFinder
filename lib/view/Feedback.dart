import 'package:flutter/material.dart';

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  List<String> feedbackTypes = [
    'Technical issue',
    'Internet issue',
    'Bug',
    'Glitch',
    'Slow performance',
  ];
  List<String> selectedFeedbackTypes = [];

  TextEditingController _feedbackController = TextEditingController();

  void _submitFeedback() {
    String feedbackText = _feedbackController.text;
    // For demonstration purposes, we are just printing the feedback and selected types here.
    print('Feedback submitted: $feedbackText');
    print('Selected Types: $selectedFeedbackTypes');
    // You can clear the text field and selected types after submission.
    _feedbackController.clear();
    setState(() => selectedFeedbackTypes.clear());
  }

  Widget feedbackTypeChoiceChip(String label) {
    final bool isSelected = selectedFeedbackTypes.contains(label);
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 15,
          color: isSelected ? Colors.white : Colors.black,
        ),
      ),
      selected: isSelected,
      selectedColor:  Color.fromARGB(255, 76, 175, 142), // Custom color for selected chips
      onSelected: (selected) {
        setState(() {
          if (selected) {
            selectedFeedbackTypes.add(label);
          } else {
            selectedFeedbackTypes.remove(label);
          }
        });
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.grey), // Border color of the chip
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:  Color.fromARGB(255, 76, 175, 142),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // This automatically handles navigation to the previous page
          },
        ),
        title: Text('Feedback Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Please select the type of feedback:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: feedbackTypes.map((type) {
                return feedbackTypeChoiceChip(type);
              }).toList(),
            ),
            SizedBox(height: 20),
            Text(
              'Please provide your detailed feedback:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: TextFormField(
                controller: _feedbackController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Enter your feedback here...',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
               style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 76, 175, 142), // Custom color for the button
                // Custom text color for the button
              ),
              onPressed: _submitFeedback,
              child: Text('Submit Feedback'),
            ),
          ],
        ),
      ),
    );
  }
}

