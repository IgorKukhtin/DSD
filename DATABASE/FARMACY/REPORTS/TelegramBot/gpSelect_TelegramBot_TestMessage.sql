-- Function: gpSelect_TelegramBot_TestMessage()

DROP FUNCTION IF EXISTS gpSelect_TelegramBot_TestMessage (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_TelegramBot_TestMessage(
    IN inOperDate      TDateTime ,
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS TABLE (ObjectId Integer
             , TelegramId TVarChar
             , Message TBLOB
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
     vbUserId:= lpGetUserBySession (inSession);
     
     -- ���������
     RETURN QUERY
     SELECT 3, '568330367'::TVarChar, '������� ���������.'::TBLOB
     ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
--ALTER FUNCTION gpSelect_Movement_Check (TDateTime, TDateTime, Boolean, Integer, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 04.11.21                                                       * 
*/

-- ����

select * from gpSelect_TelegramBot_TestMessage(inOperDate := CURRENT_TIMESTAMP::TDateTime,  inSession := '3');