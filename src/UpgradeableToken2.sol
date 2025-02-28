// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.22;

import {ERC20Upgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import {ERC20BurnableUpgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20BurnableUpgradeable.sol";
import {ERC20PausableUpgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20PausableUpgradeable.sol";
import {ERC20PermitUpgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20PermitUpgradeable.sol";
import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {Ownable2StepUpgradeable} from "@openzeppelin/contracts-upgradeable/access/Ownable2StepUpgradeable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {ERC20VotesUpgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20VotesUpgradeable.sol";
import {NoncesUpgradeable} from "@openzeppelin/contracts-upgradeable/utils/NoncesUpgradeable.sol";


/// @custom:oz-upgrades-from UpgradeableToken
contract UpgradeableToken2 is Initializable, ERC20Upgradeable, ERC20BurnableUpgradeable, ERC20PausableUpgradeable, Ownable2StepUpgradeable, ERC20VotesUpgradeable, ERC20PermitUpgradeable, UUPSUpgradeable {

    function initialize(string memory _name, 
        string memory _symbol, 
        address mint_to) initializer public {
        __ERC20_init(_name, _symbol);
        __ERC20Burnable_init();
        __ERC20Pausable_init();
        __Ownable_init(msg.sender);
        __ERC20Permit_init(_name);
        __UUPSUpgradeable_init();
        _mint(mint_to, 300000000 ether);
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function _authorizeUpgrade(address newImplementation)
        internal
        onlyOwner
        override
    {}

    function nonces(address owner) public view virtual override(ERC20PermitUpgradeable, NoncesUpgradeable) returns (uint256) {
            return super.nonces(owner);
     }

    function renounceOwnership() public virtual override {
        revert("Not implemented");
    }

    function _update(address from, address to, uint256 value) internal override(ERC20PausableUpgradeable, ERC20Upgradeable, ERC20VotesUpgradeable) {
        if(_blacklisted[from]){
            revert AddressBlackListed(from);
        }
        if(_blacklisted[to]){
            revert AddressBlackListed(to);
        }
        super._update(from, to, value);
    }

    error AddressBlackListed(address account);

    mapping (address => bool) _blacklisted;

    function blacklist(address _ow) external onlyOwner() {
        _blacklisted[_ow] = true;
    }

    function blacklists(address[] memory _ows) external onlyOwner() {
        for (uint i = 0; i < _ows.length; i++) {
            _blacklisted[_ows[i]] = true;
        }
    }

    function remove_blacklist(address _ow) external onlyOwner() {
        _blacklisted[_ow] = false;
    }

    function remove_blacklists(address[] memory _ows) external onlyOwner(){
        for(uint i = 0; i <  _ows.length; i++){
            _blacklisted[_ows[i]] = false;
        }
    }

    function isBlacklisted(address _own) external view returns(bool) {
        return _blacklisted[_own];
    }
} 