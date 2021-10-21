CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_Object_Juridical() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_Object_Juridical' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_Object_Juridical_Params() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Update_Object_Juridical_Params' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_Object_Juridical_PriceList() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Update_Object_Juridical_PriceList' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_Object_Juridical_GLN() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Update_Object_Juridical_GLN' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_Object_Juridical_PrintKindItem() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Update_Object_Juridical_PrintKindItem' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_Object_Juridical_isOrderMin() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Update_Object_Juridical_isOrderMin' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_Object_Juridical_isBranchAll() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Update_Object_Juridical_isBranchAll' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_Object_isErased_Juridical() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Update_Object_isErased_Juridical' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_Object_Juridical_VatPrice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Update_Object_Juridical_VatPrice' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_Object_Juridical_SummOrderMin() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Update_Object_Juridical_SummOrderMin' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;
--

CREATE OR REPLACE FUNCTION zc_Enum_Process_Select_Object_Juridical_Basis() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Select_Object_Juridical_Basis' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;

DO $$
BEGIN

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_Object_Juridical()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= 'Справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_Juridical())||'> - сохранение данных.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_Object_Juridical');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_Object_Juridical_Params()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 2
                                  , inName:= 'Справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_Juridical())||'> - сохранение данных.'
                                  , inEnumName:= 'zc_Enum_Process_Update_Object_Juridical_Params');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_Object_Juridical_PriceList()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 2
                                  , inName:= 'Справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_Juridical())||'> - установка ПРАЙСА.'
                                  , inEnumName:= 'zc_Enum_Process_Update_Object_Juridical_PriceList');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_Object_Juridical_GLN()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 3
                                  , inName:= 'Справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_Juridical())||'> - сохранение данных.'
                                  , inEnumName:= 'zc_Enum_Process_Update_Object_Juridical_GLN');
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_Object_Juridical_PrintKindItem()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 4
                                  , inName:= 'Справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_Juridical())||'> - сохранение данных.'
                                  , inEnumName:= 'zc_Enum_Process_Update_Object_Juridical_PrintKindItem');
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Select_Object_Juridical_Basis()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 3
                                  , inName:= 'получение данных - справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_Juridical())||'>.'
                                  , inEnumName:= 'zc_Enum_Process_Select_Object_Juridical_Basis');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_Object_Juridical_isOrderMin()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 6
                                  , inName:= 'Справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_Juridical())||'> - изменение данных.'
                                  , inEnumName:= 'zc_Enum_Process_Update_Object_Juridical_isOrderMin');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_Object_Juridical_isBranchAll()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 7
                                  , inName:= 'Справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_Juridical())||'> - изменение данных.'
                                  , inEnumName:= 'zc_Enum_Process_Update_Object_Juridical_isBranchAll');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_Object_isErased_Juridical()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 8
                                  , inName:= 'Справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_Juridical())||'> - удаление/восстановление.'
                                  , inEnumName:= 'zc_Enum_Process_Update_Object_isErased_Juridical');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Select_Object_Juridical_Basis()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 9
                                  , inName:= 'Справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_Juridical())||'> - изменение данных.'
                                  , inEnumName:= 'zc_Enum_Process_Select_Object_Juridical_Basis');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_Object_Juridical_SummOrderMin()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 10
                                  , inName:= 'Справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_Juridical())||'> - сохранение данных.'
                                  , inEnumName:= 'zc_Enum_Process_Update_Object_Juridical_SummOrderMin');


END $$;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.04.20         * zc_Enum_Process_Update_Object_isErased_Juridical
 25.10.19         * zc_Enum_Process_Update_Object_Juridical_isBranchAll
 24.10.19         * zc_Enum_Process_Update_Object_Juridical_isOrderMin
 21.05.15         * add PrintKindItem
 18.03.15         * add zc_Enum_Process_Update_Object_Juridical_GLN
 27.10.14                                        *
*/
