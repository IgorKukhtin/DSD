-- Function: gpReComplete_Movement_SaleExternal(integer, boolean, tvarchar)

DROP FUNCTION IF EXISTS gpReComplete_Movement_SaleExternal (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReComplete_Movement_SaleExternal(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_SaleExternal());

     IF vbUserId = lpCheckRight(inSession, zc_Enum_Process_UnComplete_SaleExternal())
     THEN
         -- ����������� ��������
         PERFORM lpUnComplete_Movement_SaleExternal (inMovementId := inMovementId
                                                   , inUserId     := vbUserId);
     END IF;

     -- �������� ��������
     PERFORM lpComplete_Movement_SaleExternal (inMovementId     := inMovementId
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