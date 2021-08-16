-- Function: gpSelect_Movement_Income_Pfizer()

--DROP FUNCTION IF EXISTS gpSelect_Movement_Income_Pfizer (TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_Income_Pfizer (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Income_Pfizer(
    IN inDiscountExternalId Integer ,   -- Программа
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS TABLE (MovementId Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , TotalCount TFloat, TotalSumm TFloat, TotalSummSale TFloat
             , FromId Integer, FromName TVarChar, FromOKPO TVarChar
             , ToId Integer, ToName TVarChar, JuridicalId Integer, JuridicalName TVarChar, ToOKPO TVarChar
             , ContractId Integer, ContractName TVarChar
             , isRegistered Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- Определяется Аптека
     vbUnitKey := COALESCE (lpGet_DefaultValue ('zc_Object_Unit', vbUserId), '');
     vbUnitId  := CASE WHEN vbUnitKey = '' THEN 0 ELSE vbUnitKey :: Integer END;


     -- Вернули все что надо загружать в медреестр Pfizer МДМ
     PERFORM gpUpdate_Movement_Income_isRegistered_Auto (inDiscountExternalId:= inDiscountExternalId, inStartDate:= CURRENT_DATE - INTERVAL '20 DAY', inEndDate:= CURRENT_DATE, inSession:= inSession);

     -- Вернули все что надо загружать в медреестр Pfizer МДМ
     RETURN QUERY
        WITH tmpUnit AS (SELECT vbUnitId AS UnitId)
        -- Результат
        SELECT Movement.Id                                AS MovementId
             , Movement.InvNumber                         AS InvNumber
             , Movement.OperDate                          AS OperDate
             , Object_Status.ObjectCode                   AS StatusCode
             , Object_Status.ValueData                    AS StatusName
             , MovementFloat_TotalCount.ValueData         AS TotalCount
             , MovementFloat_TotalSumm.ValueData          AS TotalSumm
             , MovementFloat_TotalSummSale.ValueData      AS TotalSummSale


             , MovementLinkObject_From.ObjectId           AS FromId
             , Object_From.ValueData                      AS FromName
             , ObjectHistoryString_OKPO_from.ValueData    AS FromOKPO

             , MovementLinkObject_To.ObjectId             AS ToId
             , Object_To.ValueData                        AS ToName
             , MovementLinkObject_Juridical.ObjectId      AS JuridicalId
             , Object_Juridical.ValueData                 AS JuridicalName
             , ObjectHistoryString_OKPO_to.ValueData      AS ToOKPO

             , MovementLinkObject_Contract.ObjectId       AS ContractId
             , Object_Contract.ValueData                  AS ContractName

             , MovementBoolean.ValueData                  AS isRegistered

        FROM MovementBoolean
            LEFT JOIN Movement ON Movement.Id       = MovementBoolean.MovementId
                              AND Movement.DescId   = zc_Movement_Income()
                              AND Movement.StatusId = zc_Enum_Status_Complete()
                              -- AND Movement.OperDate BETWEEN 
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
            LEFT JOIN ObjectHistory AS ObjectHistory_Juridical_from
                                    ON ObjectHistory_Juridical_from.ObjectId = MovementLinkObject_From.ObjectId
                                   AND ObjectHistory_Juridical_from.DescId = zc_ObjectHistory_JuridicalDetails()
                                   AND Movement.OperDate >= ObjectHistory_Juridical_from.StartDate AND Movement.OperDate < ObjectHistory_Juridical_from.EndDate
            LEFT JOIN ObjectHistoryString AS ObjectHistoryString_OKPO_from
                                          ON ObjectHistoryString_OKPO_from.ObjectHistoryId = ObjectHistory_Juridical_from.Id
                                         AND ObjectHistoryString_OKPO_from.DescId = zc_ObjectHistoryString_JuridicalDetails_OKPO()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
            LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MovementLinkObject_Contract.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
            INNER JOIN tmpUnit ON tmpUnit.UnitId = MovementLinkObject_To.ObjectId
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                 ON ObjectLink_Unit_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                                AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()  
        
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                         ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                        AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = MovementLinkObject_Juridical.ObjectId -- ObjectLink_Unit_Juridical.ChildObjectId
            LEFT JOIN ObjectHistory AS ObjectHistory_Juridical_to
                                    ON ObjectHistory_Juridical_to.ObjectId = Object_Juridical.Id
                                   AND ObjectHistory_Juridical_to.DescId = zc_ObjectHistory_JuridicalDetails()
                                   AND Movement.OperDate >= ObjectHistory_Juridical_to.StartDate AND Movement.OperDate < ObjectHistory_Juridical_to.EndDate
            LEFT JOIN ObjectHistoryString AS ObjectHistoryString_OKPO_to
                                          ON ObjectHistoryString_OKPO_to.ObjectHistoryId = ObjectHistory_Juridical_to.Id
                                         AND ObjectHistoryString_OKPO_to.DescId = zc_ObjectHistoryString_JuridicalDetails_OKPO()

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummSale
                                    ON MovementFloat_TotalSummSale.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummSale.DescId = zc_MovementFloat_TotalSummSale()

        WHERE MovementBoolean.DescId    = zc_MovementBoolean_Registered()
          AND MovementBoolean.ValueData = FALSE
          AND inSession <> zfCalc_UserAdmin()
        ORDER BY Movement.OperDate DESC, Movement.Id DESC
        LIMIT 1
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.
 06.12.16                                        *
*/

-- тест
-- 
SELECT * FROM gpSelect_Movement_Income_Pfizer (inDiscountExternalId := 15615415  , inSession:= '3')