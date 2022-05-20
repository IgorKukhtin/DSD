-- Function: gpInsertUpdate_MovementItem_PriceList()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PriceList(Integer, Integer, Integer, Integer, Integer, Integer
                                                            , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_PriceList(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inDiscountPartnerId   Integer   , -- 
    IN inMeasureId           Integer   , -- 
    IN inMeasureParentId     Integer   , -- 
    IN inAmount              TFloat    , -- 
    IN inMeasureMult         TFloat    , -- 
    IN inPriceParent         TFloat    , -- 
    IN inEmpfPriceParent     TFloat    , -- 
    IN inMinCount            TFloat    , -- 
    IN inMinCountMult        TFloat    , -- 
    IN inWeightParent        TFloat    , -- 
    IN inCatalogPage         TVarChar  , --
    IN inisOutlet            Boolean   ,
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_PriceList());
     vbUserId := inSession;

     -- 
     ioId := lpInsertUpdate_MovementItem_PriceList (ioId, inMovementId, inGoodsId
                                                  , inDiscountPartnerId
                                                  , inMeasureId, inMeasureParentId
                                                  , inAmount
                                                  , inMeasureMult, inPriceParent, inEmpfPriceParent
                                                  , inMinCount, inMinCountMult, inWeightParent
                                                  , inCatalogPage
                                                  , inisOutlet
                                                  , vbUserId
                                                   );

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 19.02.22         *
*/

-- ����
--