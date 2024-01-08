-- Function: gpInsertUpdate_MovementItem_Income()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Income (Integer, Integer, Integer
                                                          , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                          , TVarChar, TVarChar, TVarChar
                                                           );
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Income (Integer, Integer, Integer
                                                          , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                          , TVarChar, TVarChar, TVarChar, TVarChar
                                                           );

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Income(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inOperPrice_orig      TFloat    , -- ��. ���� ��� ������
    IN inCountForPrice       TFloat    , -- ���� �� ���.
 INOUT ioDiscountTax         TFloat    , -- % ������
 INOUT ioOperPrice           TFloat    , -- ��. ���� � ������ ������ � ��������
 INOUT ioSummIn              TFloat    , -- ����� ��. � ������ ������
    IN inAmount_old          TFloat    , --
    IN inOperPrice_orig_old  TFloat    , --
    IN inDiscountTax_old     TFloat    , --
    IN inOperPrice_old       TFloat    , --
    IN inSummIn_old          TFloat    , --
    IN inOperPriceList       TFloat    , -- ���� �������
    IN inEmpfPrice           TFloat    , -- ���� ���������������
    IN inPartNumber          TVarChar  , -- � �� ��� ��������
 INOUT ioPartionCellName     TVarChar  , -- ��� ��� ��������
    IN inComment             TVarChar  , --
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId            Integer;
   DECLARE vbIsInsert          Boolean;
   DECLARE vbOperPriceList_old TFloat;

   DECLARE vbFromId       Integer;
   DECLARE vbToId         Integer;
   DECLARE vbOperDate     TDateTime;
   DECLARE vbTaxKindId    Integer;
   DECLARE vbTaxKindValue TFloat;   
   
   DECLARE vbPartionCellId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
     vbUserId := lpGetUserBySession (inSession);

     -- �� �����
     SELECT Movement.OperDate
          , MovementLinkObject_From.ObjectId   AS FromId
          , MovementLinkObject_To.ObjectId     AS ToId
          , OL_Partner_TaxKind.ChildObjectId   AS TaxKindId
          , MovementFloat_VATPercent.ValueData AS TaxKindValue
            INTO vbOperDate, vbFromId, vbToId, vbTaxKindId, vbTaxKindValue
     FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                  ON MovementFloat_VATPercent.MovementId = Movement.Id
                                 AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
          LEFT JOIN ObjectLink AS OL_Partner_TaxKind
                               ON OL_Partner_TaxKind.ObjectId = MovementLinkObject_From.ObjectId
                              AND OL_Partner_TaxKind.DescId   = zc_ObjectLink_Partner_TaxKind()
     WHERE Movement.Id = inMovementId
    ;
    
     vbTaxKindId:= CASE WHEN vbTaxKindId > 0 THEN vbTaxKindId ELSE zc_Enum_TaxKind_Basis() END;

     -- �������� ���� �� ����� TaxKindId - �������� ������
     IF COALESCE (vbTaxKindId,0) = 0
     THEN
         RAISE EXCEPTION '������.�� ��������� ��� ���.';
     END IF;
      
     -- �����
     IF COALESCE (ioId, 0) <> 0
     THEN
         vbOperPriceList_old:= (SELECT Object_PartionGoods.OperPriceList FROM Object_PartionGoods WHERE Object_PartionGoods.MovementItemId = ioId);
     ELSE
         vbOperPriceList_old := inOperPriceList;
     END IF;

     --������� ������ ��������, ���� ��� ����� �������
     IF COALESCE (ioPartionCellName, '') <> '' THEN
         -- !!!����� �� !!! 
         --���� ����� ��� ���� �� ����, ����� �� ��������
         IF zfConvert_StringToNumber (ioPartionCellName) <> 0
         THEN
             vbPartionCellId:= (SELECT Object.Id
                                FROM Object
                                WHERE Object.ObjectCode = zfConvert_StringToNumber (ioPartionCellName)
                                  AND Object.DescId     = zc_Object_PartionCell()
                               );
             --���� �� ����� ������
             IF COALESCE (vbPartionCellId,0) = 0
             THEN
                 RAISE EXCEPTION '������.�� ������� ������ � ����� <%>.', ioPartionCellName;
             END IF;
         ELSE
             vbPartionCellId:= (SELECT Object.Id
                                FROM Object
                                WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (ioPartionCellName))
                                  AND Object.DescId     = zc_Object_PartionCell()
                               );
             --���� �� ����� �������
             IF COALESCE (vbPartionCellId,0) = 0
             THEN
                 --
                 vbPartionCellId := gpInsertUpdate_Object_PartionCell (ioId	     := 0                                            ::Integer
                                                                     , inCode    := lfGet_ObjectCode(0, zc_Object_PartionCell()) ::Integer
                                                                     , inName    := TRIM (ioPartionCellName)                          ::TVarChar
                                                                     , inLevel   := 0           ::TFloat
                                                                     , inComment := ''          ::TVarChar
                                                                     , inSession := inSession   ::TVarChar
                                                                      );
    
             END IF;
         END IF;
         --
         ioPartionCellName := (SELECT Object.ValueData FROM Object WHERE Object.Id = vbPartionCellId); 
     ELSE 
         vbPartionCellId := NULL ::Integer;
     END IF;


     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem_Income (ioId
                                               , inMovementId
                                               , inGoodsId
                                               , inAmount
                                               , inOperPriceList
                                               , inPartNumber
                                               , inComment
                                               , vbPartionCellId
                                               , vbUserId
                                                );

     -- ��������� <������� ����>
     SELECT lpUpdate.ioDiscountTax, lpUpdate.ioOperPrice, lpUpdate.ioSummIn
            INTO ioDiscountTax, ioOperPrice, ioSummIn
     FROM lpUpdate_MI_Income_Price (ioId
                                  , inAmount
                                  , inOperPrice_orig
                                  , inCountForPrice
                                  , ioDiscountTax
                                  , ioOperPrice
                                  , ioSummIn
                                  , inAmount_old
                                  , inOperPrice_orig_old
                                  , inDiscountTax_old
                                  , inOperPrice_old
                                  , inSummIn_old
                                  , vbUserId
                                   ) AS lpUpdate;
     -- ��������� ������
     PERFORM lpInsertUpdate_Object_PartionGoods (inMovementItemId    := ioId                    -- ���� ������
                                               , inMovementId        := inMovementId            -- ���� ���������
                                               , inFromId            := vbFromId                -- ��������� ��� ������������� (����� ������)
                                               , inUnitId            := vbToId                  -- �������������(�������)
                                               , inOperDate          := vbOperDate              -- ���� �������
                                               , inObjectId          := inGoodsId               -- ������������� ��� �����
                                               , inAmount            := inAmount                -- ���-�� ������
                                                 --
                                               , inEKPrice           := ioOperPrice             -- ���� ��. ��� ���, � ������ ���� ������ + ������� + �������: �������� + �������� + ��������� = inEKPrice_discount + inCostPrice
                                               , inEKPrice_orig      := ioOperPrice             -- ���� ��. ��� ���, � ������ ������ ������ �� ��������
                                               , inEKPrice_discount  := ioOperPrice             -- ���� ��. ��� ���, � ������ ���� ������ (������ ����� ���)
                                               , inCostPrice         := 0                       -- ���� ������ ��� ��� (������� + �������: �������� + �������� + ���������)
                                               , inCountForPrice     := inCountForPrice         -- ���� �� ����������
                                                 --
                                               , inEmpfPrice         := inEmpfPrice             -- ���� ��������. ��� ���
                                               , inOperPriceList     := inOperPriceList         -- ���� �������
                                               , inOperPriceList_old := vbOperPriceList_old     -- ���� �������, �� ��������� ������
                                                 --
                                               , inTaxKindId         := vbTaxKindId             -- ��� ��� (!������������!)
                                               , inTaxKindValue      := vbTaxKindValue          -- �������� ��� (!������������!)
                                               , inUserId            := vbUserId                --
                                                );

     -- �������� ������
     UPDATE MovementItem SET PartionId = ioId WHERE MovementItem.Id = ioId AND PartionId IS NULL;

  
     -- �� ���� ������� ��������� OperPriceList
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPriceList(), MovementItem.Id, inOperPriceList)
     FROM MovementItem
          LEFT JOIN MovementItemFloat AS MIF ON MIF.MovementItemId = MovementItem.Id AND MIF.DescId = zc_MIFloat_OperPriceList()
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId     = zc_MI_Master()
       AND MovementItem.ObjectId   = inGoodsId
       AND MovementItem.Id         <> ioId
       AND COALESCE (MIF.ValueData, 0) <> inOperPriceList
     ;

     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

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