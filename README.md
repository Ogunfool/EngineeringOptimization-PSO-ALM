# Engineering-Optimization-Algorithms-for-pressure-vessel-and-welded-beam-design using a gradient-based algorithm; Augumented Lagrangian Multiplier (ALM) with DPN and golden search methods and Particle Swarm Optimization respectively. 
The design variables, objective functions and constraint functions are already defined, these algorithms were used to search for the best design variables to optimize the objective.
1. The Pressure Vessel Design Problem Formulation.
1.1 The Design Variables.
There are four(4) design variables:
  1. The thickness of the shell (Ts).
  2. The thickness of the head (Th).
  3. The inner radius (R).
  4. The length of the cylindrical section of the vessel, not including the head (L).
1.2 The Objective Function.
  𝑀𝑖𝑛𝑖𝑚𝑖𝑧𝑒 𝑓(𝑅, 𝐿,Ts, Th) = 0.6224Ts𝑅𝐿 + 1.7781Th𝑅2 + 3.1661(Ts)2𝐿 + 19.84(Ts)2𝑅
1.3 The Constraint Functions.
  Subject to: 0.0193𝑅 ≤ Ts
  0.00954𝑅 ≤ Th
  𝜋𝑅2𝐿 + 4/3𝜋𝑅3 ≥ 1296000
  𝐿 ≤ 240
  0.1 ≤ Ts ≤ 99
  0.1 ≤ Th ≤ 99
  10 ≤ 𝑅 ≤ 200
  10 ≤ 𝐿 ≤ 200
  
2. The Welded Beam Design Problem Formulation.
2.1 The Design Variables.
  There are four(4) design variables:
  1. The Height of weld (h).
  2. The Length of weld (L).
  3. The Height of the beam (t).
  4. The Width of the beam (b).
2.2 The Objective Function.
  𝑀𝑖𝑛𝑖𝑚𝑖𝑧𝑒 𝑓(h,L,t,b) = 1.10471ℎ2𝐿 + 0.04811t𝑏 (14.0 + 𝐿)
2.3 The Constraint Functions.
  Subject to: 𝜏 ≤ 𝜏max
  𝜎 ≤ 𝜎max
  ℎ ≤ 𝑏
  0.10471ℎ2 + 0.04811 𝑡 𝑏 (14.0 + 𝐿) ≤ 5
  0.125 ≤ ℎ
  𝛿 ≤ 𝛿max
  𝑃 ≤ 𝑃c
