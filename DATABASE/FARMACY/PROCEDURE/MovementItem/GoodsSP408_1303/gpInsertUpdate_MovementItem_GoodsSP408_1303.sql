-- Function: gpInsert_MovementItem_GoodsSP408_1303()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_GoodsSP408_1303 (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                                   , TVarChar, TVarChar, TDateTime, TFloat, Integer, TFloat, Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_GoodsSP408_1303(
 INOUT ioId                     Integer   , -- ���� ������
    IN inMovementId             Integer   ,    -- ������������� ���������
    IN inGoodsId                Integer   ,    -- �����

    IN inCol                    Integer   ,    -- ����� �� �������

    IN inIntenalSP_1303Id       Integer   ,    -- ̳�������� ������������� ��� ���������������� ����� ���������� ������ (1)
    IN inBrandSPId              Integer   ,    -- ����������� ����� ���������� ������ (2)

    IN inKindOutSP_1303Id       Integer   ,    -- ����� ������� (3)
    IN inDosage_1303Id          Integer   ,    -- ��������� (���. ������)(4)
    IN inCountSP_1303Id         Integer   ,    -- ʳ������ ������� ���������� ������ � ��������� �������� (5)
    IN inMakerCountrySP_1303Id  Integer   ,    -- ������������ ���������, ����� (6)

    IN inCodeATX                TVarChar  ,    -- ��� ��� (7)
    IN inReestrSP               TVarChar  ,    -- ����� ������������� ���������� �� ��������� ���� (8)
    IN inValiditySP             TDateTime ,    -- ���� ��������� ������ 䳿 ������������� ���������� �� ��������� ���� (9)

    IN inPriceOptSP             TFloat    ,    -- ������������� ������-�������� ���� (���.)(���. ������)(10)
    IN inCurrencyId             Integer   ,    -- ������ (���. ������)(11)
    IN inExchangeRate           TFloat    ,    -- ��������� ����,������������ ������������ ������ ������ �� ���� ������� ���������� ���� ������-�������� ����(���. ������)(11)

    IN inOrderNumberSP          Integer   ,    -- � �����, � ����� ������� ��(���. ������)(12)
    IN inOrderDateSP            TDateTime ,    -- ���� ������, � ����� ������� ��(���. ������)(12)
    
   OUT outPriceOOC              TFloat    ,    -- 
   OUT outPriceSale             TFloat    ,    -- ����. ����

    IN inSession                TVarChar    -- ������ ������������
)
RETURNS Record
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbOperDate_StartBegin TDateTime;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := inSession;

    -- ��������� ������
    PERFORM lpInsertUpdate_MovementItem_GoodsSP408_1303 (ioId                    := COALESCE(ioId, 0)
                                                       , inMovementId            := inMovementId
                                                       , inGoodsId               := inGoodsId
                                                       , inCol                   := inCol
                                                       , inIntenalSP_1303Id      := inIntenalSP_1303Id
                                                       , inBrandSPId             := inBrandSPId
                                                       , inKindOutSP_1303Id      := inKindOutSP_1303Id
                                                       , inDosage_1303Id         := inDosage_1303Id
                                                       , inCountSP_1303Id        := inCountSP_1303Id
                                                       , inMakerCountrySP_1303Id := inMakerCountrySP_1303Id
                                                       , inCodeATX               := TRIM(inCodeATX)::TVarChar
                                                       , inReestrSP              := TRIM(inReestrSP)::TVarChar
                                                       , inValiditySP            := inValiditySP                                                            
                                                       , inPriceOptSP            := COALESCE (inPriceOptSP, 0) :: TFloat
                                                       , inCurrencyId            := inCurrencyId
                                                       , inExchangeRate          := COALESCE (inExchangeRate, 0) :: TFloat
                                                       , inOrderNumberSP         := inOrderNumberSP
                                                       , inOrderDateSP           := inOrderDateSP
                                                       , inUserId                := vbUserId);
                                                       
                                                       
    WITH 
        tmpNDSKind AS (SELECT ObjectFloat_NDSKind_NDS.ObjectId
                            , ObjectFloat_NDSKind_NDS.ValueData
                       FROM ObjectFloat AS ObjectFloat_NDSKind_NDS
                       WHERE ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS())
      , tmpMovementItem AS ( SELECT MovementItem.Id

                                  , MovementItem.ObjectId

                                  , MovementItem.Amount::Integer                          AS Col

                                  , MIFloat_PriceOptSP.ValueData                          AS PriceOptSP
                                  , MIFloat_ExchangeRate.ValueData                        AS ExchangeRate
                                  , MIFloat_OrderNumberSP.ValueData::Integer              AS OrderNumberSP

                                  , MIDate_OrderDateSP.ValueData                          AS OrderDateSP
                                  , MIDate_ValiditySP.ValueData                           AS ValiditySP

                                  , ROW_NUMBER() OVER (PARTITION BY MovementItem.ObjectId ORDER BY MIDate_OrderDateSP.ValueData DESC) AS Ord
                                  , COALESCE (MovementItem.isErased, FALSE)    ::Boolean  AS isErased
                              FROM MovementItem
                       
                                   LEFT JOIN MovementItemFloat AS MIFloat_OrderNumberSP
                                                               ON MIFloat_OrderNumberSP.MovementItemId = MovementItem.Id
                                                              AND MIFloat_OrderNumberSP.DescId = zc_MIFloat_OrderNumberSP()  
                                   LEFT JOIN MovementItemFloat AS MIFloat_PriceOptSP
                                                               ON MIFloat_PriceOptSP.MovementItemId = MovementItem.Id
                                                              AND MIFloat_PriceOptSP.DescId = zc_MIFloat_PriceOptSP()
                                   LEFT JOIN MovementItemFloat AS MIFloat_ExchangeRate
                                                               ON MIFloat_ExchangeRate.MovementItemId = MovementItem.Id
                                                              AND MIFloat_ExchangeRate.DescId = zc_MIFloat_ExchangeRate()

                                   LEFT JOIN MovementItemDate AS MIDate_OrderDateSP
                                                              ON MIDate_OrderDateSP.MovementItemId = MovementItem.Id
                                                             AND MIDate_OrderDateSP.DescId = zc_MIDate_OrderDateSP()
                                   LEFT JOIN MovementItemDate AS MIDate_ValiditySP
                                                              ON MIDate_ValiditySP.MovementItemId = MovementItem.Id
                                                             AND MIDate_ValiditySP.DescId = zc_MIDate_ValiditySP()

                               WHERE MovementItem.DescId = zc_MI_Master()
                                 AND MovementItem.MovementId = inMovementId
                                 AND MovementItem.Id = ioId)

        SELECT CASE WHEN COALESCE (MovementItem.ObjectId, 0) > 0 
                    THEN ROUND(MovementItem.PriceOptSP  * 
                        (100.0 + COALESCE (ObjectFloat_NDSKind_NDS.ValueData, 0)) / 100.0 * 1.1, 2) END::TFloat AS PriceOOC
             , CASE WHEN COALESCE (MovementItem.ObjectId, 0) > 0 
                    THEN ROUND(MovementItem.PriceOptSP  * 
                        (100.0 + COALESCE (ObjectFloat_NDSKind_NDS.ValueData, 0)) / 100.0 * 1.1 * 1.1, 2) END::TFloat AS PriceSale
        INTO outPriceOOC
           , outPriceSale       
        FROM tmpMovementItem AS MovementItem
 
             LEFT JOIN Object_Goods_Main AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId 

             LEFT JOIN tmpNDSKind AS ObjectFloat_NDSKind_NDS
                                  ON ObjectFloat_NDSKind_NDS.ObjectId = Object_Goods.NDSKindId
         ;
                                                       

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 11.04.23                                                       *
*/
-- select * from gpInsertUpdate_MovementItem_GoodsSP408_1303(ioId := 514496660 , inMovementId := 27854839 , inGoodsId := 0 , inIntenalSPId := 19717536 , inBrandSPId := 19717553 , inKindOutSP_1303Id := 19717556 , inDosage_1303Id := 19717557 , inCountSP_1303Id := 19709040 , inMakerSP_1303Id := 19715021 , inCountry_1303Id := 19710413 , inCodeATX := 'J06BA01' , inReestrSP := 'UA/17277/01/01' , inReestrDateSP := ('22.02.2019')::TDateTime , inValiditySP := ('22.02.2024')::TDateTime , inPriceOptSP := 8744.31 , inCurrencyId := 19698853 , inExchangeRate := 33.7553 , inOrderNumberSP := 2841 , inOrderDateSP := ('09.12.2020')::TDateTime , inID_MED_FORM := 306189 , inMorionSP := 0 ,  inSession := '3');