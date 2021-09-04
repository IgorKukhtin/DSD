-- Function: gpReComplete_Movement_PromoInvoice(integer, boolean, tvarchar)

DROP FUNCTION IF EXISTS gpReComplete_Movement_PromoInvoice (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReComplete_Movement_PromoInvoice(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_PromoInvoice());

     IF vbUserId = lpCheckRight(inSession, zc_Enum_Process_UnComplete_PromoInvoice())
     THEN
         -- ����������� ��������
         PERFORM lpUnComplete_Movement_PromoInvoice (inMovementId := inMovementId
                                                   , inUserId     := vbUserId);
     END IF;

     -- �������� ��������
     PERFORM lpComplete_Movement_PromoInvoice (inMovementId     := inMovementId
                                             , inUserId         := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 01.11.20         *
*/

-- ����
-- 