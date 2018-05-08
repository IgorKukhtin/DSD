-- Function: gpSelect_Object_ToolsWeighingPlace()

DROP FUNCTION IF EXISTS gpSelect_Object_ToolsWeighingPlace (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ToolsWeighingPlace(
    IN inSession           TVarChar     -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, ItemName TVarChar, isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
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
          , Object_PriceList.ValueData  AS Name
          , ObjectDesc.ItemName
          , Object_PriceList.isErased
     FROM Object AS Object_PriceList
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_PriceList.DescId
     WHERE Object_PriceList.DescId = zc_Object_PriceList()
       
    UNION ALL
     SELECT Object_Branch.Id
          , Object_Branch.ObjectCode AS Code     
          , Object_Branch.ValueData  AS Name
          , ObjectDesc.ItemName
          , Object_Branch.isErased
     FROM Object AS Object_Branch
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Branch.DescId
     WHERE Object_Branch.DescId = zc_Object_Branch()

    UNION ALL
     SELECT Object_PaidKind.Id
          , Object_PaidKind.ObjectCode AS Code     
          , Object_PaidKind.ValueData  AS Name
          , ObjectDesc.ItemName
          , Object_PaidKind.isErased
     FROM Object AS Object_PaidKind
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_PaidKind.DescId
     WHERE Object_PaidKind.DescId = zc_Object_PaidKind()
    
    UNION ALL
     SELECT Object_GoodsKindWeighingGroup.Id
          , Object_GoodsKindWeighingGroup.ObjectCode AS Code     
          , Object_GoodsKindWeighingGroup.ValueData  AS Name
          , ObjectDesc.ItemName
          , Object_GoodsKindWeighingGroup.isErased
     FROM Object AS Object_GoodsKindWeighingGroup
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_GoodsKindWeighingGroup.DescId
     WHERE Object_GoodsKindWeighingGroup.DescId = zc_Object_GoodsKindWeighingGroup()

    UNION ALL
     SELECT Object_InfoMoney_View.InfoMoneyId       AS Id
          , Object_InfoMoney_View.InfoMoneyCode     AS Code     
          , Object_InfoMoney_View.InfoMoneyName_all AS Name
          , ObjectDesc.ItemName
          , Object_InfoMoney_View.isErased
     FROM Object_InfoMoney_View
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = zc_Object_InfoMoney()
     WHERE Object_InfoMoney_View.InfoMoneyGroupId IN (zc_Enum_InfoMoneyGroup_10000(), zc_Enum_InfoMoneyGroup_30000()) -- Основное сырье + Доходы
        OR Object_InfoMoney_View.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900()) -- Общефирменные + Ирна

    UNION ALL
     SELECT Object_Goods.Id
          , Object_Goods.ObjectCode AS Code     
          , Object_Goods.ValueData  AS Name
          , ObjectDesc.ItemName
          , Object_Goods.isErased
     FROM ObjectLink AS ObjectLink_Goods_InfoMoney
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Goods_InfoMoney.ObjectId
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Goods.DescId
     WHERE /*ObjectLink_Goods_InfoMoney.ChildObjectId = zc_Enum_InfoMoney_30301() -- Доходы + Переработка + Переработка
       AND */ ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()

    UNION ALL
     SELECT Object_DocumentKind.Id
          , Object_DocumentKind.ObjectCode AS Code
          , Object_DocumentKind.ValueData  AS Name
          , ObjectDesc.ItemName
          , Object_DocumentKind.isErased
     FROM Object AS Object_DocumentKind
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_DocumentKind.DescId
     WHERE Object_DocumentKind.DescId = zc_Object_DocumentKind()

    UNION ALL
     SELECT Object_Partner.Id
          , Object_Partner.ObjectCode AS Code     
          , Object_Partner.ValueData  AS Name
          , ObjectDesc.ItemName
          , Object_Partner.isErased
     FROM Object AS Object_Partner
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Partner.DescId
     WHERE Object_Partner.DescId = zc_Object_Partner()

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
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.11.16         * add zc_Object_Partner
 22.01.15         *

*/

-- тест
-- SELECT * FROM gpSelect_Object_ToolsWeighingPlace (inSession := zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_Object_ToolsWeighingPlace (inSession := '9818')
