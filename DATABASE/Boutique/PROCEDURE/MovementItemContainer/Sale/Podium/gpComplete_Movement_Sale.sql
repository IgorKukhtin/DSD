-- Function: gpComplete_Movement_Sale()

DROP FUNCTION IF EXISTS gpComplete_Movement_Sale (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpComplete_Movement_Sale (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_Sale(
    IN inMovementId        Integer               , -- ���� ���������
    IN inKeySMS            Integer               , -- 
    IN inSession           TVarChar                -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_Sale());


     -- �������� - ���� ���������
     PERFORM lpCheckOperDate_byUnit (inUnitId_by:= lpGetUnit_byUser (vbUserId), inOperDate:= (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId), inUserId:= vbUserId);

     -- ��������� ��������� ������� - ��� ������������ ������ �� ���������
     PERFORM lpComplete_Movement_Sale_CreateTemp();

     -- ������������
     IF 1=1 AND zc_Enum_GlobalConst_isTerry() = FALSE AND zfCalc_User_PriceListReal (vbUserId) = TRUE
        -- ������� ����
        AND EXISTS (SELECT 1 FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.ObjectId = 6319 AND MLO.DescId = zc_MovementLinkObject_From())
     THEN
         PERFORM gpComplete_Movement_Sale_recalc (inMovementId := inMovementId
                                                , inSession    := inSession
                                                 );
     END IF;

     -- ���������� ��������
     PERFORM lpComplete_Movement_Sale (inMovementId  -- ��������
                                     , inKeySMS
                                     , vbUserId);    -- ������������

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
 14.05.17         *
 */

-- ����
-- SELECT * FROM gpComplete_Movement_Sale (inMovementId:= 1100, inSession:= zfCalc_UserAdmin())
