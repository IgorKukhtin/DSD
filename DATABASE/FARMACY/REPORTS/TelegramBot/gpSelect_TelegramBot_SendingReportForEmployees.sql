-- Function: gpSelect_TelegramBot_SendingReportForEmployees()

DROP FUNCTION IF EXISTS gpSelect_TelegramBot_SendingReportForEmployees (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_TelegramBot_SendingReportForEmployees(
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS TABLE (Id Integer
             , DateSend TDateTime
             , ChatIDList TVarChar
             , SQL TVarChar
             
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
     SELECT 1, (CURRENT_DATE + INTERVAL '12 HOUR')::TDateTime, '568330367,300408824'::TVarChar, 'SELECT * FROM gpReport_TelegramBot_CheckSiteCount (''3'')'::TVarChar
     UNION ALL
     SELECT 2, (CURRENT_DATE + INTERVAL '12 HOUR')::TDateTime, '568330367,300408824'::TVarChar, 'SELECT * FROM gpReport_TelegramBot_DynamicsOrdersEIC (''3'')'::TVarChar
     ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
--ALTER FUNCTION gpSelect_Movement_Check (TDateTime, TDateTime, Boolean, Integer, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 17.06.21                                                       * 
*/

-- ����

select * from gpSelect_TelegramBot_SendingReportForEmployees(inSession := '3');