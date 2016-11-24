-- Function: gpSelect_CashRemains_Diff_ver2()

DROP FUNCTION IF EXISTS gpSelect_CashRemains_Diff_ver2 (Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_CashRemains_Diff_ver2(
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
    NewRow Boolean,
    Color_calc Integer
)

AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
BEGIN
-- if inSession = '3' then return; end if;

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
       vbUnitKey := '0';
    END IF;
    vbUnitId := vbUnitKey::Integer;
    
    -- Обновили дату последнего обращения по сессии
    PERFORM lpInsertUpdate_CashSession (inCashSessionId := inCashSessionId
                                      , inDateConnect   := CURRENT_TIMESTAMP :: TDateTime
                                      , inUserId        := vbUserId
                                       );
    
    --определяем разницу в остатках реальных и сессионных
    CREATE TEMP TABLE _DIFF (ObjectId  Integer
                           , GoodsCode Integer
                           , GoodsName TVarChar
                           , Price     TFloat
                           , Remains   TFloat
                           , MCSValue  TFloat
                           , Reserved  TFloat
                           , NewRow    Boolean
                           , Color_calc Integer
                           , MinExpirationDate TDateTime) ON COMMIT DROP;    

    -- Данные
    WITH tmpContainer AS (SELECT Container.Id, Container.ObjectId, Container.Amount
                          FROM Container
                          WHERE Container.DescId = zc_Container_Count() 
                            AND Container.WhereObjectId = vbUnitId
                            AND Container.Amount <> 0
                         )
       , tmpCLO AS (SELECT CLO.*
                    FROM ContainerlinkObject AS CLO
                    WHERE CLO.ContainerId IN (SELECT tmpContainer.Id FROM tmpContainer)
                      AND CLO.DescId = zc_ContainerLinkObject_PartionMovementItem()
                   )
       , tmpObject AS (SELECT Object.* FROM Object WHERE Object.Id IN (SELECT tmpCLO.ObjectId FROM tmpCLO))
       , tmpExpirationDate AS (SELECT tmpCLO.ContainerId, MIDate_ExpirationDate.ValueData
                               FROM tmpCLO
                                    INNER JOIN tmpObject ON tmpObject.Id = tmpCLO.ObjectId
                                    INNER JOIN MovementItemDate AS MIDate_ExpirationDate
                                                                ON MIDate_ExpirationDate.MovementItemId = tmpObject.ObjectCode
                                                               AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()
                               )
       , GoodsRemains AS
     (SELECT Container.ObjectId
           , SUM (Container.Amount) AS Remains
           , MIN (COALESCE (tmpExpirationDate.ValueData, zc_DateEnd())) :: TDateTime AS MinExpirationDate -- Срок годности
      FROM tmpContainer AS Container
          -- находим партию
          LEFT JOIN tmpExpirationDate ON tmpExpirationDate.Containerid = Container.Id
          /*
          -- находим партию
          LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                        ON ContainerLinkObject_MovementItem.Containerid =  Container.Id
                                       AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
          LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId
          -- элемент прихода
          LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
          -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
          LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                      ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                     AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
          -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
          LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id = (MIFloat_MovementItem.ValueData :: Integer)
                     
          LEFT OUTER JOIN MovementItemDate AS MIDate_ExpirationDate
                                           ON MIDate_ExpirationDate.MovementItemId = COALESCE (MI_Income_find.Id,MI_Income.Id)  --Object_PartionMovementItem.ObjectCode
                                          AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()*/
      GROUP BY Container.ObjectId
     )

  , RESERVE AS 
       (SELECT
            MovementItem_Reserve.GoodsId,
            SUM(MovementItem_Reserve.Amount)::TFloat as Amount
        FROM
            gpSelect_MovementItem_CheckDeferred(inSession) as MovementItem_Reserve
        WHERE
            MovementItem_Reserve.MovementId <> inMovementId
        Group By
            MovementItem_Reserve.GoodsId
    ),
    SESSIONDATA --состояние в сессии
    AS
    (
        SELECT 
            CashSessionSnapShot.ObjectId,
            CashSessionSnapShot.Price,
            CashSessionSnapShot.Remains,
            CashSessionSnapShot.MCSValue,
            CashSessionSnapShot.Reserved,
            CashSessionSnapShot.MinExpirationDate
        FROM
            CashSessionSnapShot
        WHERE
            CashSessionSnapShot.CashSessionId = inCashSessionId
    )
    --заливаем разницу
    INSERT INTO _DIFF (ObjectId, GoodsCode, GoodsName, Price, Remains, MCSValue, Reserved, NewRow, Color_calc,MinExpirationDate)
    SELECT
        COALESCE(GoodsRemains.ObjectId,SESSIONDATA.ObjectId)         AS ObjectId
       ,Object_Goods.ObjectCode::Integer                             AS GoodsCode
       ,Object_Goods.ValueData                                       AS GoodsName
       ,ROUND(COALESCE(Object_Price_View.Price,0),2)                 AS Price
       ,COALESCE(GoodsRemains.Remains,0)-COALESCE(Reserve.Amount,0)  AS Remains
       ,Object_Price_View.MCSValue                                   AS MCSValue
       ,Reserve.Amount::TFloat                                       AS Reserved
       ,CASE 
          WHEN SESSIONDATA.ObjectId Is Null 
            THEN TRUE 
        ELSE FALSE 
        END                                              AS NewRow
       , CASE WHEN COALESCE(ObjectBoolean_First.ValueData, False) = TRUE THEN zc_Color_GreenL() ELSE zc_Color_White() END AS Color_calc 
       , GoodsRemains.MinExpirationDate
    FROM
        GoodsRemains
        FULL OUTER JOIN SESSIONDATA ON GoodsRemains.ObjectId = SESSIONDATA.ObjectId
        INNER JOIN Object AS Object_Goods
                          ON COALESCE(GoodsRemains.ObjectId,SESSIONDATA.ObjectId) = Object_Goods.Id
        LEFT OUTER JOIN Object_Price_View ON Object_Goods.Id = Object_Price_View.GoodsId
                                         AND Object_Price_View.UnitId = vbUnitId
        LEFT OUTER JOIN RESERVE ON Object_Goods.Id = RESERVE.GoodsId

        LEFT JOIN ObjectBoolean AS ObjectBoolean_First
                                ON ObjectBoolean_First.ObjectId = Object_Goods.Id
                               AND ObjectBoolean_First.DescId = zc_ObjectBoolean_Goods_First()
    WHERE
        ROUND(COALESCE(Object_Price_View.Price,0),2) <> COALESCE(SESSIONDATA.Price,0)
        OR
        COALESCE(GoodsRemains.Remains,0)-COALESCE(Reserve.Amount,0) <> COALESCE(SESSIONDATA.Remains,0)
        OR
        COALESCE(Object_Price_View.MCSValue,0) <> COALESCE(SESSIONDATA.MCSValue,0)
        OR
        COALESCE(Reserve.Amount,0) <> COALESCE(SESSIONDATA.Reserved,0);

    --Обновляем данные в сессии
    UPDATE CashSessionSnapShot SET
        Price = _DIFF.Price,
        Remains = _DIFF.Remains,
        MCSValue = _DIFF.MCSValue,
        Reserved = _DIFF.Reserved,
        MinExpirationDate = _DIFF.MinExpirationDate
    FROM
        _DIFF
    WHERE
        CashSessionSnapShot.CashSessionId = inCashSessionId
        AND
        CashSessionSnapShot.ObjectId = _DIFF.ObjectId;
    
    --доливаем те, что появились
    Insert Into CashSessionSnapShot(CashSessionId,ObjectId,Price,Remains,MCSValue,Reserved,MinExpirationDate)
    SELECT
        inCashSessionId
       ,_DIFF.ObjectId
       ,_DIFF.Price
       ,_DIFF.Remains
       ,_DIFF.MCSValue
       ,_DIFF.Reserved
       ,_DIFF.MinExpirationDate
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
            _DIFF.Remains,
            _DIFF.MCSValue,
            _DIFF.Reserved,
            _DIFF.NewRow,
            _DIFF.Color_calc
        FROM
            _DIFF;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_CashRemains_Diff_ver2 (Integer, TVarChar, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.
 16.03.16         * 
 12.09.15                                                                       *CashSessionSnapShot
*/