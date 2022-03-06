import 'package:flutter/material.dart';

class WithoutTransactions extends StatelessWidget {
  const WithoutTransactions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            const SizedBox(height: 20),
            Text(
              'Nenhuma Transação Cadastrada',
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: constraints.maxHeight * 0.5,
              child: Image.asset(
                'assets/images/waiting.png',
                fit: BoxFit.cover,
              ),
            )
          ],
        );
      },
    );
  }
}
