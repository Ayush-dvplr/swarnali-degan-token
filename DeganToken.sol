// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract DeganToken is ERC20 {
    address public owner;

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

    function generateNFT(string memory name, string memory url, uint256 price) external onlyOwner {
        NFTs[name] = NFT({name: name, url: url, price: price, isAvailable: true});
        allNFTs.push(name);
        emit NFTGenerated(name, url, price);
    }

    function redeem(string memory name) external {
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
