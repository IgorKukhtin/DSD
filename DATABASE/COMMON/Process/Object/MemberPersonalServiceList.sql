CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_Object_MemberPersonalServiceList() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_Object_MemberSheetWorkTime' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;

DO $$
BEGIN

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_Object_MemberSheetWorkTime()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= 'Справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_MemberSheetWorkTime())||'> - сохранение данных.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_Object_MemberSheetWorkTime');


END $$;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.07.18         *
*/
