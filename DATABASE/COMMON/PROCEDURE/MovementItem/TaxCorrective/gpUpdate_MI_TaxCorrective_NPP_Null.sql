-- Function: gpUpdate_MI_TaxCorrective_NPP_Null (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_MI_TaxCorrective_NPP_Null (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_TaxCorrective_NPP_Null(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Void
AS
$BODY$
   DECLARE vbUserId    Integer;
   DECLARE vbStatusId  Integer;
   DECLARE vbInvNumber TVarChar;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_TaxCorrective());

     -- ���������� <������>
     /*SELECT StatusId, InvNumber INTO vbStatusId, vbInvNumber FROM Movement WHERE Id = inMovementId;
     -- �������� - �����������/��������� ��������� �������� ������
     IF vbStatusId <> zc_Enum_Status_UnComplete()
     THEN
         RAISE EXCEPTION '������.��������� ��������� � <%> � ������� <%> �� ��������.', vbInvNumber, lfGet_Object_ValueData (vbStatusId);
     END IF;*/

     -- ��������
     IF  EXISTS (SELECT MovementId FROM MovementBoolean WHERE MovementId = inMovementId AND DescId = zc_MovementBoolean_Registered() AND ValueData = TRUE)
      OR EXISTS (SELECT MovementId FROM MovementBoolean WHERE MovementId = inMovementId AND DescId = zc_MovementBoolean_Electron()   AND ValueData = TRUE)
     THEN
         RAISE EXCEPTION '������.���������� ������� <����������� ��������> � <%> � <%> �� <%>.<���������> ����������.', (SELECT MovementDesc.ItemName FROM Movement JOIN MovementDesc ON MovementDesc.Id = Movement.DescId WHERE Movement.Id = inMovementId)
                                                                                                       , (SELECT InvNumber FROM Movement WHERE Id = inMovementId)
                                                                                                       , zfConvert_DateToString ((SELECT OperDate FROM Movement WHERE Id = inMovementId))
                                                                                                        ;
     END IF;

     --
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_NPPTax_calc(),      MovementItem.Id, 0)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_NPP_calc(),         MovementItem.Id, 0)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountTax_calc(),   MovementItem.Id, 0)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummTaxDiff_calc(), MovementItem.Id, 0)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceTax_calc(),    MovementItem.Id, 0)
     FROM MovementItem
          LEFT JOIN MovementItemFloat AS MIFloat_NPP_calc
                                      ON MIFloat_NPP_calc.MovementItemId = MovementItem.Id
                                     AND MIFloat_NPP_calc.DescId         = zc_MIFloat_NPP_calc()
          LEFT JOIN MovementItemFloat AS MIFloat_NPPTax_calc
                                      ON MIFloat_NPPTax_calc.MovementItemId = MovementItem.Id
                                     AND MIFloat_NPPTax_calc.DescId = zc_MIFloat_NPPTax_calc()
          LEFT JOIN MovementItemFloat AS MIFloat_AmountTax_calc
                                      ON MIFloat_AmountTax_calc.MovementItemId = MovementItem.Id
                                     AND MIFloat_AmountTax_calc.DescId = zc_MIFloat_AmountTax_calc()
          LEFT JOIN MovementItemFloat AS MIFloat_SummTaxDiff_calc
                                      ON MIFloat_SummTaxDiff_calc.MovementItemId = MovementItem.Id
                                     AND MIFloat_SummTaxDiff_calc.DescId = zc_MIFloat_SummTaxDiff_calc()
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId     = zc_MI_Master()
       -- AND MovementItem.isErased   = FALSE
         ;
 

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (MovementItem.Id, vbUserId, FALSE)
     FROM MovementItem
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId     = zc_MI_Master()
       -- AND MovementItem.isErased   = FALSE
         ;

     -- ��������� ��������
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_NPP_calc(), inMovementId, FALSE)
           , lpInsertUpdate_MovementDate    (zc_MovementDate_NPP_calc(),    inMovementId, CURRENT_TIMESTAMP);


     -- ����������� �������� ����� �� ��������� - ����������� ����� ��������� ��������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 11.04.18         *
*/
-- ����
-- SELECT * FROM gpUpdate_MI_TaxCorrective_NPP_Null (inMovementId:= 8842841, inSession:= zfCalc_UserAdmin())

--select * from gpUpdate_MI_TaxCorrective_NPP_Null(inMovementId := 5073979 ,  inSession := '5');