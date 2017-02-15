
CREATE OR REPLACE FUNCTION zc_ObjectDate_Personal_In() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Personal_In'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Personal(), 'zc_ObjectDate_Personal_In', '���� �������� � ����������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Personal_In');

CREATE OR REPLACE FUNCTION zc_ObjectDate_Personal_Out() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Personal_Out'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDateDesc (DescId, Code, ItemName)
  SELECT zc_Object_Personal(), 'zc_ObjectDate_Personal_Out', '���� ���������� � ����������' WHERE NOT EXISTS (SELECT * FROM ObjectDateDesc WHERE Code = 'zc_ObjectDate_Personal_Out');


/*-------------------------------------------------------------------------------
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.
 
*/
