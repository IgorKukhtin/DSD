-- �������� 
CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_Movement_OrderIncome() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_Movement_OrderIncome' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

-- ������ ���������
CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_MI_OrderIncome() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_MI_OrderIncome' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_SetErased_MI_OrderIncome() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_SetErased_MI_OrderIncome' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

DO $$
BEGIN


-- �������� <>
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_Movement_OrderIncome()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_OrderIncome())||'> - ���������� ������.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_Movement_OrderIncome');
   
-- ������ ��������� <>
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_MI_OrderIncome()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= '������ ��������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_OrderIncome())||'> - ���������� ������.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_MI_OrderIncome');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_SetErased_MI_OrderIncome()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 3
                                  , inName:= '������ ��������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_OrderIncome())||'> - �������� ������.'
                                  , inEnumName:= 'zc_Enum_Process_SetErased_MI_OrderIncome');                                 
                                  

 
END $$;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 13.07.16         *              

*/
