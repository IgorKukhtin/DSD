 -- Function: gpReport_HouseholdInventoryRemains()

DROP FUNCTION IF EXISTS gpReport_HouseholdInventoryRemains (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_HouseholdInventoryRemains(
    IN inUnitId           Integer  ,  -- Подразделение
    IN inShowAll          Boolean,    --
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (InvNumber Integer, HouseholdInventoryId Integer, HouseholdInventoryCode Integer, HouseholdInventoryName TVarChar
             , Amount TFloat, CountForPrice TFloat, Comment TVarChar
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
           tmpPartion AS (SELECT Object_PHI.Id                          AS Id
                               , Object_PHI.ObjectCode                  AS InvNumber

                               , PHI_MovementItemId.ValueData::Integer  AS MovementItemId
                               , ObjectLink_PHI_Unit.ChildObjectId      AS UnitID

                               , MovementItem.ObjectId                  AS HouseholdInventoryId
                               , MovementItem.Amount                    AS Amount
                               , MovementItem.MovementID                AS MovementID

                               , Object_PHI.isErased                    AS isErased

                          FROM Object AS Object_PHI

                               LEFT JOIN ObjectFloat AS PHI_MovementItemId
                                                     ON PHI_MovementItemId.ObjectId = Object_PHI.Id
                                                    AND PHI_MovementItemId.DescId = zc_ObjectFloat_PartionHouseholdInventory_MovementItemId()

                               LEFT JOIN ObjectLink AS ObjectLink_PHI_Unit
                                                    ON ObjectLink_PHI_Unit.ObjectId = Object_PHI.Id
                                                   AND ObjectLink_PHI_Unit.DescId = zc_ObjectLink_PartionHouseholdInventory_Unit()

                               LEFT JOIN MovementItem ON MovementItem.Id = PHI_MovementItemId.ValueData::Integer

                          WHERE Object_PHI.DescId = zc_Object_PartionHouseholdInventory()
                            AND COALESCE (PHI_MovementItemId.ValueData, 0) <> 0
                            AND (ObjectLink_PHI_Unit.ChildObjectId = inUnitId OR COALESCE (inUnitId, 0) = 0)
                            AND (MovementItem.Amount > 0 OR inShowAll = TRUE)
                         ),
           tmpMIF AS (SELECT *
                     FROM MovementItemFloat
                     WHERE MovementItemFloat.MovementItemId IN (SELECT tmpPartion.MovementItemId FROM tmpPartion)),
           tmpMIS AS (SELECT *
                     FROM MovementItemString
                     WHERE MovementItemString.MovementItemId IN (SELECT tmpPartion.MovementItemId FROM tmpPartion)),
           tmpHouseholdInventory AS (SELECT *
                                     FROM Object
                                     WHERE Object.DescId = zc_Object_HouseholdInventory()),
           tmpUnit AS (SELECT *
                       FROM Object
                       WHERE Object.DescId = zc_Object_Unit())

        -- Результат
        SELECT tmpPartion.InvNumber                               AS InvNumber
             , tmpPartion.HouseholdInventoryId                    AS HouseholdInventoryId
             , Object_HouseholdInventory.ObjectCode               AS HouseholdInventoryCode
             , Object_HouseholdInventory.ValueData                AS HouseholdInventoryName
             , tmpPartion.Amount                                  AS Amount
             , MIFloat_CountForPrice.ValueData                    AS CountForPrice
             , MIString_Comment.ValueData                         AS Comment

             , Movement_Income.Id                                 AS IncomeId
             , Movement_Income.InvNumber                          AS IncomeInvNumber
             , Movement_Income.OperDate                           AS IncomeOperDate
             , tmpPartion.UnitId                                  AS UnitId
             , Object_Unit.ValueData                              AS UnitName
        FROM tmpPartion

             LEFT JOIN Movement AS Movement_Income ON Movement_Income.ID = tmpPartion.MovementId

             LEFT JOIN tmpMIF AS MIFloat_InvNumber
                                         ON MIFloat_InvNumber.MovementItemId = tmpPartion.MovementItemId
                                        AND MIFloat_InvNumber.DescId = zc_MIFloat_InvNumber()

             LEFT JOIN tmpMIF AS MIFloat_CountForPrice
                                         ON MIFloat_CountForPrice.MovementItemId = tmpPartion.MovementItemId
                                        AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

             LEFT JOIN tmpMIS AS MIString_Comment
                                          ON MIString_Comment.MovementItemId = tmpPartion.MovementItemId
                                         AND MIString_Comment.DescId = zc_MIString_Comment()

             LEFT JOIN tmpHouseholdInventory AS Object_HouseholdInventory ON Object_HouseholdInventory.Id = tmpPartion.HouseholdInventoryId

             LEFT JOIN tmpUnit AS Object_Unit ON Object_Unit.Id = tmpPartion.UnitId
         ;

END;

$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 09.07.20                                                                     *
*/

-- тест
--
-- select * from gpReport_HouseholdInventoryRemains(inUnitId := 0 , inShowAll := False , inSession := '3');
