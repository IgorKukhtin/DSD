CREATE OR REPLACE FUNCTION zc_Object_Status() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Status'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Status', '������� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Status');

CREATE OR REPLACE FUNCTION zc_Object_Program() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Program'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_Program', '���������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Program');

CREATE OR REPLACE FUNCTION zc_Object_Form() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Form'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Form', '����� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Form');

CREATE OR REPLACE FUNCTION zc_Object_Action() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Action'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Action', 'Action � MainForm' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Action');

CREATE OR REPLACE FUNCTION zc_Object_UserFormSettings() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_UserFormSettings'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_UserFormSettings', '���������������� ��������� ����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_UserFormSettings');

CREATE OR REPLACE FUNCTION zc_Object_Process() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Process'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Process', '��������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Process');

CREATE OR REPLACE FUNCTION zc_Object_Role() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Role'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Role', '����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Role');

CREATE OR REPLACE FUNCTION zc_Object_RoleRight() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_RoleRight'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_RoleRight', '��������� ���� �� ����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_RoleRight');

CREATE OR REPLACE FUNCTION zc_Object_RoleAction() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_RoleAction'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_RoleAction', '��������� ��� ���� - Action �� MainForm' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_RoleAction');

CREATE OR REPLACE FUNCTION zc_Object_RoleProcessAccess() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_RoleProcessAccess'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_RoleProcessAccess', '��������� ��� ���� - ��������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_RoleProcessAccess');

CREATE OR REPLACE FUNCTION zc_object_User() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_object_User'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_object_User', '������������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_object_User');

CREATE OR REPLACE FUNCTION zc_Object_UserRole() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_UserRole'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_UserRole', '��������� ��� ������������ - ����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_UserRole');

-- �������������� - ...
CREATE OR REPLACE FUNCTION zc_Object_AnalyzerId() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_AnalyzerId'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_AnalyzerId', '���� �������� ��� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_AnalyzerId');

-- �������������� - ������
CREATE OR REPLACE FUNCTION zc_Object_Account() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Account'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Account', '����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Account');

CREATE OR REPLACE FUNCTION zc_Object_AccountDirection() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_AccountDirection'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_AccountDirection', '��������� ����� (�����)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_AccountDirection');

CREATE OR REPLACE FUNCTION zc_Object_AccountGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_AccountGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_AccountGroup', '������ ������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_AccountGroup');

-- �������������� - ����
CREATE OR REPLACE FUNCTION zc_Object_ProfitLossGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ProfitLossGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ProfitLossGroup', '������ ������ ����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ProfitLossGroup');

CREATE OR REPLACE FUNCTION zc_Object_ProfitLossDirection() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ProfitLossDirection'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ProfitLossDirection', '��������� ������ ���� - �����������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ProfitLossDirection');

CREATE OR REPLACE FUNCTION zc_Object_ProfitLoss() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ProfitLoss'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ProfitLoss', '������ ����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ProfitLoss');

-- �������������� - ������
CREATE OR REPLACE FUNCTION zc_Object_InfoMoney() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_InfoMoney'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_InfoMoney', '������ ������/������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_InfoMoney');

-- ����������������
CREATE OR REPLACE FUNCTION zc_Object_Member() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Member'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Member', '���������� ����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Member');

CREATE OR REPLACE FUNCTION zc_Object_Unit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Unit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Unit', '������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Unit');


CREATE OR REPLACE FUNCTION zc_Object_ImportType() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ImportType'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ImportType', '���� �������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ImportType');

CREATE OR REPLACE FUNCTION zc_Object_ImportSettings() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ImportSettings'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ImportSettings', '��������� �������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ImportSettings');

CREATE OR REPLACE FUNCTION zc_Object_ImportSettingsItems() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ImportSettingsItems'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ImportSettingsItems', '��������� �������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ImportSettingsItems');

CREATE OR REPLACE FUNCTION zc_Object_FileTypeKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_FileTypeKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_FileTypeKind', '���� �����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_FileTypeKind');

CREATE OR REPLACE FUNCTION zc_Object_ImportTypeItems() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ImportTypeItems'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ImportTypeItems', '�������� ���� �������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ImportTypeItems');
  

-- Add Project_Merlin


CREATE OR REPLACE FUNCTION zc_Object_CommentMoveMoney() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_CommentMoveMoney'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_CommentMoveMoney', '���������� �������� �����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_CommentMoveMoney');
  
CREATE OR REPLACE FUNCTION zc_Object_CommentInfoMoney() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_CommentInfoMoney'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_CommentInfoMoney', '���������� ������/������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_CommentInfoMoney');
  
CREATE OR REPLACE FUNCTION zc_Object_InfoMoneyKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_InfoMoneyKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_InfoMoneyKind', '���� ������/������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_InfoMoneyKind');

CREATE OR REPLACE FUNCTION zc_Object_InfoMoneyDetail() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_InfoMoneyDetail'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_InfoMoneyDetail', '�������� ������/������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_InfoMoneyDetail');
  
CREATE OR REPLACE FUNCTION zc_Object_ServiceItem() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ServiceItem'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ServiceItem', '������� ������� ������� ������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ServiceItem');
  
/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 06.02.22         * zc_Object_ServiceItem
 12.01.22         * zc_Object_CommentMoveMoney
                    zc_Object_CommentInfoMoney
                    zc_Object_InfoMoneyKind
                    zc_Object_InfoMoneyDetail
 10.01.22                                        * 
*/
