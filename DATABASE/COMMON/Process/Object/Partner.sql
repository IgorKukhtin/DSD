CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_Object_Partner() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_Object_Partner' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_Object_Partner_Order() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Update_Object_Partner_Order' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_Object_Partner_PriceList() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Update_Object_Partner_PriceList' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_Object_Partner_Address() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Update_Object_Partner_Address' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_Object_Partner_GLN() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Update_Object_Partner_GLN' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;


DO $$
BEGIN

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_Object_Partner()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= 'Справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_Partner())||'> - сохранение данных.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_Object_Partner');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_Object_Partner_Order()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 2
                                  , inName:= 'Справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_Partner())||'> - сохранение данных.'
                                  , inEnumName:= 'zc_Enum_Process_Update_Object_Partner_Order');
                                  
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_Object_Partner_PriceList()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 3
                                  , inName:= 'Справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_Partner())||'> - сохранение данных.'
                                  , inEnumName:= 'zc_Enum_Process_Update_Object_Partner_PriceList');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_Object_Partner_Address()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 4
                                  , inName:= 'Справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_Partner())||'> - сохранение данных.'
                                  , inEnumName:= 'zc_Enum_Process_Update_Object_Partner_Address');
                                  
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_Object_Partner_GLN()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 5
                                  , inName:= 'Справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_Partner())||'> - сохранение данных.'
                                  , inEnumName:= 'zc_Enum_Process_Update_Object_Partner_GLN');

END $$;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.10.14                                        * add zc_Enum_Process_Update_Object_Partner_Order AND zc_Enum_Process_Update_Object_Partner_PriceList
 05.12.13         *
*/
