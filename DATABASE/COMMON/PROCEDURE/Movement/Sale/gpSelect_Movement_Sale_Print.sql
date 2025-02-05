-- Function: gpSelect_Movement_Sale_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_Sale_Print (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Sale_Print(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;
    DECLARE Cursor3 refcursor;

    DECLARE vbGoodsPropertyId Integer;
    DECLARE vbGoodsPropertyId_basis Integer;

    DECLARE vbOperDate TDateTime;
    DECLARE vbOperDatePartner TDateTime;
    DECLARE vbDescId Integer;
    DECLARE vbStatusId Integer;
    DECLARE vbPriceWithVAT Boolean;
    DECLARE vbVATPercent TFloat;
    DECLARE vbDiscountPercent TFloat;
    DECLARE vbExtraChargesPercent TFloat;
    DECLARE vbPaidKindId Integer;
    DECLARE vbContractId Integer;
    DECLARE vbIsChangePrice Boolean;
    DECLARE vbIsDiscountPrice Boolean;

    DECLARE vbOperSumm_MVAT TFloat;
    DECLARE vbOperSumm_PVAT TFloat;
    DECLARE vbTotalCountKg  TFloat;
    DECLARE vbTotalCountSh  TFloat;
    DECLARE vbTotalCountSh_Kg TFloat;
    DECLARE vbTotalCountKg_only TFloat;

    DECLARE vbIsProcess_BranchIn Boolean;
    DECLARE vbIsGoodsCode Boolean;

    DECLARE vbWeighingCount   Integer;
    DECLARE vbStoreKeeperName TVarChar;

    DECLARE vbIsInfoMoney_30201 Boolean;
    DECLARE vbIsInfoMoney_30200 Boolean;

    DECLARE vbIsKiev Boolean;

    DECLARE vbIsPrice_Pledge_25 Boolean;

    DECLARE vbIsOKPO_04544524 Boolean;
    DECLARE vbIsOKPO_40075815 Boolean;

    DECLARE vbIsLongUKTZED Boolean;

    DECLARE vbOKPO TVarChar;

    DECLARE vbOperDate_Begin1 TDateTime;

    DECLARE vbMovementId_tax Integer;
    DECLARE vbCountMI Integer;
BEGIN
     -- сразу запомнили время начала выполнения Проц.
     vbOperDate_Begin1:= CLOCK_TIMESTAMP();

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Sale());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!! для Киева + Львов
     vbIsKiev:= EXISTS (SELECT 1 FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.ObjectId IN (8411, 3080691) AND MLO.DescId = zc_MovementLinkObject_From());


     -- кол-во Взвешиваний
     vbWeighingCount:= (SELECT COUNT(*)
                        FROM Movement
                        WHERE Movement.ParentId = inMovementId AND Movement.DescId IN (zc_Movement_WeighingPartner(), zc_Movement_WeighingProduction())
                          AND Movement.StatusId = zc_Enum_Status_Complete()
                       );

     -- параметры из Взвешивания
     vbStoreKeeperName:= (SELECT Object_User.ValueData
                          FROM Movement
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_User
                                                            ON MovementLinkObject_User.MovementId = Movement.Id
                                                           AND MovementLinkObject_User.DescId = zc_MovementLinkObject_User()
                               LEFT JOIN Object AS Object_User ON Object_User.Id = MovementLinkObject_User.ObjectId
                          WHERE Movement.ParentId = inMovementId AND Movement.DescId IN (zc_Movement_WeighingPartner(), zc_Movement_WeighingProduction())
                            AND Movement.StatusId = zc_Enum_Status_Complete()
                          LIMIT 1
                         );


     -- Проверка
     IF EXISTS (SELECT 1
                FROM Movement
                     LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                            ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                           AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                WHERE Movement.Id = inMovementId AND Movement.DescId = zc_Movement_Sale()
                  AND COALESCE (MovementDate_OperDatePartner.ValueData, zc_DateStart()) < (Movement.OperDate - INTERVAL '15 DAY')
                  AND (EXTRACT (MONTH FROM Movement.OperDate) = EXTRACT (MONTH FROM CURRENT_DATE)
                    OR EXTRACT (MONTH FROM Movement.OperDate) = EXTRACT (MONTH FROM CURRENT_DATE - INTERVAL '17 DAY')
                      )
               )
     THEN
         RAISE EXCEPTION 'Ошибка.В документе от <%> неверное значение дата у покупателя <%>.', zfConvert_DateToString ((SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId))
                                                                                             , zfConvert_DateToString ((SELECT MovementDate.ValueData FROM MovementDate WHERE MovementDate.MovementId = inMovementId AND MovementDate.DescId = zc_MovementDate_OperDatePartner()));
     END IF;


     -- Параметры - захардкодили
     SELECT -- ТОВАРИСТВО З ОБМЕЖЕНОЮ ВІДПОВІДАЛЬНІСТЮ"АРІТЕЙЛ"
            CASE WHEN OH_JuridicalDetails_To.OKPO = '41135005'
                      THEN TRUE
                      ELSE FALSE
            END AS isGoodsCode

            -- ТОВАРИСТВО З ОБМЕЖЕНОЮ ВІДПОВІДАЛЬНІСТЮ "ФУДКОМ"
          , CASE WHEN OH_JuridicalDetails_To.OKPO = '40982829'
                      THEN TRUE
                      ELSE FALSE
            END AS isPrice_Pledge_25

            -- КЗ "ДФКС "ДОР"
          , CASE WHEN OH_JuridicalDetails_To.OKPO = '04544524'
                      THEN TRUE
                      ELSE FALSE
            END AS isOKPO_04544524

            -- Українська залізниця АТ СТРУКТУРНИЙ ПІДРОЗДІЛ "Запорізьке моторвагонне депо" м. Запоріжжя вул. Аваліані буд.4 Б
          , CASE WHEN OH_JuridicalDetails_To.OKPO = '40075815'
                   AND MovementLinkObject_To.ObjectId = 3470516 
                      THEN TRUE
                      ELSE FALSE
            END AS isOKPO_40075815

          , OH_JuridicalDetails_To.OKPO

            INTO vbIsGoodsCode, vbIsPrice_Pledge_25, vbIsOKPO_04544524, vbIsOKPO_40075815, vbOKPO

     FROM Movement
          LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                 ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                               ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                              AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()

          LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_To
                                                              ON OH_JuridicalDetails_To.JuridicalId = COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MovementLinkObject_To.ObjectId)
                                                             AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) >= OH_JuridicalDetails_To.StartDate
                                                             AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) <  OH_JuridicalDetails_To.EndDate
     WHERE Movement.Id     = inMovementId
       AND Movement.DescId <> zc_Movement_SendOnPrice()
     ;

     -- параметры из документа
     SELECT Movement.OperDate
          , MovementDate_OperDatePartner.ValueData
          , Movement.DescId
          , Movement.StatusId
          , COALESCE (MovementBoolean_PriceWithVAT.ValueData, TRUE) AS PriceWithVAT
          , COALESCE (MovementFloat_VATPercent.ValueData, 0)        AS VATPercent
          , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) < 0 THEN -1 * MovementFloat_ChangePercent.ValueData ELSE 0 END AS DiscountPercent
          , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) > 0 THEN      MovementFloat_ChangePercent.ValueData ELSE 0 END AS ExtraChargesPercent
          , zfCalc_GoodsPropertyId (MovementLinkObject_Contract.ObjectId, COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MovementLinkObject_To.ObjectId), MovementLinkObject_To.ObjectId) AS GoodsPropertyId
          , zfCalc_GoodsPropertyId (0, zc_Juridical_Basis(), 0)       AS GoodsPropertyId_basis
          , COALESCE (MovementLinkObject_PaidKind.ObjectId, 0)        AS PaidKindId
          , COALESCE (MovementLinkObject_Contract.ObjectId, 0)        AS ContractId
          , COALESCE (ObjectBoolean_isDiscountPrice.ValueData, FALSE) AS isDiscountPrice_juridical
          , CASE WHEN COALESCE (ObjectLink_Contract_InfoMoney.ChildObjectId, 0) = zc_Enum_InfoMoney_30201() -- Параметр для Мясное сырье
                     THEN TRUE
                 ELSE FALSE
            END AS isInfoMoney_30200
          , COALESCE (ObjectBoolean_isLongUKTZED.ValueData, TRUE)    AS isLongUKTZED

          , MovementLinkMovement_Master.MovementChildId AS MovementId_tax

            INTO vbOperDate, vbOperDatePartner, vbDescId, vbStatusId, vbPriceWithVAT, vbVATPercent, vbDiscountPercent, vbExtraChargesPercent, vbGoodsPropertyId, vbGoodsPropertyId_basis, vbPaidKindId, vbContractId, vbIsDiscountPrice
               , vbIsInfoMoney_30200, vbIsLongUKTZED
               , vbMovementId_tax
     FROM Movement
          LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                 ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                AND MovementDate_OperDatePartner.DescId     = zc_MovementDate_OperDatePartner()
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

          LEFT JOIN ObjectLink AS ObjectLink_Contract_InfoMoney
                               ON ObjectLink_Contract_InfoMoney.ObjectId = MovementLinkObject_Contract.ObjectId
                              AND ObjectLink_Contract_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()

          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                               ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                              AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
          -- LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
          --                      ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
          --                     AND ObjectLink_Juridical_Retail.DescId   = zc_ObjectLink_Juridical_Retail()
          LEFT JOIN ObjectBoolean AS ObjectBoolean_isDiscountPrice
                                  ON ObjectBoolean_isDiscountPrice.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                 AND ObjectBoolean_isDiscountPrice.DescId = zc_ObjectBoolean_Juridical_isDiscountPrice()

          LEFT JOIN ObjectBoolean AS ObjectBoolean_isLongUKTZED
                                  ON ObjectBoolean_isLongUKTZED.ObjectId = MovementLinkObject_To.ObjectId
                                 AND ObjectBoolean_isLongUKTZED.DescId = zc_ObjectBoolean_Juridical_isLongUKTZED()

          /*LEFT JOIN ObjectLink AS ObjectLink_Juridical_GoodsProperty
                               ON ObjectLink_Juridical_GoodsProperty.ObjectId = COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MovementLinkObject_To.ObjectId)
                              AND ObjectLink_Juridical_GoodsProperty.DescId = zc_ObjectLink_Juridical_GoodsProperty()
          LEFT JOIN ObjectLink AS ObjectLink_JuridicalBasis_GoodsProperty
                               ON ObjectLink_JuridicalBasis_GoodsProperty.ObjectId = zc_Juridical_Basis()
                              AND ObjectLink_JuridicalBasis_GoodsProperty.DescId = zc_ObjectLink_Juridical_GoodsProperty()*/

          LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Master
                                         ON MovementLinkMovement_Master.MovementId = Movement.Id
                                        AND MovementLinkMovement_Master.DescId = zc_MovementLinkMovement_Master()
          LEFT JOIN Movement AS Movement_DocumentMaster ON Movement_DocumentMaster.Id = MovementLinkMovement_Master.MovementChildId

     WHERE Movement.Id = inMovementId AND Movement.DescId <> zc_Movement_SendOnPrice()
       -- AND Movement.StatusId = zc_Enum_Status_Complete()
    ;

IF vbUserId = 5 AND 1=0
THEN
    RAISE EXCEPTION 'Ошибка.<%>  <%>', vbGoodsPropertyId, lfGet_Object_ValueData_sh (vbGoodsPropertyId);
