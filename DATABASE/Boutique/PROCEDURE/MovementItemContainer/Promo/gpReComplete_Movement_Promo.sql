-- Function: gpReComplete_Movement_Promo(integer, tvarchar)

DROP FUNCTION IF EXISTS gpReComplete_Movement_Promo (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReComplete_Movement_Promo(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_Promo());

     IF vbUserId = lpCheckRight(inSession, zc_Enum_Process_UnComplete_Promo())
     THEN
         -- ����������� ��������
         PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                      , inUserId     := vbUserId);
     END IF;

     -- �������� �������� + ��������� ��������
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_Promo()
                                , inUserId     := vbUserId
                                 );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  �o������� �.�.
 13.10.15                                                         *
*/
