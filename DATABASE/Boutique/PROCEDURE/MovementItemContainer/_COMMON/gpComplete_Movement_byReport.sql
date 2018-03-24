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


     -- ���������� ��������� ���������
     SELECT Movement.DescId, Movement.OperDate INTO vbDescId, vbOperDate FROM Movement WHERE Movement.Id = inMovementId;


     -- �������� - ���� ���������
     PERFORM lpCheckOperDate_byUnit (inUnitId_by:= lpGetUnit_byUser (vbUserId), inOperDate:= vbOperDate, inUserId:= vbUserId);


     -- ��������� �������� <���� �������������> - �� ���� ����������
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Update(), inMovementId, CURRENT_TIMESTAMP);
     -- ��������� �������� <������������ (�������������)> - �� ������������ ����������
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Update(), inMovementId, vbUserId);


     -- 1.�������
     IF vbDescId = zc_Movement_Sale()
     THEN
         -- ��������� ��������� ������� - ��� ������������ ������ �� ���������
         PERFORM lpComplete_Movement_Sale_CreateTemp();
         -- ���������� ��������
         PERFORM lpComplete_Movement_Sale (inMovementId  -- ��������
                                         , vbUserId);    -- ������������
     END IF;

     -- 2.�������
     IF vbDescId = zc_Movement_ReturnIn()
     THEN
         -- ��������� ��������� ������� - ��� ������������ ������ �� ���������
         PERFORM lpComplete_Movement_ReturnIn_CreateTemp();
         -- ���������� ��������
         PERFORM lpComplete_Movement_ReturnIn (inMovementId  -- ��������
                                             , vbUserId);    -- ������������
     END IF;

     -- 3.�������
     IF vbDescId = zc_Movement_GoodsAccount()
     THEN
         -- ��������� ��������� ������� - ��� ������������ ������ �� ���������
         PERFORM lpComplete_Movement_GoodsAccount_CreateTemp();
         -- ���������� ��������
         PERFORM lpComplete_Movement_GoodsAccount (inMovementId  -- ��������
                                                 , vbUserId);    -- ������������
     END IF;


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
