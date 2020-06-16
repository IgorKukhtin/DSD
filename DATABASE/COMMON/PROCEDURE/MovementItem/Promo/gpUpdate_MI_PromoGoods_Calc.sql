-- Function: gpUpdate_MI_PromoGoods_Calc()
DROP FUNCTION IF EXISTS gpUpdate_MI_PromoGoods_Calc (Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);
--DROP FUNCTION IF EXISTS gpUpdate_MI_PromoGoods_Calc (Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_MI_PromoGoods_Calc (Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_MI_PromoGoods_Calc (Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_MI_PromoGoods_Calc (Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_PromoGoods_Calc(
    IN inId                       Integer   , -- ���� ������� <������� ���������>
    IN inMovementId               Integer   , -- ��������
    IN inPriceIn                  TFloat    , -- ���-�� ����, ���/��
    IN inNum                      TFloat    , -- ����� ������
    IN inAmountSale               TFloat    , --
    IN inSummaSale                TFloat    , -- 
    IN inContractCondition        TVarChar    , -- �����
    IN inTaxRetIn                 TVarChar    , -- % �������
    IN inTaxPromo                 TVarChar    , -- % ������, �����������
    IN inisTaxPromo               Boolean   , -- 
   --OUT outSummaProfit             TFloat    , --����� �������
    IN inSession                  TVarChar    -- ������ ������������
)
RETURNS  void
AS 
$BODY$ 
   DECLARE vbUserId Integer;
   DECLARE vbTaxPromo TFloat;
   DECLARE vbGoodsId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := CASE WHEN inSession = '-12345' THEN inSession :: Integer ELSE lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Promo()) END;

    vbTaxPromo := (REPLACE(REPLACE ('15,33 %', '%', ''), ',', '.')) :: TFloat;
    vbGoodsId  := (SELECT MovementItem.ObjectId FROM MovementItem WHERE MovementItem.Id = inId);
    
    -- ��������� ������������ �����/��� ������
    IF inNum IN (3)
    THEN
        RAISE EXCEPTION '������. ������ � <%> �� �������������' , zfConvert_FloatToString (inNum);
    END IF;
    
    -- ���� %
    IF inNum = 1
    THEN
        -- ��������� % �������
        PERFORM -- ��������� % �������
                lpInsertUpdate_MovementItemFloat (zc_MIFloat_TaxRetIn(), MovementItem.Id, zfConvert_StringToFloat(TRIM (REPLACE (REPLACE (inTaxRetIn, '%', ''), ',', '.'))))
               -- ��������� % �����
              , lpInsertUpdate_MovementItemFloat (zc_MIFloat_TaxPromo(), MovementItem.Id, zfConvert_StringToFloat(TRIM (REPLACE (REPLACE (inTaxPromo, '%', ''), ',', '.'))))
              -- ��������� % ������
              , lpInsertUpdate_MovementItemFloat (zc_MIFloat_ContractCondition(), MovementItem.Id, zfConvert_StringToFloat(TRIM (REPLACE (REPLACE (inContractCondition, '%', ''), ',', '.'))))
        FROM MovementItem
        WHERE MovementItem.MovementId = inMovementId
          AND MovementItem.ObjectId = vbGoodsId;
              
        --�������� ��������� - ����� �����
        IF COALESCE (vbTaxPromo,0) <> 0
        THEN
            --�������� ��������� - ����� �����
            PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_TaxPromo(), inMovementId, inisTaxPromo);  
        ELSE
            -- ���� 0
            PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_TaxPromo(), inMovementId, NULL :: Boolean);  
        END IF;
    END IF;

    IF inNum = 2
    THEN
        -- ��������� ���-�� - 2 ����, ���/��
        PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceIn2(), inId, inPriceIn);
        -- ��������� ���-�� ��������
        PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountSale(), inId, inAmountSale);        
    END IF;
    IF inNum = 4
    THEN
        -- ��������� ���-�� - 1 ����, ���/��
        PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceIn1(), inId, inPriceIn);
    END IF;
    
    


    --outSummaProfit := COALESCE (inSummaSale, 0) - (COALESCE (inPriceIn, 0) + COALESCE (inAmountRetIn, 0) + COALESCE (inContractCondition, 0)) * COALESCE (inAmountSale, 0);
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.    ��������� �.�.
 06.04.20         *
 06.08.17         *
*/