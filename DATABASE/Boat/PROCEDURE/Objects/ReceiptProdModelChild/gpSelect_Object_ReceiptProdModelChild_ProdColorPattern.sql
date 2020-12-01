-- Function: gpSelect_Object_ReceiptProdModelChild_ProdColorPattern()

DROP FUNCTION IF EXISTS gpSelect_Object_ReceiptProdModelChild_ProdColorPattern (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ReceiptProdModelChild_ProdColorPattern(
    IN inIsErased    Boolean,       -- признак показать удаленные да / нет 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Comment TVarChar
             , Value TFloat
             , ReceiptProdModelId Integer, ReceiptProdModelName TVarChar
             , ObjectId Integer, ObjectName TVarChar
             , InsertName TVarChar, UpdateName TVarChar
             , InsertDate TDateTime, UpdateDate TDateTime
             , isErased Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ReceiptProdModelChild());
   vbUserId:= lpGetUserBySession (inSession);

     RETURN QUERY

     SELECT 
           Object_ReceiptProdModelChild.Id              AS Id 
         , Object_ReceiptProdModelChild.ValueData       AS Comment

         , ObjectFloat_Value.ValueData       ::TFloat   AS Value

         , Object_ReceiptProdModel.Id        ::Integer  AS ReceiptProdModelId
         , Object_ReceiptProdModel.ValueData ::TVarChar AS ReceiptProdModelName

         , Object_Object.Id                  ::Integer  AS ObjectId
         , Object_Object.ValueData           ::TVarChar AS ObjectName

         , Object_Insert.ValueData                      AS InsertName
         , Object_Update.ValueData                      AS UpdateName
         , ObjectDate_Insert.ValueData                  AS InsertDate
         , ObjectDate_Update.ValueData                  AS UpdateDate
         , Object_ReceiptProdModelChild.isErased        AS isErased
         
     FROM Object AS Object_ReceiptProdModelChild

          LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                ON ObjectFloat_Value.ObjectId = Object_ReceiptProdModelChild.Id
                               AND ObjectFloat_Value.DescId = zc_ObjectFloat_ReceiptProdModelChild_Value() 

          LEFT JOIN ObjectLink AS ObjectLink_ReceiptProdModel
                               ON ObjectLink_ReceiptProdModel.ObjectId = Object_ReceiptProdModelChild.Id
                              AND ObjectLink_ReceiptProdModel.DescId = zc_ObjectLink_ReceiptProdModelChild_ReceiptProdModel()
          LEFT JOIN Object AS Object_ReceiptProdModel ON Object_ReceiptProdModel.Id = ObjectLink_ReceiptProdModel.ChildObjectId 

          LEFT JOIN ObjectLink AS ObjectLink_Object
                               ON ObjectLink_Object.ObjectId = Object_ReceiptProdModelChild.Id
                              AND ObjectLink_Object.DescId = zc_ObjectLink_ReceiptProdModelChild_Object()
          LEFT JOIN Object AS Object_Object ON Object_Object.Id = ObjectLink_Object.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Insert
                               ON ObjectLink_Insert.ObjectId = Object_ReceiptProdModelChild.Id
                              AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
          LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId 

          LEFT JOIN ObjectLink AS ObjectLink_Update
                               ON ObjectLink_Update.ObjectId = Object_ReceiptProdModelChild.Id
                              AND ObjectLink_Update.DescId = zc_ObjectLink_Protocol_Update()
          LEFT JOIN Object AS Object_Update ON Object_Update.Id = ObjectLink_Update.ChildObjectId 

          LEFT JOIN ObjectDate AS ObjectDate_Insert
                               ON ObjectDate_Insert.ObjectId = Object_ReceiptProdModelChild.Id
                              AND ObjectDate_Insert.DescId = zc_ObjectDate_Protocol_Insert()

          LEFT JOIN ObjectDate AS ObjectDate_Update
                               ON ObjectDate_Update.ObjectId = Object_ReceiptProdModelChild.Id
                              AND ObjectDate_Update.DescId = zc_ObjectDate_Protocol_Update()

     WHERE Object_ReceiptProdModelChild.DescId = zc_Object_ReceiptProdModelChild()
      AND (Object_ReceiptProdModelChild.isErased = FALSE OR inIsErased = TRUE)
      AND Object_Object.DescId = zc_Object_ProdColorPattern()
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
-- SELECT * FROM gpSelect_Object_ReceiptProdModelChild (false, zfCalc_UserAdmin())
