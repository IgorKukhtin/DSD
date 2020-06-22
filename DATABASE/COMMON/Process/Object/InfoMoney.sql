CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_InfoMoney_ProfitLoss() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Update_InfoMoney_ProfitLoss' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_InfoMoney_CashFlow() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Update_InfoMoney_CashFlow' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;

DO $$
BEGIN

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_InfoMoney_ProfitLoss()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= 'Справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_InfoMoney())||'> - изменение данных.'
                                  , inEnumName:= 'zc_Enum_Process_Update_InfoMoney_ProfitLoss');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_InfoMoney_CashFlow()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 2
                                  , inName:= 'Справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_InfoMoney())||'> - изменение данных.'
                                  , inEnumName:= 'zc_Enum_Process_Update_InfoMoney_CashFlow');
END $$;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.12.18         *
*/
