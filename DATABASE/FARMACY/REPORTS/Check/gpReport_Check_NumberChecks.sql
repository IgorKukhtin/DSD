-- Function:  gpReport_Check_NumberChecks()

DROP FUNCTION IF EXISTS gpReport_Check_NumberChecks (TDateTime, TDateTime, Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION  gpReport_Check_NumberChecks(
    IN inDateStart        TDateTime,  -- Дата начала
    IN inDateFinal        TDateTime,  -- Дата окончания
    IN inRetailId         Integer  ,  -- Сеть
    IN inSummaMin         TFloat   ,  -- От суммы
    IN inSummaMax         TFloat   ,  -- До суммы
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (
  UnitId        Integer,
  UnitCode      Integer,
  UnitName      TVarChar,
  NumberChecks  Integer
)
AS
$BODY$
   DECLARE vbUserId      Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);


    -- Результат
    RETURN QUERY
    WITH tmpMovement AS (SELECT Movement.ID
                         FROM Movement
                         WHERE Movement.OperDate >= inDateStart
                           AND Movement.OperDate < inDateFinal + INTERVAL '1 DAY'
                           AND Movement.DescId = zc_Movement_Check()
                           AND Movement.StatusId = zc_Enum_Status_Complete())

    SELECT Object_Unit.Id
         , Object_Unit.ObjectCode
         , Object_Unit.valuedata
         , Count(*)::Integer                            AS NumberChecks
    FROM tmpMovement as Movement

         INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                      ON MovementLinkObject_Unit.MovementId = Movement.Id
                                     AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

         INNER JOIN ObjectLink AS ObjectLink_Unit_Juridical
                               ON ObjectLink_Unit_Juridical.ObjectId = MovementLinkObject_Unit.ObjectId
                              AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
         INNER JOIN Object AS Object_Unit ON Object_Unit.ID = MovementLinkObject_Unit.ObjectId

         INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                               ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                              AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                              AND ObjectLink_Juridical_Retail.ChildObjectId = 4

         LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                 ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

  WHERE (ObjectLink_Juridical_Retail.ChildObjectId = inRetailId OR COALESCE(inRetailId, 0) = 0)
    AND COALESCE(MovementFloat_TotalSumm.ValueData, 0) >= inSummaMin
    AND (COALESCE(MovementFloat_TotalSumm.ValueData, 0) <= inSummaMax OR COALESCE(inSummaMax, 0) = 0)
  GROUP BY Object_Unit.Id
         , Object_Unit.ObjectCode
         , Object_Unit.valuedata;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.02.19         * признак Товары соц-проект берем и документа
*/

-- тест
-- select * from gpReport_Check_NumberChecks(inDateStart := ('01.01.2020')::TDateTime , inDateFinal := ('31.01.2020')::TDateTime , inRetailId := 4, inSummaMin := 0, inSummaMax := 0,  inSession := '3');