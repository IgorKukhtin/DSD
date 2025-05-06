-- Function: gpReport_PrintForms_byMovement (TDateTime, TDateTime, TVarChar)

DROP FUNCTION IF EXISTS gpReport_PrintForms_byMovement (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_PrintForms_byMovement(
    IN inStartDate   TDateTime , -- 
    IN inEndDate     TDateTime , --
    IN inMovementDescId Integer,
    IN inSession     TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, Invnumber TVarChar, OperDate TDateTime
             , MovementDescName TVarChar
             , TotalLines TFloat 
             , TotalPage_1 TFloat, TotalPage_2 TFloat, TotalPage_3 TFloat, TotalPage_4 TFloat
             , TotalPage_5 TFloat, TotalPage_6 TFloat, TotalPage_7 TFloat, TotalPage_8 TFloat
             , FormPrintName TVarChar
             , InsertName TVarChar, BranchName_Ins TVarChar
             , UnitCode_Ins Integer, UnitName_Ins TVarChar
             , PositionName_Ins TVarChar 
             , PrintKindId Integer, PrintKindName TVarChar
             , FromId Integer, FromName  TVarChar
             , ToId Integer, ToName TVarChar
             , JuridicalId Integer, JuridicalName TVarChar
             , RetailName TVarChar
             , MovementId_sale Integer             
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- Результат
   RETURN QUERY 
    WITH 
    tmpMovementDesc AS (
                        SELECT MovementDesc.*
                        FROM MovementDesc
                        WHERE MovementDesc.Id IN (zc_Movement_Income()
                                                , zc_Movement_Loss()
                                                , zc_Movement_OrderExternal()
                                                , zc_Movement_ReturnIn()
                                                , zc_Movement_ReturnOut()
                                                , zc_Movement_Sale()
                                                , zc_Movement_Send()
                                                , zc_Movement_SendOnPrice()
                                                , zc_Movement_TransportGoods()
                                                , zc_Movement_QualityDoc()
                                                --, zc_Movement_()
                                                 )
                        )

  , tmpPrintForms_View AS (SELECT *
                           FROM PrintForms_View
                           )

  , tmpJuridical_PrintKindItem AS (WITH
                                   tmpPrintKindItem AS (SELECT * FROM lpSelect_Object_PrintKindItem ())
                                   SELECT Object_Juridical.Id AS JuridicalId
                                        , tmpPrintKindItem.isMovement          --+
                                        , tmpPrintKindItem.isAccount           --+
                                        , tmpPrintKindItem.isTransport
                                        , tmpPrintKindItem.isQuality           --+
                                        , tmpPrintKindItem.isPack
                                        , tmpPrintKindItem.isSpec
                                        , tmpPrintKindItem.isTax
                                        , tmpPrintKindItem.isTransportBill
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
                          , CASE WHEN tmpMovementDesc.Id = zc_Movement_Income() THEN 'PrintMovement_Income'
                                 WHEN tmpMovementDesc.Id = zc_Movement_Loss() THEN 'PrintMovement_Loss'
                                 WHEN tmpMovementDesc.Id = zc_Movement_OrderExternal() THEN 'PrintMovement_OrderExternal'
                                 WHEN tmpMovementDesc.Id = zc_Movement_ReturnOut() THEN 'PrintMovement_ReturnOut'
                                 WHEN tmpMovementDesc.Id = zc_Movement_Send() THEN 'PrintMovement_Send'
                                 WHEN tmpMovementDesc.Id = zc_Movement_SendOnPrice() THEN 'PrintMovement_SendOnPrice'
                                 ELSE NULL
                            END  AS PrintFormName
                            , zc_Enum_PrintKind_Movement() AS PrintKindId
                     FROM tmpMovementDesc
                     WHERE tmpMovementDesc.Id = inMovementDescId OR inMovementDescId = 0
                    )
  , tmpMovement AS (SELECT Movement.*
                    FROM Movement
                    WHERE Movement.DescId IN (SELECT DISTINCT tmpPrintForm.MovementDescId FROM tmpPrintForm)
                      AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                    )
  , tmpMLO AS (SELECT MovementLinkObject.*
               FROM MovementLinkObject
               WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
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
               WHERE MovementLinkMovement.MovementChildId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                 AND MovementLinkMovement.DescId IN (zc_MovementLinkMovement_TransportGoods()
                                                   )
               )

  , tmpMovementDate AS (SELECT MovementDate.*
                        FROM MovementDate
                        WHERE MovementDate.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                          AND MovementDate.DescId IN (zc_MovementDate_OperDatePartner()
                                                            )
                        )
  , tmpMovementFloat AS (SELECT MovementFloat.*
                         FROM MovementFloat
                         WHERE MovementFloat.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
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
                           WHERE MovementBoolean.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                             AND MovementBoolean.DescId IN (zc_MovementBoolean_PriceWithVAT()
                                                               )
                           )


  , tmpSale AS (SELECT Movement.Id                   ::Integer
                     , Movement.Invnumber            ::TVarChar 
                     , Movement.OperDate             ::TDateTime
                     , tmpPrintForm.MovementDescName ::TVarChar 
                     , MovementLinkObject_Insert.ObjectId AS InsertId
                     , zc_Enum_PrintKind_Movement() AS PrintKindId

                     , MovementLinkObject_From.ObjectId AS FromId
                     , Object_From.ValueData            AS FromName
                     , MovementLinkObject_To.ObjectId   AS ToId
                     , Object_To.ValueData              AS ToName
                     , COALESCE( ObjectLink_Partner_Juridical.ChildObjectId, MovementLinkObject_To.ObjectId)  AS JuridicalId
                     , ObjectLink_Juridical_Retail.ChildObjectId  AS RetailId
                     , MovementLinkObject_PaidKind.ObjectId       AS PaidKindId
                     , tmpPrintKindItem.isMovement
                     , tmpPrintKindItem.isAccount
                     , tmpPrintKindItem.isTransport
                     , tmpPrintKindItem.isQuality
                     , tmpPrintKindItem.isPack
                     , tmpPrintKindItem.isSpec
                     , tmpPrintKindItem.isTax
                     , tmpPrintKindItem.isTransportBill
                FROM tmpMovement AS Movement
                    LEFT JOIN tmpPrintForm ON tmpPrintForm.MovementDescId = Movement.DescId
                    LEFT JOIN tmpMLO AS MovementLinkObject_Insert
                                     ON MovementLinkObject_Insert.MovementId = Movement.Id
                                    AND MovementLinkObject_Insert.DescId = zc_MovementLinkObject_Insert()
             
                    LEFT JOIN tmpMLO AS MovementLinkObject_From
                                     ON MovementLinkObject_From.MovementId = Movement.Id
                                    AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                    LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

                    LEFT JOIN tmpMLO AS MovementLinkObject_To
                                     ON MovementLinkObject_To.MovementId = Movement.Id
                                    AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                    LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

                    LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                         ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                                        AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()

                    LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                         ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                        AND ObjectLink_Juridical_Retail.DescId   = zc_ObjectLink_Juridical_Retail()

                   LEFT JOIN tmpMLO AS MovementLinkObject_PaidKind
                                    ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                   AND MovementLinkObject_PaidKind.DescId IN (zc_MovementLinkObject_PaidKind(), zc_MovementLinkObject_PaidKindTo())

                   LEFT JOIN tmpJuridical_PrintKindItem AS tmpPrintKindItem ON tmpPrintKindItem.JuridicalId = COALESCE( ObjectLink_Partner_Juridical.ChildObjectId, MovementLinkObject_To.ObjectId)
                WHERE Movement.DescId = zc_Movement_Sale()
                )

  , tmpData AS (
                SELECT Movement.Id                   ::Integer
                     , Movement.Invnumber            ::TVarChar 
                     , Movement.OperDate             ::TDateTime
                     , tmpPrintForm.MovementDescName ::TVarChar 
                     , tmpPrintForm.PrintFormName ::TVarChar AS PrintFormName
                     , tmpPrintForm.PrintKindId
                     , MovementLinkObject_Insert.ObjectId AS InsertId
                     , MovementLinkObject_From.ObjectId AS FromId
                     , Object_From.ValueData            AS FromName
                     , MovementLinkObject_To.ObjectId   AS ToId
                     , Object_To.ValueData              AS ToName
                     , ObjectLink_Partner_Juridical.ChildObjectId AS JuridicalId
                     , ObjectLink_Juridical_Retail.ChildObjectId  AS RetailId
                     , 0 ::Integer AS MovementId_sale 
                FROM tmpMovement AS Movement
                     LEFT JOIN tmpPrintForm ON tmpPrintForm.MovementDescId = Movement.DescId 
             
                     LEFT JOIN tmpMLO AS MovementLinkObject_Insert
                                      ON MovementLinkObject_Insert.MovementId = Movement.Id
                                     AND MovementLinkObject_Insert.DescId = zc_MovementLinkObject_Insert()

                     LEFT JOIN tmpMLO AS MovementLinkObject_To
                                      ON MovementLinkObject_To.MovementId = Movement.Id
                                     AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                     LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

                     LEFT JOIN tmpMLO AS MovementLinkObject_From
                                      ON MovementLinkObject_From.MovementId = Movement.Id
                                     AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                     LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

                     LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                          ON ObjectLink_Partner_Juridical.ObjectId = CASE WHEN Object_To.DescId <> zc_Object_Unit() THEN MovementLinkObject_To.ObjectId ELSE MovementLinkObject_From.ObjectId END
                                         AND ObjectLink_Partner_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()

                     LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                          ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                         AND ObjectLink_Juridical_Retail.DescId   = zc_ObjectLink_Juridical_Retail()

                WHERE Movement.DescId NOT IN (zc_Movement_TransportGoods(), zc_Movement_Sale(), zc_Movement_ReturnIn()) 
             UNION 
                SELECT Movement.Id                   ::Integer
                     , Movement.Invnumber            ::TVarChar 
                     , Movement.OperDate             ::TDateTime
                     , tmpPrintForm.MovementDescName ::TVarChar 
                     , COALESCE (PrintForms_View.PrintFormName, 'PrintMovement_TTN_03012025') ::TVarChar AS PrintFormName
                     , zc_Enum_PrintKind_Movement() AS PrintKindId
                     , MovementLinkObject_Insert.ObjectId AS InsertId
                     , MovementLinkObject_From.ObjectId AS FromId
                     , Object_From.ValueData            AS FromName
                     , MovementLinkObject_To.ObjectId   AS ToId
                     , Object_To.ValueData              AS ToName
                     , COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MovementLinkObject_To.ObjectId) AS JuridicalId
                     , ObjectLink_Juridical_Retail.ChildObjectId  AS RetailId
                     , MovementLinkMovement_TransportGoods.MovementId AS MovementId_sale  
                FROM tmpMovement AS Movement
                      LEFT JOIN tmpPrintForm ON tmpPrintForm.MovementDescId = Movement.DescId
             
                      LEFT JOIN tmpMLO AS MovementLinkObject_Insert
                                       ON MovementLinkObject_Insert.MovementId = Movement.Id
                                      AND MovementLinkObject_Insert.DescId = zc_MovementLinkObject_Insert()
              
                      LEFT JOIN tmpMovementDate AS MovementDate_OperDatePartner
                                                ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                               AND MovementDate_OperDatePartner.DescId     = zc_MovementDate_OperDatePartner()
          
                      LEFT JOIN tmpMLM AS MovementLinkMovement_TransportGoods
                                       ON MovementLinkMovement_TransportGoods.MovementChildId = Movement.Id 
                                      AND MovementLinkMovement_TransportGoods.DescId = zc_MovementLinkMovement_TransportGoods()
          
                      LEFT JOIN tmpMLO AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = COALESCE (MovementLinkMovement_TransportGoods.MovementId, Movement.Id)
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                      LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
          
                      LEFT JOIN tmpMLO AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = COALESCE (MovementLinkMovement_TransportGoods.MovementId, Movement.Id)
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
                --Качественное
                SELECT Movement.Id                   ::Integer
                     , Movement.Invnumber            ::TVarChar 
                     , Movement.OperDate             ::TDateTime
                     , tmpPrintForm.MovementDescName ::TVarChar 
                     ,  COALESCE (PrintForms_View.PrintFormName, 'PrintMovement_Quality') ::TVarChar AS PrintFormName
                     , zc_Enum_PrintKind_Quality() AS PrintKindId 
                     , MovementLinkObject_Insert.ObjectId AS InsertId
                     , MovementLinkObject_From.ObjectId AS FromId
                     , Object_From.ValueData            AS FromName
                     , MovementLinkObject_To.ObjectId   AS ToId
                     , Object_To.ValueData              AS ToName
                     , ObjectLink_Partner_Juridical.ChildObjectId AS JuridicalId
                     , ObjectLink_Juridical_Retail.ChildObjectId  AS RetailId
                     , MovementLinkMovement_Child.MovementChildId ::Integer AS MovementId_sale 

                FROM tmpMovement AS Movement
                      LEFT JOIN tmpPrintForm ON tmpPrintForm.MovementDescId = Movement.DescId

                      LEFT JOIN tmpMLO AS MovementLinkObject_Insert
                                       ON MovementLinkObject_Insert.MovementId = Movement.Id
                                      AND MovementLinkObject_Insert.DescId = zc_MovementLinkObject_Insert()

                      LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Child
                                                     ON MovementLinkMovement_Child.MovementId = Movement.Id 
                                                    AND MovementLinkMovement_Child.DescId = zc_MovementLinkMovement_Child()

                      LEFT JOIN tmpMLO AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = MovementLinkMovement_Child.MovementChildId
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                      LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

                     /* LEFT JOIN tmpMLO AS MovementLinkObject_Contract
                                       ON MovementLinkObject_Contract.MovementId = MovementLinkMovement_Child.MovementChildId
                                      AND MovementLinkObject_Contract.DescId     = zc_MovementLinkObject_Contract()
                      LEFT JOIN ObjectLink AS ObjectLink_Contract_InfoMoney
                                           ON ObjectLink_Contract_InfoMoney.ObjectId = MovementLinkObject_Contract.ObjectId
                                          AND ObjectLink_Contract_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()
                      */
                      LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                           ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                                          AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                      LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                           ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                          AND ObjectLink_Juridical_Retail.DescId   = zc_ObjectLink_Juridical_Retail()

                      LEFT JOIN tmpMLO AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = MovementLinkMovement_Child.MovementChildId
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                      LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

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
                --Продажи 
                SELECT Movement.Id                   ::Integer
                     , Movement.Invnumber            ::TVarChar 
                     , Movement.OperDate             ::TDateTime
                     , Movement.MovementDescName ::TVarChar 
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
                     , Movement.PrintKindId
                     , Movement.InsertId
                     , Movement.FromId
                     , Movement.FromName
                     , Movement.ToId
                     , Movement.ToName
                     , Movement.JuridicalId
                     , Movement.RetailId
                     , 0 ::Integer AS MovementId_sale
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

                WHERE Movement.isMovement = TRUE
             UNION
                -- Счет
                SELECT Movement.Id                   ::Integer
                     , Movement.Invnumber            ::TVarChar 
                     , Movement.OperDate             ::TDateTime
                     , Movement.MovementDescName     ::TVarChar
                     , COALESCE (PrintForms_View.PrintFormName, PrintForms_View_Default.PrintFormName) ::TVarChar AS PrintFormName
                     , zc_Enum_PrintKind_Account() AS PrintKindId  
                     , Movement.InsertId
                     , Movement.FromId
                     , Movement.FromName
                     , Movement.ToId
                     , Movement.ToName
                     , Movement.JuridicalId
                     , Movement.RetailId
                     , 0 ::Integer AS MovementId_sale
                     
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
                -- Упаковочный
                SELECT Movement.Id                   ::Integer
                     , Movement.Invnumber            ::TVarChar 
                     , Movement.OperDate             ::TDateTime
                     , Movement.MovementDescName     ::TVarChar
                     , 'PrintMovement_SalePack' ::TVarChar AS PrintFormName
                     , zc_Enum_PrintKind_Pack() AS PrintKindId
                     , Movement.InsertId
                     , Movement.FromId
                     , Movement.FromName
                     , Movement.ToId
                     , Movement.ToName
                     , Movement.JuridicalId
                     , Movement.RetailId
                     , 0 ::Integer AS MovementId_sale
                FROM tmpSale AS Movement
                WHERE Movement.isPack = TRUE             
             UNION
                -- Возвраты
                SELECT Movement.Id                   ::Integer
                     , Movement.Invnumber            ::TVarChar 
                     , Movement.OperDate             ::TDateTime
                     , tmpPrintForm.MovementDescName ::TVarChar 
                     , COALESCE (PrintForms_View.PrintFormName, PrintForms_View_Default.PrintFormName) ::TVarChar AS PrintFormName
                     , tmpPrintForm.PrintKindId
                     , MovementLinkObject_Insert.ObjectId AS InsertId
                     , MovementLinkObject_From.ObjectId AS FromId
                     , Object_From.ValueData            AS FromName
                     , MovementLinkObject_To.ObjectId   AS ToId
                     , Object_To.ValueData              AS ToName
                     , ObjectLink_Partner_Juridical.ChildObjectId AS JuridicalId
                     , ObjectLink_Juridical_Retail.ChildObjectId  AS RetailId
                     , 0 ::Integer AS MovementId_sale
                FROM tmpMovement AS Movement
                    LEFT JOIN tmpPrintForm ON tmpPrintForm.MovementDescId = Movement.DescId
                    LEFT JOIN tmpMLO AS MovementLinkObject_Insert
                                     ON MovementLinkObject_Insert.MovementId = Movement.Id
                                    AND MovementLinkObject_Insert.DescId = zc_MovementLinkObject_Insert()
             
                    LEFT JOIN tmpMLO AS MovementLinkObject_From
                                     ON MovementLinkObject_From.MovementId = Movement.Id
                                    AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                    LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

                    LEFT JOIN tmpMLO AS MovementLinkObject_To
                                     ON MovementLinkObject_To.MovementId = Movement.Id
                                    AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                    LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId


                    LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                           ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                          AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()

                    LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                         ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                        AND ObjectLink_Juridical_Retail.DescId   = zc_ObjectLink_Juridical_Retail()
             
                    LEFT JOIN tmpPrintForms_View AS PrintForms_View
                           ON Movement.OperDate BETWEEN PrintForms_View.StartDate AND PrintForms_View.EndDate
                          AND PrintForms_View.JuridicalId = COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MovementLinkObject_From.ObjectId)
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
             , tmpData.Invnumber           ::TVarChar 
             , tmpData.OperDate            ::TDateTime
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

             , tmpData.PrintFormName       ::TVarChar AS PrintFormName
             , Object_Insert.ValueData     ::TVarChar AS InsertName
             , Object_Branch.ValueData     ::TVarChar AS BranchName_Ins
             , Object_Unit.ObjectCode      ::Integer  AS UnitCode_Ins
             , Object_Unit.ValueData       ::TVarChar AS UnitName_Ins
             , Object_Position.ValueData   ::TVarChar AS PositionName_Ins
       
             , Object_PrintKind.Id         ::Integer  AS PrintKindId
             , Object_PrintKind.ValueData  ::TVarChar AS PrintKindName
             , tmpData.FromId              ::Integer
             , tmpData.FromName            ::TVarChar
             , tmpData.ToId                ::Integer
             , tmpData.ToName              ::TVarChar
             , Object_Juridical.Id         ::Integer  AS JuridicalId
             , Object_Juridical.ValueData  ::TVarChar AS JuridicalName
             , Object_Retail.ValueData     ::TVarChar AS RetailName
             , tmpData.MovementId_sale ::Integer AS MovementId_sale --для ттн
        FROM tmpData
             LEFT JOIN Object AS Object_Insert    ON Object_Insert.Id = tmpData.InsertId              
             LEFT JOIN Object AS Object_PrintKind ON Object_PrintKind.Id = tmpData.PrintKindId
             LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpData.JuridicalId
             LEFT JOIN Object AS Object_Retail    ON Object_Retail.Id = tmpData.RetailId
             --
             LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                  ON ObjectLink_User_Member.ObjectId = Object_Insert.Id
                                 AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
             LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_User_Member.ChildObjectId

             LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = ObjectLink_User_Member.ChildObjectId
             LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpPersonal.PositionId
             LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpPersonal.UnitId
             LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                                  ON ObjectLink_Unit_Branch.ObjectId = Object_Unit.Id
                                 AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
             LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_Unit_Branch.ChildObjectId

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

        order by 1,4, 5
 
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
 --SELECT * FROM gpReport_PrintForms_byMovement ('30.04.2025','01.05.2025',zc_Movement_ReturnIn(),'5') 
 