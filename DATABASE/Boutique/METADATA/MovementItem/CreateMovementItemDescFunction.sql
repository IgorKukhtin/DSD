CREATE OR REPLACE FUNCTION zc_MI_Master() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemDesc WHERE Code = 'zc_MI_Master'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemDesc (Code, ItemName)
  SELECT 'zc_MI_Master', '������� ������� ���������' WHERE NOT EXISTS (SELECT * FROM MovementItemDesc WHERE Code = 'zc_MI_Master');

CREATE OR REPLACE FUNCTION zc_MI_Child() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemDesc WHERE Code = 'zc_MI_Child'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemDesc (Code, ItemName)
  SELECT 'zc_MI_Child', '����������� ������� ���������' WHERE NOT EXISTS (SELECT * FROM MovementItemDesc WHERE Code = 'zc_MI_Child');

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 12.07.13                                        * ����� �����2
 30.06.13                                        * rename zc_MI...
 30.06.13                                        * ����� �����
*/
