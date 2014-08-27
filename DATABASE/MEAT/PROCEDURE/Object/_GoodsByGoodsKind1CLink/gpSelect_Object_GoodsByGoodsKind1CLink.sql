-- Function: gpSelect_Object_GoodsByGoodsKind1CLink (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsByGoodsKind1CLink (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsByGoodsKind1CLink(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, GoodsKindId Integer, GoodsKindName TVarChar
             , Id Integer, Code Integer, Name TVarChar, Name_find1C TVarChar
             , BranchId Integer, BranchName TVarChar
             , Price TFloat
              )
AS
$BODY$
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_GoodsByGoodsKind1CLink());
   
     -- Результат
     RETURN QUERY 
       WITH tmpSale1C  AS (SELECT Sale1C.GoodsCode, Sale1C.GoodsName
                                , zfGetBranchLinkFromBranchPaidKind(zfGetBranchFromUnitId (Sale1C.UnitId), zfGetPaidKindFrom1CType(Sale1C.VidDoc)) AS BranchTopId
                           FROM Sale1C
                           WHERE Sale1C.GoodsCode <> 0
                           GROUP BY Sale1C.GoodsCode, Sale1C.GoodsName
                                 , zfGetBranchLinkFromBranchPaidKind(zfGetBranchFromUnitId (Sale1C.UnitId), zfGetPaidKindFrom1CType(Sale1C.VidDoc))
                          )

       SELECT 
           tmpResult.GoodsId
        ,  tmpResult.GoodsCode
        ,  tmpResult.GoodsName
        ,  tmpResult.GoodsKindId
        ,  tmpResult.GoodsKindName
        ,  tmpResult.Id
        ,  tmpResult.Code
        ,  tmpResult.Name
        ,  tmpSale1C.GoodsName AS Name_find1C
        ,  tmpResult.BranchId
        ,  tmpResult.BranchName
        ,  lfObjectHistory_PriceListItem.ValuePrice AS Price
       FROM
       (SELECT 
           /*COALESCE(GoodsByGoodsKind.GoodsId, GoodsByGoodsKind1CLink.GoodsId) AS GoodsId
        ,  COALESCE(GoodsByGoodsKind.GoodsCode, GoodsByGoodsKind1CLink.GoodsCode) AS GoodsCode
        ,  COALESCE(GoodsByGoodsKind.GoodsName, GoodsByGoodsKind1CLink.GoodsName) AS GoodsName
        ,  COALESCE(GoodsByGoodsKind.GoodsKindId, GoodsByGoodsKind1CLink.GoodsKindId) AS GoodsKindId
        ,  COALESCE(GoodsByGoodsKind.GoodsKindName, GoodsByGoodsKind1CLink.GoodsKindName) AS GoodsKindName*/
           GoodsByGoodsKind1CLink.GoodsId AS GoodsId
        ,  GoodsByGoodsKind1CLink.GoodsCode AS GoodsCode
        ,  GoodsByGoodsKind1CLink.GoodsName AS GoodsName
        ,  GoodsByGoodsKind1CLink.GoodsKindId AS GoodsKindId
        ,  GoodsByGoodsKind1CLink.GoodsKindName AS GoodsKindName
        ,  GoodsByGoodsKind1CLink.Id
        ,  GoodsByGoodsKind1CLink.Code
        ,  GoodsByGoodsKind1CLink.Name
        ,  GoodsByGoodsKind1CLink.BranchId
        ,  GoodsByGoodsKind1CLink.BranchName
       FROM /*(SELECT Object_GoodsByGoodsKind_View.GoodsId
                  , Object_GoodsByGoodsKind_View.GoodsCode
                  , Object_GoodsByGoodsKind_View.GoodsName
                  , (COALESCE (Object_GoodsByGoodsKind_View.GoodsId, 0) :: TVarChar || '_' || COALESCE (Object_GoodsByGoodsKind_View.GoodsKindId, 0) :: TVarChar) :: TVarChar AS MasterId
                  , Object_GoodsByGoodsKind_View.GoodsKindId
                  , Object_GoodsByGoodsKind_View.GoodsKindName
             FROM (SELECT Object_Goods.Id            AS GoodsId
                        , Object_Goods.ObjectCode    AS GoodsCode
                        , Object_Goods.ValueData     AS GoodsName
                        , Object_GoodsKind.Id        AS GoodsKindId
                        , Object_GoodsKind.ValueData AS GoodsKindName
                   FROM Object_InfoMoney_View
                        JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                        ON ObjectLink_Goods_InfoMoney.ChildObjectId = Object_InfoMoney_View.InfoMoneyId
                                       AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                        JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Goods_InfoMoney.ObjectId
                                                   AND Object_Goods.isErased = FALSE
                        LEFT JOIN Object_GoodsByGoodsKind_View ON Object_GoodsByGoodsKind_View.GoodsId = Object_Goods.Id
                        LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = COALESCE (Object_GoodsByGoodsKind_View.GoodsKindId, zc_Enum_GoodsKind_Main())
                   WHERE Object_InfoMoney_View.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900(), zc_Enum_InfoMoneyDestination_21000(), zc_Enum_InfoMoneyDestination_21100(), zc_Enum_InfoMoneyDestination_30100())
                     AND Object_Goods.Id NOT IN (7645, 7601, 6779, 6816) -- ТУШЕНКА
                  ) AS Object_GoodsByGoodsKind_View
            UNION ALL
             SELECT Object.Id AS GoodsId
                  , Object.ObjectCode AS GoodsCode
                  , Object.ValueData AS GoodsName
                  , (COALESCE (Object.Id, 0) :: TVarChar || '_'|| '0') :: TVarChar AS MasterId
                  , 0 ::Integer AS GoodsKindId
                  , '' ::TVarChar AS GoodsKindName
             FROM Object
             WHERE Object.DescId = zc_Object_Goods()
               AND Object.Id IN (7645, 7601, 6779, 6816) -- ТУШЕНКА
            ) AS GoodsByGoodsKind

            FULL JOIN*/ (SELECT Object_GoodsByGoodsKind1CLink.Id               AS Id 
                            , Object_GoodsByGoodsKind1CLink.ObjectCode       AS Code
                            , Object_GoodsByGoodsKind1CLink.ValueData        AS Name
                            , (COALESCE (ObjectLink_GoodsByGoodsKind1CLink_Goods.ChildObjectId, 0) :: TVarChar || '_' || COALESCE (ObjectLink_GoodsByGoodsKind1CLink_GoodsKind.ChildObjectId, 0) :: TVarChar) :: TVarChar AS MasterId
                            , Object_Branch.Id                               AS BranchId
                            , Object_Branch.BranchLinkName                        AS BranchName
                            , Object_Goods.Id AS  GoodsId
                            , Object_Goods.ObjectCode AS  GoodsCode
                            , Object_Goods.ValueData AS GoodsName
                            , Object_GoodsKind.Id AS GoodsKindId
                            , Object_GoodsKind.ValueData AS GoodsKindName
                       FROM Object AS Object_GoodsByGoodsKind1CLink
                            LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind1CLink_Goods
                                                 ON ObjectLink_GoodsByGoodsKind1CLink_Goods.ObjectId = Object_GoodsByGoodsKind1CLink.Id
                                                AND ObjectLink_GoodsByGoodsKind1CLink_Goods.DescId = zc_ObjectLink_GoodsByGoodsKind1CLink_Goods()
                            LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind1CLink_GoodsKind
                                                 ON ObjectLink_GoodsByGoodsKind1CLink_GoodsKind.ObjectId = Object_GoodsByGoodsKind1CLink.Id
                                                AND ObjectLink_GoodsByGoodsKind1CLink_GoodsKind.DescId = zc_ObjectLink_GoodsByGoodsKind1CLink_GoodsKind()
                            LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind1CLink_Branch
                                                 ON ObjectLink_GoodsByGoodsKind1CLink_Branch.ObjectId = Object_GoodsByGoodsKind1CLink.Id
                                                AND ObjectLink_GoodsByGoodsKind1CLink_Branch.DescId = zc_ObjectLink_GoodsByGoodsKind1CLink_Branch()
                            LEFT JOIN Object_BranchLink_View AS Object_Branch ON Object_Branch.Id = ObjectLink_GoodsByGoodsKind1CLink_Branch.ChildObjectId   
                            LEFT JOIN OBJECT AS Object_Goods ON Object_Goods.Id = ObjectLink_GoodsByGoodsKind1CLink_Goods.ChildObjectId 
                            LEFT JOIN OBJECT AS Object_GoodsKind ON Object_GoodsKind.Id = ObjectLink_GoodsByGoodsKind1CLink_GoodsKind.ChildObjectId 
                       WHERE Object_GoodsByGoodsKind1CLink.DescId = zc_Object_GoodsByGoodsKind1CLink()
                      )  AS GoodsByGoodsKind1CLink
                         /*ON GoodsByGoodsKind1CLink.MasterId = GoodsByGoodsKind.MasterId*/
       ) AS tmpResult
       LEFT JOIN lfSelect_ObjectHistory_PriceListItem (inPriceListId:= zc_PriceList_Basis(), inOperDate:= DATE_TRUNC ('DAY', CURRENT_TIMESTAMP))
              AS lfObjectHistory_PriceListItem ON lfObjectHistory_PriceListItem.GoodsId = tmpResult.GoodsId
       LEFT JOIN tmpSale1C ON tmpSale1C.GoodsCode = tmpResult.Code
                          AND tmpSale1C.BranchTopId = tmpResult.BranchId
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_GoodsByGoodsKind1CLink (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 22.08.14                                        * add tmpSale1C
 22.08.14                                        * show only exists
 22.04.14                                        * add Price
 11.04.14                        * 
 10.04.14                                        * add Object_InfoMoney_View
 17.02.14                        * 
 15.02.14                                        * all
 28.01.14                        * 
*/
/*
delete from ObjectBoolean where ObjectId in (select Object_Partner1CLink.Id FROM Object AS Object_Partner1CLink WHERE Object_Partner1CLink.DescId = zc_Object_Partner1CLink() and ObjectCode = 0 and trim(ValueData) = '');
delete from ObjectLink where ObjectId in (select Object_Partner1CLink.Id FROM Object AS Object_Partner1CLink WHERE Object_Partner1CLink.DescId = zc_Object_Partner1CLink() and ObjectCode = 0 and trim(ValueData) = '');
delete from objectProtocol where ObjectId in (select Object_Partner1CLink.Id FROM Object AS Object_Partner1CLink WHERE Object_Partner1CLink.DescId = zc_Object_Partner1CLink() and ObjectCode = 0 and trim(ValueData) = '');
delete from object where Id in (select Object_Partner1CLink.Id FROM Object AS Object_Partner1CLink WHERE Object_Partner1CLink.DescId = zc_Object_Partner1CLink() and ObjectCode = 0 and trim(ValueData) = '');
*/
-- тест
-- SELECT * FROM gpSelect_Object_GoodsByGoodsKind1CLink (zfCalc_UserAdmin()) WHERE Code = 1