--------------------------- !!!!!!!!!!!!!!!!!!!
--------------------------- !!! ����� ����� !!!
--------------------------- !!!!!!!!!!!!!!!!!!!

CREATE OR REPLACE FUNCTION zc_MovementString_InvNumberPartner() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_InvNumberPartner'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_InvNumberPartner', '����� ��������� � �����������' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_InvNumberPartner');

CREATE OR REPLACE FUNCTION zc_MovementString_PartionGoods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_PartionGoods'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_PartionGoods', '������ ������' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_PartionGoods');

CREATE OR REPLACE FUNCTION zc_MovementString_FileName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_FileName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_FileName', '��� �����' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_FileName');

CREATE OR REPLACE FUNCTION zc_MovementString_OKPO() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_OKPO'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_OKPO', '����' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_OKPO');

CREATE OR REPLACE FUNCTION zc_MovementString_JuridicalName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_JuridicalName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_JuridicalName', 'JuridicalName' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_JuridicalName');

CREATE OR REPLACE FUNCTION zc_MovementString_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_Comment', '����������' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_Comment');

CREATE OR REPLACE FUNCTION zc_MovementString_BankAccount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_BankAccount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_BankAccount', '��������� ����' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_BankAccount');

CREATE OR REPLACE FUNCTION zc_MovementString_BankMFO() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_BankMFO'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_BankMFO', '���' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_BankMFO');

CREATE OR REPLACE FUNCTION zc_MovementString_BankName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_BankName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_BankName', '�������� �����' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_BankName');

CREATE OR REPLACE FUNCTION zc_MovementString_InvNumberOrder() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementStringDesc WHERE Code = 'zc_MovementString_InvNumberOrder'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementStringDesc (Code, ItemName)
  SELECT 'zc_MovementString_InvNumberOrder', '����� ������ �����������' WHERE NOT EXISTS (SELECT * FROM MovementStringDesc WHERE Code = 'zc_MovementString_InvNumberOrder');

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 11.01.14                                        * add zc_MovementString_InvNumberOrder
 02.12.13                         * ���� ��� ������ � ������-������
 25.09.13         * add zc_MovementString_Comment              
 13.08.13         * add zc_MovementString_OKPO              
 12.08.13         * add zc_MovementString_FileName              
 19.07.13         * add zc_MovementString_PartionGoods()
 30.06.13                                        * ����� �����
*/
