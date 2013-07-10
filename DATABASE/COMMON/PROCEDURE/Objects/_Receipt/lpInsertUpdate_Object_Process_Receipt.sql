-- создаются функции
CREATE OR REPLACE FUNCTION zc_Enum_Process_Select_Object_Receipt() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Select_Object_Receipt' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Get_Object_Receipt() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Get_Object_Receipt' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_Object_Receipt() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_Object_Receipt' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;

-- сохраняются элементы справочника (zc_Object_Process)
DO $$
BEGIN
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Select_Object_Receipt(), inDescId:= zc_Object_Process(), inCode:= lfGet_ObjectCode_byEnum ('zc_Enum_Process_Select_Object_Receipt'), inName:= 'Проверка получения данных', inEnumName:= 'zc_Enum_Process_Select_Object_Receipt');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Get_Object_Receipt(), inDescId:= zc_Object_Process(), inCode:= lfGet_ObjectCode_byEnum ('zc_Enum_Process_Get_Object_Receipt'), inName:= 'Проверка выборки данных', inEnumName:= 'zc_Enum_Process_Get_Object_Receipt');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_Object_Receipt(), inDescId:= zc_Object_Process(), inCode:= lfGet_ObjectCode_byEnum ('zc_Enum_Process_InsertUpdate_Object_Receipt'), inName:= 'Проверка сохранения данных', inEnumName:= 'zc_Enum_Process_InsertUpdate_Object_Receipt');
END $$;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.07.13          *                             

*/