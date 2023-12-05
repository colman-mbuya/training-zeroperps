# Zero Perps

A simple perpertual market implementation built to hopefully gain a deeper understanding of DeFi perpetual markets.

## Progress & Roadmap
- [] Smart Contract(s) with the following functionalities, with corresponding tests:
    - [] Liquidity Providers can deposit and withdraw liquidity.
    - [] A way to get the realtime price of the asset being traded.
    - [] Traders can open a perpetual position for BTC, with a given size and collateral.
    - [] Traders can increase the size of a perpetual position.
    - [] Traders can increase the collateral of a perpetual position.
    - [] Traders cannot utilize more than a configured percentage of the deposited liquidity.
    - [] Liquidity providers cannot withdraw liquidity that is reserved for positions.
- [] README
    - [] How does the system work? How would a user interact with it?
    - [] What actors are involved? Is there a keeper? What is the admin tasked with?
    - [] What are the known risks/issues?
    - [] Any pertinent formulas used.
- [] Security & Testing 
    - [] Review the [ERC4626 security blog by OZ](https://docs.openzeppelin.com/contracts/4.x/erc4626)
    - [] Review OZ testsuite for ERC4626 -> lib/openzeppelin-contracts/lib/erc4626-tests/ERC4626.test.sol