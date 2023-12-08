-- Function: gpGet_Movement_Income()

DROP FUNCTION IF EXISTS gpGet_MovementItem_Invoice (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MovementItem_Invoice(
    IN inId             Integer  , -- ключ 
    IN inSession        TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar 
             , Article        TVarChar
             , PartnerId Integer, PartnerName TVarChar
             , Amount         TFloat
             , OperPrice      TFloat
             , Comment        TVarChar
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

   IF COALESCE (inId, 0) = 0
   THEN
   RETURN QUERY
       SELECT
             CAST (0 as Integer)    AS Id
           , CAST (0 as Integer)    AS GoodsId
           , CAST (0 as Integer)    AS GoodsCode
           , CAST ('' as TVarChar)  AS GoodsName
           , CAST ('' as TVarChar)  AS Article 
           , CAST (0 as Integer)    AS PartnerId
           , CAST ('' as TVarChar)  AS PartnerName
           , CAST (0 as TFloat)     AS Amount
           , CAST (0 as TFloat)     AS OperPrice
           , CAST ('' as TVarChar)  AS Comment;
   ELSE
         RETURN QUERY
           -- Результат
           SELECT
                 MovementItem.Id                AS Id
               , MovementItem.ObjectId          AS GoodsId
               , Object_Goods.ObjectCode        AS GoodsCode
               , Object_Goods.ValueData         AS GoodsName 
               , ObjectString_Article.ValueData AS Article 
               , Object_Partner.Id              AS PartnerId
               , Object_Partner.ValueData       AS PartnerName
               , MovementItem.Amount                       ::TFloat   AS Amount
               , COALESCE (MIFloat_OperPrice.ValueData, 0) ::TFloat   AS OperPrice
               , COALESCE (MIString_Comment.ValueData, '') ::TVarChar AS Comment
           FROM MovementItem
                LEFT JOIN MovementItemFloat AS MIFloat_OperPrice
                                            ON MIFloat_OperPrice.MovementItemId = MovementItem.Id
                                           AND MIFloat_OperPrice.DescId = zc_MIFloat_OperPrice()

                LEFT JOIN MovementItemString AS MIString_Comment
                                             ON MIString_Comment.MovementItemId = MovementItem.Id
                                            AND MIString_Comment.DescId = zc_MIString_Comment()

                LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

                LEFT JOIN ObjectString AS ObjectString_Article
                                       ON ObjectString_Article.ObjectId = MovementItem.ObjectId
                                      AND ObjectString_Article.DescId   = zc_ObjectString_Article()

                LEFT JOIN ObjectLink AS ObjectLink_Goods_Partner
                                     ON ObjectLink_Goods_Partner.ObjectId = Object_Goods.Id
                                    AND ObjectLink_Goods_Partner.DescId = zc_ObjectLink_Goods_Partner()
                LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = ObjectLink_Goods_Partner.ChildObjectId
           WHERE MovementItem.Id = inId
             AND MovementItem.DescId = zc_MI_Master()
           ;
   END IF;
   
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР111
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 07.12.23         *
*/

-- тест
-- SELECT * FROM gpGet_MovementItem_Invoice (inId:= 0, inSession:= '5'::TVarChar);
