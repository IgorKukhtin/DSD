-- Function: gpSelect_Calculation_Retail_Fund()

DROP FUNCTION IF EXISTS gpSelect_Calculation_Retail_Fund (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Calculation_Retail_Fund(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Wages());

   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Retail_Fund(), T1.RetailId, T1.Summa)
   FROM
   (WITH
              -- Текущее значение
      tmpPersentSalary AS (SELECT ObjectHistory.StartDate + INTERVAL '1 DAY' AS StartDate
                                , ObjectHistory.EndDate + INTERVAL '1 DAY'   AS EndDate
                                , OHF_PersentSalary_Value.ValueData          AS PersentSalary
                           FROM ObjectHistory
                                LEFT JOIN ObjectHistoryFloat AS OHF_PersentSalary_Value
                                                            ON OHF_PersentSalary_Value.DescId = zc_ObjectHistoryFloat_PersentSalary_Value()
                                                           AND OHF_PersentSalary_Value.ObjectHistoryId = ObjectHistory.Id
                           WHERE ObjectHistory.DescId = zc_ObjectHistory_PersentSalary())
    ,  tmpCheckId AS (
              SELECT DATE_TRUNC ('DAY', Movement.OperDate)                                   AS OperDate
                   , MovementLinkObject_Unit.ObjectId                                        AS UnitId
                   , Movement.ID                                                             AS ID
              FROM Movement

                   INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                 ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                AND MovementLinkObject_Unit.ObjectId <> 377606
              WHERE Movement.OperDate >= (SELECT MIN(tmpPersentSalary.StartDate) FROM tmpPersentSalary)
                AND Movement.DescId = zc_Movement_Check()
                AND Movement.StatusId = zc_Enum_Status_Complete())
    ,  tmpCheck AS (
              SELECT Movement.OperDate                                                       AS OperDate
                   , ObjectLink_Juridical_Retail.ChildObjectId                               AS RetailId
                   , SUM(MovementFloat_TotalSumm.ValueData)                                  AS TotalSumm
              FROM tmpCheckId AS Movement

                   INNER JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                         ON ObjectLink_Unit_Juridical.ObjectId = Movement.UnitId
                                        AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                   INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                         ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                        AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                        AND ObjectLink_Juridical_Retail.ChildObjectId = 4
                   INNER JOIN MovementFloat AS MovementFloat_TotalSumm
                                            ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                           AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

              GROUP BY Movement.OperDate
                     , ObjectLink_Juridical_Retail.ChildObjectId)
    ,  tmpData AS (SELECT tmpCheck.RetailId
                        , ROUND(SUM(tmpCheck.TotalSumm * COALESCE(PersentSalary.PersentSalary, 0) / 100), 2) AS Summa
                   FROM tmpCheck
                        INNER JOIN tmpPersentSalary AS PersentSalary
                                                    ON PersentSalary.StartDate <= tmpCheck.OperDate
                                                   AND PersentSalary.EndDate > tmpCheck.OperDate
                   GROUP BY tmpCheck.RetailId
                   )

       SELECT tmpData.RetailId
            , tmpData.Summa
       FROM tmpData) AS T1;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Calculation_Retail_Fund (TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 23.04.20                                                        *
*/

-- select * from gpSelect_Calculation_Retail_Fund('3');