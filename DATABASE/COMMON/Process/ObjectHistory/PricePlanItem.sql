CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_ObjectHistory_PricePlanItem() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_ObjectHistory_PricePlanItem' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_PricePlanItem() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Update_PricePlanItem' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;

DO $$
BEGIN

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_ObjectHistory_PricePlanItem()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= 'Справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_PricePlanItem())||'> - сохранение данных.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_ObjectHistory_PricePlanItem');

 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_PricePlanItem()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 2
                                   , inName:= 'Разрешено изменение цены (план) в любом прайсе.'
                                   , inEnumName:= 'zc_Enum_Process_Update_PricePlanItem');

END $$;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.05.26         *
*/
