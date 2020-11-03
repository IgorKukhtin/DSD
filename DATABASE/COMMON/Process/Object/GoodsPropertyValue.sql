CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_Object_GoodsPropertyValue() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_Object_GoodsPropertyValue' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_Object_GoodsPropertyValue_AmountDoc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Update_Object_GoodsPropertyValue_AmountDoc' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_Object_GoodsPropertyValue_VMS() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Update_Object_GoodsPropertyValue_VMS' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_Object_GoodsPropertyValue_External() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Update_Object_GoodsPropertyValue_External' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;

DO $$
BEGIN

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_Object_GoodsPropertyValue()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= 'Справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_GoodsPropertyValue())||'> - сохранение данных.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_Object_GoodsPropertyValue');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_Object_GoodsPropertyValue_AmountDoc()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 2
                                  , inName:= 'Справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_GoodsPropertyValue())||'> - изменение данных.'
                                  , inEnumName:= 'zc_Enum_Process_Update_Object_GoodsPropertyValue_AmountDoc');
                                  
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_Object_GoodsPropertyValue_VMS()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 3
                                  , inName:= 'Справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_GoodsPropertyValue())||'> - изменение данных.'
                                  , inEnumName:= 'zc_Enum_Process_Update_Object_GoodsPropertyValue_VMS');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_Object_GoodsPropertyValue_External()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 4
                                  , inName:= 'Справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_GoodsPropertyValue())||'> - изменение данных.'
                                  , inEnumName:= 'zc_Enum_Process_Update_Object_GoodsPropertyValue_External');
END $$;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 26.02.19         *
 27.06.17         *
 12.02.15                                        *
*/
