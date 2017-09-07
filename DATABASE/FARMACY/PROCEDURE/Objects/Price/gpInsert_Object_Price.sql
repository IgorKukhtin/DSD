-- Function: gpInsert_Object_Price_BySend()

DROP FUNCTION IF EXISTS gpInsert_Object_Price_BySend (Integer, Integer, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Object_Price_BySend(
    IN inUnitId              Integer   , -- ������������� 
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inPriceNew            TFloat    , -- ���� �����
 INOUT ioPriceUnitTo         TFloat    , -- ���� ����������
   OUT outSummaUnitTo        TFloat    , -- ����� � ����� ����������
    IN inSession             TVarChar    -- ������ ������������
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Send());
    vbUserId := inSession;
    
    --���� ���� ���������� <> 0  - �������� ������ ������
    IF COALESCE (ioPriceUnitTo, 0) <> 0 
    THEN
        RAISE EXCEPTION '������.��������� ���������� ���� ���������� ������ 0.';
    END IF;
    
    --���� ����� ���� ������ ���� > 0
    IF COALESCE (inPriceNew, 0) = 0 
    THEN
        RAISE EXCEPTION '������.����� ���� ������ ���� ������ 0.';
    END IF;
    
    ioPriceUnitTo := inPriceNew;
        
    --����������� �����
    PERFORM lpInsertUpdate_Object_Price(inGoodsId := inGoodsId,
                                        inUnitId  := inUnitId,
                                        inPrice   := ioPriceUnitTo,
                                        inDate    := CURRENT_DATE::TDateTime,
                                        inUserId  := vbUserId);
                                        
                                            
    --��������� �����
    outSummaUnitTo := ROUND(inAmount * ioPriceUnitTo, 2); 

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 07.09.17         *
*/

-- ����
-- 