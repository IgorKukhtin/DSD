-- Function: gpInsertUpdate_Object_ProdOptItems()

--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ProdOptItems(Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ProdOptItems(Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ProdOptItems(Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ProdOptItems(
 INOUT ioId                     Integer   , -- ����
    IN inCode                   Integer   , -- ���
    IN inProductId              Integer   ,
 INOUT ioProdOptionsId          Integer   ,
    IN inProdOptPatternId       Integer   ,
    IN inProdColorPatternId     Integer   ,
    IN inMaterialOptionsId      Integer   ,
    IN inMovementId_OrderClient Integer   ,
 INOUT ioGoodsId                Integer   ,
   OUT outGoodsName             TVarChar  ,
    IN inAmount                 TFloat    ,
    IN inPriceIn                TFloat    ,
    IN inPriceOut               TFloat    ,
    IN inDiscountTax            TFloat    ,
    IN inPartNumber             TVarChar  ,
    IN inComment                TVarChar  ,
    IN inSession                TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
   DECLARE vbProdOptionsId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbMI_Id Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_ProdOptItems());
   vbUserId:= lpGetUserBySession (inSession);


   -- ��������
   IF COALESCE (ioProdOptionsId, 0) = 0
   THEN
       RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := '������.�������� <�����> �� �����������.'
                                             , inProcedureName := 'gpInsertUpdate_Object_ProdOptItems'
                                             , inUserId        := vbUserId
                                              );
   END IF;
   -- ��������
   IF COALESCE (inProductId, 0) = 0
   THEN
       RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := '������.�������� <�����> �� ����������.'
                                             , inProcedureName := 'gpInsertUpdate_Object_ProdOptItems'
                                             , inUserId        := vbUserId
                                              );
   END IF;
   -- ��������
   IF COALESCE (inMovementId_OrderClient, 0) = 0
   THEN
       RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := '������.�������� <����� �������> �� ����������.'
                                             , inProcedureName := 'gpInsertUpdate_Object_ProdOptItems'
                                             , inUserId        := vbUserId
                                              );
   END IF;

   -- ����� - ������ inMovementId_OrderClient � ������
   vbMI_Id := (SELECT MI.Id FROM MovementItem AS MI WHERE MI.MovementId = inMovementId_OrderClient AND MI.ObjectId = inProductId AND MI.isErased = FALSE AND MI.DescId = zc_MI_Master());
   -- ��������
   IF COALESCE (vbMI_Id, 0) = 0
   THEN
       RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := '������.� ��������� <����� �������> �� ������ ������� �������.'
                                             , inProcedureName := 'gpInsertUpdate_Object_ProdOptItems'
                                             , inUserId        := vbUserId
                                              );
   END IF;

   -- �������� - ������ ����������� �����
   IF EXISTS (SELECT 1
              FROM ObjectLink AS OL
                   -- �� ������
                   JOIN Object AS Object_ProdOptItems ON Object_ProdOptItems.Id       = OL.ObjectId
                                                     AND Object_ProdOptItems.isErased = FALSE
                   -- �����
                   JOIN ObjectLink AS OL_ProdOptions
                                   ON OL_ProdOptions.ObjectId = OL.ObjectId
                                  AND OL_ProdOptions.DescId   = zc_ObjectLink_ProdOptItems_ProdOptions()
                   LEFT JOIN ObjectLink AS OL_ProdColorPattern
                                        ON OL_ProdColorPattern.ObjectId = OL_ProdOptions.ChildObjectId
                                       AND OL_ProdColorPattern.DescId   = zc_ObjectLink_ProdOptions_ProdColorPattern()
                                       -- � ����� Boat Structure
                                       AND OL_ProdColorPattern.ChildObjectId = (SELECT OL_find.ChildObjectId FROM ObjectLink AS OL_find WHERE OL_find.ObjectId = ioProdOptionsId AND OL_find.DescId = zc_ObjectLink_ProdOptions_ProdColorPattern())
                   LEFT JOIN ObjectFLoat AS OF_CodeVergl
                                         ON OF_CodeVergl.ObjectId = OL_ProdOptions.ChildObjectId
                                        AND OF_CodeVergl.DescId   = zc_ObjectFloat_ProdOptions_CodeVergl()
                                        -- � ����� CodeVergl
                                        AND OF_CodeVergl.ValueData = (SELECT OF_find.ValueData FROM ObjectFLoat AS OF_find WHERE OF_find.ObjectId = ioProdOptionsId AND OF_find.DescId = zc_ObjectFloat_ProdOptions_CodeVergl())
              WHERE OL.ChildObjectId = inProductId AND OL.DescId = zc_ObjectLink_ProdOptItems_Product()
                AND OL.ObjectId <> COALESCE (ioId, 0)
                AND (OL_ProdColorPattern.ChildObjectId > 0 OR OF_CodeVergl.ValueData > 0)
             )
   THEN
       RAISE EXCEPTION '������.������������ ����� <%> ���������.'
                      , lfGet_Object_ValueData_sh (ioProdOptionsId)
                       ;
   END IF;

   -- �������� MaterialOptions
   IF COALESCE (inMaterialOptionsId, 0) = 0 AND EXISTS (SELECT 1 FROM ObjectLink AS OL WHERE OL.ObjectId = ioProdOptionsId AND OL.DescId = zc_ObjectLink_ProdOptions_MaterialOptions() AND OL.ChildObjectId > 0)
   THEN
       RAISE EXCEPTION '������.��� ����� <%> ���������� ������� ���������.'
                      , lfGet_Object_ValueData_sh (ioProdOptionsId)
                       ;
   END IF;
   -- �������� MaterialOptions
   IF inMaterialOptionsId > 0 AND NOT EXISTS (SELECT 1 FROM ObjectLink AS OL WHERE OL.ObjectId = ioProdOptionsId AND OL.DescId = zc_ObjectLink_ProdOptions_MaterialOptions() AND OL.ChildObjectId > 0)
   THEN
       RAISE EXCEPTION '������.��� ����� <%> �� ������������ ����� ��������� <%>.'
                      , lfGet_Object_ValueData_sh (ioProdOptionsId)
                      , lfGet_Object_ValueData_sh (inMaterialOptionsId)
                       ;
   END IF;

   -- ������, �.�. ��������� MaterialOptions
   IF inMaterialOptionsId > 0 AND NOT EXISTS (SELECT 1 FROM ObjectLink AS OL WHERE OL.ObjectId = ioProdOptionsId AND OL.DescId = zc_ObjectLink_ProdOptions_MaterialOptions() AND OL.ChildObjectId = inMaterialOptionsId)
   THEN
       -- ��������
       IF 1 < (SELECT COUNT(*)
               FROM ObjectLink AS OL
                    JOIN ObjectLink AS OL_ProdColorPattern
                                    ON OL_ProdColorPattern.ObjectId = OL.ObjectId
                                   AND OL_ProdColorPattern.DescId   = zc_ObjectLink_ProdOptions_ProdColorPattern()
                                   -- � ����� Boat Structure
                                   AND OL_ProdColorPattern.ChildObjectId = (SELECT OL_find.ChildObjectId FROM ObjectLink AS OL_find WHERE OL_find.ObjectId = ioProdOptionsId AND OL_find.DescId = zc_ObjectLink_ProdOptions_ProdColorPattern())
               WHERE OL.ChildObjectId = inMaterialOptionsId AND OL.DescId = zc_ObjectLink_ProdOptions_MaterialOptions()
              )
       THEN
           RAISE EXCEPTION '������.������� ��������� ����� <%> � ���������� <%>.'
                          , lfGet_Object_ValueData_sh (ioProdOptionsId)
                          , lfGet_Object_ValueData_sh (inMaterialOptionsId)
                           ;
       END IF;

       -- �����
       vbProdOptionsId:= COALESCE ((SELECT OL.ObjectId
                                    FROM ObjectLink AS OL
                                         JOIN ObjectLink AS OL_ProdColorPattern
                                                         ON OL_ProdColorPattern.ObjectId      = OL.ObjectId
                                                        AND OL_ProdColorPattern.DescId        = zc_ObjectLink_ProdOptions_ProdColorPattern()
                                                        -- � ����� Boat Structure
                                                        AND OL_ProdColorPattern.ChildObjectId = (SELECT OL_find.ChildObjectId FROM ObjectLink AS OL_find WHERE OL_find.ObjectId = ioProdOptionsId AND OL_find.DescId = zc_ObjectLink_ProdOptions_ProdColorPattern())
                                    WHERE OL.ChildObjectId = inMaterialOptionsId AND OL.DescId = zc_ObjectLink_ProdOptions_MaterialOptions()
                                   ), 0);
       -- ��������
       IF COALESCE (vbProdOptionsId, 0) = 0
       THEN
           RAISE EXCEPTION '������.��� ����� <%> �� ���������� ��������� <%>.'
                          , lfGet_Object_ValueData_sh (ioProdOptionsId)
                          , lfGet_Object_ValueData_sh (inMaterialOptionsId)
                           ;
       ELSE 
           -- !!!������
           ioProdOptionsId:= vbProdOptionsId;

       END IF;

   END IF;



   -- ��������/�����
   IF COALESCE (inProdOptPatternId, 0) = 0
   THEN
       -- ������ "���������"
       inProdOptPatternId:= (SELECT MIN (Object.Id) FROM Object WHERE Object.DescId = zc_Object_ProdOptPattern() AND Object.isErased = FALSE
                             AND Object.Id NOT IN (-- ���� ��� ����� ������������
                                                   SELECT ObjectLink_ProdOptPattern.ChildObjectId
                                                   FROM Object AS Object_ProdOptItems
                                                        INNER JOIN ObjectLink AS ObjectLink_Product
                                                                             ON ObjectLink_Product.ObjectId      = Object_ProdOptItems.Id
                                                                            AND ObjectLink_Product.DescId        = zc_ObjectLink_ProdOptItems_Product()
                                                                            -- ��� ���� �����
                                                                            AND ObjectLink_Product.ChildObjectId = inProductId

                                                        INNER JOIN ObjectLink AS ObjectLink_ProdOptPattern
                                                                              ON ObjectLink_ProdOptPattern.ObjectId = Object_ProdOptItems.Id
                                                                             AND ObjectLink_ProdOptPattern.DescId   = zc_ObjectLink_ProdOptItems_ProdOptPattern()
                                                   WHERE Object_ProdOptItems.DescId = zc_Object_ProdOptItems()
                                                     AND Object_ProdOptItems.isErased = FALSE
                                                  ));
     --RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := '������.������� �� ����������.'
     --                                      , inProcedureName := 'gpInsertUpdate_Object_ProdOptItems'
     --                                      , inUserId        := vbUserId
     --                                       );
   END IF;


   -- ���� ��� ����� �� Boat Structure ��� ���� inProdColorPatternId
 --IF EXISTS (SELECT 1 FROM ObjectLink WHERE ObjectLink.DescId = zc_ObjectLink_ProdColorPattern_ProdOptions() AND ObjectLink.ChildObjectId = ioProdOptionsId)
   IF EXISTS (SELECT 1 FROM ObjectLink WHERE ObjectLink.DescId = zc_ObjectLink_ProdOptions_ProdColorPattern() AND ObjectLink.ObjectId = ioProdOptionsId)
      OR inProdColorPatternId > 0
   THEN
        -- �������� inProdColorPatternId - ��������
        IF COALESCE (inProdColorPatternId, 0) = 0
        THEN
            RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := '������.inProdColorPatternId �� ����������.'
                                                  , inProcedureName := 'gpInsertUpdate_Object_ProdOptItems'
                                                  , inUserId        := vbUserId
                                                   );
        END IF;
        -- �������� ioProdOptionsId - �� Boat Structure
        IF NOT EXISTS (SELECT 1 FROM ObjectLink AS OL WHERE OL.DescId = zc_ObjectLink_ProdOptions_ProdColorPattern() AND OL.ObjectId = ioProdOptionsId AND OL.ChildObjectId = inProdColorPatternId)
        THEN
            RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := '������.�� ������ ioProdOptionsId + inProdColorPatternId.'
                                                  , inProcedureName := 'gpInsertUpdate_Object_ProdOptItems'
                                                  , inUserId        := vbUserId
                                                   );
        END IF;

        -- ��������� � Items Boat Structure
        PERFORM gpInsertUpdate_Object_ProdColorItems(ioId                     := tmp.Id
                                                   , inCode                   := tmp.Code
                                                   , inProductId              := inProductId
                                                   , inGoodsId                := ioGoodsId
                                                   , inProdColorPatternId     := tmp.ProdColorPatternId
                                                   , inMaterialOptionsId      := inMaterialOptionsId
                                                   , inMovementId_OrderClient := inMovementId_OrderClient
                                                   , inComment                := inComment
                                                   , inIsEnabled              := TRUE :: Boolean
                                                   , ioIsProdOptions          := CASE WHEN tmp.GoodsId_Receipt <> ioGoodsId THEN TRUE ELSE FALSE END
                                                   , inSession                := inSession
                                                    )
                                                   
        FROM gpSelect_Object_ProdColorItems (COALESCE (inMovementId_OrderClient,0),FALSE,FALSE,FALSE, inSession) as tmp
        WHERE tmp.ProductId = inProductId
          AND tmp.ProdColorPatternId = inProdColorPatternId
        ;
   
        -- !!! ����� !!!
        -- RETURN;
        
    END IF;


   -- ���������� ������� ��������/�������������
   vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- ���� ��� �� ����������, ���������� ��� ��� ���������+1, ��� ������ ����� ������� � 1
   IF COALESCE (ioId,0) = 0 AND inCode = 0
   THEN
       vbCode_calc:= COALESCE ((SELECT MAX (Object_ProdOptItems.ObjectCode) AS ObjectCode
                                FROM Object AS Object_ProdOptItems
                                     INNER JOIN ObjectLink AS ObjectLink_Product
                                                           ON ObjectLink_Product.ObjectId = Object_ProdOptItems.Id
                                                          AND ObjectLink_Product.DescId = zc_ObjectLink_ProdOptItems_Product()
                                                          AND ObjectLink_Product.ChildObjectId = inProductId AND COALESCE (inProductId,0) <> 0
                                WHERE Object_ProdOptItems.DescId = zc_Object_ProdOptItems())
                               , 0) + 1;
   ELSE
        vbCode_calc:= inCode;
   END IF;

   -- �������� ���� ������������ ��� �������� <������������ >
   --PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_ProdOptItems(), inName, vbUserId);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_ProdOptItems(), vbCode_calc, '');

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_ProdOptItems_PartNumber(), ioId, inPartNumber);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_ProdOptItems_Comment(), ioId, inComment);

   -- ��������� �������� <��� �����>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ProdOptItems_Count(), ioId, inAmount);

   -- ��������� �������� <PriceIn> - �������� �����, ����� ����� �����������
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ProdOptItems_PriceIn(), ioId, 0);
   -- ��������� �������� <PriceOut> - �������� �����, ����� ����� �����������
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ProdOptItems_PriceOut(), ioId, inPriceOut);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ProdOptItems_DiscountTax(), ioId, inDiscountTax);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ProdOptItems_Product(), ioId, inProductId);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ProdOptItems_ProdOptions(), ioId, ioProdOptionsId);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ProdOptItems_ProdOptPattern(), ioId, inProdOptPatternId);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ProdOptItems_Goods(), ioId, ioGoodsId);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ProdOptItems_OrderClient(), ioId, inMovementId_OrderClient);


   IF vbIsInsert = TRUE THEN
      -- ��������� �������� <���� ��������>
      PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Insert(), ioId, CURRENT_TIMESTAMP);
      -- ��������� �������� <������������ (��������)>
      PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Insert(), ioId, vbUserId);
   END IF;

   outGoodsName := (SELECT Object.ValueData FROM Object WHERE Object.Id = ioGoodsId);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);


   -- ������������� - �������  - ����� �������
   vbMI_Id:= (WITH gpSelect AS (SELECT gpSelect.Basis_summ, gpSelect.Basis_summ_orig, gpSelect.Basis_summ1_orig
                                FROM gpSelect_Object_Product (FALSE, FALSE, vbUserId :: TVarChar) AS gpSelect
                                WHERE gpSelect.MovementId_OrderClient = inMovementId_OrderClient
                               )
              -- ���������
              SELECT tmp.ioId
              FROM lpInsertUpdate_MovementItem_OrderClient (ioId            := vbMI_Id
                                                          , inMovementId    := inMovementId_OrderClient
                                                          , inGoodsId       := inProductId
                                                          , inAmount        := (SELECT MovementItem.Amount FROM MovementItem WHERE MovementItem.Id = vbMI_Id)
                                                            -- ����� ����� ������� ��� ��� - �� ����� �������� (Basis+options)
                                                          , ioOperPrice     := (SELECT gpSelect.Basis_summ       FROM gpSelect)
                                                            -- ����� ����� ������� ��� ��� - ��� ������ (Basis+options)
                                                          , inOperPriceList := (SELECT gpSelect.Basis_summ_orig  FROM gpSelect)
                                                            -- ����� ����� ������� ��� ��� - ��� ������ (Basis)
                                                          , inBasisPrice    := (SELECT gpSelect.Basis_summ1_orig FROM gpSelect)
                                                            -- 
                                                          , inCountForPrice := 1  ::TFloat
                                                          , inComment       := '' ::TVarChar
                                                          , inUserId        := vbUserId
                                                           ) AS tmp
             );


   -- �������� - ������ ����������� �����
   IF EXISTS (SELECT 1
              FROM ObjectLink AS OL
                   -- �� ������
                   JOIN Object AS Object_ProdOptItems ON Object_ProdOptItems.Id       = OL.ObjectId
                                                     AND Object_ProdOptItems.isErased = FALSE
                   -- �����
                   JOIN ObjectLink AS OL_ProdOptions
                                   ON OL_ProdOptions.ObjectId      = OL.ObjectId
                                  AND OL_ProdOptions.DescId        = zc_ObjectLink_ProdOptItems_ProdOptions()
                                  AND OL_ProdOptions.ChildObjectId = ioProdOptionsId
              WHERE OL.ChildObjectId = inProductId AND OL.DescId = zc_ObjectLink_ProdOptItems_Product()
                AND OL.ObjectId <> COALESCE (ioId, 0)
             )
   THEN
       RAISE EXCEPTION '������.������������ ����� <%> ���������.'
                      , lfGet_Object_ValueData_sh (ioProdOptionsId)
                       ;
   END IF;

   -- ��������� ��������
   PERFORM lpInsert_MovementItemProtocol (vbMI_Id, vbUserId, FALSE);
   -- ����������� �������� ����� - ����� �������
   PERFORM lpInsertUpdate_MovementFloat_TotalSumm_order (inMovementId_OrderClient);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 06.04.21         * inAmount
 04.01.21         * inDiscountTax
 09.10.20         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_ProdOptItems()
