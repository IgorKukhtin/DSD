-- Function: gpGet_Object_ReceiptProdModelChild()

DROP FUNCTION IF EXISTS gpGet_Object_ReceiptProdModelChild (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ReceiptProdModelChild(
    IN inId          Integer ,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , Comment TVarChar
             , Value TFloat
             , ReceiptProdModelId Integer, ReceiptProdModelName TVarChar
             , ObjectId Integer, ObjectName TVarChar
) AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ReceiptProdModelChild());
   vbUserId:= lpGetUserBySession (inSession);

  IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
              0 :: Integer            AS Id
           , '' :: TVarChar           AS Comment
           , 0  :: TFloat             AS Value
           , 0  :: Integer            AS ReceiptProdModelId
           , '' :: TVarChar           AS ReceiptProdModelName
           , 0  :: Integer            AS ObjectId
           , '' :: TVarChar           AS ObjectName
       ;
   ELSE
     RETURN QUERY

     SELECT 
           Object_ReceiptProdModelChild.Id              AS Id 
         , Object_ReceiptProdModelChild.ValueData       AS Comment

         , ObjectFloat_Value.ValueData       ::TFloat   AS Value

         , Object_ReceiptProdModel.Id        ::Integer  AS ReceiptProdModelId
         , Object_ReceiptProdModel.ValueData ::TVarChar AS ReceiptProdModelName

         , Object_Object.Id                  ::Integer  AS ObjectId
         , Object_Object.ValueData           ::TVarChar AS ObjectName
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

     WHERE Object_ReceiptProdModelChild.DescId = zc_Object_ReceiptProdModelChild()
      AND Object_ReceiptProdModelChild.Id = inId
     ;
   END IF;
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.12.20         *
*/

-- тест
-- SELECT * FROM gpGet_Object_ReceiptProdModelChild (0, zfCalc_UserAdmin())