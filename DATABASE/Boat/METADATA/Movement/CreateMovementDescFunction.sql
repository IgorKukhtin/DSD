CREATE OR REPLACE FUNCTION zc_Movement_OrderPartner() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_OrderPartner'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_OrderPartner', '����� ����������' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_OrderPartner');

CREATE OR REPLACE FUNCTION zc_Movement_OrderClient() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_OrderClient'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_OrderClient', '����� �������' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_OrderClient');

CREATE OR REPLACE FUNCTION zc_Movement_OrderProduction() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_OrderProduction'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_OrderProduction', '����� ������������' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_OrderProduction');

CREATE OR REPLACE FUNCTION zc_Movement_Income() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_Income'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_Income', '������ �� ����������' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_Income');

CREATE OR REPLACE FUNCTION zc_Movement_Send() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_Send'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_Send', '�����������' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_Send');

CREATE OR REPLACE FUNCTION zc_Movement_Sale() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_Sale'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_Sale', '������� �������' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_Sale');

CREATE OR REPLACE FUNCTION zc_Movement_Loss() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_Loss'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_Loss', '��������' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_Loss');

CREATE OR REPLACE FUNCTION zc_Movement_Inventory() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_Inventory'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_Inventory', '��������������' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_Inventory');

CREATE OR REPLACE FUNCTION zc_Movement_Cash() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_Cash'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_Cash', '�����, ������/������' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_Cash');

CREATE OR REPLACE FUNCTION zc_Movement_BankAccount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_BankAccount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_BankAccount', '��������� ����, ������/������' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_BankAccount');

CREATE OR REPLACE FUNCTION zc_Movement_Invoice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_Invoice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_Invoice', '����' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_Invoice');

CREATE OR REPLACE FUNCTION zc_Movement_ReturnIn() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_ReturnIn'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_ReturnIn', '������� �� ����������' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_ReturnIn');

CREATE OR REPLACE FUNCTION zc_Movement_ReturnOut() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_ReturnOut'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_ReturnOut', '������� ����������' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_ReturnOut');

CREATE OR REPLACE FUNCTION zc_Movement_OrderClient() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_OrderClient'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_OrderClient', '����� �������' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_OrderClient');

CREATE OR REPLACE FUNCTION zc_Movement_IncomeCost() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_IncomeCost'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_IncomeCost', '�������' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_IncomeCost');

CREATE OR REPLACE FUNCTION zc_Movement_ProductionUnion() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_ProductionUnion'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_ProductionUnion', '������������ - ������' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_ProductionUnion');


CREATE OR REPLACE FUNCTION zc_Movement_ProductionPersonal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_ProductionPersonal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_ProductionPersonal', '������������ - ���� �����������' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_ProductionPersonal');

CREATE OR REPLACE FUNCTION zc_Movement_PriceList() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_PriceList'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_PriceList', '����� ����' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_PriceList');



/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 18.02.22         * zc_Movement_PriceList
 13.07.21         * zc_Movement_ProductionPersonal
 12.07.21         * zc_Movement_ProductionUnion
 15.02.21         * zc_Movement_OrderClient
 02.02.21         * zc_Movement_Invoice
 24.08.20                                        *
*/
