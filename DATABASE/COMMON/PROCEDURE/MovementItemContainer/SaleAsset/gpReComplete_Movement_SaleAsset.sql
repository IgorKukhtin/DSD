-- Function: gpReComplete_Movement_Sale(integer, tvarchar)

DROP FUNCTION IF EXISTS gpReComplete_Movement_SaleAsset (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReComplete_Movement_SaleAsset(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_SaleAsset());

     IF vbUserId = lpCheckRight(inSession, zc_Enum_Process_UnComplete_SaleAsset())
     THEN
         -- ����������� ��������
         PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                      , inUserId     := vbUserId);
     END IF;


     -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
     -- PERFORM lpComplete_Movement_SaleAsset_CreateTemp();
     -- �������� ��������
     PERFORM gpComplete_Movement_SaleAsset (inMovementId     := inMovementId
                                     , inIsLastComplete := NULL
                                     , inSession        := inSession);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 18.06.20         *
*/

-- ����
-- 