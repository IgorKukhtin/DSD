-- Function: gpReport_MovementCheck_UnderreportedDE()

DROP FUNCTION IF EXISTS gpReport_MovementCheck_UnderreportedDE (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_MovementCheck_UnderreportedDE(
    IN inOperDate           TDateTime , --
--    IN inUnitId             Integer,    -- Подразделение
--    IN inDiscountExternalId Integer,    -- Подразделение
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS TABLE (/*UnitName TVarChar, MainJuridicalId Integer, MainJuridicalName TVarChar, RetailId Integer, RetailName TVarChar
             , DiscountExternalName TVarChar, */
               FromName TVarChar
             , SummChangePercent TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
   DECLARE vbRetailId Integer;
   DECLARE vbDayCompensDiscount Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
     vbUserId:= lpGetUserBySession (inSession);

     -- определяется <Торговая сеть>
     vbObjectId:= lpGet_DefaultValue ('zc_Object_Retail', vbUserId);

     -- определяем Торговую сеть входящего подразделения
/*     vbRetailId:= CASE WHEN vbUserId IN (3, 183242, 375661) -- Админ + Люба + Юра
                          OR vbUserId IN (SELECT UserId FROM ObjectLink_UserRole_View WHERE RoleId IN (393039)) -- Старший менеджер
                       THEN vbObjectId
                  ELSE
                  (SELECT ObjectLink_Juridical_Retail.ChildObjectId
                   FROM ObjectLink AS ObjectLink_Unit_Juridical
                      INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                            ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                           AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                   WHERE (ObjectLink_Unit_Juridical.ObjectId = inUnitId or COALESCE(inUnitId, 0) = 0)
                     AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                   LIMIT 1
                   )
                   END;
*/
     -- Результат
     RETURN QUERY
     WITH tmpMovement_Check AS (SELECT Movement.*
                                     , MovementLinkObject_Unit.ObjectId                    AS UnitId
                                     , ObjectLink_DiscountExternal.ChildObjectId           AS DiscountExternalId
                                FROM Movement


                                     INNER JOIN MovementLinkObject AS MovementLinkObject_DiscountCard
                                                                   ON MovementLinkObject_DiscountCard.MovementId = Movement.ID
                                                                  AND MovementLinkObject_DiscountCard.DescId = zc_MovementLinkObject_DiscountCard()

                                     INNER JOIN ObjectLink AS ObjectLink_DiscountExternal
                                                           ON ObjectLink_DiscountExternal.ObjectId = MovementLinkObject_DiscountCard.ObjectId
                                                          AND ObjectLink_DiscountExternal.DescId = zc_ObjectLink_DiscountCard_Object()

                                     INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                  ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                                 AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

                                     INNER JOIN MovementDate AS MovementDate_Compensation
                                                            ON MovementDate_Compensation.MovementId = Movement.Id
                                                           AND MovementDate_Compensation.DescId = zc_MovementDate_Compensation()

                                WHERE Movement.OperDate < DATE_TRUNC ('DAY', inOperDate)
                                  AND Movement.DescId = zc_Movement_Check()
                                  AND MovementDate_Compensation.ValueData >= DATE_TRUNC ('DAY', inOperDate)
                               --   AND (ObjectLink_DiscountExternal.ChildObjectId = inDiscountExternalId
                               --    OR COALESCE (ObjectLink_DiscountExternal.ChildObjectId, 0) <> 0 AND COALESCE (inDiscountExternalId, 0) = 0)
                               --   AND (MovementLinkObject_Unit.ObjectId = inUnitId OR COALESCE (inUnitId, 0) = 0)
                                  AND  Movement.StatusId = zc_Enum_Status_Complete()
                             ),
          tmpMovement_CheckSum AS (SELECT /*Movement_Check.UnitId                    AS UnitId
                                        , Movement_Check.DiscountExternalId        AS DiscountExternalId
                                        , */
                                          MovementLinkObject_From.ObjectId         AS FromId
                                        , SUM(MovementItem.SummChangePercent * (-1.0 * MovementItemContainer.Amount)/ MovementItem.Amount) AS SummChangePercent
                                   FROM tmpMovement_Check AS Movement_Check
                                   
                                        LEFT JOIN MovementItem_Check_View AS MovementItem
                                                                          ON MovementItem.MovementId = Movement_Check.Id
                                                                         AND MovementItem.Amount > 0 
                                                                           
                                        LEFT JOIN MovementItemContainer ON MovementItemContainer.MovementItemId = MovementItem.ID

                                        LEFT JOIN ContainerLinkObject AS CLI_MI
                                                                      ON CLI_MI.ContainerId = MovementItemContainer.ContainerId
                                                                     AND CLI_MI.DescId = zc_ContainerLinkObject_PartionMovementItem()
                                        LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLI_MI.ObjectId
                                        -- элемент прихода
                                        LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                                        -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                                        LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                                    ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                                   AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                                        -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
                                        LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id  = (MIFloat_MovementItem.ValueData :: Integer)
                                                                              -- AND 1=0

                                        LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                                     ON MovementLinkObject_From.MovementId = COALESCE (MI_Income_find.MovementId,MI_Income.MovementId)
                                                                    AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                   GROUP BY MovementLinkObject_From.ObjectId
                                  )
     
         SELECT
             /*Object_Unit.ValueData                              AS UnitName
           , Object_MainJuridical.Id                            AS MainJuridicalId
           , Object_MainJuridical.ValueData                     AS MainJuridicalName
           , Object_Retail.ID                                   AS RetailId
           , Object_Retail.ValueData                            AS RetailName

           , Object_DiscountExternal.ValueData                  AS DiscountExternalName
           
           ,*/ 
             
             Object_From.ValueData                              AS FromName
           
           , Movement_Check.SummChangePercent::TFloat           AS SummChangePercent 

        FROM tmpMovement_CheckSum AS Movement_Check

/*             LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = Movement_Check.UnitId

             LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                  ON ObjectLink_Unit_Juridical.ObjectId = Movement_Check.UnitId
                                 AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
             LEFT JOIN Object AS Object_MainJuridical ON Object_MainJuridical.Id = ObjectLink_Unit_Juridical.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                  ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                 AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
             LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId

             LEFT JOIN Object AS Object_DiscountExternal ON Object_DiscountExternal.Id = Movement_Check.DiscountExternalId
*/

             LEFT JOIN Object AS Object_From ON Object_From.Id = Movement_Check.FromId
             ;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 29.10.19                                                       *
*/

select * from gpReport_MovementCheck_UnderreportedDE(inOperDate := ('28.04.2021')::TDateTime , inSession := '3');