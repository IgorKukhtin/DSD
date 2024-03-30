
-- Function: gpGet_Object_ProdModel()

DROP FUNCTION IF EXISTS gpGet_Object_ProdModel(Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Object_ProdModel(Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ProdModel(
    IN inId          Integer,       -- Основные средства 
    IN inPriceListId Integer,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Length TFloat, Beam TFloat, Height TFloat
             , Weight TFloat, Fuel TFloat, Speed TFloat, Seating TFloat
             , PatternCIN TVarChar, Comment TVarChar
             , BrandId Integer, BrandName TVarChar
             , ProdEngineId Integer, ProdEngineName TVarChar  
             , ReceiptProdModelId Integer, ReceiptProdModelName TVarChar
             , BasisPrice TFloat, StartDate_price TDateTime
             ) AS
$BODY$BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_ProdModel());
   
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_ProdModel())   AS Code
           , CAST ('' as TVarChar)  AS NAME
           
           , CAST (0 AS TFloat)     AS Length
           , CAST (0 AS TFloat)     AS Beam
           , CAST (0 AS TFloat)     AS Height
           , CAST (0 AS TFloat)     AS Weight
           , CAST (0 AS TFloat)     AS Fuel
           , CAST (0 AS TFloat)     AS Speed
           , CAST (0 AS TFloat)     AS Seating
           , CAST ('' AS TVarChar)  AS PatternCIN
           , CAST ('' AS TVarChar)  AS Comment
           , CAST (0  AS Integer)   AS BrandId
           , CAST ('' AS TVarChar)  AS BrandName
           , CAST (0  AS Integer)   AS ProdEngineId
           , CAST ('' AS TVarChar)  AS ProdEngineName 
           , CAST (0  AS Integer)   AS ReceiptProdModelId
           , CAST ('' AS TVarChar)  AS ReceiptProdModelName
           , CAST (0 AS TFloat)     AS BasisPrice
           , CAST (Null AS TDateTime) AS StartDate_price
          ;
   ELSE
     RETURN QUERY 
     WITH
     tmpReceiptProdModel AS (SELECT ObjectLink_Model.ChildObjectId    AS ModelId
                                  , Object_ReceiptProdModel.Id        AS ReceiptProdModelId
                                  , Object_ReceiptProdModel.ValueData AS ReceiptProdModelName
                                  , COALESCE (tmpPriceBasis.ValuePrice, 0) AS BasisPrice 
                                  , tmpPriceBasis.StartDate                AS StartDate_price
                             FROM ObjectLink AS ObjectLink_Model
                                  INNER JOIN ObjectBoolean AS ObjectBoolean_Main
                                                           ON ObjectBoolean_Main.ObjectId = ObjectLink_Model.ObjectId
                                                          AND ObjectBoolean_Main.DescId = zc_ObjectBoolean_ReceiptProdModel_Main()
                                                          AND ObjectBoolean_Main.ValueData = TRUE   
                                   INNER JOIN Object AS Object_ReceiptProdModel ON Object_ReceiptProdModel.Id = ObjectLink_Model.ObjectId
                                                                               AND Object_ReceiptProdModel.isErased = false
                                  LEFT JOIN  lpGet_ObjectHistory_PriceListItem (CURRENT_DATE, inPriceListId, ObjectLink_Model.ObjectId) AS tmpPriceBasis ON tmpPriceBasis.GoodsId = ObjectLink_Model.ObjectId  

                             WHERE ObjectLink_Model.ChildObjectId = inId     --ObjectLink_Model.ObjectId = Object_ReceiptProdModel.Id
                               AND ObjectLink_Model.DescId = zc_ObjectLink_ReceiptProdModel_Model()
                             LIMIT 1 
                            )


     SELECT 
           Object_ProdModel.Id             AS Id 
         , Object_ProdModel.ObjectCode     AS Code
         , Object_ProdModel.ValueData      AS Name

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
         , tmpReceiptProdModel.BasisPrice      ::TFloat
         , tmpReceiptProdModel.StartDate_price ::TDateTime         
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
          --
          LEFT JOIN tmpReceiptProdModel ON tmpReceiptProdModel.ModelId = Object_ProdModel.Id


       WHERE Object_ProdModel.Id = inId;
   END IF;
   
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 30.03.24         *
 11.01.21         * PatternCIN
 24.11.20         * add Brand
 08.10.20         *
*/

-- тест
-- SELECT * FROM gpGet_Object_ProdModel(1903, 2773, '2')