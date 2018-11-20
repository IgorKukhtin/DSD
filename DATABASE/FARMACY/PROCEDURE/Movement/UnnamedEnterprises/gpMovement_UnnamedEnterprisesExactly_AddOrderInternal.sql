-- Function: gpMovement_UnnamedEnterprisesExactly_AddOrderInternal()

DROP FUNCTION IF EXISTS gpMovement_UnnamedEnterprisesExactly_AddOrderInternal (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMovement_UnnamedEnterprisesExactly_AddOrderInternal(
    IN inMovementId        Integer  , -- ���� ���������
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbUnitId Integer;
    DECLARE vbOrderInternalId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Sale());
  vbUserId:= inSession;

  IF EXISTS(SELECT 1 FROM MovementLinkMovement
            WHERE MovementLinkMovement.DescId = zc_MovementLinkMovement_Order()
              AND MovementLinkMovement.MovementId = inMovementId)
  THEN
    RAISE EXCEPTION '������. ������ ��������� �� ���������� ����� ����� <%> �� <%> ...',
      (SELECT Movement.InvNumber
       FROM MovementLinkMovement
            INNER JOIN Movement ON Movement.ID = MovementLinkMovement.MovementChildId
       WHERE MovementLinkMovement.DescId = zc_MovementLinkMovement_Order()
         AND MovementLinkMovement.MovementId = inMovementId),
      (SELECT to_char(Movement.OperDate, 'DD-MM-YYYY')
       FROM MovementLinkMovement
            INNER JOIN Movement ON Movement.ID = MovementLinkMovement.MovementChildId
       WHERE MovementLinkMovement.DescId = zc_MovementLinkMovement_Order()
         AND MovementLinkMovement.MovementId = inMovementId);
  END IF;

  SELECT
    MovementLinkObject_Unit.ObjectId
  INTO
    vbUnitId
  FROM MovementLinkObject AS MovementLinkObject_Unit
  WHERE MovementLinkObject_Unit.MovementId = inMovementId
    AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit();

  IF NOT EXISTS(SELECT 1 FROM MovementItem
                           INNER JOIN MovementItemFloat ON MovementItemFloat.MovementItemId = MovementItem.Id
                                                       AND MovementItemFloat.ValueData > 0
                WHERE MovementItemFloat.DescId = zc_MIFloat_AmountOrder() and MovementItem.MovementID = inMovementId)
  THEN
    RAISE EXCEPTION '������. � "������ �����������" ��� ������� ��� ������� � �����...';
  END IF;

  IF NOT EXISTS(SELECT 1 FROM Movement
                           INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                        AND MovementLinkObject_Unit.ObjectId = vbUnitId
                WHERE Movement.OperDate = CURRENT_DATE
                  AND Movement.DescId = zc_Movement_OrderInternal())
  THEN
    RAISE EXCEPTION '������. ���������� ����� �� ������������� �� ������� �� ������...';
  END IF;

  IF NOT EXISTS(SELECT 1 FROM Movement
                           INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                        AND MovementLinkObject_Unit.ObjectId = vbUnitId
                WHERE Movement.OperDate = CURRENT_DATE
                  AND Movement.DescId = zc_Movement_OrderInternal()
                  AND Movement.StatusId = zc_Enum_Status_UnComplete())
  THEN
    RAISE EXCEPTION '������. ���������� ����� �� ������������� �� ������� ��������...';
  END IF;

  SELECT
    Movement.ID
  INTO
    vbOrderInternalId
  FROM Movement
       INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                     ON MovementLinkObject_Unit.MovementId = Movement.Id
                                    AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                    AND MovementLinkObject_Unit.ObjectId = vbUnitId
  WHERE Movement.OperDate = CURRENT_DATE
    AND Movement.DescId = zc_Movement_OrderInternal()
    AND Movement.StatusId = zc_Enum_Status_UnComplete() LIMIT 1;


  PERFORM lpInsertUpdate_MI_UnnamedEnterprises_OrderInternal(vbOrderInternalId,
                                                             MovementItem.ObjectId,
                                                             MIFloat_AmountOrder.ValueData,
                                                             inSession)
  FROM MovementItem
       INNER JOIN MovementItemFloat AS MIFloat_AmountOrder
                                   ON MIFloat_AmountOrder.MovementItemId = MovementItem.Id
                                   AND MIFloat_AmountOrder.DescId = zc_MIFloat_AmountOrder()
  WHERE MovementItem.MovementId = inMovementId
    AND MovementItem.DescId = zc_MI_Master()
    AND MovementItem.isErased = FALSE
    AND COALESCE(MIFloat_AmountOrder.ValueData, 0) > 0;

  PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Order(), inMovementId, vbOrderInternalId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpMovement_UnnamedEnterprisesExactly_AddOrderInternal (Integer,TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������ �.�.
 16.11.18        *
 07.11.18        *
*/

-- select * from gpMovement_UnnamedEnterprisesExactly_AddOrderInternal(inMovementId := 10582532 ,  inSession := '3');