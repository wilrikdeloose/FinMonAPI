INSERT INTO bank (ID, description) VALUES
(1, 'Triodos'),
(2, 'ABN AMRO'),
(3, 'ING'),
(4, 'Rabobank');

INSERT INTO people (ID, name) VALUES
(1, 'Wilrik'),
(2, 'Kim');

INSERT INTO account (ID, bankid, accountNumber) VALUES
(1, 1, 'TRIO 0000 0000 00'),
(2, 2, 'ABNA 0000 0000 00'),
(3, 3, 'INGB 0006 6321 07'),
(4, 4, 'RABO 0000 0000 00');

INSERT INTO account_people (accountid, peopleid) VALUES
(1, 1),
(1, 2),
(2, 1),
(2, 2),
(3, 1),
(4, 2);

INSERT INTO tags (ID, tag, keyword, parentTagId) VALUES
 (  1, 'Food', null, null)
,(  2, 'Kiosk', 'kiosk', 1)
,(  3, 'Groceries', null, 1)
,(  4, 'Cafetaria Select Boxtel', 'cafetaria select', 1)
,(  5, 'Plus', 'plus', 3)
,(  6, 'Jumbo', 'jumbo', 3)
,(  7, 'Albert Heijn', 'heijn', 3)
,(  8, 'Lidl', 'lidl', 3)
,(  9, 'Aldi', 'aldi', 3)
,( 10, 'Soussie', 'soussie', 3)
,( 11, 'Ekoplaza', 'ekoplaza', 3)
,( 12, 'Bakkerij', 'bakkerij', 3)
,( 13, 'Eating out', null, 1)
,( 14, '''t Hart van Boxtel', 'hart van boxtel', 13)
,( 15, 'Happy Tokyo Boxtel', 'happy tokyo', 13)
,( 16, 'Eetcafe de Deugniet', 'deugnie', 13)
,( 17, 'T''Apart Haaren', 'apart haaren', 13)
,( 18, 'Miru sushi', 'miru', 13)
,( 19, 'Detailhandel Smorenburg (kiosk)', 'smorenburg', 1)
,( 20, 'Frezzo', 'frezzo', 13)
,( 21, 'Pan en zo', 'pan en zo', 13)
,( 22, 'Archipel Landrijt', 'landrijt', 1)

,(100, 'Car', null, null)
,(101, 'Fuel', null, 100)
,(102, 'Shell', 'shell', 101)
,(103, 'BP', 'bp', 101)
,(104, 'Esso', 'esso', 101)
,(105, 'Avia', 'avia', 101)
,(106, 'Q8', 'q8', 101)
,(107, 'Total', 'total', 101)
,(108, 'Texaco', 'texaco', 101)
,(109, 'Tango', 'tango', 101)
,(110, 'Haan', 'haan', 101)
,(111, 'Schimmel', 'schimmel', 101)
,(112, 'Parking', null, 100)
,(113, 'Wolvenhoek', 'wolvenhoek', 112)
,(114, 'Elan', 'elan', 101)
,(115, 'Tanken (handmatig overgemaakt)', 'tanken', 101)

,(200, 'Animals', null, null)
,(201, 'Cats', null, 200)
,(202, 'Dogs', null, 200)
,(203, 'Vet', 'dierenkl', 200)
,(204, 'Animal food', 'petfood', 200)
,(205, 'Animal food', 'zooplus', 200)
,(206, 'Dog walking service', 'doughnut/megan', 202)

,(300, 'Supply store', null, null)
,(301, 'Hardware store', null, 300)
,(302, 'Garden center', null, 300)
,(303, 'Bruna', 'bruna', 300)
,(304, 'Wereldwinkel', 'wereldwinkel', 300)
,(305, 'Karwij', 'karwij', 301)
,(306, 'Groenrijk', 'groenrijk', 302)
,(307, 'Tuincentrum', 'tuincentrum', 302)
,(308, 'Blokker', 'blokker', 300)
,(309, 'Gamma', 'gamma', 301)
,(310, 'Tuincentrum Coppelmans', 'coppel', 302)
,(311, 'Pharmacy', null, 300)
,(312, 'Boots de Dommel', 'boots', 311)
,(313, 'AKO', 'ako', 300)
,(314, 'Xenos', 'xenos', 300)

,(400, 'Going out', null, null)
,(401, 'Cinemas', null, 400)
,(402, 'Vue Cinemas', 'vue', 401)
,(403, 'Pathe', 'pathe', 401)
;