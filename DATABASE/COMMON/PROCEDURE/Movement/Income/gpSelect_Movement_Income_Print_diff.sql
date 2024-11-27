-- Function: gpSelect_Movement_Income_Print_diff()

DROP FUNCTION IF EXISTS gpSelect_Movement_Income_Print_diff (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Income_Print_diff(
    IN inMovementId        Integer  , -- ключ Документа
    IN inisActDiff         Boolean  , -- печать акта разногласий
  --  IN inReportType        Integer  , -- 0=out 1=in
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;

    DECLARE vbDescId Integer;
    DECLARE vbStatusId Integer;
    DECLARE vbPriceWithVAT Boolean;
    DECLARE vbVATPercent TFloat;
    DECLARE vbDiscountPercent TFloat;
    DECLARE vbExtraChargesPercent TFloat;
    DECLARE vbChangePercentTo TFloat;
    DECLARE vbPaidKindId Integer;

    DECLARE vbOperSumm_MVAT TFloat;
    DECLARE vbOperSumm_PVAT TFloat;
    DECLARE vbTotalCountKg  TFloat;
    DECLARE vbTotalCountSh  TFloat;

    DECLARE vbGoodsPropertyId Integer;
    DECLARE vbGoodsPropertyId_basis Integer;
    DECLARE vbContractId Integer;
    DECLARE vbIsProcess_BranchIn Boolean;

    DECLARE vbInvNumberPartner TVarChar;
    DECLARE vbOperDate TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income_Print());
     vbUserId:= lpGetUserBySession (inSession);


     -- параметры из документа
     SELECT Movement.DescId
          , Movement.StatusId
          , COALESCE (MovementBoolean_PriceWithVAT.ValueData, TRUE) AS PriceWithVAT
          , COALESCE (MovementFloat_VATPercent.ValueData, 0)        AS VATPercent
          , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) < 0 THEN -MovementFloat_ChangePercent.ValueData ELSE 0 END    AS DiscountPercent
          , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) > 0 THEN MovementFloat_ChangePercent.ValueData ELSE 0 END     AS ExtraChargesPercent
          , COALESCE (MovementFloat_ChangePercentTo.ValueData, 0)   AS ChangePercentTo
          , zfCalc_GoodsPropertyId (MovementLinkObject_Contract.ObjectId, COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MovementLinkObject_To.ObjectId), MovementLinkObject_To.ObjectId) AS GoodsPropertyId
          , zfCalc_GoodsPropertyId (0, zc_Juridical_Basis(), 0)     AS GoodsPropertyId_basis
          , COALESCE (MovementLinkObject_PaidKind.ObjectId, 0)      AS PaidKindId
          , COALESCE (MovementLinkObject_Contract.ObjectId, 0)      AS ContractId
          , Movement.OperDate
          , COALESCE (MovementString_InvNumberPartner.ValueData,'') ::TVarChar AS InvNumberPartner

            INTO vbDescId, vbStatusId, vbPriceWithVAT, vbVATPercent, vbDiscountPercent, vbExtraChargesPercent, vbChangePercentTo, vbGoodsPropertyId, vbGoodsPropertyId_basis, vbPaidKindId, vbContractId
               , vbOperDate, vbInvNumberPartner
     FROM Movement
          LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                    ON MovementBoolean_PriceWithVAT.MovementId = Movement.Id
                                   AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
          LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                  ON MovementFloat_VATPercent.MovementId = Movement.Id
                                 AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
          LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                  ON MovementFloat_ChangePercent.MovementId = Movement.Id
                                 AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                       ON MovementLinkObject_Contract.MovementId = Movement.Id
                                      AND MovementLinkObject_Contract.DescId IN (zc_MovementLinkObject_Contract(), zc_MovementLinkObject_ContractTo())
          LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                       ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                      AND MovementLinkObject_PaidKind.DescId IN (zc_MovementLinkObject_PaidKind(), zc_MovementLinkObject_PaidKindTo())

          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                               ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                              AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()

          LEFT JOIN MovementFloat AS MovementFloat_ChangePercentTo
                                  ON MovementFloat_ChangePercentTo.MovementId = Movement.Id
                                 AND MovementFloat_ChangePercentTo.DescId = zc_MovementFloat_ChangePercentPartner()                              

          LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                   ON MovementString_InvNumberPartner.MovementId = Movement.Id
                                  AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()     
     WHERE Movement.Id = inMovementId
       -- AND Movement.StatusId = zc_Enum_Status_Complete()
    ;

     -- очень важная проверка
    IF COALESCE (vbStatusId, 0) <> zc_Enum_Status_Complete() --OR vbUserId = 5
    THEN
        IF vbStatusId = zc_Enum_Status_Erased() OR vbUserId = 5
        THEN
            RAISE EXCEPTION 'Ошибка.Документ <%> № <%> от <%> удален.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
        END IF;
        IF vbStatusId = zc_Enum_Status_UnComplete()
        THEN
            RAISE EXCEPTION 'Ошибка.Документ <%> № <%> от <%> не проведен.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
        END IF;
        -- это уже странная ошибка
        -- RAISE EXCEPTION 'Ошибка.Документ <%>.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId);
    END IF;



    CREATE TEMP TABLE tmpMovement (Id Integer, OperDate TDateTime) ON COMMIT DROP;
    INSERT INTO  tmpMovement (Id, OperDate)
       SELECT Movement.Id AS Id, Movement.OperDate ::TDateTime AS OperDate
       FROM Movement  
            INNER JOIN MovementString AS MovementString_InvNumberPartner
                                      ON MovementString_InvNumberPartner.MovementId = Movement.Id
                                     AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
                                     AND MovementString_InvNumberPartner.ValueData = vbInvNumberPartner 
                                     AND COALESCE (MovementString_InvNumberPartner.ValueData,'') <> '' 
                                     AND vbInvNumberPartner <> ''                         
       WHERE Movement.OperDate BETWEEN (vbOperDate - INTERVAL '1 DAY')::TDateTime AND vbOperDate
         AND Movement.DescId = zc_Movement_Income()
         AND Movement.StatusId = zc_Enum_Status_Complete()
         AND inisActDiff = TRUE
         AND Movement.Id <> inMovementId
     UNION
       --текущий док, всегда, даже если нет  InvNumberPartner
       SELECT inMovementId AS Id, vbOperDate ::TDateTime  AS OperDate
       ;



      --
    OPEN Cursor1 FOR
    WITH
    tmpMovementFloat AS (SELECT MovementFloat.*
                         FROM MovementFloat
                         WHERE MovementFloat.MovementId = inMovementId
                           AND MovementFloat.DescId IN (zc_MovementFloat_VATPercent()
                                                      , zc_MovementFloat_ChangePercent()
                                                      , zc_MovementFloat_TotalCount()
                                                      , zc_MovementFloat_TotalCountPartner()
                                                      , zc_MovementFloat_TotalCountKg()
                                                      , zc_MovementFloat_TotalCountSh()
                                                      , zc_MovementFloat_TotalSummMVAT()
                                                      , zc_MovementFloat_TotalSummPVAT()
                                                      , zc_MovementFloat_TotalSumm()
                                                      , zc_MovementFloat_TotalSummPacker()
                                                      , zc_MovementFloat_TotalSummSpending()
                                                      , zc_MovementFloat_CurrencyValue()
                                                        )
                         )

  , tmpMovementBoolean AS (SELECT MovementBoolean.*
                           FROM MovementBoolean
                           WHERE MovementBoolean.MovementId = inMovementId
                             AND MovementBoolean.DescId IN (zc_MovementBoolean_isIncome()
                                                          , zc_MovementBoolean_PriceWithVAT()
                                                          )
                         )

  , tmpMovementLinkObject AS (SELECT MovementLinkObject.*
                           FROM MovementLinkObject
                           WHERE MovementLinkObject.MovementId = inMovementId
                         )

  , tmpMovementLinkMovement AS (SELECT MovementLinkMovement.*
                           FROM MovementLinkMovement
                           WHERE MovementLinkMovement.MovementId = inMovementId
                             AND MovementLinkMovement.DescId IN (zc_MovementLinkMovement_Transport()
                                                          )
                         )
  , tmpMovementLinkObject_tr AS (SELECT MovementLinkObject.*
                           FROM MovementLinkObject
                           WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMovementLinkMovement.MovementChildId FROM tmpMovementLinkMovement)
                             AND MovementLinkObject.DescId IN (zc_MovementLinkObject_Car(), zc_MovementLinkObject_PersonalDriver()
                                                          )
                         )

         SELECT
             Movement.Id
           , zfFormat_BarCode (zc_BarCodePref_Movement(), Movement.Id) AS IdBarCode
           , CASE WHEN COALESCE (vbInvNumberPartner,'') <> '' THEN vbInvNumberPartner ELSE Movement.InvNumber END InvNumber
           , Movement.OperDate
           , Object_Status.ObjectCode          AS StatusCode
           , Object_Status.ValueData           AS StatusName

           , MovementDate_OperDatePartner.ValueData    AS OperDatePartner
           , MovementString_InvNumberPartner.ValueData AS InvNumberPartner

           , MovementBoolean_PriceWithVAT.ValueData      AS PriceWithVAT
           , MovementFloat_VATPercent.ValueData          AS VATPercent
           , MovementFloat_ChangePercent.ValueData       AS ChangePercent

           , MovementFloat_TotalCount.ValueData          AS TotalCount
           , MovementFloat_TotalCountPartner.ValueData   AS TotalCountPartner
           , MovementFloat_TotalCountKg.ValueData        AS TotalCountKg
           , MovementFloat_TotalCountSh.ValueData        AS TotalCountSh
           , MovementFloat_TotalSummMVAT.ValueData       AS TotalSummMVAT
           , MovementFloat_TotalSummPVAT.ValueData       AS TotalSummPVAT
           , MovementFloat_TotalSumm.ValueData           AS TotalSumm
           , MovementFloat_TotalSummPacker.ValueData     AS TotalSummPacker
           , MovementFloat_TotalSummSpending.ValueData   AS TotalSummSpending
           , CAST (COALESCE (MovementFloat_TotalSummPVAT.ValueData, 0) - COALESCE (MovementFloat_TotalSummMVAT.ValueData, 0) AS TFloat) AS TotalSummVAT
           , (select Sum (Amount)  from MovementItemContainer where MovementId = inMovementId and DescId = 2 and isactive = True and AccountId <> zc_Enum_Account_100301 ()) AS TotalSummPVAT_To

           , CAST (COALESCE (MovementFloat_CurrencyValue.ValueData, 0) AS TFloat)  AS CurrencyValue

           , Object_From.ValueData             AS FromName
           , Object_To.ValueData               AS ToName
           , Object_PaidKind.ValueData         AS PaidKindName
           , View_Contract_InvNumber.ContractCode AS ContractCode
           , View_Contract_InvNumber.InvNumber AS ContractName
           , ObjectDate_Signing.ValueData      AS ContractSigningDate

           , Object_JuridicalFrom.ValueData    AS JuridicalName_From
           , Object_JuridicalTo.ValueData      AS JuridicalName_To
           , ObjectHistory_JuridicalDetails_View.OKPO AS OKPO_From
           , View_InfoMoney.InfoMoneyGroupName
           , View_InfoMoney.InfoMoneyDestinationName
           , View_InfoMoney.InfoMoneyCode
           , View_InfoMoney.InfoMoneyName
           , Object_Member.Id         AS PersonalPackerId
           , Object_Member.ValueData  AS PersonalPackerName

           , Object_CurrencyDocument.ValueData AS CurrencyDocumentName
           , Object_CurrencyPartner.ValueData  AS CurrencyPartnerName
        
           , CASE WHEN (vbDiscountPercent <> 0 OR vbExtraChargesPercent <> 0) AND vbPaidKindId = zc_Enum_PaidKind_SecondForm()
                        THEN ' та знижкой'
                  ELSE ''
             END AS Price_info

           , COALESCE (MovementBoolean_isIncome.ValueData, TRUE) ::Boolean AS isIncome
 
           , Object_Car.ValueData                        AS CarName
           , Onject_PersonalDriver.ValueData             AS PersonalDriverName
           , Object_Juridical_Car.ValueData              AS JuridicalName_Car 
           , (SELECT MAX(tmpMovement.OperDate)::TDateTime AS OperDate FROM tmpMovement) ::TDateTime AS OperDate_ActDiff         
       FROM Movement
          --  JOIN tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = Movement.AccessKeyId

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId =  Movement.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN tmpMovementBoolean AS MovementBoolean_isIncome
                                         ON MovementBoolean_isIncome.MovementId = Movement.Id
                                        AND MovementBoolean_isIncome.DescId = zc_MovementBoolean_isIncome()

            LEFT JOIN tmpMovementBoolean AS MovementBoolean_PriceWithVAT
                                         ON MovementBoolean_PriceWithVAT.MovementId = Movement.Id
                                        AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()

            LEFT JOIN tmpMovementFloat AS MovementFloat_VATPercent
                                       ON MovementFloat_VATPercent.MovementId =  Movement.Id
                                      AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
            LEFT JOIN tmpMovementFloat AS MovementFloat_ChangePercent
                                       ON MovementFloat_ChangePercent.MovementId =  Movement.Id
                                      AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalCount
                                       ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                      AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()
            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalCountPartner
                                       ON MovementFloat_TotalCountPartner.MovementId =  Movement.Id
                                      AND MovementFloat_TotalCountPartner.DescId = zc_MovementFloat_TotalCountPartner()
            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalCountKg
                                       ON MovementFloat_TotalCountKg.MovementId =  Movement.Id
                                      AND MovementFloat_TotalCountKg.DescId = zc_MovementFloat_TotalCountKg()
            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalCountSh
                                       ON MovementFloat_TotalCountSh.MovementId =  Movement.Id
                                      AND MovementFloat_TotalCountSh.DescId = zc_MovementFloat_TotalCountSh()

            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalSummMVAT
                                       ON MovementFloat_TotalSummMVAT.MovementId =  Movement.Id
                                      AND MovementFloat_TotalSummMVAT.DescId = zc_MovementFloat_TotalSummMVAT()
            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalSummPVAT
                                       ON MovementFloat_TotalSummPVAT.MovementId =  Movement.Id
                                      AND MovementFloat_TotalSummPVAT.DescId = zc_MovementFloat_TotalSummPVAT()
            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalSumm
                                       ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                      AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalSummPacker
                                       ON MovementFloat_TotalSummPacker.MovementId =  Movement.Id
                                      AND MovementFloat_TotalSummPacker.DescId = zc_MovementFloat_TotalSummPacker()
            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalSummSpending
                                       ON MovementFloat_TotalSummSpending.MovementId =  Movement.Id
                                      AND MovementFloat_TotalSummSpending.DescId = zc_MovementFloat_TotalSummSpending()

            LEFT JOIN tmpMovementFloat AS MovementFloat_CurrencyValue
                                       ON MovementFloat_CurrencyValue.MovementId =  Movement.Id
                                      AND MovementFloat_CurrencyValue.DescId = zc_MovementFloat_CurrencyValue()

            LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
            LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_PaidKind
                                         ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                        AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

            LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
            LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = MovementLinkObject_Contract.ObjectId
            LEFT JOIN ObjectDate AS ObjectDate_Signing
                                 ON ObjectDate_Signing.ObjectId = View_Contract_InvNumber.ContractId -- MovementLinkObject_Contract.ObjectId
                                AND ObjectDate_Signing.DescId = zc_ObjectDate_Contract_Signing()
                                AND View_Contract_InvNumber.InvNumber <> '-'

            LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = View_Contract_InvNumber.InfoMoneyId

            LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_PersonalPacker
                                         ON MovementLinkObject_PersonalPacker.MovementId = Movement.Id
                                        AND MovementLinkObject_PersonalPacker.DescId = zc_MovementLinkObject_PersonalPacker()
            LEFT JOIN Object AS Object_Member ON Object_Member.Id = MovementLinkObject_PersonalPacker.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                 ON ObjectLink_Partner_Juridical.ObjectId = Object_From.Id
                                AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
            LEFT JOIN ObjectLink AS ObjectLink_CardFuel_Juridical
                                 ON ObjectLink_CardFuel_Juridical.ObjectId = Object_From.Id
                                AND ObjectLink_CardFuel_Juridical.DescId   = zc_ObjectLink_CardFuel_Juridical()
            LEFT JOIN Object AS Object_JuridicalFrom ON Object_JuridicalFrom.Id = COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, ObjectLink_CardFuel_Juridical.ChildObjectId)
            LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_JuridicalFrom.Id

            LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_CurrencyDocument
                                         ON MovementLinkObject_CurrencyDocument.MovementId = Movement.Id
                                        AND MovementLinkObject_CurrencyDocument.DescId = zc_MovementLinkObject_CurrencyDocument()
            LEFT JOIN Object AS Object_CurrencyDocument ON Object_CurrencyDocument.Id = MovementLinkObject_CurrencyDocument.ObjectId

            LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_CurrencyPartner
                                         ON MovementLinkObject_CurrencyPartner.MovementId = Movement.Id
                                        AND MovementLinkObject_CurrencyPartner.DescId = zc_MovementLinkObject_CurrencyPartner()
            LEFT JOIN Object AS Object_CurrencyPartner ON Object_CurrencyPartner.Id = MovementLinkObject_CurrencyPartner.ObjectId
            
            LEFT JOIN ObjectLink AS ObjectLink_To_Juridical
                                 ON ObjectLink_To_Juridical.ObjectId = Object_To.Id
                                AND ObjectLink_To_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
            LEFT JOIN Object AS Object_JuridicalTo ON Object_JuridicalTo.Id = ObjectLink_To_Juridical.ChildObjectId

            --
            LEFT JOIN tmpMovementLinkMovement AS MovementLinkMovement_Transport
                                           ON MovementLinkMovement_Transport.MovementId = Movement.Id
                                          AND MovementLinkMovement_Transport.DescId = zc_MovementLinkMovement_Transport()
            --LEFT JOIN Movement AS Movement_Transport ON Movement_Transport.Id = MovementLinkMovement_Transport.MovementChildId
  
            LEFT JOIN tmpMovementLinkObject_tr AS MovementLinkObject_Car
                                         ON MovementLinkObject_Car.MovementId =MovementLinkMovement_Transport.MovementChildId
                                        AND MovementLinkObject_Car.DescId = zc_MovementLinkObject_Car()
            LEFT JOIN Object AS Object_Car ON Object_Car.Id = MovementLinkObject_Car.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Car_Juridical
                                 ON ObjectLink_Car_Juridical.ObjectId = Object_Car.Id
                                AND ObjectLink_Car_Juridical.DescId = zc_ObjectLink_Car_Juridical()
            LEFT JOIN Object AS Object_Juridical_Car ON Object_Juridical_Car.Id = ObjectLink_Car_Juridical.ChildObjectId    

            LEFT JOIN tmpMovementLinkObject_tr AS MovementLinkObject_PersonalDriver
                                         ON MovementLinkObject_PersonalDriver.MovementId = MovementLinkMovement_Transport.MovementChildId
                                        AND MovementLinkObject_PersonalDriver.DescId = zc_MovementLinkObject_PersonalDriver()
            LEFT JOIN Object AS Onject_PersonalDriver ON Onject_PersonalDriver.Id = MovementLinkObject_PersonalDriver.ObjectId
                           
      WHERE Movement.Id = inMovementId
         AND Movement.DescId = zc_Movement_Income();
     
    RETURN NEXT Cursor1;


    OPEN Cursor2 FOR
        WITH -- Док. Взвешивание - данные Поставщика
             tmpMI_partner AS (SELECT gpSelect.GoodsCode, gpSelect.GoodsName
                                    , gpSelect.GoodsKindName
                                    , gpSelect.MeasureName TVarChar
                                      -- Кол-во Поставшик с учетом % скидки кол-во
                                    , gpSelect.Amount_income_calc
                                      -- Количество Поставщика
                                    , gpSelect.Amount_income_calc
                                      -- Количество Поставщика
                                    , gpSelect.AmountPartnerSecond
                                      --
                                    , gpSelect.PricePartnerNoVAT
                                    , gpSelect.PricePartnerWVAT
 
                               FROM gpSelect_MI_WeighingPartner_diff (inMovementId, FALSE, inSession) AS gpSelect
                              )
       SELECT COALESCE (Object_GoodsByGoodsKind_View.Id, Object_Goods.Id) AS Id
           , Object_Goods.ObjectCode         AS GoodsCode
           , (Object_Goods.ValueData || CASE WHEN COALESCE (Object_GoodsKind.Id, zc_Enum_GoodsKind_Main()) = zc_Enum_GoodsKind_Main() THEN '' ELSE ' ' || Object_GoodsKind.ValueData END) :: TVarChar AS GoodsName
           , Object_Goods.ValueData          AS GoodsName_two
           , Object_GoodsKind.ValueData      AS GoodsKindName
           , Object_Measure.ValueData        AS MeasureName
           , tmpMI.Amount                    AS Amount
           , tmpMI.AmountPartner             AS AmountPartner
           , tmpMI.AmountPartnerSecond       AS AmountPartnerSecond
           , tmpMI.AmountPacker              AS AmountPacker
          
           , tmpMI.Price                     AS Price
           , tmpMI.PricePartner              AS PricePartner
           , tmpMI.CountForPrice             AS CountForPrice

           , CASE WHEN tmpMI.Amount = 0
                       THEN 0
                  WHEN tmpMI.CountForPrice <> 0
                       THEN CAST (tmpMI.AmountPartner * (tmpMI.Price / tmpMI.CountForPrice) AS NUMERIC (16, 2)) / tmpMI.Amount
                  ELSE CAST (tmpMI.AmountPartner * tmpMI.Price AS NUMERIC (16, 2)) / tmpMI.Amount
             END AS Price2


             -- сумма по ценам док-та
           , CASE WHEN tmpMI.CountForPrice <> 0
                       THEN CAST (tmpMI.AmountPartner * (tmpMI.Price / tmpMI.CountForPrice) AS NUMERIC (16, 2))
                  ELSE CAST (tmpMI.AmountPartner * tmpMI.Price AS NUMERIC (16, 2))
             END AS AmountSumm

             -- расчет цены без НДС, до 4 знаков
           , CASE WHEN vbPriceWithVAT = TRUE
                  THEN CAST (tmpMI.Price - tmpMI.Price * (vbVATPercent / (vbVATPercent + 100)) AS NUMERIC (16, 2))
                  ELSE tmpMI.Price
             END  / CASE WHEN tmpMI.CountForPrice <> 0 THEN tmpMI.CountForPrice ELSE 1 END
             AS PriceNoVAT

             -- расчет цены с НДС, до 4 знаков
           , CASE WHEN vbPriceWithVAT <> TRUE
                  THEN CAST ((tmpMI.Price + tmpMI.Price * (vbVATPercent / 100))
                                         * CASE WHEN vbDiscountPercent <> 0 AND vbPaidKindId = zc_Enum_PaidKind_SecondForm() -- !!!для НАЛ учитываем!!!
                                                     THEN (1 - vbDiscountPercent / 100)
                                                WHEN vbExtraChargesPercent <> 0 AND vbPaidKindId = zc_Enum_PaidKind_SecondForm() -- !!!для НАЛ учитываем!!!
                                                     THEN (1 + vbExtraChargesPercent / 100)
                                                ELSE 1
                                           END
                             AS NUMERIC (16, 4))
                  ELSE CAST (tmpMI.Price * CASE WHEN vbDiscountPercent <> 0 AND vbPaidKindId = zc_Enum_PaidKind_SecondForm() -- !!!для НАЛ не учитываем!!!
                                                     THEN (1 - vbDiscountPercent / 100)
                                                WHEN vbExtraChargesPercent <> 0 AND vbPaidKindId = zc_Enum_PaidKind_SecondForm() -- !!!для НАЛ не учитываем!!!
                                                     THEN (1 + vbExtraChargesPercent / 100)
                                                ELSE 1
                                           END
                             AS NUMERIC (16, 4))
             END / CASE WHEN tmpMI.CountForPrice <> 0 THEN tmpMI.CountForPrice ELSE 1 END
             AS PriceWVAT

             -- расчет суммы без НДС, до 2 знаков
           , CAST (tmpMI.AmountPartner * CASE WHEN vbPriceWithVAT = TRUE
                                              THEN (tmpMI.Price - tmpMI.Price * (vbVATPercent / 100))
                                              ELSE tmpMI.Price
                                         END / CASE WHEN tmpMI.CountForPrice <> 0 THEN tmpMI.CountForPrice ELSE 1 END
                   AS NUMERIC (16, 2)) AS AmountSummNoVAT

             -- расчет суммы с НДС, до 3 знаков
           , CAST (tmpMI.AmountPartner * CASE WHEN vbPriceWithVAT <> TRUE
                                              THEN tmpMI.Price + tmpMI.Price * (vbVATPercent / 100)
                                              ELSE tmpMI.Price
                                         END / CASE WHEN tmpMI.CountForPrice <> 0 THEN tmpMI.CountForPrice ELSE 1 END
                   AS NUMERIC (16, 3)) AS AmountSummWVAT

           , CAST ((tmpMI.AmountPartner * (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END )) AS TFloat) AS Amount_Weight
