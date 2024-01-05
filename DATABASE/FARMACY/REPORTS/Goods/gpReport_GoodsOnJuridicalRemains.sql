 -- Function: gpReport_GoodsOnJuridicalRemains()

DROP FUNCTION IF EXISTS gpReport_GoodsOnJuridicalRemains (TDateTime, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_GoodsOnJuridicalRemains(
    IN inRemainsDate          TDateTime,  -- Дата остатка
    IN inIsDeferredSend       Boolean,    -- Отложенные перемещения
    IN inIsDeferredReturnOut  Boolean,    -- Отложенные возвраты поставщику
    IN inSession              TVarChar    -- сессия пользователя
)
RETURNS TABLE (JuridicalCode   Integer
             , JuridicalName   TVarChar
             , UnitName        TVarChar
             , NDS             TFloat
             , Amount          TFloat
             , SummaWithOutVAT TFloat
             , SummaWithVAT    TFloat
             , AmountPD        TFloat
             , SummaWithVATPD  TFloat
             )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);
    -- Ограничение на просмотр товарного справочника
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

    CREATE TEMP TABLE tmpContainerCount (ContainerId Integer, UnitId Integer, GoodsId Integer, Amount TFloat, AmountPD TFloat) ON COMMIT DROP;

    raise notice 'Value 01: %', CLOCK_TIMESTAMP();
    WITH tmpMovement AS (SELECT Movement.id
                         FROM Movement
                              INNER JOIN MovementBoolean AS MovementBoolean_Deferred
                                                         ON MovementBoolean_Deferred.MovementId = Movement.Id
                                                        AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
                                                        AND MovementBoolean_Deferred.ValueData = True
                         WHERE (Movement.DescId = zc_Movement_Send() AND inIsDeferredSend = TRUE OR
                                Movement.DescId = zc_Movement_ReturnOut() AND inIsDeferredReturnOut = TRUE)
                           AND Movement.StatusId = zc_Enum_Status_UnComplete())

       , tmpContainerDeferred AS (SELECT MIContainer.ContainerId
                                       , SUM(MIContainer.Amount)::TFloat  AS Amount    
                                  FROM tmpMovement AS Movement

                                       INNER JOIN MovementItemContainer AS MIContainer
                                                                        ON MIContainer.MovementId = Movement.Id
                                                                       AND MIContainer.OperDate < inRemainsDate
                                                                       AND MIContainer.DescId = zc_MIContainer_Count()
                                  GROUP BY MIContainer.ContainerId
                                  )
       , tmpContainerDeferredPD AS (SELECT MIContainer.ContainerId
                                         , SUM(MIContainer.Amount)::TFloat  AS Amount    
                                    FROM tmpMovement AS Movement

                                         INNER JOIN MovementItemContainer AS MIContainer
                                                                          ON MIContainer.MovementId = Movement.Id
                                                                         AND MIContainer.OperDate < inRemainsDate
                                                                         AND MIContainer.DescId = zc_MIContainer_CountPartionDate()
                                                                                                                                                                                           
                                    GROUP BY MIContainer.ContainerId
                                    )
       , tmpContainerPD AS (SELECT Container.Id
                                 , Container.ParentId
                                 , Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) - COALESCE (MAX (ContainerDeferred.Amount), 0) AS Amount
                            FROM Container

                                 LEFT JOIN MovementItemContainer AS MIContainer
                                                                 ON MIContainer.ContainerId = Container.Id
                                                                AND MIContainer.OperDate >= inRemainsDate

                                 LEFT JOIN tmpContainerDeferredPD AS ContainerDeferred
                                                                ON ContainerDeferred.ContainerId = Container.Id

                                 LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                                              AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()

                                 LEFT JOIN ObjectDate AS ObjectDate_ExpirationDate
                                                      ON ObjectDate_ExpirationDate.ObjectId = ContainerLinkObject.ObjectId
                                                     AND ObjectDate_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()

                            WHERE Container.DescId = zc_Container_CountPartionDate()
                              AND Container.WhereObjectId IN (SELECT Id FROM gpSelect_Object_Unit_Active (inNotUnitId := 0, inSession := '3'))
                              AND COALESCE (ObjectDate_ExpirationDate.ValueData, zc_DateEnd()) <= CURRENT_DATE
                           GROUP BY Container.Id
                                  , Container.ParentId
                                  , Container.Amount
                           HAVING Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) - COALESCE (MAX (ContainerDeferred.Amount), 0) <> 0)
       , tmpDataPD AS (SELECT tmpContainerPD.ParentId AS ContainerId
                            , Sum(tmpContainerPD.Amount) :: TFloat       AS Amount
                       FROM tmpContainerPD 
                       GROUP BY tmpContainerPD.ParentId)

    INSERT INTO tmpContainerCount(ContainerId, UnitId, GoodsId, Amount, AmountPD)
    SELECT Container.Id                   AS ContainerId
         , Container.WhereObjectId        AS UnitId 
         , Container.ObjectId             AS GoodsId
         , Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) - COALESCE (MAX (tmpContainerDeferred.Amount), 0) AS Amount
         , MAX(tmpDataPD.Amount)::TFloat  AS AmountPD
    FROM Container
        LEFT JOIN MovementItemContainer AS MIContainer
                                        ON MIContainer.ContainerId = Container.Id
                                       AND MIContainer.OperDate >= inRemainsDate
        LEFT JOIN tmpContainerDeferred ON tmpContainerDeferred.ContainerId = Container.Id
        LEFT JOIN tmpDataPD ON tmpDataPD.ContainerId = Container.Id
    WHERE Container.DescId = zc_Container_Count()
        AND Container.WhereObjectId IN (SELECT Id FROM gpSelect_Object_Unit_Active (inNotUnitId := 0, inSession := inSession))
    GROUP BY Container.Id
           , Container.WhereObjectId
           , Container.ObjectId
           , Container.Amount
    HAVING Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) - COALESCE (MAX (tmpContainerDeferred.Amount), 0) <> 0;

    --!!!!!!!!!!!!!!!!!!!!!
    ANALYZE tmpContainerCount;
    
    raise notice 'Value 02: % <%>', CLOCK_TIMESTAMP(), (SELECT COUNT(*) FROM tmpContainerCount);
    
    CREATE TEMP TABLE tmpRemains (ContainerId Integer, UnitId Integer, GoodsId Integer, NDSKindId_Income Integer, Amount TFloat, PriceWithOutVAT TFloat, PriceWithVAT TFloat, AmountPD TFloat) ON COMMIT DROP;
    
    WITH tmpContainer AS (SELECT Container.ContainerId
                               , Container.UnitId 
                               , Container.GoodsId
                               , Container.Amount
                               , Container.AmountPD
                               , COALESCE (MI_Income_find.MovementId, MI_Income.MovementId) :: Integer AS MovementId
                               , COALESCE (MI_Income_find.Id, MI_Income.Id):: Integer AS MovementItemId
                         FROM tmpContainerCount AS Container
                              -- партия
                              LEFT OUTER JOIN ContainerLinkObject AS CLI_MI
                                                                  ON CLI_MI.ContainerId = Container.ContainerId
                                                                 AND CLI_MI.DescId = zc_ContainerLinkObject_PartionMovementItem()
                              LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLI_MI.ObjectId
                              -- элемент прихода
                              LEFT OUTER JOIN MovementItem AS MI_Income
                                                           ON MI_Income.Id = Object_PartionMovementItem.ObjectCode :: Integer

                              -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                              LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                          ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                         AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                              -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
                              LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id = (MIFloat_MovementItem.ValueData :: Integer)
                         )

    INSERT INTO tmpRemains(ContainerId, UnitId, GoodsId, NDSKindId_Income, Amount, PriceWithOutVAT, PriceWithVAT, AmountPD)
    SELECT Container.ContainerId
         , Container.UnitId 
         , Container.GoodsId
         , MovementLinkObject_NDSKind_Income.ObjectId  AS NDSKindId_Income
         , Container.Amount
         , MIFloat_PriceWithOutVAT.ValueData           AS PriceWithOutVAT
         , MIFloat_PriceWithVAT.ValueData              AS PriceWithVAT
         , Container.AmountPD
    FROM tmpContainer AS Container
         LEFT JOIN MovementItemFloat AS MIFloat_PriceWithVAT
                                     ON MIFloat_PriceWithVAT.MovementItemId = Container.MovementItemId
                                    AND MIFloat_PriceWithVAT.DescId = zc_MIFloat_PriceWithVAT()
         -- цена без учета НДС, для элемента прихода от поставщика без % корректировки  (или NULL)
         LEFT JOIN MovementItemFloat AS MIFloat_PriceWithOutVAT
                                     ON MIFloat_PriceWithOutVAT.MovementItemId = Container.MovementItemId
                                    AND MIFloat_PriceWithOutVAT.DescId = zc_MIFloat_PriceWithOutVAT()
         -- Вид НДС, для элемента прихода от поставщика (или NULL)
         LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind_Income
                                      ON MovementLinkObject_NDSKind_Income.MovementId = Container.MovementId
                                     AND MovementLinkObject_NDSKind_Income.DescId = zc_MovementLinkObject_NDSKind()
                                     AND COALESCE (MovementLinkObject_NDSKind_Income.ObjectId, 0) <> 13937605
   ;

    ANALYSE tmpRemains;

    raise notice 'Value 03: % <%>', CLOCK_TIMESTAMP(), (SELECT COUNT(*) FROM tmpRemains);

    -- Результат
    RETURN QUERY
        WITH
        tmpNDSKind AS (SELECT ObjectFloat.*
                       FROM ObjectFloat
                       WHERE ObjectFloat.DescId = zc_ObjectFloat_NDSKind_NDS()  
                       ),
        tmpData AS (SELECT tmpRemains.UnitId
                         , tmpNDSKind.ValueData                                         AS NDS
                         , Sum(tmpRemains.Amount)::TFloat                               AS Amount
                         , Sum(tmpRemains.Amount * tmpRemains.PriceWithOutVAT)::TFloat  AS SummaWithOutVAT
                         , Sum(tmpRemains.Amount * tmpRemains.PriceWithVAT)::TFloat     AS SummaWithVAT
                         , Sum(tmpRemains.AmountPD)::TFloat                             AS AmountPD
                         , Sum(tmpRemains.AmountPD * tmpRemains.PriceWithVAT)::TFloat   AS SummaWithVATPD
                    FROM tmpRemains
                         LEFT JOIN Object_Goods_Retail AS tmpGoodsRetail ON tmpGoodsRetail.Id = tmpRemains.GoodsId
                         LEFT JOIN Object_Goods_Main AS tmpGoods ON tmpGoods.Id = tmpGoodsRetail.GoodsMainId                    
                         LEFT JOIN tmpNDSKind ON tmpNDSKind.ObjectId = COALESCE (tmpRemains.NDSKindId_Income, tmpGoods.NDSKindId)
                    GROUP BY tmpRemains.UnitId
                           , tmpNDSKind.ValueData  
                    )

               

        -- Результат
        SELECT Object_Juridical.ObjectCode      AS JuridicalCode
             , Object_Juridical.ValueData       AS JuridicalName
             , Object_Unit.ValueData            AS UnitName
             , tmpData.NDS                      AS NDS
             , tmpData.Amount                   AS Amount
             , tmpData.SummaWithOutVAT          AS SummaWithOutVAT
             , tmpData.SummaWithVAT             AS SummaWithVAT
             , tmpData.AmountPD                 AS AmountPD
             , tmpData.SummaWithVATPD           AS SummaWithVATPD
        FROM tmpData
        
            LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                 ON ObjectLink_Unit_Juridical.ObjectId = tmpData.UnitId
                                AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()

            LEFT JOIN Object AS Object_Unit  ON Object_Unit.ID = tmpData.UnitId

            LEFT JOIN Object AS Object_Juridical  ON Object_Juridical.ID = ObjectLink_Unit_Juridical.ChildObjectId
            
        ORDER BY Object_Juridical.ValueData
               , Object_Unit.ValueData
               , tmpData.NDS    
        ;

    raise notice 'Value 20: %', CLOCK_TIMESTAMP();

END;

$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 21.06.18                                                                     *
*/

-- тест
--


select * from gpReport_GoodsOnJuridicalRemains(inRemainsDate := ('01.01.2024')::TDateTime , inIsDeferredSend := 'True' , inIsDeferredReturnOut := 'False' , inSession := '3');