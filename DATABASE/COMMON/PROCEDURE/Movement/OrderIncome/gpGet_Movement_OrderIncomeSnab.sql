-- Function: gpGet_Movement_OrderIncomeSnab()

DROP FUNCTION IF EXISTS gpGet_Movement_OrderIncomeSnab (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_OrderIncomeSnab(
    IN inMovementId        Integer  , -- ключ Документа
    IN inOperDate          TDateTime, -- дата Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar
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
             , DayCount    TFloat  -- период ПРОГНОЗА = 4 недели
             , ReserveDays TFloat  -- на сколько дней считаем План. Заказ на месяц
             , InvNumber_Income_Full TVarChar
             , FromName_Income TVarChar
             , isClosed Boolean
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
             , CAST (NEXTVAL ('movement_OrderIncome_seq') AS TVarChar) AS InvNumber
             , inOperDate                                 AS OperDate
             , inOperDate		                  AS OperDatePartner

             , Object_Status.Code                         AS StatusCode
             , Object_Status.Name                         AS StatusName

             , CURRENT_TIMESTAMP ::TDateTime              AS InsertDate
             , COALESCE(Object_Insert.ValueData,'')  ::TVarChar AS InsertName

             , CAST (TRUE as Boolean)                     AS PriceWithVAT
             , CAST (20 as TFloat)                        AS VATPercent
             , CAST (0 as TFloat)                         AS ChangePercent
             , CAST (0 as TFloat)                         AS CurrencyValue
             , CAST (0 as TFloat)                         AS ParValue

             , Object_CurrencyDocument.Id                 AS CurrencyDocumentId	-- грн
             , Object_CurrencyDocument.ValueData          AS CurrencyDocumentName

             , Object_Unit.Id                               AS UnitId
             , Object_Unit.ValueData                        AS UnitName

             , 0                                          AS JuridicalId
             , CAST ('' as TVarChar)                      AS JuridicalName
             , 0                                          AS ContractId
             , CAST ('' as TVarChar)                      AS ContractName
             , 0                                          AS PaidKindId
             , CAST ('' as TVarChar)                      AS PaidKindName

             , CAST ('' as TVarChar) 	                  AS Comment

            /* , DATE_TRUNC ('MONTH', inOperDate)   ::TDateTime    AS OperDateStart
             , (DATE_TRUNC ('MONTH', inOperDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY')  ::TDateTime AS OperDateEnd*/
             , ((CASE WHEN EXTRACT (DOW FROM CURRENT_DATE) = 0 THEN CURRENT_DATE ELSE (CURRENT_DATE - ((EXTRACT (DOW FROM CURRENT_DATE))  :: TVarChar || ' DAY') :: INTERVAL) END) - interval '27 day')   ::TDateTime   AS OperDateStart
             , (CASE WHEN EXTRACT (DOW FROM CURRENT_DATE) = 0 THEN CURRENT_DATE ELSE (CURRENT_DATE - ((EXTRACT (DOW FROM CURRENT_DATE))  :: TVarChar || ' DAY') :: INTERVAL) END)                         ::TDateTime   AS OperDateEnd

               -- период ПРОГНОЗА = 4 недели
             , CAST (DATE_PART ('DAY', (DATE_TRUNC ('MONTH', inOperDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY'
                                      - DATE_TRUNC ('MONTH', inOperDate)
                                       )) + 1 AS TFloat) AS DayCount
               -- на сколько дней считаем План. Заказ на месяц
             , CAST (30 as TFloat)                        AS ReserveDays

             , CAST ('' as TVarChar) 	                  AS InvNumber_Income_Full
             , CAST ('' as TVarChar) 	                  AS FromName_Income

             , FALSE AS isClosed

          FROM lfGet_Object_Status (zc_Enum_Status_UnComplete()) AS Object_Status
               LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = vbUserId
               LEFT JOIN Object AS Object_CurrencyDocument ON Object_CurrencyDocument.Id = zc_Enum_Currency_Basis()
               LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = 8455 -- Склад специй
          ;

     ELSE

     RETURN QUERY
     WITH
     tmpIncome AS
              (SELECT STRING_AGG ( tmp.InvNumber_Income_Full, '; ')    :: TVarChar  AS InvNumber_Income_Full
                    , STRING_AGG (DISTINCT tmp.FromName_Income, '; ')  :: TVarChar  AS FromName_Income
               FROM (
                     SELECT ('№ ' || Movement_Income.InvNumber || ' от ' || Movement_Income.OperDate  :: Date :: TVarChar ) :: TVarChar  AS InvNumber_Income_Full
                          , CASE WHEN Object_FromIncome.DescId = zc_Object_Juridical() THEN Object_FromIncome.ValueData ELSE Object_JuridicalFromIncome.ValueData END :: TVarChar AS FromName_Income
                     FROM MovementLinkMovement AS MovementLinkMovement_Income
                          LEFT JOIN Movement AS Movement_Income ON Movement_Income.Id = MovementLinkMovement_Income.MovementId
                          LEFT JOIN MovementLinkObject AS MovementLinkObject_FromIncome
                                                       ON MovementLinkObject_FromIncome.MovementId = Movement_Income.Id
                                                      AND MovementLinkObject_FromIncome.DescId = zc_MovementLinkObject_From()
                          LEFT JOIN Object AS Object_FromIncome ON Object_FromIncome.Id = MovementLinkObject_FromIncome.ObjectId
                          LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                               ON ObjectLink_Partner_Juridical.ObjectId = Object_FromIncome.Id
                                              AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                          LEFT JOIN Object AS Object_JuridicalFromIncome ON Object_JuridicalFromIncome.Id = ObjectLink_Partner_Juridical.ChildObjectId

                     WHERE MovementLinkMovement_Income.MovementChildId = inMovementId --5811398 -- Movement.Id
                       AND MovementLinkMovement_Income.DescId = zc_MovementLinkMovement_Order()
                     ) AS tmp
                 )

      SELECT Movement.Id                            AS Id
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

             -- период ПРОГНОЗА = 4 недели
           , CAST (DATE_PART ('DAY', (COALESCE (MovementDate_OperDateEnd.ValueData, DATE_TRUNC ('MONTH', Movement.OperDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY')
                                    - COALESCE (MovementDate_OperDateStart.ValueData, DATE_TRUNC ('MONTH', Movement.OperDate))
                                     )) + 1 AS TFloat) AS DayCount
             -- на сколько дней считаем План. Заказ на месяц
           , COALESCE (MovementFloat_DayCount.ValueData, 30) :: TFloat  AS ReserveDays

           , tmpIncome.InvNumber_Income_Full
           , tmpIncome.FromName_Income

           , COALESCE (MovementBoolean_Closed.ValueData, false)::Boolean AS isClosed
       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementBoolean AS MovementBoolean_Closed
                                      ON MovementBoolean_Closed.MovementId = Movement.Id
                                     AND MovementBoolean_Closed.DescId = zc_MovementBoolean_Closed()

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

            LEFT JOIN tmpIncome ON 1=1

       WHERE Movement.Id = inMovementId
         AND Movement.DescId = zc_Movement_OrderIncome();

       END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 05.05.17         *
 14.04.17         *
 12.07.16         *
*/

-- тест
-- SELECT * FROM gpGet_Movement_OrderIncomeSnab (inMovementId:= 40874, inOperDate:= CURRENT_DATE, inSession := zfCalc_UserAdmin());
--select * from gpGet_Movement_OrderIncomeSnab(inMovementId := 5811398 , inOperDate := ('31.12.2017')::TDateTime ,  inSession := '5');
