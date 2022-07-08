-- Function: gpSelect_Object_ProdModel()

DROP FUNCTION IF EXISTS gpSelect_Object_ProdModel (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ProdModel(
    IN inIsShowAll   Boolean,            -- признак показать удаленные да / нет 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, Name_full TVarChar
             , Length TFloat, Beam TFloat, Height TFloat, Weight TFloat, Fuel TFloat, Speed TFloat, Seating TFloat
             , PatternCIN TVarChar, Comment TVarChar
             , BrandId Integer, BrandName TVarChar
             , ProdEngineId Integer, ProdEngineName TVarChar
             , ReceiptProdModelId Integer, ReceiptProdModelName TVarChar
             , ColorPatternId Integer, ColorPatternName TVarChar
             , InsertName TVarChar
             , InsertDate TDateTime
             , isErased boolean
) AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ProdModel());
   vbUserId:= lpGetUserBySession (inSession);

     RETURN QUERY
     WITH tmpReceiptProdModel AS (SELECT ObjectLink_Model.ChildObjectId    AS ModelId
                                       , Object_ReceiptProdModel.Id        AS ReceiptProdModelId
                                       , Object_ReceiptProdModel.ValueData AS ReceiptProdModelName
                                  FROM Object AS Object_ReceiptProdModel
                                     INNER JOIN ObjectBoolean AS ObjectBoolean_Main
                                                              ON ObjectBoolean_Main.ObjectId = Object_ReceiptProdModel.Id
                                                             AND ObjectBoolean_Main.DescId = zc_ObjectBoolean_ReceiptProdModel_Main()
                                                             AND ObjectBoolean_Main.ValueData = TRUE

                                     LEFT JOIN ObjectLink AS ObjectLink_Model
                                                          ON ObjectLink_Model.ObjectId = Object_ReceiptProdModel.Id
                                                         AND ObjectLink_Model.DescId = zc_ObjectLink_ReceiptProdModel_Model()
                                     LEFT JOIN Object AS Object_Model ON Object_Model.Id = ObjectLink_Model.ChildObjectId
                                  WHERE Object_ReceiptProdModel.DescId = zc_Object_ReceiptProdModel()
                                    AND Object_ReceiptProdModel.isErased = FALSE
                                 )


     SELECT 
           Object_ProdModel.Id             AS Id 
         , Object_ProdModel.ObjectCode     AS Code
         , Object_ProdModel.ValueData      AS Name
         , (Object_ProdModel.ValueData ||' (' || Object_Brand.ValueData||')') ::TVarChar AS Name_full

         , ObjectFloat_Length.ValueData    AS Length
         , ObjectFloat_Beam.ValueData      AS Beam
         , ObjectFloat_Height.ValueData    AS Height
         , ObjectFloat_Weight.ValueData    AS Weight
         , ObjectFloat_Fuel.ValueData      AS Fuel
         , ObjectFloat_Speed.ValueData     AS Speed
         , ObjectFloat_Seating.ValueData   AS Seating
         , ObjectString_PatternCIN.ValueData  AS PatternCIN
         , ObjectString_Comment.ValueData  AS Comment
         
         , Object_Brand.Id                 AS BrandId
         , Object_Brand.ValueData          AS BrandName
         , Object_ProdEngine.Id            AS ProdEngineId
         , Object_ProdEngine.ValueData     AS ProdEngineName

         , tmpReceiptProdModel.ReceiptProdModelId
         , tmpReceiptProdModel.ReceiptProdModelName

         , Object_ColorPattern.Id        :: Integer   AS ColorPatternId
         , Object_ColorPattern.ValueData :: TVarChar  AS ColorPatternName

         , Object_Insert.ValueData         AS InsertName
         , ObjectDate_Insert.ValueData     AS InsertDate
         , Object_ProdModel.isErased       AS isErased
         
     FROM Object AS Object_ProdModel
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_ProdModel.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_ProdModel_Comment()  

          LEFT JOIN ObjectString AS ObjectString_PatternCIN
                                 ON ObjectString_PatternCIN.ObjectId = Object_ProdModel.Id
                                AND ObjectString_PatternCIN.DescId = zc_ObjectString_ProdModel_PatternCIN()

          LEFT JOIN ObjectFloat AS ObjectFloat_Length
                                ON ObjectFloat_Length.ObjectId = Object_ProdModel.Id
                               AND ObjectFloat_Length.DescId = zc_ObjectFloat_ProdModel_Length()

          LEFT JOIN ObjectFloat AS ObjectFloat_Beam
                                ON ObjectFloat_Beam.ObjectId = Object_ProdModel.Id
                               AND ObjectFloat_Beam.DescId = zc_ObjectFloat_ProdModel_Beam()

          LEFT JOIN ObjectFloat AS ObjectFloat_Height
                                ON ObjectFloat_Height.ObjectId = Object_ProdModel.Id
                               AND ObjectFloat_Height.DescId = zc_ObjectFloat_ProdModel_Height()

          LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                ON ObjectFloat_Weight.ObjectId = Object_ProdModel.Id
                               AND ObjectFloat_Weight.DescId = zc_ObjectFloat_ProdModel_Weight()

          LEFT JOIN ObjectFloat AS ObjectFloat_Fuel
                                ON ObjectFloat_Fuel.ObjectId = Object_ProdModel.Id
                               AND ObjectFloat_Fuel.DescId = zc_ObjectFloat_ProdModel_Fuel()

          LEFT JOIN ObjectFloat AS ObjectFloat_Speed
                                ON ObjectFloat_Speed.ObjectId = Object_ProdModel.Id
                               AND ObjectFloat_Speed.DescId = zc_ObjectFloat_ProdModel_Speed()

          LEFT JOIN ObjectFloat AS ObjectFloat_Seating
                                ON ObjectFloat_Seating.ObjectId = Object_ProdModel.Id
                               AND ObjectFloat_Seating.DescId = zc_ObjectFloat_ProdModel_Seating()

          LEFT JOIN ObjectLink AS ObjectLink_Brand
                               ON ObjectLink_Brand.ObjectId = Object_ProdModel.Id
                              AND ObjectLink_Brand.DescId = zc_ObjectLink_ProdModel_Brand()
          LEFT JOIN Object AS Object_Brand ON Object_Brand.Id = ObjectLink_Brand.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_ProdEngine
                               ON ObjectLink_ProdEngine.ObjectId = Object_ProdModel.Id
                              AND ObjectLink_ProdEngine.DescId = zc_ObjectLink_ProdModel_ProdEngine()
          LEFT JOIN Object AS Object_ProdEngine ON Object_ProdEngine.Id = ObjectLink_ProdEngine.ChildObjectId

          LEFT JOIN tmpReceiptProdModel ON tmpReceiptProdModel.ModelId = Object_ProdModel.Id

          LEFT JOIN ObjectLink AS ObjectLink_Insert
                               ON ObjectLink_Insert.ObjectId = Object_ProdModel.Id
                              AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
          LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId 

          LEFT JOIN ObjectDate AS ObjectDate_Insert
                               ON ObjectDate_Insert.ObjectId = Object_ProdModel.Id
                              AND ObjectDate_Insert.DescId = zc_ObjectDate_Protocol_Insert()

          LEFT JOIN ObjectLink AS ObjectLink_ColorPattern
                               ON ObjectLink_ColorPattern.ChildObjectId = Object_ProdModel.Id
                              AND ObjectLink_ColorPattern.DescId = zc_ObjectLink_ColorPattern_Model()
          LEFT JOIN Object AS Object_ColorPattern ON Object_ColorPattern.Id = ObjectLink_ColorPattern.ObjectId

     WHERE Object_ProdModel.DescId = zc_Object_ProdModel()
      AND (Object_ProdModel.isErased = FALSE OR inIsShowAll = TRUE);  

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 07.07.22         * ColorPattern
 11.01.21         * PatternCIN
 24.11.20         * add Brand
 08.10.20         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_ProdModel (false, zfCalc_UserAdmin())
