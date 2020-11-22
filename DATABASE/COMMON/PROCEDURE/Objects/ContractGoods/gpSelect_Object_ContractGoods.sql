-- Function: gpSelect_Object_ContractGoods_all (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_ContractGoods (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ContractGoods(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code INTEGER
             , Price TFloat, Persent TFloat
             , ContractId Integer, InvNumber TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsKindId Integer, GoodsKindName TVarChar
             , GoodsPropertyName TVarChar
             , BarCode TVarChar, Article TVarChar
             , StartDate TDateTime
             , isErased Boolean
             ) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyAll Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_ContractGoods());
     vbUserId:= lpGetUserBySession (inSession);
     -- определяется - может ли пользовать видеть весь справочник
     vbAccessKeyAll:= zfCalc_AccessKey_GuideAll (vbUserId);

     -- Результат
     RETURN QUERY
     WITH
     tmpContractGoods AS (SELECT Object_ContractGoods.*
                               , ContractGoods_Contract.ChildObjectId             AS ContractId
                               , ObjectLink_Contract_PriceList.ChildObjectId      AS PriceListId
                               , ObjectLink_ContractGoods_Goods.ChildObjectId     AS GoodsId
                               , ObjectLink_ContractGoods_GoodsKind.ChildObjectId AS GoodsKindId
                               , ObjectLink_Contract_GoodsProperty.ChildObjectId  AS GoodsPropertyId
                               , ObjectDate_Start.ValueData          ::TDateTime  AS StartDate
                               , ObjectDate_End.ValueData            ::TDateTime  AS EndDate
                               , ObjectFloat_Price.ValueData                      AS Price
                               , MAX (ObjectDate_End.ValueData) OVER (PARTITION BY ContractGoods_Contract.ChildObjectId
                                                                                 , ObjectLink_Contract_PriceList.ChildObjectId
                                                                                 , ObjectLink_ContractGoods_Goods.ChildObjectId
                                                                                 , ObjectLink_ContractGoods_GoodsKind.ChildObjectId) AS EndDate_last
                          FROM Object AS Object_ContractGoods
                               LEFT JOIN ObjectLink AS ContractGoods_Contract
                                                    ON ContractGoods_Contract.ObjectId = Object_ContractGoods.Id
                                                   AND ContractGoods_Contract.DescId = zc_ObjectLink_ContractGoods_Contract()

                               LEFT JOIN ObjectLink AS ObjectLink_Contract_PriceList
                                                    ON ObjectLink_Contract_PriceList.ObjectId = ContractGoods_Contract.ChildObjectId
                                                   AND ObjectLink_Contract_PriceList.DescId = zc_ObjectLink_Contract_PriceList()
            
                               LEFT JOIN ObjectLink AS ObjectLink_ContractGoods_Goods
                                                    ON ObjectLink_ContractGoods_Goods.ObjectId = Object_ContractGoods.Id
                                                   AND ObjectLink_ContractGoods_Goods.DescId = zc_ObjectLink_ContractGoods_Goods()

                               LEFT JOIN ObjectLink AS ObjectLink_ContractGoods_GoodsKind
                                                    ON ObjectLink_ContractGoods_GoodsKind.ObjectId = Object_ContractGoods.Id
                                                   AND ObjectLink_ContractGoods_GoodsKind.DescId = zc_ObjectLink_ContractGoods_GoodsKind()

                               LEFT JOIN ObjectDate AS ObjectDate_Start
                                                    ON ObjectDate_Start.ObjectId = Object_ContractGoods.Id
                                                   AND ObjectDate_Start.DescId = zc_ObjectDate_ContractGoods_Start()
                               LEFT JOIN ObjectDate AS ObjectDate_End
                                                    ON ObjectDate_End.ObjectId = Object_ContractGoods.Id
                                                   AND ObjectDate_End.DescId = zc_ObjectDate_ContractGoods_End()

                               LEFT JOIN ObjectFloat AS ObjectFloat_Price
                                                     ON ObjectFloat_Price.ObjectId = Object_ContractGoods.Id 
                                                    AND ObjectFloat_Price.DescId = zc_ObjectFloat_ContractGoods_Price()

                               LEFT JOIN ObjectLink AS ObjectLink_Contract_GoodsProperty
                                                    ON ObjectLink_Contract_GoodsProperty.ObjectId = ContractGoods_Contract.ChildObjectId
                                                   AND ObjectLink_Contract_GoodsProperty.DescId = zc_ObjectLink_Contract_GoodsProperty()

                          WHERE Object_ContractGoods.DescId = zc_Object_ContractGoods()
                            AND Object_ContractGoods.isErased = FALSE
                         )

   , tmpGoodsPropertyValue AS (SELECT Object_GoodsPropertyValue.Id AS GoodsPropertyValueId
                                    , ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId  AS GoodsPropertyId
                                    , ObjectLink_GoodsPropertyValue_Goods.ChildObjectId          AS GoodsId
                                    , ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId      AS GoodsKindId

                                    , ObjectString_BarCode.ValueData         AS BarCode
                                    , ObjectString_Article.ValueData         AS Article
            
                               FROM (SELECT DISTINCT tmpContractGoods.GoodsId
                                                   , tmpContractGoods.GoodsPropertyId
                                                   , tmpContractGoods.GoodsKindId FROM tmpContractGoods ) AS tmp
                                 
                                  INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                                        ON ObjectLink_GoodsPropertyValue_Goods.ChildObjectId =  tmp.GoodsId
                                                       AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()

                                  INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                                        ON ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
                                                       AND ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId = ObjectLink_GoodsPropertyValue_Goods.ObjectId
                                                       AND ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = tmp.GoodsPropertyId

                                  LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                                       ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_Goods.ObjectId
                                                      AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()

                                  LEFT JOIN Object AS Object_GoodsPropertyValue
                                                   ON Object_GoodsPropertyValue.Id = ObjectLink_GoodsPropertyValue_Goods.ObjectId
                                                  AND Object_GoodsPropertyValue.DescId = zc_Object_GoodsPropertyValue()
                                                  AND Object_GoodsPropertyValue.isErased = FALSE 

                                  -- AND COALESCE (tmp.GoodsKindId,0) = COALESCE (ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId,0)

                                  LEFT JOIN ObjectString AS ObjectString_BarCode
                                                         ON ObjectString_BarCode.ObjectId = ObjectLink_GoodsPropertyValue_Goods.ObjectId
                                                        AND ObjectString_BarCode.DescId = zc_ObjectString_GoodsPropertyValue_BarCode() 
                                  LEFT JOIN ObjectString AS ObjectString_Article
                                                         ON ObjectString_Article.ObjectId = ObjectLink_GoodsPropertyValue_Goods.ObjectId
                                                        AND ObjectString_Article.DescId = zc_ObjectString_GoodsPropertyValue_Article() 
                               )

      ---
       SELECT
             Object_ContractGoods.Id          AS Id
           , Object_ContractGoods.ObjectCode  AS Code
           , Object_ContractGoods.Price       AS Price
           , CAST ( ((Object_ContractGoods.Price - tmp.Price) / 100) * tmp.Price AS NUMERIC (16,2)) ::TFloat AS Persent

           , Object_Contract.Id         AS ContractId
           , Object_Contract.ValueData  AS InvNumber

           , Object_Goods.Id                  AS GoodsId
           , Object_Goods.ObjectCode          AS GoodsCode
           , Object_Goods.ValueData           AS GoodsName
           , Object_GoodsKind.Id              AS GoodsKindId
           , Object_GoodsKind.ValueData       AS GoodsKindName
           , Object_GoodsProperty.ValueData   AS GoodsPropertyName
           , tmpGoodsPropertyValue.BarCode ::TVarChar
           , tmpGoodsPropertyValue.Article ::TVarChar
           , Object_ContractGoods.StartDate   AS StartDate
           , Object_ContractGoods.isErased    AS isErased

    FROM tmpContractGoods AS Object_ContractGoods
           -- LEFT JOIN (SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE UserId = vbUserId GROUP BY AccessKeyId) AS tmpRoleAccessKey ON NOT vbAccessKeyAll AND tmpRoleAccessKey.AccessKeyId = Object_ContractGoods.AccessKeyId
            LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = Object_ContractGoods.ContractId

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = Object_ContractGoods.GoodsId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = Object_ContractGoods.GoodsKindId

            LEFT JOIN Object AS Object_GoodsProperty ON Object_GoodsProperty.Id = Object_ContractGoods.GoodsPropertyId

            LEFT JOIN tmpGoodsPropertyValue ON tmpGoodsPropertyValue.GoodsPropertyId = Object_ContractGoods.GoodsPropertyId
                                           AND tmpGoodsPropertyValue.GoodsId = Object_ContractGoods.GoodsId
                                          -- AND COALESCE (tmpGoodsPropertyValue.GoodsKindId,0) = COALESCE (Object_ContractGoods.GoodsKindId,0)

            LEFT JOIN tmpContractGoods AS tmp
                                       ON tmp.ContractId = Object_ContractGoods.ContractId
                                      AND tmp.PriceListId = Object_ContractGoods.PriceListId
                                      AND tmp.GoodsId = Object_ContractGoods.GoodsId
                                      AND COALESCE (tmp.GoodsKindId,0) = COALESCE (Object_ContractGoods.GoodsKindId,0)
                                      AND tmp.EndDate + interval '1 day' = Object_ContractGoods.StartDate

     WHERE Object_ContractGoods.DescId = zc_Object_ContractGoods()
       --AND (tmpRoleAccessKey.AccessKeyId IS NOT NULL OR vbAccessKeyAll)
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_ContractGoods (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.02.15         *
        
*/

-- тест
-- SELECT * FROM gpSelect_Object_ContractGoods (zfCalc_UserAdmin())