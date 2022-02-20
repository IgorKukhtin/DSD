-- Function: lpInsertUpdate_MovementItem_PriceList()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PriceList (Integer, Integer, Integer, Integer, Integer, Integer
                                                             , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Boolean, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_PriceList(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inDiscountPartnerId    Integer   , -- 
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
    IN inUserId              Integer     -- ������ ������������
)
RETURNS Integer AS
$BODY$
BEGIN

     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, NULL, inMovementId, inAmount, NULL,inUserId);

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MeasureMult(), ioId, inMeasureMult);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceParent(), ioId, inPriceParent);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_EmpfPriceParent(), ioId, inEmpfPriceParent);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MinCount(), ioId, inMinCount);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MinCountMult(), ioId, inMinCountMult);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightParent(), ioId, inWeightParent);

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_CatalogPage(), ioId, inCatalogPage);
     
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_Outlet(), ioId, inisOutlet);

     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_DiscountPartner(), ioId, inDiscountPartnerId);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Measure(), ioId, inMeasureId);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_MeasureParent(), ioId, inMeasureParentId);



     -- ��������� ��������
     -- PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId);

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