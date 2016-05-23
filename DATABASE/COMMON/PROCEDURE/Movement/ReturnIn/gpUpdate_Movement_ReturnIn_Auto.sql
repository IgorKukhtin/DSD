-- Function: gpUpdate_Movement_ReturnIn_Auto()

DROP FUNCTION IF EXISTS gpUpdate_Movement_ReturnIn_Auto (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_ReturnIn_Auto(
    IN inMovementId        Integer               , -- ���� ���������
    IN inStartDateSale     TDateTime             , --
   OUT outMessageText      Text                  , --
    IN inSession           TVarChar                -- ������ ������������
)
RETURNS Text
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_ReturnIn());

     -- ��������� �������������� �������� ����� - zc_MI_Child
     outMessageText:= lpUpdate_Movement_ReturnIn_Auto (inStartDateSale := inStartDateSale
                                                     , inEndDateSale   := NULL
                                                     , inMovementId    := inMovementId
                                                     , inUserId        := vbUserId
                                                      );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 18.05.16                                        *
*/

-- ����
-- SELECT * FROM MovementItem WHERE MovementId = 3662505 AND DescId = zc_MI_Child() -- SELECT * FROM MovementItemFloat WHERE MovementItemId IN (SELECT Id FROM MovementItem WHERE MovementId = 3662505 AND DescId = zc_MI_Child())
-- SELECT gpUpdate_Movement_ReturnIn_Auto (inMovementId:= Movement.Id, inStartDateSale:= Movement.OperDate - INTERVAL '15 DAY' , inUserId:= zfCalc_UserAdmin() :: Integer) || CHR (13), Movement.* FROM Movement WHERE Movement.Id = 3662505
-- SELECT gpUpdate_Movement_ReturnIn_Auto (inMovementId:= Movement.Id, inStartDateSale:= Movement.OperDate - INTERVAL '4 MONTH', inUserId:= zfCalc_UserAdmin() :: Integer) || CHR (13), Movement.* FROM Movement WHERE Movement.Id = 3662505
