-- Function: gpSelect_Object_ToolsWeighingPlace()

DROP FUNCTION IF EXISTS gpSelect_Object_ToolsWeighingPlace (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ToolsWeighingPlace(
    IN inSession           TVarChar     -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, ItemName TVarChar, isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);

     RETURN QUERY
     SELECT Object_Unit_View.Id
          , Object_Unit_View.Code     
          , Object_Unit_View.Name
          , ObjectDesc.ItemName
          , Object_Unit_View.isErased
     FROM Object_Unit_View
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Unit_View.DescId
    
    UNION ALL
     SELECT Object_PriceList.Id
          , Object_PriceList.ObjectCode AS Code     
          , Object_PriceList.ValueData AS Name
          , ObjectDesc.ItemName
          , Object_PriceList.isErased
     FROM Object AS Object_PriceList
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_PriceList.DescId
     WHERE Object_PriceList.DescId = zc_Object_PriceList()
       
    UNION ALL
     SELECT Object_PaidKind.Id
          , Object_PaidKind.ObjectCode AS Code     
          , Object_PaidKind.ValueData AS Name
          , ObjectDesc.ItemName
          , Object_PaidKind.isErased
     FROM Object AS Object_PaidKind
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_PaidKind.DescId
     WHERE Object_PaidKind.DescId = zc_Object_PaidKind()
    
    UNION ALL
     SELECT Object_GoodsKindWeighingGroup.Id
          , Object_GoodsKindWeighingGroup.ObjectCode AS Code     
          , Object_GoodsKindWeighingGroup.ValueData AS Name
          , ObjectDesc.ItemName
          , Object_GoodsKindWeighingGroup.isErased
     FROM Object AS Object_GoodsKindWeighingGroup
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_GoodsKindWeighingGroup.DescId
     WHERE Object_GoodsKindWeighingGroup.DescId = zc_Object_GoodsKindWeighingGroup()

    UNION ALL
     SELECT MovementDesc.Id
          , MovementDesc.Id       AS Code     
          , MovementDesc.ItemName AS Name
          , '' :: TVarChar        AS ItemName
          , FALSE isErased
     FROM MovementDesc
 
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_ToolsWeighingPlace (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 22.01.15         *

*/

-- ����
-- SELECT * FROM gpSelect_Object_ToolsWeighingPlace (inSession := zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_Object_ToolsWeighingPlace (inSession := '9818')
