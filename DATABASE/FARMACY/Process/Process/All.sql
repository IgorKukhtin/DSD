-- Документ <>
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_SendAll() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_SendAll' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

DO $$
BEGIN

 -- НЕ ограничиваются Документы
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_SendAll()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 1001
                                   , inName:= 'Документ Перемещение (проведение без проверки)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_SendAll');
 
END $$;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 01.11.17                                        *
*/