END IF;


     -- !!!надо определить - есть ли скидка в цене!!!
     vbIsChangePrice:= vbIsDiscountPrice = TRUE                              -- у Юр лица есть галка
                    OR vbPaidKindId = zc_Enum_PaidKind_FirstForm()           -- это БН
                    OR ((vbDiscountPercent > 0 OR vbExtraChargesPercent > 0) -- в шапке есть скидка, но есть хоть один элемент со скидкой = 0%
                        AND EXISTS (SELECT 1
                                    FROM MovementItem
                                         LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                                                     ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                                                    AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()
                                    WHERE MovementItem.MovementId = inMovementId
                                      AND MovementItem.DescId = zc_MI_Master()
                                      AND MovementItem.isErased = FALSE
                                      AND COALESCE (MIFloat_ChangePercent.ValueData, 0) = 0
                                   ));


    -- Важный параметр - Прихрд на филиала или расход с филиала (в первом слчае вводится только "Дата (приход)")
    vbIsProcess_BranchIn:= EXISTS (SELECT Id FROM Object_Unit_View WHERE Id = (SELECT ObjectId FROM MovementLinkObject WHERE MovementId = inMovementId AND DescId = zc_MovementLinkObject_To()) AND BranchId = (SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.BranchId))
                           ;

    -- очень важная проверка
    IF COALESCE (vbStatusId, 0) <> zc_Enum_Status_Complete() AND inSession <> zfCalc_UserAdmin()
    THEN
        IF vbStatusId = zc_Enum_Status_Erased()
        THEN
            RAISE EXCEPTION 'Ошибка.Документ <%> № <%> от <%> удален.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
        END IF;
        IF vbStatusId = zc_Enum_Status_UnComplete()
        THEN
            RAISE EXCEPTION 'Ошибка.Документ <%> № <%> от <%> не проведен.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
        END IF;
        -- это уже странная ошибка
        RAISE EXCEPTION 'Ошибка.Документ <%>.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId);
    END IF;

    -- получаем данные для GoodsPropertyValue - нужны в обоих курсорах
    CREATE TEMP TABLE tmpObject_GoodsPropertyValue (ObjectId Integer, GoodsId Integer, GoodsKindId Integer, Name TVarChar,
                                                    Amount TFloat, AmountDoc TFloat, BoxCount TFloat,
                                                    BarCode TVarChar, Article TVarChar,
                                                    BarCodeGLN  TVarChar, ArticleGLN TVarChar,
                                                    isWeigth Boolean) ON COMMIT DROP;
    INSERT INTO  tmpObject_GoodsPropertyValue (ObjectId, GoodsId, GoodsKindId, Name, Amount, AmountDoc, BoxCount, BarCode, Article, BarCodeGLN, ArticleGLN, isWeigth)
        SELECT ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
             , ObjectLink_GoodsPropertyValue_Goods.ChildObjectId                   AS GoodsId
             , COALESCE (ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId, 0) AS GoodsKindId
             , Object_GoodsPropertyValue.ValueData  AS Name
             , ObjectFloat_Amount.ValueData         AS Amount
             , ObjectFloat_AmountDoc.ValueData      AS AmountDoc
             , ObjectFloat_BoxCount.ValueData       AS BoxCount
             , ObjectString_BarCode.ValueData       AS BarCode
             , ObjectString_Article.ValueData       AS Article
             , ObjectString_BarCodeGLN.ValueData    AS BarCodeGLN
             , ObjectString_ArticleGLN.ValueData    AS ArticleGLN
             , COALESCE (ObjectBoolean_Weigth.ValueData, FALSE) :: Boolean AS isWeigth
        FROM (SELECT vbGoodsPropertyId AS GoodsPropertyId WHERE vbGoodsPropertyId <> 0
             ) AS tmpGoodsProperty
             INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                   ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = tmpGoodsProperty.GoodsPropertyId
                                  AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
             LEFT JOIN Object AS Object_GoodsPropertyValue ON Object_GoodsPropertyValue.Id = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
             LEFT JOIN ObjectFloat AS ObjectFloat_Amount
                                   ON ObjectFloat_Amount.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                  AND ObjectFloat_Amount.DescId = zc_ObjectFloat_GoodsPropertyValue_Amount()
             LEFT JOIN ObjectFloat AS ObjectFloat_AmountDoc
                                   ON ObjectFloat_AmountDoc.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                  AND ObjectFloat_AmountDoc.DescId = zc_ObjectFloat_GoodsPropertyValue_AmountDoc()
             LEFT JOIN ObjectFloat AS ObjectFloat_BoxCount
                                   ON ObjectFloat_BoxCount.ObjectId = Object_GoodsPropertyValue.Id
                                  AND ObjectFloat_BoxCount.DescId = zc_ObjectFloat_GoodsPropertyValue_BoxCount()
             LEFT JOIN ObjectString AS ObjectString_BarCode
                                    ON ObjectString_BarCode.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                   AND ObjectString_BarCode.DescId = zc_ObjectString_GoodsPropertyValue_BarCode()
             LEFT JOIN ObjectString AS ObjectString_Article
                                    ON ObjectString_Article.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                   AND ObjectString_Article.DescId = zc_ObjectString_GoodsPropertyValue_Article()

             LEFT JOIN ObjectString AS ObjectString_BarCodeGLN
                                    ON ObjectString_BarCodeGLN.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                   AND ObjectString_BarCodeGLN.DescId = zc_ObjectString_GoodsPropertyValue_BarCodeGLN()
             LEFT JOIN ObjectString AS ObjectString_ArticleGLN
                                    ON ObjectString_ArticleGLN.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                   AND ObjectString_ArticleGLN.DescId = zc_ObjectString_GoodsPropertyValue_ArticleGLN()

             LEFT JOIN ObjectBoolean AS ObjectBoolean_Weigth
                                     ON ObjectBoolean_Weigth.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                    AND ObjectBoolean_Weigth.DescId = zc_ObjectBoolean_GoodsPropertyValue_Weigth()

             LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                  ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                 AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
             LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                  ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                 AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
         ;


    IF vbIsProcess_BranchIn = FALSE AND vbDescId = zc_Movement_SendOnPrice()
    THEN
        -- Расчет Сумм
        SELECT CASE WHEN NOT vbPriceWithVAT OR vbVATPercent = 0
                         -- если цены без НДС или %НДС=0
                         THEN OperSumm
                    WHEN vbPriceWithVAT AND 1=1
                         -- если цены c НДС
                         THEN CAST ( (OperSumm) / (1 + vbVATPercent / 100) AS NUMERIC (16, 2))
                    WHEN vbPriceWithVAT
                         -- если цены c НДС (Вариант может быть если первичен расчет НДС =1/6 )
                         THEN OperSumm - CAST ( (OperSumm) / (100 / vbVATPercent + 1) AS NUMERIC (16, 2))
               END AS OperSumm_MVAT
               -- Сумма с НДС
             , CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                         -- если цены с НДС
                         THEN (OperSumm)
                    WHEN vbVATPercent > 0
                         -- если цены без НДС
                         THEN CAST ( (1 + vbVATPercent / 100) * (OperSumm) AS NUMERIC (16, 2))
               END AS OperSumm_PVAT
             , TotalCountKg
             , TotalCountKg_only
             , TotalCountSh
             , TotalCountSh_Kg

               INTO vbOperSumm_MVAT, vbOperSumm_PVAT
                  , vbTotalCountKg, vbTotalCountKg_only, vbTotalCountSh, vbTotalCountSh_Kg

        FROM
       (SELECT SUM (CASE WHEN tmpMI.CountForPrice <> 0
                              THEN CAST (tmpMI.Amount * tmpMI.Price / tmpMI.CountForPrice AS NUMERIC (16, 2))
                         ELSE CAST (tmpMI.Amount * tmpMI.Price AS NUMERIC (16, 2))
                    END
                   ) AS OperSumm

                         -- ШТ
                       , SUM (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() AND COALESCE (tmpObject_GoodsPropertyValue.isWeigth,FALSE) = FALSE
                                   THEN tmpMI.Amount
                              ELSE 0
                         END) AS TotalCountSh
                         -- ВЕС
                       , SUM (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()
                                   THEN tmpMI.Amount * COALESCE (ObjectFloat_Weight.ValueData, 0)
                              WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Kg()
                                   THEN tmpMI.Amount
                              ELSE 0
                         END) AS TotalCountKg
                         -- ВЕС - только если весовой
                       , SUM (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()
                                   THEN 0
                              WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Kg()
                                   THEN tmpMI.Amount
                              ELSE 0
                         END) AS TotalCountKg_only

                         -- для ШТ, если сво-во tmpObject_GoodsPropertyValue.isWeigth = TRUE, нужно єто кол-во снять с итого шт.
                       , SUM (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() AND COALESCE (tmpObject_GoodsPropertyValue.isWeigth, FALSE) = TRUE
                                   THEN tmpMI.Amount
                              ELSE 0
                         END) AS TotalCountSh_Kg

        FROM (SELECT MovementItem.ObjectId AS GoodsId
                   , COALESCE (MILinkObject_GoodsKind.ObjectId, zc_GoodsKind_Basis()) AS GoodsKindId
                   , CASE WHEN MIFloat_ChangePercent.ValueData <> 0
                               THEN zfCalc_PriceTruncate (inOperDate     := vbOperDatePartner
                                                        , inChangePercent:= MIFloat_ChangePercent.ValueData
                                                        , inPrice        := COALESCE (MIFloat_PriceTare.ValueData, MIFloat_Price.ValueData, 0)
                                                        , inIsWithVAT    := vbPriceWithVAT
                                                         )
                          /*WHEN vbDiscountPercent <> 0
                               THEN CAST ( (1 - vbDiscountPercent / 100) * COALESCE (MIFloat_PriceTare.ValueData, MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2))
                          WHEN vbExtraChargesPercent <> 0
                               THEN CAST ( (1 + vbExtraChargesPercent / 100) * COALESCE (MIFloat_PriceTare.ValueData, MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2))*/
                          ELSE COALESCE (MIFloat_PriceTare.ValueData, MIFloat_Price.ValueData, 0)

                     END AS Price
                   , COALESCE (MIFloat_CountForPrice.ValueData, 0) AS CountForPrice
                   -- , SUM (MovementItem.Amount) AS Amount
                   , SUM (CASE WHEN Movement.DescId IN (zc_Movement_Sale())
                                    THEN COALESCE (MIFloat_AmountPartner.ValueData, 0)
                               WHEN Movement.DescId IN (zc_Movement_SendOnPrice()) AND vbIsProcess_BranchIn = TRUE
                                    THEN COALESCE (MIFloat_AmountPartner.ValueData, 0)
                               ELSE MovementItem.Amount

                          END) AS Amount
              FROM MovementItem
                   INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                   LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                               ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                              AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                   LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                               ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                              AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()
                   LEFT JOIN MovementItemFloat AS MIFloat_Price
                                               ON MIFloat_Price.MovementItemId = MovementItem.Id
                                              AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                               -- AND MIFloat_Price.ValueData <> 0
                   --если MIFloat_Price.ValueData = 0, тогда берем zc_MIFloat_PriceTare
                   LEFT JOIN MovementItemFloat AS MIFloat_PriceTare
                                               ON MIFloat_PriceTare.MovementItemId = MovementItem.Id
                                              AND MIFloat_PriceTare.DescId = zc_MIFloat_PriceTare()
                                              AND COALESCE (MIFloat_Price.ValueData,0) = 0

                   LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                               ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                              AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                    ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
              WHERE MovementItem.MovementId = inMovementId
                AND MovementItem.isErased = FALSE
              GROUP BY MovementItem.ObjectId
                     , MILinkObject_GoodsKind.ObjectId
                     , MIFloat_Price.ValueData
                     , MIFloat_PriceTare.ValueData
                     , MIFloat_CountForPrice.ValueData
                     , MIFloat_ChangePercent.ValueData
             ) AS tmpMI
                       LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                             ON ObjectFloat_Weight.ObjectId = tmpMI.GoodsId
                                            AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                       LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                            ON ObjectLink_Goods_Measure.ObjectId = tmpMI.GoodsId
                                           AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                       LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                            ON ObjectLink_Goods_InfoMoney.ObjectId = tmpMI.GoodsId
                                           AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                       LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

                       LEFT JOIN tmpObject_GoodsPropertyValue ON tmpObject_GoodsPropertyValue.GoodsId = tmpMI.GoodsId
                                                             AND tmpObject_GoodsPropertyValue.GoodsKindId = tmpMI.GoodsKindId
                                                             AND (tmpObject_GoodsPropertyValue.Article <> ''
                                                               OR tmpObject_GoodsPropertyValue.BarCode <> ''
                                                               OR tmpObject_GoodsPropertyValue.ArticleGLN <> ''
                                                               OR tmpObject_GoodsPropertyValue.Name <> '')
        ) AS tmpMI;
    ELSE
            -- Расчет шт для штучного товара, который нужно показать как кг, чтоб снять это кол-во с итого шт.
        SELECT TotalCountSh_Kg, TotalCountKg_only
               INTO vbTotalCountSh_Kg, vbTotalCountKg_only
        FROM (SELECT -- для ШТ, если сво-во tmpObject_GoodsPropertyValue.isWeigth = TRUE, нужно єто кол-во снять с итого шт.
                     SUM (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() AND COALESCE (tmpObject_GoodsPropertyValue.isWeigth,FALSE) = TRUE
                                    THEN tmpMI.Amount
                               ELSE 0
                          END) AS TotalCountSh_Kg
                         -- ВЕС - только если весовой
                   , SUM (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()
                               THEN 0
                          WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Kg()
                               THEN tmpMI.Amount
                          ELSE 0
                     END) AS TotalCountKg_only
              FROM (SELECT MovementItem.ObjectId AS GoodsId
                         , COALESCE (MILinkObject_GoodsKind.ObjectId, zc_GoodsKind_Basis()) AS GoodsKindId
                         , SUM (CASE WHEN Movement.DescId IN (zc_Movement_Sale())
                                          THEN COALESCE (MIFloat_AmountPartner.ValueData, 0)
                                     WHEN Movement.DescId IN (zc_Movement_SendOnPrice()) AND vbIsProcess_BranchIn = TRUE
                                          THEN COALESCE (MIFloat_AmountPartner.ValueData, 0)
                                     ELSE MovementItem.Amount
                                END) AS Amount
                    FROM MovementItem
                         INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                         LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                     ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                    AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                         LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                          ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                         AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                    WHERE MovementItem.MovementId = inMovementId
                      AND MovementItem.isErased = FALSE
                    GROUP BY MovementItem.ObjectId
                           , MILinkObject_GoodsKind.ObjectId
                   ) AS tmpMI
                        LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                             ON ObjectLink_Goods_Measure.ObjectId = tmpMI.GoodsId
                                            AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()

                        LEFT JOIN tmpObject_GoodsPropertyValue ON tmpObject_GoodsPropertyValue.GoodsId = tmpMI.GoodsId
                                                              AND tmpObject_GoodsPropertyValue.GoodsKindId = tmpMI.GoodsKindId
                                                              AND (tmpObject_GoodsPropertyValue.Article <> ''
                                                                OR tmpObject_GoodsPropertyValue.BarCode <> ''
                                                                OR tmpObject_GoodsPropertyValue.ArticleGLN <> ''
                                                                OR tmpObject_GoodsPropertyValue.Name <> '')
             ) AS tmpMI;
    END IF;


    -- Параметр для Доходы + Продукция + Тушенка
    vbIsInfoMoney_30201:= EXISTS (SELECT 1
                                  FROM MovementItem
                                       INNER JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                             ON ObjectLink_Goods_InfoMoney.ObjectId = MovementItem.ObjectId
                                                            AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                                                            AND ObjectLink_Goods_InfoMoney.ChildObjectId = zc_Enum_InfoMoney_30102()
                                  WHERE MovementItem.MovementId = inMovementId
                                    AND MovementItem.DescId     = zc_MI_Master()
                                    AND MovementItem.isErased   = FALSE);


    --если мало строк, на печати выводим на 1 странице 2 копии
    vbCountMI := (SELECT Count (*)
                  FROM MovementItem
                  WHERE MovementItem.MovementId = inMovementId
                    AND MovementItem.DescId = zc_MI_Master()
                    AND MovementItem.isErased = FALSE
                  );
     --
    OPEN Cursor1 FOR
--     WITH tmpObject_GoodsPropertyValue AS
       WITH tmpBankAccount AS (SELECT ObjectLink_BankAccountContract_BankAccount.ChildObjectId             AS BankAccountId
                                    , COALESCE (ObjectLink_BankAccountContract_InfoMoney.ChildObjectId, 0) AS InfoMoneyId
                                    , COALESCE (ObjectLink_BankAccountContract_Unit.ChildObjectId, 0)      AS UnitId
                               FROM ObjectLink AS ObjectLink_BankAccountContract_BankAccount
                                    INNER JOIN Object AS Object_BankAccountContract ON Object_BankAccountContract.Id       = ObjectLink_BankAccountContract_BankAccount.ObjectId
                                                                                   AND Object_BankAccountContract.isErased = FALSE
                                    LEFT JOIN ObjectLink AS ObjectLink_BankAccountContract_InfoMoney
                                                         ON ObjectLink_BankAccountContract_InfoMoney.ObjectId = ObjectLink_BankAccountContract_BankAccount.ObjectId
                                                        AND ObjectLink_BankAccountContract_InfoMoney.DescId = zc_ObjectLink_BankAccountContract_InfoMoney()
                                    LEFT JOIN ObjectLink AS ObjectLink_BankAccountContract_Unit
                                                          ON ObjectLink_BankAccountContract_Unit.ObjectId = ObjectLink_BankAccountContract_InfoMoney.ObjectId
                                                         AND ObjectLink_BankAccountContract_Unit.DescId = zc_ObjectLink_BankAccountContract_Unit()
                               WHERE ObjectLink_BankAccountContract_BankAccount.DescId = zc_ObjectLink_BankAccountContract_BankAccount()
                                 AND ObjectLink_BankAccountContract_BankAccount.ChildObjectId IS NOT NULL
                              )
          , tmpObject_Bank_View AS(SELECT *
                                   FROM Object_Bank_View)
          , tmpMovementString AS (SELECT *
                                  FROM MovementString
                                  WHERE MovementString.MovementId = inMovementId
                                    AND MovementString.DescId IN (zc_MovementString_InvNumberOrder()
                                                                , zc_MovementString_Comment()
                                                                , zc_MovementString_InvNumberPartner()
                                                                 )
                                  )
          , tmpMovementDate AS (SELECT *
                                  FROM MovementDate
                                  WHERE MovementDate.MovementId = inMovementId
                                    AND MovementDate.DescId IN (zc_MovementDate_Payment()
                                                              , zc_MovementDate_OperDatePartner()
                                                                 )
                                  )

          , tmpMovementLinkMovement AS (SELECT *
                                  FROM MovementLinkMovement
                                  WHERE MovementLinkMovement.MovementId = inMovementId
                                    AND MovementLinkMovement.DescId IN (zc_MovementLinkMovement_Sale()
                                                                      , zc_MovementLinkMovement_Order()
                                                                      , zc_MovementLinkMovement_Master()
                                                                 )
                                )

          , tmpMovementString_ord AS (SELECT *
                                  FROM MovementString
                                  WHERE MovementString.MovementId IN (SELECT DISTINCT tmpMovementLinkMovement.MovementChildId FROM tmpMovementLinkMovement)
                                    AND MovementString.DescId IN (zc_MovementString_Comment()
                                                                , zc_MovementString_InvNumberPartner()
                                                                 )
                                  )


          , tmpMovementFloat AS (SELECT *
                                  FROM MovementFloat
                                  WHERE MovementFloat.MovementId = inMovementId
                                    AND MovementFloat.DescId IN (zc_MovementFloat_TotalCountPartner()
                                                                , zc_MovementFloat_TotalCountKg()
                                                                , zc_MovementFloat_TotalCountSh()
                                                                , zc_MovementFloat_TotalSummMVAT()
                                                                , zc_MovementFloat_TotalSummPVAT()
                                                                , zc_MovementFloat_TotalSumm()
                                                                , zc_MovementFloat_TotalSummTare()
                                                                , zc_MovementFloat_TotalCountTare()
                                                                 )
                                  )

          , tmpMovement AS (SELECT * FROM Movement WHERE Movement.Id = inMovementId)

       SELECT
             Movement.Id                                AS Id
           , zfFormat_BarCode (zc_BarCodePref_Movement(), Movement.Id) AS IdBarCode
