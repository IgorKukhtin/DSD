CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_ObjectHistory_PriceListItem() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_ObjectHistory_PriceListItem' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Get_OH_PriceListItem() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Get_OH_PriceListItem' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Select_OH_PriceListItem() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Select_OH_PriceListItem' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Select_OH_PriceListGoodsItem() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Select_OH_PriceListGoodsItem' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_OH_PriceListItem_zero() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_OH_PriceListItem_zero' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;
DO $$
BEGIN

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_ObjectHistory_PriceListItem()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= 'Справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_PriceListItem())||'> - сохранение данных.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_ObjectHistory_PriceListItem');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Get_OH_PriceListItem()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 2
                                  , inName:= 'Справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_PriceListItem())||'> - просмотр данных.'
                                  , inEnumName:= 'zc_Enum_Process_Get_OH_PriceListItem');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Select_OH_PriceListItem()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 3
                                  , inName:= 'Справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_PriceListItem())||'> - просмотр данных.'
                                  , inEnumName:= 'zc_Enum_Process_Select_OH_PriceListItem');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Select_OH_PriceListGoodsItem()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 4
                                  , inName:= 'Справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_PriceListItem())||'> - просмотр данных.'
                                  , inEnumName:= 'zc_Enum_Process_Select_OH_PriceListGoodsItem');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_OH_PriceListItem_zero()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 4
                                  , inName:= 'Справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_PriceListItem())||'> - изменение данных.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_OH_PriceListItem_zero');
END $$;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 26.04.18         *
 18.04.14                                        *
*/
