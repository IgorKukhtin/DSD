-- Function: gpGet_Movement_ChangeIncomePayment()

DROP FUNCTION IF EXISTS gpGet_Movement_ChangeIncomePayment (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_Movement_ChangeIncomePayment(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , TotalSumm TFloat
             , FromId Integer, FromName TVarChar
             , JuridicalId Integer, JuridicalName TVarChar
             , ChangeIncomePaymentKindId Integer, ChangeIncomePaymentKindName TVarChar
             , Comment TVarChar )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_ChangeIncomePayment());
    vbUserId := inSession;

    IF COALESCE (inMovementId, 0) = 0
    THEN
        RETURN QUERY
        SELECT
            0                                                AS Id
          , CAST (NEXTVAL ('movement_ChangeIncomePayment_seq') AS TVarChar) AS InvNumber
          , CURRENT_DATE::TDateTime                          AS OperDate
          , Object_Status.Code                               AS StatusCode
          , Object_Status.Name                               AS StatusName
          , CAST (0 as TFloat)                                AS TotalSumm
          , 0                                                AS FromId
          , CAST ('' AS TVarChar)                            AS FromName
          , 0                                                AS JuridicalId
          , CAST ('' AS TVarChar)                            AS JuridicalName
          , 0                                                AS ChangeIncomePaymentKindId
          , CAST ('' AS TVarChar)                            AS ChangeIncomePaymentKindName
          , CAST ('' AS TVarChar)                            AS Comment
        FROM 
            lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status;
    ELSE
        RETURN QUERY
        SELECT
            Movement_ChangeIncomePayment_View.Id
          , Movement_ChangeIncomePayment_View.InvNumber
          , Movement_ChangeIncomePayment_View.OperDate
          , Movement_ChangeIncomePayment_View.StatusCode
          , Movement_ChangeIncomePayment_View.StatusName
          , Movement_ChangeIncomePayment_View.TotalSumm
          , Movement_ChangeIncomePayment_View.FromId
          , Movement_ChangeIncomePayment_View.FromName
          , Movement_ChangeIncomePayment_View.JuridicalId
          , Movement_ChangeIncomePayment_View.JuridicalName
          , Movement_ChangeIncomePayment_View.ChangeIncomePaymentKindId
          , Movement_ChangeIncomePayment_View.ChangeIncomePaymentKindName
          , Movement_ChangeIncomePayment_View.Comment
        FROM
            Movement_ChangeIncomePayment_View       
        WHERE
            Movement_ChangeIncomePayment_View.Id = inMovementId;
    END IF;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGet_Movement_ChangeIncomePayment (Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 10.12.15                                                                       *
*/

-- тест
-- SELECT * FROM gpGet_Movement_ChangeIncomePayment (inMovementId:= 1, inSession:= '9818')