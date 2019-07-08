-- Function: gpReport_CheckPartionDate()

DROP FUNCTION IF EXISTS gpReport_CheckPartionDate (Integer, TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpReport_CheckPartionDate (Integer, TDateTime, TDateTime, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_CheckPartionDate(
    IN inUnitId              Integer  ,  -- Подразделение
    IN inStartDate           TDateTime,  -- Дата начала
    IN inEndDate             TDateTime,  -- Дата окончания
    IN inIsExpirationDate    Boolean  ,  -- показать типы срок/ не срок
    IN inIsPartionDateKind   Boolean  ,  -- показать срок годности
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS TABLE (MovementId    Integer
             , OperDate      TDateTime
             , Invnumber     TVarChar
             , GoodsId       Integer
             , GoodsCode     Integer
             , GoodsName     TVarChar
             , Amount        TFloat
             , PriceIncome   TFloat
             , Price         TFloat
             , PriceSale     TFloat
             , SumIncome     TFloat
             , Summ          TFloat
             , SumSale       TFloat
             , Persent       TFloat
             , SummDiff      TFloat
             , SummSaleDiff  TFloat
             , DaysDiff      TFloat
             , PartionDateKindName TVarChar
             , ExpirationDate      TDateTime
             )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbOperDate TDateTime;
   DECLARE vbDate180  TDateTime;
   DECLARE vbDate30   TDateTime;

   DECLARE vbMonth_0  TFloat;
   DECLARE vbMonth_1  TFloat;
   DECLARE vbMonth_6  TFloat;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

    -- получаем значения из справочника 
    vbMonth_0 := (SELECT ObjectFloat_Month.ValueData
                  FROM Object  AS Object_PartionDateKind
                       LEFT JOIN ObjectFloat AS ObjectFloat_Month
                                             ON ObjectFloat_Month.ObjectId = Object_PartionDateKind.Id
                                            AND ObjectFloat_Month.DescId = zc_ObjectFloat_PartionDateKind_Month()
                  WHERE Object_PartionDateKind.Id = zc_Enum_PartionDateKind_0());
    vbMonth_1 := (SELECT ObjectFloat_Month.ValueData
                  FROM Object  AS Object_PartionDateKind
                       LEFT JOIN ObjectFloat AS ObjectFloat_Month
                                             ON ObjectFloat_Month.ObjectId = Object_PartionDateKind.Id
                                            AND ObjectFloat_Month.DescId = zc_ObjectFloat_PartionDateKind_Month()
                  WHERE Object_PartionDateKind.Id = zc_Enum_PartionDateKind_1());
    vbMonth_6 := (SELECT ObjectFloat_Month.ValueData
                  FROM Object  AS Object_PartionDateKind
                       LEFT JOIN ObjectFloat AS ObjectFloat_Month
                                             ON ObjectFloat_Month.ObjectId = Object_PartionDateKind.Id
                                            AND ObjectFloat_Month.DescId = zc_ObjectFloat_PartionDateKind_Month()
                  WHERE Object_PartionDateKind.Id = zc_Enum_PartionDateKind_6());

    -- даты + 6 месяцев, + 1 месяц
    vbDate180 := CURRENT_DATE + (vbMonth_6||' MONTH' ) ::INTERVAL;
    vbDate30  := CURRENT_DATE + (vbMonth_1||' MONTH' ) ::INTERVAL;
    vbOperDate:= CURRENT_DATE + (vbMonth_0||' MONTH' ) ::INTERVAL;

    -- Результат
    RETURN QUERY
    WITH 
        tmpMovement AS (SELECT *
                        FROM Movement
                             INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                           ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                          AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                          AND MovementLinkObject_Unit.ObjectId = inUnitId
                        WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                          AND Movement.DescId = zc_Movement_Check()
                        )

      , tmpMI_Child AS (SELECT *
                        FROM MovementItem
                        WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                          AND MovementItem.DescId = zc_MI_Child()
                          AND MovementItem.IsErased = FALSE
                        )

      , tmpMIFloat_ContainerId AS (SELECT MovementItemFloat.MovementItemId
                                        , MovementItemFloat.ValueData :: Integer AS ContainerId
                                   FROM MovementItemFloat
                                   WHERE MovementItemFloat.MovementItemId IN (SELECT tmpMI_Child.Id FROM tmpMI_Child)
                                     AND MovementItemFloat.DescId = zc_MIFloat_ContainerId()
                                   )
      --
      , tmpContainer AS (SELECT tmp.MovementItemId
                              , COALESCE (MI_Income_find.MovementId, MI_Income.MovementId) AS MovementId_Income
                              , COALESCE (MI_Income_find.Id,MI_Income.Id)                  AS MI_Id_Income
                              , CASE WHEN inIsExpirationDate = TRUE THEN COALESCE (ObjectDate_PartionGoods.ValueData, zc_DateEnd()) ELSE NULL END :: TDateTime AS ExpirationDate

                              , CASE WHEN inIsPartionDateKind = TRUE 
                                     THEN CASE WHEN COALESCE (ObjectDate_PartionGoods.ValueData, zc_DateEnd()) <= vbOperDate THEN zc_Enum_PartionDateKind_0()
                                               WHEN COALESCE (ObjectDate_PartionGoods.ValueData, zc_DateEnd()) > vbOperDate AND COALESCE (ObjectDate_PartionGoods.ValueData, zc_DateEnd()) <= vbDate30 THEN zc_Enum_PartionDateKind_1()
                                               WHEN COALESCE (ObjectDate_PartionGoods.ValueData, zc_DateEnd()) > vbDate30   AND COALESCE (ObjectDate_PartionGoods.ValueData, zc_DateEnd()) <= vbDate180 THEN zc_Enum_PartionDateKind_6()
                                               ELSE 0
                                          END
                                     ELSE 0
                                END                                                        AS PartionDateKindId
                         FROM tmpMIFloat_ContainerId AS tmp
                              LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                                            ON ContainerLinkObject_MovementItem.Containerid = tmp.ContainerId
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

                              LEFT JOIN ContainerlinkObject AS ContainerLinkObject_PartionGoods
                                                            ON ContainerLinkObject_PartionGoods.Containerid = tmp.ContainerId
                                                           AND ContainerLinkObject_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
                              LEFT JOIN ObjectDate AS ObjectDate_PartionGoods
                                                   ON ObjectDate_PartionGoods.ObjectId = ContainerLinkObject_PartionGoods.ObjectId
                                                  AND ObjectDate_PartionGoods.DescId = zc_ObjectDate_PartionGoods_Value()
                        )

      , tmpMIFloat_Price_In AS (SELECT MovementItemFloat.*
                                FROM MovementItemFloat
                                WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpContainer.MI_Id_Income FROM tmpContainer)
                                  AND MovementItemFloat.DescId = zc_MIFloat_Price()
                                )

      , tmpMovementBoolean AS (SELECT MovementBoolean.*
                               FROM MovementBoolean
                               WHERE MovementBoolean.MovementId IN (SELECT DISTINCT tmpContainer.MovementId_Income FROM tmpContainer)
                                 AND MovementBoolean.DescId = zc_MovementBoolean_PriceWithVAT()
                               )

      , tmpMLO_NDSKind AS (SELECT MovementLinkObject.MovementId
                                , ObjectFloat_NDSKind_NDS.ValueData AS NDS
                           FROM MovementLinkObject
                                LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                                      ON ObjectFloat_NDSKind_NDS.ObjectId = MovementLinkObject.ObjectId
                                                     AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
                           WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpContainer.MovementId_Income FROM tmpContainer)
                             AND MovementLinkObject.DescId = zc_MovementLinkObject_NDSKind()
                           )

      , tmpIncome AS (SELECT tmpContainer.MovementItemId
                           , CASE WHEN MovementBoolean_PriceWithVAT.ValueData = TRUE THEN MIFloat_Price.ValueData
                                  ELSE (MIFloat_Price.ValueData * (1 + tmpMLO_NDSKind.NDS/100))::TFloat
                             END AS PriceIncome
                           , tmpContainer.ExpirationDate
                           , tmpContainer.PartionDateKindId
                      FROM tmpContainer
                           LEFT JOIN tmpMLO_NDSKind ON tmpMLO_NDSKind.MovementId = tmpContainer.MovementId_Income
        
                           LEFT JOIN tmpMovementBoolean AS MovementBoolean_PriceWithVAT
                                                        ON MovementBoolean_PriceWithVAT.MovementId = tmpContainer.MovementId_Income

                           LEFT JOIN tmpMIFloat_Price_In AS MIFloat_Price
                                                         ON MIFloat_Price.MovementItemId = tmpContainer.MI_Id_Income
                        )

      , tmpMI_Master AS (SELECT MovementItem.*
                         FROM MovementItem
                         WHERE MovementItem.Id IN (SELECT DISTINCT tmpMI_Child.ParentId FROM tmpMI_Child)
                           AND MovementItem.DescId = zc_MI_Master()
                           AND MovementItem.IsErased = FALSE
                         )

      , tmpMIFloat_PriceSale AS (SELECT MovementItemFloat.*
                                 FROM MovementItemFloat
                                 WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI_Master.Id FROM tmpMI_Master)
                                   AND MovementItemFloat.DescId = zc_MIFloat_PriceSale()
                                 )

      , tmpMIFloat_Price AS (SELECT MovementItemFloat.*
                             FROM MovementItemFloat
                             WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI_Master.Id FROM tmpMI_Master)
                               AND MovementItemFloat.DescId = zc_MIFloat_Price()
                             )

      , tmpData AS (SELECT tmpMI_Child.MovementId      AS MovementId
                         , tmpMI_Child.Id              AS MI_Id_Child
                         , tmpMI_Child.ObjectId        AS GoodsId
                         , tmpMI_Child.Amount          AS Amount
                         , tmpIncome.PriceIncome       AS PriceIncome                   -- цена закупки
                         , MIFloat_PriceSale.ValueData AS PriceSale                     -- цена продажи
                         , MIFloat_Price.ValueData     AS Price
                         , tmpIncome.PriceIncome * tmpMI_Child.Amount                                                                   AS SumIncome
                         , MIFloat_PriceSale.ValueData * tmpMI_Child.Amount                                                             AS SumSale
                         , MIFloat_Price.ValueData * tmpMI_Child.Amount                                                                 AS Summ
                         , CASE WHEN COALESCE (tmpIncome.PriceIncome * tmpMI_Child.Amount, 0) <> 0
                                THEN (100 - ((MIFloat_Price.ValueData * tmpMI_Child.Amount) * 100) / (tmpIncome.PriceIncome * tmpMI_Child.Amount))
                                ELSE 0
                           END                         AS Persent   -- % потери от продажи (определяем по пропорции 100%-запупка и X% - продажа)
                         , (MIFloat_Price.ValueData * tmpMI_Child.Amount - tmpIncome.PriceIncome * tmpMI_Child.Amount)                  AS SummDiff      -- сумма потери от продажи ( в денежном эквиваленте)
                         , (MIFloat_PriceSale.ValueData * tmpMI_Child.Amount - MIFloat_Price.ValueData * tmpMI_Child.Amount)            AS SummSaleDiff  -- разница суммы по цене продажи и цене без скидки
                         , tmpIncome.ExpirationDate
                         , tmpIncome.PartionDateKindId
                    FROM tmpMI_Child
                         LEFT JOIN tmpIncome ON tmpIncome.MovementItemId = tmpMI_Child.Id
                         LEFT JOIN tmpMI_Master ON tmpMI_Master.Id = tmpMI_Child.ParentId
                         LEFT JOIN tmpMIFloat_PriceSale AS MIFloat_PriceSale
                                                        ON MIFloat_PriceSale.MovementItemId = tmpMI_Master.Id
                         LEFT JOIN tmpMIFloat_Price AS MIFloat_Price
                                                    ON MIFloat_Price.MovementItemId = tmpMI_Master.Id
                    )

        -- результат
        SELECT Movement.Id             AS MovementId
             , Movement.OperDate       AS OperDate
             , Movement.Invnumber      AS Invnumber
             , Object_Goods.Id         AS GoodsId
             , Object_Goods.ObjectCode AS GoodsCode
             , Object_Goods.ValueData  AS GoodsName

             , tmpData.Amount          :: TFloat
             , tmpData.PriceIncome     :: TFloat
             , tmpData.Price           :: TFloat
             , tmpData.PriceSale       :: TFloat
             , tmpData.SumIncome       :: TFloat
             , tmpData.Summ            :: TFloat
             , tmpData.SumSale         :: TFloat
             , tmpData.Persent         :: TFloat
             , tmpData.SummDiff        :: TFloat
             , tmpData.SummSaleDiff    :: TFloat

             , CASE WHEN inIsExpirationDate = TRUE THEN DATE_PART ('DAY', (tmpData.ExpirationDate - Movement.OperDate)) ELSE 0 END :: TFloat DaysDiff
             , Object_PartionDateKind.ValueData :: TVarChar AS PartionDateKindName
             , CASE WHEN inIsExpirationDate = TRUE THEN tmpData.ExpirationDate ELSE NULL END :: TDateTime AS ExpirationDate
        FROM tmpData 
           LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpData.GoodsId

           LEFT JOIN Movement ON Movement.Id = tmpData.MovementId

           LEFT JOIN Object AS Object_PartionDateKind ON Object_PartionDateKind.Id = tmpData.PartionDateKindId
        ;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.07.19         *
 21.06.19         *
*/

-- тест
--
--SELECT * FROM gpReport_CheckPartionDate (inUnitId :=494882, inStartDate := '21.06.2019' ::TDateTime, inEndDate := '23.06.2019' ::TDateTime, inIsExpirationDate:= FALSE, inIsPartionDateKind:= FALSE, inSession := '3' :: TVarChar);
--SELECT * FROM gpReport_CheckPartionDate (inUnitId :=494882, inStartDate := '21.06.2019' ::TDateTime, inEndDate := '23.06.2019' ::TDateTime, inIsExpirationDate:= TRUE, inIsPartionDateKind:=True, inSession := '3' :: TVarChar);
