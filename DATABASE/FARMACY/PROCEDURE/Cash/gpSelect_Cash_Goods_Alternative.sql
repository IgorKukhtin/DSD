DROP FUNCTION IF EXISTS gpSELECT_CASh_Goods_Alternative_ver2(TVarChar);
DROP FUNCTION IF EXISTS gpSELECT_CASh_Goods_Alternative_ver2(Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpSELECT_CASh_Goods_Alternative_ver2 (inMovementId Integer, inSession Tvarchar)
RETURNS TABLE (
  LinkType           integer,
  MainGoodsID        Integer,
  AlternativeGroupId Integer,
  Id                 integer,
  GoodsCode          Integer,
  GoodsName          TVarChar,
  Price              TFloat,
  Remains            TFloat,
  TypeColor          Integer,
  NDS                TFloat
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
    WITH
    RESERVE
    AS
    (
        SELECT
            MovementItem_Reserve.GoodsId,
            SUM(MovementItem_Reserve.Amount)::TFloat AS Amount
        FROM
            gpSELECT_MovementItem_CheckDeferred(inSession) AS MovementItem_Reserve
        WHERE
            MovementItem_Reserve.MovementId <> inMovementId
        GROUP BY
            MovementItem_Reserve.GoodsId
    ),
    Rem
    AS
      (
        SELECT
            Container.ObjectId    AS GoodsId
           ,(SUM(Container.amount) 
             - COALESCE(Reserve.Amount,0))::TFloat AS Remains
        FROM Container
            INNER JOIN object ON Container.ObjectId = object.Id
            LEFT OUTER JOIN RESERVE ON container.objectid = RESERVE.GoodsId
        WHERE
            container.descid = zc_container_count()
            AND
            Container.WhereObjectId = vbUnitId
        GROUP BY
            Container.ObjectId
           ,Reserve.Amount
        HAVING
            SUM(Container.Amount)>0
      ),
    tmpPrice AS (
                 SELECT Price_Goods.ChildObjectId               AS GoodsId
                      , ROUND(Price_Value.ValueData,2)::TFloat  AS Price 
                 FROM ObjectLink AS ObjectLink_Price_Unit
                      LEFT JOIN ObjectLink AS Price_Goods
                             ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                            AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                      LEFT JOIN ObjectFloat AS Price_Value
                             ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                            AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
                 WHERE ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                   AND ObjectLink_Price_Unit.ChildObjectId = vbUnitId
                 )
   
    SELECT
      RES.LinkType                       AS LinkType
      ,RES.maingoodsid                   AS MainGoodsId
      ,RES.AlternativeGroupId            AS AlternativeGroupId
      ,Object_Goods.Id                   AS Id
      ,Object_Goods.objectcode           AS GoodsCode
      ,Object_Goods.valuedata            AS GoodsName
      ,tmpPrice.Price                    AS Price
      ,RES.remains::TFloat               AS Remains
      ,RES.TypeColor::Integer            AS TypeColor
      ,ObjectFloat_NDSKind_NDS.ValueData AS NDS
    FROM(  
            SELECT --Additional Goods
                0                                       AS LinkType
               ,zc_Color_Goods_Additional()/*14941410*/ AS TypeColor
               ,Object_AdditionalGoods_View.GoodsMainId AS MainGoodsId
               ,0                                       AS AlternativeGroupId
               ,Rem.GoodsId                             AS GoodsId
               ,Rem.Remains                             AS Remains
            FROM Rem
               INNER JOIN Object_AdditionalGoods_View ON Object_AdditionalGoods_View.GoodsSecondId = Rem.GoodsId
            UNION ALL
            SELECT --Alternative Goods
                1                                                AS LinkType
               ,zc_Color_Goods_Alternative()/*16380671*/         AS TypeColor
               ,0                                                AS MainGoodsId
               ,AlternativeGroup.Id                              AS AlternativeGroupId
               ,Rem.GoodsId                                      AS GoodsId
               ,Rem.Remains                                      AS Remains
            FROM Rem
                INNER JOIN ObjectLink AS ObjectLink_Goods_AlternativeGroup
                                      ON Rem.GoodsId = ObjectLink_Goods_AlternativeGroup.ObjectId
                                     AND ObjectLink_Goods_AlternativeGroup.DescId = zc_objectlink_goods_alternativegroup()
                INNER JOIN Object AS AlternativeGroup
                                  ON ObjectLink_Goods_AlternativeGroup.ChildObjectId = AlternativeGroup.Id
            Where
                AlternativeGroup.isErASed = False
        ) AS RES
        INNER JOIN Object AS Object_Goods
                          ON RES.GoodsId = Object_Goods.id
        LEFT OUTER JOIN tmpPrice ON tmpPrice.Goodsid = RES.GoodsId
                                        
        LEFT OUTER JOIN ObjectLink AS ObjectLink_Goods_NDSKind
                                   ON ObjectLink_Goods_NDSKind.ObjectId = Object_Goods.Id
                                  AND ObjectLink_Goods_NDSKind.DescId = zc_ObjectLink_Goods_NDSKind()
        LEFT OUTER JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                    ON ObjectFloat_NDSKind_NDS.ObjectId = ObjectLink_Goods_NDSKind.ChildObjectId 

    WHERE
        Object_Goods.IsErASed = False                                   
    ORDER BY
        RES.LinkType
       ,RES.maingoodsid
       ,Object_Goods.valuedata;



END;
$body$
LANGUAGE plpgsql VOLATILE;

ALTER FUNCTION gpSELECT_CASh_Goods_Alternative_ver2(Integer, TVarChar) OWNER TO postgres;

/*
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
               ‘ÂÎÓÌ˛Í ».¬.    ÛıÚËÌ ».¬.    ÎËÏÂÌÚ¸Â‚  .».   Ã‡Ì¸ÍÓ ƒ.¿.     ¬ÓÓ·Í‡ÎÓ ¿.¿
 12.06.17         * 
 22.08.15                                                                          *inMovementId
 03.07.15                                                                          *

*/

-- ÚÂÒÚ
--SELECT * FROM gpSELECT_CASh_Goods_Alternative(1,'308120'::TVarChar)
