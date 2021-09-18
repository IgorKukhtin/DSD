-- Function: gpInsertUpdate_MovementItem_Income()


DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Income (Integer, Integer, Integer, TDateTime, Integer, Integer
                                                          , TFloat, TFloat, TFloat, TFloat, TFloat
                                                          , Integer, Integer, Integer, Integer, Integer, Integer
                                                          , TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Income(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>  
    --IN inFromId              Integer   , -- 
    --IN inToId                Integer   , -- 
    --IN inOperDate            TDateTime , --
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
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbOperPriceList_old TFloat;
   DECLARE vbFromId Integer;
   DECLARE vbToId Integer;
   DECLARE vbOperDate TDateTime;
   DECLARE vbTaxKindId Integer;
   DECLARE vbTaxKindValue TFloat;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
     vbUserId := lpGetUserBySession (inSession);

     -- �� �����
     SELECT Movement.OperDate
          , MovementLinkObject_To.ObjectId     AS ToId
          , MovementLinkObject_From.ObjectId   AS FromId
          , OF_TaxKind_Value.ObjectId          AS TaxKindId
          , MovementFloat_VATPercent.ValueData AS TaxKindValue
            INTO vbOperDate, vbToId, vbFromId, vbTaxKindId, vbTaxKindValue
     FROM Movement
      LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                   ON MovementLinkObject_To.MovementId = Movement.Id
                                  AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
      LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                   ON MovementLinkObject_From.MovementId = Movement.Id
                                  AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
      LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                              ON MovementFloat_VATPercent.MovementId = Movement.Id
                             AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
      LEFT JOIN ObjectFloat AS OF_TaxKind_Value
                            ON OF_TaxKind_Value.ValueData = MovementFloat_VATPercent.ValueData
                           AND OF_TaxKind_Value.DescId = zc_ObjectFloat_TaxKind_Value()
     WHERE Movement.Id = inMovementId
    ;

     --�������� ���� �� ����� TaxKindId - �������� ������
     IF COALESCE (vbTaxKindId,0) = 0 
     THEN
         RAISE EXCEPTION '������.�� ��������� ��� ���.';
     END IF;
     
     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     IF COALESCE (ioId, 0) <> 0
     THEN
         vbOperPriceList_old:= (SELECT Object_PartionGoods.OperPriceList FROM Object_PartionGoods WHERE Object_PartionGoods.MovementItemId = ioId);
     ELSE
         vbOperPriceList_old := inOperPriceList;
     END IF;
     
     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem_Income (ioId         ::Integer
                                               , inMovementId ::Integer
                                               , inGoodsId    ::Integer
                                               , inAmount     ::TFloat
                                               , inOperPrice  ::TFloat
                                               , inCountForPrice ::TFloat
                                               , inPartNumber ::TVarChar
                                               , inComment    ::TVarChar
                                               , vbUserId     ::Integer
                                               );

     -- ��������� ������
     PERFORM lpInsertUpdate_Object_PartionGoods (inMovementItemId    := ioId                 ::Integer       -- ���� ������
                                               , inMovementId        := inMovementId         ::Integer       -- ���� ���������
                                               , inFromId            := vbFromId             ::Integer       -- ��������� ��� ������������� (����� ������)
                                               , inUnitId            := vbToId               ::Integer       -- �������������(�������)
                                               , inOperDate          := vbOperDate           ::TDateTime     -- ���� �������
                                               , inObjectId          := inGoodsId            ::Integer       -- ������������� ��� �����
                                               , inAmount            := inAmount             ::TFloat        -- ���-�� ������
                                               , inEKPrice           := inOperPrice          ::TFloat        -- ���� ��. ��� ���, ???� ������ ������???
                                               , inCountForPrice     := inCountForPrice      ::TFloat        -- ���� �� ����������
                                               , inEmpfPrice         := inEmpfPrice          ::TFloat        -- ���� ��������. ��� ���
                                               , inOperPriceList     := inOperPriceList      ::TFloat        -- ���� �������, !!!���!!!
                                               , inOperPriceList_old := vbOperPriceList_old  ::TFloat        -- ���� �������, �� ��������� ������
                                               , inGoodsGroupId      := inGoodsGroupId       ::Integer       -- ������ ������
                                               , inGoodsTagId        := inGoodsTagId         ::Integer       -- ���������
                                               , inGoodsTypeId       := inGoodsTypeId        ::Integer       -- ��� ������ 
                                               , inGoodsSizeId       := inGoodsSizeId        ::Integer       -- ������
                                               , inProdColorId       := inProdColorId        ::Integer       -- ����
                                               , inMeasureId         := inMeasureId          ::Integer       -- ������� ���������
                                               , inTaxKindId         := vbTaxKindId          ::Integer       -- ��� ��� (!������������!)
                                               , inTaxKindValue      := vbTaxKindValue       ::TFloat        -- �������� ��� (!������������!)
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