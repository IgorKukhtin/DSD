--
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Income_Load (TDateTime, Integer, Integer, TVarChar, TVarChar, TVarChar, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Income_Load(
    IN inOperDate                   TDateTime,     -- ���� ���������
    IN inPartnerCode                Integer,       -- ��� ����������
    IN inGoodsCode                  Integer,       -- ��� ������
    IN inArticle                    TVarChar,      -- Article
    IN inGoodsName                  TVarChar,      -- �������� ������
    IN inPartNumber                 TVarChar,      -- � �� ����������� 
    IN inPrice                      TFloat  ,      -- ���� ��� ���
    IN inAmount                     TFloat  ,      -- ����������
    IN inSession                    TVarChar       -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId           Integer;  
  DECLARE vbGoodsId          Integer;
  DECLARE vbMovementId       Integer;
  DECLARE vbMovementItemId   Integer;
  DECLARE vbPartnerId        Integer;
  DECLARE vbVATPercent       TFloat;
  DECLARE vbDiscountTax  TFloat;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpGetUserBySession (inSession);

   IF COALESCE (inPartnerCode,0) <> 0
   THEN
      IF COALESCE (inGoodsCode,0) <> 0
      THEN
          -- ����� � ���. ������
          vbGoodsId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Goods() AND Object.isErased = FALSE AND Object.ObjectCode = inGoodsCode limit 1);
   
          -- E��� �� ����� ����������
          IF COALESCE (vbGoodsId,0) = 0
          THEN
               RETURN;
          END IF;

          -- ������� ����������
          SELECT Object_Partner.Id
               , ObjectFloat_TaxKind_Value.ValueData::TFloat
               , ObjectFloat_DiscountTax.ValueData ::TFloat
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

           WHERE Object_Partner.DescId = zc_Object_Partner()
             AND Object_Partner.isErased = FALSE
             AND Object_Partner.ObjectCode = inPartnerCode
           limit 1;

          -- E��� �� ����� ����������
          IF COALESCE (vbPartnerId,0) = 0
          THEN
               RETURN;
          END IF;

          -- ������� ����� ��������
          vbMovementId := (SELECT Movement.Id
                           FROM Movement
                                INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                              ON MovementLinkObject_From.MovementId = Movement.Id
                                                             AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                             AND MovementLinkObject_From.ObjectId = vbPartnerId
                           WHERE Movement.DescId = zc_Movement_Income()
                             AND Movement.OperDate = inOperDate
                             AND Movement.StatusId <> zc_Enum_Status_Erased()
                           );
          -- E��� �� ����� �������
          IF COALESCE (vbMovementId,0) = 0
          THEN
               --
               vbMovementId := lpInsertUpdate_Movement_Income(ioId                 := 0
                                                            , inInvNumber          := CAST (NEXTVAL ('movement_Income_seq') AS TVarChar) 
                                                            , inInvNumberPartner   := ''            ::TVarChar
                                                            , inOperDate           := inOperDate    ::TDateTime
                                                            , inOperDatePartner    := NULL          ::TDateTime
                                                            , inPriceWithVAT       := False         ::Boolean
                                                            , inVATPercent         := vbVATPercent  ::TFloat
                                                            , inDiscountTax        := vbDiscountTax ::TFloat
                                                            , inFromId             := vbPartnerId   ::Integer
                                                            , inToId               := 0             ::Integer
                                                            , inPaidKindId         := zc_Enum_PaidKind_FirstForm() ::Integer
                                                            , inMovementId_Invoice := 0             ::Integer
                                                            , inComment            := 'auto'        ::TVarChar
                                                            , inUserId             := vbUserId      ::Integer
                                                            );
          END IF;
          
          --���� ����� �����, ����� ��� ���������, ����� ��������� 
          vbMovementItemId := (SELECT MovementItem.Id
                               FROM MovementItem
                               WHERE MovementItem.MovementId = vbMovementId
                                 AND MovementItem.DescId     = zc_MI_Master()
                                 AND MovementItem.isErased   = False
                                 AND MovementItem.ObjectId = vbGoodsId
                               );
                               
          -- ��������� <������� ���������>
          PERFORM lpInsertUpdate_MovementItem_Income (ioId            := COALESCE (vbMovementItemId,0) ::Integer
                                                    , inMovementId    := vbMovementId ::Integer
                                                    , inPartionId     := Null         ::Integer
                                                    , inGoodsId       := vbGoodsId    ::Integer
                                                    , inAmount        := inAmount     ::TFloat
                                                    , inOperPrice     := inPrice      ::TFloat
                                                    , inCountForPrice := 1            ::TFloat
                                                    , inPartNumber    := inPartNumber ::TVarChar
                                                    , inComment       := ''           ::TVarChar
                                                    , inUserId        := vbUserId     ::Integer
                                                    );
       END IF;
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 25.02.21          *
*/

-- ����
--