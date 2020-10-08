CREATE OR REPLACE FUNCTION zc_ObjectFloat_Program_MajorVersion() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Program_MajorVersion'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Program_MajorVersion', zc_Object_Program(), '������ ����� ������ ���������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Program_MajorVersion');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_Program_MinorVersion() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Program_MinorVersion'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_Program_MinorVersion', zc_Object_Program(), '������ ����� ������ ���������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_Program_MinorVersion');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_ImportSettings_StartRow() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ImportSettings_StartRow'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectFloat_ImportSettings_StartRow', zc_Object_ImportSettings(), '������ ������ �������� ��� Excel' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ImportSettings_StartRow');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_ImportSettings_Time() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ImportSettings_Time'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_ImportSettings(), 'zc_ObjectFloat_ImportSettings_Time', '������������� �������� ����� � �������� �������, ���' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ImportSettings_Time');


CREATE OR REPLACE FUNCTION zc_ObjectFloat_ProdModel_Length() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ProdModel_Length'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_ProdModel(), 'zc_ObjectFloat_ProdModel_Length', '�����' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ProdModel_Length');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_ProdModel_Beam() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ProdModel_Beam'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_ProdModel(), 'zc_ObjectFloat_ProdModel_Beam', '���' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ProdModel_Beam');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_ProdModel_Height() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ProdModel_Height'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_ProdModel(), 'zc_ObjectFloat_ProdModel_Height', '������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ProdModel_Height');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_ProdModel_Weight() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ProdModel_Weight'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_ProdModel(), 'zc_ObjectFloat_ProdModel_Weight', '���' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ProdModel_Weight');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_ProdModel_Fuel() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ProdModel_Fuel'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_ProdModel(), 'zc_ObjectFloat_ProdModel_Fuel', '����� �������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ProdModel_Fuel');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_ProdModel_Speed() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ProdModel_Speed'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_ProdModel(), 'zc_ObjectFloat_ProdModel_Speed', '��������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ProdModel_Speed');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_ProdModel_Seating() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ProdModel_Seating'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_ProdModel(), 'zc_ObjectFloat_ProdModel_Seating', '�������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ProdModel_Seating');

CREATE OR REPLACE FUNCTION zc_ObjectFloat_ProdEngine_Power() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ProdEngine_Power'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectFloatDesc (DescId, Code, ItemName)
  SELECT zc_Object_ProdEngine(), 'zc_ObjectFloat_ProdEngine_Power', '�������' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Code = 'zc_ObjectFloat_ProdEngine_Power');

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 08.10.20         * zc_ObjectFloat_ProdModel...
                    zc_ObjectFloat_ProdEngine_Power
 28.08.20                                        * 
*/