--           , CAST ((CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpMI.AmountPartner ELSE 0 END) AS TFloat) AS Amount_Sh

             -- расчет цены C НДС покупателя , до 4 знаков, для  (с учетом скидки)
           , CASE WHEN vbPriceWithVAT <> TRUE
                  THEN CAST ((tmpMI.PriceOriginal + tmpMI.PriceOriginal * (vbVATPercent / 100))
                                         * CASE WHEN vbChangePercentTo <> 0 
                                                     THEN (1 + vbChangePercentTo / 100)
                                                ELSE 1
                                           END
                             AS NUMERIC (16, 4))
                  ELSE CAST (tmpMI.PriceOriginal * CASE WHEN vbChangePercentTo <> 0
                                                             THEN (1 + vbChangePercentTo / 100)
                                                        ELSE 1
                                                   END
                             AS NUMERIC (16, 4))
             END   AS PriceWVAT_To
   
           , vbChangePercentTo
  
           --для акта несоответствия 
           -- расчет цены поставщика без НДС, до 4 знаков
           , CASE WHEN vbPriceWithVAT = TRUE
                  THEN CAST (tmpMI.PricePartner - tmpMI.PricePartner * (vbVATPercent / (vbVATPercent + 100)) AS NUMERIC (16, 2))
                  ELSE tmpMI.PricePartner
             END  / CASE WHEN tmpMI.CountForPrice <> 0 THEN tmpMI.CountForPrice ELSE 1 END
             AS PricePartnerNoVAT

             -- расчет цены поставщика с НДС, до 4 знаков
           , CASE WHEN vbPriceWithVAT <> TRUE
                  THEN CAST ((tmpMI.PricePartner + tmpMI.PricePartner * (vbVATPercent / 100) ) AS NUMERIC (16, 4))
                  ELSE CAST (tmpMI.PricePartner AS NUMERIC (16, 4))
             END / CASE WHEN tmpMI.CountForPrice <> 0 THEN tmpMI.CountForPrice ELSE 1 END
             AS PricePartnerWVAT 
             
           , COALESCE (tmpGoods_WeighingPartner.isReturnOut, FALSE) ::Boolean  AS isReturnOut
           , COALESCE (tmpGoods_WeighingPartner.Comment,'')         ::TVarChar AS Comment
    
       FROM tmpMI

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                  ON ObjectFloat_Weight.ObjectId = Object_Goods.Id
                                 AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMI.GoodsKindId

            LEFT JOIN Object_GoodsByGoodsKind_View ON Object_GoodsByGoodsKind_View.GoodsId = Object_Goods.Id
                                                  AND Object_GoodsByGoodsKind_View.GoodsKindId = Object_GoodsKind.Id
            LEFT JOIN tmpGoods_WeighingPartner ON tmpGoods_WeighingPartner.GoodsId = tmpMI.GoodsId
                                              AND COALESCE (tmpGoods_WeighingPartner.GoodsKindId,0) = COALESCE (tmpMI.GoodsKindId,0)
       WHERE tmpMI.AmountPartner <> 0 OR tmpMI.AmountPacker <> 0
       ORDER BY Object_Goods.ValueData, Object_GoodsKind.ValueData

       ;

    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.01.20         *
 05.06.15         * 
