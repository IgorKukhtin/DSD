-- Function: gpReport_CheckPartionDate()

DROP FUNCTION IF EXISTS gpReport_CheckPartionDate (Integer, Integer, Integer, TDateTime, TDateTime, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_CheckPartionDate(
    IN inUnitId              Integer  ,  -- Подразделение
    IN inRetailId            Integer  ,  -- ссылка на торг.сеть
    IN inJuridicalId         Integer  ,  -- юр.лицо
    IN inStartDate           TDateTime,  -- Дата начала
    IN inEndDate             TDateTime,  -- Дата окончания
    IN inIsExpirationDate    Boolean  ,  -- показать типы срок/ не срок
    IN inIsPartionDateKind   Boolean  ,  -- показать срок годности
    IN inisUnitList          Boolean,    --
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS TABLE (MovementId    Integer
             , OperDate      TDateTime
             , Invnumber     TVarChar
             , UnitId        Integer
             , UnitName      TVarChar
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
             , SummChangePercent TFloat
             , Persent       TFloat
             , PersentSale   TFloat
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
   DECLARE vbDate90   TDateTime;
   DECLARE vbDate30   TDateTime;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

    -- значения для разделения по срокам
    SELECT Date_6, Date_3, Date_1, Date_0
    INTO vbDate180, vbDate90, vbDate30, vbOperDate
    FROM lpSelect_PartionDateKind_SetDate ();

--raise notice 'Value 1: %', CLOCK_TIMESTAMP();

    CREATE TEMP TABLE tmpMovement_PD ON COMMIT DROP AS (
     WITH
        tmpUnit AS (SELECT inUnitId                                  AS UnitId
                    WHERE COALESCE (inUnitId, 0) <> 0
                      AND inisUnitList = FALSE
                   UNION
                    SELECT ObjectLink_Unit_Juridical.ObjectId        AS UnitId
                    FROM ObjectLink AS ObjectLink_Unit_Juridical
                         INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                               ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                              AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                              AND ((ObjectLink_Juridical_Retail.ChildObjectId = inRetailId AND inUnitId = 0)
                                                   OR (inRetailId = 0 AND inUnitId = 0))
                    WHERE ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                      AND (ObjectLink_Unit_Juridical.ChildObjectId = inJuridicalId OR inJuridicalId = 0)
                      AND inisUnitList = FALSE
                   UNION
                    SELECT ObjectBoolean_Report.ObjectId             AS UnitId
                    FROM ObjectBoolean AS ObjectBoolean_Report
                         LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                              ON ObjectLink_Unit_Juridical.ObjectId = ObjectBoolean_Report.ObjectId
                                             AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                    WHERE ObjectBoolean_Report.DescId = zc_ObjectBoolean_Unit_Report()
                      AND ObjectBoolean_Report.ValueData = TRUE
                      AND inisUnitList = TRUE
                   )

      , tmpMovementAll AS (SELECT Movement.*
                             , MovementLinkObject_Unit.ObjectId AS UnitId
                        FROM Movement
                             INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                           ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                          AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                        WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                          AND Movement.DescId = zc_Movement_Check()
                        )

                 SELECT Movement.*
                        FROM tmpMovementAll AS Movement
                             INNER JOIN tmpUnit ON tmpUnit.UnitId = Movement.UnitId
                        WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                          AND Movement.DescId = zc_Movement_Check()
                        );
                        
    ANALYSE tmpMovement_PD;
                        
--raise notice 'Value 2: %', CLOCK_TIMESTAMP();                        
                        
    CREATE TEMP TABLE tmpMI_Child_PD ON COMMIT DROP AS
                       (SELECT MovementItem.Id
                             , MovementItem.MovementId
                             , MovementItem.ParentId
                             , MovementItem.ObjectId
                             , MovementItem.Amount
                        FROM  tmpMovement_PD AS tmpMovement
                        
                              INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovement.Id 
                                                     AND MovementItem.DescId = zc_MI_Child()
                                                     AND MovementItem.IsErased = FALSE
                        );
                        
    ANALYSE tmpMI_Child_PD;

--raise notice 'Value 3: %', CLOCK_TIMESTAMP();

    -- Результат
    RETURN QUERY
    WITH
        tmpMIFloat_ContainerId AS (SELECT MovementItemFloat.MovementItemId
                                        , MovementItemFloat.ValueData :: Integer AS ContainerId
                                   FROM MovementItemFloat
                                   WHERE MovementItemFloat.MovementItemId IN (SELECT tmpMI_Child.Id FROM tmpMI_Child_PD AS tmpMI_Child)
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
                                               WHEN COALESCE (ObjectDate_PartionGoods.ValueData, zc_DateEnd()) > vbDate30 AND COALESCE (ObjectDate_PartionGoods.ValueData, zc_DateEnd()) <= vbDate90 THEN zc_Enum_PartionDateKind_3()
                                               WHEN COALESCE (ObjectDate_PartionGoods.ValueData, zc_DateEnd()) > vbDate90   AND COALESCE (ObjectDate_PartionGoods.ValueData, zc_DateEnd()) <= vbDate180 THEN zc_Enum_PartionDateKind_6()
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
                         WHERE MovementItem.Id IN (SELECT DISTINCT tmpMI_Child.ParentId FROM tmpMI_Child_PD AS tmpMI_Child)
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

      , tmpMIFloat_SummChangePercent AS (SELECT MovementItemFloat.*
                                         FROM MovementItemFloat
                                         WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI_Master.Id FROM tmpMI_Master)
                                           AND MovementItemFloat.DescId = zc_MIFloat_SummChangePercent()
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
                         , COALESCE (MIFloat_SummChangePercent.ValueData, 0)                                                            AS SummChangePercent
                         , CASE WHEN COALESCE (tmpIncome.PriceIncome * tmpMI_Child.Amount, 0) <> 0
                                THEN (100 - ((MIFloat_Price.ValueData * tmpMI_Child.Amount) * 100) / (tmpIncome.PriceIncome * tmpMI_Child.Amount))
                                ELSE 0
                           END                         AS Persent   -- % потери от продажи (определяем по пропорции 100%-запупка и X% - продажа)

                         , CASE WHEN COALESCE (MIFloat_PriceSale.ValueData * tmpMI_Child.Amount, 0) <> 0
                                THEN (100 - ((MIFloat_Price.ValueData * tmpMI_Child.Amount) * 100) / (MIFloat_PriceSale.ValueData * tmpMI_Child.Amount))
                                ELSE 0
                           END                         AS PersentSale   -- % потери от продажи (определяем по пропорции 100%-цена без скидки и X% - продажа)

                         , (MIFloat_Price.ValueData * tmpMI_Child.Amount - tmpIncome.PriceIncome * tmpMI_Child.Amount)                  AS SummDiff      -- сумма потери от продажи ( в денежном эквиваленте)
                         , (MIFloat_PriceSale.ValueData * tmpMI_Child.Amount - MIFloat_Price.ValueData * tmpMI_Child.Amount)            AS SummSaleDiff  -- разница суммы по цене продажи и цене без скидки
                         , tmpIncome.ExpirationDate
                         , tmpIncome.PartionDateKindId
                    FROM tmpMI_Child_PD AS tmpMI_Child
                         LEFT JOIN tmpIncome ON tmpIncome.MovementItemId = tmpMI_Child.Id
                         LEFT JOIN tmpMI_Master ON tmpMI_Master.Id = tmpMI_Child.ParentId
                         LEFT JOIN tmpMIFloat_PriceSale AS MIFloat_PriceSale
                                                        ON MIFloat_PriceSale.MovementItemId = tmpMI_Master.Id
                         LEFT JOIN tmpMIFloat_Price AS MIFloat_Price
                                                    ON MIFloat_Price.MovementItemId = tmpMI_Master.Id
                         LEFT JOIN tmpMIFloat_SummChangePercent AS MIFloat_SummChangePercent
                                                                ON MIFloat_SummChangePercent.MovementItemId = tmpMI_Master.Id
                    )

        -- результат
        SELECT tmpMovement.Id          AS MovementId
             , tmpMovement.OperDate    AS OperDate
             , tmpMovement.Invnumber   AS Invnumber
             , Object_Unit.Id          AS UnitId
             , Object_Unit.ValueData   AS UnitName
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
             , tmpData.SummChangePercent :: TFloat
             , tmpData.Persent         :: TFloat
             , tmpData.PersentSale     :: TFloat
             , tmpData.SummDiff        :: TFloat
             , tmpData.SummSaleDiff    :: TFloat

             , CASE WHEN inIsExpirationDate = TRUE THEN DATE_PART ('DAY', (tmpData.ExpirationDate - tmpMovement.OperDate)) ELSE 0 END :: TFloat DaysDiff
             , Object_PartionDateKind.ValueData :: TVarChar AS PartionDateKindName
             , CASE WHEN inIsExpirationDate = TRUE THEN tmpData.ExpirationDate ELSE NULL END :: TDateTime AS ExpirationDate
        FROM tmpData
           LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpData.GoodsId

           LEFT JOIN tmpMovement_PD AS tmpMovement ON tmpMovement.Id = tmpData.MovementId

           LEFT JOIN Object AS Object_PartionDateKind ON Object_PartionDateKind.Id = tmpData.PartionDateKindId
           LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpMovement.UnitId
        ;
        
--raise notice 'Value 4: %', CLOCK_TIMESTAMP();
        
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 15.07.19                                                      *
 04.07.19         *
 21.06.19         *
*/

-- тест SELECT * FROM gpReport_CheckPartionDate (inUnitId :=494882, inRetailId:= 0, inJuridicalId:=0, inStartDate := '01.12.2022' ::TDateTime, inEndDate := '31.12.2022' ::TDateTime, inIsExpirationDate:= TRUE, inIsPartionDateKind:=True, inisUnitList := false, inSession := '3' :: TVarChar);

SELECT * FROM gpReport_CheckPartionDate (inUnitId :=0, inRetailId:= 4, inJuridicalId:=0, inStartDate := '01.12.2022' ::TDateTime, inEndDate := '31.12.2022' ::TDateTime, inIsExpirationDate:= TRUE, inIsPartionDateKind:=True, inisUnitList := false, inSession := '3' :: TVarChar);
