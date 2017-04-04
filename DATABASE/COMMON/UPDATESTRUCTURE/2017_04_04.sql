CREATE OR REPLACE FUNCTION zc_ObjectString_Juridical_GUID() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Juridical_GUID'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Juridical_GUID', zc_Object_Juridical(), 'Глобальный уникальный идентификатор' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Juridical_GUID');

CREATE OR REPLACE FUNCTION zc_ObjectString_Partner_GUID() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_GUID'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectStringDesc (Code, DescId, ItemName)
  SELECT 'zc_ObjectString_Partner_GUID', zc_Object_Partner(), 'Глобальный уникальный идентификатор' WHERE NOT EXISTS (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_GUID');
