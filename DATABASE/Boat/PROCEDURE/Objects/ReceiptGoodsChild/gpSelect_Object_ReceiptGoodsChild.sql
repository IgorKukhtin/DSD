-- Function: gpSelect_Object_ReceiptGoodsChild()

DROP FUNCTION IF EXISTS gpSelect_Object_ReceiptGoodsChild (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ReceiptGoodsChild(
    IN inIsErased    Boolean,       -- признак показать удаленные да / нет 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, NPP Integer, Comment TVarChar
             , Value TFloat
             , ReceiptGoodsId Integer, ReceiptGoodsName TVarChar
             , GoodsId Integer, GoodsName TVarChar
             , InsertName TVarChar, UpdateName TVarChar
             , InsertDate TDateTime, UpdateDate TDateTime
             , isErased Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ReceiptGoodsChild());
   vbUserId:= lpGetUserBySession (inSession);

     RETURN QUERY

     SELECT 
           Object_ReceiptGoodsChild.Id              AS Id
         , ROW_NUMBER() OVER (PARTITION BY Object_ReceiptGoods.Id ORDER BY Object_ReceiptGoodsChild.Id ASC) :: Integer AS NPP
         , Object_ReceiptGoodsChild.ValueData       AS Comment

         , ObjectFloat_Value.ValueData   ::TFloat   AS Value

         , Object_ReceiptGoods.Id        ::Integer  AS ReceiptGoodsId
         , Object_ReceiptGoods.ValueData ::TVarChar AS ReceiptGoodsName

         , Object_Goods.Id               ::Integer  AS GoodsId
         , Object_Goods.ValueData        ::TVarChar AS GoodsName

         , Object_Insert.ValueData                  AS InsertName
         , Object_Update.ValueData                  AS UpdateName
         , ObjectDate_Insert.ValueData              AS InsertDate
         , ObjectDate_Update.ValueData              AS UpdateDate
         , Object_ReceiptGoodsChild.isErased        AS isErased
         
     FROM Object AS Object_ReceiptGoodsChild

          LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                ON ObjectFloat_Value.ObjectId = Object_ReceiptGoodsChild.Id
                               AND ObjectFloat_Value.DescId = zc_ObjectFloat_ReceiptGoodsChild_Value() 

          LEFT JOIN ObjectLink AS ObjectLink_ReceiptGoods
                               ON ObjectLink_ReceiptGoods.ObjectId = Object_ReceiptGoodsChild.Id
                              AND ObjectLink_ReceiptGoods.DescId = zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods()
          LEFT JOIN Object AS Object_ReceiptGoods ON Object_ReceiptGoods.Id = ObjectLink_ReceiptGoods.ChildObjectId 

          LEFT JOIN ObjectLink AS ObjectLink_Goods
                               ON ObjectLink_Goods.ObjectId = Object_ReceiptGoodsChild.Id
                              AND ObjectLink_Goods.DescId = zc_ObjectLink_ReceiptGoodsChild_Goods()
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Goods.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Insert
                               ON ObjectLink_Insert.ObjectId = Object_ReceiptGoodsChild.Id
                              AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
          LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId 

          LEFT JOIN ObjectLink AS ObjectLink_Update
                               ON ObjectLink_Update.ObjectId = Object_ReceiptGoodsChild.Id
                              AND ObjectLink_Update.DescId = zc_ObjectLink_Protocol_Update()
          LEFT JOIN Object AS Object_Update ON Object_Update.Id = ObjectLink_Update.ChildObjectId 

          LEFT JOIN ObjectDate AS ObjectDate_Insert
                               ON ObjectDate_Insert.ObjectId = Object_ReceiptGoodsChild.Id
                              AND ObjectDate_Insert.DescId = zc_ObjectDate_Protocol_Insert()

          LEFT JOIN ObjectDate AS ObjectDate_Update
                               ON ObjectDate_Update.ObjectId = Object_ReceiptGoodsChild.Id
                              AND ObjectDate_Update.DescId = zc_ObjectDate_Protocol_Update()

     WHERE Object_ReceiptGoodsChild.DescId = zc_Object_ReceiptGoodsChild()
      AND (Object_ReceiptGoodsChild.isErased = FALSE OR inIsErased = TRUE)
     ;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.12.20         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_ReceiptGoodsChild (false, zfCalc_UserAdmin())
