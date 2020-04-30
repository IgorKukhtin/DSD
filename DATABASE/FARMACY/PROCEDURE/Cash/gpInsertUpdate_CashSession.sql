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

    PERFORM lpInsertUpdate_CashSession (inCashSessionId := inCashSessionId
                                      , inDateConnect   := CURRENT_TIMESTAMP :: TDateTime
                                      , inUserId        := vbUserId
                                       );

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