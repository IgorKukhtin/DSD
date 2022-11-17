-- Function: gpUpdate_Movement_Check_InsertDate()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Check_InsertDate (Integer, TDateTime, TVarChar);
  
CREATE OR REPLACE FUNCTION gpUpdate_Movement_Check_InsertDate(
    IN inId                Integer   , -- ���� ������� <�������� ���>
    IN inOperDate          TDateTime , -- ����/����� ���������
    IN inSession           TVarChar    -- ������ ������������
)
RETURNS void
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId := lpGetUserBySession (inSession);
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Movement_Check_InsertDate());

    IF inOperDate is null
    THEN
        RAISE EXCEPTION '���� �� ����������.';
    END IF;
    
    IF COALESCE(inId,0) = 0
    THEN
        RAISE EXCEPTION '�������� �� �������.';
    END IF;

    /*IF NOT EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = inId AND Movement.StatusId = zc_Enum_Status_Complete())
    THEN
        RETURN;
    END IF;
    */

    -- ��������� �������� <���� ��������>
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), inId, inOperDate);
    -- RAISE EXCEPTION '���� <%>', inOperDate;

    -- ��������� ��������
    PERFORM lpInsert_MovementProtocol (inId, vbUserId, False);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 17.11.22         *
*/
-- ����
--