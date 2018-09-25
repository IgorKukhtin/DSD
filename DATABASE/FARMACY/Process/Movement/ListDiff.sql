-- Документ
CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_Movement_ListDiff() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_Movement_ListDiff' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_Movement_ListDiff_From_Kind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_Movement_ListDiff_From_Kind' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_Movement_ListDiff_IsRegistered() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Update_Movement_ListDiff_IsRegistered' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_Movement_ListDiff_BranchDate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Update_Movement_ListDiff_BranchDate' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
-- строки
CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_MI_ListDiff() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_MI_ListDiff' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_SetErased_MI_ListDiff() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_SetErased_MI_ListDiff' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_SetUnErased_MI_ListDiff() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_SetUnErased_MI_ListDiff' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
-- Status
CREATE OR REPLACE FUNCTION zc_Enum_Process_UnComplete_ListDiff() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_UnComplete_ListDiff' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Complete_ListDiff() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Complete_ListDiff' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Enum_Process_SetErased_ListDiff() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_SetErased_ListDiff' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_CompleteDate_ListDiff() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_CompleteDate_ListDiff' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

DO $$


BEGIN

-- Документ
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_Movement_ListDiff()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= 'Документ <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_ListDiff())||'> - сохранение данных.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_Movement_ListDiff');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_MI_ListDiff()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= 'Элемент документа <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_ListDiff())||'> - сохранение данных.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_MI_ListDiff');
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_SetErased_MI_ListDiff()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 2
                                  , inName:= 'Элемент документа <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_ListDiff())||'> - удаление.'
                                  , inEnumName:= 'zc_Enum_Process_SetErased_MI_ListDiff');
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_SetUnErased_MI_ListDiff()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 3
                                  , inName:= 'Элемент документа <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_ListDiff())||'> - восстановление.'
                                  , inEnumName:= 'zc_Enum_Process_SetUnErased_MI_ListDiff');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_Movement_ListDiff_BranchDate()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 4
                                  , inName:= 'Элемент документа <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_ListDiff())||'> - сохранение данных.'
                                  , inEnumName:= 'zc_Enum_Process_Update_Movement_ListDiff_BranchDate');
                                  
-- Status_ListDiff
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_UnComplete_ListDiff()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= 'Документ <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_ListDiff())||'> - Распроведение.'
                                  , inEnumName:= 'zc_Enum_Process_UnComplete_ListDiff');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Complete_ListDiff()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 2
                                  , inName:= 'Документ <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_ListDiff())||'> - Проведение.'
                                  , inEnumName:= 'zc_Enum_Process_Complete_ListDiff');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_SetErased_ListDiff()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 3
                                  , inName:= 'Документ <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_ListDiff())||'> - Удаление.'
                                  , inEnumName:= 'zc_Enum_Process_SetErased_ListDiff');
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_CompleteDate_ListDiff()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 4
                                  , inName:= 'Документ <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_ListDiff())||'> - Проведение задним числом.'
                                  , inEnumName:= 'zc_Enum_Process_CompleteDate_ListDiff');

END $$;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.08.18         *
*/
