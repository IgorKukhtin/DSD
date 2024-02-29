-- Документ <Премия за лучшую бригаду>
CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_Movement_PersonalGroupSummAdd() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_Movement_PersonalGroupSummAdd' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

-- Строки Документа <Премия за лучшую бригаду>
CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_MI_PersonalGroupSummAdd() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_MI_PersonalGroupSummAdd' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_SetErased_MI_PersonalGroupSummAdd() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_SetErased_MI_PersonalGroupSummAdd' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_SetUnErased_MI_PersonalGroupSummAdd() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_SetUnErased_MI_PersonalGroupSummAdd' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

-- Status
CREATE OR REPLACE FUNCTION zc_Enum_Process_UnComplete_PersonalGroupSummAdd() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_UnComplete_PersonalGroupSummAdd' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Complete_PersonalGroupSummAdd() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Complete_PersonalGroupSummAdd' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_SetErased_PersonalGroupSummAdd() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_SetErased_PersonalGroupSummAdd' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

DO $$
BEGIN

-- Документ <Премия за лучшую бригаду>
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_Movement_PersonalGroupSummAdd()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= 'Документ <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_PersonalGroupSummAdd())||'> - сохранение данных.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_Movement_PersonalGroupSummAdd');
                                
-- Строки Документа <Премия за лучшую бригаду>
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_MI_PersonalGroupSummAdd()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 2
                                  , inName:= 'Элемент документа <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_PersonalGroupSummAdd())||'> - сохранение данных.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_MI_PersonalGroupSummAdd');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_SetErased_MI_PersonalGroupSummAdd()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 3
                                  , inName:= 'Элемент документа <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_PersonalGroupSummAdd())||'> - удаление.'
                                  , inEnumName:= 'zc_Enum_Process_SetErased_MI_PersonalGroupSummAdd');
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_SetUnErased_MI_PersonalGroupSummAdd()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 4
                                  , inName:= 'Элемент документа <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_PersonalGroupSummAdd())||'> - восстановление.'
                                  , inEnumName:= 'zc_Enum_Process_SetUnErased_MI_PersonalGroupSummAdd');
                                                                  
-- Status_PersonalGroupSummAdd
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_UnComplete_PersonalGroupSummAdd()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= 'Документ <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_PersonalGroupSummAdd())||'> - Распроведение.'
                                  , inEnumName:= 'zc_Enum_Process_UnComplete_PersonalGroupSummAdd');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Complete_PersonalGroupSummAdd()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 2
                                  , inName:= 'Документ <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_PersonalGroupSummAdd())||'> - Проведение.'
                                  , inEnumName:= 'zc_Enum_Process_Complete_PersonalGroupSummAdd');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_SetErased_PersonalGroupSummAdd()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 3
                                  , inName:= 'Документ <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_PersonalGroupSummAdd())||'> - Удаление.'
                                  , inEnumName:= 'zc_Enum_Process_SetErased_PersonalGroupSummAdd');

END $$;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.02.24         *              
*/
