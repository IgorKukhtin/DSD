-- Function: gpUpdate_Movement_ReportUnLiquid_Comment()

DROP FUNCTION IF EXISTS gpUpdate_Movement_ReportUnLiquid_Comment (Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_ReportUnLiquid_Comment (
    IN inId                  Integer   , -- ���� ������� <�������� �����������>
    IN inComment             TVarChar  , -- ����������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Void AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ReportUnLiquid());
     vbUserId := inSession;

     -- ����������
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), inId, inComment);

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 19.11.18         *
*/

-- ����
--