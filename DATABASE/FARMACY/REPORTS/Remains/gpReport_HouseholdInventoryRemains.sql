 -- Function: gpReport_HouseholdInventoryRemains()

DROP FUNCTION IF EXISTS gpReport_HouseholdInventoryRemains (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_HouseholdInventoryRemains(
    IN inUnitId           Integer  ,  -- Подразделение
    IN inShowAll          Boolean,    --
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (InvNumber Integer, HouseholdInventoryId Integer, HouseholdInventoryCode Integer, HouseholdInventoryName TVarChar
             , Amount TFloat, CountForPrice TFloat, Summa TFloat, Comment TVarChar
             , IncomeId Integer, IncomeInvNumber TVarChar, IncomeOperDate TDateTime
             , UnitId Integer, UnitName TVarChar
             )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);
    -- Результат

    RETURN QUERY
        WITH
           tmpContainer AS (SELECT Container.ID

                                 , Container.ObjectId                     AS HouseholdInventoryId
                                 , Container.Amount                       AS Amount
                                 , Container.WhereobjectId                AS UnitID

                                 , Object_PHI.ObjectCode                  AS InvNumber
                                 , PHI_MovementItemId.ValueData::Integer  AS MovementItemId
                                 , MovementItem.MovementID                AS MovementID
                          FROM Container
                          
                               LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                                            AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionHouseholdInventory()
                                                            
                               LEFT JOIN Object AS Object_PHI ON Object_PHI.ID = ContainerLinkObject.ObjectId

                               LEFT JOIN ObjectFloat AS PHI_MovementItemId
                                                     ON PHI_MovementItemId.ObjectId = Object_PHI.Id
                                                    AND PHI_MovementItemId.DescId = zc_ObjectFloat_PartionHouseholdInventory_MovementItemId()

                               LEFT JOIN MovementItem ON MovementItem.Id = PHI_MovementItemId.ValueData::Integer

                               LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId

                          WHERE Container.DescId = zc_Container_CountHouseholdInventory()
                            AND (Container.WhereobjectId = inUnitId OR COALESCE (inUnitId, 0) = 0)
                            AND (Container.Amount <> 0 OR inShowAll = TRUE)
                            AND COALESCE (Movement.StatusId, 0) = zc_Enum_Status_Complete()
                         ),
                         
           tmpMIF AS (SELECT *
                     FROM MovementItemFloat
                     WHERE MovementItemFloat.MovementItemId IN (SELECT tmpContainer.MovementItemId FROM tmpContainer)),
           tmpMIS AS (SELECT *
                     FROM MovementItemString
                     WHERE MovementItemString.MovementItemId IN (SELECT tmpContainer.MovementItemId FROM tmpContainer)),
           tmpHouseholdInventory AS (SELECT *
                                     FROM Object
                                     WHERE Object.DescId = zc_Object_HouseholdInventory()),
           tmpUnit AS (SELECT *
                       FROM Object
                       WHERE Object.DescId = zc_Object_Unit())

        -- Результат
        SELECT tmpContainer.InvNumber                             AS InvNumber
             , tmpContainer.HouseholdInventoryId                  AS HouseholdInventoryId
             , Object_HouseholdInventory.ObjectCode               AS HouseholdInventoryCode
             , Object_HouseholdInventory.ValueData                AS HouseholdInventoryName
             , tmpContainer.Amount                                AS Amount
             , MIFloat_CountForPrice.ValueData                    AS CountForPrice
             , Round(tmpContainer.Amount * MIFloat_CountForPrice.ValueData  , 2)::TFloat  AS Summa 
             , MIString_Comment.ValueData                         AS Comment

             , Movement_Income.Id                                 AS IncomeId
             , Movement_Income.InvNumber                          AS IncomeInvNumber
             , Movement_Income.OperDate                           AS IncomeOperDate
             , tmpContainer.UnitId                                AS UnitId
             , Object_Unit.ValueData                              AS UnitName
        FROM tmpContainer

             LEFT JOIN Movement AS Movement_Income ON Movement_Income.ID = tmpContainer.MovementId

             LEFT JOIN tmpMIF AS MIFloat_InvNumber
                                         ON MIFloat_InvNumber.MovementItemId = tmpContainer.MovementItemId
                                        AND MIFloat_InvNumber.DescId = zc_MIFloat_InvNumber()

             LEFT JOIN tmpMIF AS MIFloat_CountForPrice
                                         ON MIFloat_CountForPrice.MovementItemId = tmpContainer.MovementItemId
                                        AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

             LEFT JOIN tmpMIS AS MIString_Comment
                                          ON MIString_Comment.MovementItemId = tmpContainer.MovementItemId
                                         AND MIString_Comment.DescId = zc_MIString_Comment()

             LEFT JOIN tmpHouseholdInventory AS Object_HouseholdInventory ON Object_HouseholdInventory.Id = tmpContainer.HouseholdInventoryId

             LEFT JOIN tmpUnit AS Object_Unit ON Object_Unit.Id = tmpContainer.UnitId
         ;

END;

$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 30.07.20                                                                     *
 09.07.20                                                                     *
*/

-- тест
--
-- select * from gpReport_HouseholdInventoryRemains(inUnitId := 0 , inShowAll := False , inSession := '3');

