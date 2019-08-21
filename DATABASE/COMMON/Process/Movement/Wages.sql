-- Документ <З/П сотрудников>
CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_Movement_Wages() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_Movement_Wages' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

-- Строки Документа <З/П сотрудников>
CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_MI_Wages() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_MI_Wages' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

DO $$
BEGIN

-- Документ <З/П сотрудников>
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_Movement_Wages()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= 'Документ <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_Wages())||'> - сохранение данных.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_Movement_Wages');                                  

 -- Строки Документа <З/П сотрудников>
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_MI_Wages()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= 'Строки документа <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_Wages())||'> - сохранение данных.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_MI_Wages');

END $$;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий O.В.
 21.08.19                                                       *              

*/
