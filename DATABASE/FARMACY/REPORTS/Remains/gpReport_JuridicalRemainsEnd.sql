 -- Function: gpReport_JuridicalRemainsEnd()

DROP FUNCTION IF EXISTS gpReport_JuridicalRemainsEnd (Integer, Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_JuridicalRemainsEnd(
    IN inRetailId         Integer  ,  -- ссылка на торг.сеть
    IN inJuridicalId      Integer  ,  -- Юр.лицо
    IN inRemainsDate      TDateTime,  -- Дата остатка
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (JuridicalId Integer, JuridicalName TVarChar
             , UnitId Integer, UnitName TVarChar
             , Amount TFloat
             , SummaWithOutVAT TFloat, SummaWithVAT TFloat
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


    CREATE TEMP TABLE tmpContainerCount (ContainerId Integer, JuridicalId Integer, UnitId Integer, Amount TFloat) ON COMMIT DROP;
    CREATE TEMP TABLE tmpUnit (UnitId Integer, JuridicalId Integer) ON COMMIT DROP;
    
    -- список подразделений
    INSERT INTO tmpUnit (UnitId, JuridicalId)
                SELECT ObjectLink_Unit_Juridical.ObjectId      AS UnitId
                     , ObjectLink_Unit_Juridical.ChildObjectId AS JuridicalId
                FROM ObjectLink AS ObjectLink_Unit_Juridical
                     INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                           ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                          AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                          AND (ObjectLink_Juridical_Retail.ChildObjectId = inRetailId OR inRetailId = 0)
                     INNER JOIN ObjectLink AS ObjectLink_Unit_Parent
                             ON ObjectLink_Unit_Parent.ObjectId = ObjectLink_Unit_Juridical.ObjectId
                            AND ObjectLink_Unit_Parent.DescId = zc_ObjectLink_Unit_Parent()
                            AND COALESCE (ObjectLink_Unit_Parent.ChildObjectId, 0) <> 0 
                WHERE ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                  AND (ObjectLink_Unit_Juridical.ChildObjectId = inJuridicalId OR inJuridicalId = 0)
                  AND ObjectLink_Unit_Juridical.ObjectId IN (SELECT Id FROM gpSelect_Object_Unit_Active (inNotUnitId := 0, inSession := inSession));
            
    INSERT INTO tmpContainerCount(ContainerId, JuridicalId, UnitId, Amount)
                SELECT Container.Id                   AS ContainerId
                     , tmpUnit.JuridicalId            AS JuridicalId
                     , tmpUnit.UnitId                 AS UnitId
                     , Container.Amount - SUM (COALESCE (MIContainer.Amount, 0)) AS Amount
                FROM Container
                    INNER JOIN tmpUnit ON tmpUnit.UnitId = Container.WhereObjectId
                    LEFT JOIN MovementItemContainer AS MIContainer 
                                                    ON MIContainer.ContainerId = Container.Id
                                                   AND MIContainer.DescId = zc_Container_Count()
                                                   AND MIContainer.OperDate > inRemainsDate
                WHERE Container.DescId = zc_Container_Count()
                --  AND Container.Amount <> 0
                GROUP BY Container.Id  
                       , Container.Amount 
                       , tmpUnit.JuridicalId
                       , tmpUnit.UnitId
                HAVING (Container.Amount -  SUM (COALESCE (MIContainer.Amount, 0)) ) <> 0;

      --!!!!!!!!!!!!!!!!!!!!!
     ANALYZE tmpContainerCount;

    -- Результат
    RETURN QUERY
        WITH   
           tmpData_1 AS (SELECT tmpContainerCount.ContainerId
                              , tmpContainerCount.Amount
                              , tmpContainerCount.JuridicalId
                              , tmpContainerCount.UnitId
                              , Object_PartionMovementItem.ObjectCode :: Integer
                              
                         FROM tmpContainerCount
                             -- партия
                             LEFT OUTER JOIN ContainerLinkObject AS CLI_MI 
                                                                 ON CLI_MI.ContainerId = tmpContainerCount.ContainerId
                                                                AND CLI_MI.DescId = zc_ContainerLinkObject_PartionMovementItem()
                             LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLI_MI.ObjectId
                         )
         , tmpMIFLoat_MI AS (SELECT MovementItemFloat.*
                             FROM MovementItemFloat
                             WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpData_1.ObjectCode FROM tmpData_1)
                               AND MovementItemFloat.DescId = zc_MIFloat_MovementItemId()
                             )
         , tmpData_2 AS (SELECT tmpData_1.ContainerId
                              , tmpData_1.Amount
                              , tmpData_1.JuridicalId
                              , tmpData_1.UnitId
                              , MI_Income.MovementId                      AS MovementId
                              , MI_Income.Id                              AS MI_Id
                              , MIFloat_MovementItem.ValueData :: Integer AS MI_Id_find
                         FROM tmpData_1
                             -- элемент прихода
                             LEFT OUTER JOIN MovementItem AS MI_Income ON MI_Income.Id = tmpData_1.ObjectCode
                                                          
                             -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                             LEFT JOIN tmpMIFLoat_MI AS MIFloat_MovementItem
                                                         ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                       -- AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                         )
         , tmpData_all AS (SELECT tmpData_2.ContainerId
                                , tmpData_2.Amount
                                , tmpData_2.JuridicalId
                                , tmpData_2.UnitId
                                , tmpData_2.MovementId        AS MovementId_Income
                                , MI_Income_find.MovementId   AS MovementId_find
                                , COALESCE (MI_Income_find.MovementId, tmpData_2.MovementId)  :: Integer AS MovementId
                                , COALESCE (MI_Income_find.Id,         tmpData_2.MI_Id)       :: Integer AS MovementItemId
                         
                           FROM tmpData_2
                               -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
                               LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id = tmpData_2.MI_Id_find
                           )
         , tmpMIFloat AS ( SELECT MIFloat_JuridicalPrice.*
                           FROM MovementItemFloat AS MIFloat_JuridicalPrice
                           WHERE MIFloat_JuridicalPrice.MovementItemId IN (SELECT DISTINCT tmpData_all.MovementItemId FROM tmpData_all)
                             AND MIFloat_JuridicalPrice.DescId IN (zc_MIFloat_JuridicalPrice(), zc_MIFloat_PriceWithVAT(), zc_MIFloat_PriceWithOutVAT())
                          )

         , tmpData AS (SELECT tmpData_all.JuridicalId
                            , tmpData_all.UnitId
                            , SUM (tmpData_all.Amount)                                                   AS Amount
                            , SUM (tmpData_all.Amount * COALESCE (MIFloat_PriceWithOutVAT.ValueData, 0)) AS SummaWithOutVAT
                            , SUM (tmpData_all.Amount * COALESCE (MIFloat_PriceWithVAT.ValueData, 0))    AS SummaWithVAT
                       FROM  tmpData_all

                            -- цена с учетом НДС, для элемента прихода от поставщика без % корректировки  (или NULL)
                            LEFT JOIN tmpMIFloat AS MIFloat_PriceWithVAT
                                                        ON MIFloat_PriceWithVAT.MovementItemId = tmpData_all.MovementItemId
                                                       AND MIFloat_PriceWithVAT.DescId = zc_MIFloat_PriceWithVAT()
                            -- цена без учета НДС, для элемента прихода от поставщика без % корректировки  (или NULL)
                            LEFT JOIN tmpMIFloat AS MIFloat_PriceWithOutVAT
                                                        ON MIFloat_PriceWithOutVAT.MovementItemId = tmpData_all.MovementItemId
                                                       AND MIFloat_PriceWithOutVAT.DescId = zc_MIFloat_PriceWithOutVAT()
                       GROUP BY tmpData_all.JuridicalId, tmpData_all.UnitId
                       HAVING SUM (tmpData_all.Amount) <> 0
                      )

        -- Результат
        SELECT Object_Juridical.Id                  AS Id
             , Object_Juridical.ValueData           AS JuridicalName
             , Object_Unit.Id                  AS Id
             , Object_Unit.ValueData           AS JuridicalName
             , tmpData.Amount             :: TFloat AS Amount
             , tmpData.SummaWithOutVAT    :: TFloat AS SummaWithOutVAT
             , tmpData.SummaWithVAT       :: TFloat AS SummaWithVAT
        FROM tmpData
             LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpData.JuridicalId
             LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpData.UnitId
         ;

END;

$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 01.09.22                                                       *
*/

-- тест
-- SELECT * FROM gpReport_JuridicalRemainsEnd( inRetailId :=0, inJuridicalId  :=0 , inRemainsDate := '01.01.2020' ::TDateTime, inSession := '3'::TVarChar )


select * from gpReport_JuridicalRemainsEnd(inRetailId := 0 , inJuridicalId := 472115 , inRemainsDate := ('01.01.2020')::TDateTime ,  inSession := '3');