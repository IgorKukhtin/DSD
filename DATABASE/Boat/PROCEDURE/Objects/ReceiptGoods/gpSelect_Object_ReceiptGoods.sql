-- Function: gpSelect_Object_ReceiptGoods()

DROP FUNCTION IF EXISTS gpSelect_Object_ReceiptGoods (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ReceiptGoods(
    IN inIsErased    Boolean,       -- признак показать удаленные да / нет 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , UserCode TVarChar, Comment TVarChar
             , isMain Boolean
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
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ReceiptGoods());
   vbUserId:= lpGetUserBySession (inSession);

     RETURN QUERY

     SELECT 
           Object_ReceiptGoods.Id         AS Id 
         , Object_ReceiptGoods.ObjectCode AS Code
         , Object_ReceiptGoods.ValueData  AS Name

         , ObjectString_Code.ValueData        ::TVarChar  AS UserCode
         , ObjectString_Comment.ValueData     ::TVarChar  AS Comment
         , ObjectBoolean_Main.ValueData       ::Boolean   AS isMain

         , Object_Goods.Id         ::Integer  AS GoodsId
         , Object_Goods.ValueData  ::TVarChar AS GoodsName

         , Object_Insert.ValueData            AS InsertName
         , Object_Update.ValueData            AS UpdateName
         , ObjectDate_Insert.ValueData        AS InsertDate
         , ObjectDate_Update.ValueData        AS UpdateDate
         , Object_ReceiptGoods.isErased       AS isErased
         
     FROM Object AS Object_ReceiptGoods
          LEFT JOIN ObjectString AS ObjectString_Code
                                 ON ObjectString_Code.ObjectId = Object_ReceiptGoods.Id
                                AND ObjectString_Code.DescId = zc_ObjectString_ReceiptGoods_Code()  
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_ReceiptGoods.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_ReceiptGoods_Comment()  

          LEFT JOIN ObjectBoolean AS ObjectBoolean_Main
                                  ON ObjectBoolean_Main.ObjectId = Object_ReceiptGoods.Id
                                 AND ObjectBoolean_Main.DescId = zc_ObjectBoolean_ReceiptGoods_Main() 

          LEFT JOIN ObjectLink AS ObjectLink_Goods
                               ON ObjectLink_Goods.ObjectId = Object_ReceiptGoods.Id
                              AND ObjectLink_Goods.DescId = zc_ObjectLink_ReceiptGoods_Object()
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Goods.ChildObjectId 

          LEFT JOIN ObjectLink AS ObjectLink_Insert
                               ON ObjectLink_Insert.ObjectId = Object_ReceiptGoods.Id
                              AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
          LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId 

          LEFT JOIN ObjectLink AS ObjectLink_Update
                               ON ObjectLink_Update.ObjectId = Object_ReceiptGoods.Id
                              AND ObjectLink_Update.DescId = zc_ObjectLink_Protocol_Update()
          LEFT JOIN Object AS Object_Update ON Object_Update.Id = ObjectLink_Update.ChildObjectId 

          LEFT JOIN ObjectDate AS ObjectDate_Insert
                               ON ObjectDate_Insert.ObjectId = Object_ReceiptGoods.Id
                              AND ObjectDate_Insert.DescId = zc_ObjectDate_Protocol_Insert()

          LEFT JOIN ObjectDate AS ObjectDate_Update
                               ON ObjectDate_Update.ObjectId = Object_ReceiptGoods.Id
                              AND ObjectDate_Update.DescId = zc_ObjectDate_Protocol_Update()

     WHERE Object_ReceiptGoods.DescId = zc_Object_ReceiptGoods()
      AND (Object_ReceiptGoods.isErased = FALSE OR inIsErased = TRUE)
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
-- SELECT * FROM gpSelect_Object_ReceiptGoods (false, zfCalc_UserAdmin())
