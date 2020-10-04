CREATE OR REPLACE FUNCTION zc_ObjectString_User_Password() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_Password'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_User_Password', zc_Object_User(), '������ ������������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_Password');

-- ��� ������������� ��������, ����� �������������� � ���� ��������
CREATE OR REPLACE FUNCTION zc_ObjectString_Enum() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Enum'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Enum', NULL, '������� ������-������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Enum');

CREATE OR REPLACE FUNCTION zc_ObjectString_Form_HelpFile() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Form_HelpFile'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Form_HelpFile', zc_Object_Form(), '���� � ����� ������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Form_HelpFile');

-- Add ProjectBoat

CREATE OR REPLACE FUNCTION zc_ObjectString_TranslateWord_Name() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_TranslateWord_Name'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_TranslateWord_Name', zc_Object_Form(), '�������� ��������' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_TranslateWord_Name');


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 28.08.20                                        * 
*/
