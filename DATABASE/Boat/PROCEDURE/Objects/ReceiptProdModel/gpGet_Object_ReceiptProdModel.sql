-- Function: gpGet_Object_ReceiptProdModel()

DROP FUNCTION IF EXISTS gpGet_Object_ReceiptProdModel (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ReceiptProdModel(
    IN inId          Integer ,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , UserCode TVarChar, Comment TVarChar
             , isMain Boolean
             , ModelId Integer, ModelName TVarChar
             , UnitId Integer, UnitName TVarChar             
) AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ReceiptProdModel());
   vbUserId:= lpGetUserBySession (inSession);

  IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
              0 :: Integer            AS Id
           , lfGet_ObjectCode(0, zc_Object_ReceiptProdModel())   AS Code
           , '' :: TVarChar           AS Name
           , '' :: TVarChar           AS UserCode
           , '' :: TVarChar           AS Comment
           , TRUE :: Boolean          AS isMain
           , 0  :: Integer            AS ModelId
           , '' :: TVarChar           AS ModelName
           , 0  ::Integer             AS UnitId
           , '' ::TVarChar            AS UnitName
       ;
   ELSE
     RETURN QUERY

     SELECT 
           Object_ReceiptProdModel.Id         AS Id 
         , Object_ReceiptProdModel.ObjectCode AS Code
         , Object_ReceiptProdModel.ValueData  AS Name

         , ObjectString_Code.ValueData        ::TVarChar  AS UserCode
         , ObjectString_Comment.ValueData     ::TVarChar  AS Comment
         , ObjectBoolean_Main.ValueData       ::Boolean   AS isMain

         , Object_Model.Id                    ::Integer  AS ModelId
         , Object_Model.ValueData             ::TVarChar AS ModelName  
         , Object_Unit.Id                     ::Integer  AS UnitId
         , Object_Unit.ValueData              ::TVarChar AS UnitName
     FROM Object AS Object_ReceiptProdModel
          LEFT JOIN ObjectString AS ObjectString_Code
                                 ON ObjectString_Code.ObjectId = Object_ReceiptProdModel.Id
                                AND ObjectString_Code.DescId = zc_ObjectString_ReceiptProdModel_Code()  
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_ReceiptProdModel.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_ReceiptProdModel_Comment()  

          LEFT JOIN ObjectBoolean AS ObjectBoolean_Main
                                  ON ObjectBoolean_Main.ObjectId = Object_ReceiptProdModel.Id
                                 AND ObjectBoolean_Main.DescId = zc_ObjectBoolean_ReceiptProdModel_Main() 

          LEFT JOIN ObjectLink AS ObjectLink_Model
                               ON ObjectLink_Model.ObjectId = Object_ReceiptProdModel.Id
                              AND ObjectLink_Model.DescId = zc_ObjectLink_ReceiptProdModel_Model()
          LEFT JOIN Object AS Object_Model ON Object_Model.Id = ObjectLink_Model.ChildObjectId 

          LEFT JOIN ObjectLink AS ObjectLink_Unit
                               ON ObjectLink_Unit.ObjectId = Object_ReceiptProdModel.Id
                              AND ObjectLink_Unit.DescId = zc_ObjectLink_ReceiptProdModel_Unit()
          LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Unit.ChildObjectId
     WHERE Object_ReceiptProdModel.DescId = zc_Object_ReceiptProdModel()
      AND Object_ReceiptProdModel.Id = inId
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
-- SELECT * FROM gpGet_Object_ReceiptProdModel (0, zfCalc_UserAdmin())
