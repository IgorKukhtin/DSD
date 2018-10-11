-- Документ <>
CREATE OR REPLACE FUNCTION zc_Enum_Process_AccessKey_SendAll() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_AccessKey_SendAll' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_Enum_Process_Select_MIContainer_Movement() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Select_MIContainer_Movement' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;



DO $$
BEGIN

 -- НЕ ограничиваются Документы
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_AccessKey_SendAll()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 1001
                                   , inName:= 'Документ Перемещение (проведение без проверки)'
                                   , inEnumName:= 'zc_Enum_Process_AccessKey_SendAll');
                                   
 -- 
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Select_MIContainer_Movement()
                                   , inDescId:= zc_Object_Process()
                                   , inCode:= 1001
                                   , inName:= 'Просмотр <Проводки документа>'
                                   , inEnumName:= 'zc_Enum_Process_Select_MIContainer_Movement');
END $$;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 11.10.18         * zc_Enum_Process_Select_MIContainer_Movement
 01.11.17                                        *
*/

