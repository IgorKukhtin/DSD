-- Документ <>
CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_Movement_Promo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_Movement_Promo' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
-- Status
CREATE OR REPLACE FUNCTION zc_Enum_Process_UnComplete_Promo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_UnComplete_Promo' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Complete_Promo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Complete_Promo' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_SetErased_Promo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_SetErased_Promo' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;


DO $$
BEGIN

-- Документ
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_Movement_Promo()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= 'Документ <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_Promo())||'> - сохранение данных.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_Movement_Promo');

-- Status_Promo
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_UnComplete_Promo()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= 'Документ <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_Promo())||'> - Распроведение.'
                                  , inEnumName:= 'zc_Enum_Process_UnComplete_Promo');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Complete_Promo()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 2
                                  , inName:= 'Документ <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_Promo())||'> - Проведение.'
                                  , inEnumName:= 'zc_Enum_Process_Complete_Promo');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_SetErased_Promo()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 3
                                  , inName:= 'Документ <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_Promo())||'> - Удаление.'
                                  , inEnumName:= 'zc_Enum_Process_SetErased_Promo');

END $$;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 11.11.15                                        *
*/
