
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/babies.dart';
import 'models/dog.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Dog>(
        create: (context) => Dog(name : 'dog06' , breed : 'breed06', age: 3),
        ),
        FutureProvider<int>(
            create: (context){
              final int dogAge = context.read<Dog>().age;
              final babies = Babies(age : dogAge);
              return babies.getBabies();
            },
            initialData: 0,
        ),
        StreamProvider<String>(
            create: (context){
              final int dogAge = context.read<Dog>().age;
              final babies = Babies(age : dogAge*2);
              return babies.bark();
            },
            initialData: 'Bark 0 times'
        )
      ],
      child: MaterialApp(
        title: 'Provider 05',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: false,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Provider 05'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '-name: ${context.watch<Dog>().name}',
              // '-name: ${Provider.of<Dog>(context , listen: false).name}',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(
              height: 16.0,
            ),
            BreedAndAge(),
          ],
        ),
      ),
    );
  }
}

class BreedAndAge extends StatelessWidget {

  const BreedAndAge({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          // '-breed : ${Provider.of<Dog>(context , listen: false).breed}',
          '-breed: ${context.select<Dog,String>((Dog dog)=> dog.breed)}',
          style: TextStyle(fontSize: 20.0),
        ),
        SizedBox(height: 10.0,),
        Age(),
      ],
    );
  }
}

class Age extends StatelessWidget {

  const Age({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          // '-age : ${Provider.of<Dog>(context).age}',
          '-age: ${context.select<Dog,int>((Dog dog) => dog.age)}',
          style: TextStyle(fontSize: 20),
        ),
        SizedBox(height: 20.0,),
        Text('-number babies : ${context.watch<int>()}'),
        SizedBox(height: 20.0,),
        Text('${context.watch<String>()}',style: TextStyle(fontSize: 20.0),),
        ElevatedButton(
            onPressed: ()=> context.read<Dog>().grow(),
            child: Text('grow',style: TextStyle(fontSize: 20.0),))
      ],
    );
  }
}

