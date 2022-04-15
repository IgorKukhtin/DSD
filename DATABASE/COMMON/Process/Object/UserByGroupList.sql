CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_Object_UserByGroupList() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_Object_UserByGroupList' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_Object_isErased_UserByGroupList() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Update_Object_isErased_UserByGroupList' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;

DO $$
BEGIN

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_Object_UserByGroupList()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= 'Справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_UserByGroupList())||'> - сохранение данных.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_Object_UserByGroupList');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_Object_isErased_UserByGroupList()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 2
                                  , inName:= 'Справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_UserByGroupList())||'> - удаление/восстановление.'
                                  , inEnumName:= 'zc_Enum_Process_Update_Object_isErased_UserByGroupList');

END $$;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.04.22         *
*/
