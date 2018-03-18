CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_Object_Client() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_Object_Client' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_Object_Client_DiscountTax() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Update_Object_Client_DiscountTax' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;

DO $$
BEGIN

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_Object_Client()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= 'Справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_Client())||'> - сохранение данных.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_Object_Client');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_Object_Client_DiscountTax()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 2
                                  , inName:= 'ввод значения свойства <% скидки> больше 30%'
                                  , inEnumName:= 'zc_Enum_Process_Update_Object_Client_DiscountTax');

END $$;
