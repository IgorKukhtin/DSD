CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_Object_User() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_Object_User' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Get_Object_User() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Get_Object_User' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Select_Object_User() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Select_Object_User' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION zc_Enum_Process_Null() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Null' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;

DO $$
BEGIN

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_Object_User()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= 'Справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_User())||'> - сохранение данных.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_Object_User');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Get_Object_User()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 2
                                  , inName:= 'Справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_User())||'> - выбор данных.'
                                  , inEnumName:= 'zc_Enum_Process_Get_Object_User');
                                  
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Select_Object_User()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 3
                                  , inName:= 'Справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_User())||'> - получение данных.'
                                  , inEnumName:= 'zc_Enum_Process_Select_Object_User');
                                  
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Null()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 123
                                  , inName:= 'Процесс удален'
                                  , inEnumName:= 'zc_Enum_Process_Null');

END $$;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.04.14                                        * add zc_Enum_Process_Null
 25.10.13                                        * add PERFORM
 07.10.13                                        *
*/
