# FMCW Radar Digital Signal Processing (DSP) & Target Tracking

An end-to-end Frequency Modulated Continuous Wave (FMCW) radar signal processing pipeline implemented in **MATLAB** and **Simulink**. This repository models the complete processing chain from raw chirp generation to dechirping, Range-Doppler extraction, Direction of Arrival (AoA) beamforming, adaptive CFAR detection, and state-space Kalman filter tracking.

---

## 📌 Project Overview

Modern FMCW radar systems are fundamental in automotive ADAS, aerospace, and defense applications. This project implements the core radar signal processing chain in software simulations and streaming models:

```
[Chirp Generation (TX)] ──► [Target Reflection & Delay] ──► [Dechirping (Mixer + LPF)]
                                                                    │
                                                                    ▼
[Kalman Filter Tracking] ◄── [1D/2D CA-CFAR Detection] ◄── [Range-Doppler-AoA (3D FFT)]
```

### Key Milestones Completed
- **Stage 1 (Beat Signal Recovery):** Single chirp FMCW transmission, dechirping, low-pass filtering, and beat frequency extraction.
- **Stage 2 (Radar Processing Chain):** Coherent chirp train stacking, 2D FFT for Range-Doppler maps, and phase-based beamforming for Angle of Arrival (AoA) estimation across a Uniform Linear Array (ULA).
- **Stage 2 (Adaptive Detection):** Custom 1D and 2D Cell Averaging Constant False Alarm Rate (CA-CFAR) algorithms with configurable training and guard cells.
- **Stage 2.5 (Target Tracking):** Kinematic Kalman filters (1D Range tracking and 2D Range + Velocity state estimation) for smoothing noisy CFAR detections.
- **Stage 3 (Simulink Frame-Based Architecture):** Streaming radar model (`FMCW_model.slx`) featuring frame buffering, rate transitions, and real-time DSP blocks.

---

## 📂 Repository Structure

```
Radar DSP/
├── FMCW_Radar_Learning_Roadmap.md  # 80/20 Concept Roadmap & industry benchmark milestones
├── Matlab/                         # Algorithmic reference implementations
│   ├── Single_Chirp.m              # Single chirp dechirping & beat frequency validation
│   ├── Chirp_Train.m               # Multi-chirp train, 2D FFT & 2D CFAR processing
│   ├── FMCW_Reference_Model.m      # 3D Reference Model (Range x Doppler x Angle)
│   ├── AoA_estimation.m            # ULA antenna array simulation & beamforming
│   ├── CFAR_1D.m                   # 1D Cell-Averaging CFAR detector function
│   ├── CFAR_2D.m                   # 2D Cell-Averaging CFAR detector function
│   ├── Kalman_filter_1D.m          # 1D constant-velocity Kalman filter (Range only)
│   └── Kalman_filter_2D.m          # 2D Kalman filter (Joint Range & Velocity state)
├── Simulink/                       # Streaming & frame-based system modeling
│   ├── FMCW_model.slx              # End-to-end FMCW radar processing system
│   └── buffer_test.slx             # Frame buffering and rate transition testbench
└── AI-Learning-Toolkit/            # Active-recall & inquiry-based learning workflows
    ├── README.md                   # Toolkit guidelines and workflow documentation
    ├── learning/                   # Concept logs, error post-mortems, and Q&A
    └── .agents/                    # Prompts, rules, and companion workflows
```

---

## 🔬 Core Algorithms & DSP Principles

### 1. FMCW Chirp & Beat Frequency
A linear frequency-modulated chirp is transmitted with bandwidth $B$ and duration $T_c$. Mixing the received reflected signal with the reference chirp collapses the time delay $\tau = \frac{2R}{c}$ into an intermediate beat frequency $f_b$:
$$f_b = \frac{B}{T_c} \tau = \frac{2 B R}{c T_c}$$
Range resolution is determined strictly by the sweep bandwidth:
$$\Delta R = \frac{c}{2B}$$

### 2. Range-Doppler Processing (2D FFT)
- **Fast-Time (Within Chirp):** Sampled along ADC samples of a single chirp; 1D FFT yields range bins.
- **Slow-Time (Across Chirps):** Sampled across $N_{\text{chirps}}$ successive chirps; phase shift $\Delta \phi = 2\pi f_d T_c$ yields Doppler frequency:
$$v = \frac{\lambda f_d}{2}$$

