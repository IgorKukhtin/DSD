-- Function: gpSetErased_Movement_Income (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_Income (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_Income(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar                -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_Income());

    -- ������� ��������
    PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                , inUserId     := vbUserId);

     -- �������� - ���-��
     UPDATE Object_PartionGoods SET Amount = 0, isErased = TRUE, isArc = TRUE
     WHERE Object_PartionGoods.MovementId = inMovementId
    ;

    IF EXISTS (SELECT 1 FROM  Object_PartionGoods WHERE Object_PartionGoods.MovementId = inMovementId AND (Object_PartionGoods.isErased <> TRUE OR Object_PartionGoods.Amount <> 0 OR Object_PartionGoods.isArc <> TRUE))
    THEN
        RAISE EXCEPTION '������.�� ������� <%> ���������.', (SELECT COUNT(*) FROM  Object_PartionGoods WHERE Object_PartionGoods.MovementId = inMovementId AND (Object_PartionGoods.isErased <> TRUE OR Object_PartionGoods.Amount <> 0 OR Object_PartionGoods.isArc <> TRUE));
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ��������� �.�.
 25.04.17         *
*/
