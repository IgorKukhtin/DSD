-- Function: gpSelect_Movement_IncomeBySumm()

DROP FUNCTION IF EXISTS gpSelect_Movement_IncomeBySumm (TFloat, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_IncomeBySumm(
    IN inSumm     TFloat , -- Сумма документа
    IN inIncome   Integer, -- № сохраненной накладной
    IN inSession  TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, FromId Integer, FromName TVarChar, JuridicalId Integer, JuridicalName TVarChar, UnitId Integer, UnitName TVarChar)
AS
$BODY$
BEGIN
    IF COALESCE(inIncome,0) = 0 AND
       COALESCE(inSumm,0) = 0
    THEN
        RETURN QUERY
            SELECT 
                NULL::Integer   AS Id,
                NULL::TVarChar  AS InvNumber,
                NULL::TDateTime AS OperDate,
                NULL::Integer   AS FromId,
                NULL::TVarChar  AS FromName,
                NULL::Integer   AS JuridicalId,
                NULL::TVarChar  AS JuridicalName,
                NULL::Integer   AS UnitId,
                NULL::TVarChar  AS UnitName
            WHERE 1 = 0;
    ELSE
        IF COALESCE(inIncome,0) <> 0
        THEN
            RETURN QUERY
                SELECT 
                    Movement.Id,
                    Movement.InvNumber,
                    Movement.OperDate,
                    Object_From.Id             AS FromId,
                    Object_From.ValueData      AS FromName,
                    Object_Juridical.Id        AS JuridicalId,
                    Object_Juridical.ValueData AS JuridicalName,
                    Object_Unit.Id             AS UnitId,
                    Object_Unit.ValueData      AS UnitName
                FROM
                    Movement
                    INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                  ON MovementLinkObject_From.MovementId = Movement.Id
                                                 AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                    INNER JOIN Object AS Object_From
                                      ON Object_From.Id = MovementLinkObject_From.ObjectId
                    INNER JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                                  ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                                 AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
                    INNER JOIN Object AS Object_Juridical
                                      ON Object_Juridical.Id = MovementLinkObject_juridical.ObjectId
                    INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                  ON MovementLinkObject_To.MovementId = Movement.Id
                                                 AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                    INNER JOIN Object AS Object_Unit
                                      ON Object_Unit.Id = MovementLinkObject_To.ObjectId
                WHERE
                    Movement.Id = inIncome;
        
        ELSE
            RETURN QUERY
                SELECT 
                    Movement.Id,
                    Movement.InvNumber,
                    Movement.OperDate,
                    Object_From.Id             AS FromId,
                    Object_From.ValueData      AS FromName,
                    Object_Juridical.Id        AS JuridicalId,
                    Object_Juridical.ValueData AS JuridicalName,
                    Object_Unit.Id             AS UnitId,
                    Object_Unit.ValueData      AS UnitName
                FROM
                    Movement
                    INNER JOIN MovementFloat ON MovementFloat.MovementId = Movement.Id
                                AND MovementFloat.DescId = zc_MovementFloat_TotalSumm()
                                AND MovementFloat.ValueData = inSumm
                    INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                  ON MovementLinkObject_From.MovementId = Movement.Id
                                                 AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                    INNER JOIN Object AS Object_From
                                      ON Object_From.Id = MovementLinkObject_From.ObjectId
                    INNER JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                                  ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                                 AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
                    INNER JOIN Object AS Object_Juridical
                                      ON Object_Juridical.Id = MovementLinkObject_juridical.ObjectId
                    INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                  ON MovementLinkObject_To.MovementId = Movement.Id
                                                 AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                    INNER JOIN Object AS Object_Unit
                                      ON Object_Unit.Id = MovementLinkObject_To.ObjectId
                    INNER JOIN Object AS Object_Movement
                                     ON Object_Movement.ObjectCode = Movement.Id 
                                    AND Object_Movement.DescId = zc_Object_PartionMovement()
                    INNER JOIN Container ON Container.DescId = zc_Container_SummIncomeMovementPayment()
                                        AND Container.ObjectId = Object_Movement.Id
                                        AND Container.KeyValue like '%,'||MovementLinkObject_Juridical.ObjectId||';%' 
                                        AND Container.Amount <> 0
                WHERE
                    Movement.DescId = zc_Movement_Income()
                    AND
                    Movement.StatusId = zc_Enum_Status_Complete()
                    ;
                    
        END IF;
    END IF;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Movement_IncomeBySumm (TFloat, Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.
 11.01.16                                                                        *

*/

-- тест
-- SELECT * FROM gpSelect_Movement_IncomeBySumm (inSumm:= 0, inIncome := 0, inSession:= '3')