-- Function: gpGet_CashSession_Busy()

DROP FUNCTION IF EXISTS gpGet_CashSession_Busy (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_CashSession_Busy(
    IN inCashSessionId  TVarChar  , -- �� ������
   OUT outisBusy        Boolean   , -- ����� CashSessionId
    IN inSession        TVarChar    -- ������ ������������ 
)
RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
   vbUserId:= lpGetUserBySession (inSession);

    IF EXISTS(SELECT 1 
              FROM CashSession 
              WHERE CashSession.Id = inCashSessionId 
                AND CashSession.UserId <> vbUserId
                AND StartUpdate > CURRENT_DATE)
    THEN
      outisBusy := True;  
    ELSE
      outisBusy := False;  
    END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ������ �.�.
 13.03.21                                                      *
*/

SELECT * FROM gpGet_CashSession_Busy('{0B05C610-B172-4F81-99B8-25BF5385ADD6}', '3' );