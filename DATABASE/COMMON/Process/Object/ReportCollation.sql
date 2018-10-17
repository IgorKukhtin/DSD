CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_Object_ReportCollation() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_Object_ReportCollation' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Insert_Object_ReportCollation_Buh() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Insert_Object_ReportCollation_Buh' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_Object_ReportCollation() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Update_Object_ReportCollation' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;

DO $$
BEGIN

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_Object_ReportCollation()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= 'сохранение данных - справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_ReportCollation())||'>.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_Object_ReportCollation');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Insert_Object_ReportCollation_Buh()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= 'Установить визу получено бухгалтерией - справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_ReportCollation())||'>.'
                                  , inEnumName:= 'zc_Enum_Process_Insert_Object_ReportCollation_Buh');
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_Object_ReportCollation()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 3
                                  , inName:= 'Изменение данных - справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_ReportCollation())||'>.'
                                  , inEnumName:= 'zc_Enum_Process_Update_Object_ReportCollation');
END $$;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.01.17                                        *
*/
