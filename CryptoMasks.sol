// SUPPLY DISTRIBUTION INFO
// There will be 555 total nfts to ever exist
// 5 of them will be Mythic from  1 - 4 and 555th
// 25 of them will be Legendary from 5 to 29 
// 85 of them will be Epic from 30 to 114
// 155 of them will be Rare from 115 to 269
// 285 of them will be Common from 270 to 554
//
// HOW ALLOWLIST WORKS
// Owner can set wallets and their ranks in contract
// according to their levels in discord
// Wallet with rank 5 will get to mint Mythic
// Wallet with rank 4, 3, 2 or 1 will get to mint a
// Legendary, Epic, Rare or Common respectively
//
// PRESALE INFO
// 1 Mythic 4 Legendary 45 Epic 100 Rare and 150 Common
// will be availble to mint in Presale for
// 0.25 0.12 0.06 0.04 and 0.02 eth respectively
// Only allowlist users with defined ranks
// can mint during Presale
//
// GIVEAWAYS INFO
// 3 Mythic 21 Legendary 40 Epic 55 Rare and 36 Common
// are already reserved for giveaways, auctions or team
// Wallet with rank 55 can claim a free Mythic
// Wallet with rank 44, 33, 22 or 11 can claim a free
// Legendary, Epic, Rare or Common respectively
// Selected winners can claim during presale mint
//
// PUBLIC SALE INFO
// Any remaining unminted + 99 Common and 1 Mythic
// will be made availbe in Public sale for 0.03 eth flat
// one in the last 100 nfts will be a Mythic at random
// Users can only mint 1 nft / wallet
// 
// OWNER RIGHTS INFO
// Owner can update the Whitelist, update the prices,
// start / stop the sales, update the metadata,
// transfer ownership, add shareholder, withdraw balance
// 
// CONTRACT BALANCE INFO
// Withdraw will distribute all balance between following
// 20% to shareholder = 0x627137FC6cFa3fbfa0ed936fB4B5d66fB383DBE8
// 80% to owner = 0xB9aB0B590abC88037a45690a68e1Ee41c5ea7365

// SPDX-License-Identifier: GPL-3.0

