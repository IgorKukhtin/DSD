-- Function: gpUpdate_Movement_Promo_ChangePercent()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Promo_ChangePercent (Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Promo_ChangePercent(
    IN inMovementId            Integer   , -- ���� ������� <��������>
    IN inChangePercent         TFloat    , -- (-)% ��. (+)% ���.
    IN inSession               TVarChar     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_Promo_ChangePercent());
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Promo());

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ChangePercent(), inMovementId, inChangePercent);
     

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 13.07.20         *
*/

-- ����
-- SELECT * FROM gpUpdate_Movement_Promo_ChangePercent (inMovementId:= 2641111, inChangePercent := 5, inSession:= zfCalc_UserAdmin())
