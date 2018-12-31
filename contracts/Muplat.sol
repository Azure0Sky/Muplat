pragma solidity >=0.4.22 <0.6.0;

contract Muplat {
    address public owner;
    uint musicNumber;
    uint userNumber;
    uint artistNumber;

    struct User {
        uint uid;
        uint musicNum;
        string userName;
        // string password;
        uint[] purchasedMusic;
        mapping(uint => bool) musicPurchased;
    }

    struct Artist {
        uint aid;
        string name;
        address payable addr;
        uint[] uploadedMusic;
    }

    struct Music {
        uint aid;
        uint mid;
        uint price;
        uint releaseTime;
        string name;
    }

    mapping(address => User) addrToUser;
    mapping(uint => Artist) idToArtist;
    mapping(address => uint) addrToArtistID;
    mapping(uint => Music) idToMusic;
    mapping(string => uint[]) musicNameToID;

    modifier onlyOwner {
        require(
            msg.sender == owner,
            "Only Owner can call this."
        );
        _;
    }

    modifier onlyUser {require(addrToUser[msg.sender].uid != 0, "Only User can call this." ); _;}
    modifier onlyArtist {require(addrToArtistID[msg.sender] != 0, "Only artist can call this." ); _;}

    constructor() public {
        owner = msg.sender;
        musicNumber = 0;
        userNumber = 0;
        artistNumber = 0;
    }

    function PurchaseMusic(uint mid)
        payable
        external
        onlyUser
    {
        Music storage music = idToMusic[mid];
        require(music.mid != 0, "The music is not exist.");
        require(msg.value == music.price, "The payment is incorrect.");

        User storage buyer = addrToUser[msg.sender];
        require(!buyer.musicPurchased[music.mid], "Already bought this music.");

        buyer.musicPurchased[music.mid] = true;
        buyer.purchasedMusic.push(music.mid);
        ++buyer.musicNum;

        idToArtist[music.aid].addr.transfer(msg.value);
    }

    function UserRegister(string memory _username) public
    {
        require(addrToUser[msg.sender].uid == 0, "Already registered.");

        User memory newUser = User(++userNumber, 0, _username, new uint[](0));
        addrToUser[msg.sender] = newUser;
    }

    function ArtistRegister(string memory _name) public
    {
        require(addrToArtistID[msg.sender] == 0, "Already registered.");

        if (addrToUser[msg.sender].uid == 0) {
            UserRegister(_name);
        }

        Artist memory newArtist = Artist(++artistNumber, _name, msg.sender, new uint[](0));
        addrToArtistID[msg.sender] = artistNumber;
        idToArtist[artistNumber] = newArtist;
    }

    function UploadMusic(uint _price, string calldata _name)
        external
        onlyArtist
    {
        Artist storage uploader = idToArtist[addrToArtistID[msg.sender]];
        uploader.uploadedMusic.push(++musicNumber);

        idToMusic[musicNumber] = Music(uploader.aid, musicNumber, _price, now, _name);
        musicNameToID[_name].push(musicNumber);
    }

    function GetUser()
        public
        view
        returns(uint, uint, string memory, uint[] memory)
    {
        return (addrToUser[msg.sender].uid, addrToUser[msg.sender].musicNum,
            addrToUser[msg.sender].userName, addrToUser[msg.sender].purchasedMusic);
    }

    function GetArtist()
        public
        view
        returns(uint, string memory, uint[] memory)
    {
        Artist memory artist = idToArtist[addrToArtistID[msg.sender]];
        return (artist.aid, artist.name, artist.uploadedMusic);
    }

    function GetMusicInfo(uint mid)
        public
        view
        returns(string memory, uint, uint, uint, string memory)
    {
        Music memory music = idToMusic[mid];
        return (idToArtist[music.aid].name, music.mid, music.price, music.releaseTime, music.name);
    }

    function SearchMusicByExactName(string memory _name)
        public
        view
        returns(uint[] memory)
    {
        return musicNameToID[_name];
    }
}
