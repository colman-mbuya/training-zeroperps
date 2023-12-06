// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC4626} from "@openzeppelin/contracts/token/ERC20/extensions/ERC4626.sol";
import {IPyth} from "@pyth-sdk-solidity/Ipyth.sol";
import {PythStructs} from "@pyth-sdk-solidity/PythStructs.sol";


contract ZeroPerps is ERC4626 {
    //================================================================
    // Storage Design
    //================================================================
    //

    IPyth pyth;
    bytes32 s_btcPriceId;


    // Taken from https://github.com/pyth-network/pyth-crosschain/blob/bbd3d1add3b58b257309810828d996a9257c10dd/target_chains/ethereum/examples/oracle_swap/contract/src/OracleSwap.sol#L93
    function convertToUint(PythStructs.Price memory price, uint8 targetDecimals) private pure returns (uint256) {
        if (price.price < 0 || price.expo > 0 || price.expo < -255) {
            revert();
        }

        uint8 priceDecimals = uint8(uint32(-1 * price.expo));

        if (targetDecimals >= priceDecimals) {
            return
                uint(uint64(price.price)) *
                10 ** uint32(targetDecimals - priceDecimals);
        } else {
            return
                uint(uint64(price.price)) /
                10 ** uint32(priceDecimals - targetDecimals);
        }
    }

    constructor(ERC20 _asset, address _pythAddr, bytes32 _btcPriceId) ERC4626(_asset) ERC20("Zero", "ZERO") {
        pyth = IPyth(_pythAddr);
        s_btcPriceId = _btcPriceId;
     }

     function _getLatestBtcPrice(bytes[] memory updateData) internal returns (uint256) {
        uint256 updateFee = pyth.getUpdateFee(updateData);
        pyth.updatePriceFeeds{value: updateFee}(updateData);
        PythStructs.Price memory btcPrice = pyth.getPrice(s_btcPriceId);
        return convertToUint(btcPrice, 18);
     }

}
