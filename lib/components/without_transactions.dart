import 'package:flutter/material.dart';

class WithoutTransactions extends StatelessWidget {
  const WithoutTransactions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Nenhuma Transação Cadastrada',
          style: Theme.of(context).textTheme.headline6,
        ),
        const SizedBox(height: 30),
        SizedBox(
          height: 200,
          child: Image.asset(
            'assets/images/waiting.png',
            fit: BoxFit.cover,
          ),
        )
      ],
    );
  }
}
