import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main(List<String> args) {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromARGB(221, 44, 44, 44),
      body: BmiCalculator(),
    );
  }
}

class BmiCalculator extends StatefulWidget {
  const BmiCalculator({super.key});

  @override
  State<BmiCalculator> createState() => _BmiCalculatorState();
}

class _BmiCalculatorState extends State<BmiCalculator> {
  TextEditingController height = TextEditingController();
  TextEditingController weight = TextEditingController();
  double resalut = 0;
  Map<int, String> bmiText = {
    1: 'Severe Thinness',
    2: 'Mild Thinness',
    3: 'Normal',
    4: 'Overweight',
    5: 'Obese Class I',
    6: 'Obese Class II',
    7: 'Obese Class III',
  };
  double sliderValue = 28;
  String selectedBmiText = '';
  int group = 1;
  Widget mytextfield(
      {required String hinttext,
      required TextEditingController textcontroler,
      required String suffix}) {
    return TextField(
      inputFormatters: [
        FilteringTextInputFormatter.deny(
            r"^([1-9]\d*(\.|\,)\d*|0?(\.|\,)\d*[1-9]\d*|[1-9]\d*)$")
      ],
      controller: textcontroler,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      style: const TextStyle(color: Colors.amber, fontSize: 20),
      decoration: InputDecoration(
          suffixText: suffix,
          suffixStyle: const TextStyle(color: Colors.deepOrangeAccent),
          floatingLabelAlignment: FloatingLabelAlignment.center,
          labelText: hinttext,
          labelStyle: const TextStyle(
            color: Colors.amber,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
                color: Colors.amber, style: BorderStyle.solid, width: 2),
          )),
    );
  }

  String adviceText(int status) {
    String text = '';
    if (status == 1) {
      text = '''
-Seek medical help. 
-Eat balanced, small meals. 
-Stay hydrated. 
-Get emotional support.''';
    } else if (status == 2) {
      text = '''
-Choose nutrient-rich foods. 
-Increase portion sizes. 
-Stay hydrated. 
-Consider light exercise.''';
    } else if (status == 3) {
      text = '''
-Maintain balance in diet and exercise. 
-Prioritize healthy habits. 
-Stay active.''';
    } else if (status == 4) {
      text = '''
-Control portions. 
-Stay active regularly. 
-Eat a balanced diet. 
-Seek support if needed.''';
    } else if (status == 5) {
      text = '''
-Focus on balanced diet. 
-Increase activity. 
-Aim for gradual weight loss. 
-Seek guidance.''';
    } else if (status == 6) {
      text = '''
-Emphasize healthy eating. 
-Regular exercise is key. 
-Manage weight with patience.''';
    } else if (status == 7) {
      text = '''
-Consult professionals. 
-Focus on effective strategies. 
-Prioritize health and well-being.''';
    }
    return text;
  }

  Color? colorgenerate(double status) {
    Color? mycolor;
    if (status < 16.5) {
      mycolor = Colors.red;
    } else if (18.5 > status && status > 16.5) {
      mycolor = const Color.fromARGB(255, 238, 255, 0);
    } else if (25 > status && status >= 18.5) {
      mycolor = Colors.green;
    } else if (30 > status && status >= 25) {
      mycolor = Colors.yellow;
    } else if (35 > status && status >= 30) {
      mycolor = const Color.fromARGB(255, 245, 115, 158);
    } else if (40 > status && status >= 35) {
      mycolor = Colors.red;
    } else if (40 <= status) {
      mycolor = const Color.fromARGB(255, 169, 0, 0);
    }
    return mycolor;
  }

  var sliderKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            width: double.infinity,
            height: 50,
          ),
          const Text(
            textAlign: TextAlign.center,
            'BMI Calculator',
            style: TextStyle(color: Colors.amber, fontSize: 20),
          ),
          const SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  width: 90,
                  child: mytextfield(
                      hinttext: 'Height',
                      textcontroler: height,
                      suffix: group == 1 ? 'in ' : 'm')),
              const SizedBox(
                width: 50,
              ),
              SizedBox(
                  width: 90,
                  child: mytextfield(
                      hinttext: 'Weight',
                      textcontroler: weight,
                      suffix: group == 1 ? 'lb' : 'Kg'))
            ],
          ),
          const SizedBox(
            height: 25,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const SizedBox(
              width: 30,
            ),
            const Text(
              'US unit:',
              style: TextStyle(color: Colors.amber),
            ),
            Radio(
              activeColor: Colors.deepOrange,
              value: 1,
              groupValue: group,
              onChanged: (value) {
                setState(() {
                  group = value!;
                });
              },
            ),
            const SizedBox(
              width: 30,
            ),
            const Text(
              'Metric unit:',
              style: TextStyle(color: Colors.amber),
            ),
            Radio(
              activeColor: Colors.deepOrange,
              value: 2,
              groupValue: group,
              onChanged: (value) {
                setState(() {
                  group = value!;
                });
              },
            )
          ]),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                if (group == 1) {
                  if (weight.text.isNotEmpty && height.text.isNotEmpty) {
                    if (double.parse(height.text) > 107) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                          'Enter valid Height',
                          style: TextStyle(color: Colors.black),
                        ),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.amber,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50))),
                      ));
                    } else {
                      double wint = double.parse(weight.text);
                      double hint = double.parse(height.text);
                      resalut = (wint / pow(hint, 2) * 703);

                      if (resalut < 16) {
                        sliderValue = 16;
                      } else if (resalut > 40) {
                        sliderValue = 40;
                      } else {
                        sliderValue = resalut;
                      }

                      if (resalut < 16.5) {
                        selectedBmiText = bmiText[1]!;
                      } else if (18.5 > resalut && resalut > 16.5) {
                        selectedBmiText = bmiText[2]!;
                      } else if (25 > resalut && resalut > 18.5) {
                        selectedBmiText = bmiText[3]!;
                      } else if (30 > resalut && resalut > 25) {
                        selectedBmiText = bmiText[4]!;
                      } else if (35 > resalut && resalut > 30) {
                        selectedBmiText = bmiText[5]!;
                      } else if (40 > resalut && resalut > 35) {
                        selectedBmiText = bmiText[6]!;
                      } else if (40 < resalut) {
                        selectedBmiText = bmiText[7]!;
                      }
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                        'Enter Weight And Height',
                        style: TextStyle(color: Colors.black),
                      ),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.amber,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                    ));
                  }
                } else {
                  if (weight.text.isNotEmpty && height.text.isNotEmpty) {
                    if (double.parse(height.text) > 5) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                          'Enter valid Height',
                          style: TextStyle(color: Colors.black),
                        ),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.amber,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50))),
                      ));
                    } else {
                      double wint = double.parse(weight.text);
                      double hint = double.parse(height.text);
                      resalut = (wint / pow(hint, 2));

                      if (resalut < 16) {
                        sliderValue = 16;
                      } else if (resalut > 40) {
                        sliderValue = 40;
                      } else {
                        sliderValue = resalut;
                      }

                      if (resalut < 16.5) {
                        selectedBmiText = bmiText[1]!;
                      } else if (18.5 > resalut && resalut > 16.5) {
                        selectedBmiText = bmiText[2]!;
                      } else if (25 > resalut && resalut > 18.5) {
                        selectedBmiText = bmiText[3]!;
                      } else if (30 > resalut && resalut > 25) {
                        selectedBmiText = bmiText[4]!;
                      } else if (35 > resalut && resalut > 30) {
                        selectedBmiText = bmiText[5]!;
                      } else if (40 > resalut && resalut > 35) {
                        selectedBmiText = bmiText[6]!;
                      } else if (40 < resalut) {
                        selectedBmiText = bmiText[7]!;
                      }
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                        'Enter Weight And Height',
                        style: TextStyle(color: Colors.black),
                      ),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.amber,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                    ));
                  }
                }
              });
            },
            style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.amber)),
            child: const Text(
              'Calculate',
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          Container(
            height: 60,
            width: 100,
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.amber,
                ),
                borderRadius: BorderRadius.circular(50)),
            child: Center(
              child: Text(
                resalut == 0 ? '' : resalut.toStringAsFixed(2),
                style: const TextStyle(color: Colors.amber, fontSize: 30),
              ),
            ),
          ),
          Slider(
            key: sliderKey,
            min: 16,
            max: 40,
            divisions: 10,
            value: sliderValue,
            onChanged: (value) {
              // setState(() {
              //   sliderValue = value;
              // });
            },
            inactiveColor: Colors.black26,
            activeColor: colorgenerate(resalut),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              "       status:  $selectedBmiText",
              style: TextStyle(color: colorgenerate(resalut)),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextButton(
            onPressed: selectedBmiText == ''
                ? () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                        'Enter Weight And Height',
                        style: TextStyle(color: Colors.black),
                      ),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.amber,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                    ));
                  }
                : () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: Colors.amber,
                          content: Text(
                            adviceText(
                              bmiText.keys.firstWhere(
                                  (k) => bmiText[k] == selectedBmiText),
                            ),
                          ),
                          title: const Text('Health Advice'),
                        );
                      },
                    );
                  },
            child: const Text(
              'Click for Health advices',
              style: TextStyle(color: Colors.amber),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      bottomLeft: Radius.circular(50))),
              width: 150,
              height: 40,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      bottomLeft: Radius.circular(50))),
              width: 120,
              height: 40,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      bottomLeft: Radius.circular(50))),
              width: 90,
              height: 40,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(50),
                      bottomRight: Radius.circular(50))),
              width: 130,
              height: 40,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(50),
                      bottomRight: Radius.circular(50))),
              width: 75,
              height: 40,
            ),
          ),
        ],
      ),
    );
  }
}
