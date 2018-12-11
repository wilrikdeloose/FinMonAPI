-- drop views
DROP VIEW transaction_details;

-- drop tables
DROP TABLE transaction_tags;
DROP TABLE tags;
DROP TRIGGER tagCheckTrigger ON transactions;
DROP FUNCTION tagCheck;
DROP TABLE transactions;
DROP TABLE account_people;
DROP TABLE account;
DROP TABLE people;
DROP TABLE bank;

-- drop stored procedures
DROP FUNCTION getAllSubTags;
DROP FUNCTION recursive_getAllSubTags;
DROP FUNCTION getAmount;
