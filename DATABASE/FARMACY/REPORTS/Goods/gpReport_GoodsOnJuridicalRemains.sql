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
             , Amount          TFloat
             , SummaWithVAT    TFloat
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

    CREATE TEMP TABLE tmpContainerCount (ContainerId Integer, UnitId Integer, GoodsId Integer, Amount TFloat) ON COMMIT DROP;

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

    INSERT INTO tmpContainerCount(ContainerId, UnitId, GoodsId, Amount)
    SELECT Container.Id                AS ContainerId
         , Container.WhereObjectId     AS UnitId 
         , Container.ObjectId          AS GoodsId
         , Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) - COALESCE (MAX (tmpContainerDeferred.Amount), 0) AS Amount
    FROM Container
        LEFT JOIN MovementItemContainer AS MIContainer
                                        ON MIContainer.ContainerId = Container.Id
                                       AND MIContainer.OperDate >= inRemainsDate
        LEFT JOIN tmpContainerDeferred ON tmpContainerDeferred.ContainerId = Container.Id
    WHERE Container.DescId = zc_Container_Count()
      AND Container.WhereObjectId IN (SELECT DISTINCT ObjectLink_Unit_Juridical.ObjectId AS UnitId
                                      FROM ObjectLink AS ObjectLink_Unit_Juridical
                                           INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                                 ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                                                AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                                                AND ObjectLink_Juridical_Retail.ChildObjectId = vbObjectId
                                      WHERE ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical())
    GROUP BY Container.Id
           , Container.WhereObjectId
           , Container.ObjectId
           , Container.Amount
    HAVING Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) - COALESCE (MAX (tmpContainerDeferred.Amount), 0) <> 0;

    --!!!!!!!!!!!!!!!!!!!!!
    ANALYZE tmpContainerCount;
    
    raise notice 'Value 02: % <%>', CLOCK_TIMESTAMP(), (SELECT COUNT(*) FROM tmpContainerCount);
    
    CREATE TEMP TABLE tmpRemains (ContainerId Integer, UnitId Integer, GoodsId Integer, Amount TFloat, Price TFloat) ON COMMIT DROP;
    
    WITH tmpContainer AS (SELECT Container.ContainerId
                               , Container.UnitId 
                               , Container.GoodsId
                               , Container.Amount
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

    INSERT INTO tmpRemains(ContainerId, UnitId, GoodsId, Amount, Price)
    SELECT Container.ContainerId
         , Container.UnitId 
         , Container.GoodsId
         , Container.Amount
         , MIFloat_PriceWithVAT.ValueData AS Price
    FROM tmpContainer AS Container
         LEFT JOIN MovementItemFloat AS MIFloat_PriceWithVAT
                                     ON MIFloat_PriceWithVAT.MovementItemId = Container.MovementItemId
                                    AND MIFloat_PriceWithVAT.DescId = zc_MIFloat_PriceWithVAT()
   ;

    ANALYSE tmpRemains;

    raise notice 'Value 03: % <%>', CLOCK_TIMESTAMP(), (SELECT COUNT(*) FROM tmpRemains);

    -- Результат
    RETURN QUERY
        WITH
        tmpData AS (SELECT tmpRemains.UnitId
                         , Sum(tmpRemains.Amount)::TFloat                            AS Amount
                         , Sum(Round(tmpRemains.Amount * tmpRemains.Price, 2))::TFloat  AS Summa
                    FROM tmpRemains
                    GROUP BY tmpRemains.UnitId
                    )

               

        -- Результат
        SELECT Object_Juridical.ObjectCode      AS JuridicalCode
             , Object_Juridical.ValueData       AS JuridicalName
             , Sum(tmpData.Amount)::TFloat      AS Amount
             , Sum(tmpData.Summa)::TFloat       AS SummaWithVAT
        FROM tmpData
        
            LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                 ON ObjectLink_Unit_Juridical.ObjectId = tmpData.UnitId
                                AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()

            LEFT JOIN Object AS Object_Juridical  ON Object_Juridical.ID = ObjectLink_Unit_Juridical.ChildObjectId
                                                        
        GROUP BY Object_Juridical.ObjectCode
               , Object_Juridical.ValueData
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