CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_JuridicalBasis() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_JuridicalBasis'); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ContainerLinkObjectDesc (Code, ItemName, ObjectDescId)
  SELECT 'zc_ContainerLinkObject_JuridicalBasis', '��.���� (�������)', zc_Object_Juridical() WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_JuridicalBasis');

CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_Business() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_Business'); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ContainerLinkObjectDesc (Code, ItemName, ObjectDescId)
  SELECT 'zc_ContainerLinkObject_Business', '������', /*zc_Object_Business*/zc_Object_Juridical() WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_Business');

CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_Account() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_Account'); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ContainerLinkObjectDesc (Code, ItemName, ObjectDescId)
  SELECT 'zc_ContainerLinkObject_Account', '�� ����', zc_Object_Account() WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_Account');

CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_ProfitLoss() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_ProfitLoss'); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ContainerLinkObjectDesc (Code, ItemName, ObjectDescId)
  SELECT 'zc_ContainerLinkObject_ProfitLoss', '������ ������ ����', zc_Object_ProfitLoss() WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_ProfitLoss');

CREATE OR REPLACE FUNCTION zc_ContainerLinkObject_InfoMoney() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id AS Id FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_InfoMoney'); END;  $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ContainerLinkObjectDesc (Code, ItemName, ObjectDescId)
  SELECT 'zc_ContainerLinkObject_InfoMoney', '������ ����������', zc_Object_InfoMoney() WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_InfoMoney');


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 24.08.20                                        *
*/
