-- ��������
CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_Movement_IncomeHouseholdInventory() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_Movement_IncomeHouseholdInventory' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
-- ������
CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_MI_IncomeHouseholdInventory() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_MI_IncomeHouseholdInventory' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
-- Status
CREATE OR REPLACE FUNCTION zc_Enum_Process_UnComplete_IncomeHouseholdInventory() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_UnComplete_IncomeHouseholdInventory' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Complete_IncomeHouseholdInventory() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Complete_IncomeHouseholdInventory' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_SetErased_IncomeHouseholdInventory() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_SetErased_IncomeHouseholdInventory' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

DO $$


BEGIN

-- ��������
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_Movement_IncomeHouseholdInventory()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_IncomeHouseholdInventory())||'> - ���������� ������.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_Movement_IncomeHouseholdInventory');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_MI_IncomeHouseholdInventory()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= '������� ��������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_IncomeHouseholdInventory())||'> - ���������� ������.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_MI_IncomeHouseholdInventory');

                                  
-- Status_IncomeHouseholdInventory
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_UnComplete_IncomeHouseholdInventory()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_IncomeHouseholdInventory())||'> - �������������.'
                                  , inEnumName:= 'zc_Enum_Process_UnComplete_IncomeHouseholdInventory');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Complete_IncomeHouseholdInventory()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 2
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_IncomeHouseholdInventory())||'> - ����������.'
                                  , inEnumName:= 'zc_Enum_Process_Complete_IncomeHouseholdInventory');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_SetErased_IncomeHouseholdInventory()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 3
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_IncomeHouseholdInventory())||'> - ��������.'
                                  , inEnumName:= 'zc_Enum_Process_SetErased_IncomeHouseholdInventory');

END $$;


-------------------------------------------------------------------------------
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 08.07.20                                                       *
*/
