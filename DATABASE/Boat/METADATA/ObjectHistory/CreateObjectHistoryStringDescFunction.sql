CREATE OR REPLACE FUNCTION zc_ObjectHistoryString_JuridicalDetails_FullName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectHistoryStringDesc WHERE Code = 'zc_ObjectHistoryString_JuridicalDetails_FullName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectHistoryStringDesc (DescId, Code ,itemname)
SELECT zc_ObjectHistory_JuridicalDetails(), 'zc_ObjectHistoryString_JuridicalDetails_FullName','Юр. лицо полное название' WHERE NOT EXISTS (SELECT * FROM ObjectHistoryStringDesc WHERE Id = zc_ObjectHistoryString_JuridicalDetails_FullName());

CREATE OR REPLACE FUNCTION zc_ObjectHistoryString_JuridicalDetails_JuridicalAddress() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectHistoryStringDesc WHERE Code = 'zc_ObjectHistoryString_JuridicalDetails_JuridicalAddress'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectHistoryStringDesc (DescId, Code ,itemname)
SELECT zc_ObjectHistory_JuridicalDetails(), 'zc_ObjectHistoryString_JuridicalDetails_JuridicalAddress','Юридический адрес' WHERE NOT EXISTS (SELECT * FROM ObjectHistoryStringDesc WHERE Id = zc_ObjectHistoryString_JuridicalDetails_JuridicalAddress());

CREATE OR REPLACE FUNCTION zc_ObjectHistoryString_JuridicalDetails_OKPO() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectHistoryStringDesc WHERE Code = 'zc_ObjectHistoryString_JuridicalDetails_OKPO'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectHistoryStringDesc (DescId, Code ,itemname)
SELECT zc_ObjectHistory_JuridicalDetails(), 'zc_ObjectHistoryString_JuridicalDetails_OKPO','ОКПО' WHERE NOT EXISTS (SELECT * FROM ObjectHistoryStringDesc WHERE Id = zc_ObjectHistoryString_JuridicalDetails_OKPO());

CREATE OR REPLACE FUNCTION zc_ObjectHistoryString_JuridicalDetails_INN() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectHistoryStringDesc WHERE Code = 'zc_ObjectHistoryString_JuridicalDetails_INN'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectHistoryStringDesc (DescId, Code ,itemname)
SELECT zc_ObjectHistory_JuridicalDetails(), 'zc_ObjectHistoryString_JuridicalDetails_INN','ИНН' WHERE NOT EXISTS (SELECT * FROM ObjectHistoryStringDesc WHERE Id = zc_ObjectHistoryString_JuridicalDetails_INN());

CREATE OR REPLACE FUNCTION zc_ObjectHistoryString_JuridicalDetails_NumberVAT() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectHistoryStringDesc WHERE Code = 'zc_ObjectHistoryString_JuridicalDetails_NumberVAT'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectHistoryStringDesc (DescId, Code ,itemname)
SELECT zc_ObjectHistory_JuridicalDetails(), 'zc_ObjectHistoryString_JuridicalDetails_NumberVAT','Номер свидетельства плательщика НДС' WHERE NOT EXISTS (SELECT * FROM ObjectHistoryStringDesc WHERE Id = zc_ObjectHistoryString_JuridicalDetails_NumberVAT());

CREATE OR REPLACE FUNCTION zc_ObjectHistoryString_JuridicalDetails_AccounterName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectHistoryStringDesc WHERE Code = 'zc_ObjectHistoryString_JuridicalDetails_AccounterName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectHistoryStringDesc (DescId, Code ,itemname)
SELECT zc_ObjectHistory_JuridicalDetails(), 'zc_ObjectHistoryString_JuridicalDetails_AccounterName','ФИО бухг.' WHERE NOT EXISTS (SELECT * FROM ObjectHistoryStringDesc WHERE Id = zc_ObjectHistoryString_JuridicalDetails_AccounterName());

CREATE OR REPLACE FUNCTION zc_ObjectHistoryString_JuridicalDetails_BankAccount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectHistoryStringDesc WHERE Code = 'zc_ObjectHistoryString_JuridicalDetails_BankAccount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectHistoryStringDesc (DescId, Code ,itemname)
SELECT zc_ObjectHistory_JuridicalDetails(), 'zc_ObjectHistoryString_JuridicalDetails_BankAccount','р.счет' WHERE NOT EXISTS (SELECT * FROM ObjectHistoryStringDesc WHERE Id = zc_ObjectHistoryString_JuridicalDetails_BankAccount());

CREATE OR REPLACE FUNCTION zc_ObjectHistoryString_JuridicalDetails_Phone() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectHistoryStringDesc WHERE Code = 'zc_ObjectHistoryString_JuridicalDetails_Phone'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectHistoryStringDesc (DescId, Code ,itemname)
SELECT zc_ObjectHistory_JuridicalDetails(), 'zc_ObjectHistoryString_JuridicalDetails_Phone','телефон' WHERE NOT EXISTS (SELECT * FROM ObjectHistoryStringDesc WHERE Id = zc_ObjectHistoryString_JuridicalDetails_Phone());

CREATE OR REPLACE FUNCTION zc_ObjectHistoryString_JuridicalDetails_MainName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectHistoryStringDesc WHERE Code = 'zc_ObjectHistoryString_JuridicalDetails_MainName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectHistoryStringDesc (DescId, Code ,itemname)
SELECT zc_ObjectHistory_JuridicalDetails(), 'zc_ObjectHistoryString_JuridicalDetails_MainName','ФИО директора' WHERE NOT EXISTS (SELECT * FROM ObjectHistoryStringDesc WHERE Id = zc_ObjectHistoryString_JuridicalDetails_MainName());


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 07.04.16         * add InvNumberBranch
 26.11.15         * add MainName
 12.02.14                                                       * add phone
 15.12.13                                        * !!!rename!!!
*/
