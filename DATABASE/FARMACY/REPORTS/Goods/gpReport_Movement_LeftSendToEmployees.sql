-- Function: gpReport_Movement_LeftSendToEmployees()

DROP FUNCTION IF EXISTS gpReport_Movement_LeftSendToEmployees (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Movement_LeftSendToEmployees(
    IN inOperDate      TDateTime,  -- ����
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS TABLE ("�����"        TVarChar
             , "����"         TDateTime
             , "% ��������"   TFloat
             , "������"       TVarChar
             , "����"         TVarChar
              )

AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     -- ���������
     RETURN QUERY
       SELECT
             Report.InvNumber
           , Report.OperDate
           , Report.ReturnRate
           , Report.FromName
           , Report.ToName
       FROM gpReport_Movement_LeftSend (inOperDate, inOperDate, inSession) AS Report
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpReport_Movement_LeftSendToEmployees (TDateTime, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 04.08.20                                                       *
*/

-- ����
--
SELECT * FROM gpReport_Movement_LeftSendToEmployees (inOperDate:= '21.09.2019', inSession:= '3')