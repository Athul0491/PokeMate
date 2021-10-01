import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class SomethingWentWrong extends StatelessWidget {
  const SomethingWentWrong({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Text(
            'Something went wrong!',
            style: TextStyle(
              fontSize: 25,
            ),
          ),
          ElevatedButton(
            child: const Text(
              'Try again',
            ),
            onPressed: (){
              /// Start App again

            },
          ),
        ],
      ),
    );
  }
}

