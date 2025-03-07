CREATE OR REPLACE FUNCTION zc_Enum_Process_Auto_PrimeCost()    RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Auto_PrimeCost'    AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Auto_ReComplete()   RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Auto_ReComplete'   AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Enum_Process_Auto_Pack()         RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Auto_Pack'         AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Auto_Kopchenie()    RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Auto_Kopchenie'    AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Auto_Defroster()    RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Auto_Defroster'    AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Enum_Process_Auto_PartionDate()  RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Auto_PartionDate'  AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Auto_PartionClose() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Auto_PartionClose' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Enum_Process_Auto_Send()         RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Auto_Send'         AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Auto_ReturnIn()     RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Auto_ReturnIn'     AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Auto_Medoc()        RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Auto_Medoc'        AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Enum_Process_Auto_Peresort()     RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Auto_Peresort'     AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

DO $$
BEGIN

 -- для 
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Auto_PartionDate()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 1001
                                   , inName:= 'Расход партий П/Ф (ГП) по Рецептуре'
                                   , inEnumName:= 'zc_Enum_Process_Auto_PartionDate');

 -- для 
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Auto_PartionClose()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 1002
                                   , inName:= 'Расход партий П/Ф (ГП) при закрытии'
                                   , inEnumName:= 'zc_Enum_Process_Auto_PartionClose');
 -- для 
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Auto_PrimeCost()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 1003
                                   , inName:= 'Расчет с/с'
                                   , inEnumName:= 'zc_Enum_Process_Auto_PrimeCost');
 -- для 
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Auto_Defroster()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 1004
                                   , inName:= 'Приход/расход схема Дефростер'
                                   , inEnumName:= 'zc_Enum_Process_Auto_Defroster');

 -- для 
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Auto_Pack()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 1005
                                   , inName:= 'Приход/расход цех Упаковки'
                                   , inEnumName:= 'zc_Enum_Process_Auto_Pack');
 -- для 
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Auto_Kopchenie()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 1006
                                   , inName:= 'Приход/расход цех Копчения'
                                   , inEnumName:= 'zc_Enum_Process_Auto_Kopchenie');

 -- для 
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Auto_Send()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 1007
                                   , inName:= 'Приход/расход схема Нарезка'
                                   , inEnumName:= 'zc_Enum_Process_Auto_Send');

 -- для 
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Auto_ReturnIn()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 1008
                                   , inName:= 'Возврат - привязка к продаже'
                                   , inEnumName:= 'zc_Enum_Process_Auto_ReturnIn');

 -- для 
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Auto_ReComplete()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 1009
                                   , inName:= 'Перепроведение - в закрытом периоде'
                                   , inEnumName:= 'zc_Enum_Process_Auto_ReComplete');

 -- для 
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Auto_Medoc()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 1010
                                   , inName:= 'Medoc - Авто загрузка'
                                   , inEnumName:= 'zc_Enum_Process_Auto_Medoc');
 
 -- для 
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Auto_Peresort()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 1011
                                   , inName:= 'Автоматический пересорт'
                                   , inEnumName:= 'zc_Enum_Process_Auto_Peresort');

END $$;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 05.07.15                                        *
*/
