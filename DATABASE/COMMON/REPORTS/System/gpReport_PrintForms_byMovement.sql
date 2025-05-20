-- Function: gpReport_PrintForms_byMovement (TDateTime, TDateTime, TVarChar)

DROP FUNCTION IF EXISTS gpReport_PrintForms_byMovement (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_PrintForms_byMovement(
    IN inStartDate   TDateTime , --
    IN inEndDate     TDateTime , --
    IN inMovementDescId Integer,
    IN inSession     TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber Integer, OperDate TDateTime
             , MovementDescId Integer, MovementDescName TVarChar
             , TotalLines TFloat
             , TotalPage_1 TFloat, TotalPage_2 TFloat, TotalPage_3 TFloat, TotalPage_4 TFloat
             , TotalPage_5 TFloat, TotalPage_6 TFloat, TotalPage_7 TFloat, TotalPage_8 TFloat
             , TotalPage_All TFloat
             , FormPrintName TVarChar
             , InsertName TVarChar, BranchName_Ins TVarChar
             , UnitCode_Ins Integer, UnitName_Ins TVarChar
             , PositionName_Ins TVarChar
             , PrintKindId Integer, PrintKindName TVarChar
             , FromId Integer, FromName  TVarChar
             , ToId Integer, ToName TVarChar
             , JuridicalId Integer, JuridicalName TVarChar
             , RetailName TVarChar
             , UnitName TVarChar
             , BranchName TVarChar
             , MovementId_sale Integer
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

--     inStartDate:= '01.05.2025';
  --   inEndDate  := CURRENT_DATE;
  --inStartDate:= CURRENT_DATE;
  -- inEndDate  := CURRENT_DATE;
--        WHERE tmpData.MovementDescId = zc_Movement_Sale()
  --      order by 1,4, 5

   -- Результат
   RETURN QUERY
    WITH
    tmpMovementDesc AS (
                        SELECT MovementDesc.*
                        FROM MovementDesc
                        WHERE MovementDesc.Id IN (zc_Movement_Sale()
                                                , zc_Movement_SendOnPrice()
                                                , zc_Movement_Send()
                                                , zc_Movement_Loss()
                                              --, zc_Movement_ReturnIn()

                                                , zc_Movement_OrderExternal()

                                              --, zc_Movement_Income()
                                              --, zc_Movement_ReturnOut()
                                                  --
                                                , zc_Movement_TransportGoods()
                                                , zc_Movement_QualityDoc()
                                                 )
                        )

  , tmpPrintForms_View AS (SELECT *
                           FROM PrintForms_View
                          )

  , tmpJuridical_PrintKindItem AS (WITH
                                   tmpPrintKindItem AS (SELECT * FROM lpSelect_Object_PrintKindItem ())
                                   SELECT Object_Juridical.Id AS JuridicalId
                                      --, tmpPrintKindItem.isMovement          --+
                                        , tmpPrintKindItem.isAccount           --+
                                      --, tmpPrintKindItem.isTransport
                                      --, tmpPrintKindItem.isQuality           --+
                                        , tmpPrintKindItem.isPack
                                        , tmpPrintKindItem.isSpec
                                      --, tmpPrintKindItem.isTax
                                      --, tmpPrintKindItem.isTransportBill
                                   FROM Object AS Object_Juridical
                                        LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                             ON ObjectLink_Juridical_Retail.ObjectId = Object_Juridical.Id
                                                            AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                        LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId

                                        LEFT JOIN ObjectLink AS ObjectLink_Retail_PrintKindItem
                                                             ON ObjectLink_Retail_PrintKindItem.ObjectId = ObjectLink_Juridical_Retail.ChildObjectId
                                                            AND ObjectLink_Retail_PrintKindItem.DescId = zc_ObjectLink_Retail_PrintKindItem()
                                        LEFT JOIN ObjectLink AS ObjectLink_Juridical_PrintKindItem
                                                             ON ObjectLink_Juridical_PrintKindItem.ObjectId = Object_Juridical.Id
                                                            AND ObjectLink_Juridical_PrintKindItem.DescId = zc_ObjectLink_Juridical_PrintKindItem()

                                        INNER JOIN tmpPrintKindItem ON tmpPrintKindItem.Id = CASE WHEN ObjectLink_Juridical_Retail.ChildObjectId > 0
                                                                                                       -- Всегда для Торговая сеть
                                                                                                       THEN ObjectLink_Retail_PrintKindItem.ChildObjectId
                                                                                                  -- Всегда для Юр лицо
                                                                                                  ELSE ObjectLink_Juridical_PrintKindItem.ChildObjectId
                                                                                             END
                                   WHERE Object_Juridical.DescId = zc_Object_Juridical()
                                   )

  , tmpPrintForm AS (SELECT tmpMovementDesc.Id       AS MovementDescId
                          , tmpMovementDesc.ItemName AS MovementDescName
                          , CASE WHEN tmpMovementDesc.Id = zc_Movement_Income()        THEN 'PrintMovement_Income'
                                 WHEN tmpMovementDesc.Id = zc_Movement_Loss()          THEN 'PrintMovement_Loss'
                                 WHEN tmpMovementDesc.Id = zc_Movement_OrderExternal() THEN 'PrintMovement_OrderExternal'
                                 WHEN tmpMovementDesc.Id = zc_Movement_ReturnOut()     THEN 'PrintMovement_ReturnOut'
                                 WHEN tmpMovementDesc.Id = zc_Movement_ReturnOut()     THEN 'PrintMovement_ReturnIn'
                                 WHEN tmpMovementDesc.Id = zc_Movement_Send()          THEN 'PrintMovement_Send'
                                 WHEN tmpMovementDesc.Id = zc_Movement_SendOnPrice()   THEN 'PrintMovement_SendOnPrice'
                                 ELSE NULL
                            END  AS PrintFormName
                     FROM tmpMovementDesc
                     WHERE tmpMovementDesc.Id = inMovementDescId OR inMovementDescId = 0
                    )
  , tmpMovement_all AS (SELECT Movement.*
                        FROM Movement
                        WHERE Movement.DescId IN (SELECT DISTINCT tmpPrintForm.MovementDescId FROM tmpPrintForm)
                          AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                       )
  , tmpMLO AS (SELECT MovementLinkObject.*
               FROM MovementLinkObject
               WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMovement_all.Id FROM tmpMovement_all)
                 AND MovementLinkObject.DescId IN (zc_MovementLinkObject_Insert()
                                                  , zc_MovementLinkObject_To()
                                                  , zc_MovementLinkObject_From()
                                                  , zc_MovementLinkObject_Contract()
                                                  , zc_MovementLinkObject_PaidKind()
                                                  , zc_MovementLinkObject_PaidKindTo()
                                                  )
               )

  , tmpMLM AS (SELECT MovementLinkMovement.*
               FROM MovementLinkMovement
               WHERE MovementLinkMovement.MovementChildId IN (SELECT DISTINCT tmpMovement_all.Id FROM tmpMovement_all)
                 AND MovementLinkMovement.DescId IN (zc_MovementLinkMovement_TransportGoods()
                                                   )
               )

  , tmpMovementDate AS (SELECT MovementDate.*
                        FROM MovementDate
                        WHERE MovementDate.MovementId IN (SELECT DISTINCT tmpMovement_all.Id FROM tmpMovement_all)
                          AND MovementDate.DescId IN (zc_MovementDate_OperDatePartner()
                                                    , zc_MovementDate_Insert()
                                                     )
                        )
  , tmpMovementFloat AS (SELECT MovementFloat.*
                         FROM MovementFloat
                         WHERE MovementFloat.MovementId IN (SELECT DISTINCT tmpMovement_all.Id FROM tmpMovement_all)
                           AND MovementFloat.DescId IN (zc_MovementFloat_TotalLines()
                                                      , zc_MovementFloat_TotalPage_1()
                                                      , zc_MovementFloat_TotalPage_2()
                                                      , zc_MovementFloat_TotalPage_3()
                                                      , zc_MovementFloat_TotalPage_4()
                                                      , zc_MovementFloat_TotalPage_5()
                                                      , zc_MovementFloat_TotalPage_6()
                                                      , zc_MovementFloat_TotalPage_7()
                                                      , zc_MovementFloat_TotalPage_8()
                                                        )
                         )
  , tmpMovementBoolean AS (SELECT MovementBoolean.*
                           FROM MovementBoolean
                           WHERE MovementBoolean.MovementId IN (SELECT DISTINCT tmpMovement_all.Id FROM tmpMovement_all)
                             AND MovementBoolean.DescId IN (zc_MovementBoolean_PriceWithVAT()
                                                           )
                          )

      , tmpMovement AS (SELECT Movement.*
                             , MovementLinkObject_From.ObjectId AS FromId
                             , Object_From.DescId               AS DescId_from
                             , Object_From.ValueData            AS FromName
                             , MovementLinkObject_To.ObjectId   AS ToId
                             , Object_To.DescId                 AS DescId_to
                             , Object_To.ValueData              AS ToName
                             , MovementLinkObject_Insert.ObjectId AS UserId_insert
                             , MovementDate_Insert.ValueData      AS OperDate_insert
                        FROM tmpMovement_all AS Movement
                              LEFT JOIN tmpMLO AS MovementLinkObject_Insert
                                               ON MovementLinkObject_Insert.MovementId = Movement.Id
                                              AND MovementLinkObject_Insert.DescId     = zc_MovementLinkObject_Insert()
                              LEFT JOIN tmpMovementDate AS MovementDate_Insert
                                                        ON MovementDate_Insert.MovementId = Movement.Id
                                                       AND MovementDate_Insert.DescId     = zc_MovementDate_Insert()
                              LEFT JOIN tmpMLO AS MovementLinkObject_From
                                               ON MovementLinkObject_From.MovementId = Movement.Id
                                              AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                              LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

                              LEFT JOIN tmpMLO AS MovementLinkObject_To
                                               ON MovementLinkObject_To.MovementId = Movement.Id
                                              AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                              LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId


                              -- Взвешивание
                              /*LEFT JOIN Movement AS Movement_Weighing ON Movement_Weighing.ParentId = Movement.Id
                                                                     AND Movement_Weighing.DescId   IN (zc_Movement_WeighingPartner(), zc_Movement_WeighingProduction())
                              -- Протокол - Взвешивание
                              LEFT JOIN MovementLinkObject AS MovementLinkObject_User
                                                           ON MovementLinkObject_User.MovementId = Movement_Weighing.Id
                                                          AND MovementLinkObject_User.DescId     = zc_MovementLinkObject_User()
                              LEFT JOIN MovementDate AS MovementDate_EndBegin
                                                     ON MovementDate_EndBegin.MovementId = Movement_Weighing.Id
                                                    AND MovementDate_EndBegin.DescId     = zc_MovementDate_EndBegin()*/

                        WHERE Movement.DescId IN (SELECT DISTINCT tmpPrintForm.MovementDescId FROM tmpPrintForm)
                          AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                       )

  , tmpSale AS (SELECT Movement.Id
                     , Movement.InvNumber
                     , Movement.OperDate
                     , Movement.DescId

                     , tmpPrintForm.MovementDescName

                     , Movement.UserId_insert

                     , Movement.FromId
                     , Movement.DescId_from
                     , Movement.FromName
                     , Movement.ToId
                     , Movement.DescId_to
                     , Movement.ToName
                     , COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, Movement.ToId)  AS JuridicalId
                     , ObjectLink_Juridical_Retail.ChildObjectId  AS RetailId
                     , MovementLinkObject_PaidKind.ObjectId       AS PaidKindId
                       --
                  --, tmpPrintKindItem.isMovement
                     , tmpPrintKindItem.isAccount
                  -- , tmpPrintKindItem.isTransport
                  -- , tmpPrintKindItem.isQuality
                     , tmpPrintKindItem.isPack
                     , tmpPrintKindItem.isSpec
                  -- , tmpPrintKindItem.isTax
                  -- , tmpPrintKindItem.isTransportBill
                FROM tmpMovement AS Movement
                    LEFT JOIN tmpPrintForm ON tmpPrintForm.MovementDescId = Movement.DescId

                    LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                         ON ObjectLink_Partner_Juridical.ObjectId = Movement.FromId
                                        AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()

                    LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                         ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                        AND ObjectLink_Juridical_Retail.DescId   = zc_ObjectLink_Juridical_Retail()

                   LEFT JOIN tmpMLO AS MovementLinkObject_PaidKind
                                    ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                   AND MovementLinkObject_PaidKind.DescId IN (zc_MovementLinkObject_PaidKind(), zc_MovementLinkObject_PaidKindTo())

                   LEFT JOIN tmpJuridical_PrintKindItem AS tmpPrintKindItem ON tmpPrintKindItem.JuridicalId = COALESCE( ObjectLink_Partner_Juridical.ChildObjectId, Movement.ToId)
                WHERE Movement.DescId = zc_Movement_Sale()
               )

  , tmpData AS (-- все простые формы
                SELECT Movement.Id
                     , Movement.InvNumber
                     , Movement.OperDate
                     , Movement.DescId AS MovementDescId

                     , tmpPrintForm.MovementDescName
                     , tmpPrintForm.PrintFormName ::TVarChar AS PrintFormName
                       -- Накладная
                     , zc_Enum_PrintKind_Movement() AS PrintKindId

                     , Movement.UserId_insert

                     , Movement.FromId
                     , Movement.DescId_from
                     , Movement.FromName
                     , Movement.ToId
                     , Movement.DescId_to
                     , Movement.ToName
                     , ObjectLink_Partner_Juridical.ChildObjectId AS JuridicalId
                     , ObjectLink_Juridical_Retail.ChildObjectId  AS RetailId

                     , 0 ::Integer AS MovementId_sale

                FROM tmpMovement AS Movement
                     LEFT JOIN tmpPrintForm ON tmpPrintForm.MovementDescId = Movement.DescId

                     LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                          ON ObjectLink_Partner_Juridical.ObjectId = CASE WHEN Movement.DescId_to <> zc_Object_Unit() THEN Movement.ToId ELSE Movement.FromId END
                                         AND ObjectLink_Partner_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()
                     LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                          ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                         AND ObjectLink_Juridical_Retail.DescId   = zc_ObjectLink_Juridical_Retail()

                WHERE Movement.DescId NOT IN (zc_Movement_Sale(), zc_Movement_TransportGoods(),zc_Movement_QualityDoc())

               UNION
                -- TTN
                SELECT Movement.Id
                     , Movement.InvNumber
                     , Movement.OperDate
                     , Movement.DescId AS MovementDescId

                     , tmpPrintForm.MovementDescName
                     , COALESCE (PrintForms_View.PrintFormName, 'PrintMovement_TTN_03012025') ::TVarChar AS PrintFormName
                       -- TTN
                     , zc_Enum_PrintKind_Transport() AS PrintKindId

                     , Movement.UserId_insert

                     , MovementLinkObject_From.ObjectId AS FromId
                     , Object_From.DescId               AS DescId_from
                     , Object_From.ValueData            AS FromName
                     , MovementLinkObject_To.ObjectId   AS ToId
                     , Object_To.DescId                 AS DescId_to
                     , Object_To.ValueData              AS ToName
                     , COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MovementLinkObject_To.ObjectId) AS JuridicalId
                     , ObjectLink_Juridical_Retail.ChildObjectId  AS RetailId

                     , MovementLinkMovement_TransportGoods.MovementId AS MovementId_sale

                FROM tmpMovement AS Movement
                      LEFT JOIN tmpPrintForm ON tmpPrintForm.MovementDescId = Movement.DescId

                      -- связь Товаро-транспортная накладная с Продажа покупателю
                      LEFT JOIN tmpMLM AS MovementLinkMovement_TransportGoods
                                       ON MovementLinkMovement_TransportGoods.MovementChildId = Movement.Id
                                      AND MovementLinkMovement_TransportGoods.DescId          = zc_MovementLinkMovement_TransportGoods()

                      LEFT JOIN tmpMovementDate AS MovementDate_OperDatePartner
                                                ON MovementDate_OperDatePartner.MovementId = MovementLinkMovement_TransportGoods.MovementId
                                               AND MovementDate_OperDatePartner.DescId     = zc_MovementDate_OperDatePartner()

                      LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                   ON MovementLinkObject_To.MovementId = MovementLinkMovement_TransportGoods.MovementId
                                                  AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                      LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

                      LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                   ON MovementLinkObject_From.MovementId = MovementLinkMovement_TransportGoods.MovementId
                                                  AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                      LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

                      LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                           ON ObjectLink_Partner_Juridical.ObjectId = CASE WHEN Object_To.DescId <> zc_Object_Unit() THEN MovementLinkObject_To.ObjectId ELSE MovementLinkObject_From.ObjectId END
                                          AND ObjectLink_Partner_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()

                      LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                           ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                          AND ObjectLink_Juridical_Retail.DescId   = zc_ObjectLink_Juridical_Retail()

                      LEFT JOIN tmpPrintForms_View AS PrintForms_View
                             ON COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) BETWEEN PrintForms_View.StartDate AND PrintForms_View.EndDate
                            AND PrintForms_View.JuridicalId = COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MovementLinkObject_To.ObjectId)
                            AND PrintForms_View.ReportType = 'TransportGoods'
                            AND PrintForms_View.DescId = zc_Movement_TransportGoods()

                WHERE Movement.DescId = zc_Movement_TransportGoods()

               UNION
                -- Качественное
                SELECT Movement.Id
                     , Movement.InvNumber
                     , Movement.OperDate
                     , Movement.DescId AS MovementDescId

                     , tmpPrintForm.MovementDescName
                     ,  COALESCE (PrintForms_View.PrintFormName, 'PrintMovement_Quality') ::TVarChar AS PrintFormName
                       -- Качественное
                     , zc_Enum_PrintKind_Quality() AS PrintKindId

                     , Movement.UserId_insert

                     , MovementLinkObject_From.ObjectId AS FromId
                     , Object_From.DescId               AS DescId_from
                     , Object_From.ValueData            AS FromName
                     , MovementLinkObject_To.ObjectId   AS ToId
                     , Object_To.DescId                 AS DescId_to
                     , Object_To.ValueData              AS ToName
                     , ObjectLink_Partner_Juridical.ChildObjectId AS JuridicalId
                     , ObjectLink_Juridical_Retail.ChildObjectId  AS RetailId

                     , MovementLinkMovement_Child.MovementChildId AS MovementId_sale

                FROM tmpMovement AS Movement
                      LEFT JOIN tmpPrintForm ON tmpPrintForm.MovementDescId = Movement.DescId

                      -- связь Качественное с Продажа покупателю
                      LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Child
                                                     ON MovementLinkMovement_Child.MovementId = Movement.Id
                                                    AND MovementLinkMovement_Child.DescId     = zc_MovementLinkMovement_Child()

                      LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                   ON MovementLinkObject_To.MovementId = MovementLinkMovement_Child.MovementChildId
                                                  AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                      LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

                      LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                   ON MovementLinkObject_From.MovementId = MovementLinkMovement_Child.MovementChildId
                                                  AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                      LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

                      LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                           ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                                          AND ObjectLink_Partner_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()
                      LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                           ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                          AND ObjectLink_Juridical_Retail.DescId   = zc_ObjectLink_Juridical_Retail()

                      LEFT JOIN ObjectHistory_JuridicalDetails_View AS OH_JuridicalDetails ON OH_JuridicalDetails.JuridicalId = CASE WHEN Movement.DescId = zc_Movement_TransferDebtOut() THEN MovementLinkObject_To.ObjectId ELSE ObjectLink_Partner_Juridical.ChildObjectId END

                      LEFT JOIN tmpPrintForms_View AS PrintForms_View
                             ON Movement.OperDate BETWEEN PrintForms_View.StartDate AND PrintForms_View.EndDate
                            AND PrintForms_View.JuridicalId = CASE WHEN Movement.DescId = zc_Movement_TransferDebtOut() THEN MovementLinkObject_To.ObjectId ELSE ObjectLink_Partner_Juridical.ChildObjectId END
                            AND PrintForms_View.ReportType = 'Quality'
                            AND PrintForms_View.DescId = zc_Movement_Sale()
                            AND (/*vbIsGoodsCode_2393 = TRUE
                              OR*/ OH_JuridicalDetails.OKPO NOT IN ('32294926', '40720198', '32294897')
                                )
                WHERE Movement.DescId = zc_Movement_QualityDoc()

              UNION
                -- Продажи - zc_Enum_PrintKind_Movement
                SELECT Movement.Id
                     , Movement.InvNumber
                     , Movement.OperDate
                     , Movement.DescId AS MovementDescId

                     , Movement.MovementDescName
                     , CASE -- !!!захардкодил для Contract - JuridicalInvoice!!!
                                WHEN ObjectLink_Contract_JuridicalInvoice.ChildObjectId > 0
                                 AND Movement.PaidKindId = zc_Enum_PaidKind_FirstForm()
                                     THEN 'PrintMovement_SaleJuridicalInvoice'

                               /* -- !!!захардкодил для Гофротары!!!
                                WHEN EXISTS (SELECT 1 FROM tmpPack WHERE tmpPack.Ord1 = tmpPack.Ord2)
                                 AND Movement.DescId <> zc_Movement_Loss()
                                     THEN 'PrintMovement_SalePackWeight'
                               */
                                -- !!!захардкодил временно для Запорожье!!!
                                WHEN Movement.FromId IN (301309) -- Склад ГП ф.Запорожье
                                 AND Movement.PaidKindId = zc_Enum_PaidKind_SecondForm()
                                     THEN PrintForms_View_Default.PrintFormName

                                -- новая форма для Жук А.Н. Товарная накладная
                                WHEN Movement.ToId = 3683763
                                     THEN 'PrintMovement_Sale2_3683763'

                                -- !!!захардкодил временно для БН с НДС!!!
                                WHEN MB_PriceWithVAT.ValueData = TRUE
                                 AND Movement.PaidKindId = zc_Enum_PaidKind_FirstForm()
                                 AND OH_JuridicalDetails.OKPO NOT IN ('26632252')
                                     THEN 'PrintMovement_Sale2PriceWithVAT'

                                ELSE COALESCE (PrintForms_View.PrintFormName, PrintForms_View_Default.PrintFormName)
                           END ::TVarChar AS PrintFormName

                      -- Накладная
                     , zc_Enum_PrintKind_Movement() AS PrintKindId

                     , Movement.UserId_insert

                     , Movement.FromId
                     , Movement.DescId_from
                     , Movement.FromName
                     , Movement.ToId
                     , Movement.DescId_to
                     , Movement.ToName
                     , Movement.JuridicalId
                     , Movement.RetailId

                     , Movement.Id AS MovementId_sale

                FROM tmpSale AS Movement
                      LEFT JOIN tmpMLO AS MovementLinkObject_Contract
                                       ON MovementLinkObject_Contract.MovementId = Movement.Id
                                      AND MovementLinkObject_Contract.DescId     = zc_MovementLinkObject_Contract()

                      LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalInvoice
                                           ON ObjectLink_Contract_JuridicalInvoice.ObjectId = MovementLinkObject_Contract.ObjectId
                                          AND ObjectLink_Contract_JuridicalInvoice.DescId   = zc_ObjectLink_Contract_JuridicalInvoice()

                      LEFT JOIN tmpMovementBoolean AS MB_PriceWithVAT
                                                   ON MB_PriceWithVAT.MovementId = Movement.Id
                                                  AND MB_PriceWithVAT.DescId     = zc_MovementBoolean_PriceWithVAT()

                      LEFT JOIN ObjectHistory_JuridicalDetails_View AS OH_JuridicalDetails ON OH_JuridicalDetails.JuridicalId = Movement.JuridicalId

                      LEFT JOIN tmpPrintForms_View AS PrintForms_View
                             ON Movement.OperDate BETWEEN PrintForms_View.StartDate AND PrintForms_View.EndDate
                            AND PrintForms_View.JuridicalId = Movement.JuridicalId
                            AND PrintForms_View.ReportType = 'Sale'

                      LEFT JOIN tmpPrintForms_View AS PrintForms_View_Default
                             ON Movement.OperDate BETWEEN PrintForms_View_Default.StartDate AND PrintForms_View_Default.EndDate
                            AND PrintForms_View_Default.JuridicalId = 0
                            AND PrintForms_View_Default.ReportType = 'Sale'
                            AND PrintForms_View_Default.PaidKindId = Movement.PaidKindId

              UNION
                -- Продажи - Счет - zc_Enum_PrintKind_Account
                SELECT Movement.Id                   ::Integer
                     , Movement.InvNumber            ::TVarChar
                     , Movement.OperDate             ::TDateTime
                     , Movement.DescId AS MovementDescId

                     , Movement.MovementDescName     ::TVarChar
                     , COALESCE (PrintForms_View.PrintFormName, PrintForms_View_Default.PrintFormName) ::TVarChar AS PrintFormName

                       -- Счет
                     , zc_Enum_PrintKind_Account() AS PrintKindId

                     , Movement.UserId_insert

                     , Movement.FromId
                     , Movement.DescId_from
                     , Movement.FromName
                     , Movement.ToId
                     , Movement.DescId_to
                     , Movement.ToName
                     , Movement.JuridicalId
                     , Movement.RetailId

                     , Movement.Id AS MovementId_sale

                FROM tmpSale AS Movement

                   LEFT JOIN PrintForms_View
                          ON Movement.OperDate BETWEEN PrintForms_View.StartDate AND PrintForms_View.EndDate
                         AND PrintForms_View.JuridicalId = Movement.JuridicalId
                         AND PrintForms_View.ReportType = 'Bill'
            --             AND PrintForms_View.DescId = zc_Movement_Sale()

                   LEFT JOIN PrintForms_View AS PrintForms_View_Default
                          ON Movement.OperDate BETWEEN PrintForms_View_Default.StartDate AND PrintForms_View_Default.EndDate
                         AND PrintForms_View_Default.JuridicalId = 0
                         AND PrintForms_View_Default.ReportType = 'Bill'
                         AND PrintForms_View_Default.PaidKindId = Movement.PaidKindId
            --             AND PrintForms_View_Default.DescId = zc_Movement_Sale()

                WHERE Movement.isAccount = TRUE

             UNION
                -- Продажи - Упаковочный (клиенту) - zc_Enum_PrintKind_Pack
                SELECT Movement.Id                   ::Integer
                     , Movement.InvNumber            ::TVarChar
                     , Movement.OperDate             ::TDateTime
                     , Movement.DescId AS MovementDescId

                     , Movement.MovementDescName     ::TVarChar
                     , 'PrintMovement_SalePack21'    ::TVarChar AS PrintFormName

                       -- Упаковочный (клиенту)
                     , zc_Enum_PrintKind_Pack()                 AS PrintKindId

                     , Movement.UserId_insert

                     , Movement.FromId
                     , Movement.DescId_from
                     , Movement.FromName
                     , Movement.ToId
                     , Movement.DescId_to
                     , Movement.ToName
                     , Movement.JuridicalId
                     , Movement.RetailId

                     , Movement.Id AS MovementId_sale

                FROM tmpSale AS Movement
                WHERE Movement.isPack = TRUE

             UNION
                -- Продажи - Спецификация (клиенту) - zc_Enum_PrintKind_Spec
                SELECT Movement.Id                   ::Integer
                     , Movement.InvNumber            ::TVarChar
                     , Movement.OperDate             ::TDateTime
                     , Movement.DescId AS MovementDescId

                     , Movement.MovementDescName     ::TVarChar
                     , 'PrintMovement_SalePack22'    ::TVarChar AS PrintFormName

                       -- Спецификация (клиенту)
                     , zc_Enum_PrintKind_Spec()                 AS PrintKindId

                     , Movement.UserId_insert

                     , Movement.FromId
                     , Movement.DescId_from
                     , Movement.FromName
                     , Movement.ToId
                     , Movement.DescId_to
                     , Movement.ToName
                     , Movement.JuridicalId
                     , Movement.RetailId

                     , Movement.Id AS MovementId_sale

                FROM tmpSale AS Movement
                WHERE Movement.isSpec = TRUE

             UNION
                -- Продажи - Упаковочный (охрана) - zc_Enum_PrintKind_PackGross
                SELECT Movement.Id                   ::Integer
                     , Movement.InvNumber            ::TVarChar
                     , Movement.OperDate             ::TDateTime
                     , Movement.DescId AS MovementDescId

                     , Movement.MovementDescName     ::TVarChar
                     , 'PrintMovement_SalePackGross' ::TVarChar AS PrintFormName

                       -- Упаковочный (охрана)
                     , zc_Enum_PrintKind_PackGross()            AS PrintKindId

                     , Movement.UserId_insert

                     , Movement.FromId
                     , Movement.DescId_from
                     , Movement.FromName
                     , Movement.ToId
                     , Movement.DescId_to
                     , Movement.ToName
                     , Movement.JuridicalId
                     , Movement.RetailId

                     , Movement.Id AS MovementId_sale

                FROM tmpSale AS Movement
                -- Только РК
                WHERE Movement.FromId = zc_Unit_RK()

             UNION
                -- Перемещение + SendOnPrice - Упаковочный (охрана) - zc_Enum_PrintKind_PackGross
                SELECT Movement.Id                   ::Integer
                     , Movement.InvNumber            ::TVarChar
                     , Movement.OperDate             ::TDateTime
                     , Movement.DescId    AS MovementDescId

                     , MovementDesc.ItemName AS MovementDescName
                     , 'PrintMovement_SendPackGross' ::TVarChar AS PrintFormName

                       -- Упаковочный (охрана)
                     , zc_Enum_PrintKind_PackGross()            AS PrintKindId

                     , Movement.UserId_insert

                     , Movement.FromId
                     , Movement.DescId_from
                     , Movement.FromName
                     , Movement.ToId
                     , Movement.DescId_to
                     , Movement.ToName

                     , 0 ::Integer AS JuridicalId
                     , 0 ::Integer AS RetailId

                     , 0 ::Integer AS MovementId_sale

                FROM tmpMovement AS Movement
                     LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId

                WHERE Movement.DescId IN (zc_Movement_Send(), zc_Movement_SendOnPrice())
                  -- !!!Только РК
                  AND Movement.FromId = zc_Unit_RK()

              UNION
                -- Возвраты
                SELECT Movement.Id                   ::Integer
                     , Movement.InvNumber            ::TVarChar
                     , Movement.OperDate             ::TDateTime
                     , Movement.DescId AS MovementDescId

                     , tmpPrintForm.MovementDescName ::TVarChar
                     , COALESCE (PrintForms_View.PrintFormName, PrintForms_View_Default.PrintFormName) ::TVarChar AS PrintFormName

                      -- Накладная
                     , zc_Enum_PrintKind_Movement() AS PrintKindId

                     , Movement.UserId_insert

                     , Movement.FromId
                     , Movement.DescId_from
                     , Movement.FromName
                     , Movement.ToId
                     , Movement.DescId_to
                     , Movement.ToName

                     , ObjectLink_Partner_Juridical.ChildObjectId AS JuridicalId
                     , ObjectLink_Juridical_Retail.ChildObjectId  AS RetailId

                     , 0 ::Integer AS MovementId_sale

                FROM tmpMovement AS Movement
                    LEFT JOIN tmpPrintForm ON tmpPrintForm.MovementDescId = Movement.DescId

                    LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                         ON ObjectLink_Partner_Juridical.ObjectId = Movement.FromId
                                        AND ObjectLink_Partner_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()

                    LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                         ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                        AND ObjectLink_Juridical_Retail.DescId   = zc_ObjectLink_Juridical_Retail()

                    LEFT JOIN tmpPrintForms_View AS PrintForms_View
                           ON Movement.OperDate BETWEEN PrintForms_View.StartDate AND PrintForms_View.EndDate
                          AND PrintForms_View.JuridicalId = COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, Movement.FromId)
                          AND PrintForms_View.ReportType = CASE WHEN Movement.DescId = zc_Movement_PriceCorrective() THEN 'PriceCorrective' ELSE 'ReturnIn' END
                          AND PrintForms_View.DescId = CASE WHEN Movement.DescId = zc_Movement_PriceCorrective() THEN zc_Movement_PriceCorrective() ELSE zc_Movement_ReturnIn() END

                    LEFT JOIN tmpPrintForms_View AS PrintForms_View_Default
                           ON Movement.OperDate BETWEEN PrintForms_View_Default.StartDate AND PrintForms_View_Default.EndDate
                          AND PrintForms_View_Default.JuridicalId = 0
                          AND PrintForms_View_Default.ReportType = CASE WHEN Movement.DescId = zc_Movement_PriceCorrective() THEN 'PriceCorrective' ELSE 'ReturnIn' END
                          AND PrintForms_View_Default.DescId = CASE WHEN Movement.DescId = zc_Movement_PriceCorrective() THEN zc_Movement_PriceCorrective() ELSE zc_Movement_ReturnIn() END
                WHERE Movement.DescId = zc_Movement_ReturnIn()
              )

      , tmpPersonal AS (SELECT lfSelect.MemberId
                             , lfSelect.UnitId
                             , lfSelect.PositionId
                             , lfSelect.isDateOut
                             , lfSelect.DateOut
                        FROM lfSelect_Object_Member_findPersonal (inSession) AS lfSelect
                       )

        --РЕЗУЛЬТАТ
        SELECT tmpData.Id                  ::Integer
             , zfConvert_StringToNumber (tmpData.InvNumber) AS InvNumber
             , tmpData.OperDate            ::TDateTime
             , tmpData.MovementDescId      ::Integer
             , tmpData.MovementDescName    ::TVarChar

             , MovementFloat_TotalLines.ValueData ::TFloat AS TotalLines
             , CASE WHEN tmpData.PrintKindId = zc_Enum_PrintKind_Movement()      THEN MovementFloat_TotalPage_1.ValueData ELSE 0 END ::TFloat AS TotalPage_1
             , CASE WHEN tmpData.PrintKindId = zc_Enum_PrintKind_Quality()       THEN MovementFloat_TotalPage_2.ValueData ELSE 0 END ::TFloat AS TotalPage_2
             , CASE WHEN tmpData.PrintKindId = zc_Enum_PrintKind_Transport()     THEN MovementFloat_TotalPage_3.ValueData ELSE 0 END ::TFloat AS TotalPage_3  --ттн
             , CASE WHEN tmpData.PrintKindId = zc_Enum_PrintKind_TransportBill() THEN MovementFloat_TotalPage_4.ValueData ELSE 0 END ::TFloat AS TotalPage_4
             , CASE WHEN tmpData.PrintKindId = zc_Enum_PrintKind_PackGross()     THEN MovementFloat_TotalPage_5.ValueData ELSE 0 END ::TFloat AS TotalPage_5
             , CASE WHEN tmpData.PrintKindId = zc_Enum_PrintKind_Pack()          THEN MovementFloat_TotalPage_6.ValueData ELSE 0 END ::TFloat AS TotalPage_6
             , CASE WHEN tmpData.PrintKindId = zc_Enum_PrintKind_Spec()          THEN MovementFloat_TotalPage_7.ValueData ELSE 0 END ::TFloat AS TotalPage_7
             , CASE WHEN tmpData.PrintKindId = zc_Enum_PrintKind_Account()       THEN MovementFloat_TotalPage_8.ValueData ELSE 0 END ::TFloat AS TotalPage_8

             , (CASE WHEN tmpData.PrintKindId = zc_Enum_PrintKind_Movement()      THEN MovementFloat_TotalPage_1.ValueData ELSE 0 END
              + CASE WHEN tmpData.PrintKindId = zc_Enum_PrintKind_Quality()       THEN MovementFloat_TotalPage_2.ValueData ELSE 0 END
              + CASE WHEN tmpData.PrintKindId = zc_Enum_PrintKind_Transport()     THEN MovementFloat_TotalPage_3.ValueData ELSE 0 END
              + CASE WHEN tmpData.PrintKindId = zc_Enum_PrintKind_TransportBill() THEN MovementFloat_TotalPage_4.ValueData ELSE 0 END
              + CASE WHEN tmpData.PrintKindId = zc_Enum_PrintKind_PackGross()     THEN MovementFloat_TotalPage_5.ValueData ELSE 0 END
              + CASE WHEN tmpData.PrintKindId = zc_Enum_PrintKind_Pack()          THEN MovementFloat_TotalPage_6.ValueData ELSE 0 END
              + CASE WHEN tmpData.PrintKindId = zc_Enum_PrintKind_Spec()          THEN MovementFloat_TotalPage_7.ValueData ELSE 0 END
              + CASE WHEN tmpData.PrintKindId = zc_Enum_PrintKind_Account()       THEN MovementFloat_TotalPage_8.ValueData ELSE 0 END
               ) ::TFloat AS TotalPage_All

             , tmpData.PrintFormName       ::TVarChar AS PrintFormName

             , Object_Insert.ValueData         ::TVarChar AS InsertName
             , Object_Branch_Ins.ValueData     ::TVarChar AS BranchName_Ins
             , Object_Unit_Ins.ObjectCode      ::Integer  AS UnitCode_Ins
             , Object_Unit_Ins.ValueData       ::TVarChar AS UnitName_Ins
             , Object_Position_Ins.ValueData   ::TVarChar AS PositionName_Ins

             , Object_PrintKind.Id         ::Integer  AS PrintKindId
             , Object_PrintKind.ValueData  ::TVarChar AS PrintKindName
             , tmpData.FromId              ::Integer
             , tmpData.FromName            ::TVarChar
             , tmpData.ToId                ::Integer
             , tmpData.ToName              ::TVarChar
             , Object_Juridical.Id         ::Integer  AS JuridicalId
             , Object_Juridical.ValueData  ::TVarChar AS JuridicalName
             , Object_Retail.ValueData     ::TVarChar AS RetailName

             , CASE WHEN tmpData.MovementDescId IN (zc_Movement_Income(), zc_Movement_ReturnIn(), zc_Movement_OrderExternal())
                         THEN tmpData.ToName
                    ELSE tmpData.FromName
               END :: TVarChar AS UnitName
             , Object_Branch.ValueData AS BranchName

               -- для Transport + Quality
             , tmpData.MovementId_sale ::Integer AS MovementId_sale

        FROM tmpData
             LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                                  ON ObjectLink_Unit_Branch.ObjectId = CASE WHEN tmpData.MovementDescId IN (zc_Movement_Income(), zc_Movement_ReturnIn(), zc_Movement_OrderExternal())
                                                                                 THEN tmpData.ToId
                                                                            ELSE tmpData.FromId
                                                                       END
                                 AND ObjectLink_Unit_Branch.DescId   = zc_ObjectLink_Unit_Branch()
                                 AND tmpData.DescId_From             = zc_Object_Unit()
             LEFT JOIN Object AS Object_Branch    ON Object_Branch.Id = ObjectLink_Unit_Branch.ChildObjectId

             LEFT JOIN Object AS Object_Insert    ON Object_Insert.Id = tmpData.UserId_insert
             LEFT JOIN Object AS Object_PrintKind ON Object_PrintKind.Id = tmpData.PrintKindId
             LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpData.JuridicalId
             LEFT JOIN Object AS Object_Retail    ON Object_Retail.Id = tmpData.RetailId
             --
             LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                  ON ObjectLink_User_Member.ObjectId = Object_Insert.Id
                                 AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
             LEFT JOIN Object AS Object_Member_Ins ON Object_Member_Ins.Id = ObjectLink_User_Member.ChildObjectId

             LEFT JOIN tmpPersonal AS tmpPersonal_ins ON tmpPersonal_ins.MemberId = ObjectLink_User_Member.ChildObjectId

             LEFT JOIN Object AS Object_Position_Ins ON Object_Position_Ins.Id = tmpPersonal_ins.PositionId
             LEFT JOIN Object AS Object_Unit_Ins     ON Object_Unit_Ins.Id     = tmpPersonal_ins.UnitId

             LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch_Ins
                                  ON ObjectLink_Unit_Branch_Ins.ObjectId = Object_Unit_Ins.Id
                                 AND ObjectLink_Unit_Branch_Ins.DescId   = zc_ObjectLink_Unit_Branch()
             LEFT JOIN Object AS Object_Branch_Ins ON Object_Branch_Ins.Id = ObjectLink_Unit_Branch_Ins.ChildObjectId

             LEFT JOIN tmpMovementFloat AS MovementFloat_TotalLines
                                        ON MovementFloat_TotalLines.MovementId = tmpData.Id
                                       AND MovementFloat_TotalLines.DescId     = zc_MovementFloat_TotalLines()

             LEFT JOIN tmpMovementFloat AS MovementFloat_TotalPage_1
                                        ON MovementFloat_TotalPage_1.MovementId = tmpData.Id
                                       AND MovementFloat_TotalPage_1.DescId     = zc_MovementFloat_TotalPage_1()
             LEFT JOIN tmpMovementFloat AS MovementFloat_TotalPage_2
                                        ON MovementFloat_TotalPage_2.MovementId = tmpData.MovementId_sale
                                       AND MovementFloat_TotalPage_2.DescId     = zc_MovementFloat_TotalPage_2()
             LEFT JOIN tmpMovementFloat AS MovementFloat_TotalPage_3
                                        ON MovementFloat_TotalPage_3.MovementId = tmpData.MovementId_sale
                                       AND MovementFloat_TotalPage_3.DescId     = zc_MovementFloat_TotalPage_3()
             LEFT JOIN tmpMovementFloat AS MovementFloat_TotalPage_4
                                        ON MovementFloat_TotalPage_4.MovementId = tmpData.Id
                                       AND MovementFloat_TotalPage_4.DescId     = zc_MovementFloat_TotalPage_4()
             LEFT JOIN tmpMovementFloat AS MovementFloat_TotalPage_5
                                        ON MovementFloat_TotalPage_5.MovementId = tmpData.Id
                                       AND MovementFloat_TotalPage_5.DescId     = zc_MovementFloat_TotalPage_5()
             LEFT JOIN tmpMovementFloat AS MovementFloat_TotalPage_6
                                        ON MovementFloat_TotalPage_6.MovementId = tmpData.Id
                                       AND MovementFloat_TotalPage_6.DescId     = zc_MovementFloat_TotalPage_6()
             LEFT JOIN tmpMovementFloat AS MovementFloat_TotalPage_7
                                        ON MovementFloat_TotalPage_7.MovementId = tmpData.Id
                                       AND MovementFloat_TotalPage_7.DescId     = zc_MovementFloat_TotalPage_7()
             LEFT JOIN tmpMovementFloat AS MovementFloat_TotalPage_8
                                        ON MovementFloat_TotalPage_8.MovementId = tmpData.Id
                                       AND MovementFloat_TotalPage_8.DescId     = zc_MovementFloat_TotalPage_8()

        -- WHERE tmpData.MovementDescId = zc_Movement_Sale()
        -- WHERE tmpData.Id = 31267929 
        order by 1, 4, 5
        -- LIMIT 1
   ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.05.25         *
*/
-- тест
-- SELECT * FROM gpReport_PrintForms_byMovement ('01.05.2025','01.05.2025',0,'5')
