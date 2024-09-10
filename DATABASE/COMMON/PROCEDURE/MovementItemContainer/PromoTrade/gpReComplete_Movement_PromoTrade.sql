-- Function: gpReComplete_Movement_PromoTrade(integer, boolean, tvarchar)

DROP FUNCTION IF EXISTS gpReComplete_Movement_PromoTrade (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReComplete_Movement_PromoTrade(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_PromoTrade());

     IF vbUserId = lpCheckRight(inSession, zc_Enum_Process_UnComplete_PromoTrade())
     THEN
         -- ����������� ��������
         PERFORM lpUnComplete_Movement_PromoTrade (inMovementId := inMovementId
                                                   , inUserId     := vbUserId);
     END IF;

     -- �������� ��������
     PERFORM lpComplete_Movement_PromoTrade (inMovementId     := inMovementId
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