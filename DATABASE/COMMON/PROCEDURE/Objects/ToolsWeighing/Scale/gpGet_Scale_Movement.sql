-- Function: gpGet_Scale_Movement()

-- DROP FUNCTION IF EXISTS gpGet_Scale_Movement (Integer, TDateTime, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Scale_Movement (Integer, TDateTime, Boolean, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Scale_Movement(
    IN inMovementId            Integer     , --
    IN inOperDate              TDateTime   , --
    IN inIsNext                Boolean     , --
    IN inBranchCode            Integer     , --
    IN inSession               TVarChar      -- сессия пользователя
)
RETURNS TABLE (MovementId       Integer
             , BarCode          TVarChar
             , InvNumber        TVarChar
             , InvNumberPartner TVarChar
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

             , isMovement      Boolean, CountMovement   TFloat   -- Накладная
             , isAccount       Boolean, CountAccount    TFloat   -- Счет
             , isTransport     Boolean, CountTransport  TFloat   -- ТТН
             , isQuality       Boolean, CountQuality    TFloat   -- Качественное
             , isPack          Boolean, CountPack       TFloat   -- Упаковочный
             , isSpec          Boolean, CountSpec       TFloat   -- Спецификация
             , isTax           Boolean, CountTax        TFloat   -- Налоговая

             , isContractGoods Boolean
             , isAsset        Boolean

             , MovementId_Order Integer
             , MovementDescId_Order Integer
             , InvNumber_Order  TVarChar
             , OrderExternalName_master TVarChar

             , MovementId_Transport Integer
             , Transport_BarCode    TVarChar
             , Transport_InvNumber  TVarChar
             , PersonalDriverId     Integer
             , PersonalDriverName   TVarChar
             , CarName              TVarChar
             , RouteName            TVarChar

             , SubjectDocId   Integer
             , SubjectDocCode Integer
             , SubjectDocName TVarChar

             , ReasonId       Integer
             , ReasonCode     Integer
             , ReasonName     TVarChar
             , ReturnKindName TVarChar

             , TotalSumm TFloat
             , TotalSummPartner TFloat

             , Comment TVarChar
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
                                      INNER JOIN MovementFloat AS MovementFloat_BranchCode
                                                               ON MovementFloat_BranchCode.MovementId =  Movement.Id
                                                              AND MovementFloat_BranchCode.DescId     = zc_MovementFloat_BranchCode()
                                                              AND MovementFloat_BranchCode.ValueData  = inBranchCode
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
                                      INNER JOIN MovementFloat AS MovementFloat_BranchCode
                                                               ON MovementFloat_BranchCode.MovementId =  Movement.Id
                                                              AND MovementFloat_BranchCode.DescId     = zc_MovementFloat_BranchCode()
                                                              AND MovementFloat_BranchCode.ValueData  = inBranchCode
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
              , tmpMI_Reason AS (SELECT MILinkObject_Reason.ObjectId AS ReasonId
                                 FROM tmpMovement_find
                                      LEFT JOIN MovementItem ON MovementItem.MovementId = tmpMovement_find.Id
                                                            AND MovementItem.DescId     = zc_MI_Master()
                                                            AND MovementItem.isErased   = FALSE
                                      LEFT JOIN MovementItemLinkObject AS MILinkObject_Reason
                                                                       ON MILinkObject_Reason.MovementItemId = MovementItem.Id
                                                                      AND MILinkObject_Reason.DescId         = zc_MILinkObject_Reason()
                                 WHERE MILinkObject_Reason.ObjectId > 0
                                 ORDER BY MovementItem.Id DESC
                                 LIMIT 1
                                )
         , tmpReason AS (SELECT MAX (CASE WHEN ObjectBoolean_ReturnIn.ValueData = TRUE THEN Object_Reason.Id ELSE 0 END) AS ReasonId_ReturnIn
                              , MAX (CASE WHEN ObjectBoolean_SendOnPrice.ValueData = TRUE THEN Object_Reason.Id ELSE 0 END) AS ReasonId_SendOnPrice
                         FROM Object AS Object_Reason
                              LEFT JOIN ObjectBoolean AS ObjectBoolean_ReturnIn
                                                      ON ObjectBoolean_ReturnIn.ObjectId = Object_Reason.Id
                                                     AND ObjectBoolean_ReturnIn.DescId = zc_ObjectBoolean_Reason_ReturnIn()
                              LEFT JOIN ObjectBoolean AS ObjectBoolean_SendOnPrice
                                                      ON ObjectBoolean_SendOnPrice.ObjectId = Object_Reason.Id
                                                     AND ObjectBoolean_SendOnPrice.DescId = zc_ObjectBoolean_Reason_SendOnPrice()
                         WHERE Object_Reason.DescId   = zc_Object_Reason()
                           AND Object_Reason.isErased = FALSE
                           AND (ObjectBoolean_ReturnIn.ValueData = TRUE
                             OR ObjectBoolean_SendOnPrice.ValueData = TRUE
                               )
                           AND NOT EXISTS (SELECT 1 FROM tmpMI_Reason)
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
                                                  THEN -- если zc_Movement_Sale или zc_Movement_ReturnOut, тогда определяется
                                                       lfGet_Object_Partner_PriceList_onDate_get (MovementLinkObject_Contract.ObjectId
                                                                                                , MovementLinkObject_To.ObjectId
                                                                                                , MovementFloat_MovementDesc.ValueData :: Integer
                                                                                                , NULL :: TDateTime
                                                                                                , inOperDate
                                                                                                , FALSE
                                                                                                , NULL :: TDateTime
                                                                                                 )
                                             WHEN -- если zc_Movement_Income или zc_Movement_ReturnIn, тогда определяется
                                                  MovementFloat_MovementDesc.ValueData IN (zc_Movement_ReturnIn(), zc_Movement_Income())
                                                  THEN lfGet_Object_Partner_PriceList_onDate_get (MovementLinkObject_Contract.ObjectId
                                                                                                , MovementLinkObject_From.ObjectId
                                                                                                , MovementFloat_MovementDesc.ValueData :: Integer
                                                                                                , NULL :: TDateTime
                                                                                                , inOperDate
                                                                                                , FALSE
                                                                                                , NULL :: TDateTime
                                                                                                 )

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
                                      , zfCalc_GoodsPropertyId (MovementLinkObject_Contract.ObjectId, ObjectLink_Partner_Juridical.ChildObjectId, ObjectLink_Partner_Juridical.ObjectId) AS GoodsPropertyId

                                      , MovementLinkObject_SubjectDoc.ObjectId AS SubjectDocId

                                      , MovementLinkMovement_Order.MovementChildId     AS MovementId_Order
                                      , MovementLinkMovement_Transport.MovementChildId AS MovementId_Transport

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

                                      LEFT JOIN MovementLinkObject AS MovementLinkObject_SubjectDoc
                                                                   ON MovementLinkObject_SubjectDoc.MovementId = Movement.Id
                                                                  AND MovementLinkObject_SubjectDoc.DescId     = zc_MovementLinkObject_SubjectDoc()

                                      LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Transport
                                                                     ON MovementLinkMovement_Transport.MovementId = Movement.Id
                                                                    AND MovementLinkMovement_Transport.DescId = zc_MovementLinkMovement_Transport()

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
                                                              ON MovementFloat_MovementDesc.MovementId = Movement.Id
                                                             AND MovementFloat_MovementDesc.DescId = zc_MovementFloat_MovementDesc()
                                      LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                           ON ObjectLink_Partner_Juridical.ObjectId = CASE WHEN MovementFloat_MovementDesc.ValueData IN (zc_Movement_Sale(), zc_Movement_ReturnOut())
                                                                                                                THEN MovementLinkObject_To.ObjectId
                                                                                                           ELSE MovementLinkObject_From.ObjectId
                                                                                                      END
                                                          AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                 WHERE tmpMovement_find.Id > 0
                                )
           , tmpMovementTransport AS (SELECT tmpMovement.MovementId_Transport
                                           , Movement.InvNumber
                                           , Movement.OperDate
                                           , COALESCE (MILinkObject_Route.ObjectId, MovementItem.ObjectId) AS RouteId
                                           , COALESCE (MILinkObject_Car.ObjectId, MovementLinkObject_Car.ObjectId) AS CarId
                                           , COALESCE (MovementLinkObject_PersonalDriver.ObjectId, CASE WHEN Movement.DescId = zc_Movement_Transport() THEN MovementItem.ObjectId END) AS PersonalDriverId
                                      FROM tmpMovement
                                           INNER JOIN Movement ON Movement.Id = tmpMovement.MovementId_Transport
                                                              AND Movement.StatusId <> zc_Enum_Status_Erased()
                                           LEFT JOIN MovementLinkObject AS MovementLinkObject_Route
                                                                        ON MovementLinkObject_Route.MovementId = tmpMovement.MovementId_Order
                                                                       AND MovementLinkObject_Route.DescId = zc_MovementLinkObject_Route()

                                           LEFT JOIN MovementLinkObject AS MovementLinkObject_Car
                                                                        ON MovementLinkObject_Car.MovementId = tmpMovement.MovementId_Transport
                                                                       AND MovementLinkObject_Car.DescId = zc_MovementLinkObject_Car()
                                           LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalDriver
                                                                        ON MovementLinkObject_PersonalDriver.MovementId = tmpMovement.MovementId_Transport
                                                                       AND MovementLinkObject_PersonalDriver.DescId = zc_MovementLinkObject_PersonalDriver()

                                           LEFT JOIN MovementItem ON MovementItem.MovementId = tmpMovement.MovementId_Transport
                                                                 AND MovementItem.DescId     = zc_MI_Master()
                                                                 AND MovementItem.isErased   = FALSE
                                                                 AND (MovementItem.ObjectId  = MovementLinkObject_Route.ObjectId OR Movement.DescId = zc_Movement_TransportService() OR tmpMovement.MovementId_Order IS NULL)
                                           LEFT JOIN MovementItemLinkObject AS MILinkObject_Route
                                                                            ON MILinkObject_Route.MovementItemId = MovementItem.Id
                                                                           AND MILinkObject_Route.DescId = zc_MILinkObject_Route()
                                                                           AND (MILinkObject_Route.ObjectId = MovementLinkObject_Route.ObjectId OR tmpMovement.MovementId_Order IS NULL)
                                                                           AND Movement.DescId = zc_Movement_TransportService()
                                           LEFT JOIN MovementItemLinkObject AS MILinkObject_Car
                                                                            ON MILinkObject_Car.MovementItemId = MovementItem.Id
                                                                           AND MILinkObject_Car.DescId = zc_MILinkObject_Car()
                                                                           AND Movement.DescId = zc_Movement_TransportService()
                                      LIMIT 1
                                     )

           , tmpJuridicalPrint AS (SELECT tmp.Id AS JuridicalId
                                        , tmp.isMovement, tmp.CountMovement
                                        , tmp.isAccount, tmp.CountAccount
                                        , tmp.isTransport, tmp.CountTransport
                                        , tmp.isQuality, tmp.CountQuality
                                        , tmp.isPack, tmp.CountPack
                                        , tmp.isSpec, tmp.CountSpec
                                        , tmp.isTax, tmp.CountTax
                                   FROM lpGet_Object_Juridical_PrintKindItem ((SELECT tmpMovement.JuridicalId FROM tmpMovement LIMIT 1)) AS tmp
                                  )
       -- Результат
       SELECT tmpMovement.Id                                 AS MovementId
            , '' ::TVarChar                                  AS BarCode
            , tmpMovement.InvNumber                          AS InvNumber
            , MovementString_InvNumberPartner.ValueData      AS InvNumberPartner
            , tmpMovement.OperDate                           AS OperDate

            , MovementFloat_MovementDescNumber.ValueData :: Integer AS MovementDescNumber

            , tmpMovement.MovementDescId :: Integer          AS MovementDescId
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
            , (SELECT tmp.ChangePercentAmount FROM gpGet_Scale_Partner (inOperDate       := inOperDate
                                                                      , inMovementDescId := tmpMovement.MovementDescId :: Integer
                                                                      , inPartnerCode    := -1 * Object_Partner.Id
                                                                      , inInfoMoneyId    := View_Contract_InvNumber.InfoMoneyId
                                                                      , inPaidKindId     := Object_PaidKind.Id
                                                                      , inSession        := inSession
                                                                       ) AS tmp
               WHERE COALESCE (tmp.ContractId, 0) = COALESCE (View_Contract_InvNumber.ContractId, 0)
                  OR tmpMovement.MovementDescId = zc_Movement_Send()
              ) AS ChangePercentAmount

            , COALESCE (ObjectBoolean_Partner_EdiOrdspr.ValueData, FALSE)  :: Boolean AS isEdiOrdspr
            , COALESCE (ObjectBoolean_Partner_EdiInvoice.ValueData, FALSE) :: Boolean AS isEdiInvoice
            , COALESCE (ObjectBoolean_Partner_EdiDesadv.ValueData, FALSE)  :: Boolean AS isEdiDesadv

            , CASE WHEN tmpJuridicalPrint.isPack = TRUE OR tmpJuridicalPrint.isSpec = TRUE THEN COALESCE (tmpJuridicalPrint.isMovement, FALSE) ELSE TRUE END :: Boolean AS isMovement
            , CASE WHEN tmpJuridicalPrint.CountMovement > 0 THEN tmpJuridicalPrint.CountMovement ELSE 2 END :: TFloat AS CountMovement
            , COALESCE (tmpJuridicalPrint.isAccount,   FALSE) :: Boolean AS isAccount,   COALESCE (tmpJuridicalPrint.CountAccount, 0)   :: TFloat AS CountAccount
            , CASE WHEN Object_PaidKind.Id = zc_Enum_PaidKind_FirstForm() THEN TRUE ELSE COALESCE (tmpJuridicalPrint.isTransport, FALSE) END  :: Boolean AS isTransport
            , CASE WHEN Object_PaidKind.Id = zc_Enum_PaidKind_FirstForm() THEN 1    ELSE COALESCE (tmpJuridicalPrint.CountTransport, 0)  END  :: TFloat  AS CountTransport
            , COALESCE (tmpJuridicalPrint.isQuality,   FALSE) :: Boolean AS isQuality  , COALESCE (tmpJuridicalPrint.CountQuality, 0)   :: TFloat AS CountQuality
            , COALESCE (tmpJuridicalPrint.isPack,      FALSE) :: Boolean AS isPack     , COALESCE (tmpJuridicalPrint.CountPack, 0)      :: TFloat AS CountPack
            , COALESCE (tmpJuridicalPrint.isSpec,      FALSE) :: Boolean AS isSpec     , COALESCE (tmpJuridicalPrint.CountSpec, 0)      :: TFloat AS CountSpec
            , COALESCE (tmpJuridicalPrint.isTax,       FALSE) :: Boolean AS isTax      , COALESCE (tmpJuridicalPrint.CountTax, 0)       :: TFloat AS CountTax

            , EXISTS (SELECT 1
                      FROM Movement
                           INNER JOIN MovementLinkObject AS MLO_Contract
                                                         ON MLO_Contract.MovementId = Movement.Id
                                                        AND MLO_Contract.DescId     = zc_MovementLinkObject_Contract()
                                                        AND MLO_Contract.ObjectId   = View_Contract_InvNumber.ContractId
                      WHERE Movement.DescId    = zc_Movement_ContractGoods()
                        AND Movement.StatusId  = zc_Enum_Status_Complete()
                     ) :: Boolean AS isContractGoods

              -- определили <Asset>
            , (SELECT CASE WHEN TRIM (tmp.RetV) ILIKE 'TRUE' THEN TRUE ELSE FALSE END :: Boolean
               FROM (SELECT gpGet_ToolsWeighing_Value (inLevel1      := 'Scale_' || inBranchCode
                                                     , inLevel2      := 'Movement'
                                                     , inLevel3      := 'MovementDesc_' || CASE WHEN MovementFloat_MovementDescNumber.ValueData < 10 THEN '0' ELSE '' END || (MovementFloat_MovementDescNumber.ValueData :: Integer) :: TVarChar
                                                     , inItemName    := 'isAsset'
                                                     , inDefaultValue:= 'FALSE'
                                                     , inSession     := inSession
                                                      ) AS RetV
                    ) AS tmp
              ) :: Boolean AS isAsset

            , tmpMovement.MovementId_Order AS MovementId_Order
            , Movement_Order.DescId        AS MovementDescId_Order
            , Movement_Order.InvNumber     AS InvNumber_Order
            , ('№ <' || Movement_Order.InvNumber || '>' || ' от <' || DATE (Movement_Order.OperDate) :: TVarChar || '>' || ' '|| COALESCE (Object_Personal.ValueData, '')) :: TVarChar AS OrderExternalName_master

            , tmpMovement.MovementId_Transport
            , zfFormat_BarCode (zc_BarCodePref_Movement(), tmpMovement.MovementId_Transport) AS Transport_BarCode
            , ('№ <' || tmpMovementTransport.InvNumber || '>' || ' от <' || DATE (tmpMovementTransport.OperDate) :: TVarChar || '>') :: TVarChar AS Transport_InvNumber
            , Object_PersonalDriver.Id        AS PersonalDriverId
            , Object_PersonalDriver.ValueData AS PersonalDriverName
            , (COALESCE (Object_Car.ValueData, '')  || ' ' || COALESCE (Object_CarModel.ValueData, '') || COALESCE (' ' || Object_CarType.ValueData, '')) :: TVarChar AS CarName  

            , Object_Route.ValueData          AS RouteName

            , Object_SubjectDoc.Id            AS SubjectDocId
            , Object_SubjectDoc.ObjectCode    AS SubjectDocCode
            , Object_SubjectDoc.ValueData     AS SubjectDocName

            , Object_Reason.Id                AS ReasonId
            , Object_Reason.ObjectCode        AS ReasonCode
            , Object_Reason.ValueData         AS ReasonName
            , Object_ReturnKind.ValueData     AS ReturnKindName

            , MovementFloat_TotalSumm.ValueData AS TotalSumm
            , 0                       :: TFloat AS TotalSummPartner

            , MovementString_Comment.ValueData AS Comment

       FROM tmpMovement
            LEFT JOIN tmpMovementTransport ON tmpMovementTransport.MovementId_Transport = tmpMovement.MovementId_Transport
            LEFT JOIN tmpJuridicalPrint ON tmpJuridicalPrint.JuridicalId = tmpMovement.JuridicalId

            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId = tmpMovement.Id
                                    AND MovementString_InvNumberPartner.DescId     = zc_MovementString_InvNumberPartner()

            LEFT JOIN Movement AS Movement_Order ON Movement_Order.Id = tmpMovement.MovementId_Order
            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Order
                                           ON MovementLinkMovement_Order.MovementId = tmpMovement.MovementId_Order
                                          AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()

            LEFT JOIN Object AS Object_PersonalDriver ON Object_PersonalDriver.Id = tmpMovementTransport.PersonalDriverId
            LEFT JOIN Object AS Object_Car ON Object_Car.Id = tmpMovementTransport.CarId

            LEFT JOIN ObjectLink AS ObjectLink_Car_CarModel ON ObjectLink_Car_CarModel.ObjectId = Object_Car.Id
                                                           AND ObjectLink_Car_CarModel.DescId = zc_ObjectLink_Car_CarModel()
            LEFT JOIN Object AS Object_CarModel ON Object_CarModel.Id = ObjectLink_Car_CarModel.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Car_CarType
                                 ON ObjectLink_Car_CarType.ObjectId = Object_Car.Id
                                AND ObjectLink_Car_CarType.DescId = zc_ObjectLink_Car_CarType()
            LEFT JOIN Object AS Object_CarType ON Object_CarType.Id = ObjectLink_Car_CarType.ChildObjectId

            LEFT JOIN Object AS Object_Route ON Object_Route.Id = tmpMovementTransport.RouteId

            LEFT JOIN Object AS Object_SubjectDoc ON Object_SubjectDoc.Id = tmpMovement.SubjectDocId

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

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId =  tmpMovement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN tmpMI_Reason ON tmpMovement.MovementDescId IN (zc_Movement_ReturnIn(), zc_Movement_SendOnPrice())
            LEFT JOIN tmpReason ON tmpMovement.MovementDescId IN (zc_Movement_ReturnIn(), zc_Movement_SendOnPrice())
            LEFT JOIN Object AS Object_Reason ON Object_Reason.Id = CASE WHEN tmpMI_Reason.ReasonId > 0 THEN tmpMI_Reason.ReasonId
                                                                         WHEN tmpMovement.MovementDescId = zc_Movement_ReturnIn() THEN tmpReason.ReasonId_ReturnIn
                                                                         WHEN tmpMovement.MovementDescId = zc_Movement_SendOnPrice() THEN tmpReason.ReasonId_SendOnPrice
                                                                         ELSE 0 
                                                                    END
            LEFT JOIN ObjectLink AS ObjectLink_ReturnKind
                                 ON ObjectLink_ReturnKind.ObjectId = Object_Reason.Id
                                AND ObjectLink_ReturnKind.DescId   = zc_ObjectLink_Reason_ReturnKind()
            LEFT JOIN Object AS Object_ReturnKind ON Object_ReturnKind.Id = ObjectLink_ReturnKind.ChildObjectId
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
-- SELECT * FROM gpGet_Scale_Movement (20258087, CURRENT_TIMESTAMP, TRUE,  1, zfCalc_UserAdmin())
-- SELECT * FROM gpGet_Scale_Movement (0, CURRENT_TIMESTAMP, FALSE, 1, zfCalc_UserAdmin())
