-- Function: gpComplete_Movement_byReport (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpComplete_Movement_byReport (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_byReport(
    IN inMovementId   Integer    , -- ���� ������� <��������>
   OUT outStatusCode  Integer    , --
    IN inSession      TVarChar     -- ������� ������������
)                              
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbDescId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);

     -- ���������� ��� ���������
     vbDescId := (SELECT Movement.DescId FROM Movement WHERE Movement.Id = inMovementId);
     
     PERFORM CASE WHEN vbDescId = zc_Movement_Sale()         THEN gpComplete_Movement_Sale (inMovementId, inSession)
                  WHEN vbDescId = zc_Movement_ReturnIn()     THEN gpComplete_Movement_ReturnIn (inMovementId, inSession)
                  WHEN vbDescId = zc_Movement_GoodsAccount() THEN gpComplete_Movement_GoodsAccount (inMovementId, inSession)
             END;

     outStatusCode := (SELECT Object_Status.ObjectCode  AS StatusCode
                       FROM Movement 
                            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
                       WHERE Movement.Id = inMovementId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 19.01.18         *
*/

-- ����
-- SELECT * FROM gpComplete_Movement_byReport (inMovementId:= 55, inSession:= '2')
