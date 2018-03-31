-- Function: gpUpdate_MI_TaxCorrective_NPP()

DROP FUNCTION IF EXISTS gpUpdate_MI_TaxCorrective_NPP (Integer, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_TaxCorrective_NPP(
    IN inId                   Integer   , -- ���� ������� <������� ���������>
    IN inLineNumTaxCorr_calc  TFloat    , -- � �/� ��-����.(�����.)
    IN inLineNumTaxCorr       TFloat    , -- � �/� ��-����.
    IN inAmountTax_calc       TFloat    , -- ���-�� ��� ��-����.(�����.)
    IN inSession              TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_MI_TaxCorrective_NPP());

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_NPPTax_calc(), inId, inLineNumTaxCorr_calc);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_NPP_calc(), inId, inLineNumTaxCorr);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountTax_calc(), inId, inAmountTax_calc);

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 30.03.18         *
*/

-- ����
--