CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_Object_Member() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_Object_Member' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Get_Object_Member() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Get_Object_Member' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Select_Object_Member() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Select_Object_Member' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_Object_Member_Transport() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Update_Object_Member_Transport' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION zc_Enum_Process_Get_Object_Member_ScalePSW() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Get_Object_Member_ScalePSW' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_Object_Member_ScalePSW() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Update_Object_Member_ScalePSW' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_Object_Member_GLN() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Update_Object_Member_GLN' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;

DO $$
BEGIN

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_Object_Member()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= 'Справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_Member())||'> - сохранение данных.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_Object_Member');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Get_Object_Member()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 2
                                  , inName:= 'Справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_Member())||'> - выбор данных.'
                                  , inEnumName:= 'zc_Enum_Process_Get_Object_Member');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Select_Object_Member()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 3
                                  , inName:= 'Справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_Member())||'> - получение данных.'
                                  , inEnumName:= 'zc_Enum_Process_Select_Object_Member');
                                  
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_Object_Member_Transport()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 4
                                  , inName:= 'Справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_Member())||'> - изменение данных.'
                                  , inEnumName:= 'zc_Enum_Process_Update_Object_Member_Transport');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Get_Object_Member_ScalePSW()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 5
                                  , inName:= 'Справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_Member())||'> - выбор данных.'
                                  , inEnumName:= 'zc_Enum_Process_Get_Object_Member_ScalePSW');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_Object_Member_ScalePSW()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 6
                                  , inName:= 'Справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_Member())||'> - сохранение данных.'
                                  , inEnumName:= 'zc_Enum_Process_Update_Object_Member_ScalePSW');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_Object_Member_GLN()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 7
                                  , inName:= 'Справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_Member())||'> - сохранение данных.'
                                  , inEnumName:= 'zc_Enum_Process_Update_Object_Member_GLN');

 -- заливка прав - InsertUpdate
 PERFORM gpInsertUpdate_Object_RoleProcess (ioId        := tmpData.RoleRightId
                                          , inRoleId    := tmpRole.RoleId
                                          , inProcessId := tmpProcess.ProcessId
                                          , inSession   := zfCalc_UserAdmin())
 -- select  tmpData.RoleRightId, tmpRole.RoleId, tmpProcess.ProcessId
 FROM (SELECT Id AS RoleId FROM Object WHERE DescId = zc_Object_Role() AND ObjectCode in (-1)) AS tmpRole
      JOIN (SELECT zc_Enum_Process_InsertUpdate_Object_Member() AS ProcessId) AS tmpProcess ON 1=1

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
      JOIN (SELECT zc_Enum_Process_Get_Object_Member() AS ProcessId) AS tmpProcess ON 1=1

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
      JOIN (SELECT zc_Enum_Process_Select_Object_Member()  AS ProcessId) AS tmpProcess ON 1=1

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
 04.12.13         *
*/
