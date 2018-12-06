-- Function: gpGet_Scale_OrderExternal()

DROP FUNCTION IF EXISTS gpGet_Scale_OrderExternal (TDateTime, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Scale_OrderExternal(
    IN inOperDate       TDateTime   ,
    IN inBranchCode     Integer   , --
    IN inBarCode        TVarChar    ,
    IN inSession        TVarChar      -- сессия пользователя
)
RETURNS TABLE (MovementId            Integer
             , MovementDescId_order  Integer
             , MovementId_get        Integer -- документ взвешивания !!!только для заявки!!!, потом переносится в MovementId
             , BarCode               TVarChar
             , InvNumber             TVarChar
             , InvNumberPartner      TVarChar

             , MovementDescNumber Integer -- !!!только для zc_Movement_SendOnPrice!!!
             , MovementDescId     Integer -- !!!расчет для будущего документа!!!
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

             , isMovement    Boolean, CountMovement   TFloat   -- Накладная
             , isAccount     Boolean, CountAccount    TFloat   -- Счет
             , isTransport   Boolean, CountTransport  TFloat   -- ТТН
             , isQuality     Boolean, CountQuality    TFloat   -- Качественное
             , isPack        Boolean, CountPack       TFloat   -- Упаковочный
             , isSpec        Boolean, CountSpec       TFloat   -- Спецификация
             , isTax         Boolean, CountTax        TFloat   -- Налоговая

             , OrderExternalName_master TVarChar
              )
AS
$BODY$
   DECLARE vbUserId     Integer;

   DECLARE vbBranchId   Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpGetUserBySession (inSession);


    -- Проверка
    IF (vbBranchId :: Integer) > 1000
    THEN
        RAISE EXCEPTION 'Ошибка.Для печати этикетки сканировать нельзя.';
    END IF;

    -- определяется
    vbBranchId:= CASE WHEN inBranchCode > 100 THEN zc_Branch_Basis()
                      ELSE (SELECT Object.Id FROM Object WHERE Object.ObjectCode = inBranchCode and Object.DescId = zc_Object_Branch())
                 END;

    -- Результат
    RETURN QUERY
       WITH tmpMovement AS (SELECT tmpMovement.Id
                                 , tmpMovement.InvNumber
                                 , tmpMovement.DescId
                                 , tmpMovement.OperDate
                                 , MovementLinkObject_Contract.ObjectId       AS ContractId
                                 , CASE WHEN tmpMovement.DescId = zc_Movement_OrderIncome()
                                             THEN MovementLinkObject_Unit.ObjectId
                                        ELSE MovementLinkObject_From.ObjectId
                                   END AS FromId
                                 , CASE WHEN tmpMovement.DescId = zc_Movement_OrderIncome()
                                             THEN (SELECT OL.ObjectId
                                                   FROM MovementLinkObject AS MLO
                                                        INNER JOIN ObjectLink AS OL ON OL.ChildObjectId = MLO.ObjectId AND OL.DescId = zc_ObjectLink_Partner_Juridical()
                                                        INNER JOIN Object ON Object.Id = OL.ObjectId AND Object.isErased = FALSE
                                                   WHERE MLO.MovementId = tmpMovement.Id
                                                     AND MLO.DescId     = zc_MovementLinkObject_Juridical()
                                                   LIMIT 1)
                                        WHEN MovementLinkObject_From.ObjectId = MovementLinkObject_To.ObjectId
                                         AND inBranchCode BETWEEN 301 AND 310
                                         AND tmpMovement.DescId = zc_Movement_OrderInternal()
                                             THEN 8455 -- Склад специй
                                        ELSE MovementLinkObject_To.ObjectId
                                   END AS ToId
                                 , ObjectLink_Partner_Juridical.ChildObjectId AS JuridicalId
                                 , zfCalc_GoodsPropertyId (MovementLinkObject_Contract.ObjectId, ObjectLink_Partner_Juridical.ChildObjectId, ObjectLink_Partner_Juridical.ObjectId) AS GoodsPropertyId
                                   -- вот таким сложным CASE определяется приход или расход
                                 , CASE WHEN ObjectLink_UnitFrom_Branch.ChildObjectId = vbBranchId
                                             THEN NULL -- FALSE -- для филиала - расход с него !!!блокируется!!!
                                        WHEN ObjectLink_UnitTo_Branch.ChildObjectId = vbBranchId
                                             THEN TRUE -- для филиала - приход на него
                                        WHEN ObjectLink_UnitTo_Branch.ChildObjectId > 0
                                             THEN NULL -- FALSE -- для главного - расход с него !!!блокируется!!!
                                        WHEN ObjectLink_UnitFrom_Branch.ChildObjectId > 0
                                             THEN TRUE -- для главного - приход на него
                                   END AS isSendOnPriceIn
                            FROM (-- по Ш/К
                                  SELECT Movement.Id
                                       , Movement.InvNumber
                                       , Movement.DescId
                                       , Movement.OperDate
                                  FROM (SELECT zfConvert_StringToNumber (SUBSTR (inBarCode, 4, 13-4)) AS MovementId WHERE CHAR_LENGTH (inBarCode) >= 13
                                       ) AS tmp
                                       INNER JOIN Movement ON Movement.Id = tmp.MovementId
                                                          AND Movement.DescId IN (zc_Movement_OrderExternal(), zc_Movement_OrderInternal(), zc_Movement_SendOnPrice())
                                                          AND Movement.OperDate BETWEEN inOperDate - INTERVAL '18 DAY' AND inOperDate + INTERVAL '8 DAY'
                                                          AND Movement.StatusId <> zc_Enum_Status_Erased()
                                 UNION
                                  -- по Ш/К - Приход, т.к. период 80 дней
                                  SELECT Movement.Id
                                       , Movement.InvNumber
                                       , Movement.DescId
                                       , Movement.OperDate
                                  FROM (SELECT zfConvert_StringToNumber (SUBSTR (inBarCode, 4, 13-4)) AS MovementId WHERE CHAR_LENGTH (inBarCode) >= 13
                                                                                                                      AND inBranchCode BETWEEN 301 AND 310
                                       ) AS tmp
                                       INNER JOIN Movement ON Movement.Id = tmp.MovementId
                                                          AND Movement.DescId = zc_Movement_OrderIncome()
                                                          AND Movement.OperDate BETWEEN inOperDate - INTERVAL '80 DAY' AND inOperDate + INTERVAL '80 DAY'
                                                          AND Movement.StatusId <> zc_Enum_Status_Erased()
                                 UNION
                                  -- по № документа
                                  SELECT Movement.Id
                                       , Movement.InvNumber
                                       , Movement.DescId
                                       , Movement.OperDate
                                  FROM (SELECT inBarCode AS BarCode WHERE CHAR_LENGTH (inBarCode) > 0 AND CHAR_LENGTH (inBarCode) < 13
                                       ) AS tmp
                                       INNER JOIN Movement ON Movement.InvNumber = tmp.BarCode
                                                          AND Movement.DescId IN (zc_Movement_OrderExternal(), zc_Movement_OrderInternal(), zc_Movement_SendOnPrice())
                                                          AND Movement.OperDate BETWEEN inOperDate - INTERVAL '18 DAY' AND inOperDate + INTERVAL '8 DAY'
                                                          AND Movement.StatusId <> zc_Enum_Status_Erased()
                                 UNION
                                  -- по № документа - Приход, т.к. период 80 дней
                                  SELECT Movement.Id
                                       , Movement.InvNumber
                                       , Movement.DescId
                                       , Movement.OperDate
                                  FROM (SELECT inBarCode AS BarCode WHERE CHAR_LENGTH (inBarCode) > 0 AND CHAR_LENGTH (inBarCode) < 13
                                                                      AND inBranchCode BETWEEN 301 AND 310
                                       ) AS tmp
                                       INNER JOIN Movement ON Movement.InvNumber = tmp.BarCode
                                                          AND Movement.DescId = zc_Movement_OrderIncome()
                                                          AND Movement.OperDate BETWEEN inOperDate - INTERVAL '80 DAY' AND inOperDate + INTERVAL '80 DAY'
                                                          AND Movement.StatusId <> zc_Enum_Status_Erased()
                                 ) AS tmpMovement
                                 LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                              ON MovementLinkObject_Contract.MovementId = tmpMovement.Id
                                                             AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                 LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                                              ON MovementLinkObject_Partner.MovementId = tmpMovement.Id
                                                             AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
                                 LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                              ON MovementLinkObject_From.MovementId = tmpMovement.Id
                                                             AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                 LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                              ON MovementLinkObject_Unit.MovementId = tmpMovement.Id
                                                             AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                             
                                 LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                              ON MovementLinkObject_To.MovementId = tmpMovement.Id
                                                             AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                 LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                      ON ObjectLink_Partner_Juridical.ObjectId = COALESCE (MovementLinkObject_Partner.ObjectId, MovementLinkObject_From.ObjectId)
                                                     AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                 LEFT JOIN ObjectLink AS ObjectLink_UnitFrom_Branch
                                                      ON ObjectLink_UnitFrom_Branch.ObjectId = MovementLinkObject_From.ObjectId
                                                     AND ObjectLink_UnitFrom_Branch.DescId = zc_ObjectLink_Unit_Branch()
                                 LEFT JOIN ObjectLink AS ObjectLink_UnitTo_Branch
                                                      ON ObjectLink_UnitTo_Branch.ObjectId = MovementLinkObject_To.ObjectId
                                                     AND ObjectLink_UnitTo_Branch.DescId = zc_ObjectLink_Unit_Branch()
                           )
           , tmpMovement_find AS (SELECT tmpMovement.Id
                                       , MovementLinkMovement_Order.MovementId AS MovementId_get
                                  FROM tmpMovement
                                       INNER JOIN MovementLinkMovement AS MovementLinkMovement_Order
                                                                       ON MovementLinkMovement_Order.MovementChildId = tmpMovement.Id
                                                                      AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
                                       INNER JOIN Movement ON Movement.Id = MovementLinkMovement_Order.MovementId
                                                          AND Movement.DescId = zc_Movement_WeighingPartner()
                                                          AND Movement.StatusId = zc_Enum_Status_UnComplete()
                                       INNER JOIN MovementLinkObject
                                               AS MovementLinkObject_User
                                               ON MovementLinkObject_User.MovementId = Movement.Id
                                              AND MovementLinkObject_User.DescId = zc_MovementLinkObject_User()
                                              AND MovementLinkObject_User.ObjectId = vbUserId
                                              -- AND vbUserId <> 5
                                 )
           , tmpJuridicalPrint AS (SELECT tmpGet.Id AS JuridicalId
                                        , tmpGet.isMovement, tmpGet.CountMovement
                                        , tmpGet.isAccount, tmpGet.CountAccount
                                        , tmpGet.isTransport, tmpGet.CountTransport
                                        , tmpGet.isQuality, tmpGet.CountQuality
                                        , tmpGet.isPack, tmpGet.CountPack
                                        , tmpGet.isSpec, tmpGet.CountSpec
                                        , tmpGet.isTax, tmpGet.CountTax
                                   FROM (SELECT tmpMovement.JuridicalId FROM tmpMovement WHERE tmpMovement.DescId = zc_Movement_OrderExternal() LIMIT 1) AS tmp
                                        INNER JOIN lpGet_Object_Juridical_PrintKindItem ((SELECT tmpMovement.JuridicalId FROM tmpMovement LIMIT 1)) AS tmpGet ON tmpGet.Id = tmp.JuridicalId
                                  )
      , tmpMovementDescNumber AS (SELECT tmpSelect.Number AS MovementDescNumber
                                       , tmp.MovementId
                                  FROM (SELECT CASE WHEN tmpMovement.DescId = zc_Movement_OrderIncome()
                                                         THEN zc_Movement_Income()
                                                    WHEN tmpMovement.DescId = zc_Movement_OrderInternal()
                                                         THEN zc_Movement_Send()
                                                    WHEN Object_From.DescId = zc_Object_ArticleLoss()
                                                         THEN zc_Movement_Loss()
                                                    WHEN Object_From.DescId = zc_Object_Unit()
                                                         THEN zc_Movement_SendOnPrice()
                                                    ELSE tmpMovement.DescId
                                               END AS MovementDescId
                                             , tmpMovement.DescId AS MovementDescId_original
                                             , tmpMovement.FromId
                                             , tmpMovement.ToId
                                             , tmpMovement.isSendOnPriceIn
                                             , tmpMovement.Id AS MovementId
                                        FROM tmpMovement
                                             LEFT JOIN Object AS Object_From ON Object_From.Id = tmpMovement.FromId
                                        WHERE tmpMovement.DescId = zc_Movement_OrderIncome()
                                           OR tmpMovement.DescId = zc_Movement_SendOnPrice()
                                           OR Object_From.DescId = zc_Object_ArticleLoss()
                                           OR Object_From.DescId = zc_Object_Unit()
                                       ) AS tmp
                                       INNER JOIN gpSelect_Object_ToolsWeighing_MovementDesc (inBranchCode:= inBranchCode
                                                                                            , inSession   := inSession
                                                                                             ) AS tmpSelect ON tmpSelect.MovementDescId = tmp.MovementDescId
                                                                                                           AND tmpSelect.FromId = CASE WHEN tmp.MovementDescId = zc_Movement_Income()
                                                                                                                                            THEN 0 -- для Прихода от поставщика
                                                                                                                                       WHEN tmp.MovementDescId = zc_Movement_Send()
                                                                                                                                            THEN tmp.ToId -- для Перемещения
                                                                                                                                       WHEN tmp.MovementDescId = zc_Movement_Loss()
                                                                                                                                            THEN tmp.ToId -- для списания
                                                                                                                                       WHEN tmp.MovementDescId = zc_Movement_SendOnPrice() AND tmp.MovementDescId_original = zc_Movement_OrderExternal()
                                                                                                                                            THEN tmp.ToId -- для SendOnPrice по заявке

                                                                                                                                       WHEN vbBranchId = zc_Branch_Basis() AND tmp.isSendOnPriceIn = FALSE
                                                                                                                                            THEN tmp.FromId -- для главного - расход с него
                                                                                                                                       WHEN vbBranchId = zc_Branch_Basis() AND tmp.isSendOnPriceIn = TRUE
                                                                                                                                            THEN 0 -- для главного - приход на него, а здесь 0 т.к. он выбирается из справочника
                                                                                                                                       WHEN tmp.isSendOnPriceIn = TRUE
                                                                                                                                            THEN tmp.FromId -- для филиала - приход на него, а здесь FromId т.к. не выбирается
                                                                                                                                       WHEN tmp.isSendOnPriceIn = FALSE
                                                                                                                                            THEN tmp.FromId -- для для филиала - расход с него
                                                                                                                                  END
                                                                                                           AND tmpSelect.ToId   = CASE WHEN tmp.MovementDescId = zc_Movement_Income()
                                                                                                                                            THEN tmp.FromId -- для Прихода от поставщика
                                                                                                                                       WHEN tmp.MovementDescId = zc_Movement_Send()
                                                                                                                                            THEN tmp.FromId -- для Перемещения
                                                                                                                                       WHEN tmp.MovementDescId = zc_Movement_Loss()
                                                                                                                                            THEN 0 -- для списания здесь 0 т.к. он выбирается из справочника
                                                                                                                                       WHEN tmp.MovementDescId = zc_Movement_SendOnPrice() AND tmp.MovementDescId_original = zc_Movement_OrderExternal()
                                                                                                                                            THEN 0 -- для SendOnPrice по заявке

                                                                                                                                       WHEN vbBranchId = zc_Branch_Basis() AND tmp.isSendOnPriceIn = FALSE
                                                                                                                                            THEN 0 -- для главного - расход с него, а здесь 0 т.к. он выбирается из справочника
                                                                                                                                       WHEN vbBranchId = zc_Branch_Basis() AND tmp.isSendOnPriceIn = TRUE
                                                                                                                                            THEN tmp.ToId -- для главного - приход на него
                                                                                                                                       WHEN tmp.isSendOnPriceIn = TRUE
                                                                                                                                            THEN tmp.ToId -- для филиала - приход на него
                                                                                                                                       WHEN tmp.isSendOnPriceIn = FALSE
                                                                                                                                            THEN tmp.ToId -- для для филиала - расход с него, а здесь ToId т.к. не выбирается
                                                                                                                                  END
                                                                                                           AND COALESCE (tmpSelect.PaidKindId, 0) = CASE WHEN tmp.MovementDescId = zc_Movement_Income()
                                                                                                                                                              THEN (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = tmp.MovementId AND MLO.DescId = zc_MovementLinkObject_PaidKind())
                                                                                                                                                         ELSE COALESCE (tmpSelect.PaidKindId, 0)
                                                                                                                                                    END
                                 )
       SELECT tmpMovement.Id                                 AS MovementId
            , tmpMovement.DescId                             AS MovementDescId_order
            , tmpMovement_find.MovementId_get                AS MovementId_get
            , inBarCode                                      AS BarCode
            , tmpMovement.InvNumber                          AS InvNumber
            , MovementString_InvNumberPartner.ValueData      AS InvNumberPartner

            , tmpMovementDescNumber.MovementDescNumber       AS MovementDescNumber -- !!!только для zc_Movement_SendOnPrice!!!
            , CASE WHEN tmpMovement.DescId = zc_Movement_OrderIncome()
                        THEN zc_Movement_Income()
                   WHEN tmpMovement.DescId = zc_Movement_OrderInternal()
                        THEN  zc_Movement_Send()
                   WHEN Object_From.DescId = zc_Object_ArticleLoss()
                        THEN zc_Movement_Loss()
                   WHEN Object_From.DescId = zc_Object_Unit()
                        THEN zc_Movement_SendOnPrice()
                   WHEN tmpMovement.DescId = zc_Movement_OrderExternal()
                        THEN zc_Movement_Sale()
                   ELSE tmpMovement.DescId
              END AS MovementDescId
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

            , CASE WHEN tmpMovement.DescId = zc_Movement_OrderIncome()
                        THEN Object_To.Id
                   WHEN tmpMovement.DescId = zc_Movement_OrderExternal()
                        THEN Object_From.Id
                   WHEN tmpMovement.DescId = zc_Movement_SendOnPrice() AND tmpMovement.isSendOnPriceIn = TRUE
                        THEN Object_From.Id
                   WHEN tmpMovement.DescId = zc_Movement_SendOnPrice() AND tmpMovement.isSendOnPriceIn = FALSE
                        THEN Object_To.Id
              END :: Integer AS PartnerId_calc
            , CASE WHEN tmpMovement.DescId = zc_Movement_OrderIncome()
                        THEN Object_To.ObjectCode
                   WHEN tmpMovement.DescId = zc_Movement_OrderExternal()
                        THEN Object_From.ObjectCode
                   WHEN tmpMovement.DescId = zc_Movement_SendOnPrice() AND tmpMovement.isSendOnPriceIn = TRUE
                        THEN Object_From.ObjectCode
                   WHEN tmpMovement.DescId = zc_Movement_SendOnPrice() AND tmpMovement.isSendOnPriceIn = FALSE
                        THEN Object_To.ObjectCode
              END :: Integer AS PartnerCode_calc
            , CASE WHEN tmpMovement.DescId = zc_Movement_OrderIncome()
                        THEN Object_To.ValueData
                   WHEN tmpMovement.DescId = zc_Movement_OrderExternal()
                        THEN Object_From.ValueData
                   WHEN tmpMovement.DescId = zc_Movement_SendOnPrice() AND tmpMovement.isSendOnPriceIn = TRUE
                        THEN Object_From.ValueData
                   WHEN tmpMovement.DescId = zc_Movement_SendOnPrice() AND tmpMovement.isSendOnPriceIn = FALSE
                        THEN Object_To.ValueData
              END :: TVarChar AS PartnerName_calc

            , MovementFloat_ChangePercent.ValueData AS ChangePercent
            , (SELECT tmp.ChangePercentAmount FROM gpGet_Scale_Partner (inOperDate       := inOperDate
                                                                      , inMovementDescId := CASE WHEN Object_From.DescId = zc_Object_ArticleLoss()
                                                                                                      THEN zc_Movement_Loss()
                                                                                                 WHEN Object_From.DescId = zc_Object_Unit() AND tmpMovement.DescId = zc_Movement_OrderExternal()
                                                                                                      THEN zc_Movement_SendOnPrice()
                                                                                                 WHEN tmpMovement.DescId = zc_Movement_OrderExternal()
                                                                                                      THEN zc_Movement_Sale()
                                                                                                 ELSE tmpMovement.DescId
                                                                                            END
                                                                      , inPartnerCode    := -1 * Object_From.Id
                                                                      , inInfoMoneyId    := COALESCE (View_Contract_InvNumber.InfoMoneyId, zc_Enum_InfoMoney_30101())
                                                                      , inPaidKindId     := Object_PaidKind.Id
                                                                      , inSession        := inSession
                                                                       ) AS tmp
               WHERE COALESCE (tmp.ContractId, 0) = COALESCE (View_Contract_InvNumber.ContractId, 0)
                  OR Object_From.DescId = zc_Object_Unit()
              ) AS ChangePercentAmount

            , COALESCE (ObjectBoolean_Partner_EdiOrdspr.ValueData, FALSE)  :: Boolean AS isEdiOrdspr
            , COALESCE (ObjectBoolean_Partner_EdiInvoice.ValueData, FALSE) :: Boolean AS isEdiInvoice
            , COALESCE (ObjectBoolean_Partner_EdiDesadv.ValueData, FALSE)  :: Boolean AS isEdiDesadv

            , CASE WHEN tmpJuridicalPrint.isPack = TRUE OR tmpJuridicalPrint.isSpec = TRUE THEN COALESCE (tmpJuridicalPrint.isMovement, FALSE) ELSE TRUE END :: Boolean AS isMovement
            , CASE WHEN tmpJuridicalPrint.CountMovement > 0 THEN tmpJuridicalPrint.CountMovement ELSE 2 END :: TFloat AS CountMovement
            , COALESCE (tmpJuridicalPrint.isAccount,   FALSE) :: Boolean AS isAccount,   COALESCE (tmpJuridicalPrint.CountAccount, 0)   :: TFloat AS CountAccount
            , COALESCE (tmpJuridicalPrint.isTransport, FALSE) :: Boolean AS isTransport, COALESCE (tmpJuridicalPrint.CountTransport, 0) :: TFloat AS CountTransport
            , COALESCE (tmpJuridicalPrint.isQuality,   FALSE) :: Boolean AS isQuality  , COALESCE (tmpJuridicalPrint.CountQuality, 0)   :: TFloat AS CountQuality
            , COALESCE (tmpJuridicalPrint.isPack,      FALSE) :: Boolean AS isPack     , COALESCE (tmpJuridicalPrint.CountPack, 0)      :: TFloat AS CountPack
            , COALESCE (tmpJuridicalPrint.isSpec,      FALSE) :: Boolean AS isSpec     , COALESCE (tmpJuridicalPrint.CountSpec, 0)      :: TFloat AS CountSpec
            , COALESCE (tmpJuridicalPrint.isTax,       FALSE) :: Boolean AS isTax      , COALESCE (tmpJuridicalPrint.CountTax, 0)       :: TFloat AS CountTax

            , ('№ <' || tmpMovement.InvNumber || '>' || ' от <' || DATE (tmpMovement.OperDate) :: TVarChar || '>' || ' '|| COALESCE (Object_Personal.ValueData, '')) :: TVarChar AS OrderExternalName_master

       FROM tmpMovement
            LEFT JOIN tmpMovement_find ON tmpMovement_find.Id = tmpMovement.Id
            LEFT JOIN tmpMovementDescNumber ON tmpMovementDescNumber.MovementDescNumber > 0
            LEFT JOIN tmpJuridicalPrint ON tmpJuridicalPrint.JuridicalId = tmpMovement.JuridicalId

            LEFT JOIN Object AS Object_From ON Object_From.Id = tmpMovement.FromId
            /*LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = tmpMovement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()*/
            LEFT JOIN Object AS Object_To ON Object_To.Id = tmpMovement.ToId -- MovementLinkObject_To.ObjectId

            LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = tmpMovement.ContractId
            LEFT JOIN Object AS Object_GoodsProperty ON Object_GoodsProperty.Id = tmpMovement.GoodsPropertyId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                         ON MovementLinkObject_PaidKind.MovementId = tmpMovement.Id
                                        AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
                                        AND tmpMovement.DescId IN (zc_Movement_OrderExternal(), zc_Movement_OrderIncome())
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                         ON MovementLinkObject_Juridical.MovementId = tmpMovement.Id
                                        AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
                                        AND tmpMovement.DescId = zc_Movement_OrderIncome()
            LEFT JOIN ObjectLink AS ObjectLink_Juridical_PriceList
                                 ON ObjectLink_Juridical_PriceList.ObjectId = MovementLinkObject_Juridical.ObjectId 
                                AND ObjectLink_Juridical_PriceList.DescId = zc_ObjectLink_Juridical_PriceList()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PriceList
                                         ON MovementLinkObject_PriceList.MovementId = tmpMovement.Id
                                        AND MovementLinkObject_PriceList.DescId = zc_MovementLinkObject_PriceList()
            LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = COALESCE (ObjectLink_Juridical_PriceList.ChildObjectId, CASE WHEN tmpMovement.DescId = zc_Movement_OrderIncome() THEN zc_PriceList_Basis() ELSE MovementLinkObject_PriceList.ObjectId END)

            LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                    ON MovementFloat_ChangePercent.MovementId =  tmpMovement.Id
                                   AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId =  tmpMovement.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Order
                                           ON MovementLinkMovement_Order.MovementId = tmpMovement.Id
                                          AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()

            LEFT JOIN ObjectBoolean AS ObjectBoolean_Partner_EdiOrdspr
                                    ON ObjectBoolean_Partner_EdiOrdspr.ObjectId =  tmpMovement.FromId
                                   AND ObjectBoolean_Partner_EdiOrdspr.DescId = zc_ObjectBoolean_Partner_EdiOrdspr()
                                   AND MovementLinkMovement_Order.MovementChildId > 0 -- проверка по связи заявки с EDI
            LEFT JOIN ObjectBoolean AS ObjectBoolean_Partner_EdiInvoice
                                    ON ObjectBoolean_Partner_EdiInvoice.ObjectId =  tmpMovement.FromId
                                   AND ObjectBoolean_Partner_EdiInvoice.DescId = zc_ObjectBoolean_Partner_EdiInvoice()
                                   AND MovementLinkMovement_Order.MovementChildId > 0 -- проверка по связи заявки с EDI
            LEFT JOIN ObjectBoolean AS ObjectBoolean_Partner_EdiDesadv
                                    ON ObjectBoolean_Partner_EdiDesadv.ObjectId =  tmpMovement.FromId
                                   AND ObjectBoolean_Partner_EdiDesadv.DescId = zc_ObjectBoolean_Partner_EdiDesadv()
                                   AND MovementLinkMovement_Order.MovementChildId > 0 -- проверка по связи заявки с EDI

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Personal
                                         ON MovementLinkObject_Personal.MovementId = tmpMovement.Id
                                        AND MovementLinkObject_Personal.DescId = zc_MovementLinkObject_Personal()
            LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = MovementLinkObject_Personal.ObjectId
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Scale_OrderExternal (TDateTime, Integer, TVarChar, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 18.01.15                                        *
*/

-- тест
-- SELECT * FROM gpGet_Scale_OrderExternal (inOperDate := ('01.07.2015')::TDateTime , inBranchCode := 1 , inBarCode := '2020018777013' ,  inSession := '5');
-- SELECT * FROM gpGet_Scale_OrderExternal(inOperDate := CURRENT_DATE , inBranchCode := 301 , inBarCode := '135', inSession := '5');
