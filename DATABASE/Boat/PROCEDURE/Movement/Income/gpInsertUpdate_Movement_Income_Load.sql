--
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Income_Load (TDateTime, Integer, Integer, TVarChar, TVarChar, TVarChar, TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Income_Load(
    IN inOperDate                   TDateTime,     -- ���� ���������
    IN inPartnerCode                Integer,       -- ��� ����������
    IN inGoodsCode                  Integer,       -- ��� ������
    IN inArticle                    TVarChar,      -- Article
    IN inGoodsName                  TVarChar,      -- �������� ������
    IN inPartNumber                 TVarChar,      -- � �� �����������
    IN inPrice                      TFloat  ,      -- ���� ��� ���
    IN inAmount                     TFloat  ,      -- ����������
    IN inEmpfPrice                  TFloat  ,      -- ���� ��������������� ��� ���
    IN inOperPriceList              TFloat  ,      -- ���� �������
    IN inSession                    TVarChar       -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId           Integer;
  DECLARE vbToId             Integer;
  DECLARE vbGoodsId          Integer;
  DECLARE vbMovementId       Integer;
  DECLARE vbMovementItemId   Integer;
  DECLARE vbPartnerId        Integer;
  DECLARE vbVATPercent       TFloat;
  DECLARE vbDiscountTax  TFloat;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);

     -- �������� - �����
     vbToId:= 35139;

     -- ��������
     /*IF inPartNumber <> ''
     THEN
         RAISE EXCEPTION '������.������ inPartNumber = <%>.', inPartNumber;
     END IF;*/


     -- �����������, ���� ���������� ���
     IF inPartnerCode <> 0 AND inGoodsCode <> 0
     THEN
         -- ����� � ���. ������
         vbGoodsId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Goods() AND Object.isErased = FALSE AND Object.ObjectCode = inGoodsCode limit 1);

         -- E��� �� ����� ����������
         IF COALESCE (vbGoodsId,0) = 0
         THEN
              RETURN;
         END IF;

         -- ���� ������ � �������� - IncomeSN_Load, ����� �� ���������
         IF EXISTS (SELECT 1
                    FROM Movement
                         INNER JOIN MovementString AS MovementString_Comment
                                                   ON MovementString_Comment.MovementId = Movement.Id
                                                  AND MovementString_Comment.DescId     = zc_MovementString_Comment()
                                                  AND MovementString_Comment.ValueData  ILIKE 'auto S/N'
                         JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                          AND MovementItem.DescId     = zc_MI_Master()
                                          AND MovementItem.ObjectId   = vbGoodsId
                                          AND MovementItem.isErased   = FALSE
                    WHERE Movement.DescId = zc_Movement_Income() AND Movement.StatusId <> zc_Enum_Status_Erased()
                   )
         THEN
             RETURN; -- !!!�����
         END IF;

         -- ������� ����������
         SELECT Object_Partner.Id
              , ObjectFloat_TaxKind_Value.ValueData
              , ObjectFloat_DiscountTax.ValueData
                INTO vbPartnerId, vbVATPercent, vbDiscountTax
          FROM Object AS Object_Partner
               LEFT JOIN ObjectLink AS ObjectLink_TaxKind
                                    ON ObjectLink_TaxKind.ObjectId = Object_Partner.Id
                                   AND ObjectLink_TaxKind.DescId = zc_ObjectLink_Partner_TaxKind()

               LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                     ON ObjectFloat_TaxKind_Value.ObjectId = COALESCE (ObjectLink_TaxKind.ChildObjectId, zc_Enum_TaxKind_Basis())
                                    AND ObjectFloat_TaxKind_Value.DescId = zc_ObjectFloat_TaxKind_Value()

               LEFT JOIN ObjectFloat AS ObjectFloat_DiscountTax
                                     ON ObjectFloat_DiscountTax.ObjectId = Object_Partner.Id
                                    AND ObjectFloat_DiscountTax.DescId = zc_ObjectFloat_Partner_DiscountTax()

          WHERE Object_Partner.ObjectCode = inPartnerCode
            AND Object_Partner.DescId     = zc_Object_Partner()
            AND Object_Partner.isErased   = FALSE
          --LIMIT 1
         ;

         -- E��� �� ����� ����������
         IF COALESCE (vbPartnerId,0) = 0
         THEN
             -- RETURN;
             -- !!!��������
             vbPartnerId:= 40048;
         END IF;


         -- ������� ����� ��������
         vbMovementId := (SELECT Movement.Id
                          FROM Movement
                               INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                             ON MovementLinkObject_From.MovementId = Movement.Id
                                                            AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                            AND MovementLinkObject_From.ObjectId = vbPartnerId
                               INNER JOIN MovementString AS MovementString_Comment
                                                         ON MovementString_Comment.MovementId = Movement.Id
                                                        AND MovementString_Comment.DescId     = zc_MovementString_Comment()
                                                        AND MovementString_Comment.ValueData ILIKE 'auto'
                          WHERE Movement.OperDate = inOperDate
                            AND Movement.DescId   = zc_Movement_Income()
                            AND Movement.StatusId <> zc_Enum_Status_Erased()
                         );
         -- E��� �� ����� �������
         IF COALESCE (vbMovementId,0) = 0
         THEN
              --
              vbMovementId := lpInsertUpdate_Movement_Income(ioId                 := 0
                                                           , inInvNumber          := CAST (NEXTVAL ('movement_Income_seq') AS TVarChar)
                                                           , inInvNumberPartner   := ''  
                                                           , inInvNumberPack      := ''
                                                           , inInvNumberInvoice   := ''
                                                           , inOperDate           := inOperDate
                                                           , inOperDatePartner    := inOperDate
                                                           , inPriceWithVAT       := FALSE
                                                           , inVATPercent         := vbVATPercent
                                                           , inDiscountTax        := vbDiscountTax
                                                           , inFromId             := vbPartnerId
                                                           , inToId               := vbToId
                                                           , inPaidKindId         := zc_Enum_PaidKind_FirstForm()
                                                           , inComment            := 'auto'
                                                           , inUserId             := vbUserId
                                                            );
         END IF;

         -- ����� �������� � ����� �������, ����� ��� ���������, ����� ���������
         vbMovementItemId := (SELECT MovementItem.Id
                              FROM MovementItem
                              WHERE MovementItem.MovementId = vbMovementId
                                AND MovementItem.DescId     = zc_MI_Master()
                                AND MovementItem.isErased   = FALSE
                                AND MovementItem.ObjectId   = vbGoodsId
                             );

         -- ��������� <������� ���������>
         vbMovementItemId:= lpInsertUpdate_MovementItem_Income (ioId            := COALESCE (vbMovementItemId,0) ::Integer
                                                              , inMovementId    := vbMovementId ::Integer
                                                              , inGoodsId       := vbGoodsId    ::Integer
                                                              , inAmount        := inAmount     ::TFloat
                                                              , inOperPrice     := inPrice      ::TFloat
                                                              , inCountForPrice := 1            ::TFloat
                                                              , inOperPriceList := inOperPriceList
                                                              , inPartNumber    := '' -- !!!������ - ������ ����� inPartNumber
                                                              , inComment       := ''           ::TVarChar   
                                                              , inPartionCellId := Null         ::Integer
                                                              , inUserId        := vbUserId     ::Integer
                                                              );


         -- ��������� ������
         PERFORM lpInsertUpdate_Object_PartionGoods (inMovementItemId    := vbMovementItemId
                                                   , inMovementId        := vbMovementId
                                                   , inFromId            := vbPartnerId
                                                   , inUnitId            := vbToId
                                                   , inOperDate          := inOperDate
                                                   , inObjectId          := vbGoodsId
                                                   , inAmount            := inAmount
                                                     -- 
                                                   , inEKPrice           := inPrice             -- ���� ��. ��� ���, � ������ ���� ������ + ������� + �������: �������� + �������� + ��������� = inEKPrice_discount + inCostPrice
                                                   , inEKPrice_orig      := inPrice             -- ���� ��. ��� ���, � ������ ������ ������ �� ��������
                                                   , inEKPrice_discount  := inPrice             -- ���� ��. ��� ���, � ������ ���� ������ (������ ����� ���)
                                                   , inCostPrice         := 0                   -- ���� ������ ��� ��� (������� + �������: �������� + �������� + ���������)
                                                   , inCountForPrice     := 1
                                                     --
                                                   , inEmpfPrice         := inEmpfPrice
                                                   , inOperPriceList     := inOperPriceList
                                                   , inOperPriceList_old := 0
                                                     --
                                                   , inTaxKindId         := COALESCE (ObjectLink_Goods_TaxKind.ChildObjectId, 0)
                                                   , inTaxKindValue      := COALESCE (ObjectFloat_TaxKind_Value.ValueData, 0)
                                                   , inUserId            := vbUserId
                                                    )
         FROM Object
              LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                   ON ObjectLink_Goods_GoodsGroup.ObjectId = Object.Id
                                  AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
              LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                   ON ObjectLink_Goods_Measure.ObjectId = Object.Id
                                  AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
              LEFT JOIN ObjectLink AS ObjectLink_Goods_TaxKind
                                   ON ObjectLink_Goods_TaxKind.ObjectId = Object.Id
                                  AND ObjectLink_Goods_TaxKind.DescId = zc_ObjectLink_Goods_TaxKind()
              LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                    ON ObjectFloat_TaxKind_Value.ObjectId = ObjectLink_Goods_TaxKind.ChildObjectId
                                   AND ObjectFloat_TaxKind_Value.DescId = zc_ObjectFloat_TaxKind_Value()
              LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsTag
                                   ON ObjectLink_Goods_GoodsTag.ObjectId = Object.Id
                                  AND ObjectLink_Goods_GoodsTag.DescId = zc_ObjectLink_Goods_GoodsTag()
              LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsType
                                   ON ObjectLink_Goods_GoodsType.ObjectId = Object.Id
                                  AND ObjectLink_Goods_GoodsType.DescId   = zc_ObjectLink_Goods_GoodsType()
              LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsSize
                                   ON ObjectLink_Goods_GoodsSize.ObjectId = Object.Id
                                  AND ObjectLink_Goods_GoodsSize.DescId = zc_ObjectLink_Goods_GoodsSize()
              LEFT JOIN ObjectLink AS ObjectLink_Goods_ProdColor
                                   ON ObjectLink_Goods_ProdColor.ObjectId = Object.Id
                                  AND ObjectLink_Goods_ProdColor.DescId = zc_ObjectLink_Goods_ProdColor()
         WHERE Object.Id = vbGoodsId;

         -- �������� ������
         UPDATE MovementItem SET PartionId = vbMovementItemId WHERE MovementItem.Id = vbMovementItemId;

     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 04.06.21         *
 25.02.21         *
*/

-- ����
--
