-- Function: gpSelect_Movement_Income()

DROP FUNCTION IF EXISTS gpSelect_CashRemains_Diff (Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_CashRemains_Diff(
    IN inMovementId    Integer,    -- Текущая накладная
    IN inCashSessionId TVarChar,   -- Сессия кассового места
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (
    Id Integer,
    GoodsCode Integer,
    GoodsName TVarChar,
    Price TFloat,
    Remains TFloat,
    MCSValue TFloat,
    Reserved TFloat,
    NewRow Boolean)

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
    
    --Обновили дату последнего обращения по сессии
    PERFORM lpInsertUpdate_CashSession(inCashSessionId := inCashSessionId,
                                        inDateConnect := CURRENT_TIMESTAMP::TDateTime);
    
    --определяем разницу в остатках реальных и сессионных
    CREATE TEMP TABLE _DIFF (ObjectId  Integer
                           , GoodsCode Integer
                           , GoodsName TVarChar
                           , Price     TFloat
                           , Remains   TFloat
                           , MCSValue  TFloat
                           , Reserved  TFloat
                           , NewRow    Boolean) ON COMMIT DROP;    
    WITH GoodsRemains
    AS
    (
        SELECT 
            SUM(Amount) AS Remains, 
            container.objectid 
        FROM container
            INNER JOIN containerlinkobject AS CLO_Unit
                                           ON CLO_Unit.containerid = container.id 
                                          AND CLO_Unit.descid = zc_ContainerLinkObject_Unit()
                                          AND CLO_Unit.objectid = vbUnitId
        WHERE 
            container.descid = zc_container_count() 
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
    REALDATA --реальное состояние товара
    AS
    (
        SELECT 
            GoodsRemains.ObjectId                             AS ObjectId
           ,COALESCE(Object_Price_View.Price,0)               AS Price
           ,(GoodsRemains.Remains 
                - COALESCE(RESERVE.Amount,0))::TFloat         AS Remains
           ,Object_Price_View.MCSValue                        AS MCSValue
           ,Reserve.Amount::TFloat                            AS Reserved
        FROM
            GoodsRemains
            LEFT OUTER JOIN Object_Price_View ON GoodsRemains.ObjectId = Object_Price_View.GoodsId
                                             AND Object_Price_View.UnitId = vbUnitId
            LEFT OUTER JOIN RESERVE ON GoodsRemains.ObjectId = RESERVE.GoodsId
    ),
    SESSIONDATA --состояние в сессии
    AS
    (
        SELECT 
            CashSessionSnapShot.ObjectId,
            CashSessionSnapShot.Price,
            CashSessionSnapShot.Remains,
            CashSessionSnapShot.MCSValue,
            CashSessionSnapShot.Reserved
        FROM
            CashSessionSnapShot
        WHERE
            CashSessionSnapShot.CashSessionId = inCashSessionId
    )
    --заливаем разницу
    INSERT INTO _DIFF (ObjectId, GoodsCode, GoodsName, Price, Remains, MCSValue, Reserved, NewRow)
    SELECT
        COALESCE(REALDATA.ObjectId,SESSIONDATA.ObjectId) AS ObjectId
       ,Object_Goods.ObjectCode::Integer                 AS GoodsCode
       ,Object_Goods.ValueData                           AS GoodsName
       ,COALESCE(REALDATA.Price,0)                       AS Price
       ,COALESCE(REALDATA.Remains,0)                     AS Remains
       ,REALDATA.MCSValue                                AS MCSValue
       ,REALDATA.Reserved                                AS Reserved
       ,CASE 
          WHEN SESSIONDATA.ObjectId Is Null 
            THEN TRUE 
        ELSE FALSE 
        END                                              AS NewRow
    FROM
        REALDATA
        FULL OUTER JOIN SESSIONDATA ON REALDATA.ObjectId = SESSIONDATA.ObjectId
        INNER JOIN Object AS Object_Goods
                          ON COALESCE(REALDATA.ObjectId,SESSIONDATA.ObjectId) = Object_Goods.Id
    WHERE
        COALESCE(REALDATA.Price,0) <> COALESCE(SESSIONDATA.Price,0)
        OR
        COALESCE(REALDATA.Remains,0) <> COALESCE(SESSIONDATA.Remains,0)
        OR
        COALESCE(REALDATA.MCSValue,0) <> COALESCE(SESSIONDATA.MCSValue,0)
        OR
        COALESCE(REALDATA.Reserved,0) <> COALESCE(SESSIONDATA.Reserved,0);
    --Обновляем данные в сессии
    UPDATE CashSessionSnapShot SET
        Price = _DIFF.Price,
        Remains = _DIFF.Remains,
        MCSValue = _DIFF.MCSValue,
        Reserved = _DIFF.Reserved
    FROM
        _DIFF
    WHERE
        CashSessionSnapShot.CashSessionId = inCashSessionId
        AND
        CashSessionSnapShot.ObjectId = _DIFF.ObjectId;
    
    --доливаем те, что появились
    Insert Into CashSessionSnapShot(CashSessionId,ObjectId,Price,Remains,MCSValue,Reserved)
    SELECT
        inCashSessionId
       ,_DIFF.ObjectId
       ,_DIFF.Price
       ,_DIFF.Remains
       ,_DIFF.MCSValue
       ,_DIFF.Reserved
    FROM
        _DIFF
    WHERE
        _DIFF.NewRow = TRUE;
    --Возвращаем разницу в клиента
    RETURN QUERY
        SELECT
            _DIFF.ObjectId,
            _DIFF.GoodsCode,
            _DIFF.GoodsName,
            _DIFF.Price,
            (_DIFF.Remains - COALESCE(CurrentMovement.Amount,0))::TFloat AS Remains,
            _DIFF.MCSValue,
            _DIFF.Reserved,
            _DIFF.NewRow
        FROM
            _DIFF
            LEFT OUTER JOIN (
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
                            ) AS CurrentMovement
                              ON CurrentMovement.ObjectId = _DIFF.ObjectId;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_CashRemains_Diff (Integer, TVarChar, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.
 12.09.15                                                                       *CashSessionSnapShot
*/