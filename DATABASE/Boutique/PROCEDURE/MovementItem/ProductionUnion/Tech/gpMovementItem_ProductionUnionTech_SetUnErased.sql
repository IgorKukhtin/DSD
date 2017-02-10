-- Function: gpMovementItem_ProductionUnionTech_SetUnErased (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpMovementItem_ProductionUnionTech_SetUnErased (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMovementItem_ProductionUnionTech_SetUnErased(
    IN inMovementItemId      Integer              , -- ���� ������� <������� ���������>
   OUT outAmount_master      TFloat               , -- ���������� � zc_MI_Master
   OUT outIsErased           Boolean              , -- ����� ��������
    IN inSession             TVarChar               -- ������� ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpCheckRight(inSession, zc_Enum_Process_SetUnErased_MI_ProductionUnion());

   -- ������������� ����� ��������
   outIsErased:= lpSetUnErased_MovementItem (inMovementItemId:= inMovementItemId, inUserId:= vbUserId);

   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Update(), inMovementItemId, vbUserId);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Update(), inMovementItemId, CURRENT_TIMESTAMP);

   -- �������� ���-�� ��� zc_MI_Master + �������� ��-�� <����������> ��� ��� � ���� isTaxExit=TRUE
   outAmount_master:= (SELECT tmp.outAmount_master
                       FROM lpUpdate_MI_ProductionUnionTech_Recalc (inMovementId         := (SELECT MovementItem.MovementId FROM MovementItem WHERE MovementItem.Id = inMovementItemId)
                                                                  , inMovementItemId     := inMovementItemId
                                                                  , inParentId           := (SELECT MovementItem.ParentId FROM MovementItem WHERE MovementItem.Id = inMovementItemId)
                                                                  , inReceiptId          := (SELECT MILO_Receipt.ObjectId FROM MovementItemLinkObject AS MILO_Receipt WHERE MILO_Receipt.MovementItemId = (SELECT MovementItem.ParentId FROM MovementItem WHERE MovementItem.Id = inMovementItemId) AND MILO_Receipt.DescId = zc_MILinkObject_Receipt())
                                                                  , inIsTaxExit          := COALESCE ((SELECT MIBoolean_TaxExit.ValueData FROM MovementItemBoolean AS MIBoolean_TaxExit WHERE MIBoolean_TaxExit.MovementItemId = inMovementItemId AND MIBoolean_TaxExit.DescId = zc_MIBoolean_TaxExit()), FALSE)
                                                                  , ioAmount             := (SELECT MovementItem.Amount FROM MovementItem WHERE MovementItem.Id = inMovementItemId)
                                                                  , inAmountReceipt      := (SELECT MIFloat_AmountReceipt.ValueData FROM MovementItemFloat AS MIFloat_AmountReceipt WHERE MIFloat_AmountReceipt.MovementItemId = inMovementItemId AND MIFloat_AmountReceipt.DescId = zc_MIFloat_AmountReceipt())
                                                                  , inUserId             := vbUserId
                                                                   ) AS tmp);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpMovementItem_ProductionUnionTech_SetUnErased (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.A.
 04.05.15                                        *
*/

-- ����
-- SELECT * FROM gpMovementItem_ProductionUnionTech_SetUnErased (inMovementId:= 55, inJuridicalId = 1, inSession:= '2')
