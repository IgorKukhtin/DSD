-- Function: gpInsertUpdate_MovementItem_Income()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Income(Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Income(Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Income(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>  
    IN inFromId              Integer   , -- 
    IN inToId                Integer   , -- 
    IN inOperDate            TDateTime , --
    IN inPartionId           Integer   , -- ������
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inEmpfPrice           TFloat    , -- ���� ��������������� ��� ��� �������
    IN inOperPrice           TFloat    , -- ���� �������
    IN inOperPriceList       TFloat    , -- ���� �������
    IN inCountForPrice       TFloat    , -- ���� �� ���.
    IN inTaxKindValue        TFloat    , -- �������� ��� (!������������!)
    IN inGoodsGroupId        Integer   , -- ������ ������
    IN inGoodsTagId          Integer   , -- ���������
    IN inGoodsTypeId         Integer   , -- ��� ������ 
    IN inGoodsSizeId         Integer   , -- ������
    IN inProdColorId         Integer   , -- ����
    IN inMeasureId           Integer   , -- ������� ���������
    IN inTaxKindId           Integer   , -- ��� ��� (!������������!)                                            
    IN inPartNumber          TVarChar  , --� �� ��� ��������
    IN inComment             TVarChar  , --
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbOperPriceList_old TFloat;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
     vbUserId := lpGetUserBySession (inSession);


     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     IF COALESCE (ioId, 0) <> 0
     THEN
         vbOperPriceList_old:= (SELECT Object_PartionGoods.OperPriceList FROM Object_PartionGoods WHERE Object_PartionGoods.MovementItemId = ioId)::TFloat;
     ELSE
         vbOperPriceList_old := inOperPriceList;
     END IF;
     
     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem_Income (ioId         ::Integer
                                               , inMovementId ::Integer
                                               , inPartionId  ::Integer
                                               , inGoodsId    ::Integer
                                               , inAmount     ::TFloat
                                               , inOperPrice  ::TFloat
                                               , inCountForPrice ::TFloat
                                               , inPartNumber ::TVarChar
                                               , inComment    ::TVarChar
                                               , vbUserId     ::Integer
                                               );

     --��������� ������
     inPartionId := lpInsertUpdate_Object_PartionGoods(inMovementItemId    := ioId                 ::Integer       -- ���� ������
                                                     , inMovementId        := inMovementId         ::Integer       -- ���� ���������
                                                     , inFromId            := inFromId             ::Integer       -- ��������� ��� ������������� (����� ������)
                                                     , inUnitId            := inToId               ::Integer       -- �������������(�������)
                                                     , inOperDate          := inOperDate           ::TDateTime     -- ���� �������
                                                     , inObjectId          := inGoodsId            ::Integer       -- ������������� ��� �����
                                                     , inAmount            := inAmount             ::TFloat        -- ���-�� ������
                                                     , inEKPrice           := inOperPrice          ::TFloat        -- ���� ��. ��� ���
                                                     , inCountForPrice     := COALESCE (inCountForPrice, 1)  ::TFloat  -- ���� �� ����������
                                                     , inEmpfPrice         := inEmpfPrice          ::TFloat        -- ���� ��������. ��� ���
                                                     , inOperPriceList     := inOperPriceList      ::TFloat        -- ���� �������, !!!���!!!
                                                     , inOperPriceList_old := vbOperPriceList_old  ::TFloat        -- ���� �������, �� ��������� ������
                                                     , inGoodsGroupId      := inGoodsGroupId       ::Integer       -- ������ ������
                                                     , inGoodsTagId        := inGoodsTagId         ::Integer       -- ���������
                                                     , inGoodsTypeId       := inGoodsTypeId        ::Integer       -- ��� ������ 
                                                     , inGoodsSizeId       := inGoodsSizeId        ::Integer       -- ������
                                                     , inProdColorId       := inProdColorId        ::Integer       -- ����
                                                     , inMeasureId         := inMeasureId          ::Integer       -- ������� ���������
                                                     , inTaxKindId         := inTaxKindId          ::Integer       -- ��� ��� (!������������!)
                                                     , inTaxKindValue      := inTaxKindValue       ::TFloat        -- �������� ��� (!������������!)
                                                     , inUserId            := vbUserId             ::Integer       --
                                                 );

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 08.02.21         *
*/

-- ����
-- 