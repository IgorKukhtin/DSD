-- Документ <Транспорт>
CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_Movement_Transport() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_Movement_Transport' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Get_Movement_Transport() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Get_Movement_Transport' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Select_Movement_Transport() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Select_Movement_Transport' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_Movement_Transport_Confirmed() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_Movement_Transport_Confirmed' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

-- Строки Документа <Транспорт>
CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_MI_TransportMaster() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_MI_TransportMaster' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_MI_TransportChild() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_MI_TransportChild' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Select_MI_Transport() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Select_MI_Transport' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Select_MI_TransportReport() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Select_MI_TransportReport' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

-- Status
CREATE OR REPLACE FUNCTION zc_Enum_Process_UnComplete_Transport() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_UnComplete_Transport' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Complete_Transport() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Complete_Transport' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_SetErased_Transport() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_SetErased_Transport' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_CompletePeriod_Transport() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_CompletePeriod_Transport' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

DO $$
BEGIN

-- Документ <Транспорт>
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_Movement_Transport()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= 'сохранение данных - документ <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_Transport())||'>.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_Movement_Transport');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Get_Movement_Transport()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 2
                                  , inName:= 'выбор данных - документ <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_Transport())||'>.'
                                  , inEnumName:= 'zc_Enum_Process_Get_Movement_Transport');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Select_Movement_Transport()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 3
                                  , inName:= 'получение данных - документ <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_Transport())||'>.'
                                  , inEnumName:= 'zc_Enum_Process_Select_Movement_Transport');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_Movement_Transport_Confirmed()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 4
                                  , inName:= 'сохранение данных - документ <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_Transport())||'>.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_Movement_Transport_Confirmed');
-- Строки Документа <Транспорт>
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_MI_TransportMaster()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= 'сохранение данных - строки документа <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_Transport())||'>.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_MI_TransportMaster');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_MI_TransportChild()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 2
                                  , inName:= 'сохранение данных - строки документа <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_Transport())||'>.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_MI_TransportChild');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Select_MI_Transport()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 3
                                  , inName:= 'получение данных - строки документа <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_Transport())||'>.'
                                  , inEnumName:= 'zc_Enum_Process_Select_MI_Transport');                                 
 
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Select_MI_TransportReport()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 4
                                  , inName:= 'получение данных - документ <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_Transport())||'(Итоги)>.'
                                  , inEnumName:= 'zc_Enum_Process_Select_MI_TransportReport');                               
                                                                   
-- Status_Transport
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_UnComplete_Transport()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= 'Распроведение - документ <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_Transport())||'>.'
                                  , inEnumName:= 'zc_Enum_Process_UnComplete_Transport');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Complete_Transport()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 2
                                  , inName:= 'Проведение - документ <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_Transport())||'>.'
                                  , inEnumName:= 'zc_Enum_Process_Complete_Transport');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_SetErased_Transport()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 3
                                  , inName:= 'Удаление - документ <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_Transport())||'>.'
                                  , inEnumName:= 'zc_Enum_Process_SetErased_Transport');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_CompletePeriod_Transport()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 4
                                  , inName:= 'Проведение за период - документы <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_Transport())||'>.'
                                  , inEnumName:= 'zc_Enum_Process_CompletePeriod_Transport');


 -- Документ <Транспорт>
 -- заливка прав - InsertUpdate_Movement_Transport + Get_Movement_Transport
 PERFORM gpInsertUpdate_Object_RoleProcess (ioId        := tmpData.RoleRightId
                                          , inRoleId    := tmpRole.RoleId
                                          , inProcessId := tmpProcess.ProcessId
                                          , inSession   := zfCalc_UserAdmin())
 -- select  tmpData.RoleRightId, tmpRole.RoleId, tmpProcess.ProcessId
 FROM (SELECT Id AS RoleId FROM Object WHERE DescId = zc_Object_Role() AND ObjectCode in (-1)) AS tmpRole
      JOIN (SELECT zc_Enum_Process_InsertUpdate_Movement_Transport() AS ProcessId
           UNION ALL
            SELECT zc_Enum_Process_Get_Movement_Transport() AS ProcessId
           UNION ALL
            SELECT zc_Enum_Process_InsertUpdate_MI_TransportMaster() AS ProcessId
           UNION ALL
            SELECT zc_Enum_Process_InsertUpdate_MI_TransportChild() AS ProcessId
           ) AS tmpProcess ON 1=1

      -- находим уже существующие права
      LEFT JOIN (SELECT ObjectLink_RoleRight_Role.ObjectId         AS RoleRightId
                      , ObjectLink_RoleRight_Role.ChildObjectId    AS RoleId
                      , ObjectLink_RoleRight_Process.ChildObjectId AS ProcessId
                 FROM ObjectLink AS ObjectLink_RoleRight_Role
                      JOIN ObjectLink AS ObjectLink_RoleRight_Process ON ObjectLink_RoleRight_Process.ObjectId = ObjectLink_RoleRight_Role.ObjectId
                                                                     AND ObjectLink_RoleRight_Process.DescId = zc_ObjectLink_RoleRight_Process()
                 WHERE ObjectLink_RoleRight_Role.DescId = zc_ObjectLink_RoleRight_Role()
                ) AS tmpData ON tmpData.RoleId    = tmpRole.RoleId
                            AND tmpData.ProcessId = tmpProcess.ProcessId
 WHERE tmpData.RoleId IS NULL
