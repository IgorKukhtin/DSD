-- Function: lpSelect_PriceList_SupplierFailures()

DROP FUNCTION IF EXISTS lpSelect_PriceList_SupplierFailures (Integer, Integer);

CREATE OR REPLACE FUNCTION lpSelect_PriceList_SupplierFailures(
    IN inUnitId              Integer ,    -- Подразделение
    IN inUserId              Integer      -- сессия пользователя
)
RETURNS TABLE (GoodsId Integer
             , JuridicalId Integer
             , ContractId Integer
             , AreaId Integer
)
AS
$BODY$
BEGIN

    RETURN QUERY
    WITH tmpMovementAll AS (SELECT MAX (Movement.OperDate)
                                   OVER (PARTITION BY MovementLinkObject_Juridical.ObjectId
                                                    , COALESCE (MovementLinkObject_Contract.ObjectId, 0)
                                                    , COALESCE (MovementLinkObject_Area.ObjectId, 0)
                                        ) AS Max_Date
                                 , Movement.OperDate                                  AS OperDate
                                 , Movement.Id                                        AS MovementId
                                 , MovementLinkObject_Juridical.ObjectId              AS JuridicalId
                                 , COALESCE (MovementLinkObject_Contract.ObjectId, 0) AS ContractId
                                 , COALESCE (MovementLinkObject_Area.ObjectId, 0)     AS AreaId
                            FROM Movement
                                 LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                                              ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                                             AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
                                 LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                              ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                             AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                 LEFT JOIN MovementLinkObject AS MovementLinkObject_Area
                                                              ON MovementLinkObject_Area.MovementId = Movement.Id
                                                             AND MovementLinkObject_Area.DescId = zc_MovementLinkObject_Area()
                            WHERE Movement.DescId = zc_Movement_PriceList()
                              AND Movement.StatusId = zc_Enum_Status_UnComplete()
                            ),
        tmpJuridicalArea AS (SELECT DISTINCT
                                    tmp.JuridicalId              AS JuridicalId
                                  , tmp.AreaId_Juridical         AS AreaId
                             FROM lpSelect_Object_JuridicalArea_byUnit (inUnitId , 0) AS tmp
                             ),
        tmpLastMovement AS (SELECT PriceList.JuridicalId
                                 , PriceList.ContractId
                                 , PriceList.AreaId
                                 , PriceList.MovementId
                            FROM tmpMovementAll AS PriceList
                            
                                 LEFT JOIN tmpJuridicalArea ON tmpJuridicalArea.JuridicalId = PriceList.JuridicalId
                                                           AND tmpJuridicalArea.AreaId = PriceList.AreaId 
                            
                            WHERE PriceList.Max_Date = PriceList.OperDate
                              AND (COALESCE (inUnitId, 0) = 0 OR COALESCE(tmpJuridicalArea.AreaId, 0) <> 0))

    SELECT DISTINCT
           MovementItem.ObjectId               AS GoodsId 
         , LastMovement.JuridicalId
         , LastMovement.ContractId
         , LastMovement.AreaId
    
    FROM tmpLastMovement AS LastMovement

        INNER JOIN MovementItem ON MovementItem.MovementId = LastMovement.MovementId
                               AND MovementItem.DescId = zc_MI_Child()

        INNER JOIN MovementItemBoolean AS MIBoolean_SupplierFailures
                                      ON MIBoolean_SupplierFailures.MovementItemId = MovementItem.Id
                                     AND MIBoolean_SupplierFailures.DescId = zc_MIBoolean_SupplierFailures()
                                     AND MIBoolean_SupplierFailures.ValueData = TRUE
    ;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 22.02.22                                                       *
*/

-- тест
-- 
SELECT * FROM lpSelect_PriceList_SupplierFailures (inUnitId := 6309262 , inUserId := 3)