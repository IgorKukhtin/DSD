-- Документ
CREATE OR REPLACE FUNCTION zc_Enum_Process_IU_Movement_InventoryHouseholdInventory() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_IU_Movement_InventoryHouseholdInventory' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
-- строки
CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_MI_InventoryHouseholdInventory() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_MI_InventoryHouseholdInventory' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
-- Status
CREATE OR REPLACE FUNCTION zc_Enum_Process_UnComplete_InventoryHouseholdInventory() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_UnComplete_InventoryHouseholdInventory' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Complete_InventoryHouseholdInventory() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Complete_InventoryHouseholdInventory' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_SetErased_InventoryHouseholdInventory() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_SetErased_InventoryHouseholdInventory' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

DO $$


BEGIN

-- Документ
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_IU_Movement_InventoryHouseholdInventory()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= 'Документ <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_InventoryHouseholdInventory())||'> - сохранение данных.'
                                  , inEnumName:= 'zc_Enum_Process_IU_Movement_InventoryHouseholdInventory');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_MI_InventoryHouseholdInventory()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= 'Элемент документа <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_InventoryHouseholdInventory())||'> - сохранение данных.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_MI_InventoryHouseholdInventory');

                                  
-- Status_InventoryHouseholdInventory
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_UnComplete_InventoryHouseholdInventory()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= 'Документ <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_InventoryHouseholdInventory())||'> - Распроведение.'
                                  , inEnumName:= 'zc_Enum_Process_UnComplete_InventoryHouseholdInventory');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Complete_InventoryHouseholdInventory()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 2
                                  , inName:= 'Документ <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_InventoryHouseholdInventory())||'> - Проведение.'
                                  , inEnumName:= 'zc_Enum_Process_Complete_InventoryHouseholdInventory');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_SetErased_InventoryHouseholdInventory()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 3
                                  , inName:= 'Документ <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_InventoryHouseholdInventory())||'> - Удаление.'
                                  , inEnumName:= 'zc_Enum_Process_SetErased_InventoryHouseholdInventory');

END $$;


-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 17.07.20                                                       *
*/
