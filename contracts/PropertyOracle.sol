// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

// Importing Chainlink FunctionsClient to interact with Chainlink Functions
import {FunctionsClient} from "@chainlink/contracts/src/v0.8/functions/v1_0_0/FunctionsClient.sol";
import {FunctionsRequest} from "@chainlink/contracts/src/v0.8/functions/v1_0_0/libraries/FunctionsRequest.sol";

/// @title PropertyOracle
/// @notice A Chainlink Functions consumer contract that fetches off-chain property data
///         using Chainlink Functions on Sepolia testnet.
/// @dev The contract requests encoded property data and updates on-chain storage upon fulfillment.
contract PropertyOracle is FunctionsClient {
    using FunctionsRequest for FunctionsRequest.Request;

    /// @notice Struct to represent property details
    struct Property {
        uint256 id; // Unique property identifier
        uint256 value; // Property monetary value
        string location; // Property location description
    }

    /// @notice Mapping to store properties by their ID
    mapping(uint256 => Property) public properties;

    /// @notice Track the last Chainlink Functions request ID
    bytes32 public s_lastRequestId;

    /// @notice Store the last raw response bytes returned from Chainlink node
    bytes public s_lastResponse;

    /// @notice Store any error returned from Chainlink node
    bytes public s_lastError;

    // Chainlink Functions router contract address on Sepolia
    address constant ROUTER = 0xb83E47C2bC239B3bf370bc41e1459A34b41238D0;

    // Decentralized Oracle Network (DON) ID for Chainlink Functions
    bytes32 constant DON_ID =
        0x66756e2d657468657265756d2d7365706f6c69612d3100000000000000000000;

    // Maximum gas limit for the fulfillment callback
    uint32 constant gasLimit = 300_000;

    /// @notice Inline JavaScript source code for Chainlink Functions
    ///         Returns mock property data encoded as bytes:
    ///         - Property ID: 12345 (uint256)
    ///         - Property Value: 1,495,000 (uint256)
    ///         - Location: "London" (string)
    string public constant SOURCE =
        "return Functions.encodeUint256(12345)"
        "+Functions.encodeUint256(1495000)"
        "+Functions.encodeString('London');";

    /// @notice Emitted when a Chainlink Functions request is sent
    /// @param requestId The unique identifier of the request
    /// @param propertyId The ID of the property requested
    event RequestSent(bytes32 indexed requestId, uint256 indexed propertyId);

    /// @notice Emitted when property data is received or when an error occurs
    /// @param requestId The unique identifier of the request
    /// @param id The property ID returned by the oracle (0 if error)
    /// @param value The property value returned by the oracle (0 if error)
    /// @param location The property location string (empty if error)
    /// @param rawResponse The raw bytes returned from the oracle
    /// @param error The error bytes returned from the oracle (empty if no error)
    event PropertyDataReceived(
        bytes32 indexed requestId,
        uint256 indexed id,
        uint256 value,
        string location,
        bytes rawResponse,
        bytes error
    );

    /// @notice Contract constructor, initializes Chainlink Functions client with router address
    constructor() FunctionsClient(ROUTER) {}

    /// @notice Initiates a Chainlink Functions request to fetch property data
    /// @param subscriptionId The Chainlink subscription ID used for billing
    /// @param propertyId The property ID for which data is requested (not currently used in the request)
    /// @return requestId The unique identifier for the Chainlink request
    function requestPropertyData(
        uint64 subscriptionId,
        uint256 propertyId
    ) external returns (bytes32) {
        // Build and send the request to Chainlink Functions network
        s_lastRequestId = _sendRequest(
            _buildRequest(),
            subscriptionId,
            gasLimit,
            DON_ID
        );
        emit RequestSent(s_lastRequestId, propertyId);
        return s_lastRequestId;
    }

    /// @notice Internal helper to construct the Chainlink Functions request payload
    /// @dev Encodes the inline JavaScript source into CBOR format required by Chainlink node
    /// @return Encoded request bytes in CBOR format
    function _buildRequest() internal pure returns (bytes memory) {
        FunctionsRequest.Request memory req;
        req.initializeRequestForInlineJavaScript(SOURCE);
        return req.encodeCBOR();
    }

    /// @notice Callback function called by Chainlink node upon request fulfillment
    /// @dev Decodes the response or handles errors, updates property mapping and emits event
    /// @param requestId The ID of the request being fulfilled
    /// @param response The raw bytes response from the Chainlink oracle
    /// @param err The raw bytes error returned if request failed
    function fulfillRequest(
        bytes32 requestId,
        bytes memory response,
        bytes memory err
    ) internal override {
        // Ensure the fulfillment corresponds to the last sent request
        require(requestId == s_lastRequestId, "Unexpected requestId");

        // Store the raw response and error bytes
        s_lastResponse = response;
        s_lastError = err;

        if (err.length == 0) {
            // Decode response into Property data
            (uint256 id, uint256 val, string memory loc) = abi.decode(
                response,
                (uint256, uint256, string)
            );

            // Update on-chain property mapping
            properties[id] = Property(id, val, loc);

            // Emit event with decoded property data
            emit PropertyDataReceived(requestId, id, val, loc, response, err);
        } else {
            // Emit event with error details but no property data
            emit PropertyDataReceived(requestId, 0, 0, "", response, err);
        }
    }
}
