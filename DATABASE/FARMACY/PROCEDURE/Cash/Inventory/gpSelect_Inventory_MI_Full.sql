-- Function: gpSelect_Inventory_MI_Full()

DROP FUNCTION IF EXISTS gpSelect_Inventory_MI_Full (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Inventory_MI_Full(
    IN inUnitId       Integer   , -- Подразделение
    IN inOperDate     TDateTime , -- Дата инвентаризации
    IN inSession      TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , UnitId Integer
             , GoodsId Integer
             , Amount TFloat
             , Price TFloat
             , Remains TFloat, ExpirationDate TDateTime
             , AmountUser TFloat, CountUser Integer
             , MIComment TVarChar, isAuto Boolean
             )
AS
$BODY$
DECLARE
  vbUserId Integer;
  vbObjectId Integer;
  vbMovementId Integer;

  vbUnitId Integer;
  vbOperDate TDateTime;
  vbIsFullInvent Boolean;
  vbIsRemains Boolean;
  vbStatusId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Inventory());
    -- inShowAll:= TRUE;
    vbUserId:= lpGetUserBySession (inSession);
    vbObjectId := lpGet_DefaultValue ('zc_Object_Retail', vbUserId);
    vbIsRemains := True;


    --определяем подразделение и дату документа
    
    vbMovementId := ( SELECT Movement.Id
                      FROM Movement
                           INNER JOIN MovementLinkObject AS MLO_Unit
                                                         ON MLO_Unit.MovementId = Movement.Id
                                                        AND MLO_Unit.DescId = zc_MovementLinkObject_Unit()
                                                        AND MLO_Unit.ObjectId = inUnitId
                           INNER JOIN MovementBoolean AS MovementBoolean_FullInvent
                                                      ON MovementBoolean_FullInvent.MovementId = Movement.Id
                                                     AND MovementBoolean_FullInvent.DescId = zc_MovementBoolean_FullInvent()
                                                     AND MovementBoolean_FullInvent.ValueData = True
                      WHERE Movement.OperDate >= inOperDate
                        AND Movement.OperDate <= inOperDate + INTERVAL '4 DAY'
                        AND Movement.DescId = zc_Movement_Inventory()
                        AND Movement.StatusId = zc_Enum_Status_UnComplete());
      
    IF COALESCE(vbMovementId, 0) = 0
    THEN
      RAISE EXCEPTION 'Полная инвентаризация по подразделению <%> не найдена.%Необходимо создать документ полной инв в Farmacy', lfGet_Object_ValueData (inUnitId), Chr(13);
    END IF;

    -- вытягиваем дату и подразделение и ...
    SELECT DATE_TRUNC ('DAY', Movement.OperDate) + INTERVAL '1 DAY' AS OperDate     -- при рассчете остатка добавил 1 день для условия >=
         , MLO_Unit.ObjectId                                        AS UnitId
         , COALESCE (MB_FullInvent.ValueData, FALSE)                AS isFullInvent
         , Movement.StatusId
           INTO vbOperDate
              , vbUnitId
              , vbIsFullInvent
              , vbStatusId
    FROM Movement
         INNER JOIN MovementLinkObject AS MLO_Unit
                                       ON MLO_Unit.MovementId = Movement.Id
                                      AND MLO_Unit.DescId = zc_MovementLinkObject_Unit()
         LEFT OUTER JOIN MovementBoolean AS MB_FullInvent
                                         ON MB_FullInvent.MovementId = Movement.Id
                                        AND MB_FullInvent.DescId = zc_MovementBoolean_FullInvent()
    WHERE Movement.Id = vbMovementId;

