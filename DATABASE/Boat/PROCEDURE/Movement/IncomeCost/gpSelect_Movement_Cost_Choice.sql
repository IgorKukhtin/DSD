-- Function: gpSelect_Movement_Cost_Choice()

DROP FUNCTION IF EXISTS gpSelect_Movement_Cost_Choice (TDateTime, TDateTime, Boolean, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Cost_Choice(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inIsErased      Boolean   ,
    IN inInfoMoneyId   Integer   ,
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber Integer, InvNumber_Full TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , Comment TVarChar , DescId Integer, DescName TVarChar
             , PartnerCode Integer, PartnerName TVarChar
             , InfoMoneyCode Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , Amount TFloat, Amount_NotVAT TFloat, Amount_VAT TFloat
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


     , tmpInvoice AS (SELECT Movement.Id AS MovementId
                           , Movement.StatusId AS StatusId
                           , Movement.OperDate
                           , zfConvert_StringToNumber (Movement.InvNumber) AS InvNumber
                           , ('№ ' || Movement.InvNumber || ' от ' || zfConvert_DateToString (Movement.OperDate)) :: TVarChar AS InvNumber_Full
                           , Movement.DescId                               AS DescId
                           , MovementDesc.ItemName                         AS DescName

                             -- с НДС
                           , -1 * MovementFloat_Amount.ValueData           AS Amount
                             -- без НДС
                           , -1 * zfCalc_Summ_NoVAT (MovementFloat_Amount.ValueData, ObjectFloat_TaxKind_Value.ValueData) AS Amount_NotVAT
                             -- НДС
                           , -1 * zfCalc_Summ_VAT (MovementFloat_Amount.ValueData, ObjectFloat_TaxKind_Value.ValueData) AS Amount_VAT

                           , MovementString_Comment.ValueData              AS Comment
                           , MLO_InfoMoney.ObjectId                        AS InfoMoneyId
                           , MLO_Object.ObjectId                           AS PartnerId
                      FROM tmpStatus
                           INNER JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate
                                              AND Movement.DescId = zc_Movement_Invoice()
                                              AND Movement.StatusId = tmpStatus.StatusId
                           LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId

                           -- Сумма по счету, которую выставили нам
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
                           LEFT JOIN ObjectLink AS ObjectLink_TaxKind
                                                ON ObjectLink_TaxKind.ObjectId = MLO_Object.ObjectId
                                               AND ObjectLink_TaxKind.DescId   IN (zc_ObjectLink_Partner_TaxKind(), zc_ObjectLink_Client_TaxKind())
                           LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                                 ON ObjectFloat_TaxKind_Value.ObjectId = ObjectLink_TaxKind.ChildObjectId 
                                                AND ObjectFloat_TaxKind_Value.DescId   = zc_ObjectFloat_TaxKind_Value()
                     )
     , tmpList AS  (SELECT tmpInvoice.MovementId, tmpInvoice.StatusId, tmpInvoice.OperDate, tmpInvoice.InvNumber, tmpInvoice.InvNumber_Full
                         , tmpInvoice.DescId, tmpInvoice.DescName
                         , tmpInvoice.Amount, tmpInvoice.Amount_NotVAT, tmpInvoice.Amount_VAT
                         , tmpInvoice.Comment
                         , tmpInvoice.InfoMoneyId, tmpInvoice.PartnerId
                    FROM tmpInvoice
                   )
        -- РЕЗУЛЬТАТ
        SELECT tmpList.MovementId AS Id
             , tmpList.InvNumber
             , tmpList.InvNumber_Full
             , tmpList.OperDate
             , Object_Status.ObjectCode         AS StatusCode
             , Object_Status.ValueData          AS StatusName
             , tmpList.Comment
             , tmpList.DescId
             , tmpList.DescName
             
             , Object_Partner.ObjectCode   AS PartnerCode
             , Object_Partner.ValueData    AS PartnerName

             , Object_InfoMoney_View.InfoMoneyCode
             , Object_InfoMoney_View.InfoMoneyGroupName
             , Object_InfoMoney_View.InfoMoneyDestinationName
             , Object_InfoMoney_View.InfoMoneyName
             , Object_InfoMoney_View.InfoMoneyName_all

               -- Сумма счета - с НДС
             , tmpList.Amount :: TFloat
               -- без НДС
             , tmpList.Amount_NotVAT :: TFloat
               -- НДС
             , tmpList.Amount_VAT :: TFloat

        FROM tmpList
             LEFT JOIN Object AS Object_Status  ON Object_Status.Id  = tmpList.StatusId
             LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = tmpList.PartnerId
             LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = tmpList.InfoMoneyId
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
