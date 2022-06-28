-- Function: gpSelect_Object_ProdOptionsChoice()

DROP FUNCTION IF EXISTS gpSelect_Object_ProdOptionsChoice (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ProdOptionsChoice(
    IN inModelId     Integer,
    IN inIsShowAll   Boolean,
    IN inIsErased    Boolean,
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , ModelId Integer, ModelCode Integer, ModelName TVarChar
             , BrandId Integer, BrandName TVarChar
             , ProdEngineId Integer, ProdEngineName TVarChar
             , ProdColorPatternId Integer, ProdColorPatternName TVarChar
             , GoodsId Integer, GoodsId_choice Integer, GoodsCode Integer, GoodsName TVarChar
             , TaxKindId Integer, TaxKindName TVarChar, TaxKind_Value TFloat
             , EKPrice TFloat, EKPriceWVAT TFloat
             , BasisPrice TFloat, BasisPriceWVAT TFloat
             , SalePrice TFloat, SalePriceWVAT TFloat
             , Comment TVarChar
             , InsertName TVarChar
             , InsertDate TDateTime
             , isErased boolean
             , GoodsGroupNameFull TVarChar
             , GoodsGroupName TVarChar
             , Article TVarChar
             , ProdColorName TVarChar
             , MeasureName TVarChar
             , MaterialOptionsName TVarChar
             , Id_Site TVarChar
             , CodeVergl Integer
             , NPP Integer
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ProdOptions());
     vbUserId:= lpGetUserBySession (inSession);


     RETURN QUERY
     WITH -- �����, ������� ���������� ��� Boat Structure
          tmpSelect AS (SELECT *
                        FROM gpSelect_Object_ProdOptions (inModelId     := inModelId
                                                        , inIsErased    := inIsErased
                                                        , inSession     := inSession
                                                         )
                       )

     -- ���������
     SELECT
           MIN (tmpSelect.Id)    :: Integer  AS Id
         , MIN (tmpSelect.Code)  :: Integer  AS Code
         , tmpSelect.Name        :: TVarChar AS Name

         , tmpSelect.ModelId
         , tmpSelect.ModelCode
         , tmpSelect.ModelName
         , tmpSelect.BrandId
         , tmpSelect.BrandName
         , tmpSelect.ProdEngineId
         , tmpSelect.ProdEngineName


         , tmpSelect.ProdColorPatternId
         , tmpSelect.ProdColorPatternName

         , tmpSelect.GoodsId
         , tmpSelect.GoodsId_choice
         , tmpSelect.GoodsCode
         , tmpSelect.GoodsName

         , 0               AS TaxKindId
         , ''  :: TVarChar AS TaxKindName
         , 0   :: TFloat   AS TaxKind_Value

           -- ���� ��. ��� ��� - ������ �� ������
         , MAX (tmpSelect.EKPrice)        :: TFloat AS EKPrice
           -- ���� ��. � ���
         , MAX (tmpSelect.EKPriceWVAT)    :: TFloat AS EKPriceWVAT

           -- ���� ������� ��� ��� (Artikel)
         , MAX (tmpSelect.BasisPrice)     :: TFloat AS BasisPrice
           -- ���� ������� � ���
         , MAX (tmpSelect.BasisPriceWVAT) :: TFloat AS BasisPriceWVAT
           -- ���� ������� ��� ��� - ���� ����� ������ �� ����� ���� ������, ����� ��� Boat Structure ����� ����� SalePrice
         , MAX (tmpSelect.SalePrice)      :: TFloat AS SalePrice
           -- ���� ������� � ��� - ���� ����� ������ �� ����� ���� ������, ����� ��� Boat Structure ����� ����� SalePrice
         , MAX (tmpSelect.SalePriceWVAT)  :: TFloat AS SalePriceWVAT

         , MAX (tmpSelect.Comment)        :: TVarChar  AS Comment

         , MAX (tmpSelect.InsertName)     :: TVarChar  AS InsertName
         , MAX (tmpSelect.InsertDate)     :: TDateTime AS InsertDate
         , tmpSelect.isErased

         , tmpSelect.GoodsGroupNameFull
         , tmpSelect.GoodsGroupName
         , tmpSelect.Article
         , tmpSelect.ProdColorName
         , tmpSelect.MeasureName

         , ''  :: TVarChar AS MaterialOptionsName
         , ''  :: TVarChar AS Id_Site
         , tmpSelect.CodeVergl

         , MIN (tmpSelect.NPP) :: Integer AS NPP

     FROM tmpSelect

     GROUP BY tmpSelect.Name
            , tmpSelect.ModelId
            , tmpSelect.ModelCode
            , tmpSelect.ModelName
            , tmpSelect.BrandId
            , tmpSelect.BrandName
            , tmpSelect.ProdEngineId
            , tmpSelect.ProdEngineName


            , tmpSelect.ProdColorPatternId
            , tmpSelect.ProdColorPatternName

            , tmpSelect.GoodsId
            , tmpSelect.GoodsId_choice
            , tmpSelect.GoodsCode
            , tmpSelect.GoodsName

            , tmpSelect.isErased

            , tmpSelect.GoodsGroupNameFull
            , tmpSelect.GoodsGroupName
            , tmpSelect.Article
            , tmpSelect.ProdColorName
            , tmpSelect.MeasureName

            , tmpSelect.CodeVergl
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 27.06.22                                        *
*/

-- ����
-- SELECT * FROM gpSelect_Object_ProdOptionsChoice (0, False, False, zfCalc_UserAdmin())