-- raise notice 'Value 1: %', CLOCK_TIMESTAMP();

    -- остатки
    CREATE TEMP TABLE tmpContainer ON COMMIT DROP AS
                                       (SELECT
                                             Container.Id AS ContainerId
                                           , Container.ObjectId  -- Товар
                                           , Container.Amount - COALESCE (SUM (MovementItemContainer.Amount), 0.0) AS Amount
                                        FROM Container
                                            LEFT OUTER JOIN MovementItemContainer ON MovementItemContainer.ContainerId = Container.Id
                                                                                 -- AND DATE_TRUNC ('DAY', MovementItemContainer.Operdate) > vbOperDate
                                                                                 AND MovementItemContainer.Operdate >= vbOperDate
                                        WHERE
                                            Container.DescID = zc_Container_Count()
                                        AND Container.WhereObjectId = vbUnitId
                                        GROUP BY
                                            Container.Id
                                           ,Container.ObjectId
                                        HAVING Container.Amount - COALESCE (SUM (MovementItemContainer.Amount), 0) <> 0

                                       UNION ALL
                                        -- надо минуснуть то что в проводках (тогда получим расчетный остаток, при этом фактический - это тот что вводит пользователь)
                                        SELECT
                                             Container.Id  AS ContainerId
                                           , Container.ObjectId  -- Товар
                                           , -1 * SUM (MovementItemContainer.Amount) AS Amount
                                        FROM MovementItemContainer
                                            INNER JOIN Container ON Container.Id = MovementItemContainer.ContainerId
                                        WHERE MovementItemContainer.DescID = zc_MIContainer_Count()
                                          AND MovementItemContainer.MovementId = vbMovementId
                                        GROUP BY
                                            Container.Id
                                           ,Container.ObjectId
                                    );
                                    
    ANALYSE tmpContainer;

    -- остатки на начало следующего дня
    CREATE TEMP TABLE tmpREMAINS ON COMMIT DROP AS
                               (
                                SELECT
                                    T0.ObjectId
                                   ,SUM (T0.Amount) :: TFloat AS Amount
                                   ,MIN (COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) )  AS minExpirationDate   -- min срок годности
                                FROM tmpContainer AS T0

                                     -- находим срок годности из прихода
                                    LEFT JOIN ContainerlinkObject AS CLO_PartionMovementItem
                                                                  ON CLO_PartionMovementItem.Containerid = T0.ContainerId
                                                                 AND CLO_PartionMovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                                    LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLO_PartionMovementItem.ObjectId
                                    -- элемент прихода
                                    LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                                    -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                                    LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                                ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                               AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                                    -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
                                    LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id = (MIFloat_MovementItem.ValueData :: Integer)

                                    LEFT OUTER JOIN MovementItemDate  AS MIDate_ExpirationDate
                                                                      ON MIDate_ExpirationDate.MovementItemId = COALESCE (MI_Income_find.Id,MI_Income.Id)  --Object_PartionMovementItem.ObjectCode
                                                                     AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()

                                GROUP BY T0.ObjectId
                                HAVING SUM (T0.Amount) <> 0
                            );
                            
    ANALYSE tmpREMAINS;

        -- РЕЗУЛЬТАТ
        RETURN QUERY
            WITH tmpPrice AS (SELECT Price_Goods.ChildObjectId               AS GoodsId
                                   , ROUND(Price_Value.ValueData,2)::TFloat  AS Price
                              FROM ObjectLink AS ObjectLink_Price_Unit
                                   LEFT JOIN ObjectLink AS Price_Goods
                                          ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                         AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                                   LEFT JOIN ObjectFloat AS Price_Value
                                          ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                         AND Price_Value.DescId =  zc_ObjectFloat_Price_Value()
                              WHERE ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                                AND ObjectLink_Price_Unit.ChildObjectId = vbUnitId
                             )
                 -- проводки
               , tmpMI_calc AS (SELECT MIContainer.MovementItemId
                                     , SUM (MIContainer.Amount) AS Diff
                                FROM MovementItemContainer AS MIContainer
                               WHERE MIContainer.MovementId = vbMovementId
                                 AND MIContainer.DescId     = zc_MIContainer_Count()
                               GROUP BY MIContainer.MovementItemId
                              )

                 -- строчная часть
               , tmpMI AS (SELECT MovementItem.Id            AS Id
                                , MovementItem.ObjectId      AS ObjectId
                                , MovementItem.Amount        AS Amount
                                , MIFloat_Price.ValueData    AS Price
                                , MIFloat_Summ.ValueData     AS Summ
                                , MIFloat_Remains.ValueData  AS Remains
                                , MovementItem.isErased      AS isErased
                                , MIString_Comment.ValueData AS MIComment
                                , MIBoolean_isAuto.ValueData AS isAuto

                                , COALESCE (tmpMI_calc.Diff, 0) AS Diff_calc
                                , COALESCE (tmpMI_calc.Diff, 0) * COALESCE (MIFloat_Price.ValueData, 0) AS DiffSumm_calc
                                , CASE WHEN tmpMI_calc.Diff < 0 THEN -1 * tmpMI_calc.Diff * COALESCE (MIFloat_Price.ValueData, 0) ELSE 0 END AS DeficitSumm_calc
                                , CASE WHEN tmpMI_calc.Diff > 0 THEN  1 * tmpMI_calc.Diff * COALESCE (MIFloat_Price.ValueData, 0) ELSE 0 END AS ProficitSumm_calc

                            FROM MovementItem
                                 LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                             ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                            AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                 LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                                             ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                                            AND MIFloat_Summ.DescId = zc_MIFloat_Summ()
                                 LEFT JOIN MovementItemFloat AS MIFloat_Remains
                                                             ON MIFloat_Remains.MovementItemId = MovementItem.Id
                                                            AND MIFloat_Remains.DescId = zc_MIFloat_Remains()
                                                            AND vbStatusId = zc_Enum_Status_Complete()
                                 LEFT OUTER JOIN MovementItemString AS MIString_Comment
                                                                    ON MIString_Comment.MovementItemId = MovementItem.Id
                                                                   AND MIString_Comment.DescId = zc_MIString_Comment()
                                 LEFT JOIN MovementItemBoolean AS MIBoolean_isAuto
                                                               ON MIBoolean_isAuto.MovementItemId = MovementItem.Id
                                                              AND MIBoolean_isAuto.DescId = zc_MIBoolean_isAuto()
                                 LEFT JOIN tmpMI_calc ON tmpMI_calc.MovementItemId = MovementItem.Id

                            WHERE MovementItem.MovementId = vbMovementId
                              AND MovementItem.DescId     = zc_MI_Master()
                              AND MovementItem.isErased  = FALSE
                           )
         -- строчная часть чайлд
         , tmpMI_Child AS (SELECT tmp.ParentId
                                , COUNT (tmp.Num)::Integer         AS CountUser
                                , SUM (tmp.AmountUser)::TFloat     AS AmountUser
                           FROM (SELECT MovementItem.ParentId      AS ParentId
                                      , CASE WHEN MovementItem.ObjectId = vbUserId THEN MovementItem.Amount ELSE 0 END   AS AmountUser
                                      , CAST (ROW_NUMBER() OVER (PARTITION BY MovementItem.ParentId, MovementItem.ObjectId ORDER BY MovementItem.ParentId, MovementItem.ObjectId, MIDate_Insert.ValueData DESC) AS Integer) AS Num
                                 FROM MovementItem
                                      LEFT JOIN MovementItemDate AS MIDate_Insert
                                                                 ON MIDate_Insert.MovementItemId = MovementItem.Id
                                                                AND MIDate_Insert.DescId = zc_MIDate_Insert()
                                 WHERE MovementItem.MovementId = vbMovementId
                                   AND MovementItem.DescId     = zc_MI_Child()
                                   AND MovementItem.isErased  = FALSE
                                 ) AS tmp
                           WHERE tmp.Num = 1
                           GROUP BY tmp.ParentId
                           )

            -- Результат
            SELECT                
                MovementItem.Id
              , inUnitId                                                            AS UnitId
              , COALESCE(MovementItem.ObjectId, REMAINS.ObjectId)                   AS GoodsId
              , MovementItem.Amount                                                 AS Amount

              , CASE WHEN MovementItem.ObjectId > 0 THEN MovementItem.Price ELSE tmpPrice.Price END :: TFloat AS Price
              , REMAINS.Amount  :: TFloat                                           AS Remains
              , REMAINS.minExpirationDate ::TDateTime
              , tmpMI_Child.AmountUser
              , tmpMI_Child.CountUser
              , MovementItem.MIComment                                              AS MIComment
              , CASE WHEN MovementItem.ObjectId > 0 THEN COALESCE (MovementItem.isAuto, FALSE) ELSE TRUE END :: Boolean AS isAuto

            FROM tmpREMAINS AS REMAINS
                FULL JOIN tmpMI AS MovementItem ON MovementItem.ObjectId = REMAINS.ObjectId

                LEFT JOIN tmpPrice ON tmpPrice.GoodsId = COALESCE (MovementItem.ObjectId, REMAINS.ObjectId)

                LEFT JOIN tmpMI_Child ON tmpMI_Child.ParentId = MovementItem.Id

            ;

    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Inventory_MI_Full (Integer, TDateTime, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 25.05.123                                                      *
*/

-- тест

select * from gpSelect_Inventory_MI_Full(inUnitId := 183289 , inOperDate := '19.05.2023' ,  inSession := '3');