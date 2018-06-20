-- Документ <...>
CREATE OR REPLACE FUNCTION zc_Enum_Process_Get_Movement_Form() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Get_Movement_Form' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

DO $$
BEGIN

-- Документ <>
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Get_Movement_Form()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= 'Получение Формы документа.'
                                  , inEnumName:= 'zc_Enum_Process_Get_Movement_Form');

END $$;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.06.18         *
*/
