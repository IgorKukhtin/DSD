CREATE OR REPLACE FUNCTION zc_Enum_Process_LoadSaleFrom1C() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_LoadSaleFrom1C' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_LoadMoneyFrom1C() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_LoadMoneyFrom1C' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

DO $$
BEGIN

-- 
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_LoadSaleFrom1C()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= 'Загрузка данных из 1С - накладные.'
                                  , inEnumName:= 'zc_Enum_Process_LoadSaleFrom1C');

-- 
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_LoadMoneyFrom1C()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= 'Загрузка данных из 1С - касса.'
                                  , inEnumName:= 'zc_Enum_Process_LoadMoneyFrom1C');

END $$;

-- select *  from objectProtocol left join Object on Object.Id = UserId where objectProtocol.Objectid = zc_Enum_Process_LoadSaleFrom1C() order by 1 desc
-- select *  from objectProtocol left join Object on Object.Id = UserId where objectProtocol.Objectid = zc_Enum_Process_LoadMoneyFrom1C() order by 1 desc