--         , Movement.InvNumber                         AS InvNumber
           , CASE WHEN Movement.DescId = zc_Movement_Sale()
                       THEN Movement.InvNumber
                  WHEN Movement.DescId = zc_Movement_TransferDebtOut() AND MovementString_InvNumberPartner.ValueData <> ''
                       THEN COALESCE (MovementString_InvNumberPartner.ValueData, Movement.InvNumber)
                  WHEN Movement.DescId = zc_Movement_TransferDebtOut() AND MovementString_InvNumberPartner.ValueData = ''
                       THEN Movement.InvNumber
                  ELSE Movement.InvNumber
             END AS InvNumber

           , MovementString_InvNumberPartner.ValueData  AS InvNumberPartner

           , CASE WHEN MovementString_InvNumberPartner_order.ValueData <> ''
                       THEN CASE WHEN zfConvert_StringToNumber (MovementString_InvNumberPartner_order.ValueData) <> 0
                                      THEN zfConvert_StringToNumber (MovementString_InvNumberPartner_order.ValueData) :: TVarChar
                                 ELSE MovementString_InvNumberPartner_order.ValueData
                            END
                  WHEN MovementString_InvNumberOrder.ValueData <> ''
                       THEN MovementString_InvNumberOrder.ValueData
                  ELSE COALESCE (Movement_order.InvNumber, '')
             END AS InvNumberOrder

           , EXTRACT (DAY FROM Movement.OperDate) :: Integer AS OperDate_day
           , COALESCE (EXTRACT (DAY FROM MovementDate_OperDatePartner.ValueData), 0) :: Integer AS OperDatePartner_day

           , Movement.OperDate                          AS OperDate
           , COALESCE (MovementDate_OperDatePartner.ValueData, CASE WHEN Movement.DescId <> zc_Movement_Sale() THEN Movement.OperDate END) :: TDateTime AS OperDatePartner
           , MovementDate_Payment.ValueData             AS PaymentDate
           , CASE WHEN MovementDate_Payment.ValueData IS NOT NULL THEN TRUE ELSE FALSE END :: Boolean AS isPaymentDate
           , COALESCE (Movement_order.OperDate, Movement.OperDate) :: TDateTime AS OperDateOrder
           , vbPriceWithVAT                             AS PriceWithVAT
           , vbVATPercent                               AS VATPercent
           , vbExtraChargesPercent - vbDiscountPercent  AS ChangePercent
           , MovementFloat_TotalCount.ValueData         AS TotalCount
           , FLOOR (MovementFloat_TotalCount.ValueData) AS TotalCount_floor

           , vbTotalCountKg_only AS TotalCountKg_only
           , CASE WHEN vbIsProcess_BranchIn = FALSE AND vbDescId = zc_Movement_SendOnPrice() THEN vbTotalCountKg ELSE MovementFloat_TotalCountKg.ValueData END AS TotalCountKg
           , CASE WHEN vbIsProcess_BranchIn = FALSE AND vbDescId = zc_Movement_SendOnPrice() THEN vbTotalCountSh ELSE MovementFloat_TotalCountSh.ValueData - COALESCE (vbTotalCountSh_Kg,0) END AS TotalCountSh

           , COALESCE (CASE WHEN vbIsProcess_BranchIn = FALSE AND vbDescId = zc_Movement_SendOnPrice() THEN vbOperSumm_MVAT ELSE MovementFloat_TotalSummMVAT.ValueData END, 0)
             + COALESCE (CAST (MovementFloat_TotalSummTare.ValueData - MovementFloat_TotalSummTare.ValueData * (vbVATPercent / (vbVATPercent + 100)) AS NUMERIC (16, 4)),0) AS TotalSummMVAT

           , (COALESCE (CASE WHEN vbIsProcess_BranchIn = FALSE AND vbDescId = zc_Movement_SendOnPrice() THEN vbOperSumm_PVAT ELSE MovementFloat_TotalSummPVAT.ValueData END, 0)
            + COALESCE (MovementFloat_TotalSummTare.ValueData,0)
            - CASE WHEN inMovementId = 25962251 THEN 0.01 ELSE 0 END -- № 1871895 от 16.08.2023 - Військова частина Т0920 м. Дніпро вул. Стартова буд.15
             ) :: TFloat AS TotalSummPVAT

           , CASE WHEN vbIsProcess_BranchIn = FALSE AND vbDescId = zc_Movement_SendOnPrice()
                  THEN vbOperSumm_PVAT - vbOperSumm_MVAT
                  ELSE MovementFloat_TotalSummPVAT.ValueData - MovementFloat_TotalSummMVAT.ValueData
                     + COALESCE (CAST ( MovementFloat_TotalSummTare.ValueData * (vbVATPercent / (vbVATPercent + 100)) AS NUMERIC (16, 4)),0)
                     - CASE WHEN inMovementId = 25962251 THEN 0.01 ELSE 0 END -- № 1871895 от 16.08.2023 - Військова частина Т0920 м. Дніпро вул. Стартова буд.15
             END :: TFloat AS SummVAT

           , CASE WHEN vbIsProcess_BranchIn = FALSE AND vbDescId = zc_Movement_SendOnPrice()
                  THEN vbOperSumm_PVAT
                  ELSE MovementFloat_TotalSumm.ValueData
                     - CASE WHEN inMovementId = 25962251 THEN 0.01 ELSE 0 END -- № 1871895 от 16.08.2023 - Військова частина Т0920 м. Дніпро вул. Стартова буд.15
             END :: TFloat AS TotalSumm
           , CASE WHEN vbIsProcess_BranchIn = FALSE AND vbDescId = zc_Movement_SendOnPrice() THEN vbOperSumm_PVAT ELSE MovementFloat_TotalSumm.ValueData *(1 - (vbVATPercent / (vbVATPercent + 100))) END TotalSummMVAT_Info
             -- Сумма оборотной тары
           , MovementFloat_TotalSummTare.ValueData AS TotalSummPVAT_Tare -- c НДС

           , CAST (MovementFloat_TotalSummTare.ValueData - MovementFloat_TotalSummTare.ValueData * (vbVATPercent / (vbVATPercent + 100)) AS NUMERIC (16, 4)) AS TotalSummMVAT_Tare --  без НДС


           , Object_From.ValueData             		AS FromName
           , CASE WHEN vbIsKiev = TRUE OR OH_JuridicalDetails_To.OKPO IN ('43536406') THEN TRUE ELSE FALSE END AS isPrintPageBarCode

          -- , COALESCE (Object_Partner.ValueData, Object_To.ValueData) AS ToName
           , CASE -- WHEN vbUserId = 5 THEN Object_Juridical_curr.Id :: TvarChar -- OH_JuridicalDetails_To.Name --  ||' '|| ObjectString_ToAddress.ValueData)
                  WHEN COALESCE (OH_JuridicalDetails_To.Name,'') <> ''
                   AND OH_JuridicalDetails_To.JuridicalId <> 9840136 -- Укрзалізниця АТ
                       THEN (OH_JuridicalDetails_To.Name ||' '|| ObjectString_ToAddress.ValueData)
             -- Object_Juridical_curr
                  ELSE COALESCE (Object_Partner.ValueData, Object_To.ValueData)
             END ::TVarChar AS ToName  
             
           , (CASE WHEN COALESCE (OH_JuridicalDetails_To.Name,'') <> ''
                        THEN OH_JuridicalDetails_To.Name ||' '
                        ELSE Object_Juridical.ValueData||' '
              END
              || ' ' || COALESCE (ObjectString_Partner_ShortName.ValueData, '')
              || CASE WHEN View_Partner_Address.RegionName    <> '' THEN ' ' || View_Partner_Address.RegionName   || ' обл., ' ELSE '' END
              || CASE WHEN View_Partner_Address.ProvinceName  <> '' THEN ' ' || View_Partner_Address.ProvinceName || ' р-н, '  ELSE '' END
              || ' ' || ObjectString_ToAddress.ValueData
             )  ::TVarChar AS ToName_full

           , Object_PaidKind.ValueData         		AS PaidKindName
           , View_Contract.InvNumber        		AS ContractName
           , ObjectDate_Signing.ValueData               AS ContractSigningDate
           , View_Contract.ContractKindName             AS ContractKind
           , COALESCE (ObjectString_PartnerCode.ValueData, '') :: TVarChar AS PartnerCode

           , Object_RouteSorting.ValueData 	        AS RouteSortingName

           , /*CASE WHEN View_Contract.InfoMoneyId = zc_Enum_InfoMoney_30101() AND Object_From.Id = 8459
                   AND OH_JuridicalDetails_To.OKPO NOT IN ('32516492', '39135315', '39622918')
                       THEN 'Бабенко В.П.'
                  ELSE ''
             END*/
             CASE WHEN COALESCE (Object_PersonalStore_View.PersonalName, '') <> '' THEN zfConvert_FIO (Object_PersonalStore_View.PersonalName, 2, FALSE) ELSE vbStoreKeeperName END  AS StoreKeeper -- кладовщик
           , '' :: TVarChar                             AS Through     -- через кого
           , CASE WHEN OH_JuridicalDetails_To.OKPO IN ('32516492', '39135315', '39622918') THEN 'м. Київ, вул Ольжича, 18/22' ELSE '' END :: TVarChar  AS UnitAddress -- адреса складання

           , CASE -- !!!захардкодил временно для Запорожье!!!
                  WHEN MovementLinkObject_From.ObjectId IN (301309) -- Склад ГП ф.Запорожье
                   AND vbPaidKindId = zc_Enum_PaidKind_SecondForm()
                       THEN FALSE
                  WHEN ObjectLink_Contract_JuridicalDocument.ChildObjectId > 0
                   AND Movement.AccessKeyId <> zc_Enum_Process_AccessKey_DocumentKiev()
                       THEN TRUE
                  ELSE FALSE
             END :: Boolean AS isJuridicalDocument
           , CASE WHEN COALESCE (ObjectLink_Unit_Branch.ChildObjectId, zc_Branch_Basis()) = zc_Branch_Basis()
                   AND COALESCE (ObjectLink_Juridical_Retail.ChildObjectId, 0) <> 3207268 -- Мануфактура - для ф.КрРог
                       THEN TRUE
                  ELSE FALSE
             END :: Boolean AS isBranchBasis

           , ObjectString_Partner_ShortName.ValueData   AS ShortNamePartner_To
           , (ObjectString_ToAddress.ValueData
              || CASE WHEN vbIsOKPO_40075815 = TRUE
                           THEN CHR (13) || 'СТРУКТУРНИЙ ПІДРОЗДІЛ "Запорізьке моторвагонне депо"'
                      ELSE ''
                 END
             ) :: TVarChar           AS PartnerAddress_To

           , (CASE WHEN ObjectString_PostalCode.ValueData  <> '' THEN ObjectString_PostalCode.ValueData || ' '      ELSE '' END
           || CASE WHEN View_Partner_Address.RegionName    <> '' THEN View_Partner_Address.RegionName   || ' обл., ' ELSE '' END
           || CASE WHEN View_Partner_Address.ProvinceName  <> '' THEN View_Partner_Address.ProvinceName || ' р-н, '  ELSE '' END
           || ObjectString_ToAddress.ValueData
             ) :: TVarChar            AS PartnerAddressAll_To
           , OH_JuridicalDetails_To.JuridicalId         AS JuridicalId_To

           , (CASE WHEN Object_To.Id IN (11216101) --AND vbUserId = 5
                        THEN '' -- inToId := 3470472 , inPartnerId := 11216101
                   --WHEN Object_To.Id IN (9840136) AND vbUserId = 5
                   --     THEN COALESCE (OH_JuridicalDetails_To.Name, '')
                   ELSE COALESCE (Object_ArticleLoss.ValueData, OH_JuridicalDetails_To.FullName) 
              END

           || CASE WHEN Object_To.Id IN (11216101) --AND vbUserId = 5
                        -- Укрзалізниця АТ - Условное обозначение
                        THEN ObjectString_BranchJur.ValueData
                        
                   --WHEN Object_To.Id IN (9840136) AND vbUserId = 5
                   --     -- Укрзалізниця АТ - Условное обозначение
                   --     THEN ', ' || TRIM (TRIM (LOWER (SPLIT_PART (ObjectString_ShortName.ValueData, 'підрозділ', 1)))
                   --        || ' ' || TRIM (SPLIT_PART (SPLIT_PART (ObjectString_ShortName.ValueData, 'філії', 1), 'Структурний', 2)))

                   ELSE ''
              END
             ) :: TVarChar AS JuridicalName_To

           , Object_Juridical.ValueData                 AS JuridicalName_short_To
           , OH_JuridicalDetails_To.JuridicalAddress    AS JuridicalAddress_To
           , OH_JuridicalDetails_To.OKPO                AS OKPO_To
           , OH_JuridicalDetails_To.INN                 AS INN_To
           , OH_JuridicalDetails_To.NumberVAT           AS NumberVAT_To
           , OH_JuridicalDetails_To.AccounterName       AS AccounterName_To
           , OH_JuridicalDetails_To.MainName            AS MainName_To
           , OH_JuridicalDetails_To.BankAccount         AS BankAccount_To
           , OH_JuridicalDetails_To.BankName            AS BankName_To
           , OH_JuridicalDetails_To.MFO                 AS BankMFO_To
           , OH_JuridicalDetails_To.Phone               AS Phone_To

           , COALESCE (OH_JuridicalDetails_Invoice.JuridicalId,      OH_JuridicalDetails_To.JuridicalId)         AS JuridicalId_Invoice

           , (CASE WHEN Object_To.Id IN (11216101) --AND vbUserId = 5
                        THEN '' -- inToId := 3470472 , inPartnerId := 11216101
                   --WHEN Object_To.Id IN (9840136) AND vbUserId = 5
                   --     THEN COALESCE (OH_JuridicalDetails_To.Name, '')
                   ELSE COALESCE (OH_JuridicalDetails_Invoice.FullName, Object_ArticleLoss.ValueData, OH_JuridicalDetails_To.FullName)
              END

           || CASE WHEN Object_To.Id IN (11216101) --AND vbUserId = 5
                        -- Укрзалізниця АТ - Условное обозначение
                        THEN ObjectString_BranchJur.ValueData
                        
                   --WHEN Object_To.Id IN (9840136) AND vbUserId = 5
                   --     -- Укрзалізниця АТ - Условное обозначение
                   --     THEN ', ' || TRIM (TRIM (LOWER (SPLIT_PART (ObjectString_ShortName.ValueData, 'підрозділ', 1)))
                   --        || ' ' || TRIM (SPLIT_PART (SPLIT_PART (ObjectString_ShortName.ValueData, 'філії', 1), 'Структурний', 2)))

                   ELSE ''
              END
             ) :: TVarChar AS JuridicalName_Invoice

           , COALESCE (OH_JuridicalDetails_Invoice.JuridicalAddress, OH_JuridicalDetails_To.JuridicalAddress)    AS JuridicalAddress_Invoice
           , COALESCE (OH_JuridicalDetails_Invoice.OKPO,             OH_JuridicalDetails_To.OKPO)                AS OKPO_Invoice
           , COALESCE (OH_JuridicalDetails_Invoice.INN,              OH_JuridicalDetails_To.INN)                 AS INN_Invoice
           , COALESCE (OH_JuridicalDetails_Invoice.NumberVAT,        OH_JuridicalDetails_To.NumberVAT)           AS NumberVAT_Invoice
           , COALESCE (OH_JuridicalDetails_Invoice.AccounterName,    OH_JuridicalDetails_To.AccounterName)       AS AccounterName_Invoice
           , COALESCE (OH_JuridicalDetails_Invoice.MainName,         OH_JuridicalDetails_To.MainName)            AS MainName_Invoice
           , COALESCE (OH_JuridicalDetails_Invoice.BankAccount,      OH_JuridicalDetails_To.BankAccount)         AS BankAccount_Invoice
           , COALESCE (OH_JuridicalDetails_Invoice.BankName,         OH_JuridicalDetails_To.BankName)            AS BankName_Invoice
           , COALESCE (OH_JuridicalDetails_Invoice.MFO,              OH_JuridicalDetails_To.MFO)                 AS BankMFO_Invoice
           , COALESCE (OH_JuridicalDetails_Invoice.Phone,            OH_JuridicalDetails_To.Phone)               AS Phone_Invoice

           , CASE WHEN COALESCE (Object_PersonalCollation.ValueData, '') = '' THEN '' ELSE zfConvert_FIO (Object_PersonalCollation.ValueData, 2, FALSE) END :: TVarChar        AS PersonalCollationName
           --, CASE WHEN ObjectLink_Juridical_Retail.ChildObjectId = 310855 /*Варус*/ THEN ObjectString_Partner_GLNCode.ValueData ELSE ObjectString_Juridical_GLNCode.ValueData END AS BuyerGLNCode
           --, ObjectString_Partner_GLNCode.ValueData AS DeliveryPlaceGLNCode
           --, ObjectString_Partner_GLNCode.ValueData AS RecipientGLNCode

           , ObjectString_Partner_GLNCode.ValueData     AS DeliveryPlaceGLNCode
           /*, CASE WHEN ObjectString_Partner_GLNCodeJuridical.ValueData <> '' THEN ObjectString_Partner_GLNCodeJuridical.ValueData ELSE ObjectString_Juridical_GLNCode.ValueData END AS BuyerGLNCode
           , CASE WHEN ObjectString_Partner_GLNCodeRetail.ValueData <> '' THEN ObjectString_Partner_GLNCodeRetail.ValueData WHEN ObjectString_Retail_GLNCode.ValueData <> '' THEN ObjectString_Retail_GLNCode.ValueData ELSE ObjectString_Juridical_GLNCode.ValueData END AS RecipientGLNCode

           , CASE WHEN ObjectString_Partner_GLNCodeCorporate.ValueData <> '' THEN ObjectString_Partner_GLNCodeCorporate.ValueData ELSE ObjectString_JuridicalFrom_GLNCode.ValueData END AS SupplierGLNCode
           , CASE WHEN ObjectString_Partner_GLNCodeCorporate.ValueData <> '' THEN ObjectString_Partner_GLNCodeCorporate.ValueData ELSE ObjectString_JuridicalFrom_GLNCode.ValueData END AS SenderGLNCode*/

           , zfCalc_GLNCodeJuridical (inGLNCode                  := ObjectString_Partner_GLNCode.ValueData
                                    , inGLNCodeJuridical_partner := ObjectString_Partner_GLNCodeJuridical.ValueData
                                    , inGLNCodeJuridical         := ObjectString_Juridical_GLNCode.ValueData
                                     ) AS BuyerGLNCode

           , zfCalc_GLNCodeRetail (inGLNCode               := ObjectString_Partner_GLNCode.ValueData
                                 , inGLNCodeRetail_partner := ObjectString_Partner_GLNCodeRetail.ValueData
                                 , inGLNCodeRetail         := ObjectString_Retail_GLNCode.ValueData
                                 , inGLNCodeJuridical      := ObjectString_Juridical_GLNCode.ValueData
                                  ) AS RecipientGLNCode

           , CASE WHEN 1=0 AND OH_JuridicalDetails_To.JuridicalId = 15158 -- МЕТРО Кеш енд Кері Україна ТОВ
                       THEN '' -- если Метро, тогда наш = "пусто"
                  ELSE zfCalc_GLNCodeCorporate (inGLNCode                  := ObjectString_Partner_GLNCode.ValueData
                                              , inGLNCodeCorporate_partner := ObjectString_Partner_GLNCodeCorporate.ValueData
                                              , inGLNCodeCorporate_retail  := ObjectString_Retail_GLNCodeCorporate.ValueData
                                              , inGLNCodeCorporate_main    := ObjectString_JuridicalFrom_GLNCode.ValueData
                                               )
             END :: TVarChar AS SupplierGLNCode

           , zfCalc_GLNCodeCorporate (inGLNCode                  := ObjectString_Partner_GLNCode.ValueData
                                    , inGLNCodeCorporate_partner := ObjectString_Partner_GLNCodeCorporate.ValueData
                                    , inGLNCodeCorporate_retail  := ObjectString_Retail_GLNCodeCorporate.ValueData
                                    , inGLNCodeCorporate_main    := ObjectString_JuridicalFrom_GLNCode.ValueData
                                     ) AS SenderGLNCode
           , ObjectString_Partner_Movement.ValueData ::TVarChar AS MovementComment

           , OH_JuridicalDetails_From.JuridicalId       AS JuridicalId_From
           , OH_JuridicalDetails_From.FullName          AS JuridicalName_From
           , OH_JuridicalDetails_From.JuridicalAddress  AS JuridicalAddress_From
           , OH_JuridicalDetails_From.OKPO              AS OKPO_From
           , OH_JuridicalDetails_From.INN               AS INN_From
           , OH_JuridicalDetails_From.NumberVAT         AS NumberVAT_From
           , OH_JuridicalDetails_From.AccounterName     AS AccounterName_From
           , CASE WHEN COALESCE (OH_JuridicalDetails_From.MainName, '') = '' THEN '' ELSE zfConvert_FIO (OH_JuridicalDetails_From.MainName, 2, FALSE) END :: TVarChar   AS MainName_From --- , zfConvert_FIO (OH_JuridicalDetails_From.MainName, 2, FALSE)          AS MainName_From
           , OH_JuridicalDetails_From.BankAccount       AS BankAccount_From
           , OH_JuridicalDetails_From.BankName          AS BankName_From
           , OH_JuridicalDetails_From.MFO               AS BankMFO_From
           , OH_JuridicalDetails_From.Phone             AS Phone_From
           --, ObjectString_JuridicalFrom_GLNCode.ValueData     AS SupplierGLNCode
           --, ObjectString_JuridicalFrom_GLNCode.ValueData     AS SenderGLNCode

           , Object_BankAccount.Name                            AS BankAccount_ByContract
           , 'российских рублях' :: TVarChar                    AS CurrencyInternalAll_ByContract
           , Object_BankAccount.CurrencyInternalName            AS CurrencyInternal_ByContract
           , Object_BankAccount.BankName                        AS BankName_ByContract
           , Object_BankAccount.MFO                             AS BankMFO_ByContract
           , Object_BankAccount.SWIFT                           AS BankSWIFT_ByContract
           , Object_BankAccount.IBAN                            AS BankIBAN_ByContract
           , Object_BankAccount.CorrespondentBankName           AS CorrBankName_ByContract
           , Object_Bank_View_CorrespondentBank_From.SWIFT      AS CorrBankSWIFT_ByContract
           , Object_BankAccount.CorrespondentAccount            AS CorrespondentAccount_ByContract
           , OHS_JD_JuridicalAddress_Bank_From.ValueData        AS JuridicalAddressBankFrom
           , OHS_JD_JuridicalAddress_CorrBank_From.ValueData    AS JuridicalAddressCorrBankFrom


           , COALESCE(MovementLinkMovement_Sale.MovementChildId, 0)  AS EDIId

           , BankAccount_To.BankName                            AS BankName_Int
           , BankAccount_To.Name                                AS BankAccount_Int

           , BankAccount_To.CorrespondentBankName               AS CorBankName_Int
           , Object_Bank_View_CorrespondentBank.JuridicalName   AS CorBankJuridicalName_Int
           , Object_Bank_View_CorrespondentBank.SWIFT           AS CorBankSWIFT_Int

           , BankAccount_To.BeneficiarysBankName                AS BenefBankName_Int
           , OHS_JD_JuridicalAddress_BenifBank_To.ValueData     AS JuridicalAddressBenifBank_Int
           , Object_Bank_View_BenifBank.SWIFT                   AS BenifBankSWIFT_Int
           , BankAccount_To.BeneficiarysBankAccount             AS BenefBankAccount_Int

           , BankAccount_To.MFO                                 AS BankMFO_Int
           , BankAccount_To.SWIFT                               AS BankSWIFT_Int
           , BankAccount_To.IBAN                                AS BankIBAN_Int

           , Object_Bank_View_To.JuridicalName                  AS BankJuridicalName_Int
           , OHS_JD_JuridicalAddress_To.ValueData               AS BankJuridicalAddress_Int
           , BankAccount_To.BeneficiarysAccount                 AS BenefAccount_Int
           , BankAccount_To.Name                                AS BankAccount_Int

           , MS_InvNumberPartner_Master.ValueData               AS InvNumberPartner_Master

           , CASE WHEN (vbDiscountPercent <> 0 OR vbExtraChargesPercent <> 0) AND vbPaidKindId = zc_Enum_PaidKind_SecondForm()
                        THEN ' та знижкой'
                  ELSE ''
             END AS Price_info

           , vbIsInfoMoney_30201 AS isInfoMoney_30201
           , vbIsInfoMoney_30200 AS isInfoMoney_30200

           , CASE WHEN COALESCE (ObjectString_PlaceOf.ValueData, '') <> '' THEN COALESCE (ObjectString_PlaceOf.ValueData, '')
                  ELSE '' -- 'м.Днiпро'
                  END  :: TVarChar   AS PlaceOf
           , CASE WHEN COALESCE (Object_Personal_View.PersonalName, '') <> '' THEN zfConvert_FIO (Object_Personal_View.PersonalName, 2, FALSE) ELSE '' END AS PersonalBookkeeperName   -- бухгалтер из спр.Филиалы

           , CASE WHEN OH_JuridicalDetails_To.OKPO IN ('02147345') THEN '' ELSE MovementSale_Comment.ValueData END :: TVarChar AS SaleComment
           , CASE WHEN OH_JuridicalDetails_To.OKPO IN ('02147345') THEN MovementSale_Comment.ValueData ELSE '' END :: TVarChar AS SaleComment_02147345

           , CASE WHEN vbIsInfoMoney_30200 = FALSE AND TRIM (MovementOrder_Comment.ValueData) <> TRIM (COALESCE (MovementSale_Comment.ValueData, ''))
                   AND (vbPaidKindId = zc_Enum_PaidKind_SecondForm() OR Position(UPPER('обмен') in UPPER(View_Contract.InvNumber)) > 0)
                       THEN MovementOrder_Comment.ValueData
                  ELSE ''
             END :: TVarChar AS OrderComment
           , CASE WHEN Movement.DescId = zc_Movement_Loss() THEN TRUE ELSE FALSE END isMovementLoss

           , CASE WHEN Position(UPPER('обмен') in UPPER(View_Contract.InvNumber)) > 0 THEN TRUE ELSE FALSE END :: Boolean AS isPrintText

           , CASE WHEN vbPaidKindId = zc_Enum_PaidKind_FirstForm() THEN TRUE ELSE FALSE END :: Boolean AS isFirstForm

             -- кол-во Взвешиваний
           , vbWeighingCount AS WeighingCount

             -- Мiсце складання
           , 'м.Дніпро' :: TVarChar AS CityOf

             -- для договора Id = 4440485(№7183Р(14781)) + доп страничка
         --, CASE WHEN View_Contract.InvNumber = 4440485 THEN FALSE ELSE FALSE END :: Boolean AS isFozzyPage2
           , CASE WHEN View_Contract.InvNumber ILIKE '7183Р' THEN TRUE ELSE FALSE END :: Boolean AS isFozzyPage2

             -- этому Юр Лицу печатается "За довіренністю ...."
           , vbIsOKPO_04544524 :: Boolean AS isOKPO_04544524

           --если мало строк печатается 2 копии
           --, CASE WHEN COALESCE (vbCountMI,0) > 3 THEN FALSE ELSE TRUE END :: Boolean AS isTwoCopies
           , TRUE :: Boolean isTwoCopies

       FROM tmpMovement AS Movement
            LEFT JOIN tmpMovementLinkMovement AS MovementLinkMovement_Sale
                                              ON MovementLinkMovement_Sale.MovementId = Movement.Id
                                             AND MovementLinkMovement_Sale.DescId = zc_MovementLinkMovement_Sale()
            LEFT JOIN tmpMovementLinkMovement AS MovementLinkMovement_Order
                                              ON MovementLinkMovement_Order.MovementId = Movement.Id
                                             AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
            LEFT JOIN Movement AS Movement_order ON Movement_order.Id = MovementLinkMovement_Order.MovementChildId
            LEFT JOIN tmpMovementString_ord AS MovementString_InvNumberPartner_order
                                            ON MovementString_InvNumberPartner_order.MovementId = Movement_order.Id
                                           AND MovementString_InvNumberPartner_order.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN tmpMovementString AS MovementString_InvNumberOrder
                                        ON MovementString_InvNumberOrder.MovementId =  Movement.Id
                                       AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()

            LEFT JOIN tmpMovementString AS MovementSale_Comment
                                        ON MovementSale_Comment.MovementId = Movement.Id
                                       AND MovementSale_Comment.DescId = zc_MovementString_Comment()
            LEFT JOIN tmpMovementString_ord AS MovementOrder_Comment
                                            ON MovementOrder_Comment.MovementId = Movement_order.Id
                                           AND MovementOrder_Comment.DescId = zc_MovementString_Comment()


            LEFT JOIN tmpMovementDate AS MovementDate_Payment
                                      ON MovementDate_Payment.MovementId =  Movement.Id
                                     AND MovementDate_Payment.DescId = zc_MovementDate_Payment()
            LEFT JOIN tmpMovementDate AS MovementDate_OperDatePartner
                                      ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                     AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
            LEFT JOIN tmpMovementString AS MovementString_InvNumberPartner
                                        ON MovementString_InvNumberPartner.MovementId =  Movement.Id
                                       AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalCount
                                       ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                      AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCountPartner()
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

            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalSummTare
                                       ON MovementFloat_TotalSummTare.MovementId =  Movement.Id
                                      AND MovementFloat_TotalSummTare.DescId = zc_MovementFloat_TotalSummTare()
 /*           LEFT JOIN tmpMovementFloat AS MovementFloat_TotalCountTare
                                       ON MovementFloat_TotalCountTare.MovementId =  Movement.Id
                                      AND MovementFloat_TotalCountTare.DescId = zc_MovementFloat_TotalCountTare()
*/

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                         ON MovementLinkObject_Partner.MovementId = Movement.Id
                                        AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = MovementLinkObject_Partner.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                 ON ObjectLink_Unit_Juridical.ObjectId = Object_From.Id
                                AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                                AND vbContractId = 0

            LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                                 ON ObjectLink_Unit_Branch.ObjectId = Object_From.Id
                                AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
            LEFT JOIN ObjectString AS ObjectString_PlaceOf
                                   ON ObjectString_PlaceOf.ObjectId = COALESCE (ObjectLink_Unit_Branch.ChildObjectId, zc_Branch_Basis())
                                  AND ObjectString_PlaceOf.DescId = zc_objectString_Branch_PlaceOf()
            LEFT JOIN ObjectLink AS ObjectLink_Branch_Personal
                                 ON ObjectLink_Branch_Personal.ObjectId = ObjectLink_Unit_Branch.ChildObjectId
                                AND ObjectLink_Branch_Personal.DescId = zc_ObjectLink_Branch_Personal()
            LEFT JOIN Object_Personal_View ON Object_Personal_View.PersonalId = ObjectLink_Branch_Personal.ChildObjectId
            LEFT JOIN ObjectLink AS ObjectLink_Branch_PersonalStore
                                 ON ObjectLink_Branch_PersonalStore.ObjectId = ObjectLink_Unit_Branch.ChildObjectId
                                AND ObjectLink_Branch_PersonalStore.DescId = zc_ObjectLink_Branch_PersonalStore()
            LEFT JOIN Object_Personal_View AS Object_PersonalStore_View ON Object_PersonalStore_View.PersonalId = ObjectLink_Branch_PersonalStore.ChildObjectId



            LEFT JOIN MovementLinkObject AS MovementLinkObject_ArticleLoss
                                         ON MovementLinkObject_ArticleLoss.MovementId = Movement.Id
                                        AND MovementLinkObject_ArticleLoss.DescId = zc_MovementLinkObject_ArticleLoss()
            LEFT JOIN Object AS Object_ArticleLoss ON Object_ArticleLoss.Id = MovementLinkObject_ArticleLoss.ObjectId
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
            -- Условное обозначение - Українська залізниця АТ АТ "УКРЗАЛІЗНИЦЯ" Виробничий підрозділ "Служба аварійно-відновлювальних робіт" м. Дніпро пр-кт. Д.Яворницького буд.108
            -- Українська залізниця АТ АТ "УКРЗАЛІЗНИЦЯ" Виробничий підрозділ "Служба аварійно-відновлювальних робіт" м. Дніпро пр-кт. Д.Яворницького буд.108
            LEFT JOIN ObjectString AS ObjectString_ShortName
                                   ON ObjectString_ShortName.ObjectId = 11216101 -- MovementLinkObject_To.ObjectId
                                  AND ObjectString_ShortName.DescId = zc_ObjectString_Partner_ShortName()
            -- Название юр.лица для филиала
            LEFT JOIN ObjectString AS ObjectString_BranchJur
                                   ON ObjectString_BranchJur.ObjectId = MovementLinkObject_To.ObjectId
                                  AND ObjectString_BranchJur.DescId = zc_ObjectString_Partner_BranchJur()

            LEFT JOIN ObjectString AS ObjectString_ToAddress
                                   ON ObjectString_ToAddress.ObjectId = COALESCE (MovementLinkObject_Partner.ObjectId, Object_To.Id)
                                  AND ObjectString_ToAddress.DescId = zc_ObjectString_Partner_Address()
            LEFT JOIN ObjectString AS ObjectString_Partner_ShortName
                                   ON ObjectString_Partner_ShortName.ObjectId = COALESCE (MovementLinkObject_Partner.ObjectId, Object_To.Id)
                                  AND ObjectString_Partner_ShortName.DescId = zc_ObjectString_Partner_ShortName()
            LEFT JOIN Object_Partner_Address_View AS View_Partner_Address ON View_Partner_Address.PartnerId = COALESCE (MovementLinkObject_Partner.ObjectId, Object_To.Id)
            LEFT JOIN ObjectString AS ObjectString_PostalCode
                                   ON ObjectString_PostalCode.ObjectId = View_Partner_Address.StreetId
                                  AND ObjectString_PostalCode.DescId = zc_ObjectString_Street_PostalCode()

            /*LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                         ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                        AND MovementLinkObject_PaidKind.DescId IN (zc_MovementLinkObject_PaidKind(), zc_MovementLinkObject_PaidKindTo())*/
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = vbPaidKindId -- MovementLinkObject_PaidKind.ObjectId
-- Contract
            /*LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId IN (zc_MovementLinkObject_Contract(), zc_MovementLinkObject_ContractTo())*/
            LEFT JOIN Object_Contract_View AS View_Contract ON View_Contract.ContractId = vbContractId -- MovementLinkObject_Contract.ObjectId
            LEFT JOIN ObjectDate AS ObjectDate_Signing
                                 ON ObjectDate_Signing.ObjectId = View_Contract.ContractId -- MovementLinkObject_Contract.ObjectId
                                AND ObjectDate_Signing.DescId = zc_ObjectDate_Contract_Signing()
                                AND View_Contract.InvNumber <> '-'
            LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalDocument
                                 ON ObjectLink_Contract_JuridicalDocument.ObjectId = View_Contract.ContractId -- MovementLinkObject_Contract.ObjectId
                                AND ObjectLink_Contract_JuridicalDocument.DescId = zc_ObjectLink_Contract_JuridicalDocument()
                                AND vbPaidKindId = zc_Enum_PaidKind_SecondForm()
            LEFT JOIN ObjectLink AS ObjectLink_Contract_PersonalCollation
                                 ON ObjectLink_Contract_PersonalCollation.ObjectId = View_Contract.ContractId
                                AND ObjectLink_Contract_PersonalCollation.DescId = zc_ObjectLink_Contract_PersonalCollation()
            LEFT JOIN Object AS Object_PersonalCollation ON Object_PersonalCollation.Id = ObjectLink_Contract_PersonalCollation.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalInvoice
                                 ON ObjectLink_Contract_JuridicalInvoice.ObjectId = View_Contract.ContractId
                                AND ObjectLink_Contract_JuridicalInvoice.DescId = zc_ObjectLink_Contract_JuridicalInvoice()
            -- код поставщика
            LEFT JOIN ObjectString AS ObjectString_PartnerCode
                                   ON ObjectString_PartnerCode.ObjectId = View_Contract.ContractId
                                  AND ObjectString_PartnerCode.DescId = zc_objectString_Contract_PartnerCode()

            LEFT JOIN Object AS Object_RouteSorting ON Object_RouteSorting.Id = NULL

            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                 ON ObjectLink_Partner_Juridical.ObjectId = Object_To.Id
                                AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, Object_To.Id)

            LEFT JOIN ObjectString AS ObjectString_Partner_GLNCode
                                   ON ObjectString_Partner_GLNCode.ObjectId = COALESCE (MovementLinkObject_Partner.ObjectId, Object_To.Id)
                                  AND ObjectString_Partner_GLNCode.DescId = zc_ObjectString_Partner_GLNCode()
            LEFT JOIN ObjectString AS ObjectString_Partner_GLNCodeJuridical
                                   ON ObjectString_Partner_GLNCodeJuridical.ObjectId = COALESCE (MovementLinkObject_Partner.ObjectId, Object_To.Id)
                                  AND ObjectString_Partner_GLNCodeJuridical.DescId = zc_ObjectString_Partner_GLNCodeJuridical()
            LEFT JOIN ObjectString AS ObjectString_Partner_GLNCodeRetail
                                   ON ObjectString_Partner_GLNCodeRetail.ObjectId = COALESCE (MovementLinkObject_Partner.ObjectId, Object_To.Id)
                                  AND ObjectString_Partner_GLNCodeRetail.DescId = zc_ObjectString_Partner_GLNCodeRetail()
            LEFT JOIN ObjectString AS ObjectString_Partner_GLNCodeCorporate
                                   ON ObjectString_Partner_GLNCodeCorporate.ObjectId = COALESCE (MovementLinkObject_Partner.ObjectId, Object_To.Id)
                                  AND ObjectString_Partner_GLNCodeCorporate.DescId = zc_ObjectString_Partner_GLNCodeCorporate()

            LEFT JOIN ObjectString AS ObjectString_Partner_Movement
                                   ON ObjectString_Partner_Movement.ObjectId = COALESCE (MovementLinkObject_Partner.ObjectId, Object_To.Id)
                                  AND ObjectString_Partner_Movement.DescId = zc_ObjectString_Partner_Movement()

            --LEFT JOIN Object AS Object_Juridical_curr ON Object_Juridical_curr.Id = COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, Object_To.Id)

            LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_To
                                                                ON OH_JuridicalDetails_To.JuridicalId = COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, Object_To.Id)
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) >= OH_JuridicalDetails_To.StartDate
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) <  OH_JuridicalDetails_To.EndDate

            LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_Invoice
                                                                ON OH_JuridicalDetails_Invoice.JuridicalId = ObjectLink_Contract_JuridicalInvoice.ChildObjectId
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) >= OH_JuridicalDetails_Invoice.StartDate
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) <  OH_JuridicalDetails_Invoice.EndDate

            LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                 ON ObjectLink_Juridical_Retail.ObjectId = OH_JuridicalDetails_To.JuridicalId
                                AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
            LEFT JOIN ObjectString AS ObjectString_Juridical_GLNCode
                                   ON ObjectString_Juridical_GLNCode.ObjectId = OH_JuridicalDetails_To.JuridicalId
                                  AND ObjectString_Juridical_GLNCode.DescId = zc_ObjectString_Juridical_GLNCode()
            LEFT JOIN ObjectString AS ObjectString_Retail_GLNCode
                                   ON ObjectString_Retail_GLNCode.ObjectId = ObjectLink_Juridical_Retail.ChildObjectId
                                  AND ObjectString_Retail_GLNCode.DescId = zc_ObjectString_Retail_GLNCode()
            LEFT JOIN ObjectString AS ObjectString_Retail_GLNCodeCorporate
                                   ON ObjectString_Retail_GLNCodeCorporate.ObjectId = ObjectLink_Juridical_Retail.ChildObjectId
                                  AND ObjectString_Retail_GLNCodeCorporate.DescId = zc_ObjectString_Retail_GLNCodeCorporate()

            LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_From
                                                                ON OH_JuridicalDetails_From.JuridicalId = COALESCE (ObjectLink_Contract_JuridicalDocument.ChildObjectId
                                                                                                        , COALESCE (View_Contract.JuridicalBasisId
                                                                                                        , COALESCE (ObjectLink_Unit_Juridical.ChildObjectId
                                                                                                                  , Object_From.Id)))
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) >= OH_JuridicalDetails_From.StartDate
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) <  OH_JuridicalDetails_From.EndDate
            LEFT JOIN ObjectString AS ObjectString_JuridicalFrom_GLNCode
                                   ON ObjectString_JuridicalFrom_GLNCode.ObjectId = OH_JuridicalDetails_From.JuridicalId
                                  AND ObjectString_JuridicalFrom_GLNCode.DescId = zc_ObjectString_Juridical_GLNCode()

