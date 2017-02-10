-- Function: gpComplete_Movement_Promo()

DROP FUNCTION IF EXISTS gpComplete_Movement_Promo  (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_Promo(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId    Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_Promo());


     -- ���������� "�����" ������������ + �� �������� �� ����������� ������
     PERFORM lpUpdate_Movement_Promo_Auto (inMovementId := inMovementId
                                         , inUserId     := vbUserId
                                          );

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
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
 29.11.15                                        * add lpUpdate_Movement_Promo_Auto
 13.10.15                                                         *
 */