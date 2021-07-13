-- Function: gpReport_TelegramBot_CheckSiteCount()

DROP FUNCTION IF EXISTS gpReport_TelegramBot_CheckSiteCount (TVarChar);

CREATE OR REPLACE FUNCTION gpReport_TelegramBot_CheckSiteCount(
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS TABLE (Message Text             
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCountPrev Integer;
   DECLARE vbCountCurr Integer;
   DECLARE vbSummCurr TFloat;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
     vbUserId:= lpGetUserBySession (inSession);
     
     SELECT SUM(Report.CountCurr)
          , SUM(Report.SummCurr)
     INTO vbCountCurr, vbSummCurr
     FROM gpReport_Movement_CheckSiteCount(inStartDate := CURRENT_DATE - INTERVAL '1 DAY', inEndDate := CURRENT_DATE - INTERVAL '1 DAY', inSession := inSession) AS Report;     
     
     SELECT SUM(Report.CountCurr)
     INTO vbCountPrev
     FROM gpReport_Movement_CheckSiteCount(inStartDate := CURRENT_DATE - INTERVAL '8 DAY', inEndDate := CURRENT_DATE - INTERVAL '8 DAY', inSession := inSession) AS Report;     

     -- ���������
     RETURN QUERY
     SELECT 
      ('�� '||zfConvert_DateToString(CURRENT_DATE - INTERVAL '1 DAY')||CHR(13)||'����� '||zfConvert_IntToString (COALESCE(vbCountCurr, 0))||
       ' �� ����� '||zfConvert_FloatToString (COALESCE(vbSummCurr, 0)::TFloat)||
       ' ���. ������� ��������� '||CASE WHEN vbCountPrev < vbCountCurr THEN ' + ' ELSE '' END||
       zfConvert_FloatToString (COALESCE(CASE WHEN COALESCE(vbCountPrev, 0) = 0 THEN 0 ELSE Round(vbCountCurr::TFloat / vbCountPrev::TFloat * 100.0 - 100.0, 2) END, 0)::TFloat)||' %')::Text;

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

select * from gpReport_TelegramBot_CheckSiteCount(inSession := '3');     
