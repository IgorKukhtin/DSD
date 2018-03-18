-- Документ <Возврат поставщику>
CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_Movement_Sale() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_Movement_Sale' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
-- строки
CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_MI_Sale() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_MI_Sale' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_SetErased_MI_Sale() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_SetErased_MI_Sale' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_SetUnErased_MI_Sale() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_SetUnErased_MI_Sale' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_MI_Checked() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Update_MI_Checked' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

-- Status
CREATE OR REPLACE FUNCTION zc_Enum_Process_UnComplete_Sale() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_UnComplete_Sale' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Complete_Sale() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Complete_Sale' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_SetErased_Sale() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_SetErased_Sale' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

DO $$
BEGIN

-- Документ <Приход>
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_Movement_Sale()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= 'Документ <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_Sale())||'> - сохранение данных.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_Movement_Sale');
                                  
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_MI_Sale()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 4
                                  , inName:= 'Строки документа <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_Sale())||'> - сохранение данных.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_MI_Sale');
                   
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_SetErased_MI_Sale()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 5
                                  , inName:= 'Элемент документа <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_Sale())||'> - удаление.'
                                  , inEnumName:= 'zc_Enum_Process_SetErased_MI_Sale');
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_SetUnErased_MI_Sale()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 6
                                  , inName:= 'Элемент документа <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_Sale())||'> - восстановление.'
                                  , inEnumName:= 'zc_Enum_Process_SetUnErased_MI_Sale');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_MI_Checked()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 7
                                  , inName:= 'Изменение свойства <Возврат более чем за 31 день>.'
                                  , inEnumName:= 'zc_Enum_Process_Update_MI_Checked');

-- Status_Sale
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_UnComplete_Sale()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= 'Документ <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_Sale())||'> - Распроведение.'
                                  , inEnumName:= 'zc_Enum_Process_UnComplete_Sale');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Complete_Sale()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 2
                                  , inName:= 'Документ <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_Sale())||'> - Проведение.'
                                  , inEnumName:= 'zc_Enum_Process_Complete_Sale');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_SetErased_Sale()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 3
                                  , inName:= 'Документ <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_Sale())||'> - Удаление.'
                                  , inEnumName:= 'zc_Enum_Process_SetErased_Sale');
                                  
END $$;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.04.17         *
*/
