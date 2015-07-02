DROP FUNCTION IF EXISTS gpSelect_Cash_Goods_Alternative(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Cash_Goods_Alternative (inSession Tvarchar)
RETURNS TABLE (
  LinkType         integer,
  MainGoodsID      Integer,
  AlternativeGroupId Integer,
  GoodsId          integer,
  GoodsCode        Integer,
  GoodsName        TVarChar,
  GoodsPrice       TFloat,
  Remains          TFloat,
  PriceAndRemains  TVarChar
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
    SELECT
      RES.LinkType                   as LinkType
      ,RES.maingoodsid               as MainGoodsId
      ,RES.AlternativeGroupId        as AlternativeGroupId
      ,Object_Goods.Id               as GoodsId
      ,Object_Goods.objectcode       as GoodsCode
      ,Object_Goods.valuedata        as GoodsName
      ,Object_Price_View.price       as GoodsPrice
      ,RES.remains::TFloat           as Remains
      ,(COALESCE(Object_Price_View.price,0.0)||' X '||COALESCE(RES.remains,0))::TVarChar
                                    as PriceAndRemains
    FROM
    --Start SubQuery
      (  
        Select --Additional Goods
          0                                  as LinkType
          ,object_GoodsMain.Id               AS MainGoodsId
          ,0                                 as AlternativeGroupId
          ,Rem.GoodsId                       AS GoodsId
          ,Rem.Remains                       AS Remains
        FROM
          (
             SELECT
               object_Goods.Id                   AS GoodsId
              ,SUM(Container.amount)             as Remains
            from Container
              Inner Join containerlinkobject AS CLO_Unit
                                             ON CLO_Unit.containerid = container.id
                                            AND CLO_Unit.descid = zc_ContainerLinkObject_Unit()
                                            AND CLO_Unit.objectid = vbUnitId
              Inner Join object_goods_view AS object_Goods
                                           ON Container.ObjectId = object_goods.ID
                                          AND object_goods.objectid = vbObjectId
            WHERE
              container.descid = zc_container_count()
              AND
              object_Goods.IsErased = False
            Group BY
              object_Goods.Id
            Having
              SUM(Container.Amount)>0) as Rem
          Inner Join objectlink AS LinkGoods_Goods
                                ON linkgoods_goods.ChildObjectId = Rem.GoodsId
                               AND linkgoods_goods.DescId = zc_ObjectLink_LinkGoods_Goods()
          Inner Join ObjectLink AS LinkGoods_GoodsMain
                                ON LinkGoods_GoodsMain.ObjectId = LinkGoods_Goods.ObjectId
                               AND LinkGoods_GoodsMain.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
          Inner Join object_goods_view AS object_GoodsMain
                                       ON LinkGoods_GoodsMain.ChildObjectId = object_goodsMain.ID
        WHERE
          object_GoodsMain.IsErased = False
        UNION ALL
        Select --Alternative Goods
          1                                                 as LinkType
          ,0                                                as MainGoodsId
          ,AlternativeGroup.Id                              as AlternativeGroupId
          ,Container.ObjectId                               AS GoodsId
          ,SUM(Container.amount)                            as Remains
        from container 
          Inner Join containerlinkobject AS CLO_Unit
                                         ON CLO_Unit.containerid = container.id
                                        AND CLO_Unit.descid = zc_ContainerLinkObject_Unit()
                                        AND CLO_Unit.objectid = vbUnitId
          Inner Join Object_Goods_View ON Container.ObjectId = Object_Goods_View.Id
                                      AND Object_Goods_View.ObjectId = vbObjectId
          Inner Join ObjectLink AS OL_G_AG
                                ON Container.ObjectId = OL_G_AG.ObjectId
                               AND OL_G_AG.DescId = zc_objectlink_goods_alternativegroup()
          Inner Join Object AS AlternativeGroup
                            ON OL_G_AG.ChildObjectId = AlternativeGroup.Id
                               
        WHERE
          container.descid = zc_container_count()
          AND
          Object_Goods_View.isErased = False
          AND
          AlternativeGroup.IsErased = False
        Group BY
          AlternativeGroup.Id,
          Container.ObjectId 
        HAVING
          SUM(Container.amount) > 0
          
      ) AS RES
    --End SubQuery
    INNER JOIN Object AS Object_Goods
                      ON RES.GoodsId = Object_Goods.id
    LEFT OUTER JOIN Object_Price_View ON RES.GoodsId = Object_Price_View.goodsid
                                     AND Object_Price_View.unitid = vbUnitId
  Order BY
    RES.maingoodsid
    ,RES.LinkType
    ,Object_Goods.valuedata;



END;
$body$
LANGUAGE plpgsql VOLATILE;

ALTER FUNCTION gpSelect_Cash_Goods_Alternative(TVarChar) OWNER TO postgres;

--Select * from gpSelect_Cash_Goods_Alternative('308120')
