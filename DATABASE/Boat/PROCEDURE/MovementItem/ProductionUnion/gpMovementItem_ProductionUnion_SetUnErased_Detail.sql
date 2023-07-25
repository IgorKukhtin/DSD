-- Function: gpMovementItem_ProductionUnion_SetUnErased_Detail (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpMovementItem_ProductionUnion_SetUnErased_Detail (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMovementItem_ProductionUnion_SetUnErased_Detail(
    IN inMovementItemId      Integer              , -- ���� ������� <������� ���������>
   OUT outIsErased           Boolean              , -- ����� ��������
    IN inSession             TVarChar               -- ������� ������������
)
RETURNS Boolean
AS
$BODY$
   DECLARE vbUserId     Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbPartnerId  Integer;
   DECLARE vbVATPercent TFloat;
BEGIN
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_SetUnErased_MI_ProductionUnion());
     vbUserId:= lpGetUserBySession (inSession);

     -- ������������� ����� ��������
     outIsErased:= lpSetUnErased_MovementItem (inMovementItemId:= inMovementItemId, inUserId:= vbUserId);


     --
     vbMovementId:= (SELECT MovementItem.MovementId FROM MovementItem WHERE MovementItem.Id= inMovementItemId);

     -- ��������� ����� - ����������� ������������� �� ������ zc_MI_Detail
     vbPartnerId := (SELECT MAX (ObjectLink_Partner.ChildObjectId)
                     FROM MovementItem
                          INNER JOIN MovementItem AS MovementItem_parent ON MovementItem_parent.Id       = MovementItem.ParentId
                                                                        AND MovementItem_parent.isErased = FALSE
                          INNER JOIN ObjectLink AS ObjectLink_Partner
                                                  ON ObjectLink_Partner.ObjectId      = MovementItem.ObjectId
                                                 AND ObjectLink_Partner.DescId        = zc_ObjectLink_ReceiptService_Partner()
                                                 AND ObjectLink_Partner.ChildObjectId > 0
                     WHERE MovementItem.MovementId = vbMovementId AND MovementItem.DescId = zc_MI_Detail() AND MovementItem.isErased = FALSE
                    );
     -- ��������� ����� � <��������� �����>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Partner(), vbMovementId, vbPartnerId);

     -- % ���
     vbVATPercent:= (SELECT ObjectFloat_TaxKind_Value.ValueData AS TaxKind_Value
                     FROM ObjectLink AS ObjectLink_TaxKind
                          INNER JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                                 ON ObjectFloat_TaxKind_Value.ObjectId = ObjectLink_TaxKind.ChildObjectId
                                                AND ObjectFloat_TaxKind_Value.DescId = zc_ObjectFloat_TaxKind_Value()
                     WHERE ObjectLink_TaxKind.ObjectId = vbPartnerId
                       AND ObjectLink_TaxKind.DescId   = zc_ObjectLink_Partner_TaxKind()
                    );
     -- ��������� <% ���>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_VATPercent(), vbMovementId, COALESCE (vbVATPercent, 0));

     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (vbMovementId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 23.12.22         *
*/

-- ����
--