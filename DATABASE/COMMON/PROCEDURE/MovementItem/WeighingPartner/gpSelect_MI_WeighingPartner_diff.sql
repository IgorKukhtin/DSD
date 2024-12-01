-- Function: gpSelect_MI_WeighingPartner_diff()

DROP FUNCTION IF EXISTS gpSelect_MI_WeighingPartner_diff (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_WeighingPartner_diff(
    IN inMovementId  Integer      , -- ключ Документа
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Ord Integer, Id Integer, MovementId Integer, MovementId_WeighingPartner Integer, MovementId_income Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupNameFull TVarChar
             , GoodsKindId Integer, GoodsKindName TVarChar, MeasureName TVarChar

             --, AmountPartner_calc TFloat
             , AmountPartnerSecond TFloat
             , PricePartnerNoVAT TFloat, PricePartnerWVAT TFloat
             , SummPartnerNoVAT TFloat, SummPartnerWVAT TFloat

             , ChangePercentAmount TFloat

             , Amount_income TFloat, Amount_income_calc TFloat, AmountPartner_income TFloat, PriceNoVAT_income TFloat, PriceWVat_income TFloat, SummNoVAT_income TFloat, SummWVAT_income TFloat
             , Amount_diff TFloat, Price_diff TFloat, Summ_diff TFloat
             , isAmountPartnerSecond Boolean
             , isReturnOut Boolean
             , isReason_1 Boolean, isReason_2 Boolean
             , ReasonName TVarChar
             , Comment TVarChar
             , isErased Boolean

              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId_find_min Integer;
   DECLARE vbMovementId_find_max Integer;
   DECLARE vbContractId Integer;
   DECLARE vbPaidKindId Integer;
   DECLARE vbVATPercent TFloat;
   DECLARE vbInvNumberPartner TVarChar;
   DECLARE vbOperDate TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_WeighingPartner());
     vbUserId:= lpGetUserBySession (inSession);


     -- параметры из документа
     vbOperDate        := (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId);
     vbInvNumberPartner:= (SELECT MS.ValueData FROM MovementString AS MS WHERE MS.MovementId = inMovementId AND MS.DescId = zc_MovementString_InvNumberPartner());
     vbContractId      := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Contract());
     vbPaidKindId      := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_PaidKind());

     -- Проверка
     IF COALESCE (vbInvNumberPartner, '') = ''
     THEN
         RAISE EXCEPTION 'Ошибка.Не установлен Номер документа поставщика.';
     END IF;


     -- если НЕ Документ поставщика
     IF NOT EXISTS (SELECT 1 FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId AND MB.DescId = zc_MovementBoolean_DocPartner())
     THEN
         -- замена - поиск Документ поставщика
         SELECT MIN (Movement.Id), MAX (Movement.Id)
                INTO vbMovementId_find_min, vbMovementId_find_max
         FROM Movement
              -- есть такое св-во
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
         WHERE Movement.OperDate BETWEEN vbOperDate - INTERVAL '1 DAY' AND vbOperDate
           AND Movement.DescId   = zc_Movement_WeighingPartner()
           AND Movement.StatusId = zc_Enum_Status_Complete()
        ;

         -- Проверка
         IF vbMovementId_find_min <> vbMovementId_find_max
         THEN
             RAISE EXCEPTION 'Ошибка.Найдено несколько документов поставщика.';
         END IF;

         -- Проверка
         IF COALESCE (vbMovementId_find_min, 0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Документ поставщика не найден.';
         END IF;

         -- замена - поиск Документ поставщика
         inMovementId:= vbMovementId_find_min;

     END IF;


     -- параметры из документа
     vbVATPercent:= (SELECT COALESCE (MF.ValueData, 0) FROM MovementFloat AS MF WHERE MF.MovementId = inMovementId AND MF.DescId = zc_MovementFloat_VATPercent());


     -- inShowAll:= TRUE;
     RETURN QUERY

        WITH -- Док. Взвешивание - данные Поставщика
             tmpMIList AS (SELECT MAX (MovementItem.Id)     AS Id
                                , SUM (MovementItem.Amount) AS Amount
                                , MovementItem.MovementId
                                , MovementItem.ObjectId
                                , COALESCE (MILO_GoodsKind.ObjectId, 0) AS GoodsKindId
                           FROM MovementItem
                                LEFT JOIN MovementItemLinkObject AS MILO_GoodsKind
                                                                 ON MILO_GoodsKind.MovementItemId = MovementItem.Id
                                                                AND MILO_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                           WHERE MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = FALSE
                           GROUP BY MovementItem.MovementId
                                  , MovementItem.ObjectId
                                  , COALESCE (MILO_GoodsKind.ObjectId, 0)
                          )

            , tmpMI_Float AS (SELECT MovementItemFloat.*
                              FROM MovementItemFloat
                              WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMIList.Id FROM tmpMIList)
                             )

      , tmpMI_Boolean AS (SELECT MovementItemBoolean.*
                          FROM MovementItemBoolean
                          WHERE MovementItemBoolean.MovementItemId IN (SELECT DISTINCT tmpMIList.Id FROM tmpMIList)
                            AND MovementItemBoolean.DescId IN (zc_MIBoolean_AmountPartnerSecond()
                                                             , zc_MIBoolean_PriceWithVAT()
                                                             , zc_MIBoolean_ReturnOut()
                                                             )
                         )

      , tmpMI_String AS (SELECT MovementItemString.*
                         FROM MovementItemString
                         WHERE MovementItemString.MovementItemId IN (SELECT DISTINCT tmpMIList.Id FROM tmpMIList)
                           AND MovementItemString.DescId IN (zc_MIString_Comment()
                                                            )
                         )

      , tmpMI_wp AS (SELECT tmpMI.*
                            -- расчет сумма без НДС, 2 знака
                          , CASE WHEN tmpMI.isPriceWithVAT = TRUE AND tmpMI.SummPartner > 0
                                      -- если ввели сумма с НДС
                                      THEN CAST (tmpMI.SummPartner / (1 + vbVATPercent / 100) AS NUMERIC (16, 2))

                                 WHEN tmpMI.SummPartner > 0
                                      -- если ввели сумма без НДС
                                      THEN tmpMI.SummPartner

                                 ELSE CAST (tmpMI.PricePartnerNoVAT * tmpMI.AmountPartnerSecond AS NUMERIC (16, 2))

                            END AS SummPartnerNoVAT

                            -- расчет сумма с НДС, до 2 знака
                          , CASE WHEN tmpMI.isPriceWithVAT = TRUE AND tmpMI.SummPartner > 0
                                      -- если ввели сумма с НДС
                                      THEN tmpMI.SummPartner

                                 WHEN tmpMI.SummPartner > 0
                                      -- если ввели сумма без НДС
                                      THEN CAST (tmpMI.SummPartner * (1 + vbVATPercent / 100) AS NUMERIC (16, 2))

                                 ELSE CAST (tmpMI.PricePartnerWVAT * tmpMI.AmountPartnerSecond AS NUMERIC (16, 2))

                            END AS SummPartnerWVAT

                     FROM (SELECT MovementItem.Id                               AS MovementItemId
                                , MovementItem.MovementId                       AS MovementId
                                , MovementItem.ObjectId                         AS GoodsId
                                , MovementItem.GoodsKindId                      AS GoodsKindId

                                  -- Количество Поставщика - Документ Поставщика
                                , COALESCE (MIFloat_AmountPartnerSecond.ValueData, 0) AS AmountPartnerSecond
                                  -- Цена/Сумма с НДС (да/нет)
                                , COALESCE (MIBoolean_PriceWithVAT.ValueData, FALSE)  AS isPriceWithVAT
                                  -- Сумма Поставщика
                                , COALESCE (MIFloat_SummPartner.ValueData, 0)         AS SummPartner

                                  -- расчет цена без НДС, до 2 или 4 знака
                                , CASE WHEN MIBoolean_PriceWithVAT.ValueData = TRUE AND MIFloat_SummPartner.ValueData > 0 AND MIFloat_AmountPartnerSecond.ValueData > 0
                                            -- если ввели сумма с НДС
                                            THEN CAST (MIFloat_SummPartner.ValueData / MIFloat_AmountPartnerSecond.ValueData / (1 + vbVATPercent / 100) AS NUMERIC (16, 4))

                                       WHEN MIBoolean_PriceWithVAT.ValueData = TRUE
                                            -- если ввели цена с НДС
                                            THEN CAST (COALESCE (MIFloat_PricePartner.ValueData, 0) / (1 + vbVATPercent / 100) AS NUMERIC (16, 2))

                                       WHEN MIFloat_SummPartner.ValueData > 0 AND MIFloat_AmountPartnerSecond.ValueData > 0
                                            -- если ввели сумма без НДС
                                            THEN CAST (MIFloat_SummPartner.ValueData / MIFloat_AmountPartnerSecond.ValueData AS NUMERIC (16, 4))

                                       -- ничего не делаем
                                       ELSE COALESCE (MIFloat_PricePartner.ValueData, 0)

                                  END AS PricePartnerNoVAT

                                  -- расчет цена с НДС, до 2 или 4 знака
                                , CASE WHEN MIBoolean_PriceWithVAT.ValueData = TRUE AND MIFloat_SummPartner.ValueData > 0 AND MIFloat_AmountPartnerSecond.ValueData > 0
                                            -- если ввели сумма с НДС
                                            THEN CAST (MIFloat_SummPartner.ValueData / MIFloat_AmountPartnerSecond.ValueData AS NUMERIC (16, 4))

                                       WHEN MIBoolean_PriceWithVAT.ValueData = TRUE
                                            -- если ввели цена с НДС - ничего не делаем
                                            THEN COALESCE (MIFloat_PricePartner.ValueData, 0)

                                       WHEN MIFloat_SummPartner.ValueData > 0 AND MIFloat_AmountPartnerSecond.ValueData > 0
                                            -- если ввели сумма без НДС
                                            THEN CAST (MIFloat_SummPartner.ValueData / MIFloat_AmountPartnerSecond.ValueData * (1 + vbVATPercent / 100) AS NUMERIC (16, 4))

                                       -- если ввели цена без НДС
                                       ELSE CAST (COALESCE (MIFloat_PricePartner.ValueData, 0) * (1 + vbVATPercent / 100) AS NUMERIC (16, 4))

                                  END AS PricePartnerWVAT

                                  -- Признак "без оплаты"
                                , COALESCE (MIBoolean_AmountPartnerSecond.ValueData, FALSE) :: Boolean AS isAmountPartnerSecond
                                  -- Возврат да/нет
                                , COALESCE (MIBoolean_ReturnOut.ValueData, FALSE)           :: Boolean  AS isReturnOut
                                  --
                                , COALESCE (MIString_Comment.ValueData,'')                  :: TVarChar AS Comment

                           FROM tmpMIList AS MovementItem
                                -- Признак "без оплаты"
                                LEFT JOIN tmpMI_Boolean AS MIBoolean_AmountPartnerSecond
                                                        ON MIBoolean_AmountPartnerSecond.MovementItemId = MovementItem.Id
                                                       AND MIBoolean_AmountPartnerSecond.DescId         = zc_MIBoolean_AmountPartnerSecond()
                                -- Цена/Сумма с НДС (да/нет)
                                LEFT JOIN tmpMI_Boolean AS MIBoolean_PriceWithVAT
                                                        ON MIBoolean_PriceWithVAT.MovementItemId = MovementItem.Id
                                                       AND MIBoolean_PriceWithVAT.DescId         = zc_MIBoolean_PriceWithVAT()
                                -- Возврат да/нет
                                LEFT JOIN tmpMI_Boolean AS MIBoolean_ReturnOut
                                                        ON MIBoolean_ReturnOut.MovementItemId = MovementItem.Id
                                                       AND MIBoolean_ReturnOut.DescId         = zc_MIBoolean_ReturnOut()

                                LEFT JOIN tmpMI_String AS MIString_Comment
                                                       ON MIString_Comment.MovementItemId = MovementItem.Id
                                                      AND MIString_Comment.DescId = zc_MIString_Comment()
                                -- Количество Поставщика - Документ Поставщика
                                LEFT JOIN tmpMI_Float AS MIFloat_AmountPartnerSecond
                                                      ON MIFloat_AmountPartnerSecond.MovementItemId = MovementItem.Id
                                                     AND MIFloat_AmountPartnerSecond.DescId = zc_MIFloat_AmountPartnerSecond()

                                -- Цена Поставщика
                                LEFT JOIN tmpMI_Float AS MIFloat_PricePartner
                                                      ON MIFloat_PricePartner.MovementItemId = MovementItem.Id
                                                     AND MIFloat_PricePartner.DescId = zc_MIFloat_PricePartner()
                                -- Сумма Поставщика
                                LEFT JOIN tmpMI_Float AS MIFloat_SummPartner
                                                      ON MIFloat_SummPartner.MovementItemId = MovementItem.Id
                                                     AND MIFloat_SummPartner.DescId         = zc_MIFloat_SummPartner()
                          ) AS tmpMI
                    )

        -- ВСЕ приходы, с одинаковым InvNumberPartner + ContractId + PaidKindId +  для Акта Разногласий
      , tmpMovement AS (SELECT Movement.Id                                               AS MovementId
                             , Movement_WeighingPartner.Id                               AS MovementId_WeighingPartner
                               -- % Скидки для кол-во поставщик
                             , COALESCE (MovementFloat_ChangePercentAmount.ValueData, 0) AS ChangePercentAmount
                               -- Причина скидки в кол-ве температура
                             , COALESCE (MB_Reason1.ValueData, FALSE)                    AS isReason_1
                               -- Причина скидки в кол-ве качество
                             , COALESCE (MB_Reason2.ValueData, FALSE)                    AS isReason_2
                        FROM Movement
                             INNER JOIN MovementString AS MovementString_InvNumberPartner
                                                       ON MovementString_InvNumberPartner.MovementId = Movement.Id
                                                      AND MovementString_InvNumberPartner.DescId     = zc_MovementString_InvNumberPartner()
                                                      AND MovementString_InvNumberPartner.ValueData  = vbInvNumberPartner
                                                      AND vbInvNumberPartner <> ''
                             INNER JOIN MovementLinkObject AS MLO_Contract
                                                           ON MLO_Contract.MovementId = Movement.Id
                                                          AND MLO_Contract.DescId     = zc_MovementLinkObject_Contract()
                                                          AND MLO_Contract.ObjectId   = vbContractId
                             INNER JOIN MovementLinkObject AS MLO_PaidKind
                                                           ON MLO_PaidKind.MovementId = Movement.Id
                                                          AND MLO_PaidKind.DescId     = zc_MovementLinkObject_PaidKind()
                                                          AND MLO_PaidKind.ObjectId   = vbPaidKindId
                             LEFT JOIN Movement AS Movement_WeighingPartner
                                                ON Movement_WeighingPartner.ParentId = Movement.Id
                                               AND Movement_WeighingPartner.DescId   = zc_Movement_WeighingPartner()
                             -- % Скидки для кол-во поставщик
                             LEFT JOIN MovementFloat AS MovementFloat_ChangePercentAmount
                                                     ON MovementFloat_ChangePercentAmount.MovementId = Movement_WeighingPartner.Id
                                                    AND MovementFloat_ChangePercentAmount.DescId     = zc_MovementFloat_ChangePercentAmount()
                             -- Причина скидки в кол-ве температура
                             LEFT JOIN MovementBoolean AS MB_Reason1
                                                       ON MB_Reason1.MovementId = Movement_WeighingPartner.Id
                                                      AND MB_Reason1.DescId     = zc_MovementBoolean_Reason1()
                             -- Причина скидки в кол-ве качество
                             LEFT JOIN MovementBoolean AS MB_Reason2
                                                       ON MB_Reason2.MovementId = Movement_WeighingPartner.Id
                                                      AND MB_Reason2.DescId     = zc_MovementBoolean_Reason2()

                        WHERE Movement.OperDate BETWEEN vbOperDate - INTERVAL '1 DAY' AND vbOperDate
                          AND Movement.DescId   = zc_Movement_Income()
                          AND Movement.StatusId = zc_Enum_Status_Complete()
                       )

          , tmpMF_VATPercent AS (SELECT MovementFloat_ChangePercent.*
                                 FROM MovementFloat AS MovementFloat_ChangePercent
                                 WHERE MovementFloat_ChangePercent.MovementId IN (SELECT DISTINCT tmpMovement.MovementId FROM tmpMovement)
                                   AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_VATPercent()
                                 )
          , tmpMB_PriceWithVAT AS (SELECT MovementBoolean.*
                                   FROM MovementBoolean
                                   WHERE MovementBoolean.MovementId IN (SELECT DISTINCT tmpMovement.MovementId FROM tmpMovement)
                                     AND MovementBoolean.DescId     = zc_MovementBoolean_PriceWithVAT()
                                   )
   , tmpMI_Income_all AS (SELECT MovementItem.*
                          FROM MovementItem
                          WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovement.MovementId FROM tmpMovement)
                            AND MovementItem.DescId     = zc_MI_Master()
                            AND MovementItem.isErased   = FALSE
                         )
     , tmpMILO_GoodsKind_in AS (SELECT MovementItemLinkObject.*
                                FROM MovementItemLinkObject
                                WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI_Income_all.Id FROM tmpMI_Income_all)
                                  AND MovementItemLinkObject.DescId IN (zc_MILinkObject_GoodsKind()
                                                                      , zc_MILinkObject_GoodsReal()
                                                                      , zc_MILinkObject_GoodsKindReal()
                                                                       )
                               )
       , tmpMI_Float_Price AS (SELECT MovementItemFloat.*
                               FROM MovementItemFloat
                               WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI_Income_all.Id FROM tmpMI_Income_all)
                                 AND MovementItemFloat.DescId = zc_MIFloat_Price()
                              )
         -- Количество Поставщика - Документ Приход
   , tmpMI_Float_AmountPartner AS (SELECT MovementItemFloat.*
                                   FROM MovementItemFloat
                                   WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI_Income_all.Id FROM tmpMI_Income_all)
                                     AND MovementItemFloat.DescId = zc_MIFloat_AmountPartner()
                                  )

      , tmpMI_All AS (SELECT COALESCE (MILinkObject_GoodsReal.ObjectId, MovementItem.ObjectId)                  AS GoodsId
                           , COALESCE (MILinkObject_GoodsKindReal.ObjectId, MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                             -- Кол-во факт
                           , SUM (MovementItem.Amount) AS Amount
                             -- Кол-во факт Поставщик
                           , SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0)) AS AmountPartner
                             -- расчет цена без НДС, до 2 или 4 знака
                           , CASE WHEN MovementBoolean_PriceWithVAT.ValueData = TRUE
                                       -- если ввели цена с НДС - ничего не делаем
                                       THEN CAST (COALESCE (MIFloat_Price.ValueData, 0) / (1 + COALESCE (MovementFloat_VATPercent.ValueData, 0) / 100)  AS NUMERIC (16, 4))

                                  -- если ввели цена без НДС
                                  ELSE COALESCE (MIFloat_Price.ValueData, 0)

                             END AS PriceNoVAT
                             -- расчет цена с НДС, до 2 или 4 знака
                           , CASE WHEN MovementBoolean_PriceWithVAT.ValueData = TRUE
                                       -- если ввели цена с НДС - ничего не делаем
                                       THEN COALESCE (MIFloat_Price.ValueData, 0)

                                  -- если ввели цена без НДС
                                  ELSE CAST (COALESCE (MIFloat_Price.ValueData, 0) * (1 + COALESCE (MovementFloat_VATPercent.ValueData, 0) / 100) AS NUMERIC (16, 4))

                             END AS PriceWVAT

                             -- % Скидки для кол-во поставщик
                           , tmpMovement.ChangePercentAmount
                             -- Причина скидки в кол-ве температура
                           , tmpMovement.isReason_1
                             -- Причина скидки в кол-ве качество
                           , tmpMovement.isReason_2
                             --
                           , CASE WHEN tmpMovement.ChangePercentAmount > 0 OR tmpMovement.isReason_1 = TRUE OR tmpMovement.isReason_2 = TRUE THEN tmpMovement.MovementId_WeighingPartner ELSE 0 END AS MovementId_WeighingPartner
                           , CASE WHEN tmpMovement.ChangePercentAmount > 0 OR tmpMovement.isReason_1 = TRUE OR tmpMovement.isReason_2 = TRUE THEN tmpMovement.MovementId                 ELSE 0 END AS MovementId_income

                      FROM tmpMI_Income_all AS MovementItem
                           LEFT JOIN tmpMovement ON tmpMovement.MovementId = MovementItem.MovementId

                           LEFT JOIN tmpMI_Float_AmountPartner AS MIFloat_AmountPartner
                                                               ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                              AND MIFloat_AmountPartner.DescId         = zc_MIFloat_AmountPartner()
                           LEFT JOIN tmpMI_Float_Price AS MIFloat_Price
                                                       ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                      AND MIFloat_Price.DescId = zc_MIFloat_Price()

                           LEFT JOIN tmpMILO_GoodsKind_in AS MILinkObject_GoodsKind
                                                          ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                         AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                           LEFT JOIN tmpMILO_GoodsKind_in AS MILinkObject_GoodsReal
                                                          ON MILinkObject_GoodsReal.MovementItemId = MovementItem.Id
                                                         AND MILinkObject_GoodsReal.DescId         = zc_MILinkObject_GoodsReal()
                           LEFT JOIN tmpMILO_GoodsKind_in AS MILinkObject_GoodsKindReal
                                                          ON MILinkObject_GoodsKindReal.MovementItemId = MovementItem.Id
                                                         AND MILinkObject_GoodsKindReal.DescId         = zc_MILinkObject_GoodsKindReal()

                           LEFT JOIN tmpMB_PriceWithVAT AS MovementBoolean_PriceWithVAT
                                                        ON MovementBoolean_PriceWithVAT.MovementId = MovementItem.MovementId
                           LEFT JOIN tmpMF_VATPercent AS MovementFloat_VATPercent
                                                      ON MovementFloat_VATPercent.MovementId = MovementItem.MovementId

                      GROUP BY COALESCE (MILinkObject_GoodsReal.ObjectId, MovementItem.ObjectId)
                             , COALESCE (MILinkObject_GoodsKindReal.ObjectId, MILinkObject_GoodsKind.ObjectId, 0)
                             , MIFloat_Price.ValueData
                             , MovementBoolean_PriceWithVAT.ValueData
                             , COALESCE (MovementFloat_VATPercent.ValueData, 0)
                             , tmpMovement.ChangePercentAmount
                             , tmpMovement.isReason_1
                             , tmpMovement.isReason_2
                             , CASE WHEN tmpMovement.ChangePercentAmount > 0 OR tmpMovement.isReason_1 = TRUE OR tmpMovement.isReason_2 = TRUE THEN tmpMovement.MovementId_WeighingPartner ELSE 0 END
                             , CASE WHEN tmpMovement.ChangePercentAmount > 0 OR tmpMovement.isReason_1 = TRUE OR tmpMovement.isReason_2 = TRUE THEN tmpMovement.MovementId                 ELSE 0 END
                     )
         -- Результат
       , tmpMI_Income AS (SELECT tmpMI_All.MovementId_WeighingPartner
                               , tmpMI_All.MovementId_income
                               , tmpMI_All.GoodsId
                               , tmpMI_All.GoodsKindId
                                 -- Кол-во факт
                               , tmpMI_All.Amount
                                 -- Кол-во факт Поставщик
                               , tmpMI_All.AmountPartner
                                 -- цена без НДС
                               , tmpMI_All.PriceNoVAT
                                 -- цена с НДС
                               , tmpMI_All.PriceWVAT
     
                               , CAST (tmpMI_All.PriceNoVAT * tmpMI_All.Amount AS NUMERIC (16, 2)) AS SummNoVAT
                               , CAST (tmpMI_All.PriceWVAT  * tmpMI_All.Amount AS NUMERIC (16, 2)) AS SummWVAT
     
                                 -- % Скидки для кол-во поставщик
                               , tmpMI_All.ChangePercentAmount
                                 --
                               , tmpMI_All.isReason_1
                               , tmpMI_All.isReason_2
                                 -- накопительное кол-во
                               , SUM (tmpMI_All.Amount) OVER (PARTITION BY tmpMI_All.GoodsId, tmpMI_All.GoodsKindId
                                                              ORDER BY CASE WHEN tmpMI_All.ChangePercentAmount > 0 OR tmpMI_All.isReason_1 = TRUE OR tmpMI_All.isReason_2 = TRUE THEN 0 ELSE 1 END ASC
                                                             ) AS Amount_sum
     
                                 -- № п/п
                               , ROW_NUMBER ()          OVER (PARTITION BY tmpMI_All.GoodsId, tmpMI_All.GoodsKindId
                                                              ORDER BY CASE WHEN tmpMI_All.ChangePercentAmount > 0 OR tmpMI_All.isReason_1 = TRUE OR tmpMI_All.isReason_2 = TRUE THEN 1 ELSE 0 END ASC
                                                             ) 
                               + CASE -- WHEN vbUserId = 5 AND 1=0 THEN 0
                                      WHEN tmp_check.GoodsId IS NULL
                                      THEN 1
                                      ELSE 0
                                 END AS Ord
     
                          FROM tmpMI_All
                               LEFT JOIN (SELECT DISTINCT tmpMI_All.GoodsId, tmpMI_All.GoodsKindId
                                          FROM tmpMI_All
                                          WHERE tmpMI_All.isReason_1 = FALSE AND tmpMI_All.isReason_2 = FALSE -- AND tmpMI_All.ChangePercentAmount = 0
                                         ) AS tmp_check
                                           ON tmp_check.GoodsId     = tmpMI_All.GoodsId
                                          AND tmp_check.GoodsKindId = tmpMI_All.GoodsKindId
                         UNION ALL
                          SELECT 0 AS MovementId_WeighingPartner
                               , 0 AS MovementId_income
                               , tmpMI_All.GoodsId
                               , tmpMI_All.GoodsKindId
                                 -- Кол-во факт
                               , 0 AS Amount
                                 -- Кол-во факт Поставщик
                               , 0 AS AmountPartner
                                 -- цена без НДС
                               , tmpMI_All.PriceNoVAT
                                 -- цена с НДС
                               , tmpMI_All.PriceWVAT
     
                               , 0 AS SummNoVAT
                               , 0 AS SummWVAT
     
                                 -- % Скидки для кол-во поставщик
                               , 0 AS ChangePercentAmount
                                 --
                               , FALSE AS isReason_1
                               , FALSE AS isReason_2
                                 -- накопительное кол-во
                               , tmpMI_All.Amount_sum AS Amount_sum
     
                                 -- № п/п
                               , 1 AS Ord
                           FROM (SELECT tmpMI_All.GoodsId, tmpMI_All.GoodsKindId, tmpMI_All.PriceNoVAT, tmpMI_All.PriceWVAT, SUM (tmpMI_All.Amount) AS Amount_sum
                                 FROM tmpMI_All
                                 GROUP BY tmpMI_All.GoodsId, tmpMI_All.GoodsKindId, tmpMI_All.PriceNoVAT, tmpMI_All.PriceWVAT
                                ) AS tmpMI_All
                                LEFT JOIN (SELECT DISTINCT tmpMI_All.GoodsId, tmpMI_All.GoodsKindId
                                           FROM tmpMI_All
                                           WHERE tmpMI_All.isReason_1 = FALSE AND tmpMI_All.isReason_2 = FALSE -- AND tmpMI_All.ChangePercentAmount = 0
                                          ) AS tmp_check
                                            ON tmp_check.GoodsId     = tmpMI_All.GoodsId
                                           AND tmp_check.GoodsKindId = tmpMI_All.GoodsKindId
                           WHERE tmp_check.GoodsId IS NULL
                           --AND vbUserId <> 5
                         )
       -- Результат
       SELECT ROW_NUMBER() OVER (ORDER BY tmpMI_wp.MovementItemId) :: Integer AS Ord
             -- для 1.Взвешивание - док поставщика
           , CASE WHEN tmpMI_Income.ChangePercentAmount > 0 OR tmpMI_Income.isReason_1 = TRUE OR tmpMI_Income.isReason_2 = TRUE THEN 0                                       ELSE tmpMI_wp.MovementItemId END :: Integer  AS Id
             -- для 1.Взвешивание - док поставщика
           , CASE WHEN tmpMI_Income.ChangePercentAmount > 0 OR tmpMI_Income.isReason_1 = TRUE OR tmpMI_Income.isReason_2 = TRUE THEN 0                                       ELSE tmpMI_wp.MovementId     END :: Integer  AS MovementId
             -- для 2.Взвешивание - док склад
           , CASE WHEN tmpMI_Income.ChangePercentAmount > 0 OR tmpMI_Income.isReason_1 = TRUE OR tmpMI_Income.isReason_2 = TRUE THEN tmpMI_Income.MovementId_WeighingPartner ELSE 0                       END :: Integer  AS MovementId_WeighingPartner
             -- для 2.Взвешивание - док склад
           , CASE WHEN tmpMI_Income.ChangePercentAmount > 0 OR tmpMI_Income.isReason_1 = TRUE OR tmpMI_Income.isReason_2 = TRUE THEN tmpMI_Income.MovementId_income          ELSE 0                       END :: Integer  AS MovementId_income
             --
           , Object_Goods.Id                  AS GoodsId
           , Object_Goods.ObjectCode          AS GoodsCode
           , Object_Goods.ValueData           AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_GoodsKind.Id              AS GoodsKindId
           , Object_GoodsKind.ValueData       AS GoodsKindName
           , Object_Measure.ValueData         AS MeasureName

             -- Количество Поставщика
           , CASE WHEN COALESCE (tmpMI_Income.Ord, 1) = 1
                       -- Сколько осталось
                       THEN tmpMI_wp.AmountPartnerSecond - COALESCE(tmpMI_Income.Amount_sum - tmpMI_Income.Amount, 0)
                  ELSE tmpMI_Income.Amount
             END :: TFloat AS AmountPartnerSecond

             -- цена Поставщика без НДС, до 4 знаков
           , tmpMI_wp.PricePartnerNoVAT          :: TFloat AS PricePartnerNoVAT
             -- цена Поставщика с НДС, до 4 знаков
           , tmpMI_wp.PricePartnerWVAT           :: TFloat AS PricePartnerWVAT

             --  сумма без НДС, до 4 знаков
         --, tmpMI_wp.SummPartnerNoVAT ::TFloat AS SummPartnerNoVAT
           , (CASE WHEN COALESCE (tmpMI_Income.Ord, 1) = 1
                        -- Сколько осталось
                        THEN tmpMI_wp.AmountPartnerSecond - COALESCE(tmpMI_Income.Amount_sum - tmpMI_Income.Amount, 0)
                   ELSE tmpMI_Income.Amount
              END
            * tmpMI_wp.PricePartnerNoVAT
             ) ::TFloat AS SummPartnerNoVAT

             -- сумма с НДС, до 4 знаков
         --, tmpMI_wp.SummPartnerWVAT  ::TFloat AS SummPartnerWVAT
           , (CASE WHEN COALESCE (tmpMI_Income.Ord, 1) = 1
                        -- Сколько осталось
                        THEN tmpMI_wp.AmountPartnerSecond - COALESCE(tmpMI_Income.Amount_sum - tmpMI_Income.Amount, 0)
                   ELSE tmpMI_Income.Amount
              END
            * tmpMI_wp.PricePartnerWVAT
             ) ::TFloat AS SummPartnerWVAT

             -- % скидки кол-во
           , tmpMI_Income.ChangePercentAmount :: TFloat AS ChangePercentAmount

             -- Кол-во (склад)
           , tmpMI_Income.Amount              :: TFloat AS Amount_income

             -- Кол-во Поставщик с учетом % скидки кол-во
           , CASE WHEN tmpMI_Income.ChangePercentAmount > 0 OR tmpMI_Income.isReason_1 = TRUE OR tmpMI_Income.isReason_2 = TRUE
                  -- только здесь % скидки кол-во
                  THEN tmpMI_Income.Amount * (1 - tmpMI_Income.ChangePercentAmount/100)
                  -- Признак "без оплаты"
                  WHEN tmpMI_wp.isAmountPartnerSecond = TRUE
                      -- Сколько осталось
                  THEN tmpMI_wp.AmountPartnerSecond - COALESCE(tmpMI_Income.Amount_sum - tmpMI_Income.Amount, 0)
                  -- Сколько приняли
                  ELSE tmpMI_Income.Amount

             END :: TFloat AS Amount_income_calc

              -- Кол-во Поставщик - Документ Приход от Поставщика - информативно
           , tmpMI_Income.AmountPartner           :: TFloat AS AmountPartner_income

           , tmpMI_Income.PriceNoVAT              :: TFloat AS PriceNoVAT_income
           , tmpMI_Income.PriceWVAT               :: TFloat AS PriceWVat_income
           , tmpMI_Income.SummNoVAT               :: TFloat AS SummNoVAT_income
           , tmpMI_Income.SummWVAT                :: TFloat AS SummWVAT_income

             -- Разница в количестве
           , (-- наши данные
              CASE WHEN tmpMI_Income.ChangePercentAmount > 0 OR tmpMI_Income.isReason_1 = TRUE OR tmpMI_Income.isReason_2 = TRUE
                   -- только здесь % скидки кол-во
                   THEN tmpMI_Income.Amount * (1 - tmpMI_Income.ChangePercentAmount/100)
                   -- Признак "без оплаты"
                   WHEN tmpMI_wp.isAmountPartnerSecond = TRUE
                       -- Сколько осталось
                   THEN tmpMI_wp.AmountPartnerSecond - COALESCE(tmpMI_Income.Amount_sum - tmpMI_Income.Amount, 0)
                   -- Сколько приняли
                   ELSE tmpMI_Income.Amount
 
              END
              -- док поставщика
            - CASE WHEN COALESCE (tmpMI_Income.Ord, 1) = 1
                        -- Сколько осталось
                        THEN tmpMI_wp.AmountPartnerSecond - COALESCE(tmpMI_Income.Amount_sum - tmpMI_Income.Amount, 0)
                   ELSE tmpMI_Income.Amount
              END
             ) :: TFloat AS Amount_diff

             -- Разница в цене без НДС
           , (COALESCE (tmpMI_Income.PriceNoVAT,0) - tmpMI_wp.PricePartnerNoVAT
             ) :: TFloat AS Price_diff
             
             -- Сумма разницы без НДС
           , (-- наши данные
              CASE WHEN tmpMI_Income.ChangePercentAmount > 0 OR tmpMI_Income.isReason_1 = TRUE OR tmpMI_Income.isReason_2 = TRUE
                   -- только здесь % скидки кол-во
                   THEN tmpMI_Income.Amount * (1 - tmpMI_Income.ChangePercentAmount/100)
                   -- Признак "без оплаты"
                   WHEN tmpMI_wp.isAmountPartnerSecond = TRUE
                       -- Сколько осталось
                   THEN tmpMI_wp.AmountPartnerSecond - COALESCE(tmpMI_Income.Amount_sum - tmpMI_Income.Amount, 0)
                   -- Сколько приняли
                   ELSE tmpMI_Income.Amount
  
              END * tmpMI_Income.PriceNoVAT
              -- док поставщика
            - CASE WHEN COALESCE (tmpMI_Income.Ord, 1) = 1
                        -- Сколько осталось
                        THEN tmpMI_wp.AmountPartnerSecond - COALESCE(tmpMI_Income.Amount_sum - tmpMI_Income.Amount, 0)
                   ELSE tmpMI_Income.Amount
              END
            * tmpMI_wp.PricePartnerNoVAT
             
             ) :: TFloat AS Summ_diff

             -- Признак "без оплаты"
           , CASE WHEN tmpMI_Income.ChangePercentAmount > 0 OR tmpMI_Income.isReason_1 = TRUE OR tmpMI_Income.isReason_2 = TRUE
                       THEN FALSE
                  ELSE tmpMI_wp.isAmountPartnerSecond
             END ::Boolean AS isAmountPartnerSecond
                  
             -- Возврат да/нет
           , CASE WHEN tmpMI_Income.ChangePercentAmount > 0 OR tmpMI_Income.isReason_1 = TRUE OR tmpMI_Income.isReason_2 = TRUE
                       THEN FALSE
                  ELSE tmpMI_wp.isReturnOut
             END ::Boolean AS isReturnOut

             -- Причина скидки в кол-ве температура
           , tmpMI_Income.isReason_1
             -- Причина скидки в кол-ве качество
           , tmpMI_Income.isReason_2
             -- Причина
           , CASE WHEN tmpMI_Income.isReason_1 = TRUE
                  THEN 'знижка за невідповідність температури' -- 'скидка за несоотвестветствие температуры'
                  WHEN tmpMI_Income.isReason_2 = TRUE
                  THEN 'знижка за невідповідність якості' -- 'скидка за несоотвестветствие качеству'
                  ELSE ''
             END :: TVarChar AS ReasonName
             --
           , tmpMI_wp.Comment               ::TVarChar

           , FALSE :: Boolean AS isErased

       FROM tmpMI_wp
            LEFT JOIN Object AS Object_Goods     ON Object_Goods.Id     = tmpMI_wp.GoodsId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMI_wp.GoodsKindId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpMI_wp.GoodsId
                                AND ObjectLink_Goods_Measure.DescId   = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpMI_wp.GoodsId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN tmpMI_Income ON tmpMI_Income.GoodsId     = tmpMI_wp.GoodsId
                                  AND tmpMI_Income.GoodsKindId = tmpMI_wp.GoodsKindId
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.10.24         *
*/

-- тест
-- SELECT * FROM gpSelect_MI_WeighingPartner_diff (inMovementId:= 29882295, inIsErased:= TRUE, inSession:= '2')
