CREATE OR REPLACE FUNCTION zc_Container_Count() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ContainerDesc WHERE Code = 'zc_Container_Count'); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
INSERT INTO ContainerDesc(Code, ItemName)
  SELECT 'zc_Container_Count', '������� ��������������� �����' WHERE NOT EXISTS (SELECT * FROM ContainerDesc WHERE Code = 'zc_Container_Count');

CREATE OR REPLACE FUNCTION zc_Container_CountSupplier() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ContainerDesc WHERE Code = 'zc_Container_CountSupplier'); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
INSERT INTO ContainerDesc(Code, ItemName)
  SELECT 'zc_Container_CountSupplier', '������� ��������������� ����� - ����� ����������' WHERE NOT EXISTS (SELECT * FROM ContainerDesc WHERE Code = 'zc_Container_CountSupplier');

CREATE OR REPLACE FUNCTION zc_Container_Summ() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ContainerDesc WHERE Code = 'zc_Container_Summ'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ContainerDesc(Code, ItemName)
  SELECT 'zc_Container_Summ', '������� ��������� �����' WHERE NOT EXISTS (SELECT * FROM ContainerDesc WHERE Code = 'zc_Container_Summ');

CREATE OR REPLACE FUNCTION zc_Container_SummCurrency() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ContainerDesc WHERE Code = 'zc_Container_SummCurrency'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ContainerDesc(Code, ItemName)
  SELECT 'zc_Container_SummCurrency', '������� ��������� ����� � ������' WHERE NOT EXISTS (SELECT * FROM ContainerDesc WHERE Code = 'zc_Container_SummCurrency');

CREATE OR REPLACE FUNCTION zc_Container_SummIncomeMovementPayment() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ContainerDesc WHERE Code = 'zc_Container_SummIncomeMovementPayment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ContainerDesc(Code, ItemName)
  SELECT 'zc_Container_SummIncomeMovementPayment', '�������� - ������� �� ������ ��������� ���������' WHERE NOT EXISTS (SELECT * FROM ContainerDesc WHERE Code = 'zc_Container_SummIncomeMovementPayment');

-- !!!Farmacy!!!
CREATE OR REPLACE FUNCTION zc_Container_CountPartionDate() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ContainerDesc WHERE Code = 'zc_Container_CountPartionDate'); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
INSERT INTO ContainerDesc(Code, ItemName)
  SELECT 'zc_Container_CountPartionDate', '������� ��������������� ����� (�� ���� ������)' WHERE NOT EXISTS (SELECT * FROM ContainerDesc WHERE Code = 'zc_Container_CountPartionDate');


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 19.04.19                                        * add zc_MIContainer_CountPartionDate
 11.02.15                         * add zc_Container_SummIncomeMovementPayment
 12.11.14                                        * add zc_Container_SummCurrency
 14.09.13                                        * add zc_Container_CountSupplier
 11.07.13                                        * ����� �����2 - Create and Insert
 05.07.13         * ����� �����
*/