### 3. Angle of Arrival (AoA) & Beamforming
Simulated using a Uniform Linear Array (ULA) of sensors spaced by $d = \frac{\lambda}{2}$. An incident wave at azimuth angle $\theta$ causes an inter-element phase shift:
$$\Delta \phi = \frac{2\pi d}{\lambda} \sin\theta$$
Spatial FFT / Bartlett beamforming across the receiver channels isolates the spatial angle bin.

### 4. Constant False Alarm Rate (CA-CFAR) Detection
To detect targets against fluctuating thermal noise and clutter, dynamic adaptive thresholds are calculated over sliding windows:
- **Training Cells ($T$):** Average local background noise floor.
- **Guard Cells ($G$):** Prevent target power leakage from polluting the noise estimate.
- **Detection Decision:**
$$\text{Threshold} = P_{\text{noise}} \times \alpha$$
Implemented in both 1D (`CFAR_1D.m`) and 2D (`CFAR_2D.m`) for Range-Doppler surfaces.

### 5. Kinematic Target Tracking (Kalman Filter)
Noisy peak detections are tracked across radar frames using a linear constant-velocity state space model:
- **State Vector:** $\mathbf{x} = \begin{bmatrix} R \\ v \end{bmatrix}$
- **State Transition:** $\mathbf{x}_k = \begin{bmatrix} 1 & \Delta t \\ 0 & 1 \end{bmatrix} \mathbf{x}_{k-1} + \mathbf{w}_k$
- **Measurement Matrix:** $\mathbf{z}_k = \mathbf{H} \mathbf{x}_k + \mathbf{v}_k$
Smooths sensor measurement variance, suppresses outliers, and maintains continuous target state tracks over time.

---

## 🚀 Getting Started

### Prerequisites
- **MATLAB** (R2021b or newer recommended)
- **Simulink**
- **Signal Processing Toolbox**
- **DSP System Toolbox** (optional, recommended for Simulink DSP blocks)

### Running the Scripts

1. **3D FMCW Reference Model (Range / Doppler / AoA):**
   ```matlab
   run('Matlab/FMCW_Reference_Model.m')
   ```
   *Computes a 3D FFT across 128 chirps and 8 virtual antenna channels, displaying extracted Range, Doppler, and Angle bins.*

2. **2D Range-Doppler & CFAR Detection:**
   ```matlab
   run('Matlab/Chirp_Train.m')
   ```
   *Generates chirp returns, applies 2D FFT, and outputs binary detection maps via 2D CA-CFAR.*

3. **Multi-Channel Angle of Arrival:**
   ```matlab
   run('Matlab/AoA_estimation.m')
   ```
   *Simulates multi-receiver phase offsets and plots the spatial beamforming response.*

4. **Kalman Filter Target Tracking:**
   ```matlab
   run('Matlab/Kalman_filter_2D.m')
   ```
   *Simulates noisy radar measurement blips and plots true path vs. filtered range and velocity state estimates.*

5. **Simulink Model:**
   Open and run `Simulink/FMCW_model.slx` in MATLAB to inspect frame-based buffering, spectrum analysis, and streaming CFAR blocks.

---

## 🗺️ Roadmap & Next Steps

Refer to [FMCW_Radar_Learning_Roadmap.md](FMCW_Radar_Learning_Roadmap.md) for detailed milestone breakdowns:

- [x] **Stage 1:** Single chirp simulation, dechirping, beat frequency extraction
- [x] **Stage 2:** 2D FFT Range-Doppler maps, CA-CFAR detection, multi-channel AoA beamforming
- [x] **Stage 2.5:** 1D & 2D Kalman filter state tracking & measurement filtering
- [x] **Stage 3:** Frame-based streaming architecture & Simulink model implementation
- [ ] **Stage 4:** Fixed-Point Analysis (Q-format quantization, SNR degradation, overflow/saturation)
- [ ] **Stage 5:** Hardware Description Language (HDL / Verilog implementation of Range FFT / FIR engine)
- [ ] **Stage 6:** FPGA-in-the-Loop testbench verification

---

## 📄 License

This repository is maintained for research, educational, and portfolio purposes.
