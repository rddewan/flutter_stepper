import 'package:flutter/material.dart';
import 'package:flutter_stepper/payment_success.dart';
import 'package:flutter_stepper/custom_stepper.dart' as customStepper;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(      
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  int _currentStep = 0;
  bool _isCompleted = false;
 
  @override
  Widget build(BuildContext context) {   
    return Scaffold(
      appBar: AppBar(      
        title: Text(widget.title),
      ),
      body: _isCompleted ?
      const PaymentSuccess() :
      Theme(
        data: Theme.of(context).copyWith(         
          colorScheme: const ColorScheme.light(
            primary: Colors.black38
                       
          )
        ),
        child: customStepper.Stepper(
          type: customStepper.StepperType.horizontal,
          steps: getSteps(),
          currentStep: _currentStep,
          stepStateIndexedColor: Colors.black,
          stepStateEditingColor: Colors.pink,
          stepStateCompleteColor: Colors.green,
          lineColor: Colors.orange,
          onStepContinue: () {
            final isLastStep = _currentStep == getSteps().length - 1;
      
            if (isLastStep) {
              debugPrint('done');
              setState(() {
                 _isCompleted = true;
              });             
            }
            else {
              setState(() {
                _currentStep += 1;
              });
            }          
          },
          onStepCancel: _currentStep == 0 ? null : () =>  setState(() => _currentStep -= 1),         
          onStepTapped: (step) => setState(() {
            _currentStep = step;
          }),
          controlsBuilder: (context, details){
            final isLastStep = _currentStep == getSteps().length - 1;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(                                           
                      onPressed: details.onStepContinue, 
                      child: Text(isLastStep ? 'Confirm' : 'Continue to ${_currentStep + 2}'),
                    ),
                  ),
                  const SizedBox(width: 16.0,),
                  if (_currentStep != 0)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: details.onStepCancel, 
                        child: const Text('Back',
                      ),
                    ),
                    ),
                ],
              ),
            );            
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  List<customStepper.Step> getSteps() => [
    customStepper.Step(
      state: _currentStep == 0 
      ? customStepper.StepState.editing
      :  _currentStep > 0 
      ? customStepper.StepState.complete : customStepper.StepState.indexed,
      isActive: _currentStep == 0,
      title: const Text('Account'), 
      content: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
              //label: const Text('Name'),
              labelText: 'Enter your first name',
            )
          ),
          TextFormField(
            decoration: const InputDecoration(
              //label: const Text('Name'),
              labelText: 'Enter your last name',
            )
          )
        ],
      ),
    ),
    customStepper.Step(
      state: _currentStep == 1 
        ? customStepper.StepState.editing 
        : _currentStep >= 1 
        ? customStepper.StepState.complete 
        : customStepper.StepState.indexed,
      isActive: _currentStep == 1,
      title: const Text('Address'), 
      content: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
              //label: const Text('Name'),
              labelText: 'Full address',
            )
          ),
          TextFormField(
            decoration: const InputDecoration(
              //label: const Text('Name'),
              labelText: 'Post code',
            )
          )
        ],
      ),
    ),    
    customStepper.Step(
      state: _currentStep == 2 
        ? customStepper.StepState.editing 
        : _currentStep >= 2
        ? customStepper.StepState.complete 
        : customStepper.StepState.indexed,
      isActive: _currentStep == 2,
      title: const Text('Done'), 
      content: Column(
        children: const [
          Text('Thank you for your payment')          
        ],
      ),
    )

  ];


}
