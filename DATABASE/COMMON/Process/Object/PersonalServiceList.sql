CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_Object_PersonalServiceList() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_Object_PersonalServiceList' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_Object_PersonalServiceList_Member() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Update_Object_PersonalServiceList_Member' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_Object_PersonalServiceList_PersonalOut() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Update_Object_PersonalServiceList_PersonalOut' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_Object_PersonalServiceList_User() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Update_Object_PersonalServiceList_User' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_Object_isErased_PersonalServiceList() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Update_Object_isErased_PersonalServiceList' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;



DO $$
BEGIN

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_Object_PersonalServiceList()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= 'Справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_PersonalServiceList())||'> - сохранение данных.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_Object_PersonalServiceList');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_Object_PersonalServiceList_Member()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 2
                                  , inName:= 'Справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_PersonalServiceList())||'> - сохранение данных.'
                                  , inEnumName:= 'zc_Enum_Process_Update_Object_PersonalServiceList_Member');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_Object_PersonalServiceList_PersonalOut()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 3
                                  , inName:= 'Справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_PersonalServiceList())||'> - сохранение данных.'
                                  , inEnumName:= 'zc_Enum_Process_Update_Object_PersonalServiceList_PersonalOut');
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_Object_isErased_PersonalServiceList()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 4
                                  , inName:= 'Справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_PersonalServiceList())||'> - удаление данных.'
                                  , inEnumName:= 'zc_Enum_Process_Update_Object_isErased_PersonalServiceList');  

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_Object_PersonalServiceList_User()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 5
                                  , inName:= 'Справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_PersonalServiceList())||'> - изменение данных.'
                                  , inEnumName:= 'zc_Enum_Process_Update_Object_PersonalServiceList_User'');                                
END $$;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.11.22         *
 25.05.20         *
 12.09.14         *
*/
