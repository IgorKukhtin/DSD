-- Function: gpComplete_Movement_TaxCorrective()

DROP FUNCTION IF EXISTS gpComplete_Movement_TaxCorrective (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_TaxCorrective(
    IN inMovementId        Integer               , -- ���� ���������
    IN inIsLastComplete    Boolean  DEFAULT FALSE, -- ��� ��������� ���������� ����� ������� �/� (��� ������� �������� !!!�� ��������������!!!)
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
 RETURNS void
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_TaxCorrective());

     -- �������� ��������
     PERFORM lpComplete_Movement_TaxCorrective (inMovementId := inMovementId
                                              , inUserId     := vbUserId);


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