// title:  Crypto Masks
// author: sadat.pk

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CryptoMasks is ERC721, ReentrancyGuard, Ownable {
    using Strings for uint256;

    uint256 public maxSupply = 555;
    uint256 public reservedSupply = 155;
    uint256 public priceCommon = 0.02 ether;
    uint256 public priceRare = 0.04 ether;
    uint256 public priceEpic = 0.06 ether;
    uint256 public priceLegendary = 0.12 ether;
    uint256 public priceMythic = 0.25 ether;
    uint256 public pricePublicSale = 0.03 ether;

    uint256 private mythicStart;
    uint256 private legendaryStart = 4;
    uint256 private epicStart = 29;
    uint256 private rareStart = 114;
    uint256 private commonStart = 269;
    
    string private ipfslink;
    string private extention = ".json";

    bool public isPaused = true;
    bool public inPresale = true;

    address private shareHolderWallet;
    uint256 private sharePercent;
    address private ownerWallet;

    mapping(address => uint256) private allowlist;
    mapping(address => uint256) private minted;

    constructor() ERC721("CryptoMasks", "CM") {
        setIpfslink("ipfs://unrevealed/");
    }

    // internal 

    modifier botCheck() {
        require(tx.origin == msg.sender, "humans only");
        _;
    }

    modifier presaleCheck() {
        require(!isPaused, "contract paused");
        require(inPresale, "presale not started");
        require(allowlist[msg.sender] > 0, "not allowed");
        _;
    }

    modifier publicSaleCheck() {
        require(!isPaused, "contract paused");
        require(!inPresale, "still presale");
        require(totalSupply() < maxSupply, "sold out");
        require(minted[msg.sender] < 1, "already minted");
        _;
    }
    modifier reserveCheck(uint256 _quantity) {
        require(_quantity <= reservedSupply, "supply n/a");
        _;
    }

    function _metaData() internal view virtual returns (string memory) {
        return ipfslink;
    }  

    // public 

    function claim() public payable botCheck() presaleCheck() {
        if (allowlist[msg.sender] == 5) {
            require(mythicStart < 4, "amount n/a");
            require(msg.value >= priceMythic, "funds n/a");
            _safeMint(msg.sender, mythicStart++);
            delete allowlist[msg.sender];
            minted[msg.sender]++;
            
        }
        if (allowlist[msg.sender] == 4) {
            require(legendaryStart < 29, "amount n/a");
            require(msg.value >= priceLegendary, "funds n/a");
            _safeMint(msg.sender, legendaryStart++);
            delete allowlist[msg.sender];
            minted[msg.sender]++;
        }
        if (allowlist[msg.sender] == 3) {
            require(epicStart < 114, "amount n/a");
            require(msg.value >= priceEpic, "funds n/a");
            _safeMint(msg.sender, epicStart++);
            delete allowlist[msg.sender];
            minted[msg.sender]++;
        }
        if (allowlist[msg.sender] == 2) {
            require(rareStart < 269, "amount n/a");
            require(msg.value >= priceRare, "funds n/a");
            _safeMint(msg.sender, rareStart++);
            delete allowlist[msg.sender];
            minted[msg.sender]++;
        }
        if (allowlist[msg.sender] == 1) {
            require(commonStart < 555, "amount n/a");
            require(msg.value >= priceCommon, "funds n/a");
            _safeMint(msg.sender, commonStart++);
            delete allowlist[msg.sender];
            minted[msg.sender]++;
        }
        if (allowlist[msg.sender] == 55) {
            require(mythicStart < 4, "amount n/a");
            require(reservedSupply > 0, "supply n/a");
            _safeMint(msg.sender, mythicStart++);
            delete allowlist[msg.sender];
            minted[msg.sender]++;
            reservedSupply--;
        }
        if (allowlist[msg.sender] == 44) {
            require(legendaryStart < 29, "amount n/a");
            require(reservedSupply > 0, "supply n/a");
            _safeMint(msg.sender, legendaryStart++);
            delete allowlist[msg.sender];
            minted[msg.sender]++;
            reservedSupply--;
        }
        if (allowlist[msg.sender] == 33) {
            require(epicStart < 114, "amount n/a");
            require(reservedSupply > 0, "supply n/a");
            _safeMint(msg.sender, epicStart++);
            delete allowlist[msg.sender];
            minted[msg.sender]++;
            reservedSupply--;
        }
        if (allowlist[msg.sender] == 22) {
            require(rareStart < 269, "amount n/a");
            require(reservedSupply > 0, "supply n/a");
            _safeMint(msg.sender, rareStart++);
            delete allowlist[msg.sender];
            minted[msg.sender]++;
            reservedSupply--;
        }
        if (allowlist[msg.sender] == 11) {
            require(commonStart < 555, "amount n/a");
            require(reservedSupply > 0, "supply n/a");
            _safeMint(msg.sender, commonStart++);
            delete allowlist[msg.sender];
            minted[msg.sender]++;
            reservedSupply--;
        }
    }

    function mint() public payable botCheck() publicSaleCheck() {
        require(msg.value >= pricePublicSale, "funds n/a");
        if (mythicStart < 4) {
            _safeMint(msg.sender, mythicStart++);
            minted[msg.sender]++;
        }
        else if (legendaryStart < 29) {
            _safeMint(msg.sender, legendaryStart++);
            minted[msg.sender]++;
        }
        else if (epicStart < 114) {
            _safeMint(msg.sender, epicStart++);
            minted[msg.sender]++;
        }
        else if (rareStart < 269) {
            _safeMint(msg.sender, rareStart++);
            minted[msg.sender]++;
        }
        else if (commonStart < 555){
            _safeMint(msg.sender, commonStart++);
            minted[msg.sender]++;
        }
    }

    function walletOfOwner(address _owner) public virtual view returns (uint256[] memory) {
        uint256 _balance = balanceOf(_owner);
        uint256[] memory _tokens = new uint256[](_balance);
        uint256 _index;
        uint256 _loopThrough = totalSupply();

        for (uint256 i = 0; i < _loopThrough; i++) {
            bool _exists = _exists(i);

            if (_exists) {
                if (ownerOf(i) == _owner) { _tokens[_index] = i; _index++; }
            }
            else if (!_exists && _tokens[_balance -1] == 0) { _loopThrough++; }
        }

        return _tokens;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
        string memory currentmetadatauri = _metaData();
        return
            bytes(currentmetadatauri).length > 0
                ? string(
                    abi.encodePacked(
                        currentmetadatauri,
                        tokenId.toString(),
                        extention
                    )
                )
                : "";
    }

    function totalSupply() public view returns (uint256) {
        uint256 m = mythicStart;
        uint256 l = legendaryStart - 4;
        uint256 e = epicStart - 29;
        uint256 r = rareStart - 114;
        uint256 c = commonStart - 269;
        uint256 totalMinted = m + l + e + r + c;
        return totalMinted;
    }

    //only owner

    function airdrop(address _wallet, uint256 _type, uint256 _quantity) public payable onlyOwner botCheck() reserveCheck(_quantity) {
        require(_type <= 5 && _type >= 1, "wrong type");
        if (_type == 5) {
            require(mythicStart + _quantity < 5, "amount n/a");
            for (uint256 i = 0; i < _quantity; i++) {
            _safeMint(_wallet, mythicStart++);
            reservedSupply--;
            }
        }
        else if (_type == 4) {
            require(legendaryStart + _quantity < 30, "amount n/a");
            for (uint256 i = 0; i < _quantity; i++) {
            _safeMint(_wallet, legendaryStart++);
            reservedSupply--;
            }
        }
        else if (_type == 3) {
            require(epicStart + _quantity < 115, "amount n/a");
            for (uint256 i = 0; i < _quantity; i++) {
            _safeMint(_wallet, epicStart++);
            reservedSupply--;
            }
        }
        else if (_type == 2) {
            require(rareStart + _quantity < 270, "amount n/a");
            for (uint256 i = 0; i < _quantity; i++) {
            _safeMint(_wallet, rareStart++);
            reservedSupply--;
            }
        }
        else if (_type == 1) {
            require(commonStart + _quantity < 556, "amount n/a");
            for (uint256 i = 0; i < _quantity; i++) {
            _safeMint(_wallet, commonStart++);
            reservedSupply--;
            }
        }
    }

    function setRanks(address[] memory addresses, uint256[] memory ranks) external onlyOwner {
        require(addresses.length == ranks.length,"length missmatch");
        for (uint256 i = 0; i < addresses.length; i++) {
        allowlist[addresses[i]] = ranks[i];
        }
    }

    function setPriceCommon(uint256 _newpriceCommon) public onlyOwner {
        priceCommon = _newpriceCommon;
    }

    function setPriceRare(uint256 _newpriceRare) public onlyOwner {
        priceRare = _newpriceRare;
    }

    function setPriceEpic(uint256 _newpriceEpic) public onlyOwner {
        priceEpic = _newpriceEpic;
    }

    function setPriceLegendary(uint256 _newpriceLegendary) public onlyOwner {
        priceLegendary = _newpriceLegendary;
    }

    function setPriceMythic(uint256 _newpriceMythic) public onlyOwner {
        priceMythic = _newpriceMythic;
    }

    function setPricePublicSale(uint256 _newpricePublicSale) public onlyOwner {
        pricePublicSale = _newpricePublicSale;
    }

    function setIpfslink(string memory _ipfslink) public onlyOwner {
        ipfslink = _ipfslink;
    }

    function setExtention(string memory _newextention) public onlyOwner {
        extention = _newextention;
    }

    function setPaused(bool _state) public onlyOwner {
        isPaused = _state;
    }

    function setPresale(bool _state) public onlyOwner {
        inPresale = _state;
    }

    function setShareHolders(address _wallet, uint256 _percent, address _wallet2) public onlyOwner {
        shareHolderWallet = _wallet;
        sharePercent = _percent;
        ownerWallet = _wallet2;
    }

    function withdrawETH() public payable onlyOwner nonReentrant {
        // send percent of balance to share holder wallet
        (bool hs, ) = payable(shareHolderWallet).call{value: (address(this).balance * sharePercent) / 100}("");
        require(hs);
        // send remaining balance to owner wallet
        (bool os, ) = payable(ownerWallet).call{value: address(this).balance}("");
        require(os);
    }
}