-- bank account
            LEFT JOIN ObjectLink AS ObjectLink_Contract_BankAccount
                                 ON ObjectLink_Contract_BankAccount.ObjectId = View_Contract.ContractId
                                AND ObjectLink_Contract_BankAccount.DescId = zc_ObjectLink_Contract_BankAccount()

            LEFT JOIN tmpBankAccount AS tmpBankAccount1 ON tmpBankAccount1.UnitId      = MovementLinkObject_From.ObjectId
                                                       AND tmpBankAccount1.InfoMoneyId = View_Contract.InfoMoneyId
                                                       AND ObjectLink_Contract_BankAccount.ChildObjectId IS NULL
            LEFT JOIN tmpBankAccount AS tmpBankAccount2 ON tmpBankAccount2.UnitId      = MovementLinkObject_From.ObjectId
                                                       AND tmpBankAccount2.InfoMoneyId = 0
                                                       AND ObjectLink_Contract_BankAccount.ChildObjectId IS NULL
                                                       AND tmpBankAccount1.BankAccountId IS NULL
            LEFT JOIN tmpBankAccount AS tmpBankAccount3 ON tmpBankAccount3.UnitId      = 0
                                                       AND tmpBankAccount3.InfoMoneyId = View_Contract.InfoMoneyId
                                                       AND ObjectLink_Contract_BankAccount.ChildObjectId IS NULL
                                                       AND tmpBankAccount1.BankAccountId IS NULL
                                                       AND tmpBankAccount2.BankAccountId IS NULL
            LEFT JOIN tmpBankAccount AS tmpBankAccount4 ON tmpBankAccount4.UnitId      = 0
                                                       AND tmpBankAccount4.InfoMoneyId = 0
                                                       AND ObjectLink_Contract_BankAccount.ChildObjectId IS NULL
                                                       AND tmpBankAccount1.BankAccountId IS NULL
                                                       AND tmpBankAccount2.BankAccountId IS NULL
                                                       AND tmpBankAccount3.BankAccountId IS NULL
            LEFT JOIN Object_BankAccount_View AS Object_BankAccount ON Object_BankAccount.Id = COALESCE (ObjectLink_Contract_BankAccount.ChildObjectId, COALESCE (tmpBankAccount1.BankAccountId, COALESCE (tmpBankAccount2.BankAccountId, COALESCE (tmpBankAccount3.BankAccountId, tmpBankAccount4.BankAccountId))))

            LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_Bank_From
                                                                ON OH_JuridicalDetails_Bank_From.JuridicalId = Object_BankAccount.BankJuridicalId
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) >= OH_JuridicalDetails_Bank_From.StartDate
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) <  OH_JuridicalDetails_Bank_From.EndDate

            LEFT JOIN ObjectHistoryString AS OHS_JD_JuridicalAddress_Bank_From
                                          ON OHS_JD_JuridicalAddress_Bank_From.ObjectHistoryId = OH_JuridicalDetails_Bank_From.ObjectHistoryId
                                         AND OHS_JD_JuridicalAddress_Bank_From.DescId = zc_ObjectHistoryString_JuridicalDetails_JuridicalAddress()

            LEFT JOIN tmpObject_Bank_View AS Object_Bank_View_CorrespondentBank_From ON Object_Bank_View_CorrespondentBank_From.Id = Object_BankAccount.CorrespondentBankId

            LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_CorrBank_From
                                                                ON OH_JuridicalDetails_CorrBank_From.JuridicalId = Object_Bank_View_CorrespondentBank_From.JuridicalId
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) >= OH_JuridicalDetails_CorrBank_From.StartDate
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) <  OH_JuridicalDetails_CorrBank_From.EndDate

            LEFT JOIN ObjectHistoryString AS OHS_JD_JuridicalAddress_CorrBank_From
                                          ON OHS_JD_JuridicalAddress_CorrBank_From.ObjectHistoryId = OH_JuridicalDetails_CorrBank_From.ObjectHistoryId
                                         AND OHS_JD_JuridicalAddress_CorrBank_From.DescId = zc_ObjectHistoryString_JuridicalDetails_JuridicalAddress()

