-- Function: gpInsert_MovementItem_Reprice_TEST()

DROP FUNCTION IF EXISTS gpInsert_MovementItem_Reprice_TEST ();

CREATE OR REPLACE FUNCTION gpInsert_MovementItem_Reprice_TEST()
RETURNS VOID
AS
$BODY$
   DECLARE vbOperDate_StartBegin TDateTime;
BEGIN


    -- !!!�������� - ������� ��������!!!
    vbOperDate_StartBegin:= CLOCK_TIMESTAMP();


    PERFORM gpInsertUpdate_MovementItem_Reprice (ioId                  := 0 -- ���� ������
                                               , inGoodsId             := Id -- ������
                                               , inUnitId              := 6128298 -- �������������
                                               , inUnitId_Forwarding   := 0 -- �������������(��������� ��� ��������� ���)
                                               , inTax                 := 0 -- % +/-
                                               , inJuridicalId         := JuridicalId -- ���������
                                               , inContractId          := ContractId -- �������
                                               , inExpirationDate      := ExpirationDate -- ���� ��������
                                               , inMinExpirationDate   := MinExpirationDate -- ���� �������� �������
                                               , inAmount              := RemainsCount -- ���������� (�������)
                                               , inPriceOld            := 1 -- ���� ������
                                               , inPriceNew            := 2 -- ���� �����
                                               , inJuridical_Price     := 3 -- ���� ����������
                                               , inJuridical_Percent   := 1 -- % ������������� ������� ����������
                                               , inContract_Percent    := 1 -- % ������������� ������� ��������
                                               , inGUID                := '123'  -- GUID ��� ����������� ������� ����������
                                               , inSession             := '3'  -- ������ ������������
                                                )
    FROM gpSelect_AllGoodsPrice (inUnitId := 6128298 , inUnitId_to := 0 , inMinPercent := 0 , inVAT20 := 'True' , inTaxTo := 0 , inPriceMaxTo := 0 ,  inSession := '3')
      AS tmp;

    RAISE EXCEPTION ' %  %', vbOperDate_StartBegin, CLOCK_TIMESTAMP();

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.    ��������� �.�.
 18.02.16         *
 27.11.15                                                                       *
*/
-- SELECT COUNT(*) FROM Log_Reprice
-- SELECT * FROM Log_Reprice WHERE TextValue NOT LIKE '%InsertUpdate%' ORDER BY Id DESC LIMIT 100
-- SELECT * FROM Log_Reprice ORDER BY Id DESC LIMIT 100
-- SELECT * FROM gpInsert_MovementItem_Reprice_TEST()