*/

-- тест
-- SELECT * FROM gpSelect_Movement_Income_Print_diff (inMovementId := 432692, inSession:= '5'); FETCH ALL "<unnamed portal 10>";

--  select * from gpSelect_Movement_Income_Print_diff(inMovementId := 432692 , inisActDiff := 'True' ,  inSession := '9457');FETCH ALL "<unnamed portal 8>";

/*

    isDiff := (SELECT 1
               FROM MovementItem
                    LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                 ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                                -- AND MIFloat_Price.ValueData <> 0
                    LEFT JOIN MovementItemFloat AS MIFloat_PricePartner
                                                ON MIFloat_PricePartner.MovementItemId = MovementItem.Id
                                               AND MIFloat_PricePartner.DescId = zc_MIFloat_PricePartner() 
                   LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                               AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
  
                    LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                     ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                    AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
               WHERE MovementItem.MovementId = 432692
                 AND MovementItem.DescId     = zc_MI_Master()
                 AND MovementItem.isErased   = FALSE  
               GROUP BY MovementItem.ObjectId
                      , MILinkObject_GoodsKind.ObjectId 
                      , COALESCE (MIFloat_Price.ValueData, 0)    
                      , COALESCE (MIFloat_PricePartner.ValueData,0)        
               HAVING ((COALESCE (MIFloat_Price.ValueData, 0)<> COALESCE (MIFloat_PricePartner.ValueData,0))
                     OR
                      (SUM (MovementItem.Amount) <> SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0))))
               limit 1
               )

*/
