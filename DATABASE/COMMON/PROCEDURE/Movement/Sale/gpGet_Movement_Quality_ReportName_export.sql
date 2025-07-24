-- Function: gpGet_Movement_Quality_ReportName_export()

DROP FUNCTION IF EXISTS gpGet_Movement_Quality_ReportName_export (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_Movement_Quality_ReportName_export (
    IN inMovementId         Integer  , -- ���� ���������
   OUT outReportName_fr3    TVarChar ,
   OUT outFileName          TVarChar ,
    IN inSession            TVarChar   -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);
     
     IF inMovementId = 0
     THEN
         RAISE INFO '������.inMovementId = <%>', inMovementId;
     END IF:
       
       
     outReportName_fr3:= gpGet_Movement_Quality_ReportName (inMovementId, inSession);
     --
     outFileName:= 'Doc_' || (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = inMovementId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 15.07.25                                        *
*/

-- ����
-- SELECT * FROM gpGet_Movement_Quality_ReportName_export (inMovementId:= 21043705, inSession:= '5'); -- ���
