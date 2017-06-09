-- Function: gpUpdate_Movement_Income_CheckParam()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Income_CheckParam (Integer, Integer, TDateTime, Boolean, TVarChar);
  
CREATE OR REPLACE FUNCTION gpUpdate_Movement_Income_CheckParam(
    IN inId                  Integer   , -- ���� ������� <��������>
    IN inMemberIncomeCheckId Integer   , -- ��� ���������. ����
    IN inCheckDate           TDateTime , -- ���� �������� ���������. �����
    IN inisSaveNull          Boolean   , -- ��������� ������ ��������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Void
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_...());
    vbUserId := lpGetUserBySession (inSession);

    IF (COALESCE (inisSaveNull, True) = True) OR (COALESCE (inisSaveNull, True) = False AND COALESCE (inMemberIncomeCheckId,0) <> 0)
       THEN   
           -- ��������� ����� � <>
           PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_MemberIncomeCheck(), inId, inMemberIncomeCheckId);
           IF COALESCE (inMemberIncomeCheckId,0) <> 0 
              THEN
                  -- ��������� <>
                  PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Check(), inId, inCheckDate);
              ELSE
                  -- ��������� <>
                  PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Check(), inId, NULL);
           END IF;
    END IF;

    -- ��������� ��������
    PERFORM lpInsert_MovementProtocol (inId, vbUserId, False);
   
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.
 08.06.17         *
*/

-- ����
-- 