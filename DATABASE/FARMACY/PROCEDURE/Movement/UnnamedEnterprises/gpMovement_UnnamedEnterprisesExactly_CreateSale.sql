-- Function: gpMovement_UnnamedEnterprisesExactly_CreateSale()

DROP FUNCTION IF EXISTS gpMovement_UnnamedEnterprisesExactly_CreateSale (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMovement_UnnamedEnterprisesExactly_CreateSale(
    IN inMovementId    Integer  , -- ���� ���������
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbSaleId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Sale());
  vbUserId:= inSession;

  IF EXISTS(SELECT 1 FROM MovementLinkMovement
            WHERE MovementLinkMovement.DescId = zc_MovementLinkMovement_Sale()
              AND MovementLinkMovement.MovementId = inMovementId)
  THEN
    RAISE EXCEPTION '������. �� ������� ����������� ������� ������� <%> �� <%>...',
      (SELECT Movement.InvNumber
       FROM MovementLinkMovement
            INNER JOIN Movement ON Movement.ID = MovementLinkMovement.MovementChildId
       WHERE MovementLinkMovement.DescId = zc_MovementLinkMovement_Sale()
         AND MovementLinkMovement.MovementId = inMovementId),
      (SELECT to_char(Movement.OperDate, 'DD-MM-YYYY')
       FROM MovementLinkMovement
            INNER JOIN Movement ON Movement.ID = MovementLinkMovement.MovementChildId
       WHERE MovementLinkMovement.DescId = zc_MovementLinkMovement_Sale()
         AND MovementLinkMovement.MovementId = inMovementId);
  END IF;

  vbSaleId := lpInsertUpdate_Movement_Sale (0,
                                            CAST (NEXTVAL ('movement_sale_seq') AS TVarChar),
                                            CURRENT_DATE,
                                            (SELECT MovementLinkObject.ObjectId FROM MovementLinkObject
                                             WHERE MovementLinkObject.MovementId = inMovementId
                                               AND MovementLinkObject.DescId = zc_MovementLinkObject_Unit()),
                                            1152890,
                                            zc_Enum_PaidKind_FirstForm(),
                                            Null, Null, Null, Null, Null, Null,
                                            '����������: ' || COALESCE ((SELECT Object_ClientsByBank.ValueData FROM MovementLinkObject
                                                      LEFT JOIN Object AS Object_ClientsByBank
                                                                       ON Object_ClientsByBank.Id = MovementLinkObject.ObjectId
                                                  WHERE MovementLinkObject.MovementId = inMovementId
                                                  AND MovementLinkObject.DescId = zc_MovementLinkObject_ClientsByBank()), '') ||
                                             ' ����� �����: ' || COALESCE ((SELECT MovementString.ValueData FROM MovementString
                                                  WHERE MovementString.MovementId = inMovementId
                                                  AND MovementString.DescId = zc_MovementString_AccountNumber()), ''),
                                            vbUserId);

  PERFORM lpInsertUpdate_MovementItem_Sale (0,
                                            vbSaleId,
                                            MovementItem.ObjectId,
                                            MovementItem.Amount,
                                            MIFloat_Price.ValueData,
                                            MIFloat_Price.ValueData,
                                            0::TFloat,
                                            MIFloat_Summ.ValueData,
                                            False,
                                            vbUserId)
  FROM MovementItem
       LEFT JOIN MovementItemFloat AS MIFloat_Price
                                   ON MIFloat_Price.MovementItemId = MovementItem.Id
                                  AND MIFloat_Price.DescId = zc_MIFloat_Price()

       LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                   ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                  AND MIFloat_Summ.DescId = zc_MIFloat_Summ()
  WHERE MovementItem.MovementId = inMovementId
    AND MovementItem.DescId = zc_MI_Master()
    AND MovementItem.isErased = FALSE
    AND COALESCE(MovementItem.Amount, 0) > 0;

  PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Sale(), inMovementId, vbSaleId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpMovement_UnnamedEnterprisesExactly_CreateSale (Integer,TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������ �.�.
 07.11.18        *
*/

-- select * from gpMovement_UnnamedEnterprisesExactly_CreateSale(inMovementId := 10582532 ,  inSession := '3');