-- Function: gpSelect_Calculation_Retail_FundUsed()

DROP FUNCTION IF EXISTS gpSelect_Calculation_Retail_FundUsed (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Calculation_Retail_FundUsed(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Wages());

   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Retail_FundUsed(), T1.RetailId, T1.SummaFund)
   FROM
   (WITH
              -- Текущее значение
       tmpLossAll AS (SELECT Movement.ID
                           , CASE WHEN Movement.StatusId <> zc_Enum_Status_Erased() 
                                  THEN MovementFloat_SummaFund.ValueData   
                                  ELSE 0 END                                        AS SummaFund
                      FROM Movement
                      
                           INNER JOIN MovementFloat AS MovementFloat_SummaFund
                                                    ON MovementFloat_SummaFund.MovementId = Movement.Id
                                                   AND MovementFloat_SummaFund.DescId = zc_MovementFloat_SummaFund()
                                                
                      WHERE Movement.DescId = zc_Movement_Loss())
    ,  tmpLoss AS (
              SELECT ObjectLink_Juridical_Retail.ChildObjectId                  AS RetailId
                   , SUM(Movement.SummaFund)                                    AS SummaFund
              FROM tmpLossAll AS Movement
              
                   INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                 ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                AND MovementLinkObject_UNit.DescId = zc_MovementLinkObject_Unit()
                   INNER JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                         ON ObjectLink_Unit_Juridical.ObjectId = MovementLinkObject_Unit.ObjectId       
                                        AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                   INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                         ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                        AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                        AND ObjectLink_Juridical_Retail.ChildObjectId = 4

              GROUP BY ObjectLink_Juridical_Retail.ChildObjectId)

       SELECT tmpLoss.RetailId
            , tmpLoss.SummaFund
       FROM tmpLoss) AS T1;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Calculation_Retail_FundUsed (TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 23.04.20                                                        *
*/

-- 
select * from gpSelect_Calculation_Retail_FundUsed('3');