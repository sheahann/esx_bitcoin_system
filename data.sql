CREATE TABLE `esx_bitcoin_status`(
    `Price` VARCHAR(255) NOT NULL,

    PRIMARY KEY (`Price`)
);

INSERT INTO `esx_bitcoin_status` (Price) VALUES
	(100)
;


CREATE TABLE `bitcoin_accounts` (
	`identifier` VARCHAR(255) NOT NULL,
	`ooc_name` VARCHAR(255) NOT NULL,
	`account_id` VARCHAR(255) NOT NULL,
	`bitcoins` VARCHAR(255) NOT NULL,

	PRIMARY KEY (`identifier`)
);