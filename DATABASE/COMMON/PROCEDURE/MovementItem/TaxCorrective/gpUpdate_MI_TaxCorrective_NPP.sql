-- Function: gpUpdate_MI_TaxCorrective_NPP()

DROP FUNCTION IF EXISTS gpUpdate_MI_TaxCorrective_NPP (Integer, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_MI_TaxCorrective_NPP (Integer, TFloat, TFloat, TFloat, TFloat, TVarChar);
--DROP FUNCTION IF EXISTS gpUpdate_MI_TaxCorrective_NPP (Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_MI_TaxCorrective_NPP (Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_TaxCorrective_NPP(
    IN inId                   Integer   , -- ���� ������� <������� ���������>
    IN inLineNumTaxCorr_calc  TFloat    , -- � �/� ��-����.(�����.)
    IN inLineNumTaxCorr       TFloat    , -- � �/� ��-����.
    IN inLineNumTaxNew        TFloat    , -- � �/� ����. �.
    IN inAmountTax_calc       TFloat    , -- ���-�� ��� ��-����.(�����.)
    IN inSummTaxDiff_calc     TFloat    , -- ����� ������������� ��� ��-����.(�����.) 
    IN inPriceTax_calc        TFloat    , -- ���� ��� ��-����.����(�����.)
    IN inSession              TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_MI_TaxCorrective_NPP());
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_TaxCorrective());


     -- �������� - ������
     IF EXISTS (SELECT 1
                FROM MovementItem
                     INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                        AND Movement.StatusId <> zc_Enum_Status_UnComplete()
                WHERE MovementItem.Id = inId
               )
     THEN
         RAISE EXCEPTION '������.��������� ��������� � <%> � ������� <%> �� ��������.'
                       , (SELECT Movement.InvNumber
                          FROM MovementItem
                               INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                  AND Movement.StatusId <> zc_Enum_Status_UnComplete()
                          WHERE MovementItem.Id = inId
                         )
                       , lfGet_Object_ValueData ((SELECT Movement.StatusId
                                                  FROM MovementItem
                                                       INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                                          AND Movement.StatusId <> zc_Enum_Status_UnComplete()
                                                  WHERE MovementItem.Id = inId
                                                ))
         ;
     END IF;


     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_NPPTax_calc(), inId, inLineNumTaxCorr_calc);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_NPP_calc(), inId, inLineNumTaxCorr);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountTax_calc(), inId, inAmountTax_calc);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummTaxDiff_calc(), inId, inSummTaxDiff_calc);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceTax_calc(), inId, inPriceTax_calc);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_NPPTaxNew_calc(), inId, inLineNumTaxNew);

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 27.03.20         * add inLineNumTaxNew
 12.04.18         * add PriceTax_calc
 04.04.18         * add inSummTaxDiff_calc
 30.03.18         *
*/

-- ����
--