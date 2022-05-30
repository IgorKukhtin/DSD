CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_Object_CommentInfoMoney_UserAll() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Update_Object_CommentInfoMoney_UserAll' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql;

DO $$
BEGIN

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_Object_CommentInfoMoney_UserAll()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= '���������� <'||(SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_CommentInfoMoney())||'> - ��������� ������.'
                                  , inEnumName:= 'zc_Enum_Process_Update_Object_CommentInfoMoney_UserAll');
       
END $$;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 30.05.21         *
*/