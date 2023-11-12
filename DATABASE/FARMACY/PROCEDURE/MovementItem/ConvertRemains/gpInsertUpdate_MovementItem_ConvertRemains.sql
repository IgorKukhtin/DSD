-- Function: gpInsert_MovementItem_ConvertRemains()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ConvertRemains (Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_ConvertRemains(
 INOUT ioId                     Integer   ,    -- ���� ������� <������� ���������>
    IN inMovementId             Integer   ,    -- ������������� ���������
    IN inGoodsId                Integer   ,    -- �����

    IN inAmount                 TFloat    ,    -- ����������

    IN inPriceWithVAT           TFloat    ,    -- ���� � ������ ���
    IN inVAT                    TFloat    ,    -- ���

    IN inMeasure                TVarChar  ,    -- ������� ���������

    IN inComment                TVarChar  ,    -- �����������

    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbOperDate_StartBegin TDateTime;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := inSession;

    -- ��������� ������
    PERFORM lpInsertUpdate_MovementItem_ConvertRemains (ioId                  := COALESCE(ioId, 0)
                                                      , inMovementId          := inMovementId
                                                      , inGoodsId             := inGoodsId
                                                      , inAmount              := inAmount
                                                      , inPriceWithVAT        := inPriceWithVAT
                                                      , inVAT                 := inVAT
                                                      , inMeasure             := inMeasure
                                                      , inComment             := inComment
                                                      , inUserId              := vbUserId);

     -- ����������� �������� �����
     PERFORM gpInsertUpdate_ConvertRemains_TotalSumm (ioId, inSession);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 25.10.2023                                                     *
*/
-- select * from gpInsertUpdate_MovementItem_ConvertRemains(ioId := 514496660 , inMovementId := 27854839 , inGoodsId := 0 , inIntenalSPId := 19717536 , inBrandSPId := 19717553 , inKindOutSP_1303Id := 19717556 , inDosage_1303Id := 19717557 , inCountSP_1303Id := 19709040 , inMakerSP_1303Id := 19715021 , inCountry_1303Id := 19710413 , inCodeATX := 'J06BA01' , inReestrSP := 'UA/17277/01/01' , inReestrDateSP := ('22.02.2019')::TDateTime , inValiditySP := ('22.02.2024')::TDateTime , inPriceOptSP := 8744.31 , inCurrencyId := 19698853 , inExchangeRate := 33.7553 , inOrderNumberSP := 2841 , inOrderDateSP := ('09.12.2020')::TDateTime , inID_MED_FORM := 306189 , inMorionSP := 0 ,  inSession := '3');