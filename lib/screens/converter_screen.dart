import 'package:flutter/material.dart';

class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  double inputValue = 0;
  String fromUnit = 'Meter';
  String toUnit = 'Foot';
  String result = '';

  String remZero(String result) {
    var value = result;
    if (result.contains(".0")) {
      value = result.substring(0, result.length - 2);
    }
    return value;
  }

  final Map<String, double> lengthUnitMap = {
    'Meter (m)': 1.0,
    'Foot (ft)': 3.28084,
    'Decimeter (dm)': 10.0,
    'Lightyear (ly)': 1.057e-16,
    'Millimeter (mm)': 1000.0,
    'Kilometer (km)': 0.001,
    'Centimeter (cm)': 100.0,
    'Micrometer (um)': 1e6,
    'Parsec (pc)': 3.2408e-17,
    'Astronomical Unit (AU)': 6.68459e-12,
    'Lunar Distance (LD)': 2.72761e-7,
    'Picometer (pm)': 1e12,
    'Nanometer (nm)': 1e9,
  };

  final Map<String, double> weightUnitMap = {
    'Kilogram (kg)': 1.0,
    'Gram (g)': 1000.0,
    'Milligram (mg)': 1e6,
    'Pound (lb)': 2.2046226,
    'Quintal (q)': 0.01,
    'Ton(t)': 0.001,
    'Microgram (ug)': 1e9,
    'Carat (ct)': 5000,
  };
  final TextStyle txtStyle =
      const TextStyle(fontSize: 16, fontWeight: FontWeight.bold);

  final ValueNotifier<String> currentCategory = ValueNotifier('Length');

  void convert() {
    final Map<String, double> selectedUnitMap =
        currentCategory.value == 'Length' ? lengthUnitMap : weightUnitMap;
    final conversionFactor =
        selectedUnitMap[toUnit]! / selectedUnitMap[fromUnit]!;
    setState(() {
      result = remZero((inputValue * conversionFactor).toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    final wth = MediaQuery.of(context).size.width * 0.75;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Unit Converter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text(
                        'Choose a category',
                        style: txtStyle,
                      ),
                      const Spacer(),
                      DropdownButton(
                        value: currentCategory.value,
                        onChanged: (String? newValue) {
                          currentCategory.value = newValue!;
                          setState(() {
                            fromUnit = toUnit = 'Kilogram (kg)';
                            result = '';
                          });
                        },
                        items: ['Length', 'Weight']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Row(
                    children: [
                      Text(
                        'From:',
                        style: txtStyle,
                      ),
                      const Spacer(),
                      DropdownButton(
                        value: fromUnit,
                        onChanged: (String? newValue) {
                          setState(() {
                            fromUnit = newValue!;
                          });
                        },
                        items: currentCategory.value == 'Length'
                            ? lengthUnitMap.keys
                                .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList()
                            : weightUnitMap.keys
                                .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Row(
                    children: [
                      Text(
                        'To: ',
                        style: txtStyle,
                      ),
                      const Spacer(),
                      DropdownButton(
                        value: toUnit,
                        onChanged: (String? newValue) {
                          setState(() {
                            toUnit = newValue!;
                          });
                        },
                        items: currentCategory.value == 'Length'
                            ? lengthUnitMap.keys
                                .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList()
                            : weightUnitMap.keys
                                .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Convert from $fromUnit to $toUnit:',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: wth,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        inputValue = double.tryParse(value) ?? 0;
                      },
                      decoration: InputDecoration(
                          labelText: fromUnit,
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12))),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(Size(wth, 65)),
                  backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed)) {
                        return Colors.orange;
                      }
                      return Colors.red;
                    },
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      side: const BorderSide(color: Colors.black, width: 1.5),
                    ),
                  ),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    const EdgeInsets.all(16.0),
                  ),
                ),
                onPressed: convert,
                child: const Text(
                  'Convert',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                //height: 65,
                width: wth,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (Theme.of(context).colorScheme.inversePrimary)
                      .withOpacity(0.4),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Result:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          toUnit,
                          style: const TextStyle(fontSize: 20),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      result,
                      style: txtStyle,
                      //       overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
