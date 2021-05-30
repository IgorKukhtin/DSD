-- Function: gpSelect_Movement_Cost_Choice()

DROP FUNCTION IF EXISTS gpCheckDesc_Movement_IncomeCost (Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpCheckDesc_Movement_IncomeCost (Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_Cost_Choice (TDateTime, TDateTime, Boolean, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Cost_Choice(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inIsErased      Boolean   ,
    IN inInfoMoneyId   Integer   ,
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (MovementId Integer, InvNumber Integer, InvNumber_Full TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , Comment TVarChar , DescId Integer, DescName TVarChar
             , PartnerCode Integer, PartnerName TVarChar
             , InfoMoneyCode Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , Amount TFloat, Amount_NotVAT TFloat, Amount_VAT TFloat
             , VATPercent TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete() AS StatusId
                       UNION
                        SELECT zc_Enum_Status_UnComplete() AS StatusId
                       UNION
                        SELECT zc_Enum_Status_Erased() AS StatusId WHERE inIsErased = TRUE
                       )
       -- Счета, которые выставили нам
     , tmpInvoice AS (SELECT Movement.Id AS MovementId
                           , Movement.StatusId AS StatusId
                           , Movement.OperDate
                           , zfConvert_StringToNumber (Movement.InvNumber) AS InvNumber
                           , zfCalc_InvNumber_isErased ('', Movement.InvNumber, Movement.OperDate, Movement.StatusId) AS InvNumber_Full
                           , Movement.DescId                               AS DescId
                           , MovementDesc.ItemName                         AS DescName

                             -- с НДС
                           , -1 * MovementFloat_Amount.ValueData           AS Amount
                             -- без НДС
                           , -1 * zfCalc_Summ_NoVAT (MovementFloat_Amount.ValueData, MovementFloat_VATPercent.ValueData) AS Amount_NotVAT
                             -- НДС
                           , -1 * zfCalc_Summ_VAT (MovementFloat_Amount.ValueData, MovementFloat_VATPercent.ValueData) AS Amount_VAT
                             -- % НДС
                           , MovementFloat_VATPercent.ValueData            AS VATPercent

                           , MovementString_Comment.ValueData              AS Comment
                           , MLO_InfoMoney.ObjectId                        AS InfoMoneyId
                           , MLO_Object.ObjectId                           AS PartnerId
                      FROM tmpStatus
                           INNER JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate
                                              AND Movement.DescId = zc_Movement_Invoice()
                                              AND Movement.StatusId = tmpStatus.StatusId
                           LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId

                           -- условие - счету, который выставили нам
                           INNER JOIN MovementFloat AS MovementFloat_Amount
                                                    ON MovementFloat_Amount.MovementId = Movement.Id
                                                   AND MovementFloat_Amount.DescId = zc_MovementFloat_Amount()
                                                   AND MovementFloat_Amount.ValueData  < 0

                           LEFT JOIN MovementLinkObject AS MLO_Object
                                                        ON MLO_Object.MovementId = Movement.Id
                                                       AND MLO_Object.DescId     = zc_MovementLinkObject_Object()
                           LEFT JOIN MovementLinkObject AS MLO_InfoMoney
                                                        ON MLO_InfoMoney.MovementId = Movement.Id
                                                       AND MLO_InfoMoney.DescId     = zc_MovementLinkObject_InfoMoney()
                           LEFT JOIN MovementString AS MovementString_Comment
                                                    ON MovementString_Comment.MovementId =  Movement.Id
                                                   AND MovementString_Comment.DescId = zc_MovementString_Comment()

                           LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                                   ON MovementFloat_VATPercent.MovementId = Movement.Id
                                                  AND MovementFloat_VATPercent.DescId     = zc_MovementFloat_VATPercent()
                     )
       -- Счета, которые уже попали в zc_Movement_IncomeCost, их не всегда надо показывать
     , tmpInvoice_check AS (SELECT tmpInvoice.MovementId
                            FROM tmpInvoice
                                 JOIN MovementFloat AS MovementFloat_MovementId 
                                                    ON MovementFloat_MovementId.ValueData = tmpInvoice.MovementId
                                                   AND MovementFloat_MovementId.DescId    = zc_MovementFloat_MovementId()
                                 JOIN Movement ON Movement.Id       = MovementFloat_MovementId.MovementId
                                              AND Movement.StatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete())
                           )
        -- РЕЗУЛЬТАТ
        SELECT tmpInvoice.MovementId
             , tmpInvoice.InvNumber
             , tmpInvoice.InvNumber_Full
             , tmpInvoice.OperDate
             , Object_Status.ObjectCode         AS StatusCode
             , Object_Status.ValueData          AS StatusName
             , tmpInvoice.Comment
             , tmpInvoice.DescId
             , tmpInvoice.DescName
             
             , Object_Partner.ObjectCode   AS PartnerCode
             , Object_Partner.ValueData    AS PartnerName

             , Object_InfoMoney_View.InfoMoneyCode
             , Object_InfoMoney_View.InfoMoneyGroupName
             , Object_InfoMoney_View.InfoMoneyDestinationName
             , Object_InfoMoney_View.InfoMoneyName
             , Object_InfoMoney_View.InfoMoneyName_all

               -- Сумма счета - с НДС
             , tmpInvoice.Amount :: TFloat
               -- без НДС
             , tmpInvoice.Amount_NotVAT :: TFloat
               -- НДС
             , tmpInvoice.Amount_VAT :: TFloat
               -- % НДС
             , tmpInvoice.VATPercent :: TFloat

        FROM tmpInvoice
             LEFT JOIN Object AS Object_Status  ON Object_Status.Id  = tmpInvoice.StatusId
             LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = tmpInvoice.PartnerId
             LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = tmpInvoice.InfoMoneyId
             LEFT JOIN tmpInvoice_check ON tmpInvoice_check.MovementId = tmpInvoice.MovementId
        WHERE tmpInvoice_check.MovementId IS NULL
      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.03.20         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_Cost_Choice (inStartDate:= '01.01.2021'::TDateTime, inEndDate:= '31.03.2021'::TDateTime, inIsErased:= FALSE, inInfoMoneyId :=0, inSession:= zfCalc_UserAdmin())
