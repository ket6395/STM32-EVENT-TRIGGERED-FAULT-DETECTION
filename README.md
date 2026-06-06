# STM32-Based Event-Triggered Real-Time Monitoring and Fault Detection System
## Overview
This project demonstrates the design, simulation, and embedded implementation of an Event-Triggered Monitoring and Fault Detection System.
The workflow begins with MATLAB-based validation of an event-triggered control strategy and is then deployed on an STM32F412ZG microcontroller using Embedded C.
Unlike conventional periodic execution, computations are performed only when significant changes occur, reducing unnecessary processing while maintaining system performance.

---

## Project Workflow

```text
MATLAB Simulation
        ↓
Event Trigger Validation
        ↓
Disturbance Injection
        ↓
Performance Analysis
        ↓
STM32 Deployment
        ↓
Real-Time Monitoring
        ↓
Fault Detection & State Indication
```

---

## MATLAB Validation

The event-triggered algorithm was first validated in MATLAB using a state-space plant model with communication delay and injected disturbances.

### Simulation Features

- Event-triggered control
- Periodic control comparison
- Communication delay modelling
- Disturbance injection
- Fault monitoring
- Event execution statistics
- Inter-event interval analysis

### System Parameters

| Parameter | Value |
|------------|---------|
| Sampling Time | 100 µs |
| Simulation Time | 2 s |
| Communication Delay | 5 ms |
| Trigger Threshold | 0.04 |
| Disturbance Time | 1 s |

---

## MATLAB Results

| Metric | Value |
|----------|---------|
| Total Simulation Steps | 20,001 |
| Control Executions | 29 |
| Event Execution Rate | 0.14 % |
| Average Inter-Event Time | 65 ms |
| Detection Latency | 100 ms |

The event-triggered controller successfully maintained system stability while requiring significantly fewer control updates than a conventional periodic controller.

---

## Event Triggering Behaviour

![Event Trigger Condition](Event%20Triggering%20condition%20with%20disturbance.png)

---

## Event-Triggered vs Periodic Control

![Event Triggered vs Periodic](Event%20Triggered%20VS%20Periodic%20Control.png)

---

## Inter-Event Intervals

![Inter Event Intervals](Inter_event%20intervals.png)

---

## Event Distribution

![Event Distribution](Event%20Distribution%20over%20time.png)

---

## System Health Monitoring

![Health Monitoring](System%20Health%20Monitoring.png)

---

## Fault Detection Timeline

![Fault Timeline](Fault%20Detection%20Timeline.png)

---

## MATLAB Results Summary

![Results](Results.png)

---

## STM32 Hardware Implementation

The validated MATLAB algorithm was deployed on an STM32F412ZG microcontroller using Embedded C.

### Implemented Features

- Internal temperature sensor acquisition
- Event-triggered scheduling
- Temperature change detection (ΔT)
- Moving average computation
- Variance calculation
- Fault counting



---


---



---

## Repository Structure

```text
STM32-EVENT-TRIGGERED-FAULT-DETECTION
│
├── event_triggered.m
├── Results.png
├── Event Triggering condition with disturbance.png
├── Event Triggered VS Periodic Control.png
├── Inter_event intervals.png
├── Event Distribution over time.png
├── System Health Monitoring.png
├── Fault Detection Timeline.png
└── README.md
```

---

## Tools and Technologies
- MATLAB
- State-Space Modelling
- Event-Triggered Control
- Fault Detection
- Real-Time Monitoring


---

## Future Improvements

- External sensor integration
- TinyML-based anomaly detection
- CAN communication support
- FreeRTOS integration
- Real-time dashboard visualization

---

