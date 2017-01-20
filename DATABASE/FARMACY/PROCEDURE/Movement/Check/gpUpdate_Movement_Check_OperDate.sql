-- Function: gpUpdate_Movement_Check_OperDate()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Check_OperDate (Integer, TDateTime, TVarChar, TVarChar);
  
CREATE OR REPLACE FUNCTION gpUpdate_Movement_Check_OperDate(
    IN inId                Integer   , -- ���� ������� <�������� ���>
    IN inOperDate          TDateTime , -- ����/����� ���������
    IN inInvNumber         TVarChar  , -- ����� ����
    IN inSession           TVarChar    -- ������ ������������
)
RETURNS void
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId := lpGetUserBySession (inSession);
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Movement_Check_OperDate());

    IF inOperDate is null
    THEN
        RAISE EXCEPTION '���� �� ����������.';
    END IF;
    
    IF COALESCE(inId,0) = 0
    THEN
        RAISE EXCEPTION '�������� �� �������.';
    END IF;

    -- ��������� <��������>
    inId := lpInsertUpdate_Movement (inId, zc_Movement_Check(), inInvNumber::TVarChar, inOperDate, NULL);
    
    -- ��������� ��������
    PERFORM lpInsert_MovementProtocol (inId, vbUserId, False);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.
 19.01.17         *
*/
-- ����
-- SELECT * FROM gpUpdate_Movement_Check_OperDate (inId := 0, inOperDate := NULL::TDateTime, inInvNumber:= '12345'::TVarChar, inSession := '3'::TVarChar); 
