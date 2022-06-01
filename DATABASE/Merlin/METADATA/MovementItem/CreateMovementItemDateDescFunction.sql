CREATE OR REPLACE FUNCTION zc_MIDate_Insert() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_Insert'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemDateDesc (Code, ItemName)
  SELECT 'zc_MIDate_Insert', '����/����� ��������' WHERE NOT EXISTS (SELECT * FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_Insert');

CREATE OR REPLACE FUNCTION zc_MIDate_ServiceDate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_ServiceDate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemDateDesc (Code, ItemName)
  SELECT 'zc_MIDate_ServiceDate', '����� ����������' WHERE NOT EXISTS (SELECT * FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_ServiceDate');

CREATE OR REPLACE FUNCTION zc_MIDate_Update() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_Update'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemDateDesc (Code, ItemName)
  SELECT 'zc_MIDate_Update', '����/����� �������������' WHERE NOT EXISTS (SELECT * FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_Update');
                          
CREATE OR REPLACE FUNCTION zc_MIDate_DateEnd() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_DateEnd'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemDateDesc (Code, ItemName)
  SELECT 'zc_MIDate_DateEnd', '����, �� ������� ��������� �������' WHERE NOT EXISTS (SELECT * FROM MovementItemDateDesc WHERE Code = 'zc_MIDate_DateEnd');
 
/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 01.06.22         * zc_MIDate_DateEnd
 14.01.22         * zc_MIDate_ServiceDate
 08.01.22                                        *
*/
