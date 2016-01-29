-- �������� <������ ����� �������� �������>
CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_Movement_SheetWorkTime() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_Movement_SheetWorkTime' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Get_Movement_SheetWorkTime() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Get_Movement_SheetWorkTime' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Select_Movement_SheetWorkTime() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Select_Movement_SheetWorkTime' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

-- ������ ��������� <������ ����� �������� �������>
CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_MI_SheetWorkTime() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_MI_SheetWorkTime' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Select_MI_SheetWorkTime() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Select_MI_SheetWorkTime' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_SetErased_MI_SheetWorkTime() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_SetErased_MI_SheetWorkTime' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

DO $$
BEGIN

-- �������� <���������>
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_Movement_SheetWorkTime()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_SheetWorkTime())||'> - ���������� ������.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_Movement_SheetWorkTime');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Get_Movement_SheetWorkTime()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 2
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_SheetWorkTime())||'> - ����� ������.'
                                  , inEnumName:= 'zc_Enum_Process_Get_Movement_SheetWorkTime');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Select_Movement_SheetWorkTime()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 3
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_SheetWorkTime())||'> - ��������� ������.'
                                  , inEnumName:= 'zc_Enum_Process_Select_Movement_SheetWorkTime');
                                  
-- ������ ��������� <���������>
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_MI_SheetWorkTime()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= '������ ��������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_SheetWorkTime())||'> - ���������� ������.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_MI_SheetWorkTime');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Select_MI_SheetWorkTime()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 2
                                  , inName:= '������ ��������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_SheetWorkTime())||'> - ��������� ������.'
                                  , inEnumName:= 'zc_Enum_Process_Select_MI_SheetWorkTime');                                 

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_SetErased_MI_SheetWorkTime()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 3
                                  , inName:= '������ ��������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_SheetWorkTime())||'> - �������� ������.'
                                  , inEnumName:= 'zc_Enum_Process_SetErased_MI_SheetWorkTime');                                 



 -- �������� <���������>
 -- ������� ���� - InsertUpdate_Movement_SheetWorkTime + Get_Movement_SheetWorkTime
 PERFORM gpInsertUpdate_Object_RoleProcess (ioId        := tmpData.RoleRightId
                                          , inRoleId    := tmpRole.RoleId
                                          , inProcessId := tmpProcess.ProcessId
                                          , inSession   := zfCalc_UserAdmin())
 -- select  tmpData.RoleRightId, tmpRole.RoleId, tmpProcess.ProcessId
 FROM (SELECT Id AS RoleId FROM Object WHERE DescId = zc_Object_Role() AND ObjectCode in (-1)) AS tmpRole
      JOIN (SELECT zc_Enum_Process_InsertUpdate_Movement_SheetWorkTime() AS ProcessId
           UNION ALL
            SELECT zc_Enum_Process_Get_Movement_SheetWorkTime() AS ProcessId
           UNION ALL
            SELECT zc_Enum_Process_InsertUpdate_MI_SheetWorkTime() AS ProcessId
           ) AS tmpProcess ON 1=1

      -- ������� ��� ������������ �����
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
 
  -- ������� ���� - Select_Movement_SheetWorkTime
 PERFORM gpInsertUpdate_Object_RoleProcess (ioId        := tmpData.RoleRightId
                                          , inRoleId    := tmpRole.RoleId
                                          , inProcessId := tmpProcess.ProcessId
                                          , inSession   := zfCalc_UserAdmin())
 -- select  tmpData.RoleRightId, tmpRole.RoleId, tmpProcess.ProcessId
 FROM (SELECT Id AS RoleId FROM Object WHERE DescId = zc_Object_Role() AND ObjectCode in (-1)) AS tmpRole
      JOIN (SELECT zc_Enum_Process_Select_Movement_SheetWorkTime() AS ProcessId
           UNION ALL
            SELECT zc_Enum_Process_Select_MI_SheetWorkTime() AS ProcessId
          ) AS tmpProcess ON 1=1

      -- ������� ��� ������������ �����
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
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 04.12.13         *              

*/
