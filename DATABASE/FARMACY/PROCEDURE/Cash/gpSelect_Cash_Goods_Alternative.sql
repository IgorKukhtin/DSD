DROP FUNCTION IF EXISTS gpSelect_Cash_Goods_Alternative(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Cash_Goods_Alternative (inSession Tvarchar)
RETURNS TABLE (
  MainGoodsID     Integer,
  LinkType        integer,
  GoodsId         integer,
  GoodsCode       Integer,
  GoodsName       TVarChar,
  GoodsPrice      TFloat,
  Remains         TFloat,
  PriceAndRemains TVarChar
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
      RES.maingoodsid               as MainGoodsId
      ,RES.LinkType                  as LinkType
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
        Select
          LinkGoods_GoodsMain.childobjectid AS MainGoodsId
          ,Object_LinkGoods.objectcode      as LinkType
          ,Container.ObjectId               AS GoodsId
          ,SUM(Container.amount)            as Remains
        FROM
          Object as Object_LinkGoods
          Inner Join objectlink AS LinkGoods_GoodsMain
                                ON object_linkgoods.ID = linkgoods_goodsmain.objectid
                               AND linkgoods_goodsmain.descid = zc_ObjectLink_LinkGoods_GoodsMain()
          Inner JOin object_goods_view AS object_MainGoods
                            ON LinkGoods_GoodsMain.childobjectid = object_maingoods.ID
                           AND object_maingoods.objectid = vbObjectId
          Inner Join objectlink AS LinkGoods_Goods
                                ON object_linkgoods.ID = LinkGoods_Goods.objectid
                               AND LinkGoods_Goods.descid = zc_ObjectLink_LinkGoods_Goods()
          Inner JOin object_goods_view AS object_Goods
                            ON LinkGoods_Goods.childobjectid = object_goods.ID
                           AND object_goods.objectid = vbObjectId
          INNER JOIN container ON container.objectid = LinkGoods_Goods.childobjectid
                              AND container.descid = zc_container_count()
          Inner Join containerlinkobject AS CLO_Unit
                                         ON CLO_Unit.containerid = container.id
                                        AND CLO_Unit.descid = zc_ContainerLinkObject_Unit()
                                        AND CLO_Unit.objectid = vbUnitId

        Where
          Object_LinkGoods.descid = zc_Object_LinkGoods()
        Group BY
          LinkGoods_GoodsMain.childobjectid,
          Object_LinkGoods.objectcode,
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
