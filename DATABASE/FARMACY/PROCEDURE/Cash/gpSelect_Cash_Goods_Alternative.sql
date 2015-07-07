DROP FUNCTION IF EXISTS gpSelect_Cash_Goods_Alternative(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Cash_Goods_Alternative (inSession Tvarchar)
RETURNS TABLE (
  LinkType         integer,
  MainGoodsID      Integer,
  AlternativeGroupId Integer,
  Id          integer,
  GoodsCode        Integer,
  GoodsName        TVarChar,
  Price            TFloat,
  Remains          TFloat,
  TypeColor        Integer
) AS
$body$
  DECLARE vbUserId Integer;
  DECLARE vbUnitId Integer;
  DECLARE vbObjectId Integer;
  DECLARE vbUnitKey TVarChar;
BEGIN
  vbUserId:= lpGetUserBySession (inSession);
  vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
  IF vbUnitKey = '' THEN
    vbUnitKey := '0';
  END IF;
  vbUnitId := vbUnitKey::Integer;
  vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);
  RETURN QUERY
    WITH Rem
    AS
      (
         SELECT
            Container.ObjectId    AS GoodsId
           ,SUM(Container.amount) as Remains
          from Container
            Inner Join containerlinkobject AS CLO_Unit
                                           ON CLO_Unit.containerid = container.id
                                          AND CLO_Unit.descid = zc_ContainerLinkObject_Unit()
                                          AND CLO_Unit.objectid = vbUnitId
            Inner Join object_Goods_View ON Container.ObjectId = object_Goods_View.Id
                                        AND object_Goods_View.ObjectId = vbObjectId                             
            WHERE
              container.descid = zc_container_count()
            Group BY
              Container.ObjectId
            Having
              SUM(Container.Amount)>0
      )
    SELECT
      RES.LinkType                   as LinkType
      ,RES.maingoodsid               as MainGoodsId
      ,RES.AlternativeGroupId        as AlternativeGroupId
      ,Object_Goods.Id               as Id
      ,Object_Goods.objectcode       as GoodsCode
      ,Object_Goods.valuedata        as GoodsName
      ,Object_Price_View.price       as Price
      ,RES.remains::TFloat           as Remains
      ,RES.TypeColor::Integer        as TypeColor
    FROM
    --Start SubQuery
      (  
        Select --Additional Goods
          0                                       as LinkType
         ,14941410                                as TypeColor
         ,Object_AdditionalGoods_View.GoodsMainId AS MainGoodsId
         ,0                                       as AlternativeGroupId
         ,Rem.GoodsId                             AS GoodsId
         ,Rem.Remains                             AS Remains
        FROM Rem
          Inner Join Object_LinkGoodsRetail_View AS Object_AdditionalGoods_View
                                                 ON Object_AdditionalGoods_View.GoodsId = Rem.GoodsId
                                                AND Object_AdditionalGoods_View.ObjectId = vbObjectId
         UNION ALL
         Select --Alternative Goods
           1                                                 as LinkType
           ,16380671                                         as TypeColor
           ,0                                                as MainGoodsId
           ,AlternativeGroup.Id                              as AlternativeGroupId
           ,Rem.GoodsId                                      AS GoodsId
           ,Rem.Remains                                      as Remains
         from Rem
           Inner Join ObjectLink AS OL_G_AG
                                 ON Rem.GoodsId = OL_G_AG.ObjectId
                                AND OL_G_AG.DescId = zc_objectlink_goods_alternativegroup()
           Inner Join Object AS AlternativeGroup
                             ON OL_G_AG.ChildObjectId = AlternativeGroup.Id
         Where
           AlternativeGroup.isErased = False                    
          
      ) AS RES
    --End SubQuery
    INNER JOIN Object AS Object_Goods
                      ON RES.GoodsId = Object_Goods.id
    LEFT OUTER JOIN Object_Price_View ON RES.GoodsId = Object_Price_View.goodsid
                                     AND Object_Price_View.unitid = vbUnitId
  WHERE
    Object_Goods.IsErased = False                                   
  Order BY
    RES.LinkType
    ,RES.maingoodsid
    ,Object_Goods.valuedata;



END;
$body$
LANGUAGE plpgsql VOLATILE;

ALTER FUNCTION gpSelect_Cash_Goods_Alternative(TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.     Воробкало А.А
 03.07.15                                                                          *

*/

-- тест
--Select * from gpSelect_Cash_Goods_Alternative('308120')
