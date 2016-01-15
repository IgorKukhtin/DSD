-- Function: gpReComplete_Movement_TaxCorrective(integer, tvarchar)

DROP FUNCTION IF EXISTS gpReComplete_Movement_TaxCorrective (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReComplete_Movement_TaxCorrective(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar                -- ������ ������������
)
RETURNS VOID
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
     PERFORM lpComplete_Movement_TaxCorrective (inMovementId     := inMovementId
                                              , inUserId         := vbUserId
                                               );

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

