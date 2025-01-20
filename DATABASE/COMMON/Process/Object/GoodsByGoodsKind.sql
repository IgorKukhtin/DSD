CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_Object_GoodsByGoodsKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_Object_GoodsByGoodsKind' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_Object_GoodsByGoodsKind_isOrder() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_Object_GoodsByGoodsKind_isOrder' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_Object_GoodsByGoodsKind_isScaleCeh() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_Object_GoodsByGoodsKind_isScaleCeh' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_Object_GoodsByGoodsKind_VMC() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_Object_GoodsByGoodsKind_VMC' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_GoodsByGoodsKind_OrderScaleCeh() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Update_GoodsByGoodsKind_OrderScaleCeh' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_Object_GoodsByGoodsKind_Sticker() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Update_Object_GoodsByGoodsKind_Sticker' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_Object_GoodsByGoodsKind_Norm() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Update_Object_GoodsByGoodsKind_Norm' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_GoodsByGoodsKind_NewQuality() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Update_GoodsByGoodsKind_NewQuality' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_GoodsByGoodsKind_Top() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Update_GoodsByGoodsKind_Top' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_GoodsByGoodsKind_isNotPack() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Update_GoodsByGoodsKind_isNotPack' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_GoodsByGoodsKind_PackOrder() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Update_GoodsByGoodsKind_PackOrder' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_GoodsByGoodsKind_PackLimit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Update_GoodsByGoodsKind_PackLimit' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_GoodsByGoodsKind_Etiketka() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Update_GoodsByGoodsKind_Etiketka' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;

DO $$
BEGIN

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_Object_GoodsByGoodsKind()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= 'Справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_GoodsByGoodsKind())||'> - сохранение данных.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_Object_GoodsByGoodsKind');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_Object_GoodsByGoodsKind_isOrder()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 2
                                  , inName:= 'Справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_GoodsByGoodsKind())||'> - сохранение данных.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_Object_GoodsByGoodsKind_isOrder');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_Object_GoodsByGoodsKind_isScaleCeh()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 3
                                  , inName:= 'Справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_GoodsByGoodsKind())||'> - сохранение данных.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_Object_GoodsByGoodsKind_isScaleCeh');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_GoodsByGoodsKind_OrderScaleCeh()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 3
                                  , inName:= 'Справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_GoodsByGoodsKind())||'> - изменение данных.'
                                  , inEnumName:= 'zc_Enum_Process_Update_GoodsByGoodsKind_OrderScaleCeh');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_Object_GoodsByGoodsKind_Sticker()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 4
                                  , inName:= 'Справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_GoodsByGoodsKind())||'> - изменение данных.'
                                  , inEnumName:= 'zc_Enum_Process_Update_Object_GoodsByGoodsKind_Sticker');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_Object_GoodsByGoodsKind_VMC()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 5
                                  , inName:= 'Справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_GoodsByGoodsKind())||'> - изменение данных.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_Object_GoodsByGoodsKind_VMC');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_Object_GoodsByGoodsKind_Norm() -- zc_Enum_Process_Update_Object_GoodsByGoodsKind_Sticker
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 6
                                  , inName:= 'Справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_GoodsByGoodsKind())||'> - изменение данных.'
                                  , inEnumName:= 'zc_Enum_Process_Update_Object_GoodsByGoodsKind_Norm');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_GoodsByGoodsKind_NewQuality() -- zc_Enum_Process_Update_Object_GoodsByGoodsKind_Sticker
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 7
                                  , inName:= 'Справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_GoodsByGoodsKind())||'> - изменение данных.Качественные.'
                                  , inEnumName:= 'zc_Enum_Process_Update_GoodsByGoodsKind_NewQuality');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_GoodsByGoodsKind_Top()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 8
                                  , inName:= 'Справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_GoodsByGoodsKind())||'> - изменение данных.Топ.'
                                  , inEnumName:= 'zc_Enum_Process_Update_GoodsByGoodsKind_Top');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_GoodsByGoodsKind_isNotPack() -- 
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 8
                                  , inName:= 'Справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_GoodsByGoodsKind())||'> - изменение данных.Не упаковывать.'
                                  , inEnumName:= 'zc_Enum_Process_Update_GoodsByGoodsKind_isNotPack');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_GoodsByGoodsKind_PackOrder() -- zc_Enum_Process_Update_Object_GoodsByGoodsKind_Sticker
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 9
                                  , inName:= 'Справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_GoodsByGoodsKind())||'> - изменение данных.'                    -- Нет огранич. на упак
                                  , inEnumName:= 'zc_Enum_Process_Update_GoodsByGoodsKind_PackOrder');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_GoodsByGoodsKind_PackLimit() -- zc_Enum_Process_Update_Object_GoodsByGoodsKind_Sticker
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 10
                                  , inName:= 'Справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_GoodsByGoodsKind())||'> - изменение данных.' 
                                  , inEnumName:= 'zc_Enum_Process_Update_GoodsByGoodsKind_PackLimit');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_GoodsByGoodsKind_Etiketka() -- zc_Enum_Process_Update_Object_GoodsByGoodsKind_Sticker
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 11
                                  , inName:= 'Справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_GoodsByGoodsKind())||'> - изменение данных.' 
                                  , inEnumName:= 'zc_Enum_Process_Update_GoodsByGoodsKind_Etiketka');

END $$;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.01.25         * zc_Enum_Process_Update_GoodsByGoodsKind_Etiketka
 22.01.24         * zc_Enum_Process_Update_GoodsByGoodsKind_PackOrder
 22.06.18         *
 18.02.18         *
 01.03.17         *
 09.12.16         *
 23.02.16         *
 25.03.15                                        *
*/
