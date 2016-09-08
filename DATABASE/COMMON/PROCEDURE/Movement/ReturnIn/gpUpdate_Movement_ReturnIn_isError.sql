-- Function: gpUpdate_Movement_ReturnIn_isError()

DROP FUNCTION IF EXISTS gpUpdate_Movement_ReturnIn_isError (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_ReturnIn_isError(
    IN inMovementId        Integer               , -- ���� ���������
   OUT outMessageText      Text                  , --
    IN inSession           TVarChar                -- ������ ������������
)
RETURNS Text
AS
$BODY$
  DECLARE vbUserId        Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_ReturnIn());

     -- ��������� �������������� �������� ����� - zc_MI_Child
     outMessageText:= lpUpdate_Movement_ReturnIn_Auto (inStartDateSale := DATE_TRUNC ('MONTH', (SELECT OperDate FROM Movement WHERE Id = inMovementId)) - INTERVAL '6 MONTH'
                                                     , inEndDateSale   := NULL
                                                     , inMovementId    := inMovementId
                                                     , inUserId        := vbUserId
                                                      );
     -- ��������� �������� <������>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementDate_OperDatePartner(), inMovementId, CASE WHEN outMessageText <> '' THEN TRUE ELSE FALSE END);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 08.09.16                                        *
*/

-- ����
-- SELECT gpUpdate_Movement_ReturnIn_isError (inMovementId:= Movement.Id, inUserId:= zfCalc_UserAdmin() :: Integer), Movement.* FROM Movement WHERE Movement.Id = 1
