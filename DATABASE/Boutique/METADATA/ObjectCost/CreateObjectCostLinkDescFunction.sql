CREATE OR REPLACE FUNCTION zc_ObjectCostLink_Unit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ObjectCostLinkDesc WHERE Code = 'zc_ObjectCostLink_Unit'); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectCostLinkDesc (Code, ItemName, ObjectDescId)
  SELECT 'zc_ObjectCostLink_Unit', '�������������', zc_Object_Unit() WHERE NOT EXISTS (SELECT * FROM ObjectCostLinkDesc WHERE Code = 'zc_ObjectCostLink_Unit');

CREATE OR REPLACE FUNCTION zc_ObjectCostLink_Goods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ObjectCostLinkDesc WHERE Code = 'zc_ObjectCostLink_Goods'); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectCostLinkDesc (Code, ItemName, ObjectDescId)
  SELECT 'zc_ObjectCostLink_Goods', '������', zc_Object_Goods() WHERE NOT EXISTS (SELECT * FROM ObjectCostLinkDesc WHERE Code = 'zc_ObjectCostLink_Goods');

CREATE OR REPLACE FUNCTION zc_ObjectCostLink_GoodsKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ObjectCostLinkDesc WHERE Code = 'zc_ObjectCostLink_GoodsKind'); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectCostLinkDesc (Code, ItemName, ObjectDescId)
  SELECT 'zc_ObjectCostLink_GoodsKind', '���� �������', zc_Object_GoodsKind() WHERE NOT EXISTS (SELECT * FROM ObjectCostLinkDesc WHERE Code = 'zc_ObjectCostLink_GoodsKind');

CREATE OR REPLACE FUNCTION zc_ObjectCostLink_InfoMoney() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ObjectCostLinkDesc WHERE Code = 'zc_ObjectCostLink_InfoMoney'); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectCostLinkDesc (Code, ItemName, ObjectDescId)
  SELECT 'zc_ObjectCostLink_InfoMoney', '������ ����������', zc_Object_InfoMoney() WHERE NOT EXISTS (SELECT * FROM ObjectCostLinkDesc WHERE Code = 'zc_ObjectCostLink_InfoMoney');

CREATE OR REPLACE FUNCTION zc_ObjectCostLink_InfoMoneyDetail() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ObjectCostLinkDesc WHERE Code = 'zc_ObjectCostLink_InfoMoneyDetail'); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectCostLinkDesc (Code, ItemName, ObjectDescId)
 SELECT 'zc_ObjectCostLink_InfoMoneyDetail', '������ ����������(����������� �/�)', zc_Object_InfoMoney() WHERE NOT EXISTS (SELECT * FROM ObjectCostLinkDesc WHERE Code = 'zc_ObjectCostLink_InfoMoneyDetail');

CREATE OR REPLACE FUNCTION zc_ObjectCostLink_PartionGoods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ObjectCostLinkDesc WHERE Code = 'zc_ObjectCostLink_PartionGoods'); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectCostLinkDesc (Code, ItemName, ObjectDescId)
  SELECT 'zc_ObjectCostLink_PartionGoods', '������ ������', zc_Object_PartionGoods() WHERE NOT EXISTS (SELECT * FROM ObjectCostLinkDesc WHERE Code = 'zc_ObjectCostLink_PartionGoods');

CREATE OR REPLACE FUNCTION zc_ObjectCostLink_Business() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ObjectCostLinkDesc WHERE Code = 'zc_ObjectCostLink_Business'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectCostLinkDesc (Code, ItemName, ObjectDescId)
  SELECT 'zc_ObjectCostLink_Business', '�������', zc_Object_Business() WHERE NOT EXISTS (SELECT * FROM ObjectCostLinkDesc WHERE Code = 'zc_ObjectCostLink_Business');

CREATE OR REPLACE FUNCTION zc_ObjectCostLink_JuridicalBasis() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ObjectCostLinkDesc WHERE Code = 'zc_ObjectCostLink_JuridicalBasis'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectCostLinkDesc (Code, ItemName, ObjectDescId)
  SELECT 'zc_ObjectCostLink_JuridicalBasis', '������� ����������� ����', zc_Object_Juridical() WHERE NOT EXISTS (SELECT * FROM ObjectCostLinkDesc WHERE Code = 'zc_ObjectCostLink_JuridicalBasis');

CREATE OR REPLACE FUNCTION zc_ObjectCostLink_Branch() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ObjectCostLinkDesc WHERE Code = 'zc_ObjectCostLink_Branch'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectCostLinkDesc (Code, ItemName, ObjectDescId)
  SELECT 'zc_ObjectCostLink_Branch', '�������', zc_Object_Branch() WHERE NOT EXISTS (SELECT * FROM ObjectCostLinkDesc WHERE Code = 'zc_ObjectCostLink_Branch');

CREATE OR REPLACE FUNCTION zc_ObjectCostLink_Personal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ObjectCostLinkDesc WHERE Code = 'zc_ObjectCostLink_Personal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectCostLinkDesc (Code, ItemName, ObjectDescId)
  SELECT 'zc_ObjectCostLink_Personal', '����������', zc_Object_Personal() WHERE NOT EXISTS (SELECT * FROM ObjectCostLinkDesc WHERE Code = 'zc_ObjectCostLink_Personal');

CREATE OR REPLACE FUNCTION zc_ObjectCostLink_Member() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ObjectCostLinkDesc WHERE Code = 'zc_ObjectCostLink_Member'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectCostLinkDesc (Code, ItemName, ObjectDescId)
  SELECT 'zc_ObjectCostLink_Member', '���������� ����', zc_Object_Member() WHERE NOT EXISTS (SELECT * FROM ObjectCostLinkDesc WHERE Code = 'zc_ObjectCostLink_Member');

CREATE OR REPLACE FUNCTION zc_ObjectCostLink_AssetTo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ObjectCostLinkDesc WHERE Code = 'zc_ObjectCostLink_AssetTo'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectCostLinkDesc (Code, ItemName, ObjectDescId)
  SELECT 'zc_ObjectCostLink_AssetTo', '�������� ��������(��� �������� ��������� ���)', zc_Object_Asset() WHERE NOT EXISTS (SELECT * FROM ObjectCostLinkDesc WHERE Code = 'zc_ObjectCostLink_AssetTo');

CREATE OR REPLACE FUNCTION zc_ObjectCostLink_Account() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ObjectCostLinkDesc WHERE Code = 'zc_ObjectCostLink_Account'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectCostLinkDesc (Code, ItemName, ObjectDescId)
  SELECT 'zc_ObjectCostLink_Account', '����', zc_Object_Account() WHERE NOT EXISTS (SELECT * FROM ObjectCostLinkDesc WHERE Code = 'zc_ObjectCostLink_Account');
  

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 21.12.13                                        * add zc_ObjectCostLink_Member
 20.09.13                                        * add zc_ObjectCostLink_Account
 16.07.13                                        * add zc_ObjectCostLink_Personal and zc_ObjectCostLink_AssetTo
 11.07.13                                        *
*/
