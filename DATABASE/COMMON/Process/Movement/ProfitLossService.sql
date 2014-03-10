-- Документ <Начисления по Юридическому лицу (расходы будущих периодов)>
CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_Movement_ProfitLossService() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_Movement_ProfitLossService' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
-- Status
CREATE OR REPLACE FUNCTION zc_Enum_Process_UnComplete_ProfitLossService() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_UnComplete_ProfitLossService' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Complete_ProfitLossService() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Complete_ProfitLossService' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_CompletePeriod_ProfitLossService() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_CompletePeriod_ProfitLossService' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_SetErased_ProfitLossService() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_SetErased_ProfitLossService' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

DO $$


BEGIN

-- Документ <Продажа покупателю>
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_Movement_ProfitLossService()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= 'Документ <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_ProfitLossService())||'> - сохранение данных.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_Movement_ProfitLossService');
-- Status_ProfitLossService
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_UnComplete_ProfitLossService()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= 'Документ <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_ProfitLossService())||'> - Распроведение.'
                                  , inEnumName:= 'zc_Enum_Process_UnComplete_ProfitLossService');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Complete_ProfitLossService()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 2
                                  , inName:= 'Документ <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_ProfitLossService())||'> - Проведение.'
                                  , inEnumName:= 'zc_Enum_Process_Complete_ProfitLossService');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_SetErased_ProfitLossService()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 3
                                  , inName:= 'Документ <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_ProfitLossService())||'> - Удаление.'
                                  , inEnumName:= 'zc_Enum_Process_SetErased_ProfitLossService');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_CompletePeriod_ProfitLossService()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 4
                                  , inName:= 'Документ <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_ProfitLossService())||'> - Проведение за период.'
                                  , inEnumName:= 'zc_Enum_Process_CompletePeriod_ProfitLossService');

END $$;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 10.03.14                                        *
 14.02.14                                                        *
*/
