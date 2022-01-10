
CREATE OR REPLACE FUNCTION zc_ObjectDate_Protocol_Insert() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Protocol_Insert'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Client(), 'zc_ObjectDate_Protocol_Insert', '���� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Protocol_Insert');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Protocol_Update() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Protocol_Update'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Client(), 'zc_ObjectDate_Protocol_Update', '���� �������������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Protocol_Update');

/*-------------------------------------------------------------------------------
               ������� �.�.   ������ �.�.   ���������� �.�.
 10.01.22                                        * 
*/
