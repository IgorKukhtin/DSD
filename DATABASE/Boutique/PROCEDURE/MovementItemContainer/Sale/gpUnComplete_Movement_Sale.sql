-- Function: gpUnComplete_Movement_Sale (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_Sale (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_Sale(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar                -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId   Integer;
  DECLARE vbStatusId Integer;
BEGIN
    IF zfConvert_StringToNumber (inSession) < 0
    THEN
        -- �������� ���� ������������ �� ����� ���������
        vbUserId:= lpCheckRight ((-1 * zfConvert_StringToNumber (inSession)) :: TVarChar, zc_Enum_Process_UnComplete_Sale());
    ELSE
        -- �������� ���� ������������ �� ����� ���������
        vbUserId:= lpCheckRight (inSession, zc_Enum_Process_UnComplete_Sale());
        -- vbUserId:= lpGetUserBySession (inSession);
    END IF;


    -- �������� - ���� ���������
    PERFORM lpCheckOperDate_byUnit (inUnitId_by:= lpGetUnit_byUser (vbUserId), inOperDate:= (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId), inUserId:= vbUserId);

    -- ���.������ ���������
    vbStatusId:= (SELECT Movement.StatusId FROM Movement WHERE Movement.Id = inMovementId);

    -- ����������� ��������
    PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);

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
 14.05.17         *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement_Sale (inMovementId:= 1100, inSession:= zfCalc_UserAdmin())
