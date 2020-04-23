pragma solidity 0.4.26;


contract PosHelper {
    function delegateIn(address, uint256 value) public returns (bool success) {
        bytes32 f = keccak256("delegateIn(address)");
        assembly {
            let free_ptr := mload(0x40)
            mstore(free_ptr, f)
            calldatacopy(add(free_ptr, 4), 4, 32)

            let result := call(
                gas,
                0x00000000000000000000000000000000000000da,
                value,
                free_ptr,
                36,
                0,
                0
            )
            returndatacopy(free_ptr, 0, returndatasize)

            if iszero(result) {
                revert(free_ptr, returndatasize)
            }
            return(free_ptr, returndatasize)
        }
        success = true;
    }

    function delegateOut(address) public returns (bool success) {
        bytes32 f = keccak256("delegateOut(address)");
        assembly {
            let free_ptr := mload(0x40)
            mstore(free_ptr, f)
            calldatacopy(add(free_ptr, 4), 4, 32)

            let result := call(
                gas,
                0x00000000000000000000000000000000000000da,
                0,
                free_ptr,
                36,
                0,
                0
            )
            returndatacopy(free_ptr, 0, returndatasize)

            if iszero(result) {
                revert(free_ptr, returndatasize)
            }
            return(free_ptr, returndatasize)
        }
        success = true;
    }

    function callWith32BytesReturnsUint256(
        address to,
        bytes32 functionSelector,
        bytes32 param1
    ) private view returns (uint256 result, bool success) {
        assembly {
            let freePtr := mload(0x40)

            mstore(freePtr, functionSelector)
            mstore(add(freePtr, 4), param1)

            // call ERC20 Token contract transfer function
            success := staticcall(gas, to, freePtr, 36, freePtr, 32)

            result := mload(freePtr)
        }
    }

    function getRandomByEpochId(uint256 epochId) public view returns (uint256) {
        bytes32 functionSelector = keccak256(
            "getRandomNumberByEpochId(uint256)"
        );

        (uint256 result, bool success) = callWith32BytesReturnsUint256(
            0x262,
            functionSelector,
            bytes32(epochId)
        );

        require(success, "ASSEMBLY_CALL getRandomByEpochId failed");

        return result;
    }

    function getRandomByBlockTime(uint256 blockTime)
        public
        view
        returns (uint256)
    {
        bytes32 functionSelector = keccak256(
            "getRandomNumberByTimestamp(uint256)"
        );

        (uint256 result, bool success) = callWith32BytesReturnsUint256(
            0x262,
            functionSelector,
            bytes32(blockTime)
        );

        require(success, "ASSEMBLY_CALL getRandomByBlockTime failed");

        return result;
    }

    function getEpochId(uint256 blockTime) public view returns (uint256) {
        bytes32 functionSelector = keccak256("getEpochId(uint256)");

        (uint256 result, bool success) = callWith32BytesReturnsUint256(
            0x262,
            functionSelector,
            bytes32(blockTime)
        );

        require(success, "ASSEMBLY_CALL getEpochId failed");

        return result;
    }
}