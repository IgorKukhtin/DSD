-- Function: gpUpdate_Movement_Send_isRePack()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Send_isRePack (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Send_isRePack(
    IN inId                      Integer   , -- ���� ������� <�������� �����������>
    IN inisRePack                Boolean   , -- 
   OUT outisRePack               Boolean   , -- 
    IN inSession                 TVarChar    -- ������ ������������
)
RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_Send_isRePack());

     outisRePack := NOT inisRePack;
     -- ��������� ����� � ���������� <������ ���������>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isRePack(), inId, outisRePack);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 25.09.24         *
*/

-- ����
-- 