-- +++++++++++++++++ BANK TO
            LEFT JOIN
                      (SELECT *
                       FROM Object_BankAccount_View
                       LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                    ON MovementLinkObject_To.MovementId = inMovementId
                                                   AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                       LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                            ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                                           AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()


                      WHERE Object_BankAccount_View.JuridicalId = ObjectLink_Partner_Juridical.ChildObjectId
                      LIMIT 1
                      ) AS BankAccount_To ON 1=1

            LEFT JOIN tmpObject_Bank_View AS Object_Bank_View_CorrespondentBank ON Object_Bank_View_CorrespondentBank.Id = BankAccount_To.CorrespondentBankId
            LEFT JOIN tmpObject_Bank_View AS Object_Bank_View_BenifBank ON Object_Bank_View_BenifBank.Id = BankAccount_To.BeneficiarysBankId
            LEFT JOIN tmpObject_Bank_View AS Object_Bank_View_To ON Object_Bank_View_To.Id = BankAccount_To.BankId

            LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_BenifBank_To
                                                                ON OH_JuridicalDetails_BenifBank_To.JuridicalId = Object_Bank_View_BenifBank.JuridicalId
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) >= OH_JuridicalDetails_BenifBank_To.StartDate
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) < OH_JuridicalDetails_BenifBank_To.EndDate

            LEFT JOIN ObjectHistoryString AS OHS_JD_JuridicalAddress_BenifBank_To
                                          ON OHS_JD_JuridicalAddress_BenifBank_To.ObjectHistoryId = OH_JuridicalDetails_BenifBank_To.ObjectHistoryId
                                         AND OHS_JD_JuridicalAddress_BenifBank_To.DescId = zc_ObjectHistoryString_JuridicalDetails_JuridicalAddress()


            LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetailsBank_To
                                                                ON OH_JuridicalDetailsBank_To.JuridicalId = Object_Bank_View_To.JuridicalId
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) >= OH_JuridicalDetailsBank_To.StartDate
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) <  OH_JuridicalDetailsBank_To.EndDate

            LEFT JOIN ObjectHistoryString AS OHS_JD_JuridicalAddress_To
                                          ON OHS_JD_JuridicalAddress_To.ObjectHistoryId = OH_JuridicalDetailsBank_To.ObjectHistoryId
                                         AND OHS_JD_JuridicalAddress_To.DescId = zc_ObjectHistoryString_JuridicalDetails_JuridicalAddress()

