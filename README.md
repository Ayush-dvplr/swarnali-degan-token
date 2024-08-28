# DeganToken Smart Contract

This Solidity program is a simple DeganToken contract that demonstrates the basic syntax and functionality of the Solidity programming language. The purpose of this program is to serve as a starting point for those who are new to Solidity and want to get a feel for how it works.

## Description

This program is a basic DeganToken smart contract written in Solidity for the Ethereum blockchain. It includes essential functionalities such as minting, burning, and transferring ERC20 tokens. Additionally, the contract allows owners to create and manage unique NFTs, which players can redeem using the contract's tokens. This contract serves as a straightforward introduction to Solidity programming and provides a foundation for more complex blockchain projects.

We are also going to use react and web3 to connect our blockchain to frontend.

## Usage/Examples

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract DeganToken is ERC20 {
    address public owner;
    address public storeAddress;

    struct NFT {
        string name;
        string url;
        bool isAvailable;
        uint256 price;
    }

    mapping(string => NFT) public NFTs;
    string[] public allNFTs;

    // Mapping to store NFTs bought by each user
    mapping(address => string[]) public userNFTs;

    // Events
    event Minted(address indexed to, uint256 amount);
    event Burned(address indexed from, uint256 amount);
    event StoreAddressSet(address indexed storeAddress);
    event NFTGenerated(string name, string url, uint256 price);
    event Redeemed(address indexed from, string name);

    constructor() ERC20("DeganToken", "DGN") {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
        emit Minted(to, amount);
    }

    function burn(uint256 amount) external onlyOwner {
        _burn(msg.sender, amount);
        emit Burned(msg.sender, amount);
    }

    function setStoreAddress(address _storeAddress) external onlyOwner {
        storeAddress = _storeAddress;
        emit StoreAddressSet(_storeAddress);
    }

    function generateNFT(string memory name, string memory url, uint256 price) external onlyOwner {
        NFTs[name] = NFT({name: name, url: url, price: price, isAvailable: true});
        allNFTs.push(name);
        emit NFTGenerated(name, url, price);
    }

    function redeem(string memory name) external {
        require(storeAddress != address(0), "Store address not set");
        require(balanceOf(msg.sender) >= NFTs[name].price, "Insufficient payment");

        _burn(msg.sender, NFTs[name].price);
        NFTs[name].isAvailable = false;
        userNFTs[msg.sender].push(name);

        emit Redeemed(msg.sender, name);
    }

    function getAllNFTs() external view returns (string[] memory) {
        return allNFTs;
    }

    function getUserNFTs() external view returns (string[] memory) {
        return userNFTs[msg.sender];
    }
}

```

## Run Locally

Clone the project

```bash
  git clone https://github.com/Ayush-dvplr/degan-token.git
```

Go to the project directory

```bash
  cd degan-token
```

Go to the frontend directory from another terminal

```bash
  cd frontend
```

Install dependencies

```bash
  npm install
```

Start frontend from the terminalin frontend directory

```bash
  npm start
```

## Screenshots

![App Screenshot](https://res.cloudinary.com/dsprifizw/image/upload/v1722454124/degan-token-home1.png)
![App Screenshot](https://res.cloudinary.com/dsprifizw/image/upload/v1722454124/degan-token-home2.png)

## Lessons Learned

- Integrate Solidity contracts with React using Hardhat and ensure ABI compatibility

- Utilize React hooks like useState and useEffect for efficient state management and handling blockchain interactions

- Gas Efficiency: Understanding gas implications of error handling helps design more efficient contracts.

- Design smart contracts to minimize gas costs and ensure reliable data storage and retrieval

## Author

- Ayush sah[@linkedin](https://www.linkedin.com/in/ayushsah404/)
