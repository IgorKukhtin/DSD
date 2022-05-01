CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_ObjectCode_Basis() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_ObjectCode_Basis' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;

DO $$
BEGIN

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_ObjectCode_Basis()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= '<Главный код> - изменение данных.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_ObjectCode_Basis');


END $$;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.04.22         *
*/
