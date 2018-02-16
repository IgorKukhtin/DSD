-- Function: gpUpdate_MI_PromoGoods_Calc()

DROP FUNCTION IF EXISTS gpUpdate_MI_PromoGoods_Calc (Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_PromoGoods_Calc(
    IN inId                       Integer   , -- ���� ������� <������� ���������>
    IN inPriceIn                  TFloat    , -- ���-�� ����, ���/��
    IN inNum                      TFloat    , -- ����� ������
    IN inAmountPlanMax            TFloat    , --
    IN inSummaPlanMax             TFloat    , -- 
    IN inAmountRetIn              TFloat    , -- 
    IN inAmountContractCondition  TFloat    , -- 
   OUT outSummaProfit             TFloat    , --����� �������
    IN inSession                  TVarChar    -- ������ ������������
)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := CASE WHEN inSession = '-12345' THEN inSession :: Integer ELSE lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Promo()) END;


    -- ��������� ������������ �����/��� ������
    IF inNum NOT IN (2, 4)
    THEN
        RAISE EXCEPTION '������. ������ � <%> �� �������������' , zfConvert_FloatToString (inNum);
    END IF;
    
    IF inNum = 2
    THEN
        -- ��������� ���-�� - 1 ����, ���/��
        PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceIn1(), inId, inPriceIn);
    ELSE
        -- ��������� ���-�� - 2 ����, ���/��
        PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceIn2(), inId, inPriceIn);
    END IF;
    
    outSummaProfit := COALESCE (inSummaPlanMax, 0) - (COALESCE (inPriceIn, 0) + COALESCE (inAmountRetIn, 0) + COALESCE (inAmountContractCondition, 0)) * COALESCE (inAmountPlanMax, 0);
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.    ��������� �.�.
 06.08.17         *
*/