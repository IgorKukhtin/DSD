-- �������� <>
CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_Movement_HospitalDoc_1C() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_Movement_HospitalDoc_1C' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

-- Status
CREATE OR REPLACE FUNCTION zc_Enum_Process_UnComplete_HospitalDoc_1C() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_UnComplete_HospitalDoc_1C' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Complete_HospitalDoc_1C() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Complete_HospitalDoc_1C' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_SetErased_HospitalDoc_1C() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_SetErased_HospitalDoc_1C' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

DO $$


BEGIN

-- ��������
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_Movement_HospitalDoc_1C()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_HospitalDoc_1C())||'> - ���������� ������.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_Movement_HospitalDoc_1C');

-- Status_HospitalDoc_1C
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_UnComplete_HospitalDoc_1C()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 2
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_HospitalDoc_1C())||'> - �������������.'
                                  , inEnumName:= 'zc_Enum_Process_UnComplete_HospitalDoc_1C');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Complete_HospitalDoc_1C()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 3
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_HospitalDoc_1C())||'> - ����������.'
                                  , inEnumName:= 'zc_Enum_Process_Complete_HospitalDoc_1C');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_SetErased_HospitalDoc_1C()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 4
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_HospitalDoc_1C())||'> - ��������.'
                                  , inEnumName:= 'zc_Enum_Process_SetErased_HospitalDoc_1C');

END $$;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 23.07.25         *
*/
