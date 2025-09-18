-- Документ <ШР сотрудник>
CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_Movement_StaffListMember() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_Movement_StaffListMember' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

-- Строки Документа <ШР сотрудник>
CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_MI_StaffListMember() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_MI_StaffListMember' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_SetErased_MI_StaffListMember() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_SetErased_MI_StaffListMember' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_SetUnErased_MI_StaffListMember() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_SetUnErased_MI_StaffListMember' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

-- Status
CREATE OR REPLACE FUNCTION zc_Enum_Process_UnComplete_StaffListMember() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_UnComplete_StaffListMember' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Complete_StaffListMember() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Complete_StaffListMember' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_SetErased_StaffListMember() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_SetErased_StaffListMember' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

DO $$
BEGIN

-- Документ <ШР сотрудник>
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_Movement_StaffListMember()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= 'Документ <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_StaffListMember())||'> - сохранение данных.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_Movement_StaffListMember');
                                
-- Строки Документа <ШР сотрудник>
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_MI_StaffListMember()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 2
                                  , inName:= 'Элемент документа <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_StaffListMember())||'> - сохранение данных.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_MI_StaffListMember');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_SetErased_MI_StaffListMember()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 3
                                  , inName:= 'Элемент документа <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_StaffListMember())||'> - удаление.'
                                  , inEnumName:= 'zc_Enum_Process_SetErased_MI_StaffListMember');
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_SetUnErased_MI_StaffListMember()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 4
                                  , inName:= 'Элемент документа <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_StaffListMember())||'> - восстановление.'
                                  , inEnumName:= 'zc_Enum_Process_SetUnErased_MI_StaffListMember');
                                                                  
-- Status_StaffListMember
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_UnComplete_StaffListMember()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= 'Документ <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_StaffListMember())||'> - Распроведение.'
                                  , inEnumName:= 'zc_Enum_Process_UnComplete_StaffListMember');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Complete_StaffListMember()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 2
                                  , inName:= 'Документ <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_StaffListMember())||'> - Проведение.'
                                  , inEnumName:= 'zc_Enum_Process_Complete_StaffListMember');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_SetErased_StaffListMember()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 3
                                  , inName:= 'Документ <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_StaffListMember())||'> - Удаление.'
                                  , inEnumName:= 'zc_Enum_Process_SetErased_StaffListMember');

END $$;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.09.25         *              
*/
