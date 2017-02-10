-- Function: gpSetErased_Movement_TaxCorrective (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_TaxCorrective (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_TaxCorrective(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight(inSession, zc_Enum_Process_SetErased_TaxCorrective());

     -- ������� ��������
     PERFORM lpSetErased_Movement_TaxCorrective (inMovementId := inMovementId
                                               , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ������ �.�.
 06.05.14                                        * add lpSetErased_Movement_TaxCorrective
 14.02.14                                                       *
*/

-- ����
-- SELECT * FROM gpSetErased_Movement_TaxCorrective (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
