-- �������� <��������� ������� � ������������>
CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_Movement_CompetitorMarkups() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_Movement_CompetitorMarkups' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

-- ������ ��������� <��������� ������� � ������������>
CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_MI_CompetitorMarkups() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_InsertUpdate_MI_CompetitorMarkups' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

DO $$
BEGIN

-- �������� <��������� ������� � ������������>
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_Movement_CompetitorMarkups()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= '�������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_CompetitorMarkups())||'> - ���������� ������.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_Movement_CompetitorMarkups');                                  

 -- ������ ��������� <��������� ������� � ������������>
 PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_InsertUpdate_MI_CompetitorMarkups()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= '������ ��������� <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_CompetitorMarkups())||'> - ���������� ������.'
                                  , inEnumName:= 'zc_Enum_Process_InsertUpdate_MI_CompetitorMarkups');

END $$;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ O.�.
 05.05.22                                                       *              

*/
