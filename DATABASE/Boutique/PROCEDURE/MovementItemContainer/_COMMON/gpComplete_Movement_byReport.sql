-- Function: gpComplete_Movement_byReport (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpComplete_Movement_byReport (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_byReport(
    IN inMovementId   Integer    , -- ���� ������� <��������>
   OUT outStatusCode  Integer    , --
    IN inSession      TVarChar     -- ������� ������������
)
AS
$BODY$
  DECLARE vbUserId   Integer;
  DECLARE vbDescId   Integer;
  DECLARE vbOperDate TDateTime;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);

     -- ���������� ��� ��������� + ����
     SELECT Movement.DescId, Movement.OperDate INTO vbDescId, vbOperDate FROM Movement WHERE Movement.Id = inMovementId;


     -- ��������
     IF vbOperDate < DATE_TRUNC ('DAY', CURRENT_TIMESTAMP - INTERVAL '14 HOUR')
     THEN
         RAISE EXCEPTION '������.��������� ������ �������� ������ � <%>', zfConvert_DateToString (DATE_TRUNC ('DAY', CURRENT_TIMESTAMP - INTERVAL '14 HOUR'));
     END IF;


     -- �������
     PERFORM CASE WHEN vbDescId = zc_Movement_Sale()         THEN gpComplete_Movement_Sale_User         (inMovementId, inSession)
                  WHEN vbDescId = zc_Movement_ReturnIn()     THEN gpComplete_Movement_ReturnIn_User     (inMovementId, inSession)
                  WHEN vbDescId = zc_Movement_GoodsAccount() THEN gpComplete_Movement_GoodsAccount_User (inMovementId, inSession)
             END;

     -- �������
     outStatusCode := (SELECT Object_Status.ObjectCode  AS StatusCode
                       FROM Movement
                            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
                       WHERE Movement.Id = inMovementId
                      );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 26.02.18         * _User
 19.01.18         *
*/

-- ����
-- SELECT * FROM gpComplete_Movement_byReport (inMovementId:= 55, inSession:= '2')
