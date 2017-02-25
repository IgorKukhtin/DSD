
CREATE OR REPLACE FUNCTION zc_Movement_Income() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_Income'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_Income', '������ �� ����������' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_Income');

CREATE OR REPLACE FUNCTION zc_Movement_ReturnOut() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_ReturnOut'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_ReturnOut', '������� ����������' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_ReturnOut');

CREATE OR REPLACE FUNCTION zc_Movement_Send() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_Send'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_Send', '�����������' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_Send');

CREATE OR REPLACE FUNCTION zc_Movement_Sale() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_Sale'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_Sale', '�������' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_Sale');

CREATE OR REPLACE FUNCTION zc_Movement_ReturnIn() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_ReturnIn'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_ReturnIn', '������� �� ����������' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_ReturnIn');

CREATE OR REPLACE FUNCTION zc_Movement_Loss() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_Loss'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_Loss', '��������' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_Loss');

CREATE OR REPLACE FUNCTION zc_Movement_ProductionUnion() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_ProductionUnion'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_ProductionUnion', '�����������' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_ProductionUnion');

CREATE OR REPLACE FUNCTION zc_Movement_Inventory() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_Inventory'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_Inventory', '��������������' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_Inventory');

CREATE OR REPLACE FUNCTION zc_Movement_Cash() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_Cash'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_Cash', '�����, ������/������' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_Cash');

CREATE OR REPLACE FUNCTION zc_Movement_BankAccount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_BankAccount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_BankAccount', '��������� ����, ������/������' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_BankAccount');

CREATE OR REPLACE FUNCTION zc_Movement_BankStatement() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_BankStatement'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_BankStatement', '������� �����' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_BankStatement');

CREATE OR REPLACE FUNCTION zc_Movement_BankStatementItem() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_BankStatementItem'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_BankStatementItem', '������� ������� �����' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_BankStatementItem');

CREATE OR REPLACE FUNCTION zc_Movement_Service() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_Service'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_Service', '���������� ����� �� ������������ ����' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_Service');

CREATE OR REPLACE FUNCTION zc_Movement_PersonalService() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_PersonalService'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_PersonalService', '���������� ��������' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_PersonalService');

CREATE OR REPLACE FUNCTION zc_Movement_PersonalReport() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_PersonalReport'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_PersonalReport', '��������� �����' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_PersonalReport');

CREATE OR REPLACE FUNCTION zc_Movement_LossDebt() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_LossDebt'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_LossDebt', '�������� �������������' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_LossDebt');

CREATE OR REPLACE FUNCTION zc_Movement_SendDebt() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_SendDebt'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_SendDebt', '����������� (����������� ����)' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_SendDebt');

CREATE OR REPLACE FUNCTION zc_Movement_Currency() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_Currency'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_Currency', '�������� �������' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_Currency');

CREATE OR REPLACE FUNCTION zc_Movement_FounderService() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_FounderService'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_FounderService', '���������� �����������' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_FounderService');

CREATE OR REPLACE FUNCTION zc_Movement_IncomeAsset() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_IncomeAsset'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_IncomeAsset', '������ �� ���������� (��)' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_IncomeAsset');

CREATE OR REPLACE FUNCTION zc_Movement_EntryAsset() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDesc WHERE Code = 'zc_Movement_EntryAsset'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDesc (Code, ItemName)
  SELECT 'zc_Movement_EntryAsset', '�������� �� - ���� � ������������' WHERE NOT EXISTS (SELECT * FROM MovementDesc WHERE Code = 'zc_Movement_EntryAsset');


/*-------------------------------------------------------------------------------
 !!!!!!!!!!!!!!!!!!! ������������ ����� �� �������� !!!!!!!!!!!!!!!!!!!
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   �������   �����
 25.02.17                                        * start
*/
