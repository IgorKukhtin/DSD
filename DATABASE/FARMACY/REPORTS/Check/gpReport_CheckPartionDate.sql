-- Function: gpReport_CheckPartionDate()

DROP FUNCTION IF EXISTS gpReport_CheckPartionDate (Integer, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_CheckPartionDate(
    IN inUnitId           Integer  ,  -- Подразделение
    IN inStartDate        TDateTime,  -- Дата начала
    IN inEndDate          TDateTime,  -- Дата окончания
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (MovementId    Integer
             , OperDate      TDateTime
             , Invnumber     TVarChar
             , GoodsId       Integer
             , GoodsCode     Integer
             , GoodsName     TVarChar
             , Amount        TFloat
             , PriceIncome   TFloat
             , PriceSale     TFloat
             , SumIncome     TFloat
             , SumSale       TFloat
             , Persent       TFloat
             , SummDiff      TFloat
             )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

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
                        )

      , tmpMIFloat_Price AS (SELECT MovementItemFloat.*
                             FROM MovementItemFloat
                             WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpContainer.MI_Id_Income FROM tmpContainer)
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
                      FROM tmpContainer
                           LEFT JOIN tmpMLO_NDSKind ON tmpMLO_NDSKind.MovementId = tmpContainer.MovementId_Income
        
                           LEFT JOIN tmpMovementBoolean AS MovementBoolean_PriceWithVAT
                                                        ON MovementBoolean_PriceWithVAT.MovementId = tmpContainer.MovementId_Income

                           LEFT JOIN tmpMIFloat_Price AS MIFloat_Price
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
      , tmpData AS (SELECT tmpMI_Child.MovementId      AS MovementId
                         , tmpMI_Child.Id              AS MI_Id_Child
                         , tmpMI_Child.ObjectId        AS GoodsId
                         , tmpMI_Child.Amount          AS Amount
                         , tmpIncome.PriceIncome       AS PriceIncome                   -- цена закупки
                         , MIFloat_PriceSale.ValueData AS PriceSale                     -- цена продажи
                         , tmpIncome.PriceIncome * tmpMI_Child.Amount                                                                   AS SumIncome
                         , MIFloat_PriceSale.ValueData * tmpMI_Child.Amount                                                             AS SumSale
                         , (((MIFloat_PriceSale.ValueData * tmpMI_Child.Amount) * 100) / (tmpIncome.PriceIncome * tmpMI_Child.Amount))  AS Persent   -- % потери от продажи (определяем по пропорции 100%-запупка и X% - продажа)
                         , (MIFloat_PriceSale.ValueData * tmpMI_Child.Amount - tmpIncome.PriceIncome * tmpMI_Child.Amount)              AS SummDiff -- сумма потери от продажи ( в денежном эквиваленте)
                    FROM tmpMI_Child
                         LEFT JOIN tmpIncome ON tmpIncome.MovementItemId = tmpMI_Child.Id
                         LEFT JOIN tmpMI_Master ON tmpMI_Master.Id = tmpMI_Child.ParentId
                         LEFT JOIN tmpMIFloat_PriceSale AS MIFloat_PriceSale
                                                        ON MIFloat_PriceSale.MovementItemId = tmpMI_Master.Id
                         
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
             , tmpData.PriceSale       :: TFloat
             , tmpData.SumIncome       :: TFloat
             , tmpData.SumSale         :: TFloat
             , tmpData.Persent         :: TFloat
             , tmpData.SummDiff        :: TFloat
        FROM tmpData 
           LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpData.GoodsId

           LEFT JOIN Movement ON Movement.Id = tmpData.MovementId
        ;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.06.19         *
*/

-- тест
--SELECT * FROM gpReport_CheckPartionDate (inUnitId := 0, inStartDate := '01.05.2019' ::TDateTime, inEndDate := '01.07.2019' ::TDateTime, inSession := '3' :: TVarChar);