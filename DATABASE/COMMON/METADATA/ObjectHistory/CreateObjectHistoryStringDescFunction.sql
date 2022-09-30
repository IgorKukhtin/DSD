CREATE OR REPLACE FUNCTION zc_ObjectHistoryString_JuridicalDetails_FullName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectHistoryStringDesc WHERE Code = 'zc_ObjectHistoryString_JuridicalDetails_FullName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectHistoryStringDesc (DescId, Code ,itemname)
SELECT zc_ObjectHistory_JuridicalDetails(), 'zc_ObjectHistoryString_JuridicalDetails_FullName','��. ���� ������ ��������' WHERE NOT EXISTS (SELECT * FROM ObjectHistoryStringDesc WHERE Id = zc_ObjectHistoryString_JuridicalDetails_FullName());

CREATE OR REPLACE FUNCTION zc_ObjectHistoryString_JuridicalDetails_JuridicalAddress() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectHistoryStringDesc WHERE Code = 'zc_ObjectHistoryString_JuridicalDetails_JuridicalAddress'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectHistoryStringDesc (DescId, Code ,itemname)
SELECT zc_ObjectHistory_JuridicalDetails(), 'zc_ObjectHistoryString_JuridicalDetails_JuridicalAddress','����������� �����' WHERE NOT EXISTS (SELECT * FROM ObjectHistoryStringDesc WHERE Id = zc_ObjectHistoryString_JuridicalDetails_JuridicalAddress());

CREATE OR REPLACE FUNCTION zc_ObjectHistoryString_JuridicalDetails_OKPO() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectHistoryStringDesc WHERE Code = 'zc_ObjectHistoryString_JuridicalDetails_OKPO'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectHistoryStringDesc (DescId, Code ,itemname)
SELECT zc_ObjectHistory_JuridicalDetails(), 'zc_ObjectHistoryString_JuridicalDetails_OKPO','����' WHERE NOT EXISTS (SELECT * FROM ObjectHistoryStringDesc WHERE Id = zc_ObjectHistoryString_JuridicalDetails_OKPO());

CREATE OR REPLACE FUNCTION zc_ObjectHistoryString_JuridicalDetails_INN() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectHistoryStringDesc WHERE Code = 'zc_ObjectHistoryString_JuridicalDetails_INN'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectHistoryStringDesc (DescId, Code ,itemname)
SELECT zc_ObjectHistory_JuridicalDetails(), 'zc_ObjectHistoryString_JuridicalDetails_INN','���' WHERE NOT EXISTS (SELECT * FROM ObjectHistoryStringDesc WHERE Id = zc_ObjectHistoryString_JuridicalDetails_INN());

CREATE OR REPLACE FUNCTION zc_ObjectHistoryString_JuridicalDetails_NumberVAT() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectHistoryStringDesc WHERE Code = 'zc_ObjectHistoryString_JuridicalDetails_NumberVAT'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectHistoryStringDesc (DescId, Code ,itemname)
SELECT zc_ObjectHistory_JuridicalDetails(), 'zc_ObjectHistoryString_JuridicalDetails_NumberVAT','����� ������������� ����������� ���' WHERE NOT EXISTS (SELECT * FROM ObjectHistoryStringDesc WHERE Id = zc_ObjectHistoryString_JuridicalDetails_NumberVAT());

CREATE OR REPLACE FUNCTION zc_ObjectHistoryString_JuridicalDetails_AccounterName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectHistoryStringDesc WHERE Code = 'zc_ObjectHistoryString_JuridicalDetails_AccounterName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectHistoryStringDesc (DescId, Code ,itemname)
SELECT zc_ObjectHistory_JuridicalDetails(), 'zc_ObjectHistoryString_JuridicalDetails_AccounterName','��� ����.' WHERE NOT EXISTS (SELECT * FROM ObjectHistoryStringDesc WHERE Id = zc_ObjectHistoryString_JuridicalDetails_AccounterName());

CREATE OR REPLACE FUNCTION zc_ObjectHistoryString_JuridicalDetails_BankAccount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectHistoryStringDesc WHERE Code = 'zc_ObjectHistoryString_JuridicalDetails_BankAccount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectHistoryStringDesc (DescId, Code ,itemname)
SELECT zc_ObjectHistory_JuridicalDetails(), 'zc_ObjectHistoryString_JuridicalDetails_BankAccount','�.����' WHERE NOT EXISTS (SELECT * FROM ObjectHistoryStringDesc WHERE Id = zc_ObjectHistoryString_JuridicalDetails_BankAccount());

CREATE OR REPLACE FUNCTION zc_ObjectHistoryString_JuridicalDetails_Phone() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectHistoryStringDesc WHERE Code = 'zc_ObjectHistoryString_JuridicalDetails_Phone'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectHistoryStringDesc (DescId, Code ,itemname)
SELECT zc_ObjectHistory_JuridicalDetails(), 'zc_ObjectHistoryString_JuridicalDetails_Phone','�������' WHERE NOT EXISTS (SELECT * FROM ObjectHistoryStringDesc WHERE Id = zc_ObjectHistoryString_JuridicalDetails_Phone());

