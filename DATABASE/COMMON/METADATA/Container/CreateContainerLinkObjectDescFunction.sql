-- CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_Account() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_Account'); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- INSERT INTO ContainerLinkObjectDesc (Code, ItemName, ObjectDescId)
--   SELECT 'zc_ContainerLinkObject_Account', '�������������� �����', zc_Object_Account() WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_Account');

CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_ProfitLoss() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_ProfitLoss'); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ContainerLinkObjectDesc (Code, ItemName, ObjectDescId)                  
  SELECT 'zc_ContainerLinkObject_ProfitLoss', '������ ������ � �������� � �������', zc_Object_ProfitLoss() WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_ProfitLoss');

CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_InfoMoney() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_InfoMoney'); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ContainerLinkObjectDesc (Code, ItemName, ObjectDescId)
  SELECT 'zc_ContainerLinkObject_InfoMoney', '������ ����������', zc_Object_InfoMoney() WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_InfoMoney');

CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_Unit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_Unit'); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ContainerLinkObjectDesc (Code, ItemName, ObjectDescId)
  SELECT 'zc_ContainerLinkObject_Unit', '�������������', zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_Unit');

CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_Goods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_Goods'); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ContainerLinkObjectDesc (Code, ItemName, ObjectDescId)
  SELECT 'zc_ContainerLinkObject_Goods', '������', zc_Object_Goods() WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_Goods');

CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_GoodsKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_GoodsKind'); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ContainerLinkObjectDesc (Code, ItemName, ObjectDescId)
  SELECT 'zc_ContainerLinkObject_GoodsKind', '���� �������', zc_Object_GoodsKind() WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_GoodsKind');

CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_InfoMoneyDetail() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_InfoMoneyDetail'); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ContainerLinkObjectDesc (Code, ItemName, ObjectDescId)
 SELECT 'zc_ContainerLinkObject_InfoMoneyDetail', '������ ����������(����������� �/�)', zc_Object_InfoMoney() WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_InfoMoneyDetail');

CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_Contract() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_Contract'); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ContainerLinkObjectDesc (Code, ItemName, ObjectDescId)
  SELECT 'zc_ContainerLinkObject_Contract', '��������', zc_Object_Contract() WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_Contract');

CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_PaidKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_PaidKind'); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ContainerLinkObjectDesc (Code, ItemName, ObjectDescId)
  SELECT 'zc_ContainerLinkObject_PaidKind', '���� ���� ������', zc_Object_PaidKind() WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_PaidKind');

CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_Juridical() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_Juridical'); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ContainerLinkObjectDesc (Code, ItemName, ObjectDescId)
  SELECT 'zc_ContainerLinkObject_Juridical', '����������� ����', zc_Object_Juridical() WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_Juridical');

CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_Partner() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_Partner'); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ContainerLinkObjectDesc (Code, ItemName, ObjectDescId)
  SELECT 'zc_ContainerLinkObject_Partner', '�����������', zc_Object_Partner() WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_Partner');

CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_Car() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_Car'); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ContainerLinkObjectDesc (Code, ItemName, ObjectDescId)
  SELECT 'zc_ContainerLinkObject_Car', '����������', zc_Object_Car() WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_Car');

CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_Position() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_Position'); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ContainerLinkObjectDesc (Code, ItemName, ObjectDescId)
  SELECT 'zc_ContainerLinkObject_Position', '���������', zc_Object_Position() WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_Position');

CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_Personal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_Personal'); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ContainerLinkObjectDesc (Code, ItemName, ObjectDescId)
  SELECT 'zc_ContainerLinkObject_Personal', '����������', zc_Object_Personal() WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_Personal');

CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_Member() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_Member'); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ContainerLinkObjectDesc (Code, ItemName, ObjectDescId)
  SELECT 'zc_ContainerLinkObject_Member', '���������� ����', zc_Object_Member() WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_Member');

-- CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_PersonalStore() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_PersonalStore'); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- INSERT INTO ContainerLinkObjectDesc (Code, ItemName, ObjectDescId)
--   SELECT 'zc_ContainerLinkObject_PersonalStore', '����������(�����������)', zc_Object_() WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_PersonalStore');
-- CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_PersonalBuyer() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_PersonalBuyer'); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- INSERT INTO ContainerLinkObjectDesc (Code, ItemName, ObjectDescId)
--   SELECT 'zc_ContainerLinkObject_PersonalBuyer', '����������(����������)', zc_Object_() WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_PersonalBuyer');
-- CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_PersonalGoods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_PersonalGoods'); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- INSERT INTO ContainerLinkObjectDesc (Code, ItemName, ObjectDescId)
--   SELECT 'zc_ContainerLinkObject_PersonalGoods', '����������(����������� �������������)', zc_Object_() WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_PersonalGoods');
-- CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_PersonalCash() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_PersonalCash'); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- INSERT INTO ContainerLinkObjectDesc (Code, ItemName, ObjectDescId)
--   SELECT 'zc_ContainerLinkObject_PersonalCash', '����������(����������� ����)', zc_Object_() WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_PersonalCash');
-- CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_PersonalSupplier() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_PersonalSupplier'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- INSERT INTO ContainerLinkObjectDesc (Code, ItemName, ObjectDescId)
--   SELECT 'zc_ContainerLinkObject_PersonalSupplier', '����������(����������)', zc_Object_() WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_PersonalSupplier');

CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_AssetTo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_AssetTo'); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ContainerLinkObjectDesc (Code, ItemName, ObjectDescId)
  SELECT 'zc_ContainerLinkObject_AssetTo', '�������� ��������(��� �������� ��������� ���)', zc_Object_Asset() WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_AssetTo');

CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_PartionGoods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_PartionGoods'); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ContainerLinkObjectDesc (Code, ItemName, ObjectDescId)
  SELECT 'zc_ContainerLinkObject_PartionGoods', '������ ������', zc_Object_PartionGoods() WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_PartionGoods');

CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_PartionMovement() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_PartionMovement'); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ContainerLinkObjectDesc (Code, ItemName, ObjectDescId)
  SELECT 'zc_ContainerLinkObject_PartionMovement', '������ ���������', zc_Object_PartionMovement() WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_PartionMovement');

CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_Business() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_Business'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ContainerLinkObjectDesc (Code, ItemName, ObjectDescId)
  SELECT 'zc_ContainerLinkObject_Business', '�������', zc_Object_Business() WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_Business');

CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_JuridicalBasis() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_JuridicalBasis'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ContainerLinkObjectDesc (Code, ItemName, ObjectDescId)
  SELECT 'zc_ContainerLinkObject_JuridicalBasis', '������� ����������� ����', zc_Object_Juridical() WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_JuridicalBasis');

CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_Cash() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_Cash'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ContainerLinkObjectDesc (Code, ItemName, ObjectDescId)
  SELECT 'zc_ContainerLinkObject_Cash', '�����', zc_Object_Cash() WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_Cash');

CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_BankAccount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_BankAccount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ContainerLinkObjectDesc (Code, ItemName, ObjectDescId)
  SELECT 'zc_ContainerLinkObject_BankAccount', '��������� �����', zc_Object_BankAccount() WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_BankAccount');

CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_Founder() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_Founder'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ContainerLinkObjectDesc (Code, ItemName, ObjectDescId)
  SELECT 'zc_ContainerLinkObject_Founder', '����������', zc_Object_Founder() WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_Founder');

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 21.12.13                                        * add zc_ContainerLinkObject_Member
 15.09.13                                        * add zc_ContainerLinkObject_BankAccount and zc_ContainerLinkObject_Partner
 13.07.13                                        * restore zc_ContainerLinkObject_Goods
 11.07.13                                        * ����� �����2 - Create and Insert
 05.07.13          * ������� ����� �� ����� �����
 03.07.13                                        * ����� �����
*/
