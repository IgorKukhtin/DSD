-- Function: gpGet_Scale_Movement()

-- DROP FUNCTION IF EXISTS gpGet_Scale_Movement (TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Scale_Movement (Integer, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Scale_Movement (Integer, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Scale_Movement(
    IN inMovementId            Integer     , --
    IN inOperDate              TDateTime   , --
    IN inIsNext                Boolean     , --
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

             , PriceListId     Integer, PriceListCode     Integer, PriceListName     TVarChar
             , ContractId      Integer, ContractCode      Integer, ContractNumber    TVarChar, ContractTagName TVarChar
             , GoodsPropertyId Integer, GoodsPropertyCode Integer, GoodsPropertyName TVarChar

             , PartnerId_calc   Integer
             , PartnerCode_calc Integer
             , PartnerName_calc TVarChar
             , ChangePercent    TFloat
             , ChangePercentAmount TFloat

             , isEdiOrdspr      Boolean
             , isEdiInvoice     Boolean
             , isEdiDesadv      Boolean

             , isMovement    Boolean   -- Накладная
             , isAccount     Boolean   -- Счет
             , isTransport   Boolean   -- ТТН
             , isQuality     Boolean   -- Качественное
             , isPack        Boolean   -- Упаковочный
             , isSpec        Boolean   -- Спецификация
             , isTax         Boolean   -- Налоговая

             , MovementId_Order Integer
             , MovementDescId_Order Integer
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
       WITH tmpMovement_find AS (-- или последний не закрытый
                                 SELECT MAX (Movement.Id) AS Id
                                 FROM (SELECT (inOperDate - INTERVAL '3 DAY') AS StartDate, (inOperDate + INTERVAL '3 DAY') AS EndDate WHERE COALESCE (inMovementId, 0) = 0) AS tmp
                                      INNER JOIN Movement
                                              ON Movement.DescId = zc_Movement_WeighingPartner()
                                             AND Movement.StatusId = zc_Enum_Status_UnComplete()
                                             AND Movement.OperDate BETWEEN tmp.StartDate AND tmp.EndDate
                                      INNER JOIN MovementLinkObject
                                              AS MovementLinkObject_User
                                              ON MovementLinkObject_User.MovementId = Movement.Id
                                             AND MovementLinkObject_User.DescId = zc_MovementLinkObject_User()
                                             AND MovementLinkObject_User.ObjectId = vbUserId
                                UNION
                                 -- или "следующий" не закрытый
                                 SELECT Movement.Id AS Id
                                 FROM (SELECT (inOperDate - INTERVAL '1 DAY') AS StartDate, (inOperDate + INTERVAL '1 DAY') AS EndDate WHERE inIsNext = TRUE) AS tmp
                                      INNER JOIN Movement
                                              ON Movement.DescId = zc_Movement_WeighingPartner()
                                             AND Movement.StatusId = zc_Enum_Status_UnComplete()
                                             AND Movement.OperDate BETWEEN tmp.StartDate AND tmp.EndDate
                                      INNER JOIN MovementLinkObject
                                              AS MovementLinkObject_User
                                              ON MovementLinkObject_User.MovementId = Movement.Id
                                             AND MovementLinkObject_User.DescId = zc_MovementLinkObject_User()
                                             AND MovementLinkObject_User.ObjectId = vbUserId
                                 WHERE Movement.Id <> inMovementId
                                 -- LIMIT 2 -- если больше 1-ого то типа ошибка
                                UNION
                                 -- или inMovementId если он тоже не закрытый
                                 SELECT Movement.Id
                                 FROM (SELECT inMovementId AS MovementId WHERE inMovementId > 0 AND inIsNext = FALSE) AS tmp
                                      INNER JOIN Movement
                                              ON Movement.Id = tmp.MovementId
                                             AND Movement.DescId = zc_Movement_WeighingPartner()
                                             AND Movement.StatusId = zc_Enum_Status_UnComplete()
                                )
               , tmpMovement AS (SELECT tmpMovement_find.Id
                                      , Movement.InvNumber
                                      , Movement.OperDate
                                      , MovementFloat_MovementDesc.ValueData  AS MovementDescId
                                      , MovementLinkObject_From.ObjectId      AS FromId
                                      , MovementLinkObject_To.ObjectId        AS ToId
                                      , CASE WHEN MovementLinkMovement_Order.MovementChildId <> 0 AND MovementFloat_MovementDesc.ValueData = zc_Movement_Sale()
                                                  THEN MovementLinkObject_PriceList_Order.ObjectId -- если по заявке и zc_Movement_Sale, тогда св-во из заявки
                                             WHEN MovementFloat_MovementDesc.ValueData IN (zc_Movement_Sale(), zc_Movement_ReturnOut())
                                                  THEN lfGet_Object_Partner_PriceList_record (MovementLinkObject_Contract.ObjectId /*MovementLinkObject_Contract_Order.ObjectId*/, MovementLinkObject_To.ObjectId, inOperDate) -- если zc_Movement_Sale или zc_Movement_ReturnOut, тогда определяется
                                             WHEN MovementFloat_MovementDesc.ValueData IN (zc_Movement_ReturnIn(), zc_Movement_Income())
                                                  THEN lfGet_Object_Partner_PriceList_record (MovementLinkObject_Contract.ObjectId /*MovementLinkObject_Contract_Order.ObjectId*/, MovementLinkObject_From.ObjectId, inOperDate) -- если zc_Movement_Income или zc_Movement_ReturnIn, тогда определяется
                                             WHEN MovementFloat_MovementDesc.ValueData = zc_Movement_SendOnPrice()
                                                  THEN zc_PriceList_Basis() -- для филиалов !!!всегда!!!
                                             ELSE 0
                                        END AS PriceListId
                                      , CASE WHEN MovementFloat_MovementDesc.ValueData IN (zc_Movement_Sale(), zc_Movement_ReturnOut(), zc_Movement_SendOnPrice(), zc_Movement_Loss())
                                                  THEN MovementLinkObject_To.ObjectId
                                             WHEN MovementFloat_MovementDesc.ValueData IN (zc_Movement_ReturnIn(), zc_Movement_Income())
                                                  THEN MovementLinkObject_From.ObjectId
                                             ELSE 0
                                        END AS PartnerId
                                      , ObjectLink_Partner_Juridical.ChildObjectId AS JuridicalId

                                      , MovementLinkObject_Contract.ObjectId AS ContractId -- значение - то что сохранилось при создании
                                      , zfCalc_GoodsPropertyId (MovementLinkObject_Contract.ObjectId, ObjectLink_Partner_Juridical.ChildObjectId) AS GoodsPropertyId

                                      , MovementLinkMovement_Order.MovementChildId AS MovementId_Order

                                 FROM tmpMovement_find
                                      LEFT JOIN Movement ON Movement.Id = tmpMovement_find.Id
                                      LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                                   ON MovementLinkObject_From.MovementId = Movement.Id
                                                                  AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                      LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                                   ON MovementLinkObject_To.MovementId = Movement.Id
                                                                  AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                      LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                                   ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                                  AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()

                                      LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Order
                                                                     ON MovementLinkMovement_Order.MovementId = Movement.Id
                                                                    AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
                                      LEFT JOIN MovementLinkObject AS MovementLinkObject_PriceList_Order
                                                                   ON MovementLinkObject_PriceList_Order.MovementId = MovementLinkMovement_Order.MovementChildId
                                                                  AND MovementLinkObject_PriceList_Order.DescId = zc_MovementLinkObject_PriceList()
                                      /*LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract_Order
                                                                   ON MovementLinkObject_Contract_Order.MovementId = MovementLinkMovement_Order.MovementChildId
                                                                  AND MovementLinkObject_Contract_Order.DescId = zc_MovementLinkObject_Contract()*/
                                      LEFT JOIN MovementFloat AS MovementFloat_MovementDesc
                                                              ON MovementFloat_MovementDesc.MovementId =  Movement.Id
                                                             AND MovementFloat_MovementDesc.DescId = zc_MovementFloat_MovementDesc()
                                      LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                           ON ObjectLink_Partner_Juridical.ObjectId = CASE WHEN MovementFloat_MovementDesc.ValueData IN (zc_Movement_Sale(), zc_Movement_ReturnOut())
                                                                                                                THEN MovementLinkObject_To.ObjectId
                                                                                                           ELSE MovementLinkObject_From.ObjectId
                                                                                                      END
                                                          AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                 WHERE tmpMovement_find.Id > 0
                                )
           , tmpJuridicalPrint AS (SELECT tmp.Id AS JuridicalId
                                        , tmp.isMovement
                                        , tmp.isAccount
                                        , tmp.isTransport
                                        , tmp.isQuality
                                        , tmp.isPack
                                        , tmp.isSpec
                                        , tmp.isTax
                                   FROM lpGet_Object_Juridical_PrintKindItem ((SELECT tmpMovement.JuridicalId FROM tmpMovement LIMIT 1)) AS tmp
                                  )
       SELECT tmpMovement.Id                                 AS MovementId
            , '' ::TVarChar                                  AS BarCode
            , tmpMovement.InvNumber                          AS InvNumber
            , tmpMovement.OperDate                           AS OperDate

            , MovementFloat_MovementDescNumber.ValueData :: Integer AS MovementDescNumber

            , tmpMovement.MovementDescId :: Integer             AS MovementDescId
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

            , Object_GoodsProperty.Id                        AS GoodsPropertyId
            , Object_GoodsProperty.ObjectCode                AS GoodsPropertyCode
            , Object_GoodsProperty.ValueData                 AS GoodsPropertyName

            , Object_Partner.Id                              AS PartnerId_calc
            , Object_Partner.ObjectCode                      AS PartnerCode_calc
            , Object_Partner.ValueData                       AS PartnerName_calc
            , MovementFloat_ChangePercent.ValueData          AS ChangePercent
            , (SELECT tmp.ChangePercentAmount FROM gpGet_Scale_Partner (inOperDate, -1 * Object_Partner.Id, inSession) AS tmp WHERE tmp.ContractId = View_Contract_InvNumber.ContractId) AS ChangePercentAmount

            , COALESCE (ObjectBoolean_Partner_EdiOrdspr.ValueData, FALSE)  :: Boolean AS isEdiOrdspr
            , COALESCE (ObjectBoolean_Partner_EdiInvoice.ValueData, FALSE) :: Boolean AS isEdiInvoice
            , COALESCE (ObjectBoolean_Partner_EdiDesadv.ValueData, FALSE)  :: Boolean AS isEdiDesadv

            , CASE WHEN tmpJuridicalPrint.isPack = TRUE OR tmpJuridicalPrint.isSpec = TRUE THEN COALESCE (tmpJuridicalPrint.isMovement, FALSE) ELSE TRUE END :: Boolean AS isMovement
            , COALESCE (tmpJuridicalPrint.isAccount,   FALSE) :: Boolean AS isAccount
            , COALESCE (tmpJuridicalPrint.isTransport, FALSE) :: Boolean AS isTransport
            , COALESCE (tmpJuridicalPrint.isQuality,   FALSE) :: Boolean AS isQuality
            , COALESCE (tmpJuridicalPrint.isPack,      FALSE) :: Boolean AS isPack
            , COALESCE (tmpJuridicalPrint.isSpec,      FALSE) :: Boolean AS isSpec
            , COALESCE (tmpJuridicalPrint.isTax,       FALSE) :: Boolean AS isTax

            , tmpMovement.MovementId_Order AS MovementId_Order
            , Movement_Order.DescId        AS MovementDescId_Order
            , Movement_Order.InvNumber     AS InvNumber_Order
            , ('№ <' || Movement_Order.InvNumber || '>' || ' от <' || DATE (Movement_Order.OperDate) :: TVarChar || '>' || ' '|| COALESCE (Object_Personal.ValueData, '')) :: TVarChar AS OrderExternalName_master

            , MovementFloat_TotalSumm.ValueData AS TotalSumm

       FROM tmpMovement
            LEFT JOIN tmpJuridicalPrint ON tmpJuridicalPrint.JuridicalId = tmpMovement.JuridicalId

            LEFT JOIN Movement AS Movement_Order ON Movement_Order.Id = tmpMovement.MovementId_Order
            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Order
                                           ON MovementLinkMovement_Order.MovementId = tmpMovement.MovementId_Order
                                          AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()

            LEFT JOIN Object AS Object_From ON Object_From.Id = tmpMovement.FromId
            LEFT JOIN Object AS Object_To ON Object_To.Id = tmpMovement.ToId
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = tmpMovement.PartnerId
            LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = tmpMovement.PriceListId

            LEFT JOIN ObjectBoolean AS ObjectBoolean_Partner_EdiOrdspr
                                    ON ObjectBoolean_Partner_EdiOrdspr.ObjectId =  tmpMovement.PartnerId
                                   AND ObjectBoolean_Partner_EdiOrdspr.DescId = zc_ObjectBoolean_Partner_EdiOrdspr()
                                   AND MovementLinkMovement_Order.MovementChildId > 0 -- проверка по связи заявки с EDI
            LEFT JOIN ObjectBoolean AS ObjectBoolean_Partner_EdiInvoice
                                    ON ObjectBoolean_Partner_EdiInvoice.ObjectId =  tmpMovement.PartnerId
                                   AND ObjectBoolean_Partner_EdiInvoice.DescId = zc_ObjectBoolean_Partner_EdiInvoice()
                                   AND MovementLinkMovement_Order.MovementChildId > 0 -- проверка по связи заявки с EDI
            LEFT JOIN ObjectBoolean AS ObjectBoolean_Partner_EdiDesadv
                                    ON ObjectBoolean_Partner_EdiDesadv.ObjectId =  tmpMovement.PartnerId
                                   AND ObjectBoolean_Partner_EdiDesadv.DescId = zc_ObjectBoolean_Partner_EdiDesadv()
                                   AND MovementLinkMovement_Order.MovementChildId > 0 -- проверка по связи заявки с EDI

            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  tmpMovement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
            LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                    ON MovementFloat_ChangePercent.MovementId =  tmpMovement.Id
                                   AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
            LEFT JOIN MovementFloat AS MovementFloat_MovementDescNumber
                                    ON MovementFloat_MovementDescNumber.MovementId =  tmpMovement.Id
                                   AND MovementFloat_MovementDescNumber.DescId = zc_MovementFloat_MovementDescNumber()

            LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = tmpMovement.ContractId
            LEFT JOIN Object AS Object_GoodsProperty ON Object_GoodsProperty.Id = tmpMovement.GoodsPropertyId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                         ON MovementLinkObject_PaidKind.MovementId = tmpMovement.Id
                                        AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Personal
                                         ON MovementLinkObject_Personal.MovementId = tmpMovement.MovementId_Order
                                        AND MovementLinkObject_Personal.DescId = zc_MovementLinkObject_Personal()
            LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = MovementLinkObject_Personal.ObjectId
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Scale_Movement (Integer, TDateTime, Boolean, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 18.01.15                                        *
*/

-- тест
-- SELECT * FROM gpGet_Scale_Movement (0, CURRENT_TIMESTAMP, TRUE, zfCalc_UserAdmin())
-- SELECT * FROM gpGet_Scale_Movement (0, CURRENT_TIMESTAMP, FALSE, zfCalc_UserAdmin())
