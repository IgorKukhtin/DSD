-- Function: gpUpdate_Log_CashRemains_Version()

DROP FUNCTION IF EXISTS gpUpdate_Log_CashRemains_Version (TVarChar, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Log_CashRemains_Version(
    IN inCashSessionId TVarChar,   -- ������ ��������� �����
    IN inOldProgram    Boolean,
    IN inOldServise    Boolean,
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS Void
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());

    vbUserId := lpGetUserBySession (inSession);
    
    IF EXISTS(SELECT 1 FROM Log_CashRemains WHERE Log_CashRemains.CashSessionId = inCashSessionId)  
    THEN
      UPDATE Log_CashRemains SET OldProgram = inOldProgram, OldServise = inOldServise WHERE ID =
        (SELECT MAX(ID) FROM Log_CashRemains WHERE Log_CashRemains.CashSessionId = inCashSessionId);
    END IF;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������ �.�.
 06.01.19         *
*/
