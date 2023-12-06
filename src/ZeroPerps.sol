// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC4626} from "@openzeppelin/contracts/token/ERC20/extensions/ERC4626.sol";


contract ZeroPerps is ERC4626 {
    //================================================================
    // Storage Design
    //================================================================
    //

    constructor(ERC20 _asset) ERC4626(_asset) ERC20("Zero", "ZERO") { }

}
