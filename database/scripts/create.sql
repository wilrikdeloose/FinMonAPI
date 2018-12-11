CREATE OR REPLACE TABLE bank (
  ID int(11) AUTO_INCREMENT PRIMARY KEY,
  description text NOT NULL
);

CREATE OR REPLACE TABLE people (
  ID int(11) AUTO_INCREMENT PRIMARY KEY,
  name text NOT NULL
);

CREATE OR REPLACE TABLE account (
  ID int(11) AUTO_INCREMENT PRIMARY KEY,
  bankid int(11) NOT NULL REFERENCES bank(ID),
  accountNumber text NOT NULL
);

CREATE OR REPLACE TABLE account_people (
  accountid int(11),
  peopleid int(11),
  PRIMARY KEY (accountid, peopleid)
);

CREATE OR REPLACE TABLE transactions (
  ID int(11) AUTO_INCREMENT PRIMARY KEY,
  accountid int(11) NOT NULL REFERENCES account(ID),
  date timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  amount float NOT NULL,
  description longtext
);

CREATE OR REPLACE TABLE tags (
  ID int(11) AUTO_INCREMENT PRIMARY KEY,
  tag text NOT NULL,
  keyword text,
  parentTagId int(11) REFERENCES tags(ID)
);

CREATE OR REPLACE TABLE transaction_tags (
  transactionid int(11),
  tagid int(11),
  PRIMARY KEY (transactionid, tagid)
);

DELIMITER //
CREATE OR REPLACE PROCEDURE recursive_getAllSubTags(input_tagId int(11), OUT output_tagText text)
BEGIN
  DECLARE tagId int(11);
  DECLARE parentId int(11);
  DECLARE tagText text;
  DECLARE output_tag text;
  
  SELECT ID, tag, parentTagId INTO tagId, tagText, parentId FROM tags WHERE ID = input_tagId;
  IF parentId IS NULL THEN
    SET output_tagText = tagText;
  ELSE
    CALL recursive_getAllSubTags(parentId, output_tag);
    SELECT CONCAT(output_tag, ' > ', tagText) INTO output_tagText;
  END IF;
END;
//
DELIMITER ;

DELIMITER //
CREATE OR REPLACE FUNCTION getAllSubTags(input_tagId int(11))
RETURNS CHAR(100) DETERMINISTIC
BEGIN
  DECLARE tagText text;
  
  SET @@SESSION.max_sp_recursion_depth = 10;
  CALL recursive_getAllSubTags(input_tagId, tagText);
  
  return tagText;
END;
//
DELIMITER ;

-- view that displays all transaction details of all accounts
CREATE OR REPLACE VIEW transaction_details AS (
  SELECT
    t.ID AS transactionid,
    t.accountid,
    a.accountNumber,
    a.bankid,
    b.description AS bank,
    t.date,
    DATE_FORMAT(t.date, '%Y-%m') as month,
    t.amount,
    t.description,
    tag.tag,
    getAllSubTags(tag.ID) AS tags
  FROM
    transactions t INNER JOIN
    account a ON (t.accountid = a.ID) INNER JOIN
    bank b ON (a.bankid = b.ID) LEFT JOIN
    transaction_tags tt ON (t.ID = tt.transactionid) LEFT JOIN
    tags tag ON (tt.tagId = tag.ID)
);

-- trigger that automatically searches for tags in newly inserted transactions.
DELIMITER //
CREATE OR REPLACE TRIGGER tagCheck
AFTER INSERT ON transactions FOR EACH ROW
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE tagId INT;
  DECLARE keywordText CHAR(100);
  DECLARE keyword_cursor CURSOR FOR SELECT ID, keyword FROM tags;
  
  -- declare NOT FOUND handler
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
  
  OPEN keyword_cursor;
  
  keyword_loop: LOOP
    FETCH keyword_cursor INTO tagId, keywordText;
    IF done THEN
      LEAVE keyword_loop;
    END IF;
    IF INSTR(LOWER(NEW.description), keywordText) > 0 THEN
      INSERT INTO transaction_tags (transactionid, tagid) VALUES (NEW.ID, tagId);
    END IF;
  END LOOP;
  
  CLOSE keyword_cursor;
END
//
DELIMITER ;

DELIMITER //
CREATE OR REPLACE FUNCTION getAmount(input_month text, input_tag text)
RETURNS FLOAT DETERMINISTIC
BEGIN
  DECLARE output_amount FLOAT;
  
  SELECT
    SUM(amount) INTO output_amount
  FROM
    transaction_details
  WHERE
    month = input_month AND
    tags LIKE CONCAT('%', input_tag, '%');

  RETURN output_amount;
END;
//
DELIMITER ;