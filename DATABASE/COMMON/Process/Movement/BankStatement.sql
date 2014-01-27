-- Документ <Расход денег с подотчета на подотчет>
CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_Movement_BankStatement() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_Movement_BankStatement' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_Movement_BankStatementItemLoad() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_Movement_BankStatementItemLoad' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_Movement_BankStatementItem() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Update_Movement_BankStatementItem' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Get_Movement_BankStatement() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Get_Movement_BankStatement' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Select_Movement_BankStatement() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Select_Movement_BankStatement' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
-- Status
CREATE OR REPLACE FUNCTION zc_Enum_Process_UnComplete_BankStatement() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_UnComplete_BankStatement' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Complete_BankStatement() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Complete_BankStatement' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_SetErased_BankStatement() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_SetErased_BankStatement' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_CompletePeriod_BankStatement() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_CompletePeriod_BankStatement' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

DO $$
BEGIN

-- Документ <Транспорт>
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_Movement_BankStatement()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= 'Документ <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_BankStatement())||'> - сохранение данных.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_Movement_BankStatement');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_Movement_BankStatementItemLoad()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= 'Документ <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_BankStatement())||'> - сохранение данных, на основании вписки из банка.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_Movement_BankStatementItemLoad');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_Movement_BankStatementItem()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= 'Документ <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_BankStatement())||'> - изменение данных.'
                                  , inEnumName:= 'zc_Enum_Process_Update_Movement_BankStatementItem');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Get_Movement_BankStatement()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 2
                                  , inName:= 'Документ <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_BankStatement())||'> - выбор данных.'
                                  , inEnumName:= 'zc_Enum_Process_Get_Movement_BankStatement');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Select_Movement_BankStatement()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 3
                                  , inName:= 'Документ <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_BankStatement())||'> - получение данных.'
                                  , inEnumName:= 'zc_Enum_Process_Select_Movement_BankStatement');
                                  
-- Status_BankStatement
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_UnComplete_BankStatement()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= 'Документ <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_BankStatement())||'> - Распроведение.'
                                  , inEnumName:= 'zc_Enum_Process_UnComplete_BankStatement');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Complete_BankStatement()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 2
                                  , inName:= 'Документ <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_BankStatement())||'> - Проведение.'
                                  , inEnumName:= 'zc_Enum_Process_Complete_BankStatement');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_SetErased_BankStatement()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 3
                                  , inName:= 'Документ <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_BankStatement())||'> - Удаление.'
                                  , inEnumName:= 'zc_Enum_Process_SetErased_BankStatement');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_CompletePeriod_BankStatement()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 4
                                  , inName:= 'Документ <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_BankStatement())||'> - Проведение за период.'
                                  , inEnumName:= 'zc_Enum_Process_CompletePeriod_BankStatement');


 -- Документ <Транспорт>
 -- заливка прав - InsertUpdate_Movement_BankStatement + Get_Movement_BankStatement
 PERFORM gpInsertUpdate_Object_RoleProcess (ioId        := tmpData.RoleRightId
                                          , inRoleId    := tmpRole.RoleId
                                          , inProcessId := tmpProcess.ProcessId
                                          , inSession   := zfCalc_UserAdmin())
 -- select  tmpData.RoleRightId, tmpRole.RoleId, tmpProcess.ProcessId
 FROM (SELECT Id AS RoleId FROM Object WHERE DescId = zc_Object_Role() AND ObjectCode in (-1)) AS tmpRole
      JOIN (SELECT zc_Enum_Process_InsertUpdate_Movement_BankStatement() AS ProcessId
           UNION ALL
            SELECT zc_Enum_Process_Get_Movement_BankStatement() AS ProcessId
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
 
  -- заливка прав - Select_Movement_BankStatement
 PERFORM gpInsertUpdate_Object_RoleProcess (ioId        := tmpData.RoleRightId
                                          , inRoleId    := tmpRole.RoleId
                                          , inProcessId := tmpProcess.ProcessId
                                          , inSession   := zfCalc_UserAdmin())
 -- select  tmpData.RoleRightId, tmpRole.RoleId, tmpProcess.ProcessId
 FROM (SELECT Id AS RoleId FROM Object WHERE DescId = zc_Object_Role() AND ObjectCode in (-1)) AS tmpRole
      JOIN (SELECT zc_Enum_Process_Select_Movement_BankStatement() AS ProcessId
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
 
 -- Status_BankStatement
 -- заливка прав - BankStatement_UnComplete +  BankStatement_Complete + BankStatement_Erased
 PERFORM gpInsertUpdate_Object_RoleProcess (ioId        := tmpData.RoleRightId
                                          , inRoleId    := tmpRole.RoleId
                                          , inProcessId := tmpProcess.ProcessId
                                          , inSession   := zfCalc_UserAdmin())
 -- select  tmpData.RoleRightId, tmpRole.RoleId, tmpProcess.ProcessId
 FROM (SELECT Id AS RoleId FROM Object WHERE DescId = zc_Object_Role() AND ObjectCode in (-1)) AS tmpRole
      JOIN (SELECT zc_Enum_Process_UnComplete_BankStatement() AS ProcessId
          UNION ALL
            SELECT zc_Enum_Process_SetErased_BankStatement() AS ProcessId
          UNION ALL
            SELECT zc_Enum_Process_Complete_BankStatement() AS ProcessId
          UNION ALL
            SELECT zc_Enum_Process_CompletePeriod_BankStatement() AS ProcessId
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
 25.01.14                                        *
*/
