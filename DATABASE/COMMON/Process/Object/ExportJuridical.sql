CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_Object_ExportJuridical() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_Object_ExportJuridical' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;

DO $$
BEGIN

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_Object_ExportJuridical()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= 'Справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_ExportJuridical())||'> - сохранение данных.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_Object_ExportJuridical');


END $$;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.03.16         *
*/
