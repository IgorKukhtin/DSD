-- Function: gpGet_Scale_Movement()

DROP FUNCTION IF EXISTS gpGet_Scale_Movement (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Scale_Movement(
    IN inOperDate              TDateTime   , --
    IN inSession               TVarChar      -- сессия пользователя
)
RETURNS TABLE (MovementId       Integer
             , BarCode          TVarChar
             , InvNumber        TVarChar
             , OperDate         TDateTime

             , MovementDescNumber Integer

             , MovementDescId Integer
             , FromId         Integer, FromCode         Integer, FromName       TVarChar
             , ToId           Integer, ToCode           Integer, ToName         TVarChar
             , PaidKindId     Integer, PaidKindName   TVarChar

             , PriceListId    Integer, PriceListCode  Integer, PriceListName TVarChar
             , ContractId     Integer, ContractCode   Integer, ContractNumber TVarChar, ContractTagName TVarChar

             , PartnerId_calc   Integer
             , PartnerCode_calc Integer
             , PartnerName_calc TVarChar
             , ChangePercent    TFloat
             , ChangePercentAmount TFloat
             , isEdiOrdspr      Boolean
             , isEdiInvoice     Boolean
             , isEdiDesadv      Boolean

             , MovementId_Order Integer
             , InvNumber_Order  TVarChar
             , OrderExternalName_master TVarChar

             , TotalSumm TFloat
              )
AS	
$BODY$
   DECLARE vbUserId     Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);


    -- Результат
    RETURN QUERY
       SELECT Movement.Id                                    AS MovementId
            , '' ::TVarChar                                  AS BarCode
            , Movement.InvNumber                             AS InvNumber
            , Movement.OperDate                              AS OperDate

            , MovementFloat_MovementDescNumber.ValueData :: Integer AS MovementDescNumber

            , Movement.MovementDescId :: Integer             AS MovementDescId
            , Object_From.Id                                 AS FromId
            , Object_From.ObjectCode                         AS FromCode
            , Object_From.ValueData                          AS FromName
            , Object_To.Id                                   AS ToId
            , Object_To.ObjectCode                           AS ToCode
            , Object_To.ValueData                            AS ToName
            , Object_PaidKind.Id                             AS PaidKindId
            , Object_PaidKind.ValueData                      AS PaidKindName

            , Object_PriceList.Id                            AS PriceListId
            , Object_PriceList.ObjectCode                    AS PriceListCode
            , Object_PriceList.ValueData                     AS PriceListName
            , View_Contract_InvNumber.ContractId             AS ContractId
            , View_Contract_InvNumber.ContractCode           AS ContractCode
            , View_Contract_InvNumber.InvNumber              AS ContractNumber
            , View_Contract_InvNumber.ContractTagName        AS ContractTagName

            , Object_Partner.Id                              AS PartnerId_calc
            , Object_Partner.ObjectCode                      AS PartnerCode_calc
            , Object_Partner.ValueData                       AS PartnerName_calc
            , MovementFloat_ChangePercent.ValueData          AS ChangePercent
            , (SELECT tmp.ChangePercentAmount FROM gpGet_Scale_Partner (inOperDate, -1 * Object_Partner.Id, inSession) AS tmp WHERE tmp.ContractId = View_Contract_InvNumber.ContractId) AS ChangePercentAmount

            , COALESCE (ObjectBoolean_Partner_EdiOrdspr.ValueData, FALSE)  :: Boolean AS isEdiOrdspr
            , COALESCE (ObjectBoolean_Partner_EdiInvoice.ValueData, FALSE) :: Boolean AS isEdiInvoice
            , COALESCE (ObjectBoolean_Partner_EdiDesadv.ValueData, FALSE)  :: Boolean AS isEdiDesadv

            , Movement.MovementId_Order AS MovementId_Order
            , Movement_Order.InvNumber  AS InvNumber_Order

            , ('№ <' || Movement_Order.InvNumber || '>' || ' от <' || DATE (Movement_Order.OperDate) :: TVarChar || '>') :: TVarChar AS OrderExternalName_master

            , MovementFloat_TotalSumm.ValueData AS TotalSumm

       FROM (SELECT Movement_find.Id
                  , Movement.InvNumber
                  , Movement.OperDate
                  , MovementFloat_MovementDesc.ValueData AS MovementDescId
                  , MovementLinkObject_From.ObjectId     AS FromId
                  , MovementLinkObject_To.ObjectId       AS ToId
                  , CASE WHEN MovementLinkMovement_Order.MovementChildId <> 0 AND MovementFloat_MovementDesc.ValueData = zc_Movement_Sale()
                              THEN MovementLinkObject_PriceList_Order.ObjectId
                         WHEN MovementFloat_MovementDesc.ValueData IN (zc_Movement_Sale(), zc_Movement_ReturnOut())
                              THEN lfGet_Object_Partner_PriceList_record (MovementLinkObject_To.ObjectId, inOperDate)
                         WHEN MovementFloat_MovementDesc.ValueData IN (zc_Movement_ReturnIn(), zc_Movement_Income())
                              THEN lfGet_Object_Partner_PriceList_record (MovementLinkObject_From.ObjectId, inOperDate)
                         WHEN MovementFloat_MovementDesc.ValueData = zc_Movement_SendOnPrice()
                              THEN zc_PriceList_Basis()
                         ELSE 0
                    END AS PriceListId
                  , CASE WHEN MovementFloat_MovementDesc.ValueData IN (zc_Movement_Sale(), zc_Movement_ReturnOut())
                              THEN MovementLinkObject_To.ObjectId
                         WHEN MovementFloat_MovementDesc.ValueData IN (zc_Movement_ReturnIn(), zc_Movement_Income())
                              THEN MovementLinkObject_From.ObjectId
                         ELSE 0
                    END AS PartnerId
                  , MovementLinkMovement_Order.MovementChildId AS MovementId_Order
             FROM
            (SELECT MAX (Movement.Id) AS Id
             FROM Movement
                  INNER JOIN MovementLinkObject
                          AS MovementLinkObject_User
                          ON MovementLinkObject_User.MovementId = Movement.Id
                         AND MovementLinkObject_User.DescId = zc_MovementLinkObject_User()
                         AND MovementLinkObject_User.ObjectId = vbUserId
             WHERE Movement.DescId = zc_Movement_WeighingPartner()
               AND Movement.StatusId = zc_Enum_Status_UnComplete()
               AND Movement.OperDate BETWEEN inOperDate - INTERVAL '5 DAY' AND inOperDate + INTERVAL '5 DAY'
            ) AS Movement_find
              LEFT JOIN Movement ON Movement.Id = Movement_find.Id
              LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                           ON MovementLinkObject_From.MovementId = Movement.Id
                                          AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
              LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                           ON MovementLinkObject_To.MovementId = Movement.Id
                                          AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
              LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Order
                                             ON MovementLinkMovement_Order.MovementId = Movement.Id
                                            AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
              LEFT JOIN MovementLinkObject AS MovementLinkObject_PriceList_Order
                                           ON MovementLinkObject_PriceList_Order.MovementId = MovementLinkMovement_Order.MovementChildId
                                          AND MovementLinkObject_PriceList_Order.DescId = zc_MovementLinkObject_PriceList()

              LEFT JOIN MovementFloat AS MovementFloat_MovementDesc
                                      ON MovementFloat_MovementDesc.MovementId =  Movement.Id
                                     AND MovementFloat_MovementDesc.DescId = zc_MovementFloat_MovementDesc()

            ) AS Movement

            LEFT JOIN Movement AS Movement_Order ON Movement_Order.Id = Movement.MovementId_Order

            LEFT JOIN Object AS Object_From ON Object_From.Id = Movement.FromId
            LEFT JOIN Object AS Object_To ON Object_To.Id = Movement.ToId
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = Movement.PartnerId
            LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = Movement.PriceListId

            LEFT JOIN ObjectBoolean AS ObjectBoolean_Partner_EdiOrdspr
                                    ON ObjectBoolean_Partner_EdiOrdspr.ObjectId =  Movement.PartnerId
                                   AND ObjectBoolean_Partner_EdiOrdspr.DescId = zc_ObjectBoolean_Partner_EdiOrdspr()
            LEFT JOIN ObjectBoolean AS ObjectBoolean_Partner_EdiInvoice
                                    ON ObjectBoolean_Partner_EdiInvoice.ObjectId =  Movement.PartnerId
                                   AND ObjectBoolean_Partner_EdiInvoice.DescId = zc_ObjectBoolean_Partner_EdiInvoice()
            LEFT JOIN ObjectBoolean AS ObjectBoolean_Partner_EdiDesadv
                                    ON ObjectBoolean_Partner_EdiDesadv.ObjectId =  Movement.PartnerId
                                   AND ObjectBoolean_Partner_EdiDesadv.DescId = zc_ObjectBoolean_Partner_EdiDesadv()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
            LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                    ON MovementFloat_ChangePercent.MovementId =  Movement.Id
                                   AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
            LEFT JOIN MovementFloat AS MovementFloat_MovementDescNumber
                                    ON MovementFloat_MovementDescNumber.MovementId =  Movement.Id
                                   AND MovementFloat_MovementDescNumber.DescId = zc_MovementFloat_MovementDescNumber()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
            LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = MovementLinkObject_Contract.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                         ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                        AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Scale_Movement (TDateTime, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 18.01.15                                        *
*/

-- тест
-- SELECT * FROM gpGet_Scale_Movement ('01.01.2015', zfCalc_UserAdmin())
