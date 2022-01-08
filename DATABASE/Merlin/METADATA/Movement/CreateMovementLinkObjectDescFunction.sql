CREATE OR REPLACE FUNCTION zc_MovementLinkObject_Insert() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Insert'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_Insert', '������������ ����.' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Insert');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_Update() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Update'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_Update', '������������ ����.' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Update');

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 08.01.22                                        *
*/
