-- Function: gpUpdate_Movement_Send_PersonalGroup()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Send_PersonalGroup (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Send_PersonalGroup(
    IN inId                      Integer   , -- ���� ������� <�������� �����������>
    IN inPersonalGroupId         Integer   , -- � �������
    IN inSession                 TVarChar    -- ������ ������������
)
RETURNS Void AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_Send_PersonalGroup());

     -- ��������� ����� � ���������� <������ ���������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PersonalGroup(), inId, inPersonalGroupId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 07.08.20         *
*/

-- ����
-- 