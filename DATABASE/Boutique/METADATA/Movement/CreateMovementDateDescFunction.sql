
CREATE OR REPLACE FUNCTION zc_MovementDate_Insert() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_Insert'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_Insert', '����/����� ��������' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_Insert');

CREATE OR REPLACE FUNCTION zc_MovementDate_Update() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_Update'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_Update', '����/����� �������������' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_Update');


/*-------------------------------------------------------------------------------
 !!!!!!!!!!!!!!!!!!! ������������ ����� �� �������� !!!!!!!!!!!!!!!!!!!
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   �������   �����
 25.02.17                                        * start
*/
