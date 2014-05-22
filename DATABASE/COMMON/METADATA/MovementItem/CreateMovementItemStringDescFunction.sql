CREATE OR REPLACE FUNCTION zc_MIString_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemStringDesc WHERE Code = 'zc_MIString_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemStringDesc (Code, ItemName)
  SELECT 'zc_MIString_Comment', '����������' WHERE NOT EXISTS (SELECT * FROM MovementItemStringDesc WHERE Code = 'zc_MIString_Comment');

CREATE OR REPLACE FUNCTION zc_MIString_PartionGoods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemStringDesc WHERE Code = 'zc_MIString_PartionGoods'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemStringDesc (Code, ItemName)
  SELECT 'zc_MIString_PartionGoods', '������ ������' WHERE NOT EXISTS (SELECT * FROM MovementItemStringDesc WHERE Code = 'zc_MIString_PartionGoods');

CREATE OR REPLACE FUNCTION zc_MIString_PartionGoodsCalc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemStringDesc WHERE Code = 'zc_MIString_PartionGoodsCalc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemStringDesc (Code, ItemName)
  SELECT 'zc_MIString_PartionGoodsCalc', '������ ������' WHERE NOT EXISTS (SELECT * FROM MovementItemStringDesc WHERE Code = 'zc_MIString_PartionGoodsCalc');

CREATE OR REPLACE FUNCTION zc_MIString_GLNCode() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemStringDesc WHERE Code = 'zc_MIString_GLNCode'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemStringDesc (Code, ItemName)
  SELECT 'zc_MIString_GLNCode', 'GLN code' WHERE NOT EXISTS (SELECT * FROM MovementItemStringDesc WHERE Code = 'zc_MIString_GLNCode');

CREATE OR REPLACE FUNCTION zc_MIString_GoodsName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemStringDesc WHERE Code = 'zc_MIString_GoodsName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemStringDesc (Code, ItemName)
  SELECT 'zc_MIString_GoodsName', 'GoodsName' WHERE NOT EXISTS (SELECT * FROM MovementItemStringDesc WHERE Code = 'zc_MIString_GoodsName');

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 12.07.13                                        * ����� �����2
 29.06.13                                        * ����� �����
 29.06.13                                        * zc_MIString_PartionGoods
*/
