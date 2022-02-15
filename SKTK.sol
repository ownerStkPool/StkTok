pragma solidity ^0.5.0;

contract SKTK {

	mapping(address => uint8) private _admins;

    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;
    uint256 private _reserve;

    string private _name;
    string private _symbol;
    uint8 private _decimals;
	
	address private _owner;
	
	address private _mgmtContract;

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);
	
	event Grow(uint256 amount);
	event Mint(uint256 amount);
	event Burn(uint256 amount);

    constructor() public {
																								_name = "SkeyTic";
																								_symbol = "SKTK";
																								_decimals = 6;
																								
																								_totalSupply = 0;
																								_reserve = 0;
																								
																								_owner = msg.sender;
																								
																								_admins[_owner] = 1;
    }

    function name() public view returns (string memory) 			{ 							return _name; }

    function symbol() public view returns (string memory) 			{ 							return _symbol; }

    function decimals() public view returns (uint8) 				{ 							return _decimals; }

    function totalSupply() public view returns (uint256) 			{ 							return _totalSupply; }

    function circulatingSupply() public view returns (uint256) 		{ 							return _totalSupply - _reserve; }

    function managementContract() public view returns (address) 	{ 							return _mgmtContract; }

    function setManagementContract(address lMgmtContract) public {
																								require(_admins[msg.sender] == 1, "SKTK: setManagementContract() can only be used by owner or admin");
																								_mgmtContract = lMgmtContract;
	}
	
	function setPrivileges(address lgrantee, uint8 ladmin) public {
																								require(_admins[msg.sender] == 1, "SKTK: setPrivileges() can only be used by owner or admin");
																								_admins[lgrantee] = ladmin;
	}

    function mint(uint256 amount) public {
																								require(_admins[msg.sender] == 1, "SKTK: mint() can only be used by owner or admin");
																								_mint(_owner, amount);
    }
	
    function burn(uint256 amount) public {
																								require(_admins[msg.sender] == 1, "SKTK: burn() can only be used by owner or admin");
																								_burn(_owner, amount);
    }

    function grow(uint256 amount) public {
																								require(_admins[msg.sender] == 1, "SKTK: grow() can only be used by owner or admin");
																								_grow(amount);
    }
	
    function balanceOf(address account) public view returns (uint256) {
																								return _balances[account];
    }

    function transfer(address recipient, uint256 amount) public returns (bool) {
																								_transfer(msg.sender, recipient, amount);
																								return true;
    }

    function allowance(address owner, address spender) public view returns (uint256) {
																								return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public returns (bool) {
																								_approve(msg.sender, spender, amount);
																								return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public returns (bool) {
																								uint256 currentAllowance = _allowances[sender][msg.sender];
																								require(currentAllowance >= amount, "TRC20: transfer amount exceeds allowance");
																								_approve(sender, msg.sender, currentAllowance - amount);

																								_transfer(sender, recipient, amount);

																								return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
																								_approve(msg.sender, spender, _allowances[msg.sender][spender] + addedValue);
																								return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
																								uint256 currentAllowance = _allowances[msg.sender][spender];
																								require(currentAllowance >= subtractedValue, "TRC20: decreased allowance below zero");
																								_approve(msg.sender, spender, currentAllowance - subtractedValue);

																								return true;
    }

    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal {
																								require(sender != address(0), "TRC20: transfer from the zero address");
																								require(recipient != address(0), "TRC20: transfer to the zero address");

																								uint256 senderBalance = _balances[sender];
																								require(senderBalance >= amount, "TRC20: transfer amount exceeds balance");
																								_balances[sender] = senderBalance - amount;
																								_balances[recipient] += amount;

																								emit Transfer(sender, recipient, amount);
    }

    function _mint(address account, uint256 amount) internal {
																								require(account != address(0), "TRC20: mint to the zero address");

																								_totalSupply += amount;
																								_reserve += amount;
																								_balances[account] += amount;
																								
																								emit Transfer(address(0), account, amount);																								
																								emit Mint(amount);
    }

    function _burn(address account, uint256 amount) internal {
																								require(account != address(0), "TRC20: burn from the zero address");

																								uint256 accountBalance = _balances[account];
																								require(accountBalance >= amount, "TRC20: burn amount exceeds balance");
																								_balances[account] = accountBalance - amount;
																								_totalSupply -= amount;

																								emit Transfer(account, address(0), amount);
																								emit Burn(amount);
    }

    function _grow(uint256 amount) internal {
																								require(amount <= _reserve, "SKTK: grown amount exceeds reserve");
																								
																								_reserve -= amount;
																								
																								emit Grow(amount);
    }

    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal {
																								require(owner != address(0), "TRC20: approve from the zero address");
																								require(spender != address(0), "TRC20: approve to the zero address");

																								_allowances[owner][spender] = amount;
																								emit Approval(owner, spender, amount);
    }
	
}
