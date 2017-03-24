CREATE OR REPLACE FUNCTION zc_MIString_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemStringDesc WHERE Code = 'zc_MIString_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemStringDesc (Code, ItemName)
  SELECT 'zc_MIString_Comment', '����������' WHERE NOT EXISTS (SELECT * FROM MovementItemStringDesc WHERE Code = 'zc_MIString_Comment');

CREATE OR REPLACE FUNCTION zc_MIString_PartionGoods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemStringDesc WHERE Code = 'zc_MIString_PartionGoods'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemStringDesc (Code, ItemName)
  SELECT 'zc_MIString_PartionGoods', '������ �����' WHERE NOT EXISTS (SELECT * FROM MovementItemStringDesc WHERE Code = 'zc_MIString_PartionGoods');

CREATE OR REPLACE FUNCTION zc_MIString_PartionGoodsCalc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemStringDesc WHERE Code = 'zc_MIString_PartionGoodsCalc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemStringDesc (Code, ItemName)
  SELECT 'zc_MIString_PartionGoodsCalc', '������ (������)' WHERE NOT EXISTS (SELECT * FROM MovementItemStringDesc WHERE Code = 'zc_MIString_PartionGoodsCalc');

CREATE OR REPLACE FUNCTION zc_MIString_GLNCode() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemStringDesc WHERE Code = 'zc_MIString_GLNCode'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemStringDesc (Code, ItemName)
  SELECT 'zc_MIString_GLNCode', 'GLN code' WHERE NOT EXISTS (SELECT * FROM MovementItemStringDesc WHERE Code = 'zc_MIString_GLNCode');

CREATE OR REPLACE FUNCTION zc_MIString_GoodsName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemStringDesc WHERE Code = 'zc_MIString_GoodsName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemStringDesc (Code, ItemName)
  SELECT 'zc_MIString_GoodsName', 'GoodsName' WHERE NOT EXISTS (SELECT * FROM MovementItemStringDesc WHERE Code = 'zc_MIString_GoodsName');

CREATE OR REPLACE FUNCTION zc_MIString_FEA() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemStringDesc WHERE Code = 'zc_MIString_FEA'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemStringDesc (Code, ItemName)
  SELECT 'zc_MIString_FEA', '��� �� ���' WHERE NOT EXISTS (SELECT * FROM MovementItemStringDesc WHERE Code = 'zc_MIString_FEA');

CREATE OR REPLACE FUNCTION zc_MIString_Measure() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemStringDesc WHERE Code = 'zc_MIString_Measure'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemStringDesc (Code, ItemName)
  SELECT 'zc_MIString_Measure', '������� ���������' WHERE NOT EXISTS (SELECT * FROM MovementItemStringDesc WHERE Code = 'zc_MIString_Measure');

CREATE OR REPLACE FUNCTION zc_MIString_Description() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemStringDesc WHERE Code = 'zc_MIString_Description'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemStringDesc (Code, ItemName)
  SELECT 'zc_MIString_Description', '�������� �������' WHERE NOT EXISTS (SELECT * FROM MovementItemStringDesc WHERE Code = 'zc_MIString_Description');

----!!!!!!Farmacy
CREATE OR REPLACE FUNCTION zc_MIString_SertificatNumber() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemStringDesc WHERE Code = 'zc_MIString_SertificatNumber'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemStringDesc (Code, ItemName)
  SELECT 'zc_MIString_SertificatNumber', '����� ����������� �����������' WHERE NOT EXISTS (SELECT * FROM MovementItemStringDesc WHERE Code = 'zc_MIString_SertificatNumber');

CREATE OR REPLACE FUNCTION zc_MIString_Maker() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemStringDesc WHERE Code = 'zc_MIString_Maker'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemStringDesc (Code, ItemName)
  SELECT 'zc_MIString_Maker', '�������������' WHERE NOT EXISTS (SELECT * FROM MovementItemStringDesc WHERE Code = 'zc_MIString_Maker');

CREATE OR REPLACE FUNCTION zc_MIString_UID() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemStringDesc WHERE Code = 'zc_MIString_UID'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemStringDesc (Code, ItemName)
  SELECT 'zc_MIString_UID', 'UID �������� ����' WHERE NOT EXISTS (SELECT * FROM MovementItemStringDesc WHERE Code = 'zc_MIString_UID');
  
CREATE OR REPLACE FUNCTION zc_MIString_GUID() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemStringDesc WHERE Code = 'zc_MIString_GUID'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemStringDesc (Code, ItemName)
  SELECT 'zc_MIString_GUID', '���������� ���������� �������������' WHERE NOT EXISTS (SELECT * FROM MovementItemStringDesc WHERE Code = 'zc_MIString_GUID');
  
/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ��������� �.�.  �������� �.�.
 24.03.17         * zc_MIString_Description
 28.02.17                                                                        * zc_MIString_GUID
 10.08.16                                                          * zc_MIString_UID
 14.07.16         *
 01.10.15                                                          * zc_MIString_RegNumber
 12.07.13                                        * ����� �����2
 29.06.13                                        * ����� �����
 29.06.13                                        * zc_MIString_PartionGoods
*/
