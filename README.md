# Component-Design 
A simple component design made using Vivado

The project was made by Matteo Bresciani for Reti Logiche course from Politecnico of Milan

### Description 
It's a component described with VHDL that, given a greyscale image (a matrix formed by pixel from 0 to 255 values), calculate the minimum rectangle area that contain value over a threshold value.
So every pixel must be internal or belong to the perimeter of the rectangle.

### Implementation 
Component was implmented by a **Mealy Machine**. 

### TestBench
[Here](https://github.com/bresc19/Component-Design-/tree/master/TestBench) there's some testbench used to test it.

### Synthesis
- [x] **Pre-Synthesis**
- [x] **Post-Synthesis Functional**
- [x] **Post-Synthesis Timing**
- [x] **Post-Implementation Functional** (only for Clock Signal < 5 ns)
- [ ] **Post-Implementation Timing** 


For more info go to  [Document Specification (ITA)](https://github.com/bresc19/Component-Design-/blob/master/Info.pdf)