CREATE OR REPLACE FUNCTION zc_ObjectHistoryString_JuridicalDetails_MainName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectHistoryStringDesc WHERE Code = 'zc_ObjectHistoryString_JuridicalDetails_MainName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectHistoryStringDesc (DescId, Code ,itemname)
SELECT zc_ObjectHistory_JuridicalDetails(), 'zc_ObjectHistoryString_JuridicalDetails_MainName','��� ���������' WHERE NOT EXISTS (SELECT * FROM ObjectHistoryStringDesc WHERE Id = zc_ObjectHistoryString_JuridicalDetails_MainName());

CREATE OR REPLACE FUNCTION zc_ObjectHistoryString_JuridicalDetails_MainName_Cut() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectHistoryStringDesc WHERE Code = 'zc_ObjectHistoryString_JuridicalDetails_MainName_Cut'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectHistoryStringDesc (DescId, Code ,itemname)
SELECT zc_ObjectHistory_JuridicalDetails(), 'zc_ObjectHistoryString_JuridicalDetails_MainName_Cut','��� ���������(��� �������)' WHERE NOT EXISTS (SELECT * FROM ObjectHistoryStringDesc WHERE Id = zc_ObjectHistoryString_JuridicalDetails_MainName_Cut());


CREATE OR REPLACE FUNCTION zc_ObjectHistoryString_JuridicalDetails_InvNumberBranch() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectHistoryStringDesc WHERE Code = 'zc_ObjectHistoryString_JuridicalDetails_InvNumberBranch'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectHistoryStringDesc (DescId, Code ,itemname)
SELECT zc_ObjectHistory_JuridicalDetails(), 'zc_ObjectHistoryString_JuridicalDetails_InvNumberBranch','� �������' WHERE NOT EXISTS (SELECT * FROM ObjectHistoryStringDesc WHERE Id = zc_ObjectHistoryString_JuridicalDetails_InvNumberBranch());

CREATE OR REPLACE FUNCTION zc_ObjectHistoryString_JuridicalDetails_Decision() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectHistoryStringDesc WHERE Code = 'zc_ObjectHistoryString_JuridicalDetails_Decision'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectHistoryStringDesc (DescId, Code ,itemname)
SELECT zc_ObjectHistory_JuridicalDetails(), 'zc_ObjectHistoryString_JuridicalDetails_Decision','� ������ ��� ������ ����糿' WHERE NOT EXISTS (SELECT * FROM ObjectHistoryStringDesc WHERE Id = zc_ObjectHistoryString_JuridicalDetails_Decision());

CREATE OR REPLACE FUNCTION zc_ObjectHistoryString_JuridicalDetails_License() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectHistoryStringDesc WHERE Code = 'zc_ObjectHistoryString_JuridicalDetails_License'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectHistoryStringDesc (DescId, Code ,itemname)
SELECT zc_ObjectHistory_JuridicalDetails(), 'zc_ObjectHistoryString_JuridicalDetails_License','� ����糿' WHERE NOT EXISTS (SELECT * FROM ObjectHistoryStringDesc WHERE Id = zc_ObjectHistoryString_JuridicalDetails_License());


CREATE OR REPLACE FUNCTION zc_ObjectHistoryString_JuridicalDetails_Reestr() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectHistoryStringDesc WHERE Code = 'zc_ObjectHistoryString_JuridicalDetails_Reestr'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectHistoryStringDesc (DescId, Code ,itemname)
SELECT zc_ObjectHistory_JuridicalDetails(), 'zc_ObjectHistoryString_JuridicalDetails_Reestr','����� � ������ �������� ���' WHERE NOT EXISTS (SELECT * FROM ObjectHistoryStringDesc WHERE Id = zc_ObjectHistoryString_JuridicalDetails_Reestr());

CREATE OR REPLACE FUNCTION zc_ObjectHistoryString_JuridicalDetails_MainName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectHistoryStringDesc WHERE Code = 'zc_ObjectHistoryString_JuridicalDetails_MainName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectHistoryStringDesc (DescId, Code ,itemname)
SELECT zc_ObjectHistory_JuridicalDetails(), 'zc_ObjectHistoryString_JuridicalDetails_MainName','��� ���������' WHERE NOT EXISTS (SELECT * FROM ObjectHistoryStringDesc WHERE Id = zc_ObjectHistoryString_JuridicalDetails_MainName());

CREATE OR REPLACE FUNCTION zc_ObjectHistoryString_JuridicalDetails_Name() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectHistoryStringDesc WHERE Code = 'zc_ObjectHistoryString_JuridicalDetails_Name'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectHistoryStringDesc (DescId, Code ,itemname)
SELECT zc_ObjectHistory_JuridicalDetails(), 'zc_ObjectHistoryString_JuridicalDetails_Name','��. ���� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectHistoryStringDesc WHERE Id = zc_ObjectHistoryString_JuridicalDetails_Name());


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 30.09.22         * zc_ObjectHistoryString_JuridicalDetails_Name
 06.03.17         *
 07.04.16         * add InvNumberBranch
 26.11.15         * add MainName
 12.02.14                                                       * add phone
 15.12.13                                        * !!!rename!!!
*/
