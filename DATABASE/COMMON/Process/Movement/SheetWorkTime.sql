-- �������� <������ ����� �������� �������>
CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_Movement_SheetWorkTime() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_Movement_SheetWorkTime' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

-- ������ ��������� <������ ����� �������� �������>
CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_MI_SheetWorkTime() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_MI_SheetWorkTime' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_SetErased_MI_SheetWorkTime() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_SetErased_MI_SheetWorkTime' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

DO $$
BEGIN

-- �������� <���������>
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_Movement_SheetWorkTime()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_SheetWorkTime())||'> - ���������� ������.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_Movement_SheetWorkTime');
   
-- ������ ��������� <���������>
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_MI_SheetWorkTime()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= '������ ��������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_SheetWorkTime())||'> - ���������� ������.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_MI_SheetWorkTime');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_SetErased_MI_SheetWorkTime()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 3
                                  , inName:= '������ ��������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_SheetWorkTime())||'> - �������� ������.'
                                  , inEnumName:= 'zc_Enum_Process_SetErased_MI_SheetWorkTime');                                 
                                  

 
END $$;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 04.12.13         *              

*/
