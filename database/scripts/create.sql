CREATE TABLE IF NOT EXISTS bank (
  ID SERIAL PRIMARY KEY,
  description text NOT NULL
);

CREATE TABLE IF NOT EXISTS people (
  ID SERIAL PRIMARY KEY,
  name text NOT NULL
);

CREATE TABLE IF NOT EXISTS account (
  ID SERIAL PRIMARY KEY,
  bankid integer NOT NULL REFERENCES bank(ID),
  accountNumber text NOT NULL
);

CREATE TABLE IF NOT EXISTS account_people (
  accountid integer,
  peopleid integer,
  PRIMARY KEY (accountid, peopleid)
);

CREATE TABLE IF NOT EXISTS transactions (
  ID SERIAL PRIMARY KEY,
  accountid integer NOT NULL REFERENCES account(ID),
  date timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  amount float NOT NULL,
  description text
);

CREATE TABLE IF NOT EXISTS tags (
  ID SERIAL PRIMARY KEY,
  tag text NOT NULL,
  keyword text,
  parentTagId integer REFERENCES tags(ID)
);

CREATE TABLE IF NOT EXISTS transaction_tags (
  transactionid integer,
  tagid integer,
  PRIMARY KEY (transactionid, tagid)
);

CREATE OR REPLACE FUNCTION recursive_getAllSubTags(input_tagId integer, OUT output_tagText text) AS $$
DECLARE
  tagId integer;
  parentId integer;
  tagText text;
  output_tag text;
BEGIN
  SELECT ID, tag, parentTagId INTO tagId, tagText, parentId FROM tags WHERE ID = input_tagId;
  IF parentId IS NULL THEN
    SET output_tagText = tagText;
  ELSE
    SELECT recursive_getAllSubTags(parentId, output_tag);
    SELECT CONCAT(output_tag, ' > ', tagText) INTO output_tagText;
  END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION getAllSubTags(input_tagId integer) RETURNS CHAR(100) AS $$
DECLARE
  tagText text;
BEGIN
  SELECT recursive_getAllSubTags(input_tagId, tagText);
  return tagText;
END;
$$ LANGUAGE plpgsql;

-- view that displays all transaction details of all accounts
CREATE OR REPLACE VIEW transaction_details AS (
  SELECT
    t.ID AS transactionid,
    t.accountid,
    a.accountNumber,
    a.bankid,
    b.description AS bank,
    t.date,
    to_char(t.date, 'YYYY-MM') as month,
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

CREATE OR REPLACE FUNCTION tagCheck() RETURNS trigger AS $$
DECLARE
  done INT := FALSE;
  tagId INT;
  keywordText CHAR(100);
  keyword_cursor CURSOR FOR SELECT ID, keyword FROM tags;
BEGIN
  OPEN keyword_cursor;
  
  LOOP
    FETCH keyword_cursor INTO tagId, keywordText;
    EXIT WHEN NOT FOUND;
    IF INSTR(LOWER(NEW.description), keywordText) > 0 THEN
      INSERT INTO transaction_tags (transactionid, tagid) VALUES (NEW.ID, tagId);
    END IF;
  END LOOP;
  
  CLOSE keyword_cursor;
END;
$$
LANGUAGE 'plpgsql';

-- trigger that automatically searches for tags in newly inserted transactions.
CREATE TRIGGER tagCheckTrigger AFTER INSERT OR UPDATE ON transactions FOR EACH ROW
EXECUTE PROCEDURE tagCheck();

CREATE OR REPLACE FUNCTION getAmount(input_month text, input_tag text) RETURNS FLOAT AS $$
DECLARE
  output_amount FLOAT;
BEGIN
  SELECT
    SUM(amount) INTO output_amount
  FROM
    transaction_details
  WHERE
    month = input_month AND
    tags LIKE CONCAT('%', input_tag, '%');

  RETURN output_amount;
END;
$$ LANGUAGE plpgsql;
