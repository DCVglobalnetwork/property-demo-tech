# 🏠 PropertyOracle – Chainlink Functions Integration

This smart contract demonstrates how to use **Chainlink Functions** to fetch off-chain property data (like price and location) and bring it **on-chain** in a simple, reliable, and gas-efficient way.  

It’s designed for real-world scenarios like real estate platforms, property valuation dApps, and insurance models that require external property data directly in smart contracts.

---

## 🔧 Features

- ✅ Fetches **off-chain property data** via Chainlink Functions  
- ✅ Stores the data on-chain in a structured format  
- ✅ Emits events for frontend integration or data indexing  
- ✅ Uses a simple, inline JavaScript Chainlink Functions source  
- ✅ Runs on Sepolia testnet (compatible with Chainlink Functions)  
- ✅ Clear and minimal for demo and learning purposes  

---

## ⚙️ Tech Stack & Dependencies

- **Solidity**: `^0.8.26`
- **Chainlink Functions SDK** (v1.3.0):
  - `FunctionsClient.sol`
  - `FunctionsRequest.sol`
- **Sepolia Testnet**
- **Remix + MetaMask** for testing
- (Optional) Hardhat for future simulation & CI

---

## 🚀 How It Works

1. Deploy the `PropertyOracle` contract using Remix or Hardhat.  
2. Add your deployed contract as a **consumer** in the [Chainlink Functions Portal](https://functions.chain.link).  
3. Call `requestPropertyData(subscriptionId, propertyId)` to fetch mock property data.  
4. The Chainlink node responds off-chain.  
5. The contract **decodes the response** and stores `id`, `value`, and `location` in the `properties` mapping.

---

## 🛠️ Deployment Guide (Remix + MetaMask)

### ✅ Step 1: Deploy Contract

- Open [Remix IDE](https://remix.ethereum.org)
- Use **Injected Provider - MetaMask**  
- Compile and deploy on **Sepolia** network  
- Ensure you have test ETH in your wallet

### ✅ Step 2: Add Consumer to Subscription

1. Visit: [https://functions.chain.link](https://functions.chain.link)
2. Select your **subscription**
3. Click **"Add consumer"**
4. Paste your contract address
5. Wait ~30 seconds for sync

### ✅ Step 3: Call `requestPropertyData`

In Remix:

```solidity
requestPropertyData(subscriptionId, 2)
```

## 🔐 Future Improvements (Advanced Version)

While this is a simplified prototype for the hackathon, the following upgrades are planned for production:

| Feature                   | Status   | Description                                         |
|---------------------------|----------|-----------------------------------------------------|
| ✅ Whitelist Access        | Planned  | Only authorized users can call request function     |
| ✅ Access Control / Owner  | Planned  | Use `Ownable` or `AccessControl` for management     |
| ✅ Request Fee Logic       | Optional | Add LINK or ETH fee per request                     |
| ✅ Request Throttling      | Optional | Prevent spam/frequent re-calls                      |
| ✅ Dynamic JS Scripts      | Future   | Allow dynamic JavaScript logic per request          |
| ✅ IPFS / External API     | Future   | Replace mocked data with real-world API or IPFS     |

---

## 📹 Demo

- ✅ Screenshots and full video demo recorded  
- ✅ Working Chainlink Functions request shown  
- ✅ Data correctly parsed and stored on-chain  

---

## 🔗 Project Links

- **Canva Design (Brochure/Slides):** [View on Canva](https://www.canva.com/design/DAGrqBWirLk/SAArdJnI_be1nVvHEw-1oQ/view?utm_content=DAGrqBWirLk&utm_campaign=designshare&utm_medium=link2&utm_source=uniquelinks&utlId=h4229c9811c)

- **Live Demo:** [https://property-demo-2025.netlify.app/](https://property-demo-2025.netlify.app/)

- **GitHub Repository:** [https://github.com/DCVglobalnetwork/property-demo](https://github.com/DCVglobalnetwork/property-demo)


## 🙌 Acknowledgements

- [🔗 Chainlink Functions Docs](https://docs.chain.link/chainlink-functions)
- [🛠 Remix IDE](https://remix.ethereum.org)
- [💧 Ethereum Sepolia Faucet](https://sepoliafaucet.com)

---

## 🧠 Summary

This project shows how simple and powerful it is to integrate **off-chain data** into a smart contract using **Chainlink Functions**. While this prototype focuses on clarity and simplicity, it’s fully extensible and can evolve into a **production-grade property oracle**.


