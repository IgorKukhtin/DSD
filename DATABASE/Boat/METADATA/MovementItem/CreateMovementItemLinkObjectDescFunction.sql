
CREATE OR REPLACE FUNCTION zc_MILinkObject_Currency() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Currency'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_Currency', '������' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Currency');

CREATE OR REPLACE FUNCTION zc_MILinkObject_Currency_pl() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Currency_pl'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_Currency_pl', '������ (���� �����)' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Currency_pl');

CREATE OR REPLACE FUNCTION zc_MILinkObject_PaidKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PaidKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_PaidKind', '����� ������' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PaidKind');

CREATE OR REPLACE FUNCTION zc_MILinkObject_DiscountSaleKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_DiscountSaleKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_DiscountSaleKind', '��� ������ ��� �������' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_DiscountSaleKind');

CREATE OR REPLACE FUNCTION zc_MILinkObject_Cash() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Cash'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_Cash', '����� �����' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Cash');

CREATE OR REPLACE FUNCTION zc_MILinkObject_PartionMI() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionMI'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_PartionMI', '������ �������� �������/�������' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_PartionMI');


CREATE OR REPLACE FUNCTION zc_MILinkObject_MoneyPlace() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_MoneyPlace'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_MoneyPlace', '����� /��������� ���� / ���.����' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_MoneyPlace');

CREATE OR REPLACE FUNCTION zc_MILinkObject_InfoMoney() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_InfoMoney'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_InfoMoney', '������ ����������' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_InfoMoney');

CREATE OR REPLACE FUNCTION zc_MILinkObject_Unit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Unit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_Unit', '�������������' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Unit');

CREATE OR REPLACE FUNCTION zc_MILinkObject_Partner() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Partner'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_Partner', '���������' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Partner');

CREATE OR REPLACE FUNCTION zc_MILinkObject_Insert() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Insert'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_Insert', '������������ (��������)' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Insert');


CREATE OR REPLACE FUNCTION zc_MILinkObject_Goods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Goods'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_Goods', '�������������' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_Goods');

CREATE OR REPLACE FUNCTION zc_MILinkObject_ColorPattern() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_ColorPattern'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_ColorPattern', '������ Boat Structure' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_ColorPattern');

CREATE OR REPLACE FUNCTION zc_MILinkObject_ProdColorPattern() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_ProdColorPattern'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_ProdColorPattern', 'Boat Structure' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_ProdColorPattern');

CREATE OR REPLACE FUNCTION zc_MILinkObject_ProdOptions() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_ProdOptions'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MILinkObject_ProdOptions', '�����' WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Code = 'zc_MILinkObject_ProdOptions');

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
 10.07.18         * add zc_MILinkObject_MoneyPlace
                      , zc_MILinkObject_InfoMoney
                      , zc_MILinkObject_Unit
 25.05.17                                                          *
 15.05.17         * zc_MILinkObject_PartionMI
*/
