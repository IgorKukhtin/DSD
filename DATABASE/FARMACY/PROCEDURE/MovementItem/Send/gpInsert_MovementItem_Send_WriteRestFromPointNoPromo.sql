-- Function: gpInsert_MovementItem_Send_WriteRestFromPoint()

DROP FUNCTION IF EXISTS gpInsert_MovementItem_Send_WriteRestFromPointNoPromo (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_MovementItem_Send_WriteRestFromPointNoPromo(
    IN inMovementId  Integer      , -- ключ Документа
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS Void
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbUnitFromId Integer;
    DECLARE vbUnitToId Integer;
    DECLARE vbisAuto Boolean;
    DECLARE vbOperDate TDateTime;
    DECLARE vbOperDateEnd TDateTime;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_Insert_MI_Send_Remains());
    -- vbUserId:= lpGetUserBySession (inSession);

    -- определяется подразделение
    SELECT MovementLinkObject_From.ObjectId
         , MovementLinkObject_To.ObjectId
         , COALESCE(MovementBoolean_isAuto.ValueData, False) :: Boolean
         , date_trunc('day', Movement.OperDate)
    INTO vbUnitFromId
       , vbUnitToId
       , vbisAuto
       , vbOperDate
    FROM Movement
        INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                      ON MovementLinkObject_From.MovementId = Movement.ID
                                     AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
        INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                      ON MovementLinkObject_To.MovementId = Movement.ID
                                     AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
        LEFT JOIN MovementBoolean AS MovementBoolean_isAuto
                                  ON MovementBoolean_isAuto.MovementId = Movement.Id
                                 AND MovementBoolean_isAuto.DescId = zc_MovementBoolean_isAuto()
    WHERE Movement.Id = inMovementId;

    vbOperDateEnd := vbOperDate + INTERVAL '1 DAY';
    
    CREATE TEMP TABLE tmpMIPromo ON COMMIT DROP AS
     SELECT DISTINCT MI_Goods.ObjectId                  AS GoodsId
     FROM Movement
       INNER JOIN MovementLinkObject AS MovementLinkObject_Maker
                                     ON MovementLinkObject_Maker.MovementId = Movement.Id
                                    AND MovementLinkObject_Maker.DescId = zc_MovementLinkObject_Maker()

       INNER JOIN MovementDate AS MovementDate_StartPromo
                               ON MovementDate_StartPromo.MovementId = Movement.Id
                              AND MovementDate_StartPromo.DescId = zc_MovementDate_StartPromo()
       INNER JOIN MovementDate AS MovementDate_EndPromo
                               ON MovementDate_EndPromo.MovementId = Movement.Id
                              AND MovementDate_EndPromo.DescId = zc_MovementDate_EndPromo()

       INNER JOIN MovementItem AS MI_Goods ON MI_Goods.MovementId = Movement.Id
                                          AND MI_Goods.DescId = zc_MI_Master()
                                          AND MI_Goods.isErased = FALSE
     WHERE Movement.StatusId = zc_Enum_Status_Complete()
       AND Movement.DescId = zc_Movement_Promo()
       AND MovementDate_StartPromo.ValueData <= vbOperDate
       AND MovementDate_EndPromo.ValueData >= vbOperDate;
       
    ANALYSE tmpMIPromo;
    
    CREATE TEMP TABLE tmpRemains ON COMMIT DROP AS
    SELECT Container.ObjectId                  AS GoodsId
         , SUM(Container.Amount)::TFloat       AS Amount
         , AVG(MIFloat_Price.ValueData)::TFloat AS PriceIn
         , MIN(COALESCE(MIDate_ExpirationDate.ValueData,zc_DateEnd()))::TDateTime AS MinExpirationDate -- Срок годности
    FROM Container
        INNER JOIN ContainerLinkObject AS ContainerLinkObject_Unit
                                       ON Container.Id = ContainerLinkObject_Unit.ContainerId
                                      AND ContainerLinkObject_Unit.DescId = zc_ContainerLinkObject_Unit()
                                      AND ContainerLinkObject_Unit.ObjectId = vbUnitFromId
        INNER JOIN ContainerLinkObject AS CLI_MI
                                       ON CLI_MI.ContainerId = Container.Id
                                      AND CLI_MI.DescId = zc_ContainerLinkObject_PartionMovementItem()
        INNER JOIN OBJECT AS Object_PartionMovementItem
                          ON Object_PartionMovementItem.Id = CLI_MI.ObjectId
        INNER JOIN MovementItem ON MovementItem.Id = Object_PartionMovementItem.ObjectCode

        -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
        LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
               ON MIFloat_MovementItem.MovementItemId = MovementItem.Id
              AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
        -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
        LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id = (MIFloat_MovementItem.ValueData :: Integer)

        LEFT OUTER JOIN MovementItemFloat AS MIFloat_Price
                                          ON MIFloat_Price.MovementItemId = COALESCE (MI_Income_find.Id,MovementItem.Id)
                                         AND MIFloat_Price.DescId = zc_MIFloat_Price()

        LEFT JOIN MovementItemDate  AS MIDate_ExpirationDate
               ON MIDate_ExpirationDate.MovementItemId = COALESCE (MI_Income_find.Id,MovementItem.Id)
              AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()
                                          
        LEFT JOIN tmpMIPromo ON tmpMIPromo.GoodsId = Container.ObjectId 

    WHERE Container.DescId = zc_Container_Count()
      AND Container.Amount <> 0
      AND COALESCE (tmpMIPromo.GoodsId, 0) = 0
     -- AND 1=0
    GROUP BY Container.ObjectId
  --  HAVING SUM(Container.Amount) <> 0
  ;
                              
    ANALYSE tmpRemains;
                                 
    CREATE TEMP TABLE MovementItem_Send ON COMMIT DROP AS
    SELECT MovementItem_Send.Id
       , MovementItem_Send.ObjectId
       , MovementItem_Send.Amount
       , MovementItem_Send.IsErased
       , MILinkObject_ReasonDifferences.ObjectId AS ReasonDifferencesId

       , SUM(MIContainer_Count.Amount * MIFloat_Price.ValueData)/SUM(MIContainer_Count.Amount)  AS PriceIn
       , ABS(SUM(MIContainer_Count.Amount * MIFloat_Price.ValueData))                           AS SumPriceIn
       , COALESCE(MIFloat_PriceFrom.ValueData,0)     AS PriceFrom
       , COALESCE(MIFloat_PriceTo.ValueData,0)       AS PriceTo

       , COALESCE(ABS(SUM(MIContainer_Count.Amount * COALESCE (MIFloat_JuridicalPrice.ValueData, 0))/SUM(MIContainer_Count.Amount)),0) ::TFloat  AS Price
       , COALESCE(ABS(SUM(MIContainer_Count.Amount * COALESCE (MIFloat_JuridicalPrice.ValueData, 0))),0)                               ::TFloat  AS Summa
       , COALESCE(ABS(SUM(MIContainer_Count.Amount * COALESCE (MIFloat_PriceWithVAT.ValueData, 0))/SUM(MIContainer_Count.Amount)),0)   ::TFloat  AS PriceWithVAT
       , COALESCE(ABS(SUM(MIContainer_Count.Amount * COALESCE (MIFloat_PriceWithVAT.ValueData, 0))),0)                                 ::TFloat  AS SummaWithVAT
       , COALESCE(MIFloat_AmountManual.ValueData,0)   ::TFloat  AS AmountManual

    FROM MovementItem AS MovementItem_Send
        -- цена подразделений записанная при автоматическом распределении
        LEFT OUTER JOIN MovementItemFloat AS MIFloat_PriceFrom
                                          ON MIFloat_PriceFrom.MovementItemId = MovementItem_Send.ID
                                         AND MIFloat_PriceFrom.DescId = zc_MIFloat_PriceFrom()
        LEFT OUTER JOIN MovementItemFloat AS MIFloat_PriceTo
                                          ON MIFloat_PriceTo.MovementItemId = MovementItem_Send.ID
                                         AND MIFloat_PriceTo.DescId = zc_MIFloat_PriceTo()

        LEFT OUTER JOIN MovementItemContainer AS MIContainer_Count
                                              ON MIContainer_Count.MovementItemId = MovementItem_Send.Id
                                             AND MIContainer_Count.DescId = zc_Container_Count()
                                             AND MIContainer_Count.isActive = True
        LEFT JOIN MovementItemFloat AS MIFloat_AmountManual
                                    ON MIFloat_AmountManual.MovementItemId = MovementItem_Send.Id
                                   AND MIFloat_AmountManual.DescId = zc_MIFloat_AmountManual()
        LEFT JOIN MovementItemLinkObject AS MILinkObject_ReasonDifferences
                                         ON MILinkObject_ReasonDifferences.MovementItemId = MovementItem_Send.Id
                                        AND MILinkObject_ReasonDifferences.DescId = zc_MILinkObject_ReasonDifferences()

        LEFT OUTER JOIN ContainerLinkObject AS CLI_MI
                                            ON CLI_MI.ContainerId = MIContainer_Count.ContainerId
                                           AND CLI_MI.DescId = zc_ContainerLinkObject_PartionMovementItem()
        LEFT OUTER JOIN Object AS Object_PartionMovementItem
                               ON Object_PartionMovementItem.Id = CLI_MI.ObjectId
        LEFT OUTER JOIN MovementItem ON MovementItem.Id = Object_PartionMovementItem.ObjectCode
        LEFT OUTER JOIN MovementItemFloat AS MIFloat_Price
                                          ON MIFloat_Price.MovementItemId = MovementItem.ID
                                         AND MIFloat_Price.DescId = zc_MIFloat_Price()

        -- цена с учетом НДС, для элемента прихода от поставщика (или NULL)
        LEFT JOIN MovementItemFloat AS MIFloat_JuridicalPrice
                                    ON MIFloat_JuridicalPrice.MovementItemId = MovementItem.ID
                                   AND MIFloat_JuridicalPrice.DescId = zc_MIFloat_JuridicalPrice()
        -- цена с учетом НДС, для элемента прихода от поставщика без % корректировки  (или NULL)
        LEFT JOIN MovementItemFloat AS MIFloat_PriceWithVAT
                                    ON MIFloat_PriceWithVAT.MovementItemId = MovementItem.Id
                                   AND MIFloat_PriceWithVAT.DescId = zc_MIFloat_PriceWithVAT()

    WHERE MovementItem_Send.MovementId = inMovementId
      AND MovementItem_Send.DescId = zc_MI_Master()
      AND MovementItem_Send.isErased = FALSE
    GROUP BY MovementItem_Send.Id
           , MovementItem_Send.ObjectId
           , MovementItem_Send.Amount
           , MovementItem_Send.IsErased
           , MILinkObject_ReasonDifferences.ObjectId
           , COALESCE(MIFloat_PriceFrom.ValueData,0)
           , COALESCE(MIFloat_PriceTo.ValueData,0)
           , COALESCE(MIFloat_AmountManual.ValueData,0);
           
    ANALYSE MovementItem_Send;
                                     

    PERFORM gpInsertUpdate_MovementItem_Send(ioId := Id,
                                             inMovementId := inMovementId,
                                             inGoodsId := GoodsId,
                                             inAmount := AmountRemains,
                                             inPrice := PriceIn,
                                             inPriceUnitFrom := 0,
                                             ioPriceUnitTo := 0,
                                             inAmountManual := AmountRemains,
                                             inAmountStorage:= AmountRemains,        -- Факт кол-во точки-отправителя
                                             inReasonDifferencesId := 0,
                                             inCommentSendID       := 0,
                                             inSession := inSession) 
    FROM
            (SELECT
                COALESCE(MovementItem_Send.Id,0)                            AS Id
              , COALESCE(MovementItem_Send.ObjectId,tmpRemains.GoodsId)     AS GoodsId
              , tmpRemains.Amount::TFloat                                   AS AmountRemains
              , COALESCE(MovementItem_Send.PriceIn, tmpRemains.PriceIn)::TFloat  AS PriceIn

            FROM tmpRemains
                FULL OUTER JOIN MovementItem_Send ON tmpRemains.GoodsId = MovementItem_Send.ObjectId
                LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = COALESCE(MovementItem_Send.ObjectId,tmpRemains.GoodsId)

            WHERE Object_Goods.isErased = FALSE
               or MovementItem_Send.id is not null) AS tempResult
            WHERE  COALESCE (PriceIn, 0) > 0;

      PERFORM gpInsert_Object_Price_BySend(inUnitId := vbUnitToId,
                                           inGoodsId := GoodsId,
                                           inAmount := Amount,
                                           inPriceNew := PriceUnitFrom,
                                           ioPriceUnitTo := 0,
                                           inSession := inSession)
      FROM (
        WITH
            MovementItem_Send AS (SELECT MovementItem.Id
                                       , MovementItem.ObjectId
                                       , MovementItem.Amount

                                  FROM MovementItem
                                  WHERE MovementItem.MovementId = inMovementId
                                    AND MovementItem.DescId = zc_MI_Master()
                                    AND MovementItem.isErased = FALSE
                                 )

           , tmpPrice AS (SELECT MovementItem_Send.ObjectId     AS GoodsId
                               , ObjectLink_Unit.ChildObjectId  AS UnitId
                               , Price_DateChange.valuedata     AS DateChange
                               , ROUND (ObjectFloat_Price_Value.ValueData, 2)  AS Price
                          FROM MovementItem_Send
                               INNER JOIN ObjectLink AS ObjectLink_Goods
                                                     ON ObjectLink_Goods.ChildObjectId = MovementItem_Send.ObjectId
                                                    AND ObjectLink_Goods.DescId        = zc_ObjectLink_Price_Goods()
                               INNER JOIN ObjectLink AS ObjectLink_Unit
                                                     ON ObjectLink_Unit.ObjectId      = ObjectLink_Goods.ObjectId
                                                    AND ObjectLink_Unit.ChildObjectId in (vbUnitFromId, vbUnitToId)
                                                    AND ObjectLink_Unit.DescId        = zc_ObjectLink_Price_Unit()
                               LEFT JOIN ObjectFloat AS ObjectFloat_Price_Value
                                                     ON ObjectFloat_Price_Value.ObjectId = ObjectLink_Goods.ObjectId
                                                    AND ObjectFloat_Price_Value.DescId   = zc_ObjectFloat_Price_Value()
                               LEFT JOIN ObjectDate AS Price_DateChange
                                                    ON Price_DateChange.ObjectId = ObjectLink_Goods.ObjectId
                                                   AND Price_DateChange.DescId   = zc_ObjectDate_Price_DateChange()
                         )

       SELECT
             MovementItem_Send.Id                              AS Id
           , MovementItem_Send.ObjectId                        AS GoodsId

           , MovementItem_Send.Amount                          AS Amount

           , Object_Price_From.Price::TFloat  AS PriceUnitFrom
           , Object_Price_From.DateChange
           , Object_Price_To.Price::TFloat  AS PriceUnitTo
           , Object_Price_To.DateChange

       FROM MovementItem_Send
            LEFT JOIN tmpPrice AS Object_Price_From
                               ON Object_Price_From.GoodsId = MovementItem_Send.ObjectId
                              AND Object_Price_From.UnitId = vbUnitFromId
            LEFT JOIN tmpPrice AS Object_Price_To
                               ON Object_Price_To.GoodsId = MovementItem_Send.ObjectId
                              AND Object_Price_To.UnitId = vbUnitToId
       WHERE Object_Price_To.Price IS Null
          OR Object_Price_From.Price::TFloat > Object_Price_To.Price::TFloat) AS SetPrice;



END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpInsert_MovementItem_Send_WriteRestFromPoint (Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 25.05.19         *
 05.06.18         *

*/

-- тест
-- select * from gpInsert_MovementItem_Send_WriteRestFromPointNoPromo(inMovementId := 33738754 ,  inSession := '3');