--
            LEFT JOIN tmpMovementLinkMovement AS MovementLinkMovement_Master
                                              ON MovementLinkMovement_Master.MovementId = Movement.Id
                                             AND MovementLinkMovement_Master.DescId = zc_MovementLinkMovement_Master()
            LEFT JOIN tmpMovementString_ord AS MS_InvNumberPartner_Master
                                            ON MS_InvNumberPartner_Master.MovementId = MovementLinkMovement_Master.MovementChildId
                                           AND MS_InvNumberPartner_Master.DescId = zc_MovementString_InvNumberPartner()



       WHERE Movement.Id =  inMovementId
         AND Movement.StatusId = zc_Enum_Status_Complete()
      ;
    RETURN NEXT Cursor1;


    OPEN Cursor2 FOR
     WITH /*tmpObject_GoodsPropertyValue AS
       (SELECT ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
             , ObjectLink_GoodsPropertyValue_Goods.ChildObjectId                   AS GoodsId
             , COALESCE (ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId, 0) AS GoodsKindId
             , Object_GoodsPropertyValue.ValueData  AS Name
             , ObjectFloat_Amount.ValueData         AS Amount
             , ObjectFloat_AmountDoc.ValueData      AS AmountDoc
             , ObjectFloat_BoxCount.ValueData       AS BoxCount
             , ObjectString_BarCode.ValueData       AS BarCode
             , ObjectString_Article.ValueData       AS Article
             , ObjectString_BarCodeGLN.ValueData    AS BarCodeGLN
             , ObjectString_ArticleGLN.ValueData    AS ArticleGLN
             , COALESCE (ObjectBoolean_Weigth.ValueData, FALSE) :: Boolean AS isWeigth
        FROM (SELECT vbGoodsPropertyId AS GoodsPropertyId WHERE vbGoodsPropertyId <> 0
             ) AS tmpGoodsProperty
             INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                   ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = tmpGoodsProperty.GoodsPropertyId
                                  AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
             LEFT JOIN Object AS Object_GoodsPropertyValue ON Object_GoodsPropertyValue.Id = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
             LEFT JOIN ObjectFloat AS ObjectFloat_Amount
                                   ON ObjectFloat_Amount.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                  AND ObjectFloat_Amount.DescId = zc_ObjectFloat_GoodsPropertyValue_Amount()
             LEFT JOIN ObjectFloat AS ObjectFloat_AmountDoc
                                   ON ObjectFloat_AmountDoc.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                  AND ObjectFloat_AmountDoc.DescId = zc_ObjectFloat_GoodsPropertyValue_AmountDoc()
             LEFT JOIN ObjectFloat AS ObjectFloat_BoxCount
                                   ON ObjectFloat_BoxCount.ObjectId = Object_GoodsPropertyValue.Id
                                  AND ObjectFloat_BoxCount.DescId = zc_ObjectFloat_GoodsPropertyValue_BoxCount()
             LEFT JOIN ObjectString AS ObjectString_BarCode
                                    ON ObjectString_BarCode.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                   AND ObjectString_BarCode.DescId = zc_ObjectString_GoodsPropertyValue_BarCode()
             LEFT JOIN ObjectString AS ObjectString_Article
                                    ON ObjectString_Article.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                   AND ObjectString_Article.DescId = zc_ObjectString_GoodsPropertyValue_Article()

             LEFT JOIN ObjectString AS ObjectString_BarCodeGLN
                                    ON ObjectString_BarCodeGLN.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                   AND ObjectString_BarCodeGLN.DescId = zc_ObjectString_GoodsPropertyValue_BarCodeGLN()
             LEFT JOIN ObjectString AS ObjectString_ArticleGLN
                                    ON ObjectString_ArticleGLN.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                   AND ObjectString_ArticleGLN.DescId = zc_ObjectString_GoodsPropertyValue_ArticleGLN()

             LEFT JOIN ObjectBoolean AS ObjectBoolean_Weigth
                                     ON ObjectBoolean_Weigth.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                    AND ObjectBoolean_Weigth.DescId = zc_ObjectBoolean_GoodsPropertyValue_Weigth()

             LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                  ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                 AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
             LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                  ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                 AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
       )
     ,*/
       tmpObject_GoodsPropertyValueGroup AS
       (SELECT tmpObject_GoodsPropertyValue.GoodsId
             , tmpObject_GoodsPropertyValue.Name
             , tmpObject_GoodsPropertyValue.Article
             , tmpObject_GoodsPropertyValue.ArticleGLN
             , tmpObject_GoodsPropertyValue.BarCode
             , tmpObject_GoodsPropertyValue.BarCodeGLN
             , tmpObject_GoodsPropertyValue.BoxCount
        FROM (SELECT MAX (tmpObject_GoodsPropertyValue.ObjectId) AS ObjectId, GoodsId FROM tmpObject_GoodsPropertyValue WHERE Article <> '' OR ArticleGLN <> '' OR BarCode <> '' OR BarCodeGLN <> '' OR Name <> '' GROUP BY GoodsId
             ) AS tmpGoodsProperty_find
             LEFT JOIN tmpObject_GoodsPropertyValue ON tmpObject_GoodsPropertyValue.ObjectId =  tmpGoodsProperty_find.ObjectId
       )
     , tmpObject_GoodsPropertyValue_basis AS
       (SELECT ObjectLink_GoodsPropertyValue_Goods.ObjectId      AS ObjectId
             , ObjectLink_GoodsPropertyValue_Goods.ChildObjectId AS GoodsId
             , COALESCE (ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId, 0) AS GoodsKindId
             , Object_GoodsPropertyValue.ValueData  AS Name
             , ObjectString_BarCode.ValueData       AS BarCode
        FROM (SELECT vbGoodsPropertyId_basis AS GoodsPropertyId
             ) AS tmpGoodsProperty
             INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                   ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = tmpGoodsProperty.GoodsPropertyId
                                  AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
             INNER JOIN Object AS Object_GoodsPropertyValue ON Object_GoodsPropertyValue.Id = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                           -- AND Object_GoodsPropertyValue.ValueData <> ''
             LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                  ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                 AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
             LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                  ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                 AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
             LEFT JOIN ObjectString AS ObjectString_BarCode
                                    ON ObjectString_BarCode.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                   AND ObjectString_BarCode.DescId = zc_ObjectString_GoodsPropertyValue_BarCode()
       )
     , tmpObject_GoodsPropertyValueGroup_basis AS
       (SELECT tmpObject_GoodsPropertyValue.GoodsId
             , tmpObject_GoodsPropertyValue.Name
             , tmpObject_GoodsPropertyValue.BarCode
        FROM (SELECT MAX (tmpObject_GoodsPropertyValue.ObjectId) AS ObjectId, GoodsId FROM tmpObject_GoodsPropertyValue_basis AS tmpObject_GoodsPropertyValue WHERE BarCode <> '' OR Name <> '' GROUP BY GoodsId
             ) AS tmpGoodsProperty_find
             LEFT JOIN tmpObject_GoodsPropertyValue_basis AS tmpObject_GoodsPropertyValue ON tmpObject_GoodsPropertyValue.ObjectId =  tmpGoodsProperty_find.ObjectId
       )
   --, tmpMI_EDI AS (SELECT MAX (MovementItem.Id)                         AS MovementItemId
     , tmpMI_Order AS (SELECT MAX (MovementItem.Id)                         AS MovementItemId
                            , MovementItem.ObjectId                         AS GoodsId
                            , SUM (MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0)) AS Amount
                            , COALESCE (MILinkObject_GoodsKind.ObjectId, zc_GoodsKind_Basis()) AS GoodsKindId
                            , COALESCE (MIFloat_Price.ValueData, 0)         AS Price
                            , CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END AS CountForPrice
                       FROM (SELECT MovementLinkMovement_Order.MovementChildId AS MovementId
                             FROM MovementLinkMovement AS MovementLinkMovement_Order
                             WHERE MovementLinkMovement_Order.MovementId = inMovementId
                               AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
                            ) AS tmpMovement
                            INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovement.MovementId
                                                   AND MovementItem.DescId     = zc_MI_Master()
                                                   AND MovementItem.isErased   = FALSE
                                                   AND MovementItem.Amount     <> 0
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                            LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                                        ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                                       AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
                            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()
                            LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                        ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                       AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                       GROUP BY MovementItem.ObjectId
                              , COALESCE (MILinkObject_GoodsKind.ObjectId, zc_GoodsKind_Basis())
                              , COALESCE (MIFloat_Price.ValueData, 0)
                              , CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END
                         )
 -- строки док
 , tmpMI AS (SELECT MovementItem.ObjectId AS GoodsId
                  , COALESCE (MILinkObject_GoodsKind.ObjectId, zc_GoodsKind_Basis()) AS GoodsKindId
                  , CASE WHEN MIFloat_ChangePercent.ValueData <> 0 AND vbIsChangePrice = TRUE -- !!!для НАЛ не учитываем, но НЕ всегда!!!
                              THEN zfCalc_PriceTruncate (inOperDate     := vbOperDatePartner
                                                       , inChangePercent:= MIFloat_ChangePercent.ValueData
                                                       , inPrice        := COALESCE (MIFloat_PriceTare.ValueData, MIFloat_Price.ValueData, 0)
                                                       , inIsWithVAT    := vbPriceWithVAT
                                                        )
                         WHEN vbDiscountPercent <> 0 AND vbIsChangePrice = TRUE AND vbDescId <> zc_Movement_Sale()
                              THEN zfCalc_PriceTruncate (inOperDate     := vbOperDatePartner
                                                       , inChangePercent:= -1 * vbDiscountPercent
                                                       , inPrice        := COALESCE (MIFloat_PriceTare.ValueData, MIFloat_Price.ValueData, 0)
                                                       , inIsWithVAT    := vbPriceWithVAT
                                                        )
                         WHEN vbExtraChargesPercent <> 0 AND vbIsChangePrice = TRUE AND vbDescId <> zc_Movement_Sale()
                              THEN zfCalc_PriceTruncate (inOperDate     := vbOperDatePartner
                                                       , inChangePercent:= -1 * vbExtraChargesPercent
                                                       , inPrice        := COALESCE (MIFloat_PriceTare.ValueData, MIFloat_Price.ValueData, 0)
                                                       , inIsWithVAT    := vbPriceWithVAT
                                                        )
                         ELSE COALESCE (MIFloat_PriceTare.ValueData, MIFloat_Price.ValueData, 0)

                    END AS Price

                  , MIFloat_CountForPrice.ValueData AS CountForPrice

                  , MIDate_PartionGoods.ValueData   AS PartionGoodsDate

                  , SUM (MovementItem.Amount) AS Amount
                  , SUM (CASE WHEN Movement.DescId IN (zc_Movement_Sale())
                                   THEN COALESCE (MIFloat_AmountPartner.ValueData, 0)
                              WHEN Movement.DescId IN (zc_Movement_SendOnPrice()) AND vbIsProcess_BranchIn = TRUE
                                   THEN COALESCE (MIFloat_AmountPartner.ValueData, 0)
                              ELSE MovementItem.Amount

                         END) AS AmountPartner
                  , ObjectLink_GoodsGroup.ChildObjectId    AS GoodsGroupId

             FROM MovementItem
                  LEFT JOIN MovementItemFloat AS MIFloat_Price
                                               ON MIFloat_Price.MovementItemId = MovementItem.Id
                                              AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                              --AND MIFloat_Price.ValueData <> 0
                  --если MIFloat_Price.ValueData = 0, тогда берем zc_MIFloat_PriceTare
                  LEFT JOIN MovementItemFloat AS MIFloat_PriceTare
                                              ON MIFloat_PriceTare.MovementItemId = MovementItem.Id
                                             AND MIFloat_PriceTare.DescId = zc_MIFloat_PriceTare()
                                             AND COALESCE (MIFloat_Price.ValueData,0) = 0

                  LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                              ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                             AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                  LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId

                  LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                              ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                             AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

                  LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                   ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                  AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                  LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                              ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                             AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()

                  LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                             ON MIDate_PartionGoods.MovementItemId =  MovementItem.Id
                                            AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                                            AND vbDescId = zc_Movement_Loss()

                  LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup
                                       ON ObjectLink_GoodsGroup.ObjectId = MovementItem.ObjectId
                                      AND ObjectLink_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()

             WHERE MovementItem.MovementId = inMovementId
               AND MovementItem.DescId     = zc_MI_Master()
               AND MovementItem.isErased   = FALSE
             GROUP BY MovementItem.ObjectId
                    , MILinkObject_GoodsKind.ObjectId
                    , CASE WHEN MIFloat_ChangePercent.ValueData <> 0 AND vbIsChangePrice = TRUE -- !!!для НАЛ не учитываем, но НЕ всегда!!!
                                THEN zfCalc_PriceTruncate (inOperDate     := vbOperDatePartner
                                                         , inChangePercent:= MIFloat_ChangePercent.ValueData
                                                         , inPrice        := COALESCE (MIFloat_PriceTare.ValueData, MIFloat_Price.ValueData, 0)
                                                         , inIsWithVAT    := vbPriceWithVAT
                                                          )
                           WHEN vbDiscountPercent <> 0 AND vbIsChangePrice = TRUE AND vbDescId <> zc_Movement_Sale()
                                THEN zfCalc_PriceTruncate (inOperDate     := vbOperDatePartner
                                                         , inChangePercent:= -1 * vbDiscountPercent
                                                         , inPrice        := COALESCE (MIFloat_PriceTare.ValueData, MIFloat_Price.ValueData, 0)
                                                         , inIsWithVAT    := vbPriceWithVAT
                                                          )
                           WHEN vbExtraChargesPercent <> 0 AND vbIsChangePrice = TRUE AND vbDescId <> zc_Movement_Sale()
                                THEN zfCalc_PriceTruncate (inOperDate     := vbOperDatePartner
                                                         , inChangePercent:= -1 * vbExtraChargesPercent
                                                         , inPrice        := COALESCE (MIFloat_PriceTare.ValueData, MIFloat_Price.ValueData, 0)
                                                         , inIsWithVAT    := vbPriceWithVAT
                                                          )
                           ELSE COALESCE (MIFloat_PriceTare.ValueData, MIFloat_Price.ValueData, 0)
                      END
                    , MIFloat_CountForPrice.ValueData
                    , MIFloat_ChangePercent.ValueData
                    , MIDate_PartionGoods.ValueData
                    , ObjectLink_GoodsGroup.ChildObjectId
            )
      , tmpGoods AS (SELECT DISTINCT tmpMI.GoodsId FROM tmpMI)
        -- на дату
      , tmpUKTZED AS (SELECT tmp.GoodsGroupId, lfGet_Object_GoodsGroup_CodeUKTZED_onDate (tmp.GoodsGroupId, vbOperDatePartner) AS CodeUKTZED
                      FROM (SELECT DISTINCT tmpMI.GoodsGroupId FROM tmpMI) AS tmp
                     )
        -- Цены из прайса
      , tmpPriceList AS (SELECT lfSelect.GoodsId     AS GoodsId
                              , lfSelect.GoodsKindId AS GoodsKindId
                              , lfSelect.ValuePrice  AS Price_basis
                         FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= zc_PriceList_Basis()
                                                                  , inOperDate   := COALESCE ((SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = inMovementId AND MD.DescId = zc_MovementDate_OperDatePartner()), (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId))
                                                                   ) AS lfSelect
                         WHERE lfSelect.ValuePrice <> 0
                        )
       -- документ Взвешивания
     , tmpMI_WeighingPartner AS (SELECT MovementItem.ObjectId                             AS GoodsId
                                      , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)     AS GoodsKindId
                                      , SUM (CASE WHEN MIBoolean_BarCode.ValueData = TRUE THEN 1 ELSE 0 END) AS Box_count
                                 FROM Movement
                                     INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                            AND MovementItem.DescId     = zc_MI_Master()
                                                            AND MovementItem.isErased   = FALSE
                                                            -- AND MovementItem.Amount    <> 0
                                     LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                      ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                     AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                                     LEFT JOIN MovementItemBoolean AS MIBoolean_BarCode
                                                                   ON MIBoolean_BarCode.MovementItemId =  MovementItem.Id
                                                                  AND MIBoolean_BarCode.DescId = zc_MIBoolean_BarCode()

                                 WHERE Movement.ParentId = inMovementId
                                   AND Movement.DescId   = zc_Movement_WeighingPartner()
                                   AND Movement.StatusId <> zc_Enum_Status_Erased()
                                 GROUP BY MovementItem.ObjectId
                                        , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                                )

     -- данные из строк налоговой
     , tmpMI_Tax AS (SELECT DISTINCT
                            MovementItem.ObjectId           AS GoodsId
                          , MILinkObject_GoodsKind.ObjectId AS GoodsKindId
                          , TRUE AS isName_new
                     FROM MovementItem
                          INNER JOIN MovementItemBoolean AS MIBoolean_Goods_Name_new
                                                         ON MIBoolean_Goods_Name_new.MovementItemId = MovementItem.Id
                                                        AND MIBoolean_Goods_Name_new.DescId = zc_MIBoolean_Goods_Name_new()
                                                        AND COALESCE (MIBoolean_Goods_Name_new.ValueData, FALSE) = TRUE
                          LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                           ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                     WHERE MovementItem.MovementId = vbMovementId_tax
                       AND MovementItem.DescId     = zc_MI_Master()
                       AND MovementItem.isErased   = FALSE
                     )

      -- Результат
      SELECT COALESCE (Object_GoodsByGoodsKind_View.Id, Object_Goods.Id) AS Id
           , Object_Goods.ObjectCode         AS GoodsCode
           , tmpObject_GoodsPropertyValue_basis.BarCode AS BarCode_Main

           , (CASE WHEN tmpObject_GoodsPropertyValue.Name            <> '' THEN tmpObject_GoodsPropertyValue.Name
                   WHEN tmpObject_GoodsPropertyValueGroup.Name       <> '' THEN tmpObject_GoodsPropertyValueGroup.Name
                   WHEN tmpObject_GoodsPropertyValue_basis.Name      <> '' THEN tmpObject_GoodsPropertyValue_basis.Name
                   WHEN tmpObject_GoodsPropertyValueGroup_basis.Name <> '' THEN tmpObject_GoodsPropertyValueGroup_basis.Name
                   WHEN ObjectString_Goods_BUH.ValueData <> '' AND vbOperDate >= ObjectDate_BUH.ValueData THEN Object_Goods.ValueData
                   WHEN COALESCE (tmpMI_Tax.isName_new, FALSE)      = TRUE THEN Object_Goods.ValueData
                   WHEN ObjectString_Goods_BUH.ValueData             <> '' THEN ObjectString_Goods_BUH.ValueData
                   ELSE Object_Goods.ValueData
              END
           || CASE WHEN COALESCE (Object_GoodsKind.Id, zc_Enum_GoodsKind_Main()) = zc_Enum_GoodsKind_Main() THEN '' ELSE ' ' || Object_GoodsKind.ValueData END
           || CASE WHEN vbDescId = zc_Movement_Loss() AND tmpMI.PartionGoodsDate > zc_DateStart() THEN ' ~' || zfConvert_DateToString (tmpMI.PartionGoodsDate) ELSE '' END

             ) :: TVarChar AS GoodsName

           , (CASE WHEN tmpObject_GoodsPropertyValue.Name            <> '' THEN tmpObject_GoodsPropertyValue.Name
                   WHEN tmpObject_GoodsPropertyValueGroup.Name       <> '' THEN tmpObject_GoodsPropertyValueGroup.Name
                   WHEN tmpObject_GoodsPropertyValue_basis.Name      <> '' THEN tmpObject_GoodsPropertyValue_basis.Name
                   WHEN tmpObject_GoodsPropertyValueGroup_basis.Name <> '' THEN tmpObject_GoodsPropertyValueGroup_basis.Name
                   WHEN ObjectString_Goods_BUH.ValueData <> '' AND vbOperDate >= ObjectDate_BUH.ValueData THEN Object_Goods.ValueData
                   WHEN COALESCE (tmpMI_Tax.isName_new, FALSE)      = TRUE THEN Object_Goods.ValueData
                   WHEN ObjectString_Goods_BUH.ValueData             <> '' THEN ObjectString_Goods_BUH.ValueData
                   ELSE Object_Goods.ValueData
              END
           || CASE WHEN vbDescId = zc_Movement_Loss() AND tmpMI.PartionGoodsDate > zc_DateStart() THEN ' ~' || zfConvert_DateToString (tmpMI.PartionGoodsDate) ELSE '' END
             ) :: TVarChar AS GoodsName_two

           , Object_GoodsKind.ValueData      AS GoodsKindName
           , Object_Measure.ValueData        AS MeasureName
           , OS_Measure_InternalCode.ValueData  AS MeasureIntCode
           , CASE Object_Measure.Id
                  WHEN zc_Measure_Sh() THEN 'PCE'
                  ELSE 'KGM'
             END::TVarChar                   AS DELIVEREDUNIT
           , tmpMI.Amount                    AS Amount

           --если  isWeigth = true - тогда в amountpartner - для шт. вернуть вес, в measurename - вернуть кг.
           , CASE WHEN COALESCE (tmpObject_GoodsPropertyValue.isWeigth, FALSE) = FALSE THEN tmpMI.AmountPartner
                  ELSE CAST ((tmpMI.AmountPartner * (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END )) AS TFloat)
             END                             AS AmountPartner

           , tmpMI_Order.Amount              AS AmountOrder

           , (CASE WHEN vbPriceWithVAT = TRUE AND vbVATPercent > 0 AND vbOKPO = '26632252'
                        THEN CAST (tmpMI.Price / (1 + vbVATPercent / 100) AS NUMERIC (16, 3))
                        ELSE tmpMI.Price
              END / CASE WHEN tmpMI.CountForPrice > 1 THEN tmpMI.CountForPrice ELSE 1 END
             ) :: TFLoat AS Price

           , CASE WHEN COALESCE (tmpObject_GoodsPropertyValue.BoxCount, COALESCE (tmpObject_GoodsPropertyValueGroup.BoxCount, 0)) > 0
                       THEN CAST (tmpMI.AmountPartner / COALESCE (tmpObject_GoodsPropertyValue.BoxCount, COALESCE (tmpObject_GoodsPropertyValueGroup.BoxCount, 0)) AS NUMERIC (16, 4))
                  ELSE 0
             END AS AmountBox
           , CASE WHEN COALESCE (tmpObject_GoodsPropertyValue.AmountDoc, 0) > 0
                       THEN CAST ((tmpMI.AmountPartner / tmpObject_GoodsPropertyValue.AmountDoc) AS NUMERIC (16, 4))
                  ELSE 0
             END AS AmountDocBox

           , COALESCE (tmpObject_GoodsPropertyValue.Name, '')       AS GoodsName_Juridical
           , COALESCE (tmpObject_GoodsPropertyValue.Amount, 0)      AS AmountInPack_Juridical
           , COALESCE (tmpObject_GoodsPropertyValue.AmountDoc, 0)   AS AmountDocInPack_Juridical
           , COALESCE (tmpObject_GoodsPropertyValue.BoxCount, tmpObject_GoodsPropertyValueGroup.BoxCount, 0)      AS BoxCount_Juridical
           , COALESCE (tmpObject_GoodsPropertyValueGroup.Article,    tmpObject_GoodsPropertyValue.Article, '')    AS Article_Juridical
           , COALESCE (tmpObject_GoodsPropertyValueGroup.BarCode,    tmpObject_GoodsPropertyValue.BarCode, tmpObject_GoodsPropertyValueGroup_basis.BarCode, '') AS BarCode_Juridical
           , COALESCE (tmpObject_GoodsPropertyValueGroup.ArticleGLN, tmpObject_GoodsPropertyValue.ArticleGLN, '') AS ArticleGLN_Juridical
           , COALESCE (tmpObject_GoodsPropertyValueGroup.BarCodeGLN, tmpObject_GoodsPropertyValue.BarCodeGLN, '') AS BarCodeGLN_Juridical

           , CASE WHEN vbGoodsPropertyId = 83954 -- Метро
                       THEN COALESCE (tmpObject_GoodsPropertyValueGroup.Article, COALESCE (tmpObject_GoodsPropertyValue.Article, ''))
                  ELSE ''
             END AS Article_order

             -- сумма по ценам док-та
           , CASE WHEN -- !!!захардкодил временно для БН с НДС!!!
                       vbPriceWithVAT = TRUE AND MLO_PaidKind.ObjectId = zc_Enum_PaidKind_FirstForm()
                       THEN CAST (tmpMI.AmountPartner
                                  -- расчет цены без НДС, до 4 знаков
                                * CAST (tmpMI.Price - tmpMI.Price * (vbVATPercent / (vbVATPercent + 100)) AS NUMERIC (16, 4))
                                / CASE WHEN tmpMI.CountForPrice <> 0 THEN tmpMI.CountForPrice ELSE 1 END
                                 AS NUMERIC (16, 2))

                  WHEN tmpMI.CountForPrice <> 0
                       THEN CASE WHEN vbPriceWithVAT = TRUE
                                 THEN CAST (tmpMI.AmountPartner * (tmpMI.Price - tmpMI.Price * (vbVATPercent / (vbVATPercent + 100))) / tmpMI.CountForPrice AS NUMERIC (16, 2))
                                 ELSE CAST (tmpMI.AmountPartner * (tmpMI.Price / tmpMI.CountForPrice) AS NUMERIC (16, 2))
                            END

                  ELSE CASE WHEN vbPriceWithVAT = TRUE
                                 THEN CAST (tmpMI.AmountPartner * (tmpMI.Price - tmpMI.Price * (vbVATPercent / (vbVATPercent + 100))) AS NUMERIC (16, 2))
                                 ELSE CAST (tmpMI.AmountPartner * tmpMI.Price AS NUMERIC (16, 2))
                            END
             END AS AmountSumm

             -- расчет цены без НДС, до 4 знаков
           , CASE WHEN vbPriceWithVAT = TRUE
                  THEN CAST (tmpMI.Price - tmpMI.Price * (vbVATPercent / (vbVATPercent + 100)) AS NUMERIC (16, 4))
                  ELSE tmpMI.Price
             END  / CASE WHEN tmpMI.CountForPrice <> 0 THEN tmpMI.CountForPrice ELSE 1 END
             AS PriceNoVAT

             -- расчет цены с НДС и скидкой, до 4 знаков
           , CASE WHEN vbPriceWithVAT <> TRUE
                  THEN CAST ((tmpMI.Price + tmpMI.Price * (vbVATPercent / 100))
                                         * CASE WHEN vbDiscountPercent <> 0 AND vbIsChangePrice = FALSE -- !!!учитываем для НАЛ, но НЕ всегда!!!
                                                     THEN (1 - vbDiscountPercent / 100)
                                                WHEN vbExtraChargesPercent <> 0 AND vbIsChangePrice = FALSE -- !!!учитываем для НАЛ, но НЕ всегда!!!
                                                     THEN (1 + vbExtraChargesPercent / 100)
                                                ELSE 1
                                           END
                             AS NUMERIC (16, 4))
                  ELSE CAST (tmpMI.Price * CASE WHEN vbDiscountPercent <> 0 AND vbIsChangePrice = FALSE -- !!!учитываем для НАЛ, но НЕ всегда!!!
                                                     THEN (1 - vbDiscountPercent / 100)
                                                WHEN vbExtraChargesPercent <> 0 AND vbIsChangePrice = FALSE -- !!!учитываем для НАЛ, но НЕ всегда!!!
                                                     THEN (1 + vbExtraChargesPercent / 100)
                                                ELSE 1
                                           END
                             AS NUMERIC (16, 4))
             END / CASE WHEN tmpMI.CountForPrice <> 0 THEN tmpMI.CountForPrice ELSE 1 END
             AS PriceWVAT
             -- расчет суммы с НДС и скидкой, до 2 знаков
           , CASE WHEN 1 = (SELECT COUNT(*) FROM tmpMI)
                  THEN CASE WHEN vbIsProcess_BranchIn = FALSE AND vbDescId = zc_Movement_SendOnPrice() THEN vbOperSumm_PVAT ELSE (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inMovementId AND MF.DescId = zc_MovementFloat_TotalSummPVAT()) END
                  ELSE CAST (CASE WHEN vbPriceWithVAT <> TRUE
                                  THEN CAST ((tmpMI.Price + tmpMI.Price * (vbVATPercent / 100))
                                                         * CASE WHEN vbDiscountPercent <> 0 AND vbIsChangePrice = FALSE -- !!!учитываем для НАЛ, но НЕ всегда!!!
                                                                     THEN (1 - vbDiscountPercent / 100)
                                                                WHEN vbExtraChargesPercent <> 0 AND vbIsChangePrice = FALSE -- !!!учитываем для НАЛ, но НЕ всегда!!!
                                                                     THEN (1 + vbExtraChargesPercent / 100)
                                                                ELSE 1
                                                           END
                                             AS NUMERIC (16, 4))
                                  ELSE CAST (tmpMI.Price * CASE WHEN vbDiscountPercent <> 0 AND vbIsChangePrice = FALSE -- !!!учитываем для НАЛ, но НЕ всегда!!!
                                                                     THEN (1 - vbDiscountPercent / 100)
                                                                WHEN vbExtraChargesPercent <> 0 AND vbIsChangePrice = FALSE -- !!!учитываем для НАЛ, но НЕ всегда!!!
                                                                     THEN (1 + vbExtraChargesPercent / 100)
                                                                ELSE 1
                                                           END
                                             AS NUMERIC (16, 4))
                             END / CASE WHEN tmpMI.CountForPrice <> 0 THEN tmpMI.CountForPrice ELSE 1 END
                           * tmpMI.AmountPartner
                             AS NUMERIC (16, 2))
             END :: TFloat AS SummWVAT
             -- расчет цены с НДС БЕЗ скидки, до 4 знаков
           , CASE WHEN vbPriceWithVAT <> TRUE
                  THEN CAST ((tmpMI.Price + tmpMI.Price * (vbVATPercent / 100))
                                         * 1
                             AS NUMERIC (16, 4))
                  ELSE CAST (tmpMI.Price * 1
                             AS NUMERIC (16, 4))
             END / CASE WHEN tmpMI.CountForPrice <> 0 THEN tmpMI.CountForPrice ELSE 1 END
             AS PriceWVAT_original

             -- расчет суммы без НДС, до 2 знаков
           , CAST (tmpMI.AmountPartner * CASE WHEN vbPriceWithVAT = TRUE
                                              THEN (tmpMI.Price - tmpMI.Price * (vbVATPercent / (vbVATPercent + 100)))
                                              ELSE tmpMI.Price
                                         END / CASE WHEN tmpMI.CountForPrice <> 0 THEN tmpMI.CountForPrice ELSE 1 END
                   AS NUMERIC (16, 2)) AS AmountSummNoVAT

             -- расчет суммы с НДС, до 3 знаков
           , CAST (tmpMI.AmountPartner * CASE WHEN vbPriceWithVAT <> TRUE
                                              THEN tmpMI.Price + tmpMI.Price * (vbVATPercent / 100)
                                              ELSE tmpMI.Price
                                         END / CASE WHEN tmpMI.CountForPrice <> 0 THEN tmpMI.CountForPrice ELSE 1 END
                   AS NUMERIC (16, 3)) AS AmountSummWVAT

           , CAST ((tmpMI.AmountPartner * (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END )) AS TFloat) AS Amount_Weight
           , CAST (tmpMI.AmountPartner * COALESCE (ObjectFloat_Weight.ValueData, 0) AS TFloat) AS AmountPack_Weight
