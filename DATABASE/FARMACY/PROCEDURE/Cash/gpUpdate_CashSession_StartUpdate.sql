-- Function: gpUpdate_CashSession_StartUpdate()

DROP FUNCTION IF EXISTS gpUpdate_CashSession_StartUpdate (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_CashSession_StartUpdate(
    IN inCashSessionId  TVarChar  , -- �� ������
   OUT outStartOk       boolean   , -- �������� ������ ����������  
   OUT outMessage       TVarChar  , -- �������  ������� ����������
    IN inSession        TVarChar    -- ������ ������������  
)
RETURNS Record AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
   vbUserId:= lpGetUserBySession (inSession);

   outStartOk := COALESCE((SELECT count(*) FROM CashSession
                           WHERE CashSession.StartUpdate > CURRENT_TIMESTAMP - INTERVAL '5 MIN'), 0) < 11;
    
   IF outStartOk = TRUE
   THEN
      IF EXISTS(SELECT 1 FROM CashSession WHERE CashSession.Id = inCashSessionId)
      THEN
          UPDATE CashSession SET
              UserId      = vbUserId
            , StartUpdate = CURRENT_TIMESTAMP
          WHERE
              CashSession.Id = inCashSessionId;
      ELSE
          PERFORM lpInsertUpdate_CashSession (inCashSessionId := inCashSessionId
                                            , inDateConnect   := CURRENT_TIMESTAMP :: TDateTime
                                            , inUserId        := vbUserId
                                             );
      END IF;
   ELSE
      outMessage := '�������� ����� ���������� ���������� ����� ��������� �����...';
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ������ �.�.
 29.04.20                                                      *
*/

/*
*/