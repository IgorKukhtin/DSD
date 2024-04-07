-- Function: gpSelect_Movement_MobileBills()

DROP FUNCTION IF EXISTS gpSelect_Movement_MobileBills (TDateTime, TDateTime, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_MobileBills (TDateTime, TDateTime, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_MobileBills(
    IN inStartDate        TDateTime , --
    IN inEndDate          TDateTime , --
    IN inJuridicalBasisId Integer   , 
    IN inIsErased         Boolean ,
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , ContractCode Integer, ContractName TVarChar
             , JuridicalCode Integer, JuridicalName TVarChar
             , TotalSumm TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

-- inStartDate:= '01.01.2013';
-- inEndDate:= '01.01.2100';

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_MobileBills());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);


     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )
     
       SELECT
             Movement.Id                        AS Id
           , Movement.InvNumber                 AS InvNumber
           , Movement.OperDate                  AS OperDate
           , Object_Status.ObjectCode           AS StatusCode
           , Object_Status.ValueData            AS StatusName
           
           , Object_Contract.ObjectCode         AS ContractCode 
           , Object_Contract.ValueData          AS ContractName

           , Object_Juridical.ObjectCode        AS JuridicalCode 
           , Object_Juridical.ValueData         AS JuridicalName

           , MovementFloat_TotalSumm.ValueData  AS TotalSumm

       FROM tmpStatus
           JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate 
                        AND Movement.DescId = zc_Movement_MobileBills()
                        AND Movement.StatusId = tmpStatus.StatusId
           
           LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

           LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                   ON MovementFloat_TotalSumm.MovementId = Movement.Id
                                  AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

           LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                        ON MovementLinkObject_Contract.MovementId = Movement.Id
                                       AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
           LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MovementLinkObject_Contract.ObjectId

           LEFT JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                ON ObjectLink_Contract_Juridical.ObjectId = Object_Contract.Id
                               AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
           LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Contract_Juridical.ChildObjectId
          ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 08.10.16         * add inJuridicalBasisId
 05.10.16         * parce
 27.09.16         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_MobileBills (inStartDate:= '30.01.2014', inEndDate:= '01.02.2014', inJuridicalBasisId:=0, inIsErased := FALSE, inSession:= '2')
