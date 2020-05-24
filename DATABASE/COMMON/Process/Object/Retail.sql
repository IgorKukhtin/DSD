CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_Object_Retail() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_Object_Retail' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_Object_Retail_GLNCode() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Update_Object_Retail_GLNCode' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_Object_Retail_PrintKindItem() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Update_Object_Retail_PrintKindItem' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_Object_Retail_ClientKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Update_Object_Retail_ClientKind' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_Object_Retail_isOrderMin() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Update_Object_Retail_isOrderMin' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_Object_Retail_isWMS() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Update_Object_Retail_isWMS' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;

DO $$
BEGIN

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_Object_Retail()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= 'Справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_Retail())||'> - сохранение данных.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_Object_Retail');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_Object_Retail_GLNCode()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 2
                                  , inName:= 'Справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_Retail())||'> - сохранение данных.'
                                  , inEnumName:= 'zc_Enum_Process_Update_Object_Retail_GLNCode');
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_Object_Retail_PrintKindItem()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 3
                                  , inName:= 'Справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_Retail())||'> - сохранение данных.'
                                  , inEnumName:= 'zc_Enum_Process_Update_Object_Retail_PrintKindItem');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_Object_Retail_ClientKind()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 4
                                  , inName:= 'Справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_Retail())||'> - изменение данных.'
                                  , inEnumName:= 'zc_Enum_Process_Update_Object_Retail_ClientKind');
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_Object_Retail_isOrderMin()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 5
                                  , inName:= 'Справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_Retail())||'> - изменение данных.'
                                  , inEnumName:= 'zc_Enum_Process_Update_Object_Retail_isOrderMin');
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_Object_Retail_isWMS()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 6
                                  , inName:= 'Справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_Retail())||'> - изменение данных.'
                                  , inEnumName:= 'zc_Enum_Process_Update_Object_Retail_isWMS');
END $$;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.10.19         * zc_Enum_Process_Update_Object_Retail_isOrderMin
 14.05.19         * zc_Enum_Process_Update_Object_Retail_ClientKind
 21.05.15         * add zc_Enum_Process_Update_Object_Retail_PrintKindItem
 18.03.15         *
*/
