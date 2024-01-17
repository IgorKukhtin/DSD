CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_Object_Goods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_Object_Goods' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_Object_isErased_Goods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Update_Object_isErased_Goods' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_Object_Goods_UKTZED() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Update_Object_Goods_UKTZED' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_Object_Goods_Name_BUH() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Update_Object_Goods_Name_BUH' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_Object_Goods_GoodsGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Update_Object_Goods_GoodsGroup' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_Object_Goods_Scale() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Update_Object_Goods_Scale' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;



-- CREATE OR REPLACE FUNCTION zc_Enum_Process_Get_Object_Goods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Get_Object_Goods' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;
-- CREATE OR REPLACE FUNCTION zc_Enum_Process_Select_Object_Goods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Select_Object_Goods' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;

DO $$
BEGIN

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_Object_Goods()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= 'Справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_Goods())||'> - сохранение данных.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_Object_Goods');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_Object_isErased_Goods()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 2
                                  , inName:= 'Справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_Goods())||'> - удаление/восстановление.'
                                  , inEnumName:= 'zc_Enum_Process_Update_Object_isErased_Goods');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_Object_Goods_UKTZED()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 3
                                  , inName:= 'Справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_Goods())||'> - изменение данных.'
                                  , inEnumName:= 'zc_Enum_Process_Update_Object_Goods_UKTZED');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_Object_Goods_Name_BUH()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 4
                                  , inName:= 'Справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_Goods())||'> - изменение данных.'
                                  , inEnumName:= 'zc_Enum_Process_Update_Object_Goods_Name_BUH');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_Object_Goods_GoodsGroup()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 5
                                  , inName:= 'Справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_Goods())||'> - изменение данных.'
                                  , inEnumName:= 'zc_Enum_Process_Update_Object_Goods_GoodsGroup');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_Object_Goods_Scale()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 6
                                  , inName:= 'Справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_Goods())||'> - изменение данных.'
                                  , inEnumName:= 'zc_Enum_Process_Update_Object_Goods_Scale');
/*             
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Get_Object_Goods()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 2
                                  , inName:= 'Справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_Goods())||'> - выбор данных.'
                                  , inEnumName:= 'zc_Enum_Process_Get_Object_Goods');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Select_Object_Goods()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 3
                                  , inName:= 'Справочник <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_Goods())||'> - получение данных.'
                                  , inEnumName:= 'zc_Enum_Process_Select_Object_Goods');
                                  
 -- заливка прав - InsertUpdate
 PERFORM gpInsertUpdate_Object_RoleProcess (ioId        := tmpData.RoleRightId
                                          , inRoleId    := tmpRole.RoleId
                                          , inProcessId := tmpProcess.ProcessId
                                          , inSession   := zfCalc_UserAdmin())
 -- select  tmpData.RoleRightId, tmpRole.RoleId, tmpProcess.ProcessId
 FROM (SELECT Id AS RoleId FROM Object WHERE DescId = zc_Object_Role() AND ObjectCode in (-1)) AS tmpRole
      JOIN (SELECT zc_Enum_Process_InsertUpdate_Object_Goods() AS ProcessId) AS tmpProcess ON 1=1

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
      JOIN (SELECT zc_Enum_Process_Get_Object_Goods() AS ProcessId) AS tmpProcess ON 1=1

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
      JOIN (SELECT zc_Enum_Process_Select_Object_Goods()  AS ProcessId) AS tmpProcess ON 1=1

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
*/
END $$;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.07.20         * zc_Enum_Process_Update_Object_Goods_UKTZED
 05.12.13         *
*/
