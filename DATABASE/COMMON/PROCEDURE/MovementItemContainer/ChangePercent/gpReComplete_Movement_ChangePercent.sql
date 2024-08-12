-- Function: gpReComplete_Movement_ChangePercent(integer, tvarchar)

DROP FUNCTION IF EXISTS gpReComplete_Movement_ChangePercent (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReComplete_Movement_ChangePercent(
    IN inMovementId        Integer               , -- ���� ���������
   OUT outMessageText      Text                  ,
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS Text
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_ChangePercent());

     IF vbUserId = lpCheckRight(inSession, zc_Enum_Process_UnComplete_ChangePercent())
     THEN
         -- ����������� ��������
         PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                      , inUserId     := vbUserId);
     END IF;


     -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
     PERFORM lpComplete_Movement_ChangePercent_CreateTemp();
     -- �������� ��������
     outMessageText:= lpComplete_Movement_ChangePercent (inMovementId     := inMovementId
                                                       , inUserId         := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 02.03.23         *
*/

-- ����
-- SELECT * FROM gpReComplete_Movement_ChangePercent (inMovementId:= 122175, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 122175 , inSession:= '2')
