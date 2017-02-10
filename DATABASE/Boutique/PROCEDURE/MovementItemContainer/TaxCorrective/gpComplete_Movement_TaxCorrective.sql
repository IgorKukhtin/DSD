-- Function: gpComplete_Movement_TaxCorrective()

DROP FUNCTION IF EXISTS gpComplete_Movement_TaxCorrective (Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpComplete_Movement_TaxCorrective (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_TaxCorrective(
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

     -- �������� ��������
     outMessageText:= lpComplete_Movement_TaxCorrective (inMovementId := inMovementId
                                                       , inUserId     := vbUserId);

     -- ������� ������ (����� �� �� ���������)
     ouStatusCode:= (SELECT Object.ObjectCode FROM Movement INNER JOIN Object ON Object.Id = Movement.StatusId WHERE Movement.Id = inMovementId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ������ �.�.
 06.05.14                                        * add lpComplete_Movement_TaxCorrective
 14.02.14                                                        *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 10154, inSession:= '2')
-- SELECT * FROM gpComplete_Movement_TaxCorrective (inMovementId:= 10154, inIsLastComplete:= FALSE, inSession:= zfCalc_UserAdmin())
