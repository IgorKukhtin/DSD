-- Function: gpUnComplete_Movement_GoodsAccount (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_GoodsAccount (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_GoodsAccount(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar                -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId   Integer;
  DECLARE vbStatusId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId:= lpCheckRight (inSession, zc_Enum_Process_UnComplete_GoodsAccount());
    -- vbUserId:= lpGetUserBySession (inSession);


    -- �������� - ���� ���������
    PERFORM lpCheckOperDate_byUnit (inUnitId_by:= lpGetUnit_byUser (vbUserId), inOperDate:= (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId), inUserId:= vbUserId);

    -- ���.������ ���������
    vbStatusId:= (SELECT Movement.StatusId FROM Movement WHERE Movement.Id = inMovementId);

    -- ����������� ��������
    PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);

    -- ����������� "��������" ����� �� ��������� ������ ������� / ��������
    PERFORM lpUpdate_MI_Partion_Total_byMovement (inMovementId);

    -- ���� ��� ������ ��������
    IF vbStatusId = zc_Enum_Status_Complete() 
    THEN 
         -- �������� �������� ����� �� ����������
         PERFORM lpUpdate_Object_Client_Total (inMovementId:= inMovementId, inIsComplete:= FALSE, inUserId:= vbUserId);
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�
 23.07.17         *
 18.05.17         *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement_GoodsAccount (inMovementId:= 1100, inSession:= zfCalc_UserAdmin())