;
 
  -- заливка прав - Select_Movement_Transport
 PERFORM gpInsertUpdate_Object_RoleProcess (ioId        := tmpData.RoleRightId
                                          , inRoleId    := tmpRole.RoleId
                                          , inProcessId := tmpProcess.ProcessId
                                          , inSession   := zfCalc_UserAdmin())
 -- select  tmpData.RoleRightId, tmpRole.RoleId, tmpProcess.ProcessId
 FROM (SELECT Id AS RoleId FROM Object WHERE DescId = zc_Object_Role() AND ObjectCode in (-1)) AS tmpRole
      JOIN (SELECT zc_Enum_Process_Select_Movement_Transport() AS ProcessId
           UNION ALL
            SELECT zc_Enum_Process_Select_MI_Transport() AS ProcessId
           UNION ALL
            SELECT zc_Enum_Process_Select_MI_TransportReport() AS ProcessId
           ) AS tmpProcess ON 1=1

      -- находим уже существующие права
      LEFT JOIN (SELECT ObjectLink_RoleRight_Role.ObjectId         AS RoleRightId
                      , ObjectLink_RoleRight_Role.ChildObjectId    AS RoleId
                      , ObjectLink_RoleRight_Process.ChildObjectId AS ProcessId
                 FROM ObjectLink AS ObjectLink_RoleRight_Role
                      JOIN ObjectLink AS ObjectLink_RoleRight_Process ON ObjectLink_RoleRight_Process.ObjectId = ObjectLink_RoleRight_Role.ObjectId
                                                                     AND ObjectLink_RoleRight_Process.DescId = zc_ObjectLink_RoleRight_Process()
                 WHERE ObjectLink_RoleRight_Role.DescId = zc_ObjectLink_RoleRight_Role()
                ) AS tmpData ON tmpData.RoleId    = tmpRole.RoleId
                            AND tmpData.ProcessId = tmpProcess.ProcessId
 WHERE tmpData.RoleId IS NULL
;
 
 -- Status_Transport
 -- заливка прав - Transport_UnComplete +  Transport_Complete + Transport_Erased
 PERFORM gpInsertUpdate_Object_RoleProcess (ioId        := tmpData.RoleRightId
                                          , inRoleId    := tmpRole.RoleId
                                          , inProcessId := tmpProcess.ProcessId
                                          , inSession   := zfCalc_UserAdmin())
 -- select  tmpData.RoleRightId, tmpRole.RoleId, tmpProcess.ProcessId
 FROM (SELECT Id AS RoleId FROM Object WHERE DescId = zc_Object_Role() AND ObjectCode in (-1)) AS tmpRole
      JOIN (SELECT zc_Enum_Process_UnComplete_Transport() AS ProcessId
          UNION ALL
            SELECT zc_Enum_Process_SetErased_Transport() AS ProcessId
          UNION ALL
            SELECT zc_Enum_Process_Complete_Transport() AS ProcessId
          UNION ALL
            SELECT zc_Enum_Process_CompletePeriod_Transport() AS ProcessId
           ) AS tmpProcess ON 1=1

      -- находим уже существующие права
      LEFT JOIN (SELECT ObjectLink_RoleRight_Role.ObjectId         AS RoleRightId
                      , ObjectLink_RoleRight_Role.ChildObjectId    AS RoleId
                      , ObjectLink_RoleRight_Process.ChildObjectId AS ProcessId
                 FROM ObjectLink AS ObjectLink_RoleRight_Role
                      JOIN ObjectLink AS ObjectLink_RoleRight_Process ON ObjectLink_RoleRight_Process.ObjectId = ObjectLink_RoleRight_Role.ObjectId
                                                                     AND ObjectLink_RoleRight_Process.DescId = zc_ObjectLink_RoleRight_Process()
                 WHERE ObjectLink_RoleRight_Role.DescId = zc_ObjectLink_RoleRight_Role()
                ) AS tmpData ON tmpData.RoleId    = tmpRole.RoleId
                            AND tmpData.ProcessId = tmpProcess.ProcessId
 WHERE tmpData.RoleId IS NULL
;
 
 
END $$;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.10.13         *              

*/
