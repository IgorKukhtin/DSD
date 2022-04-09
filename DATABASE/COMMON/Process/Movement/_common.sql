-- Документ <...>
CREATE OR REPLACE FUNCTION zc_Enum_Process_UpdateMovement_isCopy() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_UpdateMovement_isCopy' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

-- Документ <...>
CREATE OR REPLACE FUNCTION zc_Enum_Process_UpdateMovement_Branch() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_UpdateMovement_Branch' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

-- Документ <...>
CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_MI_Price_Currency() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Update_MI_Price_Currency' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

--
CREATE OR REPLACE FUNCTION zc_Enum_Process_Get_Movement_Form_Process() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Get_Movement_Form_Process' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

DO $$
BEGIN

-- Документ <>
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_UpdateMovement_isCopy()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= 'Начисление бонусов Да/Нет.'
                                  , inEnumName:= 'zc_Enum_Process_UpdateMovement_isCopy');


-- Документ <>
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_UpdateMovement_Branch()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= 'Проведение документов - нет проверки по филиалу.'
                                  , inEnumName:= 'zc_Enum_Process_UpdateMovement_Branch');

-- Документ <>
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_MI_Price_Currency()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= 'Пересчитать цены документа в валюте.'
                                  , inEnumName:= 'zc_Enum_Process_Update_MI_Price_Currency');


-- Документ <>
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Get_Movement_Form_Process()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= 'Просмотр документов Да/Нет.'
                                  , inEnumName:= 'zc_Enum_Process_Get_Movement_Form_Process');

END $$;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.11.14                                        *
*/
