# STM32-Based Event-Triggered Real-Time Monitoring and Fault Detection System

## Overview

This project implements an event-triggered monitoring framework validated in MATLAB and deployed on STM32F412ZG.

Instead of executing control updates periodically, the system updates only when an event-trigger condition is satisfied, reducing unnecessary computations.

## MATLAB Validation

Features:

- Event-triggered control
- Communication delay modeling
- Disturbance injection
- Fault monitoring
- Health monitoring
- Periodic control comparison

## Results

- Total Simulation Steps: 20001
- Control Executions: 29
- Average Inter-Event Time: 65 ms
- Detection Latency: 100 ms

The event-triggered controller achieved performance comparable to periodic control while significantly reducing control update frequency.
