-- ������

DROP FUNCTION IF EXISTS gpUpdate_Object_isErased_ProdOptItems (Integer, Boolean,  TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_isErased_ProdOptItems(
    IN inObjectId Integer,
    IN inIsErased Boolean,
    IN inSession  TVarChar
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbProdColorPatternId Integer;
   DECLARE vbProdOptionsId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_isErased_ProdOptItems());
   vbUserId:= lpGetUserBySession (inSession);


   -- ����� ���� ��� Boat Structure
   vbProdColorPatternId:= (SELECT tmp.ProdColorPatternId
                           FROM gpSelect_Object_ProdOptItems (inMovementId_OrderClient := 0
                                                            , inIsShowAll:= FALSE
                                                            , inIsErased := TRUE
                                                            , inIsSale   := TRUE
                                                            , inSession  := inSession
                                                             ) AS tmp
                           WHERE tmp.Id = inObjectId
                             AND tmp.ProdColorPatternId > 0
                          );

   -- ���� ��� Boat Structure
   IF vbProdColorPatternId > 0
   THEN
       IF inIsErased = TRUE
       THEN
           -- ��������������� � Items Boat Structure - �� �������
           IF NOT EXISTS (SELECT 1
                          FROM gpSelect_Object_ProdColorItems (0,FALSE,FALSE,FALSE, inSession) as tmp
                          -- �����
                          WHERE tmp.MovementId_OrderClient = (SELECT OFl.ValueData FROM ObjectFloat AS OFl WHERE OFl.ObjectId = inObjectId AND OFl.DescId   = zc_ObjectFloat_ProdOptItems_OrderClient()) :: Integer
                            AND tmp.ProductId = (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = inObjectId AND OL.DescId   = zc_ObjectLink_ProdOptItems_Product())
                            AND tmp.ProdColorPatternId = vbProdColorPatternId
                            AND tmp.MaterialOptionsId_Receipt > 0
                         )
              AND EXISTS (SELECT 1
                          FROM ObjectLink AS OL
                               INNER JOIN Object AS Object_ProdOptions ON Object_ProdOptions.Id       = OL.ObjectId
                                                                      AND Object_ProdOptions.isErased = FALSE
                               -- ��������� �����
                               INNER JOIN ObjectLink AS ObjectLink_MaterialOptions
                                                     ON ObjectLink_MaterialOptions.ObjectId      = Object_ProdOptions.Id
                                                    AND ObjectLink_MaterialOptions.DescId        = zc_ObjectLink_ProdOptions_MaterialOptions()
                                                    AND ObjectLink_MaterialOptions.ChildObjectId > 0
                          WHERE OL.ChildObjectId = vbProdColorPatternId
                            AND OL.DescId        = zc_ObjectLink_ProdOptions_ProdColorPattern()
                         )
           THEN
               RAISE EXCEPTION '������.������� <��������� �����>-Receipt �� ����������. <%> <%>'
                              , (SELECT OFl.ValueData FROM ObjectFloat AS OFl WHERE OFl.ObjectId = inObjectId AND OFl.DescId = zc_ObjectFloat_ProdOptItems_OrderClient()) :: Integer
                              , vbProdColorPatternId
                               ;
           END IF;
           
           -- ��������������� � Items Boat Structure - �� �������
           PERFORM gpInsertUpdate_Object_ProdColorItems(ioId                     := tmp.Id
                                                      , inCode                   := tmp.Code
                                                      , inProductId              := (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = inObjectId AND OL.DescId   = zc_ObjectLink_ProdOptItems_Product())
                                                      , inGoodsId                := tmp.GoodsId_Receipt
                                                      , inProdColorPatternId     := tmp.ProdColorPatternId
                                                      , inMaterialOptionsId      := tmp.MaterialOptionsId_Receipt
                                                      , inMovementId_OrderClient := tmp.MovementId_OrderClient
                                                      , inComment                := '' :: TVarChar
                                                      , inIsEnabled              := TRUE :: Boolean
                                                      , ioIsProdOptions          := FALSE
                                                      , inSession                := inSession
                                                      )

           FROM gpSelect_Object_ProdColorItems (0,FALSE,FALSE,FALSE, inSession) as tmp
           -- �����
           WHERE tmp.MovementId_OrderClient = (SELECT OFl.ValueData FROM ObjectFloat AS OFl WHERE OFl.ObjectId = inObjectId AND OFl.DescId   = zc_ObjectFloat_ProdOptItems_OrderClient()) :: Integer
             AND tmp.ProductId = (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = inObjectId AND OL.DescId   = zc_ObjectLink_ProdOptItems_Product())
             AND tmp.ProdColorPatternId = vbProdColorPatternId
          ;

       ELSE
           vbProdOptionsId:= (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = inObjectId AND OL.DescId = zc_ObjectLink_ProdOptItems_ProdOptions());
           -- ��������������� � Items Boat Structure - ����
           PERFORM gpInsertUpdate_Object_ProdColorItems(ioId                     := tmp.Id
                                                      , inCode                   := tmp.Code
                                                      , inProductId              := (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = inObjectId AND OL.DescId   = zc_ObjectLink_ProdOptItems_Product())
                                                      , inGoodsId                := (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = inObjectId AND OL.DescId   = zc_ObjectLink_ProdOptItems_Goods())
                                                      , inProdColorPatternId     := tmp.ProdColorPatternId
                                                      , inMaterialOptionsId      := (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbProdOptionsId AND OL.DescId = zc_ObjectLink_ProdOptions_MaterialOptions())
                                                      , inMovementId_OrderClient := tmp.MovementId_OrderClient
                                                      , inComment                := '' :: TVarChar
                                                      , inIsEnabled              := TRUE :: Boolean
                                                      , ioIsProdOptions          := CASE WHEN tmp.GoodsId_Receipt           <> (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = inObjectId AND OL.DescId = zc_ObjectLink_ProdOptItems_Goods())
                                                                                           OR tmp.MaterialOptionsId_Receipt <> (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbProdOptionsId AND OL.DescId = zc_ObjectLink_ProdOptions_MaterialOptions())
                                                                                         THEN TRUE
                                                                                         ELSE FALSE
                                                                                    END
                                                      , inSession                := inSession
                                                       )

           FROM gpSelect_Object_ProdColorItems (0,FALSE,FALSE,FALSE, inSession) as tmp
           -- �����
           WHERE tmp.MovementId_OrderClient = (SELECT OFl.ValueData FROM ObjectFloat AS OFl WHERE OFl.ObjectId = inObjectId AND OFl.DescId   = zc_ObjectFloat_ProdOptItems_OrderClient()) :: Integer
             AND tmp.ProductId = (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = inObjectId AND OL.DescId = zc_ObjectLink_ProdOptItems_Product())
             AND tmp.ProdColorPatternId = vbProdColorPatternId
          ;

       END IF;

   END IF;

   -- ��������
   PERFORM lpUpdate_Object_isErased (inObjectId:= inObjectId, inIsErased:=inIsErased, inUserId:= vbUserId);

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
                                  AND OL_ProdOptions.ChildObjectId = (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = inObjectId AND OL.DescId = zc_ObjectLink_ProdOptItems_ProdOptions())
              WHERE OL.ChildObjectId = (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = inObjectId AND OL.DescId   = zc_ObjectLink_ProdOptItems_Product())
                AND OL.DescId = zc_ObjectLink_ProdOptItems_Product()
                AND OL.ObjectId <> COALESCE (inObjectId, 0)
             )
   THEN
       RAISE EXCEPTION '������.������������ ����� <%> ���������.'
                      , lfGet_Object_ValueData_sh (ioProdOptionsId)
                       ;
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 08.10.20         *
*/
