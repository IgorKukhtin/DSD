-- ��������
CREATE OR REPLACE FUNCTION zc_Enum_Process_IU_Movement_WriteOffHouseholdInventory() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_IU_Movement_WriteOffHouseholdInventory' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
-- ������
CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_MI_WriteOffHouseholdInventory() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_MI_WriteOffHouseholdInventory' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
-- Status
CREATE OR REPLACE FUNCTION zc_Enum_Process_UnComplete_WriteOffHouseholdInventory() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_UnComplete_WriteOffHouseholdInventory' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Complete_WriteOffHouseholdInventory() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Complete_WriteOffHouseholdInventory' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_SetErased_WriteOffHouseholdInventory() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_SetErased_WriteOffHouseholdInventory' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

DO $$


BEGIN

-- ��������
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_IU_Movement_WriteOffHouseholdInventory()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_WriteOffHouseholdInventory())||'> - ���������� ������.'
                                  , inEnumName:= 'zc_Enum_Process_IU_Movement_WriteOffHouseholdInventory');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_MI_WriteOffHouseholdInventory()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= '������� ��������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_WriteOffHouseholdInventory())||'> - ���������� ������.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_MI_WriteOffHouseholdInventory');

                                  
-- Status_WriteOffHouseholdInventory
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_UnComplete_WriteOffHouseholdInventory()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_WriteOffHouseholdInventory())||'> - �������������.'
                                  , inEnumName:= 'zc_Enum_Process_UnComplete_WriteOffHouseholdInventory');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Complete_WriteOffHouseholdInventory()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 2
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_WriteOffHouseholdInventory())||'> - ����������.'
                                  , inEnumName:= 'zc_Enum_Process_Complete_WriteOffHouseholdInventory');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_SetErased_WriteOffHouseholdInventory()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 3
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_WriteOffHouseholdInventory())||'> - ��������.'
                                  , inEnumName:= 'zc_Enum_Process_SetErased_WriteOffHouseholdInventory');

END $$;


-------------------------------------------------------------------------------
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 08.07.20                                                       *
*/
