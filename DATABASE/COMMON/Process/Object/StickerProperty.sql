CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_Object_StickerProperty() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_Object_StickerProperty' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_Object_StickerProperty_CK() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Update_Object_StickerProperty_CK' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_Object_StickerProperty_NormInDays_not() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Update_Object_StickerProperty_NormInDays_not' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;
  
DO $$
BEGIN

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_Object_StickerProperty()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= 'Справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_StickerProperty())||'> - сохранение данных.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_Object_StickerProperty');
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_Object_StickerProperty_CK()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 2
                                  , inName:= 'Справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_StickerProperty())||'> - сохранение данных.'
                                  , inEnumName:= 'zc_Enum_Process_Update_Object_StickerProperty_CK');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_Object_StickerProperty_NormInDays_not()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 3
                                  , inName:= 'Справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_StickerProperty())||'> - изменение данных.'
                                  , inEnumName:= 'zc_Enum_Process_Update_Object_StickerProperty_NormInDays_not');
END $$;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.10.17         *
*/
