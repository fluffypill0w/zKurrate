pragma solidity ^0.4.14;

import "./ZKurrateVerifier.sol";

contract ZKurrate is ZKurrateVerifier {
    
    struct employerReviews {
        uint256[] hashIPFS;
    }
        
    mapping(bytes32 => employerReviews) public reviewsByEmployerName; 
    
    function addReview(
            uint256 hashIPFS, 
            uint[2] a,
            uint[2][2] b,
            uint[2] c,
            uint[6] input,
            bytes32 employerName) {
        
        require(verifyProof(a, b, c, input), "Proof is invalid.");
        reviewsByEmployerName[employerName] = employerReviews.push(hashIPFS);
    }
    
    function readReviews(employerName) public constant returns(uint256) {
        return (reviewsByEmployerName[employerName].hashIPFS);
    }
}