-- Function: gpGet_Object_ProdOptions()

DROP FUNCTION IF EXISTS gpGet_Object_ProdOptions(Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Object_ProdOptions(Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Object_ProdOptions(Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ProdOptions(
    IN inId          Integer,       -- �������� ����� 
    IN inMaskId      Integer   ,    -- id ��� �����������
    IN inProModelId  Integer,       -- ������
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , ModelId Integer, ModelName TVarChar
             , BrandId Integer, BrandName TVarChar
             , ProdEngineId Integer, ProdEngineName TVarChar
             , GoodsId Integer, GoodsName TVarChar
             , TaxKindId Integer, TaxKindName TVarChar
             , SalePrice TFloat, Amount TFloat
             , Comment TVarChar
             , ProdColorPatternId Integer, ProdColorPatternName TVarChar
             , ColorPatternId Integer, ColorPatternName TVarChar
             , MaterialOptionsId    Integer
             , MaterialOptionsName  TVarChar
             , Id_Site              TVarChar
             , CodeVergl            Integer

             ) AS
$BODY$
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_ProdOptions());

   IF ((COALESCE (inId, 0) = 0) AND (COALESCE (inMaskId, 0) = 0))
   THEN
       RETURN QUERY
       SELECT
             CAST (0 as Integer)      AS Id
           , lfGet_ObjectCode (0, zc_Object_ProdOptions()) AS Code
           , CAST ('' as TVarChar)    AS NAME

           , Object_Model.Id         ::Integer  AS ModelId
           , Object_Model.ValueData  ::TVarChar AS ModelName
           , Object_Brand.Id                    AS BrandId
           , Object_Brand.ValueData             AS BrandName
           , Object_ProdEngine.Id               AS ProdEngineId
           , Object_ProdEngine.ValueData        AS ProdEngineName
           , 0  :: Integer            AS GoodsId
           , '' :: TVarChar           AS GoodsName

           , Object_TaxKind.Id        AS TaxKindId
           , Object_TaxKind.ValueData AS TaxKindName

           , CAST (0 AS TFloat)       AS SalePrice
           , CAST (0 AS TFloat)       AS Amount
           , CAST ('' AS TVarChar)    AS Comment

           , 0  :: Integer            AS ProdColorPatternId
           , '' :: TVarChar           AS ProdColorPatternName
           , Object_ColorPattern.Id        :: Integer   AS ColorPatternId
           , Object_ColorPattern.ValueData :: TVarChar  AS ColorPatternName
           , 0  :: Integer            AS MaterialOptionsId
           , '' :: TVarChar           AS MaterialOptionsName
           , '' :: TVarChar           AS Id_Site
           , CAST (0 AS Integer)   AS CodeVergl
       FROM Object AS Object_TaxKind
           LEFT JOIN Object AS Object_Model ON Object_Model.Id = inProModelId

           LEFT JOIN ObjectLink AS ObjectLink_Brand
                                ON ObjectLink_Brand.ObjectId = Object_Model.Id
                               AND ObjectLink_Brand.DescId = zc_ObjectLink_ProdModel_Brand()
           LEFT JOIN Object AS Object_Brand ON Object_Brand.Id = ObjectLink_Brand.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_ProdEngine
                                ON ObjectLink_ProdEngine.ObjectId = Object_Model.Id
                               AND ObjectLink_ProdEngine.DescId = zc_ObjectLink_ProdModel_ProdEngine()
           LEFT JOIN Object AS Object_ProdEngine ON Object_ProdEngine.Id = ObjectLink_ProdEngine.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_ColorPattern
                                ON ObjectLink_ColorPattern.ChildObjectId = Object_Model.Id
                               AND ObjectLink_ColorPattern.DescId = zc_ObjectLink_ColorPattern_Model()
           LEFT JOIN Object AS Object_ColorPattern ON Object_ColorPattern.Id = ObjectLink_ColorPattern.ObjectId

       WHERE Object_TaxKind.Id = zc_Enum_TaxKind_Basis()
      ;

   ELSE
     RETURN QUERY
     SELECT
           CASE WHEN inMaskId <> 0 THEN 0 ELSE Object_ProdOptions.Id END ::Integer AS Id
         , CASE WHEN inMaskId <> 0 THEN lfGet_ObjectCode (0, zc_Object_ProdOptions()) ELSE Object_ProdOptions.ObjectCode END ::Integer AS Code
         , Object_ProdOptions.ValueData       AS Name

         , Object_Model.Id         ::Integer  AS ModelId
         , Object_Model.ValueData  ::TVarChar AS ModelName
         , Object_Brand.Id                    AS BrandId
         , Object_Brand.ValueData             AS BrandName
         , Object_ProdEngine.Id               AS ProdEngineId
         , Object_ProdEngine.ValueData        AS ProdEngineName

         , Object_Goods.Id         ::Integer  AS GoodsId
         , Object_Goods.ValueData  ::TVarChar AS GoodsName

         , Object_TaxKind.Id                  AS TaxKindId
         , Object_TaxKind.ValueData           AS TaxKindName


         , ObjectFloat_SalePrice.ValueData    AS SalePrice
         , ObjectFloat_Amount.ValueData       AS Amount
         , ObjectString_Comment.ValueData     AS Comment

         , Object_ProdColorPattern.Id        :: Integer   AS ProdColorPatternId
         , zfCalc_ProdColorPattern_isErased (Object_ProdColorGroup.ValueData, Object_ProdColorPattern.ValueData, Object_Model_pcp.ValueData, Object_ProdColorPattern.isErased) :: TVarChar AS ProdColorPatternName

         , Object_ColorPattern.Id        :: Integer   AS ColorPatternId
         , Object_ColorPattern.ValueData :: TVarChar  AS ColorPatternName

         , Object_MaterialOptions.Id        :: Integer   AS MaterialOptionsId
         , Object_MaterialOptions.ValueData :: TVarChar  AS MaterialOptionsName

         , ObjectString_Id_Site.ValueData   :: TVarChar  AS Id_Site
         , ObjectFloat_CodeVergl.ValueData  :: Integer   AS CodeVergl

     FROM Object AS Object_ProdOptions
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_ProdOptions.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_ProdOptions_Comment()

          LEFT JOIN ObjectString AS ObjectString_Id_Site
                                 ON ObjectString_Id_Site.ObjectId = Object_ProdOptions.Id
                                AND ObjectString_Id_Site.DescId = zc_ObjectString_Id_Site()

          LEFT JOIN ObjectFloat AS ObjectFloat_SalePrice
                                ON ObjectFloat_SalePrice.ObjectId = Object_ProdOptions.Id
                               AND ObjectFloat_SalePrice.DescId = zc_ObjectFloat_ProdOptions_SalePrice()
          LEFT JOIN ObjectFloat AS ObjectFloat_Amount
                                ON ObjectFloat_Amount.ObjectId = Object_ProdOptions.Id
                               AND ObjectFloat_Amount.DescId = zc_ObjectFloat_ProdOptions_Amount()

          LEFT JOIN ObjectFloat AS ObjectFloat_CodeVergl
                                ON ObjectFloat_CodeVergl.ObjectId = Object_ProdOptions.Id
                               AND ObjectFloat_CodeVergl.DescId = zc_ObjectFloat_ProdOptions_CodeVergl()

          LEFT JOIN ObjectLink AS ObjectLink_Goods
                               ON ObjectLink_Goods.ObjectId = Object_ProdOptions.Id
                              AND ObjectLink_Goods.DescId = zc_ObjectLink_ProdOptions_Goods()
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Goods.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Model
                               ON ObjectLink_Model.ObjectId = Object_ProdOptions.Id
                              AND ObjectLink_Model.DescId   = zc_ObjectLink_ProdOptions_Model()
          LEFT JOIN Object AS Object_Model ON Object_Model.Id = ObjectLink_Model.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_TaxKind
                               ON ObjectLink_TaxKind.ObjectId = Object_ProdOptions.Id
                              AND ObjectLink_TaxKind.DescId = zc_ObjectLink_ProdOptions_TaxKind()
          LEFT JOIN Object AS Object_TaxKind ON Object_TaxKind.Id = ObjectLink_TaxKind.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Brand
                               ON ObjectLink_Brand.ObjectId = Object_Model.Id
                              AND ObjectLink_Brand.DescId = zc_ObjectLink_ProdModel_Brand()
          LEFT JOIN Object AS Object_Brand ON Object_Brand.Id = ObjectLink_Brand.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_ProdEngine
                               ON ObjectLink_ProdEngine.ObjectId = Object_Model.Id
                              AND ObjectLink_ProdEngine.DescId = zc_ObjectLink_ProdModel_ProdEngine()
          LEFT JOIN Object AS Object_ProdEngine ON Object_ProdEngine.Id = ObjectLink_ProdEngine.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_MaterialOptions
                               ON ObjectLink_MaterialOptions.ObjectId = Object_ProdOptions.Id
                              AND ObjectLink_MaterialOptions.DescId = zc_ObjectLink_ProdOptions_MaterialOptions()
          LEFT JOIN Object AS Object_MaterialOptions ON Object_MaterialOptions.Id = ObjectLink_MaterialOptions.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_ProdColorPattern
                               ON ObjectLink_ProdColorPattern.ObjectId = Object_ProdOptions.Id
                              AND ObjectLink_ProdColorPattern.DescId = zc_ObjectLink_ProdOptions_ProdColorPattern()
          LEFT JOIN Object AS Object_ProdColorPattern ON Object_ProdColorPattern.Id = ObjectLink_ProdColorPattern.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_ColorPattern
                               ON ObjectLink_ColorPattern.ObjectId = Object_ProdColorPattern.Id
                              AND ObjectLink_ColorPattern.DescId   = zc_ObjectLink_ProdColorPattern_ColorPattern()
          LEFT JOIN Object AS Object_ColorPattern ON Object_ColorPattern.Id = ObjectLink_ColorPattern.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_ProdColorGroup
                               ON ObjectLink_ProdColorGroup.ObjectId = ObjectLink_ProdColorPattern.ChildObjectId
                              AND ObjectLink_ProdColorGroup.DescId = zc_ObjectLink_ProdColorPattern_ProdColorGroup()
          LEFT JOIN Object AS Object_ProdColorGroup ON Object_ProdColorGroup.Id = ObjectLink_ProdColorGroup.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_ColorPattern_Model
                               ON ObjectLink_ColorPattern_Model.ObjectId = ObjectLink_ColorPattern.ChildObjectId
                              AND ObjectLink_ColorPattern_Model.DescId = zc_ObjectLink_ColorPattern_Model()
          LEFT JOIN Object AS Object_Model_pcp ON Object_Model_pcp.Id = ObjectLink_ColorPattern_Model.ChildObjectId

       WHERE Object_ProdOptions.Id = CASE WHEN COALESCE (inId, 0) = 0 THEN COALESCE (inMaskId,0) ELSE inId END;

   END IF;

END;
$BODY$
LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 29.05.23         *
 06.07.22         *
 22.06.22         *
 25.12.20         *
 08.10.20         *
*/

-- ����
-- SELECT * FROM gpGet_Object_ProdOptions (0, 0, 0, zfCalc_UserAdmin())
