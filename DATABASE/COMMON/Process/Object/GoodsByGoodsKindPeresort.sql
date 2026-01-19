CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_Object_GoodsByGoodsKindPeresort() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_Object_GoodsByGoodsKindPeresort' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_Object_isErased_GoodsByGoodsKindPeresort() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_Object_GoodsByGoodsKindPeresort' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;
 

DO $$
BEGIN

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_Object_GoodsByGoodsKindPeresort()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= 'Справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_GoodsByGoodsKindPeresort())||'> - сохранение данных.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_Object_GoodsByGoodsKindPeresort');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_Object_isErased_GoodsByGoodsKindPeresort()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 2
                                  , inName:= 'Справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_GoodsByGoodsKindPeresort())||'> - удаление данных.'
                                  , inEnumName:= 'zc_Enum_Process_Update_Object_isErased_GoodsByGoodsKindPeresort');
END $$;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.01.26         *
 23.05.24         * 
*/
