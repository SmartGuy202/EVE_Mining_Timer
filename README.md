# EVE_Mining_Timer
Powershell Script to calculate when to end mining cycles early for most efficient mining.

To start:
Run via powershell console.
To store stats for later use, an elevated console is required.

Setup:
The following information about your ship fit is required:
Mining laser capacity
Mininig Cycle Time
Number of Mining Lasers
Ore Hold Capacity (Currently Depreciated from internal testing)

Use:
- Enter the current asteroid's capacity in m3. No commas, no decimals.
  A survey scanner is highly recommended

- After a 3 second countdown and 4 beeps, activate all lasers on target asteroid.

- Time elapsed will be noted by 4 additional beeps.
  Laser cycle may be ended after the 4th beep.
  
- Cycle will repeat to asteroid size entry. Leave empty to end script.
