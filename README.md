# Smart Watering System — IoT Precision Agriculture Project

An automated, energy-efficient, and secure Smart Irrigation system designed for Precision Agriculture. This project shifts field management from traditional static timers (e.g., scheduled clock activation) to **Dynamic Real-Time Monitoring** driven by environmental data processed directly at the network edge.

The system was fully modeled, programmed, and simulated using the **CupCarbon** IoT simulation environment.

---

## 🚀 Concept & Overview
Traditional irrigation systems waste significant water and risk crop health by spraying on rigid schedules, regardless of actual weather conditions. This project implements an **Automated Decision-Making** framework that monitors environmental parameters and activates field sprinklers based on real-time data thresholds:
- **Heat ($C$):** Measured as ambient temperature in Degrees Celsius (°C).
- **Precipitation ($P$):** Measured as rainfall intensity in Millimeters per hour (mm/h).

### 🧠 Control Logic
The core decision rule resides directly on the sensor node. Irrigation is triggered **if and only if** the temperature is critically high and the rain is insufficient to naturally compensate:
$$\text{Temperature} > 28^\circ\text{C} \quad \text{AND} \quad \text{Rainfall} < 5\text{ mm/h}$$

---

## 🏗️ Network Architecture & Node Roles
The deployment implements a specialized sensor network composed of three distinct functional nodes executing discrete scripts:

1. **Sensor Node (`sensor.csc`):**
   - Collects environmental data from the surroundings (modeled via analog events).
   - Hosts the **Edge Intelligence** script to compute activation commands locally.
   - Restricts transmissions to status-change events only.
2. **Router Node (`router.csc`):**
   - Acts as a multi-hop relay using **Controlled Flooding** to propagate commands.
   - Includes memory cache validation to drop duplicated or echo packets, preventing broadcast storms.
3. **Sprinkler/Actuator Node (`sprinkler.csc`):**
   - Receives target commands (`1` for ON, `0` for OFF) to manipulate field valves.
   - Visually changes state in the simulation workspace (`mark 1` / `mark 0`).

---

## ⚡ Energy Efficiency & Sustainability
A primary constraint of wireless sensor networks is battery autonomy. This architecture implements key optimizations resulting in an estimated operational lifespan of **> 5 Years** (factoring a realistic 3% annual battery chemical self-discharge):

- **Edge Computing Strategy:** Processing logic locally on the sensor node avoids streaming raw telemetry continuously to the cloud, eliminating heavy radio traffic.
- **Event-Driven Transmission:** Data is dispatched *only upon a state change* (e.g., moving from an OFF state to an ON state). Continuous streams of repeated "ON-ON-ON" values are filtered out natively, drastically reducing energy expenditure ($E_{tx}$).
- **Adaptive Control:** Supports scalable transmission power level configuration (`atpl`) based on field coverage needs.

---

## 🛡️ Risk Mitigation & Local Failsafe
Relying on wireless connectivity introduces risks. If a sprinkler node receives a `WATER ON` command and subsequently loses communication (due to interference, battery drain of a router, or packet drops), it would never receive the `OFF` token, resulting in severe field flooding and crop damage.

### 💡 The Solution: Local Failsafe Script
The actuator node includes a dedicated localized background process:
- **Keep-Alive Protocol:** The central sensor node is required to periodically broadcast a refresh token when the environment remains critical.
- **Auto-Shutdown Timer:** An internal counter (`safety_timer`) increments on the sprinkler node. If no valid message refreshes the state within a predefined safety window (60 cycles), the node executes a **forced local shutdown**, prioritizing ecological and operational safety.
