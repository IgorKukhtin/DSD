-- Function: gpSelect_Movement_ReturnIn()

DROP FUNCTION IF EXISTS gpSelect_Movement_ReturnIn (TDateTime, TDateTime, Boolean, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_ReturnIn (TDateTime, TDateTime, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_ReturnIn(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inUnitId        Integer,    -- Подразделение
    IN inIsErased      Boolean ,
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer
             , TotalCount TFloat, TotalSumm TFloat
             , UnitId Integer, UnitName TVarChar
             , CashRegisterId Integer, CashRegisterName TVarChar
             , ZReport Integer, FiscalCheckNumber TVarChar
             , IdCheck Integer, InvNumberCheck TVarChar, OperDateCheck TDateTime
             , PaidTypeCheckId Integer, PaidTypeCheckName TVarChar, TotalSummCheck TFloat
             , InsertName TVarChar, InsertDate TDateTime
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpReturnInRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
     vbUserId:= lpGetUserBySession (inSession);

     -- определяется <Торговая сеть>
     vbObjectId:= lpGet_DefaultValue ('zc_Object_Retail', vbUserId);

     -- Результат
     RETURN QUERY
       WITH tmpStatus AS (SELECT zc_Enum_Status_Complete() AS StatusId
                         UNION
                          SELECT zc_Enum_Status_UnComplete() AS StatusId
                         UNION
                          SELECT zc_Enum_Status_Erased() AS StatusId WHERE inIsErased = TRUE
                         )

         SELECT       
             Movement_ReturnIn.Id
           , Movement_ReturnIn.InvNumber
           , Movement_ReturnIn.OperDate
           , Object_Status.ObjectCode                           AS StatusCode
           , MovementFloat_TotalCount.ValueData                 AS TotalCount
           , MovementFloat_TotalSumm.ValueData                  AS TotalSumm
           , Object_Unit.Id                                     AS UnitId
           , Object_Unit.ValueData                              AS UnitName
           , MovementLinkObject_CashRegister.ObjectId           AS CashRegisterId
           , Object_CashRegister.ValueData                      AS CashRegisterName
           , MovementFloat_ZReport.ValueData::Integer           AS ZReport
           , MovementString_FiscalCheckNumber.ValueData         AS FiscalCheckNumber

           , MovementCheck.Id                           AS IdCheck
           , MovementCheck.InvNumber                    AS InvNumberCheck
           , MovementCheck.OperDate                     AS OperDateCheck
           , MovementLinkObject_PaidTypeCheck.ObjectId  AS PaidTypeCheckId
           , Object_PaidTypeCheck.ValueData             AS PaidTypeCheckName
           , MovementFloat_TotalSummCheck.ValueData     AS TotalSummCheck

           , Object_Insert.ValueData                            AS InsertName
           , MovementDate_Insert.ValueData                      AS InsertDate

        FROM Movement AS Movement_ReturnIn
            INNER JOIN tmpStatus ON tmpStatus.StatusId = Movement_ReturnIn.StatusId
                   
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement_ReturnIn.StatusId

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId = Movement_ReturnIn.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId = Movement_ReturnIn.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

            LEFT JOIN MovementFloat AS MovementFloat_ZReport
                                    ON MovementFloat_ZReport.MovementId =  Movement_ReturnIn.Id
                                   AND MovementFloat_ZReport.DescId = zc_MovementFloat_ZReport()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = Movement_ReturnIn.Id
                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                 ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                                AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
            LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                 ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                               AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_CashRegister
                                         ON MovementLinkObject_CashRegister.MovementId = Movement_ReturnIn.Id
                                        AND MovementLinkObject_CashRegister.DescId = zc_MovementLinkObject_CashRegister()
            LEFT JOIN Object AS Object_CashRegister ON Object_CashRegister.Id = MovementLinkObject_CashRegister.ObjectId

            LEFT JOIN MovementString AS MovementString_FiscalCheckNumber
                                     ON MovementString_FiscalCheckNumber.MovementId = Movement_ReturnIn.ID
                                    AND MovementString_FiscalCheckNumber.DescId = zc_MovementString_FiscalCheckNumber()
 
            LEFT JOIN MovementFloat AS MovementFloat_MovementId
                                    ON MovementFloat_MovementId.MovementId = Movement_ReturnIn.Id
                                   AND MovementFloat_MovementId.DescId = zc_MovementFloat_MovementId()
            LEFT JOIN Movement AS MovementCheck ON MovementCheck.ID = MovementFloat_MovementId.ValueData::Integer

	        LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidTypeCheck
                                         ON MovementLinkObject_PaidTypeCheck.MovementId = MovementCheck.Id
                                        AND MovementLinkObject_PaidTypeCheck.DescId = zc_MovementLinkObject_PaidType()
            LEFT JOIN Object AS Object_PaidTypeCheck ON Object_PaidTypeCheck.Id = MovementLinkObject_PaidTypeCheck.ObjectId

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummCheck
                                    ON MovementFloat_TotalSummCheck.MovementId =  MovementCheck.Id
                                   AND MovementFloat_TotalSummCheck.DescId = zc_MovementFloat_TotalSumm()

            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId = Movement_ReturnIn.Id
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()

            LEFT JOIN MovementLinkObject AS MLO_Insert
                                         ON MLO_Insert.MovementId = Movement_ReturnIn.Id
                                        AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId

        WHERE Movement_ReturnIn.OperDate >= DATE_TRUNC ('DAY', inStartDate) 
          AND Movement_ReturnIn.OperDate < DATE_TRUNC ('DAY', inEndDate) + INTERVAL '1 DAY'
          AND Movement_ReturnIn.DescId = zc_Movement_ReturnIn()
          AND (MovementLinkObject_Unit.ObjectId = inUnitId OR inUnitId = 0)
          AND ObjectLink_Juridical_Retail.ChildObjectId = vbObjectId

      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В. 
 19.01.19         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_ReturnIn (inStartDate:= '01.09.2021', inEndDate:= '09.09.2021', inUnitId:= 0, inIsErased := FALSE, inSession:= '2')
