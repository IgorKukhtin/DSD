-- Function: gpReComplete_Movement_TaxCorrective(integer, tvarchar)

DROP FUNCTION IF EXISTS gpReComplete_Movement_TaxCorrective (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReComplete_Movement_TaxCorrective(
    IN inMovementId        Integer               , -- ���� ���������
   OUT ouStatusCode        Integer               , -- ������ ���������. ������������ ������� ������ ����
   OUT outMessageText      Text                  ,
    IN inSession           TVarChar                -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_TaxCorrective());

     IF vbUserId = lpCheckRight(inSession, zc_Enum_Process_UnComplete_TaxCorrective())
     THEN
         -- ����������� ��������
         PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                      , inUserId     := vbUserId);
     END IF;

     -- �������� ��������
     outMessageText:= lpComplete_Movement_TaxCorrective (inMovementId     := inMovementId
                                                       , inUserId         := vbUserId
                                                        );
     -- ������� ������ (����� �� �� ���������)
     ouStatusCode:= (SELECT Object.ObjectCode FROM Movement INNER JOIN Object ON Object.Id = Movement.StatusId WHERE Movement.Id = inMovementId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 14.01.16                                        *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 1794 , inSession:= '2')
-- SELECT * FROM gpReComplete_Movement_TaxCorrective (inMovementId := 1794, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 1794 , inSession:= '2')

