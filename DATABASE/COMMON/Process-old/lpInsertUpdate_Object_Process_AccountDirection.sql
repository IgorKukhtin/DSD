﻿-- создаются функции
CREATE OR REPLACE FUNCTION zc_Enum_Process_Select_Object_AccountDirection() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Select_Object_AccountDirection' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Get_Object_AccountDirection() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Get_Object_AccountDirection' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_Object_AccountDirection() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_Object_AccountDirection' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;

-- сохраняются элементы справочника (zc_Object_Process)
DO $$
BEGIN
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Select_Object_AccountDirection(), inDescId:= zc_Object_Process(), inCode:= lfGet_ObjectCode_byEnum ('zc_Enum_Process_Select_Object_AccountDirection'), inName:= 'Проверка получения данных', inEnumName:= 'zc_Enum_Process_Select_Object_AccountDirection');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Get_Object_AccountDirection(), inDescId:= zc_Object_Process(), inCode:= lfGet_ObjectCode_byEnum ('zc_Enum_Process_Get_Object_AccountDirection'), inName:= 'Проверка выборки данных', inEnumName:= 'zc_Enum_Process_Get_Object_AccountDirection');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_Object_AccountDirection(), inDescId:= zc_Object_Process(), inCode:= lfGet_ObjectCode_byEnum ('zc_Enum_Process_InsertUpdate_Object_AccountDirection'), inName:= 'Проверка сохранения данных', inEnumName:= 'zc_Enum_Process_InsertUpdate_Object_AccountDirection');
END $$;

 
/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.06.13          *
 21.06.13          *                             *
*/