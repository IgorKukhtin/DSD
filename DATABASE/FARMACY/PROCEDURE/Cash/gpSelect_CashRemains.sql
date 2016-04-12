-- Function: gpSelect_Movement_Income()

DROP FUNCTION IF EXISTS gpSelect_CashRemains_ver2 (TVarChar);
DROP FUNCTION IF EXISTS gpSelect_CashRemains_ver2 (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_CashRemains_ver2 (Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_CashRemains_ver2(
    IN inMovementId    Integer,    -- Текущая накладная
    IN inCashSessionId TVarChar,   -- Сессия кассового места
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, GoodsName TVarChar, GoodsCode Integer,
               Remains TFloat, Price TFloat, Reserved TFloat, MCSValue TFloat,
               AlternativeGroupId Integer, NDS TFloat,
               isFirst boolean, isSecond boolean, Color_calc Integer
               )
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
    
    --Объявили новую сессию кассового места / обновили дату последнего обращения
    PERFORM lpInsertUpdate_CashSession(inCashSessionId := inCashSessionId,
                                        inDateConnect := CURRENT_TIMESTAMP::TDateTime);
    --Очистили содержимое снапшета сессии
    DELETE FROM CashSessionSnapShot
    WHERE CashSessionId = inCashSessionId;
                                        
    WITH GoodsRemains
    AS
    (
        SELECT 
            SUM(Amount) AS Remains, 
            container.objectid 
        FROM container
        WHERE 
            container.descid = zc_container_count() 
            AND 
            Container. WhereObjectId = vbUnitId
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
    )   
    --залили снапшот
    INSERT INTO CashSessionSnapShot(CashSessionId,ObjectId,Price,Remains,MCSValue,Reserved)
    SELECT 
        inCashSessionId                             AS CashSession
       ,GoodsRemains.ObjectId                       AS GoodsId
       ,COALESCE(Object_Price_View.Price,0)         AS Price
       ,(GoodsRemains.Remains 
            - COALESCE(Reserve.Amount,0))::TFloat   AS Remains
       ,Object_Price_View.MCSValue                  AS MCSValue
       ,Reserve.Amount::TFloat                      AS Reserved
    FROM
        GoodsRemains
        LEFT OUTER JOIN Object_Price_View ON GoodsRemains.ObjectId = Object_Price_View.GoodsId
                                         AND Object_Price_View.UnitId = vbUnitId
        LEFT OUTER JOIN RESERVE ON GoodsRemains.ObjectId = RESERVE.GoodsId;
            
    RETURN QUERY
        SELECT 
            Goods.Id,
            Goods.ValueData,
            Goods.ObjectCode,
            CashSessionSnapShot.Remains,
            CashSessionSnapShot.Price,
            CashSessionSnapShot.Reserved,
            CashSessionSnapShot.MCSValue,
            Link_Goods_AlternativeGroup.ChildObjectId as AlternativeGroupId,
            ObjectFloat_NDSKind_NDS.ValueData AS NDS,
            COALESCE(ObjectBoolean_First.ValueData, False)          AS isFirst,
            COALESCE(ObjectBoolean_Second.ValueData, False)         AS isSecond,
            CASE WHEN COALESCE(ObjectBoolean_First.ValueData, False) = TRUE THEN zc_Color_GreenL() WHEN COALESCE(ObjectBoolean_Second.ValueData, False) = TRUE THEN 10965163  ELSE zc_Color_White() END AS Color_calc
        FROM
            CashSessionSnapShot
            JOIN OBJECT AS Goods ON Goods.Id = CashSessionSnapShot.ObjectId
            LEFT OUTER JOIN ObjectLink AS Link_Goods_AlternativeGroup
                                       ON Goods.Id = Link_Goods_AlternativeGroup.ObjectId
                                      AND Link_Goods_AlternativeGroup.DescId = zc_ObjectLink_Goods_AlternativeGroup()
            LEFT OUTER JOIN ObjectLink AS ObjectLink_Goods_NDSKind
                                       ON ObjectLink_Goods_NDSKind.ObjectId = Goods.Id
                                      AND ObjectLink_Goods_NDSKind.DescId = zc_ObjectLink_Goods_NDSKind()
            LEFT OUTER JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                        ON ObjectFloat_NDSKind_NDS.ObjectId = ObjectLink_Goods_NDSKind.ChildObjectId 

            LEFT JOIN ObjectBoolean AS ObjectBoolean_First
                                    ON ObjectBoolean_First.ObjectId = Goods.Id
                                   AND ObjectBoolean_First.DescId = zc_ObjectBoolean_Goods_First()
            LEFT JOIN ObjectBoolean AS ObjectBoolean_Second
                                    ON ObjectBoolean_Second.ObjectId = Goods.Id
                                   AND ObjectBoolean_Second.DescId = zc_ObjectBoolean_Goods_Second()            
        WHERE
            CashSessionSnapShot.CashSessionId = inCashSessionId
        ORDER BY
            Goods.Id;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_CashRemains_ver2 (Integer, TVarChar, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.
 12.04.16         *
 02.11.15                                                                       *NDS
 10.09.15                                                                       *CashSessionSnapShot
 22.08.15                                                                       *разделение вип и отложеных
 19.08.15                                                                       *CurrentMovement
 05.05.15                        *

*/

-- тест
-- SELECT * FROM gpSelect_CashRemains (inSession:= '308120')