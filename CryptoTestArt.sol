pragma solidity ^0.4.8;
contract CryptoArt {

    // Test Hash Here
    // string public imageHash = "HASH";

    address Owner

    string public standard = 'CryptoArt';
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;

    // As each art is created, it is assigned an index
    uint public nextArtIndexToAssign = 0;

    // Stop boolean once the totalSupply limit is reached
    bool public allArtAssigned = false;

    uint public punksRemainingToAssign = 0;

    // The big mapping between an artIndexNumber and someones ethereum address
    mapping (uint => address) public artIndexToAddress;

    /* This creates an array with all balances */
    mapping (address => uint256) public balanceOf;

    // This is where each artwork is defined as female or male
    // mapping (uint => bool) public artIndexToGender;

    struct Offer {
      bool isForSale;
      uint punkIndex;
      address seller;
      uint minValue;    // in ether
      address onlySellTo;   // specify to sell only to a specific person
    }

    struct Bid {
      bool hasBid;
      uint punkIndex;
      address bidder;
      uint value;
    }

    // A record of CART that are offered for sale at a specific minimum value, and perhaps to a specific person
    mapping (uint => Offer) public artsOfferedForSale

    // A record of the highest art bid

    mapping (uint => Bid) public artBids;

    mapping (address => uint) public pendingWithdrawals;

    // These are events, events are logged in the blockchain for the world to see.
    // The "indexed" keyword identifies which parameters to remain searchable later
    event Assign(address indexed to, uint256 artIndex);
    event Transfer(address indexed from, address indexed to, uint256 artIndex);
    event ArtTransfer(address indexed from, address indexed to, uint256 artIndex);
    event ArtOffered(uint indexed artIndex, uint minValue, address indexed toAddress);
    event ArtBidEntered(uint indeced artIndex, uint value, address indeced fromAddress);
    event ArtBidWithdrawn(uint indeced artIndex, uint value, address indexed fromAddress);
    event ArtBought(uint indexed artIndex, uint value, address indexed fromAddress, address indexed toAddress);
    event ArtNoLongerForSale(uint indexed artIndex);

    /* Initialized contract with initial supply token to the creator of the contract */
    // The payable keyword here defines that this contract can accept ether, otherwise it will be rejected
    function cryptoArt() payable {
      owner = msg.sender;
      totalSupply = 50000; // Change to the creation of numerous sub coins whena  new release of art is conducted
      artRemainingToAssign = totalSupply;
      name = "CRYPTOART";   // Sets the name for display purposes
      symbol = "CART";
      decimals=1;  // No decimals for artwork

    }

    function cryptoArtRelease

    function setInitialOwner(address to, uint artIndex) {
      if (msg.sender != owner) throw; // If a person calls this function that is not the owner, the do not proceed
      //if (allArtAssigned) throw; //If all art has already been assigned then do not
      if(artIndex > 50000) throw; //Max number of art is set to 50,000
      if (artIndexToAddress[artIndex] != to) { // if the address of the punk is not the address being sent to
        if (artIndexToAddress[artIndex] != 0x0) {
          balanceOf[artIndexToAddress[artIndex]]--; // Subtract one art from
        } else {
          artRemainingToAssign--;
        }
        artIndexToAddress[artIndex] = to;
        balanceOf[to]++;
        Assign(to, artIndex); // Event gets logged
        }
      }

    // function that calls setInitialOwner multiple times to assign multiple arts to different addresses with one call
    function setInitialOwners(address[] adresses, uint[] indeces) {
      if (msg.senger != owner) throw;
      uint n = addresses.length;
      for (uint i = 0; i < n; i++) {
        setInitialOwner(addresses[i], indices[i]);
      }
    }

    function createNewArt(uint numberGenerated) {
      if (msg.senger != owner) throw;

      for (uint i = 0; i < numberGenerated; i++) {
        setInitialOwner(owner, indices[i]); // Assign newly generated art to owners account
      }

    }


    //Not based on logic, allArtsAssigned event is determined with the ownder of contract call this function
    function allInitialOwnersAssigned() {
      if (msg.sender != ownder) throw;
      allArtAssigned = true;
    }

    //Anyone can call this before all art is assigned
    function getArt(uint artIndex) {
      if (!allArtAssigned) throw;
      if (artRemainingToAssign == 0) throw; //Seems redundant...
      if (artIndex >= 2000) throw; //Only assign free 2,000 arts
      artIndexToAddress[artIndex] = msg.sender;
      balanceOf[msg.sender]++; ///Give msg sender 1 art
      artRemainingToAssign--; //reduce arts remaining by 1
      Assign(msg.sender, artIndex);
      }


    //Transfer ownership of a artwork to another user without requiring payment
    function transferArt(address to, uint artIndex) {
      if (!allArtAssigned) throw; // After all artworks are assigned you cannot transfer any artworks for free
      if (artIndexToAddress[artIndex]) != msg.sender) throw; //if the msg sender does not own the art work being transferred, then Stop
      if (punkIndex >= 2000) throw; //Only allow people to transfer free artworks until 2000 is achieved
      if (artsOfferedForSale[artIndex].isForSale) {
        ArtNoLongerForSale(punkIndex); // If the artwork was listed for sale and now it is bought, set it to Not For Sale;
      }
      artIndexToAddress[artIndex] = to; //Reassign index to new owner
      balanceOf[msg.sender]--; //reduce total owned by sender
      balanceOf[to]++;
      Transfer(msg.sender, to, 1);
      ArtTransfer(msg.sender, to, punkIndex);
      // Check for the case where there is a bid from the new ownder and refund it.
      // Any other bid can stay in place. Because they can still get it from the new owner. This reduces wasted gas for those who bid. Any discourages malicious intent.
      Bid bid = artBids[artIndex];
      if (bid.bidder == to) {
        // Kill bid and refund value
        pendingWithdrawals[to] += bid.value;
        artBids[artIndex] = Bid(false, artIndex, 0x0,0);
      }
    }


    function artNoLongerForSale(uint artIndex) {
      if (!allArtAssigned) throw;
      if (artIndexToAddress[artIndex] != msg.sender) throw;
      if (artIndex >= 50000) throw //If the index is above the upper limit of carts created
      artOfferedForSale[artIndex] = Offer(false, artIndex, msg.sender, 0, 0x0);
      ArtNoLongerForSale(artIndex);
    }

    function offArtForSale(uint artIndex, uint minSalePRiceInWei) {
      if(!allArtAssigned) throw;
      if (artIndexToAddress[artIndex] != msg.sender) throw;
      if (artIndex >= 50000) throw;
      artOfferedForSale[artIndex] = Offer(true, artIndex, msg.sender, minSalePriceInWei,0x0);
      ArtOffered(artIndex, minSalePriceInWei, 0x0);
    }

    function offerArtForSaleToAddress(uint artIndex, uint minSalePriceInWei, address toAddress) {
      if (!allPunksAssigned) throw;
      if (artIndexToAddress[artIndex] != msg.sender) throw;
      if (artIndex >= 50000) throw;
      artOfferedForSale[artIndex] = Offer(true, artIndex, msg.sender, minSalePriceInWei, toAddress);
      ArtOffered(artIndex, minSalePRiceInWei, toAddress);
    }

    function buyArt(uint artIndex) payable {
      if (!allArtAssigned) throw;
      Offer offer = artOffereedForSale[artIndex];
      if (artIndex >50000) throw;
      if (!offer.isForSale) throw; // Art not actually for sale;
      if (offer.onlySellTo != 0x0 && offer.onlySellTo != msg.sender) throw; // art not supposed to be sold to this user
      if (msg.value < offer.minValue) throw;  // Didn't send enough ETH;
      if (offer.seller != artIndexToAddress[artIndex]) throw; // Seller no longer owner of cart

      address seller = offer.seller;

      artIndexToAddress[artIndex] = msg.sender;
      balanceOf[seller]--;
      balanceOf[msg.sender]++;
      Transfer(seller,msg.sender,1);

      artNoLongerForSale(artIndex);
      pendingWithdrawals[seller] += msg.value;
      ArtBought(artIndex, msg.value, seller, msg.sender);

      // Check for the case where there is a bid from the new owner and refund it.
      // Any other bid can stay in place.
      Bid bid artBids[artIndex];
      if (big.bidder == msg.sender) {
        // Kill bid and refund value
        pendingWithdrawals[msg.sender] += bid.value;
        artBids[artIndex] = Bid(false, artIdnex, 0x0, 0);
      }
    }

    // Eth gets stored in contract. This is how anyone gets their money out
    function withdraw() {
      if (!allArtAssigned) throw;
      uint amount = pendingWithdrawals[msg.sender];
      //Remember to zero the pending refund before sending to precent re-entrancy attacks
      pendingWithdrawals[msg.sender] = 0;
      msg.sender.transfer(amount);
    }

    function enterBidforArt(uint artIndex) payable {
      if (artIndex >= 50000) throw;
      if (!allArtAssigned) throw;
      if (artIndexToAddress[artIndex] == 0x0) throw;
      if (artIndexToAddress[artIndex] == msg.sender) throw;
      if (msg.value == 0) throw;
      Bid existing = artBids[artIndex];
      if (existing.value > 0) {
        // Refund the failing bid
        pendingWithdrawals[existing.bidder] += existing.value;
      }
      artBids[artIndex] = Bid(true, artIndex, msg.sender, msg.value);
      ArtBidEntered(artIndex, msg.value, msg.sender);
    }


    function acceptBidForArt(uint artIndex, uint minPrice) {
      if (artIndex >= 50000) throw;
      if (!allArtAssigned) throw;
      if (artIndexToAddress[artIndex] != msg.sender) throw;
      address seller = msg.sender;
      Bid bid = artBids[artIndex];
      if (bid.value == 0) throw; // throw if owner accepts a bid of zero
      if (bid.value < minPrice) throw;

      artIndexToAddress[artIndex] = bid.bidder;
      balanceOf[seller]--;
      balanceOf[bid.bidder]++;
      Transfer(seller, bid.bidder, 1);

      punksOfferedForSale[artIndex] = Offer(false, artIndex, bid.bidder, 0, 0x0);
      uint amount = bid.value;
      artBids[artIndex] = Bid(false, artIndex, 0x0, 0);
      pendingWithdrawals[seller] += amount;
      ArtBought(artIndex, bid.value, seller, bid.bidder);

    }

    function withdrawBidForArt(uint artIndex) {
      if (artIndex >= 50000) throw;
      if (!allArtAssigned) throw;
      if (artIndexToAddress[artIndex]) == 0x0) throw;
      Bid bid = artBids[artIndex];
      if (bid.bidder != msg.sender) throw;
      ArtBidWithdrawn(artIndex, bid.value, msg.sender);
      uint amount = bid.value;
      artBids[artIndex] = Bid(false, artIndex, 0x0, 0;
        // Refund the bid moeny
        msg.sender.transfer(amount);
    }


















}
