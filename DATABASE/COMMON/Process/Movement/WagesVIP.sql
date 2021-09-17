-- Документ <З/П VIP менеджеров>
CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_Movement_WagesVIP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_Movement_WagesVIP' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

-- Строки Документа <З/П VIP менеджеров>
CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_MI_WagesVIP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_MI_WagesVIP' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

DO $$
BEGIN

-- Документ <З/П VIP менеджеров>
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_Movement_WagesVIP()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= 'Документ <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_WagesVIP())||'> - сохранение данных.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_Movement_WagesVIP');                                  

 -- Строки Документа <З/П VIP менеджеров>
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_MI_WagesVIP()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= 'Строки документа <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_WagesVIP())||'> - сохранение данных.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_MI_WagesVIP');

END $$;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий O.В.
 17.09.21                                                       *              

*/
