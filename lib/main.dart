// main file

import 'package:cao_finals_project/cpu_operations.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CPU Simulation',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: const Color(0xFF4a1985),
      ),
      home: const CpuSimulator(),
    );
  }
}

class CpuSimulator extends StatefulWidget {
  const CpuSimulator({super.key});

  @override
  _CpuSimulatorState createState() => _CpuSimulatorState();
}

class _CpuSimulatorState extends State<CpuSimulator> {
  final logic = CpuSimulatorLogic();

  @override
  void dispose() {
    for (var controller in logic.memoryControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CPU Simulation", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xff080121),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            // CPU Registers
            Card(
              elevation: 7,
              color: const Color(0xFFA580CA),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text("CPU Registers", style: Theme.of(context).textTheme.titleLarge),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("R1: ${logic.r1 ?? ''}", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: Colors.black)),
                        Text("R2: ${logic.r2 ?? ''}", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: Colors.black)),
                        Text("R3: ${logic.r3 ?? ''}", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: Colors.black)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Memory Grid (A1 to A10)
            Card(
              elevation: 5,
              color: const Color(0XFF9D4EDD),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text("Memory", style: Theme.of(context).textTheme.titleLarge),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: List.generate(10, (index) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("A${index + 1}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                            Container(
                              color: const Color(0xFFEBC9FF),
                              width: 60,
                              child: TextField(
                                controller: logic.memoryControllers[index],
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  setState(() {
                                    logic.memory[index] = value.isEmpty ? null : int.tryParse(value);
                                  });
                                },
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.all(8),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Row containing Operations and History Log side-by-side
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Operations Section
                  Expanded(
                    flex: 2,
                    child: Card(
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text("Operations/Instructions", style: Theme.of(context).textTheme.titleLarge),

                            const SizedBox(height: 15,),

                            const Text('Data Transfer Instructions:', 
                            style: TextStyle(fontSize: 14, 
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.italic),
                            ),


                            Row(
                              children: [
                                // Load button
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        logic.load();
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white, backgroundColor: const Color(0XFF3C0969),
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: const Text("Load"),
                                  ),
                                ),
                                Expanded(
                                  child: DropdownButton<int>(
                                    value: logic.selectedMemoryForLoad,
                                    hint: const Text("Memory", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),),
                                    items: List.generate(10, (index) {
                                      return DropdownMenuItem(
                                        value: index,
                                        child: Text("A${index + 1}"),
                                      );
                                    }),
                                    onChanged: (value) {
                                      setState(() {
                                        logic.selectedMemoryForLoad = value;
                                      });
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: DropdownButton<int>(
                                    value: logic.selectedRegisterForLoad,
                                    hint: const Text("Register", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),),
                                    items: const [
                                      DropdownMenuItem(value: 1, child: Text("R1", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),)),
                                      DropdownMenuItem(value: 2, child: Text("R2", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),)),
                                      DropdownMenuItem(value: 3, child: Text("R3", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),)),
                                    ],
                                    onChanged: (value) {
                                      setState(() {
                                        logic.selectedRegisterForLoad = value;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 10,),

                            Row(
                              children: [
                                // Store button
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        logic.store();
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white, backgroundColor: const Color(0XFF3C0969),
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: const Text("Store"),
                                  ),
                                ),
                                Expanded(
                                  child: DropdownButton<int>(
                                    value: logic.selectedRegisterForStore,
                                    hint: const Text("Register", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),),
                                    items: const [
                                      DropdownMenuItem(value: 1, child: Text("R1", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),)),
                                      DropdownMenuItem(value: 2, child: Text("R2", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),)),
                                      DropdownMenuItem(value: 3, child: Text("R3", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),)),
                                    ],
                                    onChanged: (value) {
                                      setState(() {
                                        logic.selectedRegisterForStore = value;
                                      });
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: DropdownButton<int>(
                                    value: logic.selectedMemoryForStore,
                                    hint: const Text("Memory", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),),
                                    items: List.generate(10, (index) {
                                      return DropdownMenuItem(
                                        value: index,
                                        child: Text("A${index + 1}"),
                                      );
                                    }),
                                    onChanged: (value) {
                                      setState(() {
                                        logic.selectedMemoryForStore = value;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),

                           const SizedBox(height: 20,),

                           const Text('ALU Operations:', 
                            style: TextStyle(fontSize: 14, 
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.italic),
                            ),

                            Row(
                              children: [
                                // Add button
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        logic.add();
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white, backgroundColor: const Color(0XFF3C0969),
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: const Text("Add"),
                                  ),
                                ),
                                Expanded(
                                  child: DropdownButton<int>(
                                    value: logic.addRegister1,
                                    hint: const Text("Reg 1", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),),
                                    items: const [
                                      DropdownMenuItem(value: 1, child: Text("R1", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),)),
                                      DropdownMenuItem(value: 2, child: Text("R2", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),)),
                                      DropdownMenuItem(value: 3, child: Text("R3", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),)),
                                    ],
                                    onChanged: (value) {
                                      setState(() {
                                        logic.addRegister1 = value;
                                      });
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: DropdownButton<int>(
                                    value: logic.addRegister2,
                                    hint: const Text("Reg 2", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),),
                                    items: const [
                                      DropdownMenuItem(value: 1, child: Text("R1", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),)),
                                      DropdownMenuItem(value: 2, child: Text("R2", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),)),
                                      DropdownMenuItem(value: 3, child: Text("R3", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),)),
                                    ],
                                    onChanged: (value) {
                                      setState(() {
                                        logic.addRegister2 = value;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 10,),

                            Row(
                              children: [
                                // Subtract button
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        logic.sub();
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white, backgroundColor: const Color(0XFF3C0969),
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: const Text("Subtract"),
                                  ),
                                ),
                                Expanded(
                                  child: DropdownButton<int>(
                                    value: logic.subRegister1,
                                    hint: const Text("Reg 1", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),),
                                    items: const [
                                      DropdownMenuItem(value: 1, child: Text("R1", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),)),
                                      DropdownMenuItem(value: 2, child: Text("R2", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),)),
                                      DropdownMenuItem(value: 3, child: Text("R3", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),)),
                                    ],
                                    onChanged: (value) {
                                      setState(() {
                                        logic.subRegister1 = value;
                                      });
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: DropdownButton<int>(
                                    value: logic.subRegister2,
                                    hint: const Text("Reg 2", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),),
                                    items: const [
                                      DropdownMenuItem(value: 1, child: Text("R1", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),)),
                                      DropdownMenuItem(value: 2, child: Text("R2", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),)),
                                      DropdownMenuItem(value: 3, child: Text("R3", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),)),
                                    ],
                                    onChanged: (value) {
                                      setState(() {
                                        logic.subRegister2 = value;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 30),
                            
                            const Text('Undo or Redo Operation:', 
                            style: TextStyle(fontSize: 18, 
                            fontWeight: FontWeight.w500),
                            ),
                            
                            const SizedBox(height: 10),

                            // Undo and Redo buttons
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        logic.undo(); // Call undo method
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white, backgroundColor: Color.fromARGB(255, 75, 1, 75),
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: const Text("Undo"),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        logic.redo (); // Call redo method
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white, backgroundColor: Color.fromARGB(255, 32, 1, 49),
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: const Text("Redo"),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // History Log Section
                  Expanded(
                    flex: 1,
                    child: Card(
                      elevation: 5,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("History Log", style: Theme.of(context).textTheme.titleLarge),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: logic.history.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(logic.history[index]),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Reset Button
            ElevatedButton(
              onPressed: () {
                setState(() {
                  logic.reset();
                });
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black, backgroundColor: Color.fromARGB(255, 211, 76, 182),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                child: Text("Reset", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
