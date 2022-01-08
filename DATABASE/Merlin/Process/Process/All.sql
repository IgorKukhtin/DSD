-- 
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_Check() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_Check' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

DO $$
BEGIN

 -- для ....
 PERFORM lpInsertUpdate_Object_Enum (inId      := zc_Enum_Process_AccessKey_Check()
                                   , inDescId  := zc_Object_Process()
                                   , inCode    := 1
                                   , inName    := 'Пользователи с проверкой прав'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_Check');


END $$;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 08.04.18                                        *
*/
