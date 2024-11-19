// Cpu_Operations

import 'package:flutter/material.dart';

class CpuSimulatorLogic {
  int? r1, r2, r3;
  List<int?> memory = List.filled(10, null);
  List<TextEditingController> memoryControllers = List.generate(10, (_) => TextEditingController());
  List<String> history = [];
  List<Map<String, dynamic>> operationHistory = []; // For undo
  List<Map<String, dynamic>> redoHistory = []; // For redo

  int? selectedMemoryForLoad;
  int? selectedRegisterForLoad;
  int? selectedRegisterForStore;
  int? selectedMemoryForStore;

  int? addRegister1;
  int? addRegister2;
  int? subRegister1;
  int? subRegister2;

  void addToHistory(String operation) {
    history.add(operation);
  }

  void load() {
    if (selectedMemoryForLoad != null && selectedRegisterForLoad != null) {
      int? value = memory[selectedMemoryForLoad!];
      if (value != null) {
        switch (selectedRegisterForLoad) {
          case 1:
            r1 = value;
            break;
          case 2:
            r2 = value;
            break;
          case 3:
            r3 = value;
            break;
        }
        memory[selectedMemoryForLoad!] = null; // Clear the memory slot
        memoryControllers[selectedMemoryForLoad!].clear(); // Clear the TextField
        addToHistory("Loaded memory A${selectedMemoryForLoad! + 1} to R$selectedRegisterForLoad");
      }
    }
  }

  void store() {
    if (selectedRegisterForStore != null && selectedMemoryForStore != null) {
      int? value;
      switch (selectedRegisterForStore) {
        case 1:
          value = r1;
          break;
        case 2:
          value = r2;
          break;
        case 3:
          value = r3;
          break;
      }
      if (value != null) {
        memory[selectedMemoryForStore!] = value;
        memoryControllers[selectedMemoryForStore!].text = value.toString(); // Update the TextField
        addToHistory("Stored R$selectedRegisterForStore to memory A${selectedMemoryForStore! + 1}");
      }
    }
  }

  void add() {
    if (addRegister1 != null && addRegister2 != null) {
      int? reg1, reg2;

      // Store original values for undo
      int? originalR1 = r1;
      int? originalR2 = r2;
      int? originalR3 = r3;

      // Retrieve the values based on the selected registers
      switch (addRegister1) {
        case 1:
          reg1 = r1;
          break;
        case 2:
          reg1 = r2;
          break;
        case 3:
          reg1 = r3;
          break;
      }
      switch (addRegister2) {
        case 1:
          reg2 = r1;
          break;
        case 2:
          reg2 = r2;
          break;
        case 3:
          reg2 = r3;
          break;
      }

      // Perform addition and store the result in the first register
      if (reg1 != null && reg2 != null) {
        int result = reg1 + reg2;

        // Update the first register with the result
        switch (addRegister1) {
          case 1:
            r1 = result;
            break;
          case 2:
            r2 = result;
            break;
          case 3:
            r3 = result;
            break;
        }

        addToHistory("Added R$addRegister1 + R$addRegister2 -> R$addRegister1");

        // Save operation for undo
        operationHistory.add({
          'operation': 'add',
          'register': addRegister1,
          'originalValues': [originalR1, originalR2, originalR3],
          'result': result,
        });
        redoHistory.clear(); // Clear redo history on new operation
      }
    }
  }

  void sub() {
    if (subRegister1 != null && subRegister2 != null) {
      int? reg1, reg2;

      // Store original values for undo
      int? originalR1 = r1;
      int? originalR2 = r2;
      int? originalR3 = r3;

      // Retrieve the values based on the selected registers
      switch (subRegister1) {
        case 1:
          reg1 = r1;
          break;
        case 2:
          reg1 = r2;
          break;
        case 3:
          reg1 = r3;
          break;
      }
      switch (subRegister2) {
        case 1:
          reg2 = r1;
          break;
        case 2:
          reg2 = r2;
          break;
        case 3:
          reg2 = r3;
          break;
      }

      // Perform subtraction and store the result in the first register
      if (reg1 != null && reg2 != null) {
        int result = reg1 - reg2;

        // Update the first register with the result
        switch (subRegister1) {
          case 1:
            r1 = result;
            break;
          case 2:
            r2 = result;
            break;
          case 3:
            r3 = result;
            break;
        }

        addToHistory("Subtracted R$subRegister2 from R$subRegister1 -> R$subRegister1");

        // Save operation for undo
        operationHistory.add({
          'operation': 'subtract',
          'register': subRegister1,
          'originalValues': [originalR1, originalR2, originalR3],
          'result': result,
        });
        redoHistory.clear(); // Clear redo history on new operation
      }
    }
  }

  void undo() {
    if (operationHistory.isNotEmpty) {
      var lastOperation = operationHistory.removeLast(); // Get the last operation
      redoHistory.add(lastOperation); // Add it to the redo history

      // Restore the original values
      List<int?> originalValues = lastOperation['originalValues'];
      switch (lastOperation['register']) {
        case 1:
          r1 = originalValues[0];
          break;
        case 2:
          r2 = originalValues[1];
          break;
        case 3:
          r3 = originalValues[2];
          break;
      }

      // Remove the last entry from history as well
      if (history.isNotEmpty) {
        history.removeLast();
      }
    }
  }

  void redo() {
    if (redoHistory.isNotEmpty) {
      var lastRedoOperation = redoHistory.removeLast(); // Get the last redo operation
      operationHistory.add(lastRedoOperation); // Add it back to the operation history

      // Restore the values based on the redo operation
      switch (lastRedoOperation['operation']) {
        case 'add':
          addRegister1 = lastRedoOperation['register'];
          add(); // Reapply the addition
          break;
        case 'subtract':
          subRegister1 = lastRedoOperation['register'];
          sub(); // Reapply the subtraction
          break;
      }
    }
  }

  void reset() {
    r1 = r2 = r3 = null;
    memory.fillRange(0, memory.length, null);
    for (var controller in memoryControllers) {
      controller.clear();
    }
    operationHistory.clear();
    redoHistory.clear();
    history.clear();
  }
}