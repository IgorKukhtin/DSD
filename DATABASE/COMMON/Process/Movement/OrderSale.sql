-- Документ <>
CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_Movement_OrderSale() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_Movement_OrderSale' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
-- Status
CREATE OR REPLACE FUNCTION zc_Enum_Process_UnComplete_OrderSale() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_UnComplete_OrderSale' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Complete_OrderSale() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Complete_OrderSale' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_SetErased_OrderSale() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_SetErased_OrderSale' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

DO $$


BEGIN

-- Документ
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_Movement_OrderSale()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= 'Документ <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_OrderSale())||'> - сохранение данных.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_Movement_OrderSale');

-- Status_OrderSale
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_UnComplete_OrderSale()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= 'Документ <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_OrderSale())||'> - Распроведение.'
                                  , inEnumName:= 'zc_Enum_Process_UnComplete_OrderSale');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Complete_OrderSale()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 2
                                  , inName:= 'Документ <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_OrderSale())||'> - Проведение.'
                                  , inEnumName:= 'zc_Enum_Process_Complete_OrderSale');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_SetErased_OrderSale()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 3
                                  , inName:= 'Документ <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_OrderSale())||'> - Удаление.'
                                  , inEnumName:= 'zc_Enum_Process_SetErased_OrderSale');

END $$;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.01.21         *
*/
