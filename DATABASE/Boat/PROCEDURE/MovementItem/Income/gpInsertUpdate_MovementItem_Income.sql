-- Function: gpInsertUpdate_MovementItem_Income()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Income(Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Income(Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Income(Integer, Integer, Integer, Integer, TDateTime, Integer, Integer
                                                         , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                         , Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                         , TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Income(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>  
    --IN inFromId              Integer   , -- 
    --IN inToId                Integer   , -- 
    --IN inOperDate            TDateTime , --
    IN inPartionId           Integer   , -- ������
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inEmpfPrice           TFloat    , -- ���� ��������������� ��� ��� �������
    IN inOperPrice           TFloat    , -- ���� �������
    IN inOperPriceList       TFloat    , -- ���� �������
    IN inCountForPrice       TFloat    , -- ���� �� ���.
    --IN inTaxKindValue        TFloat    , -- �������� ��� (!������������!)
    IN inGoodsGroupId        Integer   , -- ������ ������
    IN inGoodsTagId          Integer   , -- ���������
    IN inGoodsTypeId         Integer   , -- ��� ������ 
    IN inGoodsSizeId         Integer   , -- ������
    IN inProdColorId         Integer   , -- ����
    IN inMeasureId           Integer   , -- ������� ���������
    --IN inTaxKindId           Integer   , -- ��� ��� (!������������!)                                            
    IN inPartNumber          TVarChar  , --� �� ��� ��������
    IN inComment             TVarChar  , --
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbOperPriceList_old TFloat;
   DECLARE vbFromId Integer;
   DECLARE vbToId Integer;
   DECLARE vbOperDate TDateTime;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
     vbUserId := lpGetUserBySession (inSession);

     -- �� �����
     SELECT Movement.OperDate
          , MovementLinkObject_To.ObjectId   AS ToId
          , MovementLinkObject_From.ObjectId AS FromId
   INTO vbOperDate, vbToId, vbFromId
     FROM Movement
      LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                   ON MovementLinkObject_To.MovementId = Movement.Id
                                  AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
      LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                   ON MovementLinkObject_From.MovementId = Movement.Id
                                  AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
     WHERE Movement.Id = inMovementId
     ;

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
     PERFORM lpInsertUpdate_Object_PartionGoods(inMovementItemId    := ioId                 ::Integer       -- ���� ������
                                                     , inMovementId        := inMovementId         ::Integer       -- ���� ���������
                                                     , inFromId            := vbFromId             ::Integer       -- ��������� ��� ������������� (����� ������)
                                                     , inUnitId            := vbToId               ::Integer       -- �������������(�������)
                                                     , inOperDate          := vbOperDate           ::TDateTime     -- ���� �������
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