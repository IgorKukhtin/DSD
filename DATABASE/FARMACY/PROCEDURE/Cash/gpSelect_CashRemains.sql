-- Function: gpSelect_Movement_Income()

DROP FUNCTION IF EXISTS gpSelect_CashRemains (TVarChar);
DROP FUNCTION IF EXISTS gpSelect_CashRemains (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_CashRemains(
    IN inMovementId    Integer,    -- Текущая накладная
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, GoodsName TVarChar, GoodsCode Integer,
               Remains TFloat, Price TFloat, Reserved TFloat, MCSValue TFloat,
               AlternativeGroupId Integer)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
     vbUserId:= lpGetUserBySession (inSession);
     vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
     IF vbUnitKey = '' THEN
        vbUnitKey := '0';
     END IF;
     vbUnitId := vbUnitKey::Integer;

     RETURN QUERY
       WITH GoodsRemains
       AS
        (
            SELECT 
                SUM(Amount) AS Remains, 
                container.objectid 
            FROM container
                -- INNER JOIN containerlinkobject AS CLO_Unit
                                               -- ON CLO_Unit.containerid = container.id 
                                              -- AND CLO_Unit.descid = zc_ContainerLinkObject_Unit()
                                              -- AND CLO_Unit.objectid = vbUnitId
            WHERE 
                container.descid = zc_container_count() 
                AND
                Container.WhereObjectId = vbUnitId
                AND 
                Amount<>0
            GROUP BY 
                container.objectid
        ),
        RESERVE
        AS
        (
            SELECT
                MovementItem_Reserve.GoodsId,
                SUM(MovementItem_Reserve.Amount)::TFloat as Amount
            FROM
                gpSelect_MovementItem_CheckDeferred(inSession) as MovementItem_Reserve
            WHERE
                MovementItem_Reserve.MovementId <> inMovementId
            Group By
                MovementItem_Reserve.GoodsId
        ),
        CurrentMovement
        AS
        (
            SELECT
                ObjectId,
                SUM(Amount)::TFloat as Amount
            FROM
                MovementItem
            WHERE
                MovementId = inMovementId
                AND
                Amount <> 0
            Group By
                ObjectId
        )   

       SELECT Goods.Id,
              Goods.ValueData,
              Goods.ObjectCode,
              (GoodsRemains.Remains 
                - COALESCE(CurrentMovement.Amount,0) 
                - COALESCE(Reserve.Amount,0))::TFloat,
              round(object_Price_view.price, 2)::TFloat,
              Reserve.Amount::TFloat,
              object_Price_view.mcsvalue,
              Link_Goods_AlternativeGroup.ChildObjectId as AlternativeGroupId
       FROM GoodsRemains
       JOIN OBJECT AS Goods ON Goods.Id = GoodsRemains.ObjectId
       LEFT OUTER JOIN object_Price_view ON GoodsRemains.ObjectId = object_Price_view.goodsid
                                        AND object_Price_view.unitid = vbUnitId
       LEFT OUTER JOIN ObjectLink AS Link_Goods_AlternativeGroup
                                  ON Goods.Id = Link_Goods_AlternativeGroup.ObjectId
                                 AND Link_Goods_AlternativeGroup.DescId = zc_ObjectLink_Goods_AlternativeGroup()
       LEFT OUTER JOIN RESERVE ON GoodsRemains.ObjectId = RESERVE.GoodsId
       LEFT OUTER JOIN CurrentMovement ON GoodsRemains.ObjectId = CurrentMovement.ObjectId
     ORDER BY
       Goods.Id;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_CashRemains (Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А.
 10.09.15                        * округление цены
 22.08.15                                                         * разделение вип и отложеных
 19.08.15                                                         * CurrentMovement
 05.05.15                        *                            
*/

-- тест
-- SELECT * FROM gpSelect_CashRemains (inSession:= '308120')