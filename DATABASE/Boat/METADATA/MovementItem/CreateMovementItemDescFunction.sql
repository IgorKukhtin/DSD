CREATE OR REPLACE FUNCTION zc_MI_Master() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemDesc WHERE Code = 'zc_MI_Master'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemDesc (Code, ItemName)
  SELECT 'zc_MI_Master', '������� �������' WHERE NOT EXISTS (SELECT * FROM MovementItemDesc WHERE Code = 'zc_MI_Master');

CREATE OR REPLACE FUNCTION zc_MI_Child() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemDesc WHERE Code = 'zc_MI_Child'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemDesc (Code, ItemName)
  SELECT 'zc_MI_Child', '����������� �������' WHERE NOT EXISTS (SELECT * FROM MovementItemDesc WHERE Code = 'zc_MI_Child');

CREATE OR REPLACE FUNCTION zc_MI_Detail() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemDesc WHERE Code = 'zc_MI_Detail'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemDesc (Code, ItemName)
  SELECT 'zc_MI_Detail', '����������� ������� (������)' WHERE NOT EXISTS (SELECT * FROM MovementItemDesc WHERE Code = 'zc_MI_Detail');

CREATE OR REPLACE FUNCTION zc_MI_Reserv() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemDesc WHERE Code = 'zc_MI_Reserv'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemDesc (Code, ItemName)
  SELECT 'zc_MI_Reserv', '����������� ������� (������)' WHERE NOT EXISTS (SELECT * FROM MovementItemDesc WHERE Code = 'zc_MI_Reserv');
  
/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 28.08.20                                        * 
*/
