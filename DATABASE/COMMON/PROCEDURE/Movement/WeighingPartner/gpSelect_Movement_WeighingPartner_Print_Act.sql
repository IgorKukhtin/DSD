-- Function: gpSelect_Movement_WeighingPartner_Print_Act()

DROP FUNCTION IF EXISTS gpSelect_Movement_WeighingPartner_Print_Act (Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_WeighingPartner_Print_Act (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_WeighingPartner_Print_Act(
    IN inMovementId        Integer  , -- ключ Документа  WeighingPartner
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;

    DECLARE vbMovementId_find_min Integer;
    DECLARE vbMovementId_find_max Integer;

    DECLARE vbStatusId Integer;
    DECLARE vbOperDate TDateTime;
    DECLARE vbContractId Integer;
    DECLARE vbPaidKindId Integer;

    DECLARE vbInvNumberPartner TVarChar;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income_Print());
     vbUserId:= lpGetUserBySession (inSession);

     IF NOT EXISTS (SELECT 1 FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId AND MB.DescId = zc_MovementBoolean_DocPartner() AND MB.ValueData = TRUE)
     THEN
         RAISE EXCEPTION 'Ошибка.Документ не проведен.';
     END IF;

     -- параметры из документа
     SELECT Movement.StatusId
          , Movement.OperDate
          , COALESCE (MovementLinkObject_Contract.ObjectId, 0)      AS ContractId
          , COALESCE (MovementLinkObject_PaidKind.ObjectId, 0)      AS PaidKindId
          , COALESCE (MovementString_InvNumberPartner.ValueData,'') ::TVarChar AS InvNumberPartner

            INTO vbStatusId, vbOperDate, vbContractId, vbPaidKindId
               , vbInvNumberPartner
     FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                       ON MovementLinkObject_Contract.MovementId = Movement.Id
                                      AND MovementLinkObject_Contract.DescId     = zc_MovementLinkObject_Contract()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                       ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                      AND MovementLinkObject_PaidKind.DescId     = zc_MovementLinkObject_PaidKind()
          LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                   ON MovementString_InvNumberPartner.MovementId = Movement.Id
                                  AND MovementString_InvNumberPartner.DescId     = zc_MovementString_InvNumberPartner()
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
    END IF;



    -- Все документы Приход
    CREATE TEMP TABLE tmpMovement_list (MovementId Integer) ON COMMIT DROP;
    INSERT INTO tmpMovement_list (MovementId)
       SELECT Movement.Id
       FROM Movement
            INNER JOIN MovementString AS MovementString_InvNumberPartner
                                      ON MovementString_InvNumberPartner.MovementId = Movement.Id
                                     AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
                                     AND MovementString_InvNumberPartner.ValueData = vbInvNumberPartner
                                     AND vbInvNumberPartner <> ''

            INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                                          ON MovementLinkObject_Contract.MovementId = Movement.Id
                                         AND MovementLinkObject_Contract.DescId     = zc_MovementLinkObject_Contract()
                                         AND MovementLinkObject_Contract.ObjectId   = vbContractId
            INNER JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                          ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                         AND MovementLinkObject_PaidKind.DescId     = zc_MovementLinkObject_PaidKind()
                                         AND MovementLinkObject_PaidKind.ObjectId   = vbPaidKindId
            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Transport
                                           ON MovementLinkMovement_Transport.MovementId = Movement.Id
                                          AND MovementLinkMovement_Transport.DescId = zc_MovementLinkMovement_Transport()
       WHERE Movement.OperDate BETWEEN vbOperDate - INTERVAL '1 DAY' AND vbOperDate + INTERVAL '1 DAY'
         AND Movement.DescId = zc_Movement_Income()
         AND Movement.StatusId = zc_Enum_Status_Complete()
       ORDER BY COALESCE (MovementLinkMovement_Transport.MovementChildId, 0) DESC
              , Movement.Id DESC
       LIMIT 1
      ;


    -- !!!замена
    inMovementId:= (SELECT tmpMovement_list.MovementId FROM tmpMovement_list);


     IF vbUserId = 5 AND 1=0
     THEN
         RAISE EXCEPTION 'Ошибка. %   %' , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = inMovementId)
         , (SELECT Movement.DescId FROM Movement WHERE Movement.Id = inMovementId)
         ;
     END IF;

     -- если НЕ Документ поставщика
     IF NOT EXISTS (SELECT 1 FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId AND MB.DescId = zc_MovementBoolean_DocPartner())
     THEN
         -- замена - поиск Документ поставщика
         SELECT MIN (Movement.Id), MAX (Movement.Id)
                INTO vbMovementId_find_min, vbMovementId_find_max
         FROM Movement
              -- есть такое св-во - Документ поставщика
              INNER JOIN MovementBoolean AS MovementBoolean_DocPartner
                                         ON MovementBoolean_DocPartner.MovementId = Movement.Id
                                        AND MovementBoolean_DocPartner.DescId     = zc_MovementBoolean_DocPartner()
              INNER JOIN MovementString AS MovementString_InvNumberPartner
                                        ON MovementString_InvNumberPartner.MovementId = Movement.Id
                                       AND MovementString_InvNumberPartner.DescId     = zc_MovementString_InvNumberPartner()
                                       --  с таким номером Поставщика
                                       AND MovementString_InvNumberPartner.ValueData = vbInvNumberPartner
              INNER JOIN MovementLinkObject AS MLO_Contract
                                            ON MLO_Contract.MovementId = Movement.Id
                                           AND MLO_Contract.DescId     = zc_MovementLinkObject_Contract()
                                           --  с таким Договором
                                           AND MLO_Contract.ObjectId   = vbContractId
         WHERE Movement.OperDate BETWEEN vbOperDate - INTERVAL '1 DAY' AND vbOperDate + INTERVAL '1 DAY'
           AND Movement.DescId   = zc_Movement_WeighingPartner()
           AND Movement.StatusId = zc_Enum_Status_Complete()
        ;

         -- Проверка
         IF vbMovementId_find_min <> vbMovementId_find_max
         THEN
             RAISE EXCEPTION 'Ошибка.Найдено несколько документов поставщика.% № <%> от <%> % № <%> от <%>'
                            , CHR (13)
                            , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = vbMovementId_find_min)
                            , (SELECT zfConvert_DateToString (Movement.OperDate) FROM Movement WHERE Movement.Id = vbMovementId_find_min)
                            , CHR (13)
                            , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = vbMovementId_find_max)
                            , (SELECT zfConvert_DateToString (Movement.OperDate) FROM Movement WHERE Movement.Id = vbMovementId_find_max)
                             ;
         END IF;

         -- Проверка
         IF COALESCE (vbMovementId_find_min, 0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Документ поставщика не найден.';
         END IF;

     END IF;


    --
    OPEN Cursor1 FOR
    WITH
    tmpMovementFloat AS (SELECT MovementFloat.*
                         FROM MovementFloat
                         WHERE MovementFloat.MovementId = inMovementId
                           AND MovementFloat.DescId IN (zc_MovementFloat_VATPercent()
                                                      , zc_MovementFloat_ChangePercent()
                                                       )
                        )

  , tmpMovementBoolean AS (SELECT MovementBoolean.*
                           FROM MovementBoolean
                           WHERE MovementBoolean.MovementId = inMovementId
                             AND MovementBoolean.DescId IN (zc_MovementBoolean_PriceWithVAT()
                                                           )
                          )
  , tmpMovementLinkObject AS (SELECT MovementLinkObject.*
                              FROM MovementLinkObject
                              WHERE MovementLinkObject.MovementId = inMovementId
                             )

  , tmpMovementLinkMovement AS (SELECT MovementLinkMovement.*
                                FROM MovementLinkMovement
                                WHERE MovementLinkMovement.MovementId = inMovementId
                                  AND MovementLinkMovement.DescId     = zc_MovementLinkMovement_Transport()
                               )
  , tmpMovementLinkObject_tr AS (SELECT MovementLinkObject.*
                                 FROM MovementLinkObject
                                 WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMovementLinkMovement.MovementChildId FROM tmpMovementLinkMovement)
                                   AND MovementLinkObject.DescId IN (zc_MovementLinkObject_Car(), zc_MovementLinkObject_PersonalDriver()
                                                                )
                                )
         -- Результат
         SELECT
             Movement.Id
           , zfFormat_BarCode (zc_BarCodePref_Movement(), Movement.Id) AS IdBarCode
           , CASE WHEN MovementString_InvNumberPartner.ValueData <> '' THEN MovementString_InvNumberPartner.ValueData ELSE Movement.InvNumber END :: TVarChar InvNumber
           , Movement.OperDate
           , MovementDate_OperDatePartner.ValueData    AS OperDatePartner
           , MovementString_InvNumberPartner.ValueData AS InvNumberPartner

           , MovementBoolean_PriceWithVAT.ValueData      AS PriceWithVAT
           , MovementFloat_VATPercent.ValueData          AS VATPercent

           , Object_From.ValueData                 AS FromName
           , Object_To.ValueData                   AS ToName
           , Object_PaidKind.ValueData             AS PaidKindName
           , View_Contract_InvNumber.ContractCode  AS ContractCode
           , View_Contract_InvNumber.InvNumber     AS ContractName

           , Object_JuridicalFrom.ValueData    AS JuridicalName_From
           , Object_JuridicalTo.ValueData      AS JuridicalName_To
           , ObjectHistory_JuridicalDetails_View.OKPO AS OKPO_From

           , Object_Car.ValueData                        AS CarName
           , Onject_PersonalDriver.ValueData             AS PersonalDriverName
           , Object_Juridical_Car.ValueData              AS JuridicalName_Car

       FROM Movement

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId =  Movement.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN tmpMovementBoolean AS MovementBoolean_PriceWithVAT
                                         ON MovementBoolean_PriceWithVAT.MovementId = Movement.Id
                                        AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
            LEFT JOIN tmpMovementFloat AS MovementFloat_VATPercent
                                       ON MovementFloat_VATPercent.MovementId =  Movement.Id
                                      AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()

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

            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                 ON ObjectLink_Partner_Juridical.ObjectId = Object_From.Id
                                AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
            LEFT JOIN Object AS Object_JuridicalFrom ON Object_JuridicalFrom.Id = ObjectLink_Partner_Juridical.ChildObjectId
            LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_JuridicalFrom.Id

            LEFT JOIN ObjectLink AS ObjectLink_To_Juridical
                                 ON ObjectLink_To_Juridical.ObjectId = Object_To.Id
                                AND ObjectLink_To_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
            LEFT JOIN Object AS Object_JuridicalTo ON Object_JuridicalTo.Id = ObjectLink_To_Juridical.ChildObjectId

            --
            LEFT JOIN tmpMovementLinkMovement AS MovementLinkMovement_Transport
                                              ON MovementLinkMovement_Transport.MovementId = Movement.Id
                                             AND MovementLinkMovement_Transport.DescId = zc_MovementLinkMovement_Transport()

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

      WHERE Movement.Id     = inMovementId
        AND Movement.DescId = zc_Movement_Income()
     ;

    RETURN NEXT Cursor1;


    OPEN Cursor2 FOR

        WITH -- Док. Взвешивание - данные Поставщика
             tmpMI_partner AS (SELECT gpSelect.GoodsCode, gpSelect.GoodsName
                                    , gpSelect.GoodsKindName
                                    , gpSelect.MeasureName
                                      -- Количество Поставщика
                                    , gpSelect.AmountPartnerSecond
                                      -- Кол-во Поставщик с учетом % скидки кол-во
                                    , gpSelect.Amount_income_calc
                                      -- Разница в количестве
                                    , gpSelect.Amount_diff
                                      -- Сумма разницы без НДС
                                    , gpSelect.Summ_diff
                                      --
                                    , gpSelect.PricePartnerNoVAT
                                    , gpSelect.PricePartnerWVAT
                                      --
                                    , gpSelect.PriceNoVAT_income
                                    , gpSelect.PriceWVat_income

                                    , gpSelect.isReturnOut
                                    , gpSelect.ReasonName

                               FROM gpSelect_MI_WeighingPartner_diff (inMovementId, FALSE, inSession) AS gpSelect
                              )


       SELECT tmpMI_partner.GoodsCode        AS GoodsCode
            , tmpMI_partner.GoodsName        AS GoodsName_two
            , tmpMI_partner.GoodsKindName    AS GoodsKindName
            , tmpMI_partner.MeasureName      AS MeasureName

              -- Количество Поставщика
            , tmpMI_partner.AmountPartnerSecond AS AmountPartnerSecond
              -- Кол-во Поставщик с учетом % скидки кол-во
            , tmpMI_partner.Amount_income_calc  AS AmountPartner

              -- Разница в количестве
            , tmpMI_partner.Amount_diff
              -- Сумма разницы без НДС
            , tmpMI_partner.Summ_diff

              -- цена Поставщика без НДС, до 4 знаков
            , tmpMI_partner.PricePartnerNoVAT
              -- цена Поставщика с НДС, до 4 знаков
            , tmpMI_partner.PricePartnerWVAT

              -- цена приход без НДС
            , tmpMI_partner.PriceNoVAT_income              :: TFloat AS PriceNoVAT
              -- цена приход с НДС
            , tmpMI_partner.PriceWVat_income               :: TFloat AS PriceWVat

              --
            , tmpMI_partner.isReturnOut
            , tmpMI_partner.ReasonName AS Comment

       FROM tmpMI_partner
       ORDER BY tmpMI_partner.GoodsName, tmpMI_partner.GoodsKindName

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
-- SELECT * FROM gpSelect_Movement_WeighingPartner_Print_Act (inMovementId := 29874523, inSession:= '5'); -- FETCH ALL "<unnamed portal 10>";