--           , CAST ((CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN tmpMI.AmountPartner ELSE 0 END) AS TFloat) AS Amount_Sh


           , CASE WHEN vbOperDate < '01.01.2017'
                       THEN ''

                  -- на дату у товара
                  WHEN ObjectString_Goods_UKTZED_new.ValueData <> '' AND ObjectDate_Goods_UKTZED_new.ValueData <= vbOperDatePartner
                       THEN CASE WHEN vbIsLongUKTZED = TRUE THEN ObjectString_Goods_UKTZED_new.ValueData ELSE SUBSTRING (ObjectString_Goods_UKTZED_new.ValueData FROM 1 FOR 4) END
                  -- у товара
                  WHEN ObjectString_Goods_UKTZED.ValueData <> ''
                       THEN CASE WHEN vbIsLongUKTZED = TRUE THEN ObjectString_Goods_UKTZED.ValueData ELSE SUBSTRING (ObjectString_Goods_UKTZED.ValueData FROM 1 FOR 4) END
                  -- на дату у группы товара
                  WHEN tmpUKTZED.CodeUKTZED <> ''
                       THEN CASE WHEN vbIsLongUKTZED = TRUE THEN tmpUKTZED.CodeUKTZED ELSE SUBSTRING (tmpUKTZED.CodeUKTZED FROM 1 FOR 4) END

                  WHEN ObjectLink_Goods_InfoMoney.ChildObjectId IN (zc_Enum_InfoMoney_20901(), zc_Enum_InfoMoney_30101())
                       THEN '1601'
                  WHEN ObjectLink_Goods_InfoMoney.ChildObjectId IN (zc_Enum_InfoMoney_21001(), zc_Enum_InfoMoney_30102())
                       THEN '1602'
                  WHEN ObjectLink_Goods_InfoMoney.ChildObjectId = zc_Enum_InfoMoney_30103()
                       THEN '1905'
                  ELSE '0'
              END :: TVarChar AS GoodsCodeUKTZED

              -- Залоговая цена без НДС, грн
            , CASE WHEN vbIsPrice_Pledge_25 = TRUE AND ObjectLink_Goods_InfoMoney.ChildObjectId = zc_Enum_InfoMoney_20501() THEN 25
                   WHEN ObjectLink_Goods_InfoMoney.ChildObjectId = zc_Enum_InfoMoney_20501() AND COALESCE (tmpPriceList_kind.Price_basis, tmpPriceList.Price_basis,0) > 0 THEN COALESCE (tmpPriceList_kind.Price_basis, tmpPriceList.Price_basis)
                   WHEN ObjectLink_Goods_InfoMoney.ChildObjectId = zc_Enum_InfoMoney_20501() THEN 60
                   ELSE 0
              END :: TFloat AS Price_Pledge
            , CASE WHEN ObjectLink_Goods_InfoMoney.ChildObjectId = zc_Enum_InfoMoney_20501() -- Общефирменные + "Оборотная тара"
                        THEN TRUE
                   ELSE FALSE
              END :: Boolean AS isFozziTare

            , CASE WHEN tmpMI_WeighingPartner.Box_count <= 1 AND COALESCE (tmpObject_GoodsPropertyValue.BoxCount, tmpObject_GoodsPropertyValueGroup.BoxCount, 0) > 0
                   THEN tmpMI.AmountPartner / COALESCE (tmpObject_GoodsPropertyValue.BoxCount, tmpObject_GoodsPropertyValueGroup.BoxCount, 0)
                   ELSE tmpMI_WeighingPartner.Box_count
              END :: Integer AS Box_count_calc

       FROM tmpMI
            LEFT JOIN tmpUKTZED ON tmpUKTZED.GoodsGroupId = tmpMI.GoodsGroupId
            LEFT JOIN tmpMI_Order ON tmpMI_Order.GoodsId     = tmpMI.GoodsId
                                 AND tmpMI_Order.GoodsKindId = tmpMI.GoodsKindId
            LEFT JOIN tmpMI_WeighingPartner ON tmpMI_WeighingPartner.GoodsId     = tmpMI.GoodsId
                                           AND tmpMI_WeighingPartner.GoodsKindId = tmpMI.GoodsKindId

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
            LEFT JOIN ObjectString AS ObjectString_Goods_BUH
                                   ON ObjectString_Goods_BUH.ObjectId = tmpMI.GoodsId
                                  AND ObjectString_Goods_BUH.DescId = zc_ObjectString_Goods_BUH()
            LEFT JOIN ObjectDate AS ObjectDate_BUH
                                 ON ObjectDate_BUH.ObjectId = tmpMI.GoodsId
                                AND ObjectDate_BUH.DescId = zc_ObjectDate_Goods_BUH()
            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                  ON ObjectFloat_Weight.ObjectId = Object_Goods.Id
                                 AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()

            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMI.GoodsKindId

            LEFT JOIN tmpObject_GoodsPropertyValue ON tmpObject_GoodsPropertyValue.GoodsId = tmpMI.GoodsId
                                                  AND tmpObject_GoodsPropertyValue.GoodsKindId = tmpMI.GoodsKindId
                                                  AND (tmpObject_GoodsPropertyValue.Article <> ''
                                                    OR tmpObject_GoodsPropertyValue.BarCode <> ''
                                                    OR tmpObject_GoodsPropertyValue.ArticleGLN <> ''
                                                    OR tmpObject_GoodsPropertyValue.Name <> '')
            LEFT JOIN tmpObject_GoodsPropertyValueGroup ON tmpObject_GoodsPropertyValueGroup.GoodsId = tmpMI.GoodsId
                                                       AND tmpObject_GoodsPropertyValue.GoodsId IS NULL
            LEFT JOIN tmpObject_GoodsPropertyValue_basis ON tmpObject_GoodsPropertyValue_basis.GoodsId = tmpMI.GoodsId
                                                        AND tmpObject_GoodsPropertyValue_basis.GoodsKindId = tmpMI.GoodsKindId
            LEFT JOIN tmpObject_GoodsPropertyValueGroup_basis ON tmpObject_GoodsPropertyValueGroup_basis.GoodsId = tmpMI.GoodsId
                                                           --AND tmpObject_GoodsPropertyValue_basis.GoodsId IS NULL

            LEFT JOIN Object_GoodsByGoodsKind_View ON Object_GoodsByGoodsKind_View.GoodsId = Object_Goods.Id
                                                  AND Object_GoodsByGoodsKind_View.GoodsKindId = Object_GoodsKind.Id

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() AND COALESCE (tmpObject_GoodsPropertyValue.isWeigth,FALSE) = TRUE THEN zc_Measure_Kg() ELSE ObjectLink_Goods_Measure.ChildObjectId END
            LEFT JOIN ObjectString AS OS_Measure_InternalCode
                                   ON OS_Measure_InternalCode.ObjectId = Object_Measure.Id
                                  AND OS_Measure_InternalCode.DescId = zc_ObjectString_Measure_InternalCode()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                 ON ObjectLink_Goods_InfoMoney.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()

            LEFT JOIN ObjectString AS ObjectString_Goods_UKTZED
                                   ON ObjectString_Goods_UKTZED.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_UKTZED.DescId = zc_ObjectString_Goods_UKTZED()
            LEFT JOIN ObjectString AS ObjectString_Goods_UKTZED_new
                                   ON ObjectString_Goods_UKTZED_new.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_UKTZED_new.DescId = zc_ObjectString_Goods_UKTZED_new()
            LEFT JOIN ObjectDate AS ObjectDate_Goods_UKTZED_new
                                 ON ObjectDate_Goods_UKTZED_new.ObjectId = Object_Goods.Id
                                AND ObjectDate_Goods_UKTZED_new.DescId = zc_ObjectDate_Goods_UKTZED_new()

            -- 2 раза по виду товара и без
            LEFT JOIN tmpPriceList ON tmpPriceList.GoodsId = tmpMI.GoodsId
                                  ANd tmpPriceList.GoodsKindId IS NULL
            LEFT JOIN tmpPriceList AS tmpPriceList_kind
                                   ON tmpPriceList_kind.GoodsId = tmpMI.GoodsId
                                  ANd COALESCE (tmpPriceList_kind.GoodsKindId,0) = COALESCE (tmpMI.GoodsKindId,0)

            LEFT JOIN MovementLinkObject AS MLO_PaidKind
                                         ON MLO_PaidKind.MovementId = inMovementId
                                        AND MLO_PaidKind.DescId     = zc_MovementLinkObject_PaidKind()

            LEFT JOIN tmpMI_Tax ON tmpMI_Tax.GoodsId = tmpMI.GoodsId
                               AND COALESCE (tmpMI_Tax.GoodsKindId,0) = COALESCE (tmpMI.GoodsKindId,0)
       WHERE tmpMI.AmountPartner <> 0
       ORDER BY CASE WHEN vbGoodsPropertyId IN (83954  -- Метро
                                              , 83963  -- Ашан
                                              , 404076 -- Новус
                                              , 83956  -- Фора
                                              , 83957  -- Кишени
                                               )
                          THEN zfConvert_StringToNumber (COALESCE (tmpObject_GoodsPropertyValueGroup.Article, COALESCE (tmpObject_GoodsPropertyValue.Article, '0')))
                     ELSE '0'
                END :: Integer
              , CASE WHEN vbIsGoodsCode = TRUE THEN Object_Goods.ObjectCode ELSE 0 END
              , CASE WHEN ObjectString_Goods_BUH.ValueData <> '' AND vbOperDate >= ObjectDate_BUH.ValueData THEN ObjectString_Goods_BUH.ValueData ELSE Object_Goods.ValueData END
              , Object_GoodsKind.ValueData
       ;

    RETURN NEXT Cursor2;

    -- печать тары
    OPEN Cursor3 FOR
      WITH tmpMI AS (SELECT MovementItem.ObjectId                         AS GoodsId
                          , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                          , SUM (MovementItem.Amount) AS Amount
                          , SUM (MovementItem.Amount) AS AmountPartner
                     FROM MovementItem
                          LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                      ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                     AND MIFloat_Price.DescId = zc_MIFloat_Price()
                          --если MIFloat_Price.ValueData = 0, тогда берем zc_MIFloat_PriceTare
                          LEFT JOIN MovementItemFloat AS MIFloat_PriceTare
                                                      ON MIFloat_PriceTare.MovementItemId = MovementItem.Id
                                                     AND MIFloat_PriceTare.DescId = zc_MIFloat_PriceTare()
                                                     AND COALESCE (MIFloat_Price.ValueData,0) = 0
                          LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                      ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                     AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                          LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId

                          LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                           ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                     -- !!!временно отключил!!!
                     WHERE MovementItem.MovementId = NULL -- inMovementId

                       AND MovementItem.DescId     = zc_MI_Master()
                       AND MovementItem.isErased   = FALSE
                       ---- AND COALESCE (MIFloat_Price.ValueData, 0) = 0
                       --AND COALESCE (MIFloat_PriceTare.ValueData,0) <> 0
                       AND 1 = 0 -- !!!временно отключил!!!
                     GROUP BY MovementItem.ObjectId
                            , MILinkObject_GoodsKind.ObjectId
                    )
      SELECT Object_Goods.ObjectCode         AS GoodsCode
           , (Object_Goods.ValueData || CASE WHEN COALESCE (Object_GoodsKind.Id, zc_Enum_GoodsKind_Main()) = zc_Enum_GoodsKind_Main() THEN '' ELSE ' ' || Object_GoodsKind.ValueData END) :: TVarChar AS GoodsName
           , Object_Goods.ValueData          AS GoodsName_two
           , Object_GoodsKind.ValueData      AS GoodsKindName
           , Object_Measure.ValueData        AS MeasureName

           , tmpMI.Amount                    AS Amount
           , tmpMI.AmountPartner             AS AmountPartner
           , CAST ((tmpMI.AmountPartner * (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 0 END )) AS TFloat) AS Amount_Weight
           -- , CAST ((CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpMI.AmountPartner ELSE 0 END) AS TFloat) AS Amount_Sh

       FROM tmpMI

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMI.GoodsKindId

            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                  ON ObjectFloat_Weight.ObjectId = Object_Goods.Id
                                 AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

       -- !!!временно отключил!!!
       -- WHERE tmpMI.AmountPartner <> 0

       -- !!!временно отключил!!!
       -- ORDER BY Object_Goods.ValueData, Object_GoodsKind.ValueData
      ;

    RETURN NEXT Cursor3;

     -- !!!временно - ПРОТОКОЛ - ЗАХАРДКОДИЛ!!!
   /*INSERT INTO ResourseProtocol (UserId
                                 , OperDate
                                 , Value1
                                 , Value2
                                 , Value3
                                 , Value4
                                 , Value5
                                 , Time1
                                 , Time2
                                 , Time3
                                 , Time4
                                 , Time5
                                 , ProcName
                                 , ProtocolData
                                  )
        WITH tmp_pg AS (SELECT * FROM pg_stat_activity WHERE state = 'active')
        SELECT vbUserId
               -- во сколько началась
             , CURRENT_TIMESTAMP
             , (SELECT COUNT (*) FROM tmp_pg)                                                    AS Value1
             , (SELECT COUNT (*) FROM tmp_pg WHERE position( 'autovacuum: VACUUM' in query) = 1) AS Value2
             , NULL AS Value3
             , NULL AS Value4
             , NULL AS Value5
               -- сколько всего выполнялась проц
             , (CLOCK_TIMESTAMP() - vbOperDate_Begin1) :: INTERVAL AS Time1
               -- сколько всего выполнялась проц ДО lpSelectMinPrice_List
             , NULL AS Time2
               -- сколько всего выполнялась проц lpSelectMinPrice_List
             , NULL AS Time3
               -- сколько всего выполнялась проц ПОСЛЕ lpSelectMinPrice_List
             , NULL AS Time4
               -- во сколько закончилась
             , CLOCK_TIMESTAMP() AS Time5
               -- ProcName
             , 'gpSelect_Movement_Sale_Print'
               -- ProtocolData
             , inMovementId :: TVarChar
    || ', ' || inSession
              ;*/

     IF vbUserId = 5 AND 1=0
     THEN
         RAISE EXCEPTION 'Ошибка.Admin Нет прав';
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_Sale_Print (Integer,TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 09.08.21         *
 06.12.19         *
 11.08.19         *
 26.11.15         *
 17.09.15         *
 13.11.14                                                       * fix
 12.11.14                                        * add AmountOrder
 17.10.14                                                       *
 13.05.14                                                       * Amount_Weight Amount_Sh
 23.07.14                                        * add ArticleGLN
 16.07.14                                        * add tmpObject_GoodsPropertyValueGroup
 20.06.14                                                       * change InvNumber
 05.06.14                                        * restore ContractSigningDate
 04.06.14                                        * add tmpObject_GoodsPropertyValue.Name
 20.05.14                                        * add Object_Contract_View
 17.05.14                                        * add StatusId = zc_Enum_Status_Complete
 13.05.14                                        * add calc GoodsName
 13.05.14                                                       * zc_ObjectLink_Contract_BankAccount
 08.05.14                        * add GLN code
 08.05.14                                        * all
 06.05.14                                        * add Object_Partner
 06.05.14                                                       * zc_Movement_SendOnPrice
 06.05.14                                        * OperDatePartner
 05.05.14                                                       *
 28.04.14                                                       *
 09.04.14                                        * add JOIN MIFloat_AmountPartner
 02.04.14                                                       *  PriceWVAT PriceNoVAT round to 2 sign
 01.04.14                                                       *  tmpMI.Price <> 0
 27.03.14                                                       *
 24.02.14                                                       *  add PriceNoVAT, PriceWVAT, AmountSummNoVAT, AmountSummWVAT
 19.02.14                                                       *  add by juridical
 07.02.14                                                       *  change to Cursor
 05.02.14                                                       *
*/

/*
-- PrintMovement_Sale01074874.fr3
++ PrintMovement_Sale1.fr3
++ PrintMovement_Sale2.fr3
-- PrintMovement_Sale22447463.fr3
++ PrintMovement_Sale2DiscountPrice.fr3
-- PrintMovement_Sale30487219.fr3
++ PrintMovement_Sale30982361.fr3
++ PrintMovement_Sale31929492.fr3
++ PrintMovement_Sale32049199.fr3
++ PrintMovement_Sale32294926.fr3
-- PrintMovement_Sale32516492.fr3
-- PrintMovement_Sale35275230.fr3
++ PrintMovement_Sale35442481.fr3
++ PrintMovement_Sale36003603.fr3
++ PrintMovement_Sale36387249.fr3
-- PrintMovement_Sale37910513.fr3
++ PrintMovement_Sale39118745.fr3


++ PrintMovement_Transport.fr3
++ PrintMovement_Transport32049199.fr3
-- PrintMovement_Transport32516492.fr3
++ PrintMovement_Transport36003603.fr3
*/
-- тест
-- SELECT * FROM gpSelect_Movement_Sale_Print (inMovementId:= 18441615, inSession:= zfCalc_UserAdmin()); -- FETCH ALL "<unnamed portal 1>";
