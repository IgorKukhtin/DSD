-- Function: gpInsertUpdate_Object_Product()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Product(Integer, Integer, TVarChar, Integer, Integer, Integer, TFloat, TDateTime, TDateTime, TDateTime, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Product(Integer, Integer, TVarChar, Integer, Integer, Integer, Boolean, Boolean, TFloat, TDateTime, TDateTime, TDateTime, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Product(Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Boolean, Boolean, TFloat, TDateTime, TDateTime, TDateTime, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Product(Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Boolean, Boolean, TFloat, TFloat, TFloat, TDateTime, TDateTime, TDateTime, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Product(Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Boolean, Boolean, TFloat, TFloat, TFloat, TDateTime, TDateTime, TDateTime, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Product(Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Boolean, Boolean, TFloat, TFloat, TFloat, TDateTime, TDateTime, TDateTime, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Product(
 INOUT ioId                    Integer   ,    -- ���� ������� <�����>
    IN inCode                  Integer   ,    -- ��� �������
    IN inName                  TVarChar  ,    -- �������� �������
    IN inBrandId               Integer   ,
    IN inModelId               Integer   ,
    IN inEngineId              Integer   ,
    IN inReceiptProdModelId    Integer   ,    --
    IN inClientId              Integer   ,    --
    IN inIsBasicConf           Boolean   ,    -- �������� ������� ������������
    IN inIsProdColorPattern    Boolean   ,    -- ������������� �������� ��� Items Boat Structure
    IN inHours                 TFloat    ,
    IN inChangePercent         TFloat    ,
    IN inDiscountNextTax       TFloat    ,
    IN inDateStart             TDateTime ,
    IN inDateBegin             TDateTime ,
    IN inDateSale              TDateTime ,
    IN inCIN                   TVarChar  ,
    IN inEngineNum             TVarChar  ,
    IN inComment               TVarChar  ,
    IN inSession               TVarChar       -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbVATPercent Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbMovementId Integer;
    
   /*DECLARE vbDateStart TDateTime;
   DECLARE vbModelId Integer;
   DECLARE vbModelNom TVarChar;
   */
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_Product());
   vbUserId:= lpGetUserBySession (inSession);

   -- ���������� ������� ��������/�������������
   vbIsInsert:= COALESCE (ioId, 0) = 0;

   -- !!! �������� !!!
   -- IF CEIL (inCode / 2) * 2 = inCode THEN inDateSale:= NULL; END IF;
   inDateSale:= NULL;


   -- ������ ������ ������
   IF vbIsInsert = FALSE AND inModelId <> (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = ioId AND OL.DescId = zc_ObjectLink_Product_Model())
      AND EXISTS (SELECT 1 FROM ObjectLink AS ObjectLink_Product
                             JOIN Object AS Object_ProdColorItems ON Object_ProdColorItems.Id       = ObjectLink_Product.ObjectId
                                                                 AND Object_ProdColorItems.isErased = FALSE
                  WHERE ObjectLink_Product.ChildObjectId = ioId
                    AND ObjectLink_Product.DescId        = zc_ObjectLink_ProdColorItems_Product()
                 )
   THEN
       RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := '������.�������� <Items Boat Structure>.������ ������ Model.' :: TVarChar
                                             , inProcedureName := 'gpInsertUpdate_Object_Product'    :: TVarChar
                                             , inUserId        := vbUserId
                                              );
   END IF;

   -- �������� - ������ ���� ���
   IF COALESCE (inCode, 0) = 0 THEN
      RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := '������.������ ���� ��������� <Interne Nr.>' :: TVarChar
                                            , inProcedureName := 'gpInsertUpdate_Object_Product'    :: TVarChar
                                            , inUserId        := vbUserId
                                             );
   END IF;
   -- �������� - ������ ���� CIN
   IF COALESCE (inCIN, '') = '' THEN
      RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := '������.������ ���� ��������� <CIN Nr.>' :: TVarChar
                                            , inProcedureName := 'gpInsertUpdate_Object_Product'    :: TVarChar
                                            , inUserId        := vbUserId
                                             );
   END IF;
     
   -- ��������
   IF COALESCE (inModelId, 0) = 0
   THEN
       RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := '������.������ ���� ���������� <Model>' :: TVarChar
                                             , inProcedureName := 'gpInsertUpdate_Object_Product'
                                             , inUserId        := vbUserId
                                              );
   END IF;

   -- ��������
   IF COALESCE (inReceiptProdModelId, 0) = 0
   THEN
       RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := '������.������ ���� ��������� <������ ������ ������>' :: TVarChar
                                             , inProcedureName := 'gpInsertUpdate_Object_Product'
                                             , inUserId        := vbUserId
                                              );
   END IF;

   -- �������� ������������ <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Goods(), inCode, vbUserId);
   -- �������� ������������ <CIN Nr.>
   IF LENGTH (inCIN) > 12 THEN PERFORM lpCheckUnique_ObjectString_ValueData (ioId, zc_ObjectString_Product_CIN(), inCIN, vbUserId); END IF;
   

   -- ������
   inName:= SUBSTRING (COALESCE ((SELECT Object.ValueData FROM Object WHERE Object.Id = inBrandId), ''), 1, 2)
             || ' ' || COALESCE ((SELECT Object.ValueData FROM Object WHERE Object.Id = inModelId), '')
             || ' ' || COALESCE ((SELECT Object.ValueData FROM Object WHERE Object.Id = inEngineId), '')
             || ' ' || inCIN
             ;

   -- �������� ���� ������������ ��� �������� <������������ >
 --PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_Product(), inName, vbUserId);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Product(), inCode, inName);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Product_BasicConf(), ioId, inIsBasicConf);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Product_Hours(), ioId, inHours);
   
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Product_DateStart(), ioId, inDateStart);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Product_DateBegin(), ioId, inDateBegin);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Product_DateSale(), ioId, inDateSale);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Product_CIN(), ioId, inCIN);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Product_EngineNum(), ioId, inEngineNum);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Product_Comment(), ioId, inComment);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Product_Brand(), ioId, inBrandId);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Product_Model(), ioId, inModelId);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Product_Engine(), ioId, inEngineId);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Product_ReceiptProdModel(), ioId, inReceiptProdModelId);
   
   -- ��������� �������� <>
   --PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Product_Client(), ioId, inClientId);


   -- ������ ��� ��������
   IF inIsProdColorPattern = TRUE AND (vbIsInsert = TRUE OR EXISTS (SELECT 1
                                                                    FROM gpSelect_Object_ProdColorItems (inIsShowAll:= TRUE, inIsErased:= FALSE, inIsSale:= FALSE, inSession:= inSession) AS tmp
                                                                    WHERE tmp.ProductId = ioId
                                                                      AND COALESCE (tmp.Id, 0) = 0
                                                                   ))

                                                                       /*(SELECT 1
                                                                        FROM ObjectLink AS ObjectLink_Product
                                                                             INNER JOIN Object AS Object_ProdColorItems
                                                                                               ON Object_ProdColorItems.Id       = ObjectLink_Product.ObjectId
                                                                                              AND Object_ProdColorItems.isErased = FALSE
                                                                        WHERE ObjectLink_Product.ChildObjectId = ioId
                                                                          AND ObjectLink_Product.DescId        = zc_ObjectLink_ProdColorItems_Product()
                                                                       ))*/
   THEN
       -- �������� ��� Items Boat Structure
       PERFORM gpInsertUpdate_Object_ProdColorItems (ioId                  := 0
                                                   , inCode                := 0
                                                   , inProductId           := ioId
                                                   , inGoodsId             := tmp.GoodsId
                                                   , inProdColorPatternId  := tmp.ProdColorPatternId
                                                   , inComment             := ''
                                                   , inIsEnabled           := TRUE
                                                   , ioIsProdOptions       := FALSE
                                                   , inSession             := inSession
                                                    ) 
       FROM gpSelect_Object_ProdColorItems (inIsShowAll:= TRUE, inIsErased:= FALSE, inIsSale:= FALSE, inSession:= inSession) AS tmp
       WHERE tmp.ProductId = ioId
         AND tmp.ReceiptProdModelId = inReceiptProdModelId
         AND COALESCE (tmp.Id, 0) = 0
        ;

   END IF;



   IF vbIsInsert = TRUE THEN
      -- ��������� �������� <���� ��������>
      PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Insert(), ioId, CURRENT_TIMESTAMP);
      -- ��������� �������� <������������ (��������)>
      PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Insert(), ioId, vbUserId);
   END IF;

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);


   --������������ zc_Movement_OrderClient � ������� "�� ����������"
   -- 1 -- ������� ����� ���. ���� �� ��� ������
   vbMovementId := (SELECT Movement.Id
                    FROM MovementLinkObject AS MovementLinkObject_Product
                         INNER JOIN Movement ON Movement.Id = MovementLinkObject_Product.MovementId
                                            AND Movement.DescId = zc_Movement_OrderClient()
                                            AND Movement.StatusId <> zc_Enum_Status_Erased()
                    WHERE MovementLinkObject_Product.ObjectId = ioId
                      AND MovementLinkObject_Product.DescId = zc_MovementLinkObject_Product()
                    LIMIT 1
                    );
   -- ���� ��� ���� �� ������ �� ������, ��� ��� �������
   IF COALESCE(vbMovementId,0) = 0
   THEN
       -- ��������� ������ zc_Enum_TaxKind_Basis
       vbVATPercent := (SELECT ObjectFloat_TaxKind_Value.ValueData AS VATPercent
                        FROM ObjectFloat AS ObjectFloat_TaxKind_Value
                        WHERE ObjectFloat_TaxKind_Value.ObjectId = zc_Enum_TaxKind_Basis()
                          AND ObjectFloat_TaxKind_Value.DescId = zc_ObjectFloat_TaxKind_Value()
                        )::TFloat;
                        
                    
       --������� ��������
       vbMovementId:= lpInsertUpdate_Movement_OrderClient(ioId               := 0            ::Integer
                                                        , inInvNumber        := CAST (NEXTVAL ('movement_OrderClient_seq') AS TVarChar) ::TVarChar
                                                        , inInvNumberPartner := ''           ::TVarChar
                                                        , inOperDate         := CURRENT_DATE ::TDateTime
                                                        , inPriceWithVAT     := FALSE        ::Boolean
                                                        , inVATPercent       := vbVATPercent ::TFloat
                                                        , inChangePercent    := inChangePercent   ::TFloat
                                                        , inDiscountNextTax  := inDiscountNextTax ::TFloat
                                                        , inFromId           := inClientId   ::Integer
                                                        , inToId             := 0            ::Integer
                                                        , inPaidKindId       := zc_Enum_PaidKind_FirstForm() ::Integer
                                                        , inProductId        := ioId         ::Integer
                                                        , inMovementId_Invoice := 0          ::Integer
                                                        , inComment          := ''           ::TVarChar
                                                        , inUserId           := vbUserId     ::Integer
                                                        );
       --
       PERFORM lpInsertUpdate_MovementItem_OrderClient (ioId            := 0
                                                      , inMovementId    := vbMovementId
                                                      , inGoodsId       := ioId
                                                      , inAmount        := 1  ::TFloat
                                                      , inOperPrice     := 0  ::TFloat
                                                      , inCountForPrice := 1  ::TFloat
                                                      , inComment       := '' ::TVarChar
                                                      , inUserId        := vbUserId
                                                      );
   ELSE
       --�������� ���� ����� ������� ������ �������
       PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), vbMovementId, inClientId);
       -- ��������� �������� <% ������>
       PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ChangePercent(), vbMovementId, inChangePercent);
       -- ��������� �������� <% ������ ���>
       PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_DiscountNextTax(), vbMovementId, inDiscountNextTax);    
     
       -- ��������� ��������
       PERFORM lpInsert_MovementProtocol (vbMovementId, vbUserId, False);

   END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 24.02.21         *
 11.01.21         *
 04.01.21         *
 09.10.20         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Product()
