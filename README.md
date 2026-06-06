# Sequence-Detector-Final-Project-Sisdig

A Mealy finite state machine (FSM) written in VHDL that detects the bit
sequence **`1011`** in a serial input stream, with **overlapping** detection
support. The project includes the design entity and a self-driving testbench.

## Team members

- Kayyisah Ajda (25/558763/PA/23486)
- Rameyza Charisa Putri Primantoko (25/569972/PA/24024)
- Mazaya Nurina (25/554758/PA/23236)
- Naomi Shakilla Isbono (25/559065/PA/23502)

---

## Overview

The detector reads one bit per clock cycle on the `din` input. Whenever the
pattern `1011` has just appeared (most recent four bits), the `detected` output
is asserted high for that cycle. Because detection is overlapping, the trailing
`1` of one match can serve as the leading `1` of the next match — so an input
stream like `1011011` produces **two** detections.

---

## Module interface

| Port       | Direction | Type        | Description                          |
|------------|-----------|-------------|--------------------------------------|
| `clk`      | in        | `STD_LOGIC` | Clock; state updates on rising edge  |
| `reset`    | in        | `STD_LOGIC` | Asynchronous reset (active high)     |
| `din`      | in        | `STD_LOGIC` | Serial input bit                     |
| `detected` | out       | `STD_LOGIC` | High for one cycle when `1011` found |

---

## FSM design

The machine uses four states that track how much of the `1011` pattern has been
matched so far:

| State  | Meaning                              |
|--------|--------------------------------------|
| `S0`   | No progress (nothing matched yet)    |
| `S1`   | Matched `1`                          |
| `S10`  | Matched `10`                         |
| `S101` | Matched `101` — one more `1` to go   |

It is a **Mealy** machine: `detected` depends on both the current state and the
current input. The pulse is asserted while in `S101` with `din = 1`, at the same
moment the machine transitions back to `S1` (enabling overlap).

### State transition diagram

```
                 din=1
        ┌───────────────────────┐
        │                       │
        v          din=1        │   din=0
      ┌────┐      ┌────┐      ┌──────┐      ┌──────┐
 ───> │ S0 │ ───> │ S1 │ ───> │ S10  │ ───> │ S101 │
      └────┘ din=1└────┘ din=0└──────┘ din=1└──────┘
        ^           ^             │            │ │
        │           │             │ din=1      │ │ din=1 / detected=1
        │ din=0      │ din=1       └────────────┘ │ (back to S1, overlap)
        └────────────┴───────────────────────────┘
                       din=0 (back toward S10/S0)
```

Transition summary:

| Current | `din` | Next   | `detected` |
|---------|-------|--------|------------|
| `S0`    | 0     | `S0`   | 0          |
| `S0`    | 1     | `S1`   | 0          |
| `S1`    | 0     | `S10`  | 0          |
| `S1`    | 1     | `S1`   | 0          |
| `S10`   | 0     | `S0`   | 0          |
| `S10`   | 1     | `S101` | 0          |
| `S101`  | 0     | `S10`  | 0          |
| `S101`  | 1     | `S1`   | **1**      |

---

## Files

| File                        | Description                              |
|-----------------------------|------------------------------------------|
| `sequence_detector.vhd`     | FSM design (entity + architecture)       |
| `tb_sequence_detector.vhd`  | Self-checking testbench / stimulus       |

---

## Testbench stimulus

The testbench applies a 20 ns clock period (10 ns high / 10 ns low), holds
`reset` high for the first 20 ns, then feeds the input stream:

```
din:  1  0  1  1  0  1  1
```

This contains two overlapping `1011` patterns, so `detected` pulses **twice** —
once after the first `1011`, and again after the overlapping `1011`.

---

## Waveform

After running the simulation, export or capture the waveform, then add it
to the repository and reference it here:

```markdown
![Simulation waveform](docs/waveform.png)
```

Expected behaviour: `detected` goes high for exactly one clock cycle at each of
the two pattern completions described above.

---

## Notes

- Written for VHDL-2008.
- `reset` is asynchronous and active high.
- In the testbench, `din` transitions align with the clock edges; for a more
  realistic setup that avoids edge-sampling races, change inputs mid-period
  (e.g. `wait for 5 ns; din <= '1'; wait for 15 ns;`).
