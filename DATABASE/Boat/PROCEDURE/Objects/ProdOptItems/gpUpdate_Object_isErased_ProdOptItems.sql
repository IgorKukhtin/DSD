-- Модель

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
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_isErased_ProdOptItems());
   vbUserId:= lpGetUserBySession (inSession);


   -- нашли если это Boat Structure
   vbProdColorPatternId:= (SELECT tmp.ProdColorPatternId
                           FROM gpSelect_Object_ProdOptItems (inIsShowAll:= FALSE
                                                            , inIsErased := TRUE
                                                            , inIsSale   := TRUE
                                                            , inSession  := inSession
                                                             ) AS tmp
                           WHERE tmp.Id = inObjectId
                             AND tmp.ProdColorPatternId > 0
                          );

   -- если это Boat Structure
   IF vbProdColorPatternId > 0
   THEN
       IF inIsErased = TRUE
       THEN
           -- восстанавливаем в Items Boat Structure - из Шаблона
           PERFORM gpInsertUpdate_Object_ProdColorItems(ioId                     := tmp.Id
                                                      , inCode                   := tmp.Code
                                                      , inProductId              := (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = inObjectId AND OL.DescId   = zc_ObjectLink_ProdOptItems_Product())
                                                      , inGoodsId                := tmp.GoodsId_Receipt
                                                      , inProdColorPatternId     := tmp.ProdColorPatternId
                                                      , inMovementId_OrderClient := tmp.MovementId_OrderClient
                                                      , inComment                := '' :: TVarChar
                                                      , inIsEnabled              := TRUE :: Boolean
                                                      , ioIsProdOptions          := FALSE
                                                      , inSession                := inSession
                                                      )
                                                      
           FROM gpSelect_Object_ProdColorItems (FALSE,FALSE,FALSE, inSession) as tmp
           -- Лодка
           WHERE tmp.MovementId_OrderClient = (SELECT OFl.ValueData FROM ObjectFloat AS OFl WHERE OFl.ObjectId = inObjectId AND OFl.DescId   = zc_ObjectFloat_ProdOptItems_OrderClient()) :: Integer
             AND tmp.ProductId = (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = inObjectId AND OL.DescId   = zc_ObjectLink_ProdOptItems_Product())
             AND tmp.ProdColorPatternId = vbProdColorPatternId
          ;

       ELSE
           -- восстанавливаем в Items Boat Structure - Факт
           PERFORM gpInsertUpdate_Object_ProdColorItems(ioId                     := tmp.Id
                                                      , inCode                   := tmp.Code
                                                      , inProductId              := (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = inObjectId AND OL.DescId   = zc_ObjectLink_ProdOptItems_Product())
                                                      , inGoodsId                := (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = inObjectId AND OL.DescId   = zc_ObjectLink_ProdOptItems_Goods())
                                                      , inProdColorPatternId     := tmp.ProdColorPatternId
                                                      , inMovementId_OrderClient := tmp.MovementId_OrderClient
                                                      , inComment                := '' :: TVarChar
                                                      , inIsEnabled              := TRUE :: Boolean
                                                      , ioIsProdOptions          := CASE WHEN tmp.GoodsId_Receipt <> (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = inObjectId AND OL.DescId   = zc_ObjectLink_ProdOptItems_Goods()) THEN TRUE ELSE FALSE END
                                                      , inSession                := inSession
                                                      )
                                                      
           FROM gpSelect_Object_ProdColorItems (FALSE,FALSE,FALSE, inSession) as tmp
           -- Лодка
           WHERE tmp.MovementId_OrderClient = (SELECT OFl.ValueData FROM ObjectFloat AS OFl WHERE OFl.ObjectId = inObjectId AND OFl.DescId   = zc_ObjectFloat_ProdOptItems_OrderClient()) :: Integer
             AND tmp.ProductId = (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = inObjectId AND OL.DescId   = zc_ObjectLink_ProdOptItems_Product())
             AND tmp.ProdColorPatternId = vbProdColorPatternId
          ;

       END IF;
       
   END IF;
   
   -- изменили
   PERFORM lpUpdate_Object_isErased (inObjectId:= inObjectId, inIsErased:=inIsErased, inUserId:= vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.10.20         *
*/
