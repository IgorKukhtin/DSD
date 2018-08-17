-- Function: gpInsert_Object_PriceChange_BySend()

DROP FUNCTION IF EXISTS gpInsert_Object_PriceChange_BySend (Integer, Integer, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Object_PriceChange_BySend(
    IN inRetailId            Integer   , -- ������������� 
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inPriceChangeNew      TFloat    , -- ���� �����
 INOUT ioPriceChange         TFloat    , -- ���� ����������
   OUT outSumma              TFloat    , -- ����� � ����� ����������
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
    IF COALESCE (ioPriceChangeUnitTo, 0) <> 0 
    THEN
        RAISE EXCEPTION '������.��������� ���������� ���� ���������� ������ 0.';
    END IF;
    
    --���� ����� ���� ������ ���� > 0
    IF COALESCE (inPriceChangeNew, 0) = 0 
    THEN
        RAISE EXCEPTION '������.����� ���� ������ ���� ������ 0.';
    END IF;
    
    ioPriceChangeUnitTo := inPriceChangeNew;
        
    --����������� �����
    PERFORM lpInsertUpdate_Object_PriceChange(inGoodsId := inGoodsId,
                                        inUnitId  := inUnitId,
                                        inPriceChange   := ioPriceChangeUnitTo,
                                        inDate    := CURRENT_DATE::TDateTime,
                                        inUserId  := vbUserId);
                                        
                                            
    --��������� �����
    outSummaUnitTo := ROUND(inAmount * ioPriceChangeUnitTo, 2); 

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