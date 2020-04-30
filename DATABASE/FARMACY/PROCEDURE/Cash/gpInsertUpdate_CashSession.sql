-- Function: gpInsertUpdate_CashSession()

DROP FUNCTION IF EXISTS gpInsertUpdate_CashSession (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_CashSession(
    IN inCashSessionId  TVarChar  , -- �� ������
    IN inSession        TVarChar         -- ������ ������������ 
)
RETURNS Void AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
   vbUserId:= lpGetUserBySession (inSession);

    IF EXISTS(SELECT 1 FROM CashSession WHERE CashSession.Id = inCashSessionId)
    THEN
        UPDATE CashSession SET
            StartUpdate = CURRENT_TIMESTAMP
          , UserId      = vbUserId
        WHERE
            CashSession.Id = inCashSessionId;
    ELSE
      PERFORM lpInsertUpdate_CashSession (inCashSessionId := inCashSessionId
                                        , inDateConnect   := CURRENT_TIMESTAMP :: TDateTime
                                        , inUserId        := vbUserId
                                         );    
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