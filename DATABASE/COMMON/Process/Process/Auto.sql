CREATE OR REPLACE FUNCTION zc_Enum_Process_Auto_PartionDate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Auto_PartionDate' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Auto_PartionClose() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Auto_PartionClose' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;


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

 
END $$;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 05.07.15                                        *
*/
