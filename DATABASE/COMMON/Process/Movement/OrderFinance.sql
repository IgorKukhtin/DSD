-- Документ <>
CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_Movement_OrderFinance() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_Movement_OrderFinance' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
-- строки
CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_MI_OrderFinance() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_MI_OrderFinance' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_SetErased_MI_OrderFinance() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_SetErased_MI_OrderFinance' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_SetUnErased_MI_OrderFinance() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_SetUnErased_MI_OrderFinance' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
-- Status
CREATE OR REPLACE FUNCTION zc_Enum_Process_UnComplete_OrderFinance() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_UnComplete_OrderFinance' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Complete_OrderFinance() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Complete_OrderFinance' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_SetErased_OrderFinance() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_SetErased_OrderFinance' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

DO $$


BEGIN

-- Документ
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_Movement_OrderFinance()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= 'Документ <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_OrderFinance())||'> - сохранение данных.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_Movement_OrderFinance');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_MI_OrderFinance()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= 'Элемент документа <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_OrderFinance())||'> - сохранение данных.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_MI_OrderFinance');
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_SetErased_MI_OrderFinance()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 2
                                  , inName:= 'Элемент документа <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_OrderFinance())||'> - удаление.'
                                  , inEnumName:= 'zc_Enum_Process_SetErased_MI_OrderFinance');
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_SetUnErased_MI_OrderFinance()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 3
                                  , inName:= 'Элемент документа <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_OrderFinance())||'> - восстановление.'
                                  , inEnumName:= 'zc_Enum_Process_SetUnErased_MI_OrderFinance');
-- Status_OrderFinance
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_UnComplete_OrderFinance()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= 'Документ <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_OrderFinance())||'> - Распроведение.'
                                  , inEnumName:= 'zc_Enum_Process_UnComplete_OrderFinance');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Complete_OrderFinance()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 2
                                  , inName:= 'Документ <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_OrderFinance())||'> - Проведение.'
                                  , inEnumName:= 'zc_Enum_Process_Complete_OrderFinance');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_SetErased_OrderFinance()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 3
                                  , inName:= 'Документ <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_OrderFinance())||'> - Удаление.'
                                  , inEnumName:= 'zc_Enum_Process_SetErased_OrderFinance');

END $$;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 30.07.19         *
*/
