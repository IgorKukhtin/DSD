-- Function: gpGet_Movement_OrderIncome()

DROP FUNCTION IF EXISTS gpGet_Movement_OrderIncome (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_OrderIncome(
    IN inMovementId        Integer  , -- ключ Документа
    IN inOperDate          TDateTime, -- дата Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, IdBarCode TVarChar, InvNumber TVarChar
             , OperDate TDateTime, OperDatePartner TDateTime
             , StatusCode Integer, StatusName TVarChar
             , InsertDate TDateTime, InsertName TVarChar

             , PriceWithVAT Boolean, VATPercent TFloat, ChangePercent TFloat
             , CurrencyValue TFloat, ParValue TFloat
             , CurrencyDocumentId Integer, CurrencyDocumentName TVarChar

             , UnitId Integer, UnitName TVarChar
             , JuridicalId Integer, JuridicalName TVarChar
             , ContractId Integer, ContractName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , Comment TVarChar
             , OperDateStart TDateTime
             , OperDateEnd TDateTime
             , DayCount TFloat
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_OrderIncome());
     vbUserId:= lpGetUserBySession (inSession);


     IF COALESCE (inMovementId, 0) = 0
     THEN
     RETURN QUERY
         SELECT
               0 AS Id
             , '' ::TVarChar AS IdBarCode
             , CAST (NEXTVAL ('movement_OrderIncome_seq') AS TVarChar) AS InvNumber
             , inOperDate                                 AS OperDate
             , inOperDate		                  AS OperDatePartner

             , Object_Status.Code                         AS StatusCode
             , Object_Status.Name                         AS StatusName
             
             , CURRENT_TIMESTAMP ::TDateTime              AS InsertDate
             , COALESCE(Object_Insert.ValueData,'')  ::TVarChar AS InsertName
                          
             , CAST (True as Boolean)                     AS PriceWithVAT
             , CAST (20 as TFloat)                        AS VATPercent
             , CAST (0 as TFloat)                         AS ChangePercent
             , CAST (0 as TFloat)                         AS CurrencyValue
             , CAST (0 as TFloat)                         AS ParValue

             , Object_CurrencyDocument.Id                 AS CurrencyDocumentId	-- грн
             , Object_CurrencyDocument.ValueData          AS CurrencyDocumentName

             , 0                                          AS UnitId
             , CAST ('' as TVarChar)                      AS UnitName

             , 0                                          AS JuridicalId
             , CAST ('' as TVarChar)                      AS JuridicalName
             , 0                                          AS ContractId
             , CAST ('' as TVarChar)                      AS ContractName
             , 0                                          AS PaidKindId
             , CAST ('' as TVarChar)                      AS PaidKindName  
  
             , CAST ('' as TVarChar) 	                  AS Comment

             , DATE_TRUNC ('MONTH', inOperDate)   ::TDateTime    AS OperDateStart
             , (DATE_TRUNC ('MONTH', inOperDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY')  ::TDateTime AS OperDateEnd
             , CAST (30 as TFloat)                        AS DayCount
          FROM lfGet_Object_Status (zc_Enum_Status_UnComplete()) AS Object_Status
               LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = vbUserId
               LEFT JOIN Object AS Object_CurrencyDocument ON Object_CurrencyDocument.Id = zc_Enum_Currency_Basis()
          ;

     ELSE

     RETURN QUERY
      SELECT Movement.Id                            AS Id
           , zfFormat_BarCode (zc_BarCodePref_Movement(), Movement.Id) AS IdBarCode
           , Movement.InvNumber                     AS InvNumber
           , Movement.OperDate                      AS OperDate
           , MovementDate_OperDatePartner.ValueData AS OperDatePartner
           , Object_Status.ObjectCode               AS StatusCode
           , Object_Status.ValueData                AS StatusName
           
           , MovementDate_Insert.ValueData          AS InsertDate
           , Object_Insert.ValueData                AS InsertName
           
           , MovementBoolean_PriceWithVAT.ValueData AS PriceWithVAT
           , MovementFloat_VATPercent.ValueData     AS VATPercent
           , MovementFloat_ChangePercent.ValueData  AS ChangePercent
           , MovementFloat_CurrencyValue.ValueData  AS CurrencyValue
           , MovementFloat_ParValue.ValueData       AS ParValue

           , Object_CurrencyDocument.Id             AS CurrencyDocumentId
           , Object_CurrencyDocument.ValueData      AS CurrencyDocumentName

           , Object_Unit.Id                         AS UnitId
           , Object_Unit.ValueData                  AS UnitName

           , Object_Juridical.Id                    AS JuridicalId
           , Object_Juridical.ValueData             AS JuridicalName

           , Object_Contract.Id                     AS ContractId
           , Object_Contract.ValueData              AS ContractName

           , Object_PaidKind.Id                     AS PaidKindId
           , Object_PaidKind.ValueData              AS PaidKindName

           , MovementString_Comment.ValueData       AS Comment

           , COALESCE (MovementDate_OperDateStart.ValueData, DATE_TRUNC ('MONTH', Movement.OperDate)) ::TDateTime  AS OperDateStart
           , COALESCE (MovementDate_OperDateEnd.ValueData, DATE_TRUNC ('MONTH', Movement.OperDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY') ::TDateTime  AS OperDateEnd
           , COALESCE (MovementFloat_DayCount.ValueData, 30)  ::TFloat  AS DayCount

       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId = Movement.Id
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

            LEFT JOIN MovementDate AS MovementDate_OperDateStart
                                   ON MovementDate_OperDateStart.MovementId = Movement.Id
                                  AND MovementDate_OperDateStart.DescId = zc_MovementDate_OperDateStart()
            LEFT JOIN MovementDate AS MovementDate_OperDateEnd
                                   ON MovementDate_OperDateEnd.MovementId = Movement.Id
                                  AND MovementDate_OperDateEnd.DescId = zc_MovementDate_OperDateEnd()

            LEFT JOIN MovementLinkObject AS MLO_Insert
                                         ON MLO_Insert.MovementId = Movement.Id
                                        AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId  

            LEFT JOIN MovementString AS MovementString_Comment 
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                      ON MovementBoolean_PriceWithVAT.MovementId = Movement.Id
                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
            LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                    ON MovementFloat_VATPercent.MovementId =  Movement.Id
                                   AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
            LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                    ON MovementFloat_ChangePercent.MovementId =  Movement.Id
                                   AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
            LEFT JOIN MovementFloat AS MovementFloat_CurrencyValue
                                    ON MovementFloat_CurrencyValue.MovementId =  Movement.Id
                                   AND MovementFloat_CurrencyValue.DescId = zc_MovementFloat_CurrencyValue()
            LEFT JOIN MovementFloat AS MovementFloat_ParValue
                                    ON MovementFloat_ParValue.MovementId = Movement.Id
                                   AND MovementFloat_ParValue.DescId = zc_MovementFloat_ParValue()

            LEFT JOIN MovementFloat AS MovementFloat_DayCount
                                    ON MovementFloat_DayCount.MovementId = Movement.Id
                                   AND MovementFloat_DayCount.DescId = zc_MovementFloat_DayCount()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
            LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MovementLinkObject_Contract.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                         ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                        AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                         ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                        AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = MovementLinkObject_Juridical.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_CurrencyDocument
                                         ON MovementLinkObject_CurrencyDocument.MovementId = Movement.Id
                                        AND MovementLinkObject_CurrencyDocument.DescId = zc_MovementLinkObject_CurrencyDocument()
            LEFT JOIN Object AS Object_CurrencyDocument ON Object_CurrencyDocument.Id = MovementLinkObject_CurrencyDocument.ObjectId


       WHERE Movement.Id = inMovementId
         AND Movement.DescId = zc_Movement_OrderIncome();

       END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 14.04.17         * 
 12.07.16         *  
*/

-- тест
-- SELECT * FROM gpGet_Movement_OrderIncome (inMovementId:= 40874, inOperDate:= CURRENT_DATE, inSession := zfCalc_UserAdmin());
