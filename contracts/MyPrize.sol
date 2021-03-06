pragma solidity >=0.8.10;
    contract MyPrize {
      struct Prize {
        uint id;
        address owner;        // current owner
        bytes10 geohash;      // current unclaimed location
        string metadata;      // probably a URL pointing to the full metadata
        uint placedAt;        // block count when it was placed
      }

      mapping (uint => Prize) public prizes;
      // Constructor
      constructor() {
        for (uint i=1; i <= 10; i++) {
            Prize memory prize = Prize({id: i, owner: msg.sender, geohash: "", metadata: "", placedAt: 0});
            prizes[i] = prize;
        }
      }

      function placePrize (uint prizeId, bytes10 geohash, string memory _metadata) public {
        Prize storage prize = prizes[prizeId];
        require (prize.id != 0);
        require (geohash != bytes10(""));
        require (prize.owner == address(0) || msg.sender == prize.owner);
        prize.owner = address(0);
        prize.geohash = geohash;
        prize.metadata = _metadata;
        prize.placedAt = block.number;
      }

      function claimPrize (uint prizeId, bytes10 geohash) public {
        Prize storage prize = prizes[prizeId];
        require (prize.id != 0);
        require (geohash != bytes10("") && prize.geohash == geohash);
        require (block.number - prize.placedAt > 1000);
        prize.owner = msg.sender;
        prize.geohash = "";
        prize.metadata = "";
        prize.placedAt = 0;
      }
    }