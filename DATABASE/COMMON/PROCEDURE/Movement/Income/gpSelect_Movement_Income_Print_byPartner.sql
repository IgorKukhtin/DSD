-- Function: gpSelect_Movement_Income_Print_byPartner()

DROP FUNCTION IF EXISTS gpSelect_Movement_Income_Print_byPartner (Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_Income_Print_byPartner (Integer, TDateTime, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_Income_Print_byPartner (Integer, Integer, Integer, TDateTime, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_Income_Print_byPartner (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Income_Print_byPartner(
    IN inMovementId        Integer  , -- ключ Документа  WeighingPartner
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;

    DECLARE vbContractId        Integer  ;
    DECLARE vbPaidKindId        Integer  ;
    DECLARE vbPartnerId         Integer  ;
    DECLARE vbOperDate          TDateTime;
    DECLARE vbInvNumberPartner  TVarChar ;

    DECLARE vbDescId Integer;
    DECLARE vbStatusId Integer;
    DECLARE vbPriceWithVAT Boolean;
    DECLARE vbVATPercent TFloat;
    DECLARE vbDiscountPercent TFloat;
    DECLARE vbExtraChargesPercent TFloat;
    DECLARE vbChangePercentTo TFloat;

    DECLARE vbGoodsPropertyId Integer;
    DECLARE vbGoodsPropertyId_basis Integer;
    DECLARE vbIsProcess_BranchIn Boolean;
    DECLARE vbMovementId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income_Print());
     vbUserId:= lpGetUserBySession (inSession);

       SELECT Movement.OperDate
            , MLO_Contract.ObjectId
            , MLO_PaidKind.ObjectId
            , MovementLinkObject_From.ObjectId
            , MovementString_InvNumberPartner.ValueData
              INTO vbOperDate
                 , vbContractId
                 , vbPaidKindId
                 , vbPartnerId
                 , vbInvNumberPartner

       FROM Movement
            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId = Movement.Id
                                    AND MovementString_InvNumberPartner.DescId     = zc_MovementString_InvNumberPartner()
            LEFT JOIN MovementLinkObject AS MLO_Contract
                                         ON MLO_Contract.MovementId = Movement.Id
                                       AND MLO_Contract.DescId     = zc_MovementLinkObject_Contract()
            LEFT JOIN MovementLinkObject AS MLO_PaidKind
                                         ON MLO_PaidKind.MovementId = Movement.Id
                                        AND MLO_PaidKind.DescId     = zc_MovementLinkObject_PaidKind()
            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Movement AS Movement_WeighingPartner
                               ON Movement_WeighingPartner.ParentId = Movement.Id
                              AND Movement_WeighingPartner.DescId   = zc_Movement_WeighingPartner()
       WHERE Movement.Id       = inMovementId
       --AND Movement.DescId   = zc_Movement_WeighingPartner()
       --AND Movement.StatusId = zc_Enum_Status_Complete()
      ;

     IF NOT EXISTS (SELECT 1 FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId AND MB.DescId = zc_MovementBoolean_DocPartner() AND MB.ValueData = TRUE)
        AND EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = inMovementId AND Movement.DescId = zc_Movement_WeighingPartner())
     THEN
         RAISE EXCEPTION 'Ошибка.Документ не проведен.';
     END IF;


     -- Проверка
     IF COALESCE (vbInvNumberPartner, '') = ''
     THEN
         RAISE EXCEPTION 'Ошибка.Не установлен Номер документа поставщика.';
     END IF;



    -- ВСЕ приходы, с одинаковым InvNumberPartner + ContractId + PaidKindId + PartnerId
    CREATE TEMP TABLE tmpMovement (MovementId Integer, OperDate TDateTime, MovementId_WeighingPartner Integer) ON COMMIT DROP;
    INSERT INTO  tmpMovement (MovementId, OperDate, MovementId_WeighingPartner)
       SELECT Movement.Id                 AS MovementId
            , Movement.OperDate           AS OperDate
            , Movement_WeighingPartner.Id AS MovementId_WeighingPartner
       FROM Movement
            INNER JOIN MovementString AS MovementString_InvNumberPartner
                                      ON MovementString_InvNumberPartner.MovementId = Movement.Id
                                     AND MovementString_InvNumberPartner.DescId     = zc_MovementString_InvNumberPartner()
                                     AND MovementString_InvNumberPartner.ValueData  = vbInvNumberPartner
            INNER JOIN MovementLinkObject AS MLO_Contract
                                          ON MLO_Contract.MovementId = Movement.Id
                                         AND MLO_Contract.DescId     = zc_MovementLinkObject_Contract()
                                         AND MLO_Contract.ObjectId   = vbContractId
            INNER JOIN MovementLinkObject AS MLO_PaidKind
                                          ON MLO_PaidKind.MovementId = Movement.Id
                                         AND MLO_PaidKind.DescId     = zc_MovementLinkObject_PaidKind()
                                         AND MLO_PaidKind.ObjectId   = vbPaidKindId
            INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                          ON MovementLinkObject_From.MovementId = Movement.Id
                                         AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                         AND MovementLinkObject_From.ObjectId = vbPartnerId

            LEFT JOIN Movement AS Movement_WeighingPartner
                               ON Movement_WeighingPartner.ParentId = Movement.Id
                              AND Movement_WeighingPartner.DescId   = zc_Movement_WeighingPartner()
       WHERE Movement.OperDate BETWEEN vbOperDate - INTERVAL '1 DAY' AND vbOperDate + INTERVAL '1 DAY'
         AND Movement.DescId   = zc_Movement_Income()
         AND Movement.StatusId = zc_Enum_Status_Complete()
        ;

    --переопределим документ, что б всегда ператался один и тот же , берем макс. Id
    vbMovementId := (SELECT  MAX (tmpMovement.MovementId)
                     FROM tmpMovement
                     );


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

            INTO vbDescId, vbStatusId, vbPriceWithVAT, vbVATPercent, vbDiscountPercent, vbExtraChargesPercent, vbChangePercentTo, vbGoodsPropertyId, vbGoodsPropertyId_basis, vbPaidKindId
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

     WHERE Movement.Id = vbMovementId
       -- AND Movement.StatusId = zc_Enum_Status_Complete()
    ;

     -- очень важная проверка
    IF COALESCE (vbStatusId, 0) <> zc_Enum_Status_Complete() --OR vbUserId = 5
    THEN
        IF vbStatusId = zc_Enum_Status_Erased() OR vbUserId = 5
        THEN
            RAISE EXCEPTION 'Ошибка.Документ <%> № <%> от <%> удален.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = vbMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = vbMovementId);
        END IF;
        IF vbStatusId = zc_Enum_Status_UnComplete()
        THEN
            RAISE EXCEPTION 'Ошибка.Документ <%> № <%> от <%> не проведен.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = vbMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = vbMovementId);
        END IF;
        -- это уже странная ошибка
        -- RAISE EXCEPTION 'Ошибка.Документ <%>.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId);
    END IF;




      --
    OPEN Cursor1 FOR
    WITH
    tmpMovementFloat AS (SELECT MovementFloat.*
                         FROM MovementFloat
                         WHERE MovementFloat.MovementId IN (SELECT DISTINCT tmpMovement.MovementId FROM tmpMovement)
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
                           WHERE MovementBoolean.MovementId = vbMovementId
                             AND MovementBoolean.DescId IN (zc_MovementBoolean_isIncome()
                                                          , zc_MovementBoolean_PriceWithVAT()
                                                          )
                         )

  , tmpMovementLinkObject AS (SELECT MovementLinkObject.*
                           FROM MovementLinkObject
                           WHERE MovementLinkObject.MovementId = vbMovementId
                         )

  , tmpMovementLinkMovement AS (SELECT MovementLinkMovement.*
                           FROM MovementLinkMovement
                           WHERE MovementLinkMovement.MovementId = vbMovementId
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
           , Movement.InvNumber ::TVarChar  AS InvNumber
           , Movement.OperDate     ::TDateTime AS OperDate
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
           , (select Sum (Amount)
              from MovementItemContainer
              where MovementId IN (SELECT DISTINCT tmpMovement.MovementId FROM tmpMovement)
                and DescId = 2
                and isactive = True
                and AccountId <> zc_Enum_Account_100301 ()
              ) AS TotalSummPVAT_To

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
                                       ON MovementFloat_VATPercent.MovementId = Movement.Id
                                      AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
            LEFT JOIN tmpMovementFloat AS MovementFloat_ChangePercent
                                       ON MovementFloat_ChangePercent.MovementId = Movement.Id
                                      AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

            LEFT JOIN (SELECT SUM (COALESCE (tmpMovementFloat.ValueData,0)) AS ValueData
                       FROM tmpMovementFloat
                       WHERE tmpMovementFloat.DescId = zc_MovementFloat_TotalCount()
                       ) AS MovementFloat_TotalCount ON 1 = 1
            LEFT JOIN (SELECT SUM (COALESCE (tmpMovementFloat.ValueData,0)) AS ValueData
                       FROM tmpMovementFloat
                       WHERE tmpMovementFloat.DescId = zc_MovementFloat_TotalCountPartner()
                       ) AS MovementFloat_TotalCountPartner ON 1 = 1
            LEFT JOIN (SELECT SUM (COALESCE (tmpMovementFloat.ValueData,0)) AS ValueData
                       FROM tmpMovementFloat
                       WHERE tmpMovementFloat.DescId = zc_MovementFloat_TotalCountKg()
                       ) AS MovementFloat_TotalCountKg ON 1 = 1
            LEFT JOIN (SELECT SUM (COALESCE (tmpMovementFloat.ValueData,0)) AS ValueData
                       FROM tmpMovementFloat
                       WHERE tmpMovementFloat.DescId = zc_MovementFloat_TotalCountSh()
                       ) AS MovementFloat_TotalCountSh ON 1 = 1

            LEFT JOIN (SELECT SUM (COALESCE (tmpMovementFloat.ValueData,0)) AS ValueData
                       FROM tmpMovementFloat
                       WHERE tmpMovementFloat.DescId = zc_MovementFloat_TotalSummMVAT()
                       ) AS MovementFloat_TotalSummMVAT ON 1 = 1
            LEFT JOIN (SELECT SUM (COALESCE (tmpMovementFloat.ValueData,0)) AS ValueData
                       FROM tmpMovementFloat
                       WHERE tmpMovementFloat.DescId = zc_MovementFloat_TotalSummPVAT()
                       ) AS MovementFloat_TotalSummPVAT ON 1 = 1
            LEFT JOIN (SELECT SUM (COALESCE (tmpMovementFloat.ValueData,0)) AS ValueData
                       FROM tmpMovementFloat
                       WHERE tmpMovementFloat.DescId = zc_MovementFloat_TotalSumm()
                       ) AS MovementFloat_TotalSumm ON 1 = 1
            LEFT JOIN (SELECT SUM (COALESCE (tmpMovementFloat.ValueData,0)) AS ValueData
                       FROM tmpMovementFloat
                       WHERE tmpMovementFloat.DescId = zc_MovementFloat_TotalSummPacker()
                       ) AS MovementFloat_TotalSummPacker ON 1 = 1
            LEFT JOIN (SELECT SUM (COALESCE (tmpMovementFloat.ValueData,0)) AS ValueData
                       FROM tmpMovementFloat
                       WHERE tmpMovementFloat.DescId = zc_MovementFloat_TotalSummSpending()
                       ) AS MovementFloat_TotalSummSpending ON 1 = 1

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

      WHERE Movement.Id = vbMovementId
         AND Movement.DescId = zc_Movement_Income();

    RETURN NEXT Cursor1;


    OPEN Cursor2 FOR

    WITH

    --выбираем приходы, нужно объединить все накл за этот день, если у них одинаковый InvNumberPartner + для Акта Разногласий
    tmpMI_All AS (SELECT MovementItem.*
                  FROM MovementItem
                  WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovement.MovementId FROM tmpMovement)
                    AND MovementItem.DescId     = zc_MI_Master()
                    AND MovementItem.isErased   = FALSE
                  )
  , tmpMILO_GoodsKind AS (SELECT MovementItemLinkObject.*
                          FROM MovementItemLinkObject
                          WHERE MovementItemLinkObject.MovementItemId in (SELECT DISTINCT tmpMI_All.Id FROM tmpMI_All)
                            AND MovementItemLinkObject.DescId = zc_MILinkObject_GoodsKind()
                          )

  , tmpMI_Float AS (SELECT MovementItemFloat.*
                    FROM MovementItemFloat
                    WHERE MovementItemFloat.MovementItemId in (SELECT DISTINCT tmpMI_All.Id FROM tmpMI_All)
                      AND MovementItemFloat.DescId IN (zc_MIFloat_CountForPrice()
                                                     , zc_MIFloat_AmountPacker()
                                                     , zc_MIFloat_AmountPartnerSecond()
                                                     , zc_MIFloat_AmountPartner()
                                                     , zc_MIFloat_PricePartner()
                                                     , zc_MIFloat_Price()
                                                     )
                    )

  , tmpMI AS (SELECT MovementItem.ObjectId AS GoodsId
                  , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                  , CASE WHEN vbDiscountPercent <> 0 AND vbPaidKindId <> zc_Enum_PaidKind_SecondForm() -- !!!для НАЛ не учитываем!!!
                              THEN CAST ( (1 - vbDiscountPercent / 100) * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2))
                         WHEN vbExtraChargesPercent <> 0 AND vbPaidKindId <> zc_Enum_PaidKind_SecondForm() -- !!!для НАЛ не учитываем!!!
                              THEN CAST ( (1 + vbExtraChargesPercent / 100) * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2))
                         ELSE COALESCE (MIFloat_Price.ValueData, 0)
                    END AS Price
                  , MIFloat_CountForPrice.ValueData AS CountForPrice
                  , SUM (MovementItem.Amount) AS Amount
                  , SUM (CASE WHEN Movement.DescId IN (zc_Movement_Sale(), zc_Movement_Income(), zc_Movement_ReturnOut(), zc_Movement_ReturnIn())
                                   THEN COALESCE (MIFloat_AmountPartner.ValueData, 0)
                              WHEN Movement.DescId IN (zc_Movement_SendOnPrice()) AND vbIsProcess_BranchIn = TRUE
                                   THEN COALESCE (MIFloat_AmountPartner.ValueData, 0)
                              ELSE MovementItem.Amount
                         END) AS AmountPartner
                  , SUM (COALESCE (MIFloat_AmountPartnerSecond.VAlueData, 0)) AS AmountPartnerSecond
                  , SUM (COALESCE (MIFloat_AmountPacker.VAlueData, 0))        AS AmountPacker
                  , COALESCE (MIFloat_Price.ValueData, 0)                     AS PriceOriginal
                  , COALESCE (MIFloat_PricePartner.ValueData,0)               AS PricePartner
             FROM tmpMI_All AS MovementItem
                  LEFT JOIN tmpMI_Float AS MIFloat_Price
                                              ON MIFloat_Price.MovementItemId = MovementItem.Id
                                             AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                              -- AND MIFloat_Price.ValueData <> 0
                  LEFT JOIN tmpMI_Float AS MIFloat_PricePartner
                                        ON MIFloat_PricePartner.MovementItemId = MovementItem.Id
                                       AND MIFloat_PricePartner.DescId = zc_MIFloat_PricePartner()
                  LEFT JOIN tmpMI_Float AS MIFloat_AmountPartner
                                        ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                  LEFT JOIN tmpMI_Float AS MIFloat_AmountPartnerSecond
                                        ON MIFloat_AmountPartnerSecond.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountPartnerSecond.DescId = zc_MIFloat_AmountPartnerSecond()

                  LEFT JOIN tmpMI_Float AS MIFloat_AmountPacker
                                        ON MIFloat_AmountPacker.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountPacker.DescId = zc_MIFloat_AmountPacker()

                  LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId

                  LEFT JOIN tmpMI_Float AS MIFloat_CountForPrice
                                        ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                       AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

                  LEFT JOIN tmpMILO_GoodsKind AS MILinkObject_GoodsKind
                                              ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                             AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
             GROUP BY MovementItem.ObjectId
                    , MILinkObject_GoodsKind.ObjectId
                    , MIFloat_Price.ValueData
                    , MIFloat_CountForPrice.ValueData
                    , COALESCE (MIFloat_PricePartner.ValueData,0)
            )
     --данные из док взвешивание
  , tmpGoods_WeighingPartner AS (WITH
                                 tmpMov AS (SELECT DISTINCT tmpMovement.MovementId_WeighingPartner AS Id
                                            FROM tmpMovement
                                           )
                               , tmpMI AS (
                                          SELECT MovementItem.*
                                          FROM MovementItem
                                          WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMov.Id FROM tmpMov)
                                            AND MovementItem.DescId     = zc_MI_Master()
                                            AND MovementItem.isErased   = FALSE
                                          )
                               , tmpMILO_GoodsKind AS (SELECT MovementItemLinkObject.*
                                                       FROM MovementItemLinkObject
                                                       WHERE MovementItemLinkObject.MovementItemId in (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                                         AND MovementItemLinkObject.DescId = zc_MILinkObject_GoodsKind()
                                                       )
                               , tmpMIBoolean AS (SELECT MovementItemBoolean.*
                                                  FROM MovementItemBoolean
                                                  WHERE MovementItemBoolean.MovementItemId in (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                                    AND MovementItemBoolean.DescId = zc_MIBoolean_ReturnOut()
                                                  )
                               , tmpMIString AS (SELECT MovementItemString.*
                                                  FROM MovementItemString
                                                  WHERE MovementItemString.MovementItemId in (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                                    AND MovementItemString.DescId = zc_MIString_Comment()
                                                  )

                                 SELECT MovementItem.ObjectId                           AS GoodsId
                                      , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)   AS GoodsKindId
                                      , COALESCE (MIBoolean_ReturnOut.ValueData, FALSE) AS isReturnOut
                                      , STRING_AGG (DISTINCT COALESCE (MIString_Comment.ValueData, ''), ';') AS Comment
                                 FROM tmpMI AS MovementItem
                                      LEFT JOIN tmpMILO_GoodsKind AS MILinkObject_GoodsKind
                                                                   ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                 AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                      LEFT JOIN MovementItemBoolean AS MIBoolean_ReturnOut
                                                                    ON MIBoolean_ReturnOut.MovementItemId = MovementItem.Id
                                                                   AND MIBoolean_ReturnOut.DescId = zc_MIBoolean_ReturnOut()
                                      LEFT JOIN MovementItemString AS MIString_Comment
                                                                   ON MIString_Comment.MovementItemId = MovementItem.Id
                                                                  AND MIString_Comment.DescId = zc_MIString_Comment()
                                 GROUP BY MovementItem.ObjectId
                                        , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                                        , COALESCE (MIBoolean_ReturnOut.ValueData, FALSE)

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
       WHERE tmpMI.AmountPartner <> 0 OR tmpMI.AmountPacker <> 0 OR tmpMI.Amount <> 0
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
-- SELECT * FROM gpSelect_Movement_Income_Print_byPartner (inMovementId := 29943753, inSession:= '5'); --FETCH ALL "<unnamed portal 6>";
