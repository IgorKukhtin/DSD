CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_Object_Unit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_Object_Unit' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Get_Object_Unit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Get_Object_Unit' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Select_Object_Unit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Select_Object_Unit' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_Object_Unit_HistoryCost() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Update_Object_Unit_HistoryCost' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_Object_Unit_Personal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Update_Object_Unit_Personal' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;


DO $$
BEGIN

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_Object_Unit()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= 'сохранение данных - справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_Unit())||'>.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_Object_Unit');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Get_Object_Unit()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 2
                                  , inName:= 'выбор данных - справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_Unit())||'>.'
                                  , inEnumName:= 'zc_Enum_Process_Get_Object_Unit');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Select_Object_Unit()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 3
                                  , inName:= 'получение данных - справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_Unit())||'>.'
                                  , inEnumName:= 'zc_Enum_Process_Select_Object_Unit');
                            
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_Object_Unit_HistoryCost()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 4
                                  , inName:= 'сохранение данных - справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_Unit())||'>.'
                                  , inEnumName:= 'zc_Enum_Process_Update_Object_Unit_HistoryCost');
      
                                  
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_Object_Unit_Personal()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 4
                                  , inName:= 'сохранение данных - справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_Unit())||'>.'
                                  , inEnumName:= 'zc_Enum_Process_Update_Object_Unit_Personal');

 -- заливка прав - InsertUpdate
 PERFORM gpInsertUpdate_Object_RoleProcess (ioId        := tmpData.RoleRightId
                                          , inRoleId    := tmpRole.RoleId
                                          , inProcessId := tmpProcess.ProcessId
                                          , inSession   := zfCalc_UserAdmin())
 -- select  tmpData.RoleRightId, tmpRole.RoleId, tmpProcess.ProcessId
 FROM (SELECT Id AS RoleId FROM Object WHERE DescId = zc_Object_Role() AND ObjectCode in (-1)) AS tmpRole
      JOIN (SELECT zc_Enum_Process_InsertUpdate_Object_Unit() AS ProcessId) AS tmpProcess ON 1=1

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
 ;

 -- заливка прав - Get
 PERFORM gpInsertUpdate_Object_RoleProcess (ioId        := tmpData.RoleRightId
                                          , inRoleId    := tmpRole.RoleId
                                          , inProcessId := tmpProcess.ProcessId
                                          , inSession   := zfCalc_UserAdmin())
 -- select  tmpData.RoleRightId, tmpRole.RoleId, tmpProcess.ProcessId
 FROM (SELECT Id AS RoleId FROM Object WHERE DescId = zc_Object_Role() AND ObjectCode in (-1)) AS tmpRole
      JOIN (SELECT zc_Enum_Process_Get_Object_Unit() AS ProcessId) AS tmpProcess ON 1=1

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
 ;

 -- заливка прав - Select
 PERFORM gpInsertUpdate_Object_RoleProcess (ioId        := tmpData.RoleRightId
                                          , inRoleId    := tmpRole.RoleId
                                          , inProcessId := tmpProcess.ProcessId
                                          , inSession   := zfCalc_UserAdmin())
 -- select  tmpData.RoleRightId, tmpRole.RoleId, tmpProcess.ProcessId
 FROM (SELECT Id AS RoleId FROM Object WHERE DescId = zc_Object_Role() AND ObjectCode in (-1)) AS tmpRole
      JOIN (SELECT zc_Enum_Process_Select_Object_Unit()  AS ProcessId) AS tmpProcess ON 1=1

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
 ;

END $$;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.04.19         * zc_Enum_Process_InsertUpdate_Object_Unit_HistoryCost
 25.10.13                                        * add PERFORM
 07.10.13                                        *
*/
