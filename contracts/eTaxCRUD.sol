//SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;
contract eTaxCRUD {

  struct TimeTokenStruct {
    bytes32 timeTokenHash;
    uint index;
  }
    mapping(address => bytes32[]) private addressStruct;
    mapping(bytes32 => TimeTokenStruct) private timeTokenStruct;
    bytes32[] private timeTokenIndex;

  event LogNewTimeTokenMTM   (address indexed account, bytes32 timeTokenHash);
  event LogNewTimeToken   (bytes32 indexed timeToken, uint index, bytes32 timeTokenHash);
  
  function isTimeToken(bytes32 timeToken) public 
    view returns(bool isIndeed) 
  {
    if(timeTokenIndex.length == 0) return false;
    return (timeTokenIndex[timeTokenStruct[timeToken].index] == timeToken);
  }

  function insertTimeToken(
    bytes32 timeToken, 
    bytes32 timeTokenHash) 
    public
    returns(uint index)
  {
    if(isTimeToken(timeToken)) revert('Duplicated TimeToken in this contract.'); 
    timeTokenStruct[timeToken].timeTokenHash = timeTokenHash;
    timeTokenIndex.push(timeToken);
    timeTokenStruct[timeToken].index = timeTokenIndex.length - 1;
    emit LogNewTimeToken(
        timeToken, 
        timeTokenStruct[timeToken].index, 
        timeTokenHash);
    return timeTokenIndex.length-1;
  }

  function insertTimeTokenMTM(
    address account, 
    bytes32 timeTokenHash) 
    public
    returns(uint index)
  {
    // addressStruct
    addressStruct[account].push(timeTokenHash);
    emit LogNewTimeTokenMTM(
        account, 
        timeTokenHash);
    return  addressStruct[account].length;
  }
  
  function getTimeToken(bytes32 timeToken)
    public 
    view
    returns(bytes32 timeTokenHash, uint index)
  {
    if(!isTimeToken(timeToken)) revert('There is no TimeToken in this contract.');
    return(
      timeTokenStruct[timeToken].timeTokenHash,
      timeTokenStruct[timeToken].index);
  } 
  
  function getTimeTokenCount() 
    public
    view
    returns(uint count)
  {
    return timeTokenIndex.length;
  }

  function getTimeTokenAtIndex(uint index)
    public
    view
    returns(bytes32 timeToken)
  {
    return timeTokenIndex[index];
  }

  function getTimeTokenMTMCount(address account) public view returns (uint) {
        return addressStruct[account].length;
    }

    function getTimeTokenMTMValue(address account, uint index) public view returns (bytes32) {
        return addressStruct[account][index];
    }
}