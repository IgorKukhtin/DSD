CREATE OR REPLACE FUNCTION zc_ObjectFloat_Program_MajorVersion() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Program_MajorVersion'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Program_MajorVersion', zc_Object_Program(), '������ ����� ������ ���������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Program_MajorVersion');


CREATE OR REPLACE FUNCTION zc_ObjectFloat_Program_MinorVersion() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Program_MinorVersion'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Program_MinorVersion', zc_Object_Program(), '������ ����� ������ ���������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Program_MinorVersion');



/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ��������� �.�.
 
*/
