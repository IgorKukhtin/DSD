-- Function: gpGet_Object_Product()

DROP FUNCTION IF EXISTS gpGet_Object_Product(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Product(
    IN inId          Integer,       -- Основные средства
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Hours TFloat, DiscountTax TFloat, DiscountNextTax TFloat
             , DateStart TDateTime, DateBegin TDateTime, DateSale TDateTime
             , CIN TVarChar, EngineNum TVarChar
             , Comment TVarChar
             --, ProdGroupId Integer, ProdGroupName TVarChar
             , BrandId Integer, BrandName TVarChar
             , ModelId Integer, ModelName TVarChar, ModelName_full TVarChar
             , EngineId Integer, EngineName TVarChar
             , ReceiptProdModelId Integer, ReceiptProdModelName TVarChar
             , ClientId Integer, ClientName TVarChar
             , isBasicConf Boolean, isProdColorPattern Boolean
              ) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_Product());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
             CAST (0 as Integer)       AS Id
           , lfGet_ObjectCode(0, zc_Object_Product())   AS Code
           , CAST ('' as TVarChar)     AS Name

           , CAST (0 AS TFloat)        AS Hours
           , CAST (0 AS TFloat)        AS DiscountTax
           , CAST (0 AS TFloat)        AS DiscountNextTax
           , CAST (NULL AS TDateTime)  AS DateStart
           , CAST (NULL AS TDateTime)  AS DateBegin
           , CAST (NULL AS TDateTime)  AS DateSale
           , CAST ('' AS TVarChar)     AS CIN
           , CAST ('' AS TVarChar)     AS EngineNum
           , CAST ('' AS TVarChar)     AS Comment

          -- , CAST (0 AS Integer)    AS ProdGroupId
          -- , CAST ('' AS TVarChar)  AS ProdGroupName
           , CAST (0 AS Integer)       AS BrandId
           , CAST ('' AS TVarChar)     AS BrandName
           , CAST (0 AS Integer)       AS ModelId
           , CAST ('' AS TVarChar)     AS ModelName
           , CAST ('' AS TVarChar)     AS ModelName_full
           , CAST (0 AS Integer)       AS EngineId
           , CAST ('' AS TVarChar)     AS EngineName
           , CAST (0 AS Integer)       AS ReceiptProdModelId
           , CAST ('' AS TVarChar)     AS ReceiptProdModelName
           , CAST (0 AS Integer)       AS ClientId
           , CAST ('' AS TVarChar)     AS ClientName
           , CAST (TRUE AS Boolean)    AS isBasicConf
           , CAST (TRUE AS Boolean)    AS isProdColorPattern
       ;
   ELSE
     RETURN QUERY
     SELECT
           Object_Product.Id             AS Id
         , Object_Product.ObjectCode     AS Code
         , Object_Product.ValueData      AS Name

         , ObjectFloat_Hours.ValueData      AS Hours
         , ObjectFloat_DiscountTax.ValueData     AS DiscountTax
         , ObjectFloat_DiscountNextTax.ValueData AS DiscountNextTax
         , ObjectDate_DateStart.ValueData   AS DateStart
         , ObjectDate_DateBegin.ValueData   AS DateBegin
         , ObjectDate_DateSale.ValueData    AS DateSale
         , ObjectString_CIN.ValueData       AS CIN
         , ObjectString_EngineNum.ValueData AS EngineNum
         , ObjectString_Comment.ValueData   AS Comment

         --, Object_ProdGroup.Id             AS ProdGroupId
         --, Object_ProdGroup.ValueData      AS ProdGroupName

         , Object_Brand.Id                   AS BrandId
         , Object_Brand.ValueData            AS BrandName

         , Object_Model.Id                   AS ModelId
         , Object_Model.ValueData            AS ModelName
         , (Object_Model.ValueData ||' (' || Object_Brand_Model.ValueData||')') ::TVarChar AS ModelName_full

         , Object_Engine.Id                  AS EngineId
         , Object_Engine.ValueData           AS EngineName

         , Object_ReceiptProdModel.Id        AS ReceiptProdModelId
         , Object_ReceiptProdModel.ValueData AS ReceiptProdModelName

         , Object_Client.Id                  AS ClientId
         , Object_Client.ValueData           AS ClientName

         , COALESCE (ObjectBoolean_BasicConf.ValueData, FALSE) :: Boolean AS isBasicConf
         , CAST (FALSE AS Boolean)           AS isProdColorPattern

     FROM Object AS Object_Product
          LEFT JOIN ObjectBoolean AS ObjectBoolean_BasicConf
                                  ON ObjectBoolean_BasicConf.ObjectId = Object_Product.Id
                                 AND ObjectBoolean_BasicConf.DescId   = zc_ObjectBoolean_Product_BasicConf()

          LEFT JOIN ObjectFloat AS ObjectFloat_Hours
                                ON ObjectFloat_Hours.ObjectId = Object_Product.Id
                               AND ObjectFloat_Hours.DescId = zc_ObjectFloat_Product_Hours()

          LEFT JOIN ObjectFloat AS ObjectFloat_DiscountTax
                                ON ObjectFloat_DiscountTax.ObjectId = Object_Product.Id
                               AND ObjectFloat_DiscountTax.DescId = zc_ObjectFloat_Product_DiscountTax()
          LEFT JOIN ObjectFloat AS ObjectFloat_DiscountNextTax
                                ON ObjectFloat_DiscountNextTax.ObjectId = Object_Product.Id
                               AND ObjectFloat_DiscountNextTax.DescId = zc_ObjectFloat_Product_DiscountNextTax()

          LEFT JOIN ObjectDate AS ObjectDate_DateStart
                               ON ObjectDate_DateStart.ObjectId = Object_Product.Id
                              AND ObjectDate_DateStart.DescId = zc_ObjectDate_Product_DateStart()

          LEFT JOIN ObjectDate AS ObjectDate_DateBegin
                               ON ObjectDate_DateBegin.ObjectId = Object_Product.Id
                              AND ObjectDate_DateBegin.DescId = zc_ObjectDate_Product_DateBegin()

          LEFT JOIN ObjectDate AS ObjectDate_DateSale
                               ON ObjectDate_DateSale.ObjectId = Object_Product.Id
                              AND ObjectDate_DateSale.DescId = zc_ObjectDate_Product_DateSale()

          LEFT JOIN ObjectString AS ObjectString_CIN
                                 ON ObjectString_CIN.ObjectId = Object_Product.Id
                                AND ObjectString_CIN.DescId = zc_ObjectString_Product_CIN()

          LEFT JOIN ObjectString AS ObjectString_EngineNum
                                 ON ObjectString_EngineNum.ObjectId = Object_Product.Id
                                AND ObjectString_EngineNum.DescId = zc_ObjectString_Product_EngineNum()

          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_Product.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_Product_Comment()

          /*LEFT JOIN ObjectLink AS ObjectLink_ProdGroup
                               ON ObjectLink_ProdGroup.ObjectId = Object_Product.Id
                              AND ObjectLink_ProdGroup.DescId = zc_ObjectLink_Product_ProdGroup()
          LEFT JOIN Object AS Object_ProdGroup ON Object_ProdGroup.Id = ObjectLink_ProdGroup.ChildObjectId
          */

          LEFT JOIN ObjectLink AS ObjectLink_ReceiptProdModel
                               ON ObjectLink_ReceiptProdModel.ObjectId = Object_Product.Id
                              AND ObjectLink_ReceiptProdModel.DescId = zc_ObjectLink_Product_ReceiptProdModel()
          LEFT JOIN Object AS Object_ReceiptProdModel ON Object_ReceiptProdModel.Id = ObjectLink_ReceiptProdModel.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Brand
                               ON ObjectLink_Brand.ObjectId = Object_Product.Id
                              AND ObjectLink_Brand.DescId = zc_ObjectLink_Product_Brand()
          LEFT JOIN Object AS Object_Brand ON Object_Brand.Id = ObjectLink_Brand.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Client
                               ON ObjectLink_Client.ObjectId = Object_Product.Id
                              AND ObjectLink_Client.DescId = zc_ObjectLink_Product_Client()
          LEFT JOIN Object AS Object_Client ON Object_Client.Id = ObjectLink_Client.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Model
                               ON ObjectLink_Model.ObjectId = Object_Product.Id
                              AND ObjectLink_Model.DescId = zc_ObjectLink_Product_Model()
          LEFT JOIN Object AS Object_Model ON Object_Model.Id = ObjectLink_Model.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_ProdModel_Brand
                               ON ObjectLink_ProdModel_Brand.ObjectId = Object_Model.Id
                              AND ObjectLink_ProdModel_Brand.DescId = zc_ObjectLink_ProdModel_Brand()
          LEFT JOIN Object AS Object_Brand_Model ON Object_Brand_Model.Id = ObjectLink_ProdModel_Brand.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Engine
                               ON ObjectLink_Engine.ObjectId = Object_Product.Id
                              AND ObjectLink_Engine.DescId = zc_ObjectLink_Product_Engine()
          LEFT JOIN Object AS Object_Engine ON Object_Engine.Id = ObjectLink_Engine.ChildObjectId

       WHERE Object_Product.Id = inId;
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.01.21         *
 08.10.20         *
*/

-- тест
-- SELECT * FROM gpGet_Object_Product(0, '2')
