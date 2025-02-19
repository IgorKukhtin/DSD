-- Function: gpSelect_Movement_TaxCorrective_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_TaxCorrective_Print (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_TaxCorrective_Print(
    IN inMovementId        Integer  , -- ключ Документа
    IN inisClientCopy      Boolean  , -- копия для клиента
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE vbMovementId_Return        Integer;
    DECLARE vbMovementId_TaxCorrective Integer;
    DECLARE vbDocumentTaxKindId_tax    Integer;
    DECLARE vbDocumentTaxKindId        Integer;
    DECLARE vbStatusId_TaxCorrective   Integer;
    DECLARE vbIsLongUKTZED Boolean;

    DECLARE vbGoodsPropertyId Integer;
    DECLARE vbGoodsPropertyId_basis Integer;

    DECLARE vbNotNDSPayer_INN  TVarChar;
    DECLARE vbCalcNDSPayer_INN TVarChar;

    DECLARE vbOperDate_begin TDateTime;

    DECLARE vbIsNPP_calc Boolean;
    
    DECLARE vbMovementId_tax Integer;
    DECLARE vbOperDate_Tax TDateTime;
    DECLARE vbOperDate_Tax_Tax TDateTime;
    DECLARE vbOperDate_Tax_Tax_Tax TDateTime;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Sale());
     vbUserId:= lpGetUserBySession (inSession);


     -- !!!ОПРЕДЕЛИЛИ - НОВАЯ схема с 30.03.18!!!
     vbIsNPP_calc:= EXISTS (SELECT 1
                            FROM MovementItem
                                 LEFT JOIN MovementItemFloat AS MIFloat_NPPTax_calc
                                                             ON MIFloat_NPPTax_calc.MovementItemId = MovementItem.Id
                                                            AND MIFloat_NPPTax_calc.DescId         = zc_MIFloat_NPPTax_calc()
                                 LEFT JOIN MovementItemFloat AS MIFloat_NPP_calc
                                                             ON MIFloat_NPP_calc.MovementItemId = MovementItem.Id
                                                            AND MIFloat_NPP_calc.DescId         = zc_MIFloat_NPP_calc()
                                 LEFT JOIN MovementItemFloat AS MIFloat_AmountTax_calc
                                                             ON MIFloat_AmountTax_calc.MovementItemId = MovementItem.Id
                                                            AND MIFloat_AmountTax_calc.DescId         = zc_MIFloat_AmountTax_calc()

                            WHERE MovementItem.MovementId = inMovementId
                              AND MovementItem.DescId     = zc_MI_Master()
                              AND MovementItem.isErased   = FALSE
                              AND MovementItem.Amount     <> 0
                              AND (MIFloat_NPPTax_calc.ValueData    <> 0
                                OR MIFloat_NPP_calc.ValueData       <> 0
                                OR MIFloat_AmountTax_calc.ValueData <> 0
                                  )
                           );


     -- !!!хардкод!!!
     vbNotNDSPayer_INN := '100000000000';
     -- !!!хардкод!!!
     vbCalcNDSPayer_INN:= (SELECT CASE WHEN inMovementId IN (-- Corr
                                                             7943509
                                                           , 8066170
                                                           , 8066171
                                                           , 8066169
                                                           , 8464974
                                                           , 8465476
                                                           , 8465802
                                                           , 8479936
                                                           , 8462887
                                                           , 8462999
                                                           , 8463007
                                                           , 8488900
                                                           , 8464619
                                                            )
                                  THEN vbNotNDSPayer_INN ELSE '' END
                          );

     -- определяется
     vbMovementId_Return:= COALESCE ((SELECT MovementLinkMovement_Master.MovementChildId
                                      FROM Movement
                                           LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Master
                                                                          ON MovementLinkMovement_Master.MovementId = Movement.Id
                                                                         AND MovementLinkMovement_Master.DescId     = zc_MovementLinkMovement_Master()
                                       WHERE Movement.Id     = inMovementId
                                         AND Movement.DescId = zc_Movement_TaxCorrective()
                                     ), inMovementId);

     -- определяется <Налоговый документ> и его параметры
     SELECT COALESCE (tmpMovement.MovementId_TaxCorrective, 0) AS MovementId_TaxCorrective
          , Movement_TaxCorrective.StatusId                    AS StatusId_TaxCorrective

          , CASE WHEN (CURRENT_DATE >= '01.03.2021' /*OR vbUserId = 5*/)
                  AND COALESCE (MovementString_InvNumberRegistered.ValueData, '') = ''
                  -- AND COALESCE (MovementString_InvNumberRegistered_tax.ValueData, '') = ''
                      THEN '01.10.2024'

                 WHEN (CURRENT_DATE >= '01.03.2021' /*OR vbUserId = 5*/)
                  AND COALESCE (MovementString_InvNumberRegistered.ValueData, '') = ''
                  AND COALESCE (MovementString_InvNumberRegistered_tax.ValueData, '') = ''
                      THEN Movement_TaxCorrective.OperDate -- '01.03.2021'

                 WHEN MovementDate_DateRegistered.ValueData > Movement_TaxCorrective.OperDate
                      THEN MovementDate_DateRegistered.ValueData

                 WHEN MovementDate_DateRegistered_tax.ValueData > Movement_TaxCorrective.OperDate AND MovementString_InvNumberRegistered_tax.ValueData <> ''
                      THEN MovementDate_DateRegistered_tax.ValueData

                 ELSE Movement_TaxCorrective.OperDate

            END AS OperDate_begin

          , COALESCE (ObjectBoolean_isLongUKTZED.ValueData, TRUE)    AS isLongUKTZED
            -- вид налоговой
          , MLO_DocumentTaxKind_tax.ObjectId  AS DocumentTaxKindId_tax
            -- вид корректировки
          , MovementLinkObject_DocumentTaxKind.ObjectId  AS DocumentTaxKindId
          -- налоговая
          , MovementLinkMovement_Child.MovementChildId AS MovementId_tax

          , CASE WHEN (MovementDate_DateRegistered_tax.ValueData > Movement_TaxCorrective.OperDate OR MovementDate_DateRegistered_tax.ValueData > '01.07.2023')
                  AND MovementString_InvNumberRegistered_tax.ValueData <> ''
                      -- AND 1=0
                      THEN MovementDate_DateRegistered_tax.ValueData
                 ELSE Movement_Tax.OperDate
            END AS OperDate_Tax

          , Movement_Tax.OperDate AS OperDate_Tax_Tax

          , CASE WHEN MovementBoolean_isUKTZ_new.ValueData = TRUE
                      THEN CURRENT_DATE + INTERVAL '3 MONTH'
                 ELSE Movement_Tax.OperDate
            END AS OperDate_Tax_Tax_Tax

            INTO vbMovementId_TaxCorrective, vbStatusId_TaxCorrective, vbOperDate_begin, vbIsLongUKTZED, vbDocumentTaxKindId_tax, vbDocumentTaxKindId
               , vbMovementId_tax, vbOperDate_Tax, vbOperDate_Tax_Tax, vbOperDate_Tax_Tax_Tax

     FROM (SELECT CASE WHEN Movement.DescId = zc_Movement_TaxCorrective()
                            THEN inMovementId
                       ELSE MovementLinkMovement_Master.MovementChildId
                  END AS MovementId_TaxCorrective
           FROM Movement
                LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Master
                                               ON MovementLinkMovement_Master.MovementChildId = Movement.Id
                                              AND MovementLinkMovement_Master.DescId = zc_MovementLinkMovement_Master()
           WHERE Movement.Id = inMovementId
          ) AS tmpMovement
          INNER JOIN Movement AS Movement_TaxCorrective ON Movement_TaxCorrective.Id = tmpMovement.MovementId_TaxCorrective
                                                       AND (Movement_TaxCorrective.StatusId = zc_Enum_Status_Complete() OR tmpMovement.MovementId_TaxCorrective = inMovementId)
          LEFT JOIN MovementLinkObject AS MovementLinkObject_DocumentTaxKind
                                       ON MovementLinkObject_DocumentTaxKind.MovementId = tmpMovement.MovementId_TaxCorrective
                                      AND MovementLinkObject_DocumentTaxKind.DescId     = zc_MovementLinkObject_DocumentTaxKind()
          LEFT JOIN MovementDate AS MovementDate_DateRegistered
                                 ON MovementDate_DateRegistered.MovementId = tmpMovement.MovementId_TaxCorrective
                                AND MovementDate_DateRegistered.DescId = zc_MovementDate_DateRegistered()
          LEFT JOIN MovementString AS MovementString_InvNumberRegistered
                                   ON MovementString_InvNumberRegistered.MovementId = tmpMovement.MovementId_TaxCorrective
                                  AND MovementString_InvNumberRegistered.DescId = zc_MovementString_InvNumberRegistered()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = tmpMovement.MovementId_TaxCorrective
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN ObjectBoolean AS ObjectBoolean_isLongUKTZED
                                  ON ObjectBoolean_isLongUKTZED.ObjectId = MovementLinkObject_From.ObjectId
                                 AND ObjectBoolean_isLongUKTZED.DescId = zc_ObjectBoolean_Juridical_isLongUKTZED()
          LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Child
                                         ON MovementLinkMovement_Child.MovementId = tmpMovement.MovementId_TaxCorrective
                                        AND MovementLinkMovement_Child.DescId     = zc_MovementLinkMovement_Child()
          LEFT JOIN Movement AS Movement_Tax ON Movement_Tax.Id = MovementLinkMovement_Child.MovementChildId

          LEFT JOIN MovementBoolean AS MovementBoolean_isUKTZ_new
                                    ON MovementBoolean_isUKTZ_new.MovementId = Movement_Tax.Id
                                   AND MovementBoolean_isUKTZ_new.DescId     = zc_MovementBoolean_UKTZ_new()

          LEFT JOIN MovementLinkObject AS MLO_DocumentTaxKind_tax
                                       ON MLO_DocumentTaxKind_tax.MovementId = MovementLinkMovement_Child.MovementChildId
                                      AND MLO_DocumentTaxKind_tax.DescId     = zc_MovementLinkObject_DocumentTaxKind()
          LEFT JOIN MovementDate AS MovementDate_DateRegistered_tax
                                 ON MovementDate_DateRegistered_tax.MovementId = MovementLinkMovement_Child.MovementChildId
                                AND MovementDate_DateRegistered_tax.DescId = zc_MovementDate_DateRegistered()
          LEFT JOIN MovementString AS MovementString_InvNumberRegistered_tax
                                   ON MovementString_InvNumberRegistered_tax.MovementId = MovementLinkMovement_Child.MovementChildId
                                  AND MovementString_InvNumberRegistered_tax.DescId = zc_MovementString_InvNumberRegistered()
     ;
     
--  IF vbUserId = 5 THEN RAISE EXCEPTION 'Ошибка.<%>  <%>', vbOperDate_Tax, vbOperDate_begin; end if;

/* пока убрал, т.к. проверка сумм происходит в непроведенном состоянии, надо или добавить параметр - "когда ругаться" или сделать еще одну печать-проверку
     -- очень важная проверка
     IF COALESCE (vbMovementId_TaxCorrective, 0) = 0 OR COALESCE (vbStatusId_TaxCorrective, 0) <> zc_Enum_Status_Complete()
     THEN
         IF COALESCE (vbMovementId_TaxCorrective, 0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Документ <%> не создан.', (SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_TaxCorrective());
         END IF;
         IF vbStatusId_TaxCorrective = zc_Enum_Status_Erased()
         THEN
             RAISE EXCEPTION 'Ошибка.Документ <%> № <%> от <%> удален.', (SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_TaxCorrective()), (SELECT ValueData FROM MovementString WHERE MovementId = vbMovementId_TaxCorrective AND DescId = zc_MovementString_InvNumberPartner()), (SELECT DATE (OperDate) FROM Movement WHERE Id = vbMovementId_TaxCorrective);
         END IF;
         IF vbStatusId_TaxCorrective = zc_Enum_Status_UnComplete()
         THEN
             RAISE EXCEPTION 'Ошибка.Документ <%> № <%> от <%> не проведен.', (SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_TaxCorrective()), (SELECT ValueData FROM MovementString WHERE MovementId = vbMovementId_TaxCorrective AND DescId = zc_MovementString_InvNumberPartner()), (SELECT DATE (OperDate) FROM Movement WHERE Id = vbMovementId_TaxCorrective);
         END IF;
         -- это уже странная ошибка
         RAISE EXCEPTION 'Ошибка.Документ <%>.', (SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_TaxCorrective());
     END IF;
*/

     -- определяется параметр
     vbGoodsPropertyId:= (SELECT zfCalc_GoodsPropertyId (MovementLinkObject_Contract.ObjectId, COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MovementLinkObject_From.ObjectId), 0) -- ObjectLink_Juridical_GoodsProperty.ChildObjectId
                          FROM Movement
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                            ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                           AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                            ON MovementLinkObject_From.MovementId = Movement.Id
                                                           AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                               LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                    ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                                                   AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                               /*LEFT JOIN ObjectLink AS ObjectLink_Juridical_GoodsProperty
                                                    ON ObjectLink_Juridical_GoodsProperty.ObjectId = COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MovementLinkObject_From.ObjectId)
                                                   AND ObjectLink_Juridical_GoodsProperty.DescId = zc_ObjectLink_Juridical_GoodsProperty()*/
                          WHERE Movement.Id = inMovementId
                         );
     -- определяется параметр
     vbGoodsPropertyId_basis:= zfCalc_GoodsPropertyId (0, zc_Juridical_Basis(), 0); -- (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = zc_Juridical_Basis() AND DescId = zc_ObjectLink_Juridical_GoodsProperty());


     -- Данные по Всем корректировкам + налоговым: заголовок + строчная часть
   --CREATE TEMP TABLE tmpCursor1 ON COMMIT DROP AS
     OPEN Cursor1 FOR
     WITH tmpMovement AS
          (SELECT Movement_find.Id
                , MovementBoolean_isPartner.ValueData AS isPartner
           FROM Movement
                -- нашли док-нт Возврат
                LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Master
                                               ON MovementLinkMovement_Master.MovementId = Movement.Id
                                              AND MovementLinkMovement_Master.DescId = zc_MovementLinkMovement_Master()
                -- печатаем всегда все корректировки для док-нта Возврат
                LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Master_find
                                               ON MovementLinkMovement_Master_find.MovementChildId = MovementLinkMovement_Master.MovementChildId
                                              AND MovementLinkMovement_Master_find.DescId = zc_MovementLinkMovement_Master()
                -- корректировка - для "сводных" она одна
                INNER JOIN Movement AS Movement_find ON Movement_find.Id       = COALESCE (MovementLinkMovement_Master_find.MovementId, Movement.Id)
                                                    AND (Movement_find.StatusId = zc_Enum_Status_Complete() OR Movement_find.Id = inMovementId)
                LEFT JOIN MovementBoolean AS MovementBoolean_isPartner
                                          ON MovementBoolean_isPartner.MovementId = MovementLinkMovement_Master.MovementChildId
                                         AND MovementBoolean_isPartner.DescId    = zc_MovementBoolean_isPartner()

           WHERE Movement.Id       = inMovementId
             AND Movement.DescId   = zc_Movement_TaxCorrective()
             AND Movement_find.Id  = inMovementId
          -- AND (Movement_find.Id = inMovementId OR inSession <> '5')
          UNION
           SELECT MovementLinkMovement_Master.MovementId AS Id
                , MovementBoolean_isPartner.ValueData    AS isPartner
           FROM Movement
                -- нашли док-нты Корректировки
                INNER JOIN MovementLinkMovement AS MovementLinkMovement_Master
                                                ON MovementLinkMovement_Master.MovementChildId = Movement.Id
                                               AND MovementLinkMovement_Master.DescId = zc_MovementLinkMovement_Master()
                -- корректировки
                INNER JOIN Movement AS Movement_Master ON Movement_Master.Id       = MovementLinkMovement_Master.MovementId
                                                      AND Movement_Master.StatusId = zc_Enum_Status_Complete()
                LEFT JOIN MovementBoolean AS MovementBoolean_isPartner
                                          ON MovementBoolean_isPartner.MovementId = Movement.Id
                                         AND MovementBoolean_isPartner.DescId     = zc_MovementBoolean_isPartner()

           WHERE Movement.Id     = inMovementId
             AND Movement.DescId IN (zc_Movement_ReturnIn(), zc_Movement_TransferDebtIn(), zc_Movement_PriceCorrective())
          )

    , tmpMI_All AS
       (SELECT MovementItem.Id                        AS Id
             , MovementItem.MovementId                AS MovementId
             , Movement.InvNumber	              AS InvNumber
             , Movement.OperDate	              AS OperDate
             , MovementItem.ObjectId                  AS GoodsId
             , MovementItem.Amount                    AS Amount
             , COALESCE (MIBoolean_isAuto.ValueData, TRUE)   AS isAuto
             , ObjectLink_GoodsGroup.ChildObjectId    AS GoodsGroupId
             , tmpMovement.isPartner
        FROM tmpMovement
             LEFT JOIN Movement ON Movement.Id = tmpMovement.Id

             INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovement.Id
                                    AND MovementItem.DescId     = zc_MI_Master()
                                    AND MovementItem.isErased   = FALSE
                                    AND MovementItem.Amount     <> 0

             LEFT JOIN MovementItemBoolean AS MIBoolean_isAuto
                                           ON MIBoolean_isAuto.MovementItemId = MovementItem.Id
                                          AND MIBoolean_isAuto.DescId = zc_MIBoolean_isAuto()

             LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup
                                  ON ObjectLink_GoodsGroup.ObjectId = MovementItem.ObjectId
                                 AND ObjectLink_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
        )
    , tmpMIFloat AS (SELECT MovementItemFloat.*
                     FROM MovementItemFloat
                     WHERE MovementItemFloat.MovementItemId IN (SELECT tmpMI_All.Id FROM tmpMI_All)
                     )
    , tmpGoodsKind AS (SELECT MovementItemLinkObject.*
                       FROM MovementItemLinkObject
                       WHERE MovementItemLinkObject.MovementItemId IN (SELECT tmpMI_All.Id FROM tmpMI_All)
                         AND MovementItemLinkObject.DescId = zc_MILinkObject_GoodsKind()
                       )

    , tmpMI AS
       (SELECT tmpMI_All.Id                           AS Id
             , tmpMI_All.MovementId                   AS MovementId
             , tmpMI_All.InvNumber	              AS InvNumber
             , tmpMI_All.OperDate	              AS OperDate
             , tmpMI_All.GoodsId                      AS GoodsId
             , tmpMI_All.Amount                       AS Amount
             , CASE WHEN vbDocumentTaxKindId IN (zc_Enum_DocumentTaxKind_CorrectivePrice()
                                               , zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
                                               , zc_Enum_DocumentTaxKind_ChangePercent()
                                                )
                     AND vbDocumentTaxKindId_tax IN (zc_Enum_DocumentTaxKind_TaxSummaryJuridicalS()
                                                   , zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR()
                                                   , zc_Enum_DocumentTaxKind_TaxSummaryPartnerS()
                                                   , zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR()
                                                    )
                         THEN MIFloat_Price.ValueData -- COALESCE (MIFloat_PriceTax_calc.ValueData, MIFloat_Price.ValueData)
                    ELSE MIFloat_Price.ValueData
               END AS Price
             , MIFloat_CountForPrice.ValueData        AS CountForPrice
             , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
             , Object_GoodsKind.ValueData             AS GoodsKindName
             , tmpMI_All.isAuto                       AS isAuto
             , COALESCE (MIFloat_NPP.ValueData, 0)    AS NPP
             , tmpMI_All.GoodsGroupId                 AS GoodsGroupId
             , tmpMI_All.isPartner                    AS isPartner

             , COALESCE (MIFloat_NPPTax_calc.ValueData, 0)      AS NPPTax_calc
             , COALESCE (MIFloat_NPP_calc.ValueData, 0)         AS NPP_calc
             , COALESCE (MIFloat_NPPTaxNew_calc.ValueData, 0)   AS NPPTaxNew_calc

             , COALESCE (MIFloat_AmountTax_calc.ValueData, 0)   AS AmountTax_calc
             , COALESCE (MIFloat_SummTaxDiff_calc.ValueData, 0) AS SummTaxDiff_calc
             , COALESCE (MIFloat_PriceTax_calc.ValueData, 0)    AS PriceTax_calc

        FROM tmpMI_All
            LEFT JOIN tmpMIFloat AS MIFloat_NPP
                                 ON MIFloat_NPP.MovementItemId = tmpMI_All.Id
                                AND MIFloat_NPP.DescId = zc_MIFloat_NPP()
            LEFT JOIN tmpMIFloat AS MIFloat_Price
                                 ON MIFloat_Price.MovementItemId = tmpMI_All.Id
                                AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                -- AND MIFloat_Price.ValueData <> 0
            LEFT JOIN tmpMIFloat AS MIFloat_CountForPrice
                                 ON MIFloat_CountForPrice.MovementItemId = tmpMI_All.Id
                                AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

            LEFT JOIN tmpMIFloat AS MIFloat_NPPTax_calc
                                 ON MIFloat_NPPTax_calc.MovementItemId = tmpMI_All.Id
                                AND MIFloat_NPPTax_calc.DescId         = zc_MIFloat_NPPTax_calc()
            LEFT JOIN tmpMIFloat AS MIFloat_NPP_calc
                                 ON MIFloat_NPP_calc.MovementItemId = tmpMI_All.Id
                                AND MIFloat_NPP_calc.DescId         = zc_MIFloat_NPP_calc()
            LEFT JOIN tmpMIFloat AS MIFloat_NPPTaxNew_calc
                                 ON MIFloat_NPPTaxNew_calc.MovementItemId = tmpMI_All.Id
                                AND MIFloat_NPPTaxNew_calc.DescId         = zc_MIFloat_NPPTaxNew_calc()
            LEFT JOIN tmpMIFloat AS MIFloat_AmountTax_calc
                                 ON MIFloat_AmountTax_calc.MovementItemId = tmpMI_All.Id
                                AND MIFloat_AmountTax_calc.DescId         = zc_MIFloat_AmountTax_calc()
            LEFT JOIN tmpMIFloat AS MIFloat_SummTaxDiff_calc
                                 ON MIFloat_SummTaxDiff_calc.MovementItemId = tmpMI_All.Id
                                AND MIFloat_SummTaxDiff_calc.DescId         = zc_MIFloat_SummTaxDiff_calc()
            LEFT JOIN tmpMIFloat AS MIFloat_PriceTax_calc
                                 ON MIFloat_PriceTax_calc.MovementItemId = tmpMI_All.Id
                                AND MIFloat_PriceTax_calc.DescId         = zc_MIFloat_PriceTax_calc()

            LEFT JOIN tmpGoodsKind AS MILinkObject_GoodsKind
                                   ON MILinkObject_GoodsKind.MovementItemId = tmpMI_All.Id
                                  AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId
                                                AND Object_GoodsKind.DescId = zc_Object_GoodsKind()
        )

      -- данные из налоговой свойство zc_MIBoolean_Goods_Name_new
    , tmpName_new AS (SELECT DISTINCT
                             MovementItem.ObjectId           AS GoodsId
                           --, MILinkObject_GoodsKind.ObjectId AS GoodsKindId
                           , TRUE AS isName_new
                      FROM MovementItem
                           INNER JOIN MovementItemBoolean AS MIBoolean_Goods_Name_new
                                                          ON MIBoolean_Goods_Name_new.MovementItemId = MovementItem.Id
                                                         AND MIBoolean_Goods_Name_new.DescId = zc_MIBoolean_Goods_Name_new()
                                                         AND COALESCE (MIBoolean_Goods_Name_new.ValueData, FALSE) = TRUE
                           /*LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                            ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()*/
                      WHERE MovementItem.MovementId = vbMovementId_tax
                        AND MovementItem.DescId     = zc_MI_Master()
                        AND MovementItem.isErased   = FALSE
                      )

    , tmpGoods AS (SELECT tmp.GoodsId                              AS GoodsId
                        , Object_Goods.ObjectCode                  AS GoodsCode
                        --, CASE WHEN ObjectString_Goods_BUH.ValueData <> '' THEN ObjectString_Goods_BUH.ValueData ELSE Object_Goods.ValueData END :: TVarChar AS GoodsName
                        , CASE WHEN ObjectString_Goods_BUH.ValueData <> '' AND vbOperDate_Tax >= ObjectDate_BUH.ValueData THEN Object_Goods.ValueData
                               WHEN COALESCE (tmpName_new.isName_new, FALSE) = TRUE THEN Object_Goods.ValueData
                               WHEN ObjectString_Goods_BUH.ValueData <> ''          THEN ObjectString_Goods_BUH.ValueData
                               ELSE Object_Goods.ValueData
                          END :: TVarChar AS GoodsName
                        , ObjectString_Goods_RUS.ValueData         AS GoodsName_RUS

                        , CASE -- на дату у товара
                               WHEN ObjectString_Goods_UKTZED_new.ValueData <> '' AND ObjectDate_Goods_UKTZED_new.ValueData <= vbOperDate_Tax_Tax_Tax
                                    THEN ObjectString_Goods_UKTZED_new.ValueData
                               -- у товара
                               WHEN ObjectString_Goods_UKTZED.ValueData <> ''
                                    THEN ObjectString_Goods_UKTZED.ValueData

                               WHEN ObjectString_Goods_UKTZED_new.ValueData <> ''
                                    THEN ObjectString_Goods_UKTZED_new.ValueData

                          END AS Goods_UKTZED

                        , ObjectString_Goods_TaxImport.ValueData   AS Goods_TaxImport
                        , ObjectString_Goods_DKPP.ValueData        AS Goods_DKPP
                        , ObjectString_Goods_TaxAction.ValueData   AS Goods_TaxAction
                        , Object_Measure.Id                        AS MeasureId
                        , Object_Measure.ObjectCode                AS MeasureCode
                        , Object_Measure.ValueData                 AS MeasureName
                        , ObjectLink_Goods_InfoMoney.ChildObjectId AS InfoMoneyId
                   FROM (SELECT DISTINCT tmpMI.GoodsId FROM tmpMI
                       ) AS tmp
                        LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmp.GoodsId
                        LEFT JOIN ObjectString AS ObjectString_Goods_BUH
                                               ON ObjectString_Goods_BUH.ObjectId = tmp.GoodsId
                                              AND ObjectString_Goods_BUH.DescId = zc_ObjectString_Goods_BUH()  
                        LEFT JOIN ObjectDate AS ObjectDate_BUH
                                             ON ObjectDate_BUH.ObjectId = tmp.GoodsId
                                            AND ObjectDate_BUH.DescId = zc_ObjectDate_Goods_BUH()

                        LEFT JOIN ObjectString AS ObjectString_Goods_UKTZED
                                               ON ObjectString_Goods_UKTZED.ObjectId = tmp.GoodsId
                                              AND ObjectString_Goods_UKTZED.DescId = zc_ObjectString_Goods_UKTZED()
                        LEFT JOIN ObjectString AS ObjectString_Goods_UKTZED_new
                                               ON ObjectString_Goods_UKTZED_new.ObjectId = tmp.GoodsId
                                              AND ObjectString_Goods_UKTZED_new.DescId = zc_ObjectString_Goods_UKTZED_new()
                        LEFT JOIN ObjectDate AS ObjectDate_Goods_UKTZED_new
                                             ON ObjectDate_Goods_UKTZED_new.ObjectId = tmp.GoodsId
                                            AND ObjectDate_Goods_UKTZED_new.DescId = zc_ObjectDate_Goods_UKTZED_new()

                        LEFT JOIN ObjectString AS ObjectString_Goods_TaxImport
                                               ON ObjectString_Goods_TaxImport.ObjectId = tmp.GoodsId
                                              AND ObjectString_Goods_TaxImport.DescId = zc_ObjectString_Goods_TaxImport()
                        LEFT JOIN ObjectString AS ObjectString_Goods_DKPP
                                               ON ObjectString_Goods_DKPP.ObjectId = tmp.GoodsId
                                              AND ObjectString_Goods_DKPP.DescId = zc_ObjectString_Goods_DKPP()
                        LEFT JOIN ObjectString AS ObjectString_Goods_TaxAction
                                               ON ObjectString_Goods_TaxAction.ObjectId = tmp.GoodsId
                                              AND ObjectString_Goods_TaxAction.DescId = zc_ObjectString_Goods_TaxAction()
                        LEFT JOIN ObjectString AS ObjectString_Goods_RUS
                                               ON ObjectString_Goods_RUS.ObjectId = tmp.GoodsId
                                              AND ObjectString_Goods_RUS.DescId = zc_ObjectString_Goods_RUS()
                        LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                             ON ObjectLink_Goods_Measure.ObjectId = tmp.GoodsId
                                            AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                        LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = COALESCE (ObjectLink_Goods_Measure.ChildObjectId, zc_Measure_Sh())

                        LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                             ON ObjectLink_Goods_InfoMoney.ObjectId = tmp.GoodsId
                                            AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()

                        LEFT JOIN tmpName_new ON tmpName_new.GoodsId = Object_Goods.Id
                                             --AND COALESCE (tmpName_new.GoodsKindId,0) = COALESCE (Object_GoodsKind.Id,0)
                   )

    , tmpUKTZED    AS (SELECT tmp.GoodsGroupId, lfGet_Object_GoodsGroup_CodeUKTZED_onDate (tmp.GoodsGroupId, vbOperDate_Tax_Tax_Tax) AS CodeUKTZED
                       FROM (SELECT DISTINCT tmpMI.GoodsGroupId FROM tmpMI) AS tmp
                      )

    , tmpTaxImport AS (SELECT tmp.GoodsGroupId, lfGet_Object_GoodsGroup_TaxImport (tmp.GoodsGroupId) AS TaxImport FROM (SELECT DISTINCT tmpMI.GoodsGroupId FROM tmpMI) AS tmp)
    , tmpDKPP      AS (SELECT tmp.GoodsGroupId, lfGet_Object_GoodsGroup_DKPP (tmp.GoodsGroupId) AS DKPP FROM (SELECT DISTINCT tmpMI.GoodsGroupId FROM tmpMI) AS tmp)
    , tmpTaxAction AS (SELECT tmp.GoodsGroupId, lfGet_Object_GoodsGroup_TaxAction (tmp.GoodsGroupId) AS TaxAction FROM (SELECT DISTINCT tmpMI.GoodsGroupId FROM tmpMI) AS tmp)

    , tmpObject_GoodsPropertyValue AS
       (SELECT ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId                 AS ObjectId
             , ObjectLink_GoodsPropertyValue_Goods.ChildObjectId                    AS GoodsId
             , COALESCE (ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId, 0)  AS GoodsKindId
             , Object_GoodsPropertyValue.ValueData                                  AS Name
             , ObjectString_BarCode.ValueData                                       AS BarCode
             , ObjectString_Article.ValueData                                       AS Article
             , ObjectString_BarCodeGLN.ValueData                                    AS BarCodeGLN
             , ObjectString_ArticleGLN.ValueData                                    AS ArticleGLN
        FROM (SELECT vbGoodsPropertyId AS GoodsPropertyId WHERE vbGoodsPropertyId <> 0
             ) AS tmpGoodsProperty
             INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                   ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = tmpGoodsProperty.GoodsPropertyId
                                  AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()

             INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                   ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                  AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
             INNER JOIN tmpGoods ON tmpGoods.GoodsId = ObjectLink_GoodsPropertyValue_Goods.ChildObjectId

             LEFT JOIN Object AS Object_GoodsPropertyValue
                              ON Object_GoodsPropertyValue.Id = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                             AND Object_GoodsPropertyValue.ValueData  <> ''

             LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                  ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                 AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()

             LEFT JOIN ObjectString AS ObjectString_BarCode
                                    ON ObjectString_BarCode.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                   AND ObjectString_BarCode.DescId = zc_ObjectString_GoodsPropertyValue_BarCode()
                                   AND ObjectString_BarCode.ValueData       <> ''
             LEFT JOIN ObjectString AS ObjectString_Article
                                    ON ObjectString_Article.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                   AND ObjectString_Article.DescId = zc_ObjectString_GoodsPropertyValue_Article()
                                   AND ObjectString_Article.ValueData       <> ''

             LEFT JOIN ObjectString AS ObjectString_BarCodeGLN
                                    ON ObjectString_BarCodeGLN.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                   AND ObjectString_BarCodeGLN.DescId = zc_ObjectString_GoodsPropertyValue_BarCodeGLN()
                                   AND ObjectString_BarCodeGLN.ValueData    <> ''
             LEFT JOIN ObjectString AS ObjectString_ArticleGLN
                                    ON ObjectString_ArticleGLN.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                   AND ObjectString_ArticleGLN.DescId = zc_ObjectString_GoodsPropertyValue_ArticleGLN()
                                   AND ObjectString_ArticleGLN.ValueData    <> ''

        WHERE Object_GoodsPropertyValue.ValueData  <> ''
           OR ObjectString_BarCode.ValueData       <> ''
           OR ObjectString_Article.ValueData       <> ''
           OR ObjectString_BarCodeGLN.ValueData    <> ''
           OR ObjectString_ArticleGLN.ValueData    <> ''
       )
    , tmpObject_GoodsPropertyValueGroup AS
       (SELECT tmpObject_GoodsPropertyValue.GoodsId
             , tmpObject_GoodsPropertyValue.Article
             , tmpObject_GoodsPropertyValue.ArticleGLN
             , tmpObject_GoodsPropertyValue.Name
        FROM (SELECT MAX (tmpObject_GoodsPropertyValue.ObjectId) AS ObjectId, GoodsId FROM tmpObject_GoodsPropertyValue WHERE Article <> '' OR ArticleGLN <> '' OR Name <> '' GROUP BY GoodsId
             ) AS tmpGoodsProperty_find
             LEFT JOIN tmpObject_GoodsPropertyValue ON tmpObject_GoodsPropertyValue.ObjectId =  tmpGoodsProperty_find.ObjectId
       )
    , tmpObject_GoodsPropertyValue_basis AS
       (SELECT ObjectLink_GoodsPropertyValue_Goods.ObjectId      AS ObjectId
             , ObjectLink_GoodsPropertyValue_Goods.ChildObjectId AS GoodsId
             , COALESCE (ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId, 0) AS GoodsKindId
             , Object_GoodsPropertyValue.ValueData  AS Name
        FROM (SELECT vbGoodsPropertyId_basis AS GoodsPropertyId
             ) AS tmpGoodsProperty
             INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                   ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = tmpGoodsProperty.GoodsPropertyId
                                  AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
             INNER JOIN Object AS Object_GoodsPropertyValue ON Object_GoodsPropertyValue.Id = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                           AND Object_GoodsPropertyValue.ValueData <> ''
             INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                   ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                  AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
             INNER JOIN tmpGoods ON tmpGoods.GoodsId = ObjectLink_GoodsPropertyValue_Goods.ChildObjectId
             LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                  ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                 AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
       )
     , tmpObject_GoodsPropertyValueGroup_basis AS
       (SELECT tmpObject_GoodsPropertyValue.GoodsId
             , tmpObject_GoodsPropertyValue.Name
        FROM (SELECT MAX (tmpObject_GoodsPropertyValue.ObjectId) AS ObjectId, GoodsId FROM tmpObject_GoodsPropertyValue_basis AS tmpObject_GoodsPropertyValue WHERE Name <> '' GROUP BY GoodsId
             ) AS tmpGoodsProperty_find
             LEFT JOIN tmpObject_GoodsPropertyValue_basis AS tmpObject_GoodsPropertyValue ON tmpObject_GoodsPropertyValue.ObjectId =  tmpGoodsProperty_find.ObjectId
       )
    , tmpMITax AS (SELECT * FROM lpSelect_TaxFromTaxCorrective ((SELECT MLM.MovementChildId FROM MovementLinkMovement AS MLM WHERE MLM.MovementId = inMovementId AND MLM.DescId = zc_MovementLinkMovement_Child())))

         -- Сотрудник (бухгалтер) подписант
       , tmpBranch_PersonalBookkeeper AS (SELECT Object_PersonalBookkeeper_View.MemberId
                                               , MAX (ObjectString_PersonalBookkeeper.ValueData) AS PersonalBookkeeperName
                                          FROM Object AS Object_Branch
                                               -- Сотрудник (бухгалтер)
                                               LEFT JOIN ObjectLink AS ObjectLink_Branch_PersonalBookkeeper
                                                                    ON ObjectLink_Branch_PersonalBookkeeper.ObjectId = Object_Branch.Id
                                                                   AND ObjectLink_Branch_PersonalBookkeeper.DescId = zc_ObjectLink_Branch_PersonalBookkeeper()
                                               LEFT JOIN Object_Personal_View AS Object_PersonalBookkeeper_View ON Object_PersonalBookkeeper_View.PersonalId = ObjectLink_Branch_PersonalBookkeeper.ChildObjectId                     
                                               -- Сотрудник (бухгалтер) подписант
                                               INNER JOIN ObjectString AS ObjectString_PersonalBookkeeper
                                                                       ON ObjectString_PersonalBookkeeper.ObjectId = Object_Branch.Id
                                                                      AND ObjectString_PersonalBookkeeper.DescId   = zc_objectString_Branch_PersonalBookkeeper()
                                                                      AND ObjectString_PersonalBookkeeper.ValueData <> ''
                                          WHERE Object_Branch.DescId   = zc_Object_Branch()
                                            AND Object_Branch.isErased = FALSE
                                          GROUP BY Object_PersonalBookkeeper_View.MemberId
                                         )
      -- Сотрудник подписант - филиал
    , tmpPersonalBookkeeper AS (SELECT ObjectLink_Branch_PersonalBookkeeper.ObjectId AS BranchId
                                     , Object_PersonalBookkeeper_View.MemberId
                                     , PersonalBookkeeper_INN.ValueData AS PersonalBookkeeper_INN
                                     , COALESCE (ObjectString_PersonalBookkeeper.ValueData, zfConvert_FIO (Object_PersonalBookkeeper_View.PersonalName, 1, TRUE)) AS PersonalName
                                -- Сотрудник (бухгалтер) - филиал
                                FROM ObjectLink AS ObjectLink_Branch_PersonalBookkeeper
                                     LEFT JOIN Object_Personal_View AS Object_PersonalBookkeeper_View ON Object_PersonalBookkeeper_View.PersonalId = ObjectLink_Branch_PersonalBookkeeper.ChildObjectId
                                     LEFT JOIN ObjectString AS PersonalBookkeeper_INN
                                                            ON PersonalBookkeeper_INN.ObjectId = Object_PersonalBookkeeper_View.MemberId
                                                           AND PersonalBookkeeper_INN.DescId = zc_ObjectString_Member_INN()
                                    -- Сотрудник (бухгалтер) подписант - филиал
                                     LEFT JOIN ObjectString AS ObjectString_PersonalBookkeeper
                                                            ON ObjectString_PersonalBookkeeper.ObjectId  = ObjectLink_Branch_PersonalBookkeeper.ObjectId
                                                           AND ObjectString_PersonalBookkeeper.DescId    = zc_objectString_Branch_PersonalBookkeeper()
                                                           AND ObjectString_PersonalBookkeeper.ValueData <> ''
                                WHERE ObjectLink_Branch_PersonalBookkeeper.DescId = zc_ObjectLink_Branch_PersonalBookkeeper()
                                )

      -- Сотрудник подписант - договор
    , tmpPersonalSigning AS (SELECT ObjectLink_Contract_PersonalSigning.ObjectId AS ContractId
                                  , Object_PersonalSigning.MemberId
                                  , PersonalSigning_INN.ValueData AS PersonalSigning_INN
                                  , COALESCE (tmpBranch_PersonalBookkeeper.PersonalBookkeeperName, zfConvert_FIO (Object_PersonalSigning.PersonalName, 1, TRUE)) AS PersonalName
                             FROM ObjectLink AS ObjectLink_Contract_PersonalSigning
                                  LEFT JOIN Object_Personal_View AS Object_PersonalSigning ON Object_PersonalSigning.PersonalId = ObjectLink_Contract_PersonalSigning.ChildObjectId
                                  LEFT JOIN ObjectString AS PersonalSigning_INN
                                                         ON PersonalSigning_INN.ObjectId = Object_PersonalSigning.MemberId
                                                        AND PersonalSigning_INN.DescId = zc_ObjectString_Member_INN()
                                  -- Сотрудник подписант - замена
                                  LEFT JOIN tmpBranch_PersonalBookkeeper ON tmpBranch_PersonalBookkeeper.MemberId = Object_PersonalSigning.MemberId
                             WHERE ObjectLink_Contract_PersonalSigning.DescId = zc_ObjectLink_Contract_PersonalSigning()
                            )

    , tmpMovementFloat AS (SELECT MovementFloat.*
                           FROM MovementFloat
                           WHERE MovementFloat.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                          )
    , tmpReturnIn AS (SELECT Movement_ReturnIn.Id
                           , Movement_ReturnIn.InvNumber
                           , Movement_ReturnIn.OperDate
                           , MovementString_InvNumberMark.ValueData     AS InvNumberMark
                           , MovementDate_OperDatePartner.ValueData     AS OperDatePartner
                           , MovementString_InvNumberPartner.ValueData  AS InvNumberPartner
                      FROM Movement AS Movement_ReturnIn
                           LEFT JOIN MovementString AS MovementString_InvNumberMark
                                                    ON MovementString_InvNumberMark.MovementId = Movement_ReturnIn.Id
                                                   AND MovementString_InvNumberMark.DescId = zc_MovementString_InvNumberMark()

                           LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                                  ON MovementDate_OperDatePartner.MovementId = Movement_ReturnIn.Id
                                                 AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

                           LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                                    ON MovementString_InvNumberPartner.MovementId = Movement_ReturnIn.Id
                                                   AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
                      WHERE Movement_ReturnIn.Id = inMovementId
                     )
   , tmpMB_isCopy AS (SELECT MovementBoolean_isCopy.*
                      FROM MovementBoolean AS MovementBoolean_isCopy
                      WHERE MovementBoolean_isCopy.DescId = zc_MovementBoolean_isCopy()
                        AND MovementBoolean_isCopy.MovementId IN (SELECT tmpMovement.Id FROM tmpMovement)
                     )
   , tmpMB_PriceWithVAT AS (SELECT MovementBoolean_PriceWithVAT.*
                            FROM MovementBoolean AS MovementBoolean_PriceWithVAT
                            WHERE MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
                              AND MovementBoolean_PriceWithVAT.MovementId IN (SELECT tmpMovement.Id FROM tmpMovement)
                           )
   , tmpMovementString AS (SELECT MovementString.MovementId
                                , MovementString.DescId
                                , MovementString.ValueData
                           FROM tmpMovement
                              LEFT JOIN MovementString ON MovementString.MovementId = tmpMovement.Id
                                    AND MovementString.DescId IN (zc_MovementString_InvNumberBranch(), zc_MovementString_InvNumberPartner())
                           )
   , tmpMovement_ChildEDI AS (SELECT MovementLinkMovement_ChildEDI.MovementId      AS MovementId
                                   , MovementLinkMovement_ChildEDI.MovementChildId AS MovementChildId
                                   , MovementFloat_Amount.ValueData                AS Amount
                                   , MovementDate_OperDatePartnerEDI.ValueData     AS OperDatePartnerEDI
                                   , MovementString_InvNumberPartnerEDI.ValueData  AS InvNumberPartnerEDI
                              FROM MovementLinkMovement AS MovementLinkMovement_ChildEDI
                                   LEFT JOIN MovementFloat AS MovementFloat_Amount
                                                           ON MovementFloat_Amount.MovementId =  MovementLinkMovement_ChildEDI.MovementChildId
                                                          AND MovementFloat_Amount.DescId = zc_MovementFloat_Amount()

                                   LEFT JOIN MovementDate AS MovementDate_OperDatePartnerEDI
                                                          ON MovementDate_OperDatePartnerEDI.MovementId =  MovementLinkMovement_ChildEDI.MovementChildId
                                                         AND MovementDate_OperDatePartnerEDI.DescId = zc_MovementDate_OperDatePartner()

                                   LEFT JOIN MovementString AS MovementString_InvNumberPartnerEDI
                                                            ON MovementString_InvNumberPartnerEDI.MovementId = MovementLinkMovement_ChildEDI.MovementChildId
                                                           AND MovementString_InvNumberPartnerEDI.DescId = zc_MovementString_InvNumberPartner()
                              WHERE MovementLinkMovement_ChildEDI.DescId = zc_MovementLinkMovement_ChildEDI()
                                AND MovementLinkMovement_ChildEDI.MovementId IN (SELECT tmpMovement.Id FROM tmpMovement)
             )

, tmpContract AS (SELECT MovementLinkObject_Contract.MovementId
                       , Object_Contract.Id              AS ContractId
                       , Object_Contract.ValueData       AS ContractName
                       , Object_ContractKind.Id          AS ContractKindId
                       , Object_ContractKind.ValueData   AS ContractKindName
                       , ObjectDate_Signing.ValueData    AS ContractSigningDate
                       , COALESCE (ObjectString_PartnerCode.ValueData, '') :: TVarChar AS PartnerCode
                       , COALESCE (ObjectLink_Contract_InfoMoney.ChildObjectId, 0) AS InfoMoneyId             --уп.статья из договора
                  FROM MovementLinkObject AS MovementLinkObject_Contract
                       LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MovementLinkObject_Contract.ObjectId

                       LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractKind
                                            ON ObjectLink_Contract_ContractKind.ObjectId = MovementLinkObject_Contract.ObjectId
                                           AND ObjectLink_Contract_ContractKind.DescId = zc_ObjectLink_Contract_ContractKind()
                                           AND Object_Contract.ValueData <> '-'
                       LEFT JOIN Object AS Object_ContractKind ON Object_ContractKind.Id = ObjectLink_Contract_ContractKind.ChildObjectId

                       LEFT JOIN ObjectDate AS ObjectDate_Signing
                                            ON ObjectDate_Signing.ObjectId = MovementLinkObject_Contract.ObjectId
                                           AND ObjectDate_Signing.DescId = zc_ObjectDate_Contract_Signing()
                                           AND Object_Contract.ValueData <> '-'
                       -- код поставщика
                       LEFT JOIN ObjectString AS ObjectString_PartnerCode
                                              ON ObjectString_PartnerCode.ObjectId = MovementLinkObject_Contract.ObjectId
                                             AND ObjectString_PartnerCode.DescId = zc_objectString_Contract_PartnerCode()

                       LEFT JOIN ObjectLink AS ObjectLink_Contract_InfoMoney
                                            ON ObjectLink_Contract_InfoMoney.ObjectId = MovementLinkObject_Contract.ObjectId
                                           AND ObjectLink_Contract_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()

                  WHERE MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                    AND MovementLinkObject_Contract.MovementId IN (SELECT tmpMovement.Id FROM tmpMovement)
                 )

 , tmpMLM_Child AS (SELECT MovementLinkMovement_Child.MovementId          AS MovementId
                        , Movement_child.OperDate                        AS OperDate_Child
                        , Movement_child.Id                              AS MovementId_Child
                        , MovementString_InvNumberBranch_Child.ValueData AS InvNumberBranch_Child
                        , MS_DocumentChild_InvNumberPartner.ValueData    AS InvNumberPartner_Child
                        , Movement_Sale.InvNumber                        AS InvNumber_Sale
                        , MovementString_InvNumberPartner_Sale.ValueData AS InvNumberPartner_Sale
                        , MovementString_InvNumberOrder_Sale.ValueData   AS InvNumberOrder_Sale
                        , MovementDate_OperDatePartner_Sale.ValueData    AS OperDatePartner_Sale
                        , CASE WHEN MovementDate_DateRegistered_Child.ValueData         > Movement_child.OperDate
                             -- AND MovementString_InvNumberRegistered_Child.ValueData <> ''
                                    THEN MovementDate_DateRegistered_Child.ValueData
                               ELSE Movement_child.OperDate
                          END AS OperDate_begin_Child
                        , CASE WHEN MovementString_InvNumberRegistered_Child.ValueData <> ''
                                    THEN COALESCE (MovementDate_DateRegistered_Child.ValueData, Movement_child.OperDate)
                               ELSE CURRENT_DATE
                          END AS OperDate_rus

                   FROM tmpMovement
                        INNER JOIN MovementLinkMovement AS MovementLinkMovement_Child
                                                        ON MovementLinkMovement_Child.MovementId = tmpMovement.Id
                                                       AND MovementLinkMovement_Child.DescId = zc_MovementLinkMovement_Child()
                        INNER JOIN Movement AS Movement_child
                                            ON Movement_child.Id = MovementLinkMovement_Child.MovementChildId
                                           AND (Movement_child.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Complete())
                                             OR vbDocumentTaxKindId = zc_Enum_DocumentTaxKind_Prepay()
                                               )

                        LEFT JOIN MovementDate AS MovementDate_DateRegistered_Child
                                               ON MovementDate_DateRegistered_Child.MovementId = Movement_child.Id
                                              AND MovementDate_DateRegistered_Child.DescId     = zc_MovementDate_DateRegistered()
                        LEFT JOIN MovementString AS MovementString_InvNumberRegistered_Child
                                                 ON MovementString_InvNumberRegistered_Child.MovementId = Movement_child.Id
                                                AND MovementString_InvNumberRegistered_Child.DescId     = zc_MovementString_InvNumberRegistered()

                        LEFT JOIN MovementString AS MovementString_InvNumberBranch_Child
                                                 ON MovementString_InvNumberBranch_Child.MovementId = Movement_child.Id
                                                AND MovementString_InvNumberBranch_Child.DescId = zc_MovementString_InvNumberBranch()

                        LEFT JOIN MovementString AS MS_DocumentChild_InvNumberPartner
                                                 ON MS_DocumentChild_InvNumberPartner.MovementId = Movement_child.Id
                                                AND MS_DocumentChild_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

                        LEFT JOIN MovementLinkObject AS MovementLinkObject_DocumentTaxKind_Child
                                                     ON MovementLinkObject_DocumentTaxKind_Child.MovementId = MovementLinkMovement_Child.MovementChildId
                                                    AND MovementLinkObject_DocumentTaxKind_Child.DescId = zc_MovementLinkObject_DocumentTaxKind()

                        LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Child_Sale
                                                       ON MovementLinkMovement_Child_Sale.MovementChildId = MovementLinkMovement_Child.MovementChildId
                                                      AND MovementLinkMovement_Child_Sale.DescId = zc_MovementLinkMovement_Master()
                                                      AND MovementLinkObject_DocumentTaxKind_Child.ObjectId = zc_Enum_DocumentTaxKind_Tax() -- налоговая

                        LEFT JOIN Movement AS Movement_Sale ON Movement_Sale.Id = MovementLinkMovement_Child_Sale.MovementId

                        LEFT JOIN MovementString AS MovementString_InvNumberPartner_Sale
                                                 ON MovementString_InvNumberPartner_Sale.MovementId =  MovementLinkMovement_Child_Sale.MovementId
                                                AND MovementString_InvNumberPartner_Sale.DescId = zc_MovementString_InvNumberPartner()

                        LEFT JOIN MovementString AS MovementString_InvNumberOrder_Sale
                                                 ON MovementString_InvNumberOrder_Sale.MovementId =  MovementLinkMovement_Child_Sale.MovementId
                                                AND MovementString_InvNumberOrder_Sale.DescId = zc_MovementString_InvNumberOrder()

                        LEFT JOIN MovementDate AS MovementDate_OperDatePartner_Sale
                                               ON MovementDate_OperDatePartner_Sale.MovementId =  MovementLinkMovement_Child_Sale.MovementId
                                              AND MovementDate_OperDatePartner_Sale.DescId = zc_MovementDate_OperDatePartner()
                   )

, tmpDocumentTaxKind AS (SELECT Object.Id                                       AS Id
                              , Object.ObjectCode                               AS Code
                              , Object.ValueData                                AS Name
                              , ObjectString_Code.ValueData         :: TVarChar AS KindCode
                              , ObjectString_Goods.ValueData        :: TVarChar AS GoodsName
                              , ObjectString_Measure.ValueData      :: TVarChar AS MeasureName
                              , ObjectString_MeasureCode.ValueData  :: TVarChar AS MeasureCode
                              , ObjectFloat_Price.ValueData         :: TFloat   AS Price
                         FROM Object
                              LEFT JOIN ObjectString AS ObjectString_Code
                                                     ON ObjectString_Code.ObjectId = Object.Id
                                                    AND ObjectString_Code.DescId = zc_objectString_DocumentTaxKind_Code()
                              LEFT JOIN ObjectString AS ObjectString_Goods
                                                     ON ObjectString_Goods.ObjectId = Object.Id
                                                    AND ObjectString_Goods.DescId = zc_objectString_DocumentTaxKind_Goods()
                              LEFT JOIN ObjectString AS ObjectString_Measure
                                                     ON ObjectString_Measure.ObjectId = Object.Id
                                                    AND ObjectString_Measure.DescId = zc_objectString_DocumentTaxKind_Measure()
                              LEFT JOIN ObjectString AS ObjectString_MeasureCode
                                                     ON ObjectString_MeasureCode.ObjectId = Object.Id
                                                    AND ObjectString_MeasureCode.DescId = zc_objectString_DocumentTaxKind_MeasureCode()
                              LEFT JOIN ObjectFloat AS ObjectFloat_Price
                                                    ON ObjectFloat_Price.ObjectId = Object.Id
                                                   AND ObjectFloat_Price.DescId = zc_objectFloat_DocumentTaxKind_Price()
                         WHERE Object.DescId = zc_Object_DocumentTaxKind()
                           AND Object.isErased = FALSE
                         )

, tmpMovement_Data AS (SELECT tmpMovement.Id                                  AS MovementId
                            , MovementLinkObject_To.ObjectId                  AS ToId
                            , MovementLinkObject_From.ObjectId                AS FromId
                            , Object_From.ValueData                           AS FromName
                            , ObjectString_FromAddress.ValueData              AS FromAddress
                            , ObjectString_Partner_GLNCodeJuridical.ValueData AS Partner_GLNCodeJuridical
                            , ObjectString_Partner_GLNCodeCorporate.ValueData AS Partner_GLNCodeCorporate
                            , ObjectString_Juridical_GLNCode.ValueData        AS Juridical_GLNCode
                            , ObjectString_Retail_GLNCodeCorporate.ValueData  AS Retail_GLNCodeCorporate
                            , ObjectString_JuridicalTo_GLNCode.ValueData      AS JuridicalTo_GLNCode
                            , MovementLinkObject_DocumentTaxKind.ObjectId     AS DocumentTaxKind
                            , tmpDocumentTaxKind.KindCode                     AS Code_DocumentTaxKind
                            , tmpDocumentTaxKind.GoodsName                    AS Goods_DocumentTaxKind
                            , tmpDocumentTaxKind.MeasureName                  AS Measure_DocumentTaxKind
                            , tmpDocumentTaxKind.MeasureCode                  AS MeasureCode_DocumentTaxKind
                            , tmpDocumentTaxKind.Price                        AS Price_DocumentTaxKind

                            --, CASE WHEN COALESCE (ObjectString_DocumentTaxKind_Code.ValueData,'') = '' THEN '0' ELSE  ObjectString_DocumentTaxKind_Code.ValueData END  AS Code_DocumentTaxKind
                            , MovementLinkObject_Branch.ObjectId              AS BranchId
                            , MovementString_FromINN.ValueData                AS INN_From

                              -- № Склада или Номер филиала или кв.:
                            , ObjectString_RoomNumber.ValueData               AS RoomNumber_From
                             -- Условное обозначение
                            , ObjectString_ShortName.ValueData                AS ShortName_From
                              -- Номер филиала
                            , ObjectString_BranchCode.ValueData               AS BranchCode_From
                              -- Название юр.лица для филиала
                            , ObjectString_BranchJur.ValueData                AS BranchJur_From

                              -- Сотрудник подписант
                            , COALESCE (tmpBranch_PersonalBookkeeper_partner.PersonalBookkeeperName, Object_PersonalSigning_partner.PersonalName) AS PersonalSigningName
                            , PersonalSigning_INN.ValueData AS Signing_INN

                       FROM tmpMovement
                            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                         ON MovementLinkObject_From.MovementId = tmpMovement.Id
                                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

                            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                         ON MovementLinkObject_To.MovementId = tmpMovement.Id
                                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

                            LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                                         ON MovementLinkObject_Partner.MovementId = tmpMovement.Id
                                                        AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
                            -- Сотрудник подписант - контрагент
                            LEFT JOIN ObjectLink AS ObjectLink_Partner_PersonalSigning
                                                 ON ObjectLink_Partner_PersonalSigning.ObjectId = MovementLinkObject_Partner.ObjectId
                                                AND ObjectLink_Partner_PersonalSigning.DescId   = zc_ObjectLink_Partner_PersonalSigning()
                            LEFT JOIN Object_Personal_View AS Object_PersonalSigning_partner ON Object_PersonalSigning_partner.PersonalId = ObjectLink_Partner_PersonalSigning.ChildObjectId
                            -- Сотрудник подписант - замена
                            LEFT JOIN tmpBranch_PersonalBookkeeper AS tmpBranch_PersonalBookkeeper_partner ON tmpBranch_PersonalBookkeeper_partner.MemberId = Object_PersonalSigning_partner.MemberId
                            LEFT JOIN ObjectString AS PersonalSigning_INN
                                                   ON PersonalSigning_INN.ObjectId = COALESCE (tmpBranch_PersonalBookkeeper_partner.MemberId, Object_PersonalSigning_partner.MemberId)
                                                  AND PersonalSigning_INN.DescId   = zc_ObjectString_Member_INN()
                            

                            LEFT JOIN MovementLinkObject AS MovementLinkObject_DocumentTaxKind
                                                         ON MovementLinkObject_DocumentTaxKind.MovementId = tmpMovement.Id
                                                        AND MovementLinkObject_DocumentTaxKind.DescId = zc_MovementLinkObject_DocumentTaxKind()

                            LEFT JOIN MovementLinkObject AS MovementLinkObject_Branch
                                                         ON MovementLinkObject_Branch.MovementId = tmpMovement.Id
                                                        AND MovementLinkObject_Branch.DescId = zc_MovementLinkObject_Branch()

                            LEFT JOIN ObjectString AS ObjectString_FromAddress
                                                   ON ObjectString_FromAddress.ObjectId = MovementLinkObject_Partner.ObjectId
                                                  AND ObjectString_FromAddress.DescId = zc_ObjectString_Partner_Address()

                            LEFT JOIN ObjectString AS ObjectString_Partner_GLNCodeJuridical
                                                   ON ObjectString_Partner_GLNCodeJuridical.ObjectId = COALESCE (MovementLinkObject_Partner.ObjectId, MovementLinkObject_From.ObjectId)
                                                  AND ObjectString_Partner_GLNCodeJuridical.DescId = zc_ObjectString_Partner_GLNCodeJuridical()

                            LEFT JOIN ObjectString AS ObjectString_Partner_GLNCodeCorporate
                                                   ON ObjectString_Partner_GLNCodeCorporate.ObjectId = COALESCE (MovementLinkObject_Partner.ObjectId, MovementLinkObject_From.ObjectId)
                                                  AND ObjectString_Partner_GLNCodeCorporate.DescId = zc_ObjectString_Partner_GLNCodeCorporate()

                            LEFT JOIN MovementString AS MovementString_FromINN
                                                     ON MovementString_FromINN.MovementId = tmpMovement.Id
                                                    AND MovementString_FromINN.DescId = zc_MovementString_FromINN()
                                                    AND MovementString_FromINN.ValueData  <> ''

                            -- № Склада или Номер филиала или кв.:
                            LEFT JOIN ObjectString AS ObjectString_RoomNumber
                                                   ON ObjectString_RoomNumber.ObjectId = COALESCE (MovementLinkObject_Partner.ObjectId, MovementLinkObject_From.ObjectId)
                                                  AND ObjectString_RoomNumber.DescId   = zc_ObjectString_Partner_RoomNumber()
                            -- Условное обозначение
                            LEFT JOIN ObjectString AS ObjectString_ShortName
                                                   ON ObjectString_ShortName.ObjectId = COALESCE (MovementLinkObject_Partner.ObjectId, MovementLinkObject_From.ObjectId)
                                                  AND ObjectString_ShortName.DescId   = zc_ObjectString_Partner_ShortName()
                            -- Номер филиала
                            LEFT JOIN ObjectString AS ObjectString_BranchCode
                                                   ON ObjectString_BranchCode.ObjectId = COALESCE (MovementLinkObject_Partner.ObjectId, MovementLinkObject_From.ObjectId)
                                                  AND ObjectString_BranchCode.DescId = zc_ObjectString_Partner_BranchCode()
                            -- Название юр.лица для филиала
                            LEFT JOIN ObjectString AS ObjectString_BranchJur
                                                   ON ObjectString_BranchJur.ObjectId = COALESCE (MovementLinkObject_Partner.ObjectId, MovementLinkObject_From.ObjectId)
                                                  AND ObjectString_BranchJur.DescId = zc_ObjectString_Partner_BranchJur()

                            LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                 ON ObjectLink_Juridical_Retail.ObjectId = MovementLinkObject_From.ObjectId
                                                AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()

                            LEFT JOIN ObjectString AS ObjectString_Juridical_GLNCode
                                                   ON ObjectString_Juridical_GLNCode.ObjectId = MovementLinkObject_From.ObjectId
                                                  AND ObjectString_Juridical_GLNCode.DescId = zc_ObjectString_Juridical_GLNCode()

                            LEFT JOIN ObjectString AS ObjectString_Retail_GLNCodeCorporate
                                                   ON ObjectString_Retail_GLNCodeCorporate.ObjectId = ObjectLink_Juridical_Retail.ChildObjectId
                                                  AND ObjectString_Retail_GLNCodeCorporate.DescId = zc_ObjectString_Retail_GLNCodeCorporate()

                            LEFT JOIN ObjectString AS ObjectString_JuridicalTo_GLNCode
                                                   ON ObjectString_JuridicalTo_GLNCode.ObjectId = MovementLinkObject_To.ObjectId
                                                  AND ObjectString_JuridicalTo_GLNCode.DescId = zc_ObjectString_Juridical_GLNCode()

                            LEFT JOIN tmpDocumentTaxKind ON tmpDocumentTaxKind.Id = MovementLinkObject_DocumentTaxKind.ObjectId
                            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
                       )

/*  -- причины корректировки и кода
101. "Зміна ціни".
102. "Зміна кількості".
103. "Повернення товарів або авансових платежів".
104. "Зміна номенклатури". --zc_Enum_DocumentTaxKind_Goods

. "Зменшення обсягу при нульовій кількості".
. "Зменшення кількості при нульовому обсязі".
. "Усунення неоднозначностей"  --zc_Enum_DocumentTaxKind_Change
*/

, tmpObjectHistory_JuridicalDetails_ViewByDate AS (SELECT *
                                                 FROM ObjectHistory_JuridicalDetails_ViewByDate
                                                 WHERE ObjectHistory_JuridicalDetails_ViewByDate.JuridicalId IN (SELECT DISTINCT tmpMovement_Data.ToId FROM tmpMovement_Data
                                                                                                           UNION SELECT DISTINCT tmpMovement_Data.FromId FROM tmpMovement_Data)
                                                  )
                                                  
                                                  
   , tmpData_all AS
      -- РЕЗУЛЬТАТ
     (SELECT inMovementId                                                   AS inMovementId
           , tmpMI.MovementId                                               AS MovementId
           , tmpMI.InvNumber			                            AS InvNumber
           , tmpMI.OperDate				                    AS OperDate
           -- , 'J1201006'::TVarChar                                           AS CHARCODE
           , CASE WHEN vbOperDate_begin  < '01.04.2016' THEN 'J1201207'
                  WHEN tmpMI.OperDate    < '01.03.2017' THEN 'J1201208'
                  WHEN vbOperDate_begin  < '01.12.2018' THEN 'J1201209'
                  WHEN vbOperDate_begin  < '01.03.2021' THEN 'J1201210'
                  WHEN vbOperDate_begin  < '16.03.2021' THEN 'J1201211'
                  WHEN vbOperDate_begin  < '01.10.2024' THEN 'J1201212'
                  ELSE 'J1201216'
             END ::TVarChar AS CHARCODE

             -- Сотрудник подписант
           , CASE -- контрагент
                  WHEN tmpMovement_Data.PersonalSigningName <> ''
                       THEN tmpMovement_Data.PersonalSigningName
                  -- договор
                  WHEN tmpPersonalSigning.PersonalName <> ''
                       THEN tmpPersonalSigning.PersonalName
                  -- филиал
                  ELSE CASE WHEN tmpPersonalBookkeeper.PersonalName <> ''
                            THEN tmpPersonalBookkeeper.PersonalName
                            ELSE 'Рудик Н.В.'
                       END
             END :: TVarChar AS N10

             -- Сотрудник подписант
           , CASE -- контрагент
                  WHEN tmpMovement_Data.PersonalSigningName <> ''
                       THEN UPPER (tmpMovement_Data.PersonalSigningName)
                  -- договор
                  WHEN tmpPersonalSigning.PersonalName <> ''
                       THEN UPPER (tmpPersonalSigning.PersonalName)
                  -- филиал
                  ELSE CASE WHEN tmpPersonalBookkeeper.PersonalName <> ''
                            THEN UPPER (tmpPersonalBookkeeper.PersonalName)
                            ELSE UPPER ('Н. В. Рудик')
                       END
             END :: TVarChar AS N10_ifin

           , 'оплата з поточного рахунка'::TVarChar                         AS N9

           , tmpMovement_Data.Code_DocumentTaxKind          AS KindCode     -- заполняется в справочнике

           , CASE WHEN tmpMovement_Data.DocumentTaxKind IN (zc_Enum_DocumentTaxKind_Goods(), zc_Enum_DocumentTaxKind_Change(), zc_Enum_DocumentTaxKind_ChangeErr())
                       THEN Object_DocumentTaxKind.ValueData

                  WHEN tmpMovement_Data.DocumentTaxKind IN (zc_Enum_DocumentTaxKind_CorrectivePrice()
                                                          , zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
                                                          , zc_Enum_DocumentTaxKind_ChangePercent() )
                       THEN 'Зміна ціни'

                  WHEN MovementBoolean_isCopy.ValueData = TRUE
                       THEN 'ВИПРАВЛЕННЯ ПОМИЛКИ'

                  WHEN tmpMI.isPartner = TRUE
                       THEN 'Зміна кількості' -- 'НЕДОВІЗ'

                  ELSE 'Зміна кількості' -- 'повернення товару або авансових платежів' -- 'повернення'

             END :: TVarChar AS KindName
           , tmpMovement_Data.DocumentTaxKind
           , MovementBoolean_PriceWithVAT.ValueData                         AS PriceWithVAT
           , MovementFloat_VATPercent.ValueData                             AS VATPercent
           , CAST (REPEAT (' ', 7 - LENGTH (MovementString_InvNumberPartner.ValueData)) || MovementString_InvNumberPartner.ValueData AS TVarChar) AS InvNumberPartner
           , CAST (REPEAT ('0', 7 - LENGTH (MovementString_InvNumberPartner.ValueData)) || MovementString_InvNumberPartner.ValueData AS TVarChar) AS InvNumberPartner_ifin

           , CAST (COALESCE (MovementFloat_TotalSummPVAT.ValueData, 0) - COALESCE (MovementFloat_TotalSummMVAT.ValueData, 0) AS TFloat) AS TotalSummVAT
           , MovementFloat_TotalSummMVAT.ValueData                          AS TotalSummMVAT
           , MovementFloat_TotalSummPVAT.ValueData                          AS TotalSummPVAT
           , MovementFloat_TotalSumm.ValueData                              AS TotalSumm

           , tmpContract.ContractName         		                    AS ContractName
           , tmpContract.ContractSigningDate                                AS ContractSigningDate
           , tmpContract.ContractKindName                                   AS ContractKind
           , tmpContract.PartnerCode                                        AS PartnerCode

           , CASE WHEN tmpMLM_Child.InvNumberPartner_Child <> ''
                      THEN CAST (REPEAT (' ', 7 - LENGTH (tmpMLM_Child.InvNumberPartner_Child)) || tmpMLM_Child.InvNumberPartner_Child AS TVarChar)
                  ELSE '0' :: TVarChar
             END  AS InvNumber_Child
           , tmpMLM_Child.OperDate_Child                                    AS OperDate_Child
           , tmpMLM_Child.OperDate_begin_Child                              AS OperDate_begin_Child

           , CASE WHEN inisClientCopy=TRUE
                  THEN 'X' ELSE '' END                                      AS CopyForClient
           , CASE WHEN inisClientCopy=TRUE
                  THEN '' ELSE 'X' END                                      AS CopyForUs

           , tmpMLM_Child.MovementId_Child  AS x11
           , tmpMLM_Child.OperDate_Child    AS x12
           , '51' ::TVarChar                AS PZOB           -- поле для Медка
           , vbOperDate_begin               AS OperDate_begin -- поле для Медка

             -- Підлягає реєстрації в ЄРПН покупцем !!!так криво для медка до 01.04.2016!!!
           , CASE WHEN tmpMI.OperDate < '01.01.2015' AND (COALESCE (MovementFloat_TotalSummPVAT.ValueData, 0) - COALESCE (MovementFloat_TotalSummMVAT.ValueData, 0)) > 10000
                  THEN TRUE
                  WHEN tmpMI.OperDate >= '01.01.2015' AND tmpMLM_Child.OperDate_Child >= '01.01.2015'
                   AND COALESCE (tmpMovement_Data.INN_From, OH_JuridicalDetails_From.INN) <> vbNotNDSPayer_INN AND vbCalcNDSPayer_INN = ''
                       AND COALESCE (MovementFloat_TotalSummPVAT.ValueData, 0) >= 0
                  THEN TRUE
                  ELSE FALSE
             END :: Boolean AS isERPN

           , CASE WHEN vbOperDate_begin >= '01.04.2016' AND COALESCE (tmpMovement_Data.INN_From, OH_JuridicalDetails_From.INN) <> vbNotNDSPayer_INN AND vbCalcNDSPayer_INN = ''
                       AND COALESCE (MovementFloat_TotalSummPVAT.ValueData, 0) < 0
                       THEN 'X'
                  WHEN vbOperDate_begin >= '01.04.2016' AND (COALESCE (tmpMovement_Data.INN_From, OH_JuridicalDetails_From.INN) = vbNotNDSPayer_INN OR vbCalcNDSPayer_INN <> '')
                       THEN 'X'
                  WHEN vbOperDate_begin >= '01.04.2016'
                        THEN ''
                  WHEN tmpMI.OperDate < '01.01.2015' AND (COALESCE (MovementFloat_TotalSummPVAT.ValueData, 0) - COALESCE (MovementFloat_TotalSummMVAT.ValueData, 0)) > 10000
                       THEN 'X'
                  WHEN tmpMI.OperDate >= '01.01.2015' AND tmpMLM_Child.OperDate_Child >= '01.01.2015' AND COALESCE (tmpMovement_Data.INN_From, OH_JuridicalDetails_From.INN) <> vbNotNDSPayer_INN AND vbCalcNDSPayer_INN = ''
                       THEN 'X'
                  ELSE ''
             END :: TVarChar AS ERPN -- Підлягає реєстрації в ЄРПН постачальником (продавцем)

           , CASE WHEN COALESCE (tmpMovement_Data.INN_From, OH_JuridicalDetails_From.INN) <> vbNotNDSPayer_INN AND vbCalcNDSPayer_INN = '' AND tmpMLM_Child.OperDate_Child >= '01.02.2015'
                  THEN CASE WHEN COALESCE (MovementFloat_TotalSummPVAT.ValueData, 0) < 0 THEN '' ELSE 'X' END
                  ELSE ''
             END :: TVarChar AS ERPN2 -- Підлягає реєстрації в ЄРПН покупцем

           , CASE WHEN COALESCE (tmpMovement_Data.INN_From, OH_JuridicalDetails_From.INN) = vbNotNDSPayer_INN OR vbCalcNDSPayer_INN <> '' THEN 'X'
                  ELSE ''
             END :: TVarChar AS NotNDSPayer
           , CASE WHEN COALESCE (tmpMovement_Data.INN_From, OH_JuridicalDetails_From.INN) = vbNotNDSPayer_INN OR vbCalcNDSPayer_INN <> ''
                  THEN TRUE ELSE FALSE END :: Boolean                       AS isNotNDSPayer
           , CASE WHEN COALESCE (tmpMovement_Data.INN_From, OH_JuridicalDetails_From.INN) = vbNotNDSPayer_INN OR vbCalcNDSPayer_INN <> ''
                  THEN '0' ELSE '' END                                      AS NotNDSPayerC1
           , CASE WHEN COALESCE (tmpMovement_Data.INN_From, OH_JuridicalDetails_From.INN) = vbNotNDSPayer_INN OR vbCalcNDSPayer_INN <> ''
                  THEN '2' ELSE '' END                                      AS NotNDSPayerC2

           , tmpMovement_Data.FromAddress                                   AS PartnerAddress_From

           , OH_JuridicalDetails_To.FullName                                AS JuridicalName_To
           , OH_JuridicalDetails_To.JuridicalAddress                        AS JuridicalAddress_To

           , CASE WHEN vbOperDate_begin >= '01.12.2018'
                   AND OH_JuridicalDetails_To.INN IN ('100000000000', '300000000000')
                  THEN ''
                  ELSE OH_JuridicalDetails_To.OKPO
             END :: TVarChar AS OKPO_To
           , CASE WHEN OH_JuridicalDetails_To.INN IN ('100000000000', '300000000000')
                  THEN ''
                  ELSE (REPEAT ('0', 10 - LENGTH (OH_JuridicalDetails_To.OKPO)) ||  OH_JuridicalDetails_To.OKPO)
             END :: TVarChar AS OKPO_To_ifin
           --, (REPEAT ('0', 10 - LENGTH (OH_JuridicalDetails_To.OKPO)) ||  OH_JuridicalDetails_To.OKPO) :: TVarChar AS OKPO_To_ifin
           , OH_JuridicalDetails_To.INN                                     AS INN_To
           , OH_JuridicalDetails_To.NumberVAT                               AS NumberVAT_To
         -- , COALESCE (Object_Personal_View.PersonalName, OH_JuridicalDetails_To.AccounterName) :: TVarChar AS AccounterName_To

           , CASE WHEN tmpPersonalSigning.PersonalName <> ''
                  THEN zfConvert_FIO (tmpPersonalSigning.PersonalName, 1, FALSE)
                  ELSE CASE WHEN COALESCE (tmpPersonalBookkeeper.PersonalName,'') <> ''
                            THEN tmpPersonalBookkeeper.PersonalName                    --zfConvert_FIO (tmpPersonalBookkeeper.PersonalName, 1, FALSE)
                            ELSE 'Рудик Н.В.' /*'А.В. Марухно'*/
                       END
             END                                                :: TVarChar AS AccounterName_To
           , CASE -- контрагент
                  WHEN tmpMovement_Data.PersonalSigningName <> ''
                       THEN tmpMovement_Data.Signing_INN
                  -- договор
                  WHEN tmpPersonalSigning.PersonalName <> ''
                       THEN tmpPersonalSigning.PersonalSigning_INN
                  -- филиал
                  ELSE CASE WHEN tmpPersonalBookkeeper.PersonalName <> ''
                            THEN tmpPersonalBookkeeper.PersonalBookkeeper_INN
                            ELSE '2649713447'
                       END
              END                                               :: TVarChar AS AccounterINN_To
           , OH_JuridicalDetails_To.BankAccount                             AS BankAccount_To
           , OH_JuridicalDetails_To.BankName                                AS BankName_To
           , OH_JuridicalDetails_To.MFO                                     AS BankMFO_To
           , OH_JuridicalDetails_To.Phone                                   AS Phone_To

           /*, ObjectString_BuyerGLNCode.ValueData                          AS BuyerGLNCode
           , ObjectString_SupplierGLNCode.ValueData                         AS SupplierGLNCode*/

           , zfCalc_GLNCodeJuridical (inGLNCode                  := 'ok'
                                    , inGLNCodeJuridical_partner := tmpMovement_Data.Partner_GLNCodeJuridical
                                    , inGLNCodeJuridical         := tmpMovement_Data.Juridical_GLNCode
                                     ) AS BuyerGLNCode

           , CASE WHEN OH_JuridicalDetails_From.JuridicalId = 15158 -- МЕТРО Кеш енд Кері Україна ТОВ
                       THEN '' -- если Метро, тогда наш = "пусто"
                  ELSE zfCalc_GLNCodeCorporate (inGLNCode                  := 'ok'
                                              , inGLNCodeCorporate_partner := tmpMovement_Data.Partner_GLNCodeCorporate
                                              , inGLNCodeCorporate_retail  := tmpMovement_Data.Retail_GLNCodeCorporate
                                              , inGLNCodeCorporate_main    := tmpMovement_Data.JuridicalTo_GLNCode
                                               )
             END :: TVarChar AS SupplierGLNCode

           , tmpMovement_Data.FromName AS JuridicalName_From_inf  -- для определения признака ФОП / не ФОП

           , CASE WHEN tmpMovement_Data.FromId = 9840136 AND 1=1 -- AND vbUserId = 5
                       -- Укрзалізниця АТ
                       THEN COALESCE (OH_JuridicalDetails_From.Name, '')

                  -- Название юр.лица для филиала
                  WHEN tmpMovement_Data.BranchJur_From <> ''
                       THEN tmpMovement_Data.BranchJur_From

                  WHEN COALESCE (tmpMovement_Data.INN_From, OH_JuridicalDetails_From.INN) = vbNotNDSPayer_INN OR vbCalcNDSPayer_INN <> ''
                       THEN 'Неплатник'
                  ELSE OH_JuridicalDetails_From.FullName
             END :: TVarChar AS JuridicalName_From

           , CASE WHEN tmpMovement_Data.FromId = 9840136 AND 1=1 -- AND vbUserId = 5
                       -- Укрзалізниця АТ - Условное обозначение
                       THEN ', ' || TRIM (TRIM (LOWER (SPLIT_PART (tmpMovement_Data.ShortName_From, 'підрозділ', 1)))
                         || ' ' || TRIM (SPLIT_PART (SPLIT_PART (tmpMovement_Data.ShortName_From, 'філії', 1), 'Структурний', 2)))
                  ELSE ''
             END :: TVarChar AS JuridicalName_From_add

           , CASE WHEN COALESCE (tmpMovement_Data.INN_From, OH_JuridicalDetails_From.INN) = vbNotNDSPayer_INN OR vbCalcNDSPayer_INN <> ''
                  THEN 'Неплатник'
             ELSE OH_JuridicalDetails_From.JuridicalAddress END             AS JuridicalAddress_From

           , CASE WHEN vbOperDate_begin >= '01.12.2018'
                   AND OH_JuridicalDetails_From.INN IN ('100000000000', '300000000000')
                  THEN ''
                  ELSE COALESCE (ObjectString_Retail_OKPO.ValueData, OH_JuridicalDetails_From.OKPO)
             END :: TVarChar AS OKPO_From
           , CASE WHEN COALESCE (tmpMovement_Data.INN_From, OH_JuridicalDetails_From.INN) IN ('100000000000', '300000000000')
                  THEN ''
                  ELSE (REPEAT ('0', 10 - LENGTH (OH_JuridicalDetails_From.OKPO)) ||  OH_JuridicalDetails_From.OKPO)
             END :: TVarChar AS OKPO_From_ifin
           , CASE WHEN vbCalcNDSPayer_INN <> '' THEN vbCalcNDSPayer_INN ELSE COALESCE (tmpMovement_Data.INN_From, OH_JuridicalDetails_From.INN) END AS INN_From

           , CASE WHEN tmpMovement_Data.FromId = 9840136 AND tmpMovement_Data.RoomNumber_from <> '' -- AND vbUserId = 5
                       -- Укрзалізниця АТ - № Склада или Номер филиала или кв.:
                       THEN tmpMovement_Data.RoomNumber_from

                  -- Номер филиала
                  WHEN tmpMovement_Data.BranchCode_from <> ''
                       THEN tmpMovement_Data.BranchCode_from

                  ELSE OH_JuridicalDetails_From.InvNumberBranch
             END :: TVarChar AS InvNumberBranch_From

           , OH_JuridicalDetails_From.NumberVAT                             AS NumberVAT_From
           , OH_JuridicalDetails_From.AccounterName                         AS AccounterName_From
           , OH_JuridicalDetails_From.BankAccount                           AS BankAccount_From
           , OH_JuridicalDetails_From.BankName                              AS BankName_From
           , OH_JuridicalDetails_From.MFO                                   AS BankMFO_From
           , CASE WHEN COALESCE (tmpMovement_Data.INN_From, OH_JuridicalDetails_From.INN) = vbNotNDSPayer_INN OR vbCalcNDSPayer_INN <> ''
                  THEN ''
             ELSE OH_JuridicalDetails_From.Phone END                        AS Phone_From

           , tmpMI.Id                                                       AS Id
           , tmpGoods.GoodsCode                                             AS GoodsCode

           , CASE WHEN tmpMI.OperDate < '01.01.2017'
                       THEN ''

                  WHEN tmpGoods.Goods_UKTZED <> ''
                       THEN CASE WHEN vbIsLongUKTZED = TRUE THEN tmpGoods.Goods_UKTZED ELSE SUBSTRING (tmpGoods.Goods_UKTZED FROM 1 FOR 4) END

                  WHEN tmpUKTZED.CodeUKTZED <> ''
                       THEN CASE WHEN vbIsLongUKTZED = TRUE THEN tmpUKTZED.CodeUKTZED ELSE SUBSTRING (tmpUKTZED.CodeUKTZED FROM 1 FOR 4) END

                  -- для предоплаты
                  WHEN vbDocumentTaxKindId = zc_Enum_DocumentTaxKind_Prepay()
                       THEN '1601009900'

                  WHEN tmpGoods.InfoMoneyId IN (zc_Enum_InfoMoney_20901(), zc_Enum_InfoMoney_30101())
                       THEN '' -- '1601'
                  WHEN tmpGoods.InfoMoneyId IN (zc_Enum_InfoMoney_21001(), zc_Enum_InfoMoney_30102())
                       THEN '' -- '1602'
                  WHEN tmpGoods.InfoMoneyId = zc_Enum_InfoMoney_30103()
                       THEN '' -- '1905'
                  ELSE '' -- '0'
              END :: TVarChar AS GoodsCodeUKTZED

           , CASE WHEN tmpMI.OperDate < '01.01.2017' THEN ''
                  WHEN tmpGoods.Goods_TaxImport <> '' THEN tmpGoods.Goods_TaxImport
                  WHEN tmpTaxImport.TaxImport <> '' THEN tmpTaxImport.TaxImport
                  ELSE ''
             END :: TVarChar AS GoodsCodeTaxImport

           , CASE WHEN tmpMI.OperDate < '01.01.2017' THEN ''
                  WHEN tmpGoods.Goods_DKPP <> '' THEN tmpGoods.Goods_DKPP
                  WHEN tmpDKPP.DKPP <> '' THEN tmpDKPP.DKPP
                  ELSE ''
             END :: TVarChar AS GoodsCodeDKPP

           , CASE WHEN tmpMI.OperDate < '01.01.2017' THEN ''
                  WHEN tmpGoods.Goods_TaxAction <> '' THEN tmpGoods.Goods_TaxAction
                  WHEN tmpTaxAction.TaxAction <> '' THEN tmpTaxAction.TaxAction
                  ELSE ''
             END :: TVarChar AS GoodsCodeTaxAction

           , CASE WHEN tmpMovement_Data.DocumentTaxKind = zc_Enum_DocumentTaxKind_Prepay() AND COALESCE (tmpContract.InfoMoneyId, 0) <> zc_Enum_InfoMoney_30201()
                       THEN CASE WHEN vbOperDate_begin >= '01.12.2018' AND COALESCE (tmpMovement_Data.Goods_DocumentTaxKind, '') <> '' THEN tmpMovement_Data.Goods_DocumentTaxKind
                                 ELSE 'ПРЕДОПЛАТА ЗА КОЛБ.ИЗДЕЛИЯ'
                            END
                  WHEN tmpObject_GoodsPropertyValue.Name            <> '' THEN tmpObject_GoodsPropertyValue.Name
                  WHEN tmpObject_GoodsPropertyValueGroup.Name       <> '' THEN tmpObject_GoodsPropertyValueGroup.Name
                  WHEN tmpObject_GoodsPropertyValue_basis.Name      <> '' THEN tmpObject_GoodsPropertyValue_basis.Name
                  WHEN tmpObject_GoodsPropertyValueGroup_basis.Name <> '' THEN tmpObject_GoodsPropertyValueGroup_basis.Name
                  ELSE CASE WHEN tmpMLM_Child.OperDate_rus < zc_DateEnd_GoodsRus() AND tmpGoods.GoodsName_RUS <> '' THEN tmpGoods.GoodsName_RUS ELSE tmpGoods.GoodsName END || CASE WHEN COALESCE (tmpMI.GoodsKindId, zc_Enum_GoodsKind_Main()) = zc_Enum_GoodsKind_Main() THEN '' ELSE ' ' || tmpMI.GoodsKindName END
             END :: TVarChar AS GoodsName

           , CASE WHEN tmpMovement_Data.DocumentTaxKind = zc_Enum_DocumentTaxKind_Prepay() AND COALESCE (tmpContract.InfoMoneyId, 0) <> zc_Enum_InfoMoney_30201()
                       THEN CASE WHEN vbOperDate_begin >= '01.12.2018' AND COALESCE (tmpMovement_Data.Goods_DocumentTaxKind, '') <> '' THEN tmpMovement_Data.Goods_DocumentTaxKind
                                 ELSE 'ПРЕДОПЛАТА ЗА КОЛБ.ИЗДЕЛИЯ'
                            END
                  WHEN tmpObject_GoodsPropertyValue.Name            <> '' THEN tmpObject_GoodsPropertyValue.Name
                  WHEN tmpObject_GoodsPropertyValueGroup.Name       <> '' THEN tmpObject_GoodsPropertyValueGroup.Name
                  WHEN tmpObject_GoodsPropertyValue_basis.Name      <> '' THEN tmpObject_GoodsPropertyValue_basis.Name
                  WHEN tmpObject_GoodsPropertyValueGroup_basis.Name <> '' THEN tmpObject_GoodsPropertyValueGroup_basis.Name
                  ELSE CASE WHEN tmpMLM_Child.OperDate_rus < zc_DateEnd_GoodsRus() AND tmpGoods.GoodsName_RUS <> '' THEN tmpGoods.GoodsName_RUS ELSE tmpGoods.GoodsName END
             END :: TVarChar  AS GoodsName_two

           , tmpMI.GoodsKindName                                            AS GoodsKindName
           , CASE WHEN tmpMovement_Data.DocumentTaxKind = zc_Enum_DocumentTaxKind_Prepay() AND COALESCE (tmpContract.InfoMoneyId, 0) <> zc_Enum_InfoMoney_30201() AND vbOperDate_begin >= '01.12.2018' AND COALESCE (tmpMovement_Data.Measure_DocumentTaxKind, '') <> ''
                  THEN tmpMovement_Data.Measure_DocumentTaxKind
                  ELSE tmpGoods.MeasureName
             END                                                            AS MeasureName
           , CASE WHEN tmpMovement_Data.DocumentTaxKind = zc_Enum_DocumentTaxKind_Prepay() AND COALESCE (tmpContract.InfoMoneyId, 0) <> zc_Enum_InfoMoney_30201() AND vbOperDate_begin >= '01.12.2018' AND COALESCE (tmpMovement_Data.MeasureCode_DocumentTaxKind, '') <> ''
                  THEN tmpMovement_Data.MeasureCode_DocumentTaxKind
                  ELSE CASE WHEN tmpGoods.MeasureCode=1 THEN '0301'
                            WHEN tmpGoods.MeasureCode=2 THEN '2009'
                            ELSE ''
                       END
             END                                                            AS MeasureCode

           , COALESCE (tmpObject_GoodsPropertyValueGroup.Article, COALESCE (tmpObject_GoodsPropertyValue.Article, ''))    AS Article_Juridical
           , COALESCE (tmpObject_GoodsPropertyValue.BarCode, '')            AS BarCode_Juridical
           , COALESCE (tmpObject_GoodsPropertyValueGroup.ArticleGLN, COALESCE (tmpObject_GoodsPropertyValue.ArticleGLN, '')) AS ArticleGLN_Juridical
           , COALESCE (tmpObject_GoodsPropertyValue.BarCodeGLN, '')         AS BarCodeGLN_Juridical

             -- кол-во
           , CASE -- обычная корр или корр цены для сводной или акт предоставления скидки
                  WHEN tmpMovement_Data.DocumentTaxKind NOT IN (zc_Enum_DocumentTaxKind_CorrectivePrice()
                                                              , zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
                                                              , zc_Enum_DocumentTaxKind_ChangePercent() )
                    OR vbDocumentTaxKindId_tax IN (zc_Enum_DocumentTaxKind_TaxSummaryJuridicalS()
                                                 , zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR()
                                                 , zc_Enum_DocumentTaxKind_TaxSummaryPartnerS()
                                                 , zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR()
                                                  )
                  THEN tmpMI.Amount
                  ELSE NULL END                                            AS Amount

             -- цена
           , CASE -- обычная корр
                  WHEN tmpMovement_Data.DocumentTaxKind NOT IN (zc_Enum_DocumentTaxKind_CorrectivePrice()
                                                              , zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
                                                              , zc_Enum_DocumentTaxKind_ChangePercent())
                  THEN tmpMI.Price / CASE WHEN tmpMI.CountForPrice > 0 THEN tmpMI.CountForPrice ELSE 1 END
                  -- корр цены для сводной
                  WHEN tmpMovement_Data.DocumentTaxKind IN (zc_Enum_DocumentTaxKind_CorrectivePrice()
                                                          , zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
                                                          , zc_Enum_DocumentTaxKind_ChangePercent())
                   AND vbDocumentTaxKindId_tax IN (zc_Enum_DocumentTaxKind_TaxSummaryJuridicalS()
                                                 , zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR()
                                                 , zc_Enum_DocumentTaxKind_TaxSummaryPartnerS()
                                                 , zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR()
                                                  )
                  THEN tmpMI.PriceTax_calc / CASE WHEN tmpMI.CountForPrice > 0 THEN tmpMI.CountForPrice ELSE 1 END
                  ELSE NULL  END                                            AS Price

             -- кол-во для корр цены - КРОМЕ сводной
           , CASE -- корр цены НЕ для сводной
                  WHEN tmpMovement_Data.DocumentTaxKind IN (zc_Enum_DocumentTaxKind_CorrectivePrice()
                                                          , zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
                                                          , zc_Enum_DocumentTaxKind_ChangePercent())
                   AND vbDocumentTaxKindId_tax NOT IN (zc_Enum_DocumentTaxKind_TaxSummaryJuridicalS()
                                                     , zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR()
                                                     , zc_Enum_DocumentTaxKind_TaxSummaryPartnerS()
                                                     , zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR()
                                                      )
                  THEN tmpMI.Amount
                  ELSE NULL  END                                            AS Amount_for_PriceCor
             -- кол-во для корр цены - если все кол-во
           , tmpMI.Amount                                                   AS Amount_for_PriceCor_two

             -- цена для корр цены - КРОМЕ сводной
           , CASE -- корр цены НЕ для сводной
                  WHEN tmpMovement_Data.DocumentTaxKind IN (zc_Enum_DocumentTaxKind_CorrectivePrice()
                                                          , zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
                                                          , zc_Enum_DocumentTaxKind_ChangePercent())
                   AND vbDocumentTaxKindId_tax NOT IN (zc_Enum_DocumentTaxKind_TaxSummaryJuridicalS()
                                                     , zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR()
                                                     , zc_Enum_DocumentTaxKind_TaxSummaryPartnerS()
                                                     , zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR()
                                                      )
                  THEN tmpMI.Price / CASE WHEN tmpMI.CountForPrice > 0 THEN tmpMI.CountForPrice ELSE 1 END
                  ELSE NULL  END                                            AS Price_for_PriceCor
             -- цена для корр цены - если все кол-во
           , tmpMI.Price / CASE WHEN tmpMI.CountForPrice > 0 THEN tmpMI.CountForPrice ELSE 1 END
                                                                            AS Price_for_PriceCor_two

           , tmpMI.Amount        AS Amount_orig
           , tmpMI.Price         AS Price_orig
           , tmpMI.CountForPrice AS CountForPrice_orig
           /*, CAST (CASE WHEN tmpMI.CountForPrice > 0
                           THEN CAST ( (COALESCE (tmpMI.Amount, 0)) * tmpMI.Price / tmpMI.CountForPrice AS NUMERIC (16, 2))
                           ELSE CAST ( (COALESCE (tmpMI.Amount, 0)) * tmpMI.Price AS NUMERIC (16, 2))
                   END AS TFloat)                                           AS AmountSumm*/

           , CAST (REPEAT (' ', 4 - LENGTH (MovementString_InvNumberBranch.ValueData)) || MovementString_InvNumberBranch.ValueData AS TVarChar) AS InvNumberBranch
           , CAST (REPEAT (' ', 4 - LENGTH (tmpMLM_Child.InvNumberBranch_Child)) || tmpMLM_Child.InvNumberBranch_Child AS TVarChar) AS InvNumberBranch_Child

           , tmpReturnIn.InvNumberMark     AS InvNumberMark
           , COALESCE (tmpReturnIn.OperDatePartner, tmpReturnIn.OperDate)   AS OperDatePartner_ReturnIn
           , COALESCE (tmpReturnIn.InvNumberPartner, tmpReturnIn.InvNumber) AS InvNumberPartner_ReturnIn
--           , COALESCE (MovementFloat_VATPercent.ValueData, 0) AS VATPercent

           , tmpMLM_Child.InvNumber_Sale                                    AS InvNumber_Sale
           , tmpMLM_Child.InvNumberPartner_Sale                             AS InvNumberPartner_Sale
           , tmpMLM_Child.InvNumberOrder_Sale                               AS InvNumberOrder_Sale
           , tmpMLM_Child.OperDatePartner_Sale                              AS OperDatePartner_Sale

           , tmpMovement_ChildEDI.InvNumberPartnerEDI                       AS InvNumberPartnerEDI
           , tmpMovement_ChildEDI.OperDatePartnerEDI                        AS OperDatePartnerEDI
           , COALESCE(tmpMovement_ChildEDI.MovementChildId, 0)              AS EDIId
           , COALESCE(tmpMovement_ChildEDI.Amount, 0)                       AS SendDeclarAmount

           --, COALESCE (tmpMITax1.LineNum, tmpMITax2.LineNum) :: Integer AS LineNum
           , CASE WHEN tmpMI.isAuto = TRUE THEN COALESCE (tmpMITax1.LineNum, tmpMITax2.LineNum) ELSE tmpMI.NPP END :: Integer AS LineNum

           , CASE WHEN tmpContract.ContractId = 888997 --  в корректировках по Сильпо (только по 12 договору) в печатной форме - Все сводные корректировки, которые будут формироваться с привязкой до 01.10.2023 должны выгружаться без отметки "До зведеної податкової накладної".
                   AND vbOperDate_Tax_Tax < '01.10.2023' THEN ''
                  
                --WHEN tmpContract.ContractId = 888997 --  в корректировках по Сильпо (только по 12 договору) в печатной форме - Все сводные корректировки, которые будут формироваться с привязкой до 01.10.2023 должны выгружаться без отметки "До зведеної податкової накладної".
                -- AND vbUserId = 5 THEN EXTRACT (MONTH FROM vbOperDate_Tax_Tax) :: TVarChar
                  
                  WHEN tmpMovement_Data.DocumentTaxKind NOT IN (zc_Enum_DocumentTaxKind_CorrectivePrice(), zc_Enum_DocumentTaxKind_Corrective(),zc_Enum_DocumentTaxKind_Prepay())
                   AND vbOperDate_begin < '01.12.2018' THEN 'X'
                  WHEN tmpMovement_Data.DocumentTaxKind NOT IN (zc_Enum_DocumentTaxKind_CorrectivePrice(), zc_Enum_DocumentTaxKind_Corrective(),zc_Enum_DocumentTaxKind_Prepay(), zc_Enum_DocumentTaxKind_ChangeErr())
                   AND vbOperDate_begin >= '01.12.2018' THEN '4'
                  ELSE ''
             END    AS TaxKind --признак  сводной корректировки

           , tmpMI.NPPTax_calc           :: Integer AS NPPTax_calc
           , tmpMI.NPP_calc              :: Integer AS NPP_calc
           , tmpMI.NPPTaxNew_calc        :: Integer AS NPPTaxNew_calc
           , tmpMI.AmountTax_calc        :: TFloat  AS AmountTax_calc
           , tmpMI.SummTaxDiff_calc      :: TFloat  AS SummTaxDiff_calc
           , tmpMI.PriceTax_calc         :: TFloat  AS PriceTax_calc

             -- № п/п
           , ROW_NUMBER() OVER (ORDER BY CASE WHEN vbIsNPP_calc = TRUE THEN tmpMI.NPP_calc
                                              WHEN tmpMI.isAuto = TRUE THEN COALESCE (tmpMITax1.LineNum, tmpMITax2.LineNum)
                                              ELSE tmpMI.NPP
                                         END
                                       , CASE WHEN tmpMLM_Child.OperDate_rus < zc_DateEnd_GoodsRus() AND tmpGoods.GoodsName_RUS <> '' THEN tmpGoods.GoodsName_RUS ELSE tmpGoods.GoodsName END
                                       , tmpMI.GoodsKindName
                               ) AS Ord


       FROM tmpMI

            LEFT JOIN tmpMovement_ChildEDI ON tmpMovement_ChildEDI.MovementId = tmpMI.MovementId

            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalSumm
                                       ON MovementFloat_TotalSumm.MovementId = tmpMI.MovementId
                                      AND MovementFloat_TotalSumm.DescId     = zc_MovementFloat_TotalSumm()
            LEFT JOIN tmpMovementFloat AS MovementFloat_VATPercent
                                       ON MovementFloat_VATPercent.MovementId =  tmpMI.MovementId
                                      AND MovementFloat_VATPercent.DescId     = zc_MovementFloat_VATPercent()
            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalSummMVAT
                                       ON MovementFloat_TotalSummMVAT.MovementId = tmpMI.MovementId
                                      AND MovementFloat_TotalSummMVAT.DescId     = zc_MovementFloat_TotalSummMVAT()
            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalSummPVAT
                                       ON MovementFloat_TotalSummPVAT.MovementId =  tmpMI.MovementId
                                      AND MovementFloat_TotalSummPVAT.DescId     = zc_MovementFloat_TotalSummPVAT()

            LEFT JOIN tmpContract ON tmpContract.MovementId = tmpMI.MovementId
            LEFT JOIN tmpPersonalSigning ON tmpPersonalSigning.ContractId = tmpContract.ContractId

            LEFT JOIN tmpMB_isCopy AS MovementBoolean_isCopy ON MovementBoolean_isCopy.MovementId = tmpMI.MovementId
            LEFT JOIN tmpMB_PriceWithVAT AS MovementBoolean_PriceWithVAT
                                      ON MovementBoolean_PriceWithVAT.MovementId = tmpMI.MovementId

            LEFT JOIN tmpMovementString AS MovementString_InvNumberBranch
                                     ON MovementString_InvNumberBranch.MovementId = tmpMI.MovementId
                                    AND MovementString_InvNumberBranch.DescId = zc_MovementString_InvNumberBranch()

            LEFT JOIN tmpMovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId = tmpMI.MovementId
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN tmpMovement_Data ON tmpMovement_Data.MovementId = tmpMI.MovementId
            LEFT JOIN Object As Object_DocumentTaxKind ON Object_DocumentTaxKind.Id = tmpMovement_Data.DocumentTaxKind

            LEFT JOIN tmpPersonalBookkeeper ON tmpPersonalBookkeeper.BranchId = tmpMovement_Data.BranchId
            LEFT JOIN tmpMLM_Child ON tmpMLM_Child.MovementId = tmpMI.MovementId

            LEFT JOIN tmpObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_To
                                                                   ON OH_JuridicalDetails_To.JuridicalId = tmpMovement_Data.ToId
                                                                  AND COALESCE (tmpMLM_Child.OperDate_Child, tmpMI.OperDate) >= OH_JuridicalDetails_To.StartDate AND COALESCE (tmpMLM_Child.OperDate_Child, tmpMI.OperDate) < OH_JuridicalDetails_To.EndDate

            LEFT JOIN tmpObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_From
                                                                   ON OH_JuridicalDetails_From.JuridicalId = tmpMovement_Data.FromId
                                                                  AND COALESCE (tmpMLM_Child.OperDate_Child, tmpMI.OperDate) >= OH_JuridicalDetails_From.StartDate AND COALESCE (tmpMLM_Child.OperDate_Child, tmpMI.OperDate) < OH_JuridicalDetails_From.EndDate

            LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                 ON ObjectLink_Juridical_Retail.ObjectId = OH_JuridicalDetails_From.JuridicalId
                                AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
            LEFT JOIN ObjectString AS ObjectString_Retail_OKPO
                                   ON ObjectString_Retail_OKPO.ObjectId = ObjectLink_Juridical_Retail.ChildObjectId
                                  AND ObjectString_Retail_OKPO.DescId = zc_ObjectString_Retail_OKPO()


            LEFT JOIN tmpUKTZED ON tmpUKTZED.GoodsGroupId = tmpMI.GoodsGroupId
            LEFT JOIN tmpTaxImport ON tmpTaxImport.GoodsGroupId = tmpMI.GoodsGroupId
            LEFT JOIN tmpDKPP ON tmpDKPP.GoodsGroupId = tmpMI.GoodsGroupId
            LEFT JOIN tmpTaxAction ON tmpTaxAction.GoodsGroupId = tmpMI.GoodsGroupId
            LEFT JOIN tmpObject_GoodsPropertyValue ON tmpObject_GoodsPropertyValue.GoodsId = tmpMI.GoodsId
                                                  AND tmpObject_GoodsPropertyValue.GoodsKindId = tmpMI.GoodsKindId
            LEFT JOIN tmpObject_GoodsPropertyValueGroup ON tmpObject_GoodsPropertyValueGroup.GoodsId = tmpMI.GoodsId
                                                       AND tmpObject_GoodsPropertyValue.GoodsId IS NULL
            LEFT JOIN tmpObject_GoodsPropertyValue_basis ON tmpObject_GoodsPropertyValue_basis.GoodsId = tmpMI.GoodsId
                                                        AND tmpObject_GoodsPropertyValue_basis.GoodsKindId = tmpMI.GoodsKindId
            LEFT JOIN tmpObject_GoodsPropertyValueGroup_basis ON tmpObject_GoodsPropertyValueGroup_basis.GoodsId = tmpMI.GoodsId
                                                             AND tmpObject_GoodsPropertyValue_basis.GoodsId IS NULL
            LEFT JOIN tmpGoods ON tmpGoods.GoodsId = tmpMI.GoodsId

            ---- номера строк в НН
            LEFT JOIN tmpMITax AS tmpMITax1 ON tmpMITax1.Kind        = 1
                                           AND tmpMITax1.GoodsId     = tmpMI.GoodsId
                                           AND tmpMITax1.GoodsKindId = tmpMI.GoodsKindId
                                           AND tmpMITax1.Price       = tmpMI.Price

            LEFT JOIN tmpMITax AS tmpMITax2 ON tmpMITax2.Kind        = 2
                                           AND tmpMITax2.GoodsId     = tmpMI.GoodsId
                                           AND tmpMITax2.Price       = tmpMI.Price
                                           AND tmpMITax1.GoodsId     IS NULL

            LEFT JOIN tmpReturnIn ON 1 = 1
-- where (vbUserId <> 5 or tmpGoods.GoodsCode = 2281)
     )

    , tmpData AS (SELECT tmpData_all.InvNumberPartner
                         -- !!! только для сортировки !!!
                       , tmpData_all.Ord AS LineNum_order -- tmpData_all.LineNum AS LineNum_order
                         -- !!! ПЕРВАЯ Строка !!!
                       , (CASE WHEN vbIsNPP_calc = TRUE THEN tmpData_all.NPPTax_calc ELSE tmpData_all.LineNum END) :: Integer AS LineNum

                       , tmpData_all.GoodsName
                       , tmpData_all.GoodsKindName

                       , tmpData_all.GoodsName_two
                       , tmpData_all.MeasureName
                       , tmpData_all.MeasureCode

                       , tmpData_all.inMovementId
                       , tmpData_all.MovementId
                       , tmpData_all.InvNumber
                       , tmpData_all.OperDate
                       , tmpData_all.CHARCODE
                       , tmpData_all.N10
                       , tmpData_all.N10_ifin

                       , tmpData_all.N9
                       , CASE WHEN tmpData_all.DocumentTaxKind IN (zc_Enum_DocumentTaxKind_Prepay())
                               AND tmpData_all.AmountTax_calc <> tmpData_all.Amount
                                   THEN '102'  -- 2 --'Зміна кількості'

                              WHEN tmpData_all.DocumentTaxKind NOT IN (zc_Enum_DocumentTaxKind_CorrectivePrice()
                                                                     , zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
                                                                     , zc_Enum_DocumentTaxKind_Goods(), zc_Enum_DocumentTaxKind_Change(), zc_Enum_DocumentTaxKind_ChangeErr()
                                                                     , zc_Enum_DocumentTaxKind_ChangePercent()
                                                                      )
                               AND tmpData_all.AmountTax_calc = tmpData_all.Amount
                                   THEN '103'  --4 --'Повернення товару або авансових платежів'

                              WHEN tmpData_all.DocumentTaxKind IN (zc_Enum_DocumentTaxKind_CorrectivePrice()
                                                                 , zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
                                                                 , zc_Enum_DocumentTaxKind_ChangePercent())
                               AND tmpData_all.AmountTax_calc = tmpData_all.Amount
                                   THEN (tmpData_all.KindCode :: Integer + case when vbUserId = 5 then 0 else 0 end) :: TVarChar

                              WHEN tmpData_all.DocumentTaxKind IN (zc_Enum_DocumentTaxKind_CorrectivePrice()
                                                                 , zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
                                                                 , zc_Enum_DocumentTaxKind_ChangePercent()
                                                                 )
                               AND vbDocumentTaxKindId_tax IN (zc_Enum_DocumentTaxKind_TaxSummaryJuridicalS()
                                                             , zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR()
                                                             , zc_Enum_DocumentTaxKind_TaxSummaryPartnerS()
                                                             , zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR())
                                   THEN '104'

                              ELSE tmpData_all.KindCode
                         END AS KindCode

                       , CASE WHEN (tmpData_all.DocumentTaxKind NOT IN (zc_Enum_DocumentTaxKind_CorrectivePrice(), zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
                                                                      , zc_Enum_DocumentTaxKind_Goods(), zc_Enum_DocumentTaxKind_Change(), zc_Enum_DocumentTaxKind_ChangeErr()
                                                                      , zc_Enum_DocumentTaxKind_ChangePercent())
                                 OR vbDocumentTaxKindId_tax IN (zc_Enum_DocumentTaxKind_TaxSummaryJuridicalS()
                                                              , zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR()
                                                              , zc_Enum_DocumentTaxKind_TaxSummaryPartnerS()
                                                              , zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR()))
                               AND tmpData_all.AmountTax_calc = tmpData_all.Amount
                                   THEN 'Повернення товару або авансових платежів'

                              ELSE tmpData_all.KindName

                         END :: TVarChar AS KindName

                       , tmpData_all.PriceWithVAT
                       , tmpData_all.VATPercent
                       , tmpData_all.InvNumberPartner_ifin

                       , tmpData_all.TotalSummVAT
                       , tmpData_all.TotalSummMVAT
                       , tmpData_all.TotalSummPVAT
                       , tmpData_all.TotalSumm

                       , tmpData_all.ContractName
                       , tmpData_all.ContractSigningDate
                       , tmpData_all.ContractKind
                       , tmpData_all.PartnerCode

                       , tmpData_all.InvNumber_Child
                       , tmpData_all.OperDate_Child
                       , tmpData_all.OperDate_begin_Child

                       , tmpData_all.CopyForClient
                       , tmpData_all.CopyForUs

                       , tmpData_all.x11
                       , tmpData_all.x12
                       , tmpData_all.PZOB           -- поле для Медка
                       , tmpData_all.OperDate_begin -- поле для Медка

                       , tmpData_all.isERPN -- Підлягає реєстрації в ЄРПН покупцем !!!так криво для медка до 01.04.2016!!!

                       , tmpData_all.ERPN -- Підлягає реєстрації в ЄРПН постачальником (продавцем)

                       , tmpData_all.ERPN2 -- Підлягає реєстрації в ЄРПН покупцем

                       , tmpData_all.NotNDSPayer
                       , tmpData_all.isNotNDSPayer
                       , tmpData_all.NotNDSPayerC1
                       , tmpData_all.NotNDSPayerC2

                       , tmpData_all.PartnerAddress_From

                       , tmpData_all.JuridicalName_To
                       , tmpData_all.JuridicalAddress_To

                       , tmpData_all.OKPO_To
                       , tmpData_all.OKPO_To_ifin
                       , tmpData_all.INN_To
                       , tmpData_all.NumberVAT_To
                       , tmpData_all.AccounterName_To
                       , tmpData_all.AccounterINN_To

                       , tmpData_all.BankAccount_To
                       , tmpData_all.BankName_To
                       , tmpData_all.BankMFO_To
                       , tmpData_all.Phone_To

                       , tmpData_all.BuyerGLNCode

                       , tmpData_all.SupplierGLNCode

                       , tmpData_all.JuridicalName_From_inf
                       , tmpData_all.JuridicalName_From
                       , tmpData_all.JuridicalName_From_add
                       , tmpData_all.JuridicalAddress_From

                       , tmpData_all.OKPO_From
                       , tmpData_all.OKPO_From_ifin
                       , tmpData_all.INN_From

                       , tmpData_all.InvNumberBranch_From
                       , tmpData_all.NumberVAT_From
                       , tmpData_all.AccounterName_From
                       , tmpData_all.BankAccount_From
                       , tmpData_all.BankName_From
                       , tmpData_all.BankMFO_From
                       , tmpData_all.Phone_From

                       , tmpData_all.Id
                       , tmpData_all.GoodsCode

                       , tmpData_all.GoodsCodeUKTZED

                       , tmpData_all.GoodsCodeTaxImport

                       , tmpData_all.GoodsCodeDKPP

                       , tmpData_all.GoodsCodeTaxAction


                       , tmpData_all.Article_Juridical
                       , tmpData_all.BarCode_Juridical
                       , tmpData_all.ArticleGLN_Juridical
                       , tmpData_all.BarCodeGLN_Juridical

                       , tmpData_all.Amount_orig
                       , (CASE WHEN tmpData_all.DocumentTaxKind IN (zc_Enum_DocumentTaxKind_CorrectivePrice(), zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical(), zc_Enum_DocumentTaxKind_ChangePercent())
                                AND vbIsNPP_calc = TRUE
                                AND tmpData_all.AmountTax_calc = tmpData_all.Amount
                                    -- !!!Корр. цены - Все кол-во!!!
                                    THEN (tmpData_all.Amount_orig * tmpData_all.Price_orig / CASE WHEN tmpData_all.CountForPrice_orig > 0 THEN tmpData_all.CountForPrice_orig ELSE 1 END) :: NUMERIC (16, 2)

                               WHEN tmpData_all.DocumentTaxKind IN (zc_Enum_DocumentTaxKind_CorrectivePrice(), zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical(), zc_Enum_DocumentTaxKind_ChangePercent())
                                AND vbIsNPP_calc = TRUE
                                AND vbDocumentTaxKindId_tax NOT IN (zc_Enum_DocumentTaxKind_TaxSummaryJuridicalS()
                                                                  , zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR()
                                                                  , zc_Enum_DocumentTaxKind_TaxSummaryPartnerS()
                                                                  , zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR())
                                    -- !!!Корр. цены!!!
                                    THEN 0 -- (tmpData_all.Amount_for_PriceCor * tmpData_all.PriceTax_calc) :: NUMERIC (16, 2)

                               WHEN tmpData_all.CountForPrice_orig > 0
                                    THEN (tmpData_all.Amount_orig * tmpData_all.Price_orig / tmpData_all.CountForPrice_orig) :: NUMERIC (16, 2)

                               ELSE (tmpData_all.Amount_orig * tmpData_all.Price_orig) :: NUMERIC (16, 2)
                          END
                         ) :: TFloat AS AmountSumm_orig

                         -- !!! ПЕРВАЯ Строка !!!
                       , CASE WHEN tmpData_all.DocumentTaxKind IN (zc_Enum_DocumentTaxKind_CorrectivePrice()
                                                                 , zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
                                                                 , zc_Enum_DocumentTaxKind_ChangePercent())
                                AND tmpData_all.AmountTax_calc = tmpData_all.Amount
                                   THEN -- !!!Корр. цены - Все кол-во!!!
                                        0

                              WHEN tmpData_all.DocumentTaxKind IN (zc_Enum_DocumentTaxKind_CorrectivePrice()
                                                                 , zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
                                                                 , zc_Enum_DocumentTaxKind_ChangePercent())
                               AND vbDocumentTaxKindId_tax NOT IN (zc_Enum_DocumentTaxKind_TaxSummaryJuridicalS()
                                                                 , zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR()
                                                                 , zc_Enum_DocumentTaxKind_TaxSummaryPartnerS()
                                                                 , zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR())
                                   THEN 0 -- !!!Корр. цены!!!

                              ELSE CASE WHEN vbIsNPP_calc = TRUE THEN tmpData_all.AmountTax_calc ELSE tmpData_all.Amount END

                         END :: TFloat AS Amount

                       , CASE WHEN tmpData_all.DocumentTaxKind IN (zc_Enum_DocumentTaxKind_CorrectivePrice()
                                                                 , zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
                                                                 , zc_Enum_DocumentTaxKind_ChangePercent())
                                AND tmpData_all.AmountTax_calc = tmpData_all.Amount
                                   THEN -- !!!Корр. цены - Все кол-во!!!
                                        0
                              ELSE tmpData_all.Price
                         END :: TFloat AS Price

                         -- !!!Корр. цены!!!
                       , CASE WHEN tmpData_all.DocumentTaxKind IN (zc_Enum_DocumentTaxKind_CorrectivePrice()
                                                                 , zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
                                                                 , zc_Enum_DocumentTaxKind_ChangePercent())
                                AND tmpData_all.AmountTax_calc = tmpData_all.Amount
                                   THEN -- Все кол-во
                                        tmpData_all.Amount_for_PriceCor_two
                              ELSE tmpData_all.Amount_for_PriceCor
                         END :: TFloat AS Amount_for_PriceCor

                         -- !!! ПЕРВАЯ Строка - Корр. цены!!!
                       , CASE WHEN vbIsNPP_calc = FALSE
                               AND tmpData_all.DocumentTaxKind IN (zc_Enum_DocumentTaxKind_CorrectivePrice()
                                                                 , zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
                                                                 , zc_Enum_DocumentTaxKind_ChangePercent())
                               AND tmpData_all.AmountTax_calc = tmpData_all.Amount
                                   THEN -- Все кол-во
                                        tmpData_all.Price_for_PriceCor_two

                              WHEN vbIsNPP_calc = FALSE
                                   THEN tmpData_all.Price_for_PriceCor

                              WHEN tmpData_all.DocumentTaxKind IN (zc_Enum_DocumentTaxKind_CorrectivePrice()
                                                                 , zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
                                                                 , zc_Enum_DocumentTaxKind_ChangePercent())
                               AND tmpData_all.AmountTax_calc = tmpData_all.Amount
                                   THEN -- Все кол-во
                                        tmpData_all.PriceTax_calc

                              WHEN tmpData_all.DocumentTaxKind IN (zc_Enum_DocumentTaxKind_CorrectivePrice()
                                                                 , zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
                                                                 , zc_Enum_DocumentTaxKind_ChangePercent()
                                                                 )
                               AND vbDocumentTaxKindId_tax NOT IN (zc_Enum_DocumentTaxKind_TaxSummaryJuridicalS()
                                                                 , zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR()
                                                                 , zc_Enum_DocumentTaxKind_TaxSummaryPartnerS()
                                                                 , zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR()
                                                                  )
                                   THEN tmpData_all.PriceTax_calc
                              ELSE 0
                         END :: TFloat AS Price_for_PriceCor

                         -- !!! ПЕРВАЯ Строка !!!
                       , (CASE WHEN tmpData_all.DocumentTaxKind IN (zc_Enum_DocumentTaxKind_CorrectivePrice()
                                                                  , zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
                                                                  , zc_Enum_DocumentTaxKind_ChangePercent())
                                AND tmpData_all.AmountTax_calc = tmpData_all.Amount
                                AND vbIsNPP_calc = TRUE
                                    -- !!!Корр. цены - Все кол-во!!!
                                    THEN (tmpData_all.AmountTax_calc * tmpData_all.PriceTax_calc) :: NUMERIC (16, 2)

                               WHEN tmpData_all.DocumentTaxKind IN (zc_Enum_DocumentTaxKind_CorrectivePrice()
                                                                  , zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
                                                                  , zc_Enum_DocumentTaxKind_ChangePercent()
                                                                  )
                                AND vbDocumentTaxKindId_tax NOT IN (zc_Enum_DocumentTaxKind_TaxSummaryJuridicalS()
                                                                  , zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR()
                                                                  , zc_Enum_DocumentTaxKind_TaxSummaryPartnerS()
                                                                  , zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR()
                                                                   )
                                AND vbIsNPP_calc = TRUE
                                    -- !!!Корр. цены - НЕ СВОДНАЯ НАЛОГ!!!
                                    THEN (tmpData_all.Amount_for_PriceCor * tmpData_all.PriceTax_calc) :: NUMERIC (16, 2)

                               WHEN tmpData_all.DocumentTaxKind IN (zc_Enum_DocumentTaxKind_CorrectivePrice()
                                                                  , zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
                                                                  , zc_Enum_DocumentTaxKind_ChangePercent()
                                                                  )
                               AND vbDocumentTaxKindId_tax IN (zc_Enum_DocumentTaxKind_TaxSummaryJuridicalS()
                                                             , zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR()
                                                             , zc_Enum_DocumentTaxKind_TaxSummaryPartnerS()
                                                             , zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR()
                                                              )
                                AND vbIsNPP_calc = TRUE
                                    -- !!!Корр. цены - СВОДНАЯ НАЛОГ!!!
                                    THEN (tmpData_all.AmountTax_calc * tmpData_all.PriceTax_calc) :: NUMERIC (16, 2)

                               WHEN tmpData_all.CountForPrice_orig > 0
                                    THEN ((COALESCE (CASE WHEN vbIsNPP_calc = TRUE THEN tmpData_all.AmountTax_calc ELSE tmpData_all.Amount_orig END, 0))
                                        * tmpData_all.Price_orig / tmpData_all.CountForPrice_orig) :: NUMERIC (16, 2)
                               ELSE ((COALESCE (CASE WHEN vbIsNPP_calc = TRUE THEN tmpData_all.AmountTax_calc ELSE tmpData_all.Amount_orig END, 0)) * tmpData_all.Price_orig) :: NUMERIC (16, 2)
                          END
                        + tmpData_all.SummTaxDiff_calc
                         ) :: TFloat AS AmountSumm

                       , tmpData_all.InvNumberBranch
                       , tmpData_all.InvNumberBranch_Child

                       , tmpData_all.InvNumberMark
                       , tmpData_all.OperDatePartner_ReturnIn
                       , tmpData_all.InvNumberPartner_ReturnIn

                       , tmpData_all.InvNumber_Sale
                       , tmpData_all.InvNumberPartner_Sale
                       , tmpData_all.InvNumberOrder_Sale
                       , tmpData_all.OperDatePartner_Sale

                       , tmpData_all.InvNumberPartnerEDI
                       , tmpData_all.OperDatePartnerEDI
                       , tmpData_all.EDIId
                       , tmpData_all.SendDeclarAmount

                       , tmpData_all.TaxKind -- признак  сводной корректировки

                  FROM tmpData_all
                 UNION ALL
                  SELECT
                         tmpData_all.InvNumberPartner
                         -- !!! только для сортировки !!!
                       , tmpData_all.Ord AS LineNum_order -- tmpData_all.LineNum AS LineNum_order
                         -- !!! ВТОРАЯ Строка !!!
                       , tmpData_all.NPP_calc AS LineNum

                       , tmpData_all.GoodsName
                       , tmpData_all.GoodsKindName

                       , tmpData_all.GoodsName_two
                       , tmpData_all.MeasureName
                       , tmpData_all.MeasureCode

                       , tmpData_all.inMovementId
                       , tmpData_all.MovementId
                       , tmpData_all.InvNumber
                       , tmpData_all.OperDate
                       , tmpData_all.CHARCODE
                       , tmpData_all.N10
                       , tmpData_all.N10_ifin

                       , tmpData_all.N9
                       , CASE WHEN tmpData_all.DocumentTaxKind IN (zc_Enum_DocumentTaxKind_Prepay())
                               AND tmpData_all.AmountTax_calc <> tmpData_all.Amount
                                   THEN '102'  -- 2 --'Зміна кількості'

                              WHEN tmpData_all.DocumentTaxKind IN (zc_Enum_DocumentTaxKind_CorrectivePrice()
                                                                 , zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
                                                                 , zc_Enum_DocumentTaxKind_ChangePercent()
                                                                  )
                               AND vbDocumentTaxKindId_tax IN (zc_Enum_DocumentTaxKind_TaxSummaryJuridicalS()
                                                             , zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR()
                                                             , zc_Enum_DocumentTaxKind_TaxSummaryPartnerS()
                                                             , zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR()
                                                              )
                                   THEN '104'
                              ELSE tmpData_all.KindCode
                         END AS KindCode
                       , tmpData_all.KindName
                       , tmpData_all.PriceWithVAT
                       , tmpData_all.VATPercent
                       , tmpData_all.InvNumberPartner_ifin

                       , tmpData_all.TotalSummVAT
                       , tmpData_all.TotalSummMVAT
                       , tmpData_all.TotalSummPVAT
                       , tmpData_all.TotalSumm

                       , tmpData_all.ContractName
                       , tmpData_all.ContractSigningDate
                       , tmpData_all.ContractKind
                       , tmpData_all.PartnerCode

                       , tmpData_all.InvNumber_Child
                       , tmpData_all.OperDate_Child
                       , tmpData_all.OperDate_begin_Child

                       , tmpData_all.CopyForClient
                       , tmpData_all.CopyForUs

                       , tmpData_all.x11
                       , tmpData_all.x12
                       , tmpData_all.PZOB           -- поле для Медка
                       , tmpData_all.OperDate_begin -- поле для Медка

                       , tmpData_all.isERPN -- Підлягає реєстрації в ЄРПН покупцем !!!так криво для медка до 01.04.2016!!!

                       , tmpData_all.ERPN -- Підлягає реєстрації в ЄРПН постачальником (продавцем)

                       , tmpData_all.ERPN2 -- Підлягає реєстрації в ЄРПН покупцем

                       , tmpData_all.NotNDSPayer
                       , tmpData_all.isNotNDSPayer
                       , tmpData_all.NotNDSPayerC1
                       , tmpData_all.NotNDSPayerC2

                       , tmpData_all.PartnerAddress_From

                       , tmpData_all.JuridicalName_To
                       , tmpData_all.JuridicalAddress_To

                       , tmpData_all.OKPO_To
                       , tmpData_all.OKPO_To_ifin
                       , tmpData_all.INN_To
                       , tmpData_all.NumberVAT_To
                       , tmpData_all.AccounterName_To
                       , tmpData_all.AccounterINN_To

                       , tmpData_all.BankAccount_To
                       , tmpData_all.BankName_To
                       , tmpData_all.BankMFO_To
                       , tmpData_all.Phone_To

                       , tmpData_all.BuyerGLNCode

                       , tmpData_all.SupplierGLNCode

                       , tmpData_all.JuridicalName_From_inf
                       , tmpData_all.JuridicalName_From
                       , tmpData_all.JuridicalName_From_add
                       , tmpData_all.JuridicalAddress_From

                       , tmpData_all.OKPO_From
                       , tmpData_all.OKPO_From_ifin
                       , tmpData_all.INN_From

                       , tmpData_all.InvNumberBranch_From
                       , tmpData_all.NumberVAT_From
                       , tmpData_all.AccounterName_From
                       , tmpData_all.BankAccount_From
                       , tmpData_all.BankName_From
                       , tmpData_all.BankMFO_From
                       , tmpData_all.Phone_From

                       , tmpData_all.Id
                       , tmpData_all.GoodsCode

                       , tmpData_all.GoodsCodeUKTZED

                       , tmpData_all.GoodsCodeTaxImport

                       , tmpData_all.GoodsCodeDKPP

                       , tmpData_all.GoodsCodeTaxAction

                       , tmpData_all.Article_Juridical
                       , tmpData_all.BarCode_Juridical
                       , tmpData_all.ArticleGLN_Juridical
                       , tmpData_all.BarCodeGLN_Juridical

                       , tmpData_all.Amount_orig
                       , CASE WHEN tmpData_all.DocumentTaxKind IN (zc_Enum_DocumentTaxKind_CorrectivePrice()
                                                                 , zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
                                                                 , zc_Enum_DocumentTaxKind_ChangePercent()
                                                                 )
                               AND vbDocumentTaxKindId_tax NOT IN (zc_Enum_DocumentTaxKind_TaxSummaryJuridicalS()
                                                                 , zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR()
                                                                 , zc_Enum_DocumentTaxKind_TaxSummaryPartnerS()
                                                                 , zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR()
                                                                  )
                                   -- !!!Корр. цены!!!
                                    THEN 0 -- (tmpData_all.Amount_for_PriceCor * tmpData_all.PriceTax_calc) :: NUMERIC (16, 2)

                               WHEN tmpData_all.CountForPrice_orig > 0
                                    THEN (tmpData_all.Amount_orig * tmpData_all.Price_orig / tmpData_all.CountForPrice_orig) :: NUMERIC (16, 2)
                               ELSE (tmpData_all.Amount_orig * tmpData_all.Price_orig) :: NUMERIC (16, 2)
                         END :: TFloat AS AmountSumm_orig

                         -- !!! ВТОРАЯ Строка !!!
                       , CASE WHEN tmpData_all.DocumentTaxKind IN (zc_Enum_DocumentTaxKind_CorrectivePrice()
                                                                 , zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
                                                                 , zc_Enum_DocumentTaxKind_ChangePercent()
                                                                 )
                               AND vbDocumentTaxKindId_tax NOT IN (zc_Enum_DocumentTaxKind_TaxSummaryJuridicalS()
                                                                 , zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR()
                                                                 , zc_Enum_DocumentTaxKind_TaxSummaryPartnerS()
                                                                 , zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR()
                                                                  )
                                   THEN 0 -- !!!Корр. цены!!!
                              ELSE -1 * (tmpData_all.AmountTax_calc - tmpData_all.Amount)
                         END :: TFloat AS Amount

                       , tmpData_all.Price

                       , tmpData_all.Amount_for_PriceCor
                         -- !!! ВТОРАЯ Строка - Корр. цены!!!
                       , CASE WHEN tmpData_all.DocumentTaxKind IN (zc_Enum_DocumentTaxKind_CorrectivePrice()
                                                                 , zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
                                                                 , zc_Enum_DocumentTaxKind_ChangePercent()
                                                                 )
                               AND vbDocumentTaxKindId_tax NOT IN (zc_Enum_DocumentTaxKind_TaxSummaryJuridicalS()
                                                                 , zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR()
                                                                 , zc_Enum_DocumentTaxKind_TaxSummaryPartnerS()
                                                                 , zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR()
                                                                  )
                                    THEN -1 * (tmpData_all.PriceTax_calc - tmpData_all.Price_for_PriceCor)
                               ELSE 0
                         END :: TFloat AS Price_for_PriceCor

                         -- !!! ВТОРАЯ Строка !!!
                       , CASE WHEN tmpData_all.DocumentTaxKind IN (zc_Enum_DocumentTaxKind_CorrectivePrice()
                                                                 , zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
                                                                 , zc_Enum_DocumentTaxKind_ChangePercent()
                                                                 )
                               AND vbDocumentTaxKindId_tax NOT IN (zc_Enum_DocumentTaxKind_TaxSummaryJuridicalS()
                                                                 , zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR()
                                                                 , zc_Enum_DocumentTaxKind_TaxSummaryPartnerS()
                                                                 , zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR()
                                                                  )
                                   -- !!!Корр. цены - НЕ СВОДНАЯ НАЛОГ!!!
                                   THEN (tmpData_all.Amount_for_PriceCor * -1 * (tmpData_all.PriceTax_calc - tmpData_all.Price_for_PriceCor)) :: NUMERIC (16, 2)

                              WHEN tmpData_all.DocumentTaxKind IN (zc_Enum_DocumentTaxKind_CorrectivePrice()
                                                                 , zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
                                                                 , zc_Enum_DocumentTaxKind_ChangePercent()
                                                                 )
                               AND vbDocumentTaxKindId_tax IN (zc_Enum_DocumentTaxKind_TaxSummaryJuridicalS()
                                                             , zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR()
                                                             , zc_Enum_DocumentTaxKind_TaxSummaryPartnerS()
                                                             , zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR()
                                                              )
                                   -- !!!Корр. цены - СВОДНАЯ НАЛОГ!!!
                                   THEN ((COALESCE (-1 * (tmpData_all.AmountTax_calc - tmpData_all.Amount), 0)) * tmpData_all.PriceTax_calc) :: NUMERIC (16, 2)

                              WHEN tmpData_all.CountForPrice_orig > 0
                                   THEN ((COALESCE (-1 * (tmpData_all.AmountTax_calc - tmpData_all.Amount), 0)) * tmpData_all.Price_orig / tmpData_all.CountForPrice_orig) :: NUMERIC (16, 2)
                              ELSE ((COALESCE (-1 * (tmpData_all.AmountTax_calc - tmpData_all.Amount), 0)) * tmpData_all.Price_orig) :: NUMERIC (16, 2)
                         END :: TFloat AS AmountSumm

                       , tmpData_all.InvNumberBranch
                       , tmpData_all.InvNumberBranch_Child

                       , tmpData_all.InvNumberMark
                       , tmpData_all.OperDatePartner_ReturnIn
                       , tmpData_all.InvNumberPartner_ReturnIn

                       , tmpData_all.InvNumber_Sale
                       , tmpData_all.InvNumberPartner_Sale
                       , tmpData_all.InvNumberOrder_Sale
                       , tmpData_all.OperDatePartner_Sale

                       , tmpData_all.InvNumberPartnerEDI
                       , tmpData_all.OperDatePartnerEDI
                       , tmpData_all.EDIId
                       , tmpData_all.SendDeclarAmount

                       , tmpData_all.TaxKind -- признак  сводной корректировки

                   FROM tmpData_all
                   WHERE vbIsNPP_calc = TRUE
                         -- !!!важно - если НЕ все кол-во!!!
                     AND tmpData_all.AmountTax_calc <> COALESCE (tmpData_all.Amount, 0)
                         -- !!!важно - показали ТОЛЬКО если есть еще что возвращать!!!
                     AND (tmpData_all.AmountTax_calc <> tmpData_all.Amount
                          -- или !!!Корр. цены!!!
                       OR tmpData_all.DocumentTaxKind IN (zc_Enum_DocumentTaxKind_CorrectivePrice()
                                                        , zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
                                                        , zc_Enum_DocumentTaxKind_ChangePercent()
                                                        , zc_Enum_DocumentTaxKind_Goods(), zc_Enum_DocumentTaxKind_Change(), zc_Enum_DocumentTaxKind_ChangeErr()
                                                         ))


                 UNION ALL
                  SELECT
                         tmpData_all.InvNumberPartner
                         -- !!! только для сортировки !!!
                       , tmpData_all.Ord AS LineNum_order -- tmpData_all.LineNum AS LineNum_order
                         -- !!! ТРЕТЬЯ Строка !!!
                       , tmpData_all.NPPTaxNew_calc AS LineNum

                       , tmpData_all.GoodsName
                       , tmpData_all.GoodsKindName

                       , tmpData_all.GoodsName_two
                       , tmpData_all.MeasureName
                       , tmpData_all.MeasureCode

                       , tmpData_all.inMovementId
                       , tmpData_all.MovementId
                       , tmpData_all.InvNumber
                       , tmpData_all.OperDate
                       , tmpData_all.CHARCODE
                       , tmpData_all.N10
                       , tmpData_all.N10_ifin

                       , tmpData_all.N9
                       , CASE WHEN tmpData_all.DocumentTaxKind IN (zc_Enum_DocumentTaxKind_CorrectivePrice()
                                                                 , zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
                                                                 , zc_Enum_DocumentTaxKind_ChangePercent()
                                                                  )
                               AND tmpData_all.AmountTax_calc = tmpData_all.Amount
                                   THEN tmpData_all.KindCode
                              WHEN tmpData_all.DocumentTaxKind IN (zc_Enum_DocumentTaxKind_CorrectivePrice()
                                                                 , zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
                                                                 , zc_Enum_DocumentTaxKind_ChangePercent()
                                                                  )
                               AND vbDocumentTaxKindId_tax IN (zc_Enum_DocumentTaxKind_TaxSummaryJuridicalS()
                                                             , zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR()
                                                             , zc_Enum_DocumentTaxKind_TaxSummaryPartnerS()
                                                             , zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR()
                                                              )
                                   THEN '104'
                              
                              ELSE tmpData_all.KindCode
                         END AS KindCode
                       , tmpData_all.KindName
                       , tmpData_all.PriceWithVAT
                       , tmpData_all.VATPercent
                       , tmpData_all.InvNumberPartner_ifin

                       , tmpData_all.TotalSummVAT
                       , tmpData_all.TotalSummMVAT
                       , tmpData_all.TotalSummPVAT
                       , tmpData_all.TotalSumm

                       , tmpData_all.ContractName
                       , tmpData_all.ContractSigningDate
                       , tmpData_all.ContractKind
                       , tmpData_all.PartnerCode

                       , tmpData_all.InvNumber_Child
                       , tmpData_all.OperDate_Child
                       , tmpData_all.OperDate_begin_Child

                       , tmpData_all.CopyForClient
                       , tmpData_all.CopyForUs

                       , tmpData_all.x11
                       , tmpData_all.x12
                       , tmpData_all.PZOB           -- поле для Медка
                       , tmpData_all.OperDate_begin -- поле для Медка

                       , tmpData_all.isERPN -- Підлягає реєстрації в ЄРПН покупцем !!!так криво для медка до 01.04.2016!!!

                       , tmpData_all.ERPN -- Підлягає реєстрації в ЄРПН постачальником (продавцем)

                       , tmpData_all.ERPN2 -- Підлягає реєстрації в ЄРПН покупцем

                       , tmpData_all.NotNDSPayer
                       , tmpData_all.isNotNDSPayer
                       , tmpData_all.NotNDSPayerC1
                       , tmpData_all.NotNDSPayerC2

                       , tmpData_all.PartnerAddress_From

                       , tmpData_all.JuridicalName_To
                       , tmpData_all.JuridicalAddress_To

                       , tmpData_all.OKPO_To
                       , tmpData_all.OKPO_To_ifin
                       , tmpData_all.INN_To
                       , tmpData_all.NumberVAT_To
                       , tmpData_all.AccounterName_To
                       , tmpData_all.AccounterINN_To

                       , tmpData_all.BankAccount_To
                       , tmpData_all.BankName_To
                       , tmpData_all.BankMFO_To
                       , tmpData_all.Phone_To

                       , tmpData_all.BuyerGLNCode

                       , tmpData_all.SupplierGLNCode

                       , tmpData_all.JuridicalName_From_inf
                       , tmpData_all.JuridicalName_From
                       , tmpData_all.JuridicalName_From_add
                       , tmpData_all.JuridicalAddress_From

                       , tmpData_all.OKPO_From
                       , tmpData_all.OKPO_From_ifin
                       , tmpData_all.INN_From

                       , tmpData_all.InvNumberBranch_From
                       , tmpData_all.NumberVAT_From
                       , tmpData_all.AccounterName_From
                       , tmpData_all.BankAccount_From
                       , tmpData_all.BankName_From
                       , tmpData_all.BankMFO_From
                       , tmpData_all.Phone_From

                       , tmpData_all.Id
                       , tmpData_all.GoodsCode

                       , tmpData_all.GoodsCodeUKTZED

                       , tmpData_all.GoodsCodeTaxImport

                       , tmpData_all.GoodsCodeDKPP

                       , tmpData_all.GoodsCodeTaxAction

                       , tmpData_all.Article_Juridical
                       , tmpData_all.BarCode_Juridical
                       , tmpData_all.ArticleGLN_Juridical
                       , tmpData_all.BarCodeGLN_Juridical

                       , tmpData_all.Amount_orig
                       , CASE WHEN tmpData_all.DocumentTaxKind IN (zc_Enum_DocumentTaxKind_CorrectivePrice()
                                                                 , zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
                                                                 , zc_Enum_DocumentTaxKind_ChangePercent()
                                                                 )
                               AND tmpData_all.AmountTax_calc = tmpData_all.Amount
                                   -- !!!Корр. цены!!!
                                    THEN (tmpData_all.Amount_orig * tmpData_all.Price_orig / CASE WHEN tmpData_all.CountForPrice_orig > 0 THEN tmpData_all.CountForPrice_orig ELSE 1 END) :: NUMERIC (16, 2)

                              WHEN tmpData_all.DocumentTaxKind IN (zc_Enum_DocumentTaxKind_CorrectivePrice()
                                                                 , zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
                                                                 , zc_Enum_DocumentTaxKind_ChangePercent()
                                                                 )
                               AND vbDocumentTaxKindId_tax NOT IN (zc_Enum_DocumentTaxKind_TaxSummaryJuridicalS()
                                                                 , zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR()
                                                                 , zc_Enum_DocumentTaxKind_TaxSummaryPartnerS()
                                                                 , zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR())
                                   -- !!!Корр. цены!!!
                                    THEN 0 -- (tmpData_all.Amount_for_PriceCor * tmpData_all.PriceTax_calc) :: NUMERIC (16, 2)

                              WHEN tmpData_all.CountForPrice_orig > 0
                                   THEN (tmpData_all.Amount_orig * tmpData_all.Price_orig / tmpData_all.CountForPrice_orig) :: NUMERIC (16, 2)
                              ELSE (tmpData_all.Amount_orig * tmpData_all.Price_orig) :: NUMERIC (16, 2)
                         END :: TFloat AS AmountSumm_orig

                         -- !!! ТРЕТЬЯ Строка !!!
                       , CASE WHEN 1=0
                                   THEN 0 -- !!!Корр. цены!!!
                              WHEN tmpData_all.AmountTax_calc = tmpData_all.Amount
                                   THEN 0 -- !!!Корр. цены!!!
                              ELSE -1 * tmpData_all.Amount
                         END :: TFloat AS Amount

                       , CASE WHEN tmpData_all.AmountTax_calc = tmpData_all.Amount
                                   THEN 0 -- !!!Корр. цены!!!
                              ELSE (tmpData_all.PriceTax_calc - tmpData_all.Price_orig)
                         END :: TFloat AS Price

                       , CASE WHEN tmpData_all.AmountTax_calc = tmpData_all.Amount
                                   THEN 1 * tmpData_all.Amount -- !!!Корр. цены!!!
                              ELSE 0
                         END :: TFloat AS Amount_for_PriceCor

                         -- !!! ТРЕТЬЯ Строка - Корр. цены!!!
                       , CASE WHEN tmpData_all.AmountTax_calc = tmpData_all.Amount
                                   THEN -1 * (tmpData_all.PriceTax_calc - tmpData_all.Price_orig) -- !!!Корр. цены!!!
                              ELSE 0
                         END :: TFloat AS Price_for_PriceCor

                         -- !!! ТРЕТЬЯ Строка !!!
                       , CASE WHEN tmpData_all.CountForPrice_orig > 0
                                   THEN (COALESCE (-1 * tmpData_all.Amount, 0) * (tmpData_all.PriceTax_calc - tmpData_all.Price_orig) / tmpData_all.CountForPrice_orig) :: NUMERIC (16, 2)
                              ELSE (COALESCE (-1 * tmpData_all.Amount, 0) * (tmpData_all.PriceTax_calc - tmpData_all.Price_orig)) :: NUMERIC (16, 2)
                         END :: TFloat AS AmountSumm

                       , tmpData_all.InvNumberBranch
                       , tmpData_all.InvNumberBranch_Child

                       , tmpData_all.InvNumberMark
                       , tmpData_all.OperDatePartner_ReturnIn
                       , tmpData_all.InvNumberPartner_ReturnIn

                       , tmpData_all.InvNumber_Sale
                       , tmpData_all.InvNumberPartner_Sale
                       , tmpData_all.InvNumberOrder_Sale
                       , tmpData_all.OperDatePartner_Sale

                       , tmpData_all.InvNumberPartnerEDI
                       , tmpData_all.OperDatePartnerEDI
                       , tmpData_all.EDIId
                       , tmpData_all.SendDeclarAmount

                       , tmpData_all.TaxKind -- признак  сводной корректировки

                   FROM tmpData_all
                   WHERE vbIsNPP_calc = TRUE
                     AND tmpData_all.DocumentTaxKind IN (zc_Enum_DocumentTaxKind_CorrectivePrice()
                                                       , zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
                                                       , zc_Enum_DocumentTaxKind_ChangePercent()
                                                       )
                     AND vbDocumentTaxKindId_tax IN (zc_Enum_DocumentTaxKind_TaxSummaryJuridicalS()
                                                   , zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR()
                                                   , zc_Enum_DocumentTaxKind_TaxSummaryPartnerS()
                                                   , zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR()
                                                    )
                  )


      -- РЕЗУЛЬТАТ
      SELECT tmpData_all.InvNumberPartner
             -- !!! только для сортировки !!!
           , tmpData_all.LineNum_order :: Integer As LineNum_order -- tmpData_all.LineNum AS LineNum_order

           , tmpData_all.LineNum       :: Integer As LineNum

           , tmpData_all.GoodsName
           , tmpData_all.GoodsKindName

           , tmpData_all.GoodsName_two
           , tmpData_all.MeasureName
           , tmpData_all.MeasureCode

           , tmpData_all.inMovementId
           , tmpData_all.MovementId
           , tmpData_all.InvNumber
           , tmpData_all.OperDate
           , tmpData_all.CHARCODE
           , tmpData_all.N10
           , tmpData_all.N10_ifin

           , tmpData_all.N9
           , tmpData_all.KindCode
           , tmpData_all.KindName

           , tmpData_all.PriceWithVAT
           , tmpData_all.VATPercent
           , tmpData_all.InvNumberPartner_ifin

           /*, CASE WHEN vbOperDate_begin <  '01.12.2018' THEN tmpData_all.TotalSummVAT
                  WHEN vbOperDate_begin >= '01.12.2018' THEN tmpMI_SummVat.SummVat
             END AS TotalSummVAT*/

           , tmpData_all.TotalSummVAT
           , tmpData_all.TotalSummMVAT
           , tmpData_all.TotalSummPVAT
           , tmpData_all.TotalSumm

           , tmpData_all.ContractName
           , tmpData_all.ContractSigningDate
           , tmpData_all.ContractKind
           , tmpData_all.PartnerCode

           , tmpData_all.InvNumber_Child
           , tmpData_all.OperDate_Child
           , tmpData_all.OperDate_begin_Child

           , tmpData_all.CopyForClient
           , tmpData_all.CopyForUs

           , tmpData_all.x11
           , tmpData_all.x12
           , tmpData_all.PZOB           -- поле для Медка
           , tmpData_all.OperDate_begin -- поле для Медка

           , tmpData_all.isERPN -- Підлягає реєстрації в ЄРПН покупцем !!!так криво для медка до 01.04.2016!!!

           , tmpData_all.ERPN -- Підлягає реєстрації в ЄРПН постачальником (продавцем)

           , tmpData_all.ERPN2 -- Підлягає реєстрації в ЄРПН покупцем

           , tmpData_all.NotNDSPayer
           , tmpData_all.isNotNDSPayer
           , tmpData_all.NotNDSPayerC1
           , tmpData_all.NotNDSPayerC2

           , tmpData_all.PartnerAddress_From

           , tmpData_all.JuridicalName_To
           , tmpData_all.JuridicalAddress_To

           , tmpData_all.OKPO_To
           , tmpData_all.OKPO_To_ifin
           , tmpData_all.INN_To
           , tmpData_all.NumberVAT_To
           , tmpData_all.AccounterName_To
           , tmpData_all.AccounterINN_To

           --с 01,03,2021 новый параметр Код - если номер платника податку заполнен  в ячейку ставим 1, иначе пусто
           , CASE WHEN tmpData_all.JuridicalName_To LIKE '%ФОП%'
                   AND LENGTH(trim (tmpData_all.OKPO_To)) = 10
                   AND tmpData_all.INN_To <> '100000000000'
                  THEN '2'
                  WHEN COALESCE (tmpData_all.OKPO_To,'') IN ('100000000000', '300000000000','') 
                  THEN ''
                  ELSE '1'
             END :: TVarChar AS Code_To

           , tmpData_all.BankAccount_To
           , tmpData_all.BankName_To
           , tmpData_all.BankMFO_To
           , tmpData_all.Phone_To

           , tmpData_all.BuyerGLNCode

           , tmpData_all.SupplierGLNCode

           , tmpData_all.JuridicalName_From     :: TVarChar AS JuridicalName_From
           , tmpData_all.JuridicalName_From_add :: TVarChar AS JuridicalName_From_add
           , tmpData_all.JuridicalAddress_From

           , tmpData_all.OKPO_From
           , tmpData_all.OKPO_From_ifin
           , tmpData_all.INN_From

           --с 01,03,2021 новый параметр Код - если номер платника податку заполнен  в ячейку ставим 1, иначе пусто
           , CASE  WHEN tmpData_all.JuridicalName_From_inf LIKE '%ФОП%'
                   AND LENGTH(trim (tmpData_all.OKPO_From)) = 10
                   AND tmpData_all.INN_From <> '100000000000'
                  THEN '2'
                  WHEN COALESCE (tmpData_all.OKPO_From,'') <> ''
                  THEN '1' 
                  ELSE ''
             END ::TVarChar AS Code_From
           
           , tmpData_all.InvNumberBranch_From
           , tmpData_all.NumberVAT_From
           , tmpData_all.AccounterName_From
           , tmpData_all.BankAccount_From
           , tmpData_all.BankName_From
           , tmpData_all.BankMFO_From
           , tmpData_all.Phone_From

           , tmpData_all.Id
           , tmpData_all.GoodsCode

           , tmpData_all.GoodsCodeUKTZED

           , tmpData_all.GoodsCodeTaxImport

           , tmpData_all.GoodsCodeDKPP

           , tmpData_all.GoodsCodeTaxAction


           , tmpData_all.Article_Juridical
           , tmpData_all.BarCode_Juridical
           , tmpData_all.ArticleGLN_Juridical
           , tmpData_all.BarCodeGLN_Juridical
           , tmpData_all.Amount
           , tmpData_all.Price
           , tmpData_all.Amount_for_PriceCor
           , tmpData_all.Price_for_PriceCor
           , tmpData_all.AmountSumm

             -- сумма НДС
           , CASE WHEN tmpData_all.OperDate_begin_Child < '01.12.2018' AND tmpData_all.OperDate_begin >= '01.12.2018' AND tmpData_all.AmountSumm > 0 THEN 0 -- tmpData_all.AmountSumm_orig / 100 * tmpData_all.VATPercent
                  WHEN 1=0 AND tmpData_all.OperDate_begin_Child < '01.12.2018' AND tmpData_all.OperDate_begin >= '01.12.2018' AND tmpData_all.AmountSumm < 0 THEN -1 * tmpData_all.AmountSumm_orig / 100 * tmpData_all.VATPercent
                  ELSE tmpData_all.AmountSumm / 100 * tmpData_all.VATPercent
             END :: TFloat AS SummVat

           , tmpData_all.InvNumberBranch
           , tmpData_all.InvNumberBranch_Child

           , tmpData_all.InvNumberMark
           , tmpData_all.OperDatePartner_ReturnIn
           , tmpData_all.InvNumberPartner_ReturnIn

           , tmpData_all.InvNumber_Sale
           , tmpData_all.InvNumberPartner_Sale
           , tmpData_all.InvNumberOrder_Sale
           , tmpData_all.OperDatePartner_Sale

           , tmpData_all.InvNumberPartnerEDI
           , tmpData_all.OperDatePartnerEDI
           , tmpData_all.EDIId
           , tmpData_all.SendDeclarAmount

           , tmpData_all.TaxKind -- признак  сводной корректировки

      FROM tmpData AS tmpData_all
      ORDER BY 1
             , 2
             , 3
             , 4
             , 5
      ;
     RETURN NEXT Cursor1;


     -- Данные по разнице Возвратов и Всех корректировок
   --CREATE TEMP TABLE tmpCursor2 ON COMMIT DROP AS
     OPEN Cursor2 FOR
     WITH tmpMovement AS
          (SELECT Movement_find.Id
                , MovementLinkMovement_Master.MovementChildId AS MovementId_Return
           FROM Movement
                -- Возврат у Корректировки
                LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Master
                                               ON MovementLinkMovement_Master.MovementId = Movement.Id
                                              AND MovementLinkMovement_Master.DescId = zc_MovementLinkMovement_Master()
                -- печатаем всегда все корректировки
                LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Master_find
                                               ON MovementLinkMovement_Master_find.MovementChildId = MovementLinkMovement_Master.MovementChildId
                                              AND MovementLinkMovement_Master_find.DescId = zc_MovementLinkMovement_Master()
                INNER JOIN Movement AS Movement_find ON Movement_find.Id  = COALESCE (MovementLinkMovement_Master_find.MovementId, Movement.Id)
                                                    AND (Movement_find.StatusId IN (zc_Enum_Status_Complete())
                                                      OR vbDocumentTaxKindId = zc_Enum_DocumentTaxKind_Prepay()
                                                        )
           WHERE Movement.Id     = inMovementId
             AND Movement.DescId = zc_Movement_TaxCorrective()
          UNION
           SELECT MovementLinkMovement_Master.MovementId AS Id
                , Movement.Id AS MovementId_Return
           FROM Movement
                -- Корректировки у Возврата
                INNER JOIN MovementLinkMovement AS MovementLinkMovement_Master
                                                ON MovementLinkMovement_Master.MovementChildId = Movement.Id
                                               AND MovementLinkMovement_Master.DescId = zc_MovementLinkMovement_Master()
                INNER JOIN Movement AS Movement_Master ON Movement_Master.Id  = MovementLinkMovement_Master.MovementId
                                                      AND (Movement_Master.StatusId = zc_Enum_Status_Complete()
                                                        OR vbDocumentTaxKindId = zc_Enum_DocumentTaxKind_Prepay()
                                                          )
           WHERE Movement.Id     = inMovementId
             AND Movement.DescId IN (zc_Movement_ReturnIn(), zc_Movement_TransferDebtIn(), zc_Movement_PriceCorrective())
          )
        , tmpMovementTaxCorrectiveCount AS
          (SELECT COALESCE (COUNT (*), 0) AS CountTaxId FROM tmpMovement)
          -- Суммы в корректировках
        , tmpMovementTaxCorrective AS
          (SELECT tmpMovement.Id
                , COALESCE (MovementFloat_TotalSummPVAT.ValueData, 0) - COALESCE (MovementFloat_TotalSummMVAT.ValueData, 0) AS TotalSummVAT
                , COALESCE (MovementFloat_TotalSummMVAT.ValueData, 0) AS TotalSummMVAT
                , COALESCE (MovementFloat_TotalSummPVAT.ValueData, 0) AS TotalSummPVAT
           FROM tmpMovement
                LEFT JOIN MovementFloat AS MovementFloat_TotalSummMVAT
                                        ON MovementFloat_TotalSummMVAT.MovementId =  tmpMovement.Id
                                       AND MovementFloat_TotalSummMVAT.DescId = zc_MovementFloat_TotalSummMVAT()
                LEFT JOIN MovementFloat AS MovementFloat_TotalSummPVAT
                                        ON MovementFloat_TotalSummPVAT.MovementId =  tmpMovement.Id
                                       AND MovementFloat_TotalSummPVAT.DescId = zc_MovementFloat_TotalSummPVAT()
          )
                 -- zc_MI_Child в Возврате
         , tmpReturnIn_child AS (SELECT MovementItem.ParentId       AS ParentId
                                      , MAX (Movement_Tax.OperDate) AS OperDate_tax
                                 FROM MovementItem
                                      LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                                                  ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                                 AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
                                      LEFT JOIN Movement AS Movement_Sale ON Movement_Sale.Id = MIFloat_MovementId.ValueData :: Integer
                                      LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Tax
                                                                     ON MovementLinkMovement_Tax.MovementId = Movement_Sale.Id
                                                                    AND MovementLinkMovement_Tax.DescId     = zc_MovementLinkMovement_Master()
                                      LEFT JOIN Movement AS Movement_Tax ON Movement_Tax.Id = MovementLinkMovement_Tax.MovementChildId
                                 WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovement.MovementId_Return FROM tmpMovement)
                                   AND MovementItem.DescId     = zc_MI_Child()
                                   AND MovementItem.isErased   = FALSE
                                   AND MovementItem.Amount     <> 0
                                 GROUP BY MovementItem.ParentId
                                 )
          -- zc_MI_Master в Возврате
        , tmpReturnIn AS
          (SELECT MovementItem.ObjectId     			        AS GoodsId
                , CASE WHEN MIFloat_ChangePercent.ValueData <> 0 AND Movement.DescId = zc_Movement_ReturnIn()
                            THEN zfCalc_PriceTruncate (inOperDate     := COALESCE (tmpReturnIn_child.OperDate_tax, COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate))
                                                     , inChangePercent:= MIFloat_ChangePercent.ValueData
                                                     , inPrice        := MIFloat_Price.ValueData
                                                     , inIsWithVAT    := COALESCE (MovementBoolean_PriceWithVAT.ValueData, FALSE)
                                                      )
                       WHEN MovementFloat_ChangePercent.ValueData <> 0 AND Movement.DescId <> zc_Movement_ReturnIn()
                            THEN zfCalc_PriceTruncate (inOperDate     := COALESCE (tmpReturnIn_child.OperDate_tax, COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate))
                                                     , inChangePercent:= MovementFloat_ChangePercent.ValueData
                                                     , inPrice        := MIFloat_Price.ValueData
                                                     , inIsWithVAT    := COALESCE (MovementBoolean_PriceWithVAT.ValueData, FALSE)
                                                      )
                       ELSE COALESCE (MIFloat_Price.ValueData, 0)
                  END AS Price
                , SUM (CASE WHEN Movement.DescId = zc_Movement_ReturnIn()
                                 THEN COALESCE (MIFloat_AmountPartner.ValueData, 0)
                                 ELSE MovementItem.Amount
                       END) AS Amount
           FROM (SELECT DISTINCT MovementId_Return AS MovementId FROM tmpMovement) AS tmpMovement
                INNER JOIN Movement ON Movement.Id = tmpMovement.MovementId
                                   AND Movement.DescId IN (zc_Movement_ReturnIn(), zc_Movement_TransferDebtIn(), zc_Movement_PriceCorrective())
                                   AND Movement.StatusId <> zc_Enum_Status_Erased() -- не проведенные должны учавствовать
                LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                       ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                      AND MovementDate_OperDatePartner.DescId     = zc_MovementDate_OperDatePartner()
                LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                          ON MovementBoolean_PriceWithVAT.MovementId =  Movement.Id
                                         AND MovementBoolean_PriceWithVAT.DescId     = zc_MovementBoolean_PriceWithVAT()
                INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovement.MovementId
                                       AND MovementItem.DescId     = zc_MI_Master()
                                       AND MovementItem.isErased   = FALSE
                LEFT JOIN MovementItemFloat AS MIFloat_Price
                                            ON MIFloat_Price.MovementItemId = MovementItem.Id
                                           AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                           -- AND MIFloat_Price.ValueData <> 0
                LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                            ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                           AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                            ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                           AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()
                LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                        ON MovementFloat_ChangePercent.MovementId = MovementItem.MovementId
                                       AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
                LEFT JOIN tmpReturnIn_child ON tmpReturnIn_child.ParentId = MovementItem.Id

           GROUP BY MovementItem.ObjectId
                  , CASE WHEN MIFloat_ChangePercent.ValueData <> 0 AND Movement.DescId = zc_Movement_ReturnIn()
                              THEN zfCalc_PriceTruncate (inOperDate     := COALESCE (tmpReturnIn_child.OperDate_tax, COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate))
                                                       , inChangePercent:= MIFloat_ChangePercent.ValueData
                                                       , inPrice        := MIFloat_Price.ValueData
                                                       , inIsWithVAT    := COALESCE (MovementBoolean_PriceWithVAT.ValueData, FALSE)
                                                        )
                         WHEN MovementFloat_ChangePercent.ValueData <> 0 AND Movement.DescId <> zc_Movement_ReturnIn()
                              THEN zfCalc_PriceTruncate (inOperDate     := COALESCE (tmpReturnIn_child.OperDate_tax, COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate))
                                                       , inChangePercent:= MovementFloat_ChangePercent.ValueData
                                                       , inPrice        := MIFloat_Price.ValueData
                                                       , inIsWithVAT    := COALESCE (MovementBoolean_PriceWithVAT.ValueData, FALSE)
                                                        )
                         ELSE COALESCE (MIFloat_Price.ValueData, 0)
                    END
                  , MIFloat_ChangePercent.ValueData
                  , Movement.DescId
                  , MovementFloat_ChangePercent.ValueData
          )
         --
       , tmpMI_all AS (SELECT * FROM MovementItem WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovementTaxCorrective.Id FROM tmpMovementTaxCorrective))
         -- строчные корректировок
       , tmpTaxCorrective_MI AS --строчные корректировок
                              (SELECT MovementItem.Id             AS Id
                                    , MovementItem.ObjectId       AS GoodsId
                                    , MovementItem.Amount         AS Amount
                               FROM tmpMovementTaxCorrective
                                    INNER JOIN Movement ON Movement.Id =  tmpMovementTaxCorrective.Id
                                    INNER JOIN tmpMI_all AS MovementItem
                                                         ON MovementItem.MovementId =  Movement.Id
                                                        AND MovementItem.DescId     = zc_MI_Master()
                                                        AND MovementItem.isErased   = FALSE
                                                        AND MovementItem.Amount <> 0
                              )

       , tmpMIFloat_Price AS (SELECT MovementItemFloat.*
                              FROM MovementItemFloat
                              WHERE MovementItemFloat.MovementItemId IN (SELECT tmpTaxCorrective_MI.Id FROM tmpTaxCorrective_MI)
                               AND MovementItemFloat.DescId = zc_MIFloat_Price()
                              )
       , tmpTaxCorrective AS --строчные корректировок
                            (SELECT tmpTaxCorrective_MI.GoodsId            AS GoodsId
                                  , MIFloat_Price.ValueData                AS Price
                                  , SUM (tmpTaxCorrective_MI.Amount)       AS Amount
                             FROM tmpTaxCorrective_MI
                                  LEFT JOIN tmpMIFloat_Price AS MIFloat_Price
                                                             ON MIFloat_Price.MovementItemId = tmpTaxCorrective_MI.Id
                                                          -- AND MIFloat_Price.ValueData <> 0
                             GROUP BY tmpTaxCorrective_MI.GoodsId
                                    , MIFloat_Price.ValueData

                            )

   -- данные из налоговой свойство zc_MIBoolean_Goods_Name_new
    , tmpName_new AS (SELECT DISTINCT
                             MovementItem.ObjectId           AS GoodsId
                           --, MILinkObject_GoodsKind.ObjectId AS GoodsKindId
                           , TRUE AS isName_new
                      FROM MovementItem
                           INNER JOIN MovementItemBoolean AS MIBoolean_Goods_Name_new
                                                          ON MIBoolean_Goods_Name_new.MovementItemId = MovementItem.Id
                                                         AND MIBoolean_Goods_Name_new.DescId = zc_MIBoolean_Goods_Name_new()
                                                         AND COALESCE (MIBoolean_Goods_Name_new.ValueData, FALSE) = TRUE
                           /*LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                            ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()*/
                      WHERE MovementItem.MovementId = vbMovementId_tax
                        AND MovementItem.DescId     = zc_MI_Master()
                        AND MovementItem.isErased   = FALSE
                      )

       -- сам запрос
       SELECT COALESCE (tmp.GoodsId, 1) AS GoodsId
            , CAST (tmpMovementTaxCorrectiveCount.CountTaxId AS Integer) AS CountTaxId
            , Object_Goods.ObjectCode         AS GoodsCode
            --, CASE WHEN ObjectString_Goods_BUH.ValueData <> '' THEN ObjectString_Goods_BUH.ValueData ELSE Object_Goods.ValueData END :: TVarChar AS GoodsName
            , CASE WHEN ObjectString_Goods_BUH.ValueData <> '' AND vbOperDate_Tax >= ObjectDate_BUH.ValueData THEN Object_Goods.ValueData
                   WHEN COALESCE (tmpName_new.isName_new, FALSE) = TRUE THEN Object_Goods.ValueData
                   WHEN ObjectString_Goods_BUH.ValueData <> ''          THEN ObjectString_Goods_BUH.ValueData
                   ELSE Object_Goods.ValueData
              END :: TVarChar AS GoodsName
            , tmp.Price
            , tmp.ReturnInAmount
            , tmp.TaxCorrectiveAmount
            , tmpMovementTaxCorrective.TotalSummVAT  AS TotalSummVAT_calc
            , tmpMovementTaxCorrective.TotalSummMVAT AS TotalSummMVAT_calc
            , tmpMovementTaxCorrective.TotalSummPVAT AS TotalSummPVAT_calc
            , COALESCE (MovementFloat_TotalSummPVAT.ValueData, 0) - COALESCE (MovementFloat_TotalSummMVAT.ValueData, 0) AS TotalSummVAT
            , COALESCE (MovementFloat_TotalSummMVAT.ValueData, 0) AS TotalSummMVAT
            , COALESCE (MovementFloat_TotalSummPVAT.ValueData, 0) AS TotalSummPVAT

       FROM (SELECT SUM (tmpMovementTaxCorrective.TotalSummVAT)  AS TotalSummVAT
                  , SUM (tmpMovementTaxCorrective.TotalSummMVAT) AS TotalSummMVAT
                  , SUM (tmpMovementTaxCorrective.TotalSummPVAT) AS TotalSummPVAT
             FROM tmpMovementTaxCorrective
            ) AS tmpMovementTaxCorrective
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummMVAT
                                    ON MovementFloat_TotalSummMVAT.MovementId = vbMovementId_Return -- inMovementId
                                   AND MovementFloat_TotalSummMVAT.DescId = zc_MovementFloat_TotalSummMVAT()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummPVAT
                                    ON MovementFloat_TotalSummPVAT.MovementId = vbMovementId_Return -- inMovementId
                                   AND MovementFloat_TotalSummPVAT.DescId = zc_MovementFloat_TotalSummPVAT()
            -- строки по которым разница для Кол-во
            LEFT JOIN (SELECT GoodsId
                            , Price
                            , SUM (ReturnInAmount)            AS ReturnInAmount
                            , SUM (TaxCorrectiveAmount)       AS TaxCorrectiveAmount
                       FROM (SELECT tmpReturnIn.GoodsId
                                  , tmpReturnIn.Price
                                  , tmpReturnIn.Amount AS ReturnInAmount
                                  , 0                  AS TaxCorrectiveAmount
                             FROM tmpReturnIn
                             WHERE tmpReturnIn.Amount <> 0
                            UNION ALL
                             SELECT tmpTaxCorrective.GoodsId
                                  , tmpTaxCorrective.Price
                                  , 0                       AS ReturnInAmount
                                  , tmpTaxCorrective.Amount AS TaxCorrectiveAmount
                             FROM tmpTaxCorrective
                            ) AS tmp
                       GROUP BY tmp.GoodsId
                              , tmp.Price
                       HAVING SUM (tmp.ReturnInAmount) <>  SUM (tmp.TaxCorrectiveAmount)
                      ) AS tmp ON 1 = 1
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmp.GoodsId
            LEFT JOIN ObjectString AS ObjectString_Goods_BUH
                                   ON ObjectString_Goods_BUH.ObjectId = tmp.GoodsId
                                  AND ObjectString_Goods_BUH.DescId = zc_ObjectString_Goods_BUH()
            LEFT JOIN ObjectDate AS ObjectDate_BUH
                                 ON ObjectDate_BUH.ObjectId = tmp.GoodsId
                                AND ObjectDate_BUH.DescId = zc_ObjectDate_Goods_BUH()
            LEFT JOIN tmpMovementTaxCorrectiveCount ON 1 = 1

            LEFT JOIN tmpName_new ON tmpName_new.GoodsId = Object_Goods.Id
                               --  AND COALESCE (tmpName_new.GoodsKindId,0) = COALESCE (Object_GoodsKind.Id,0)
       -- !!! print all !!!
       -- WHERE tmpMovementTaxCount.DescId NOT IN (zc_Movement_TransferDebtIn(), zc_Movement_PriceCorrective()) OR tmp.GoodsId IS NOT NULL
     ;
    RETURN NEXT Cursor2;

     -- Result-1
   /*OPEN Cursor1 FOR
      SELECT * FROM tmpCursor1
      ORDER BY 1
             , 2
             , 3
             , 4
             , 5
              ;
     RETURN NEXT Cursor1;

     -- Result-2
     OPEN Cursor2 FOR
      SELECT * FROM tmpCursor2;
     RETURN NEXT Cursor2;*/


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 10.03.23         * zc_Enum_DocumentTaxKind_ChangePercent()
 09.08.21         *
 21.03.19         * GoodsName_RUS
 04.03.18         *
 06.11.17         *
 28.08.17         *
 29.01.16         *
 14.01.15                                                       *
 16.07.14                                        * add tmpObject_GoodsPropertyValueGroup
 09.07.14                                                       *
 27.06.14                                        * !!! print all !!!
 05.06.14                                        * restore ContractSigningDate
 04.06.14                                        * add tmpObject_GoodsPropertyValue.Name
 03.06.14                                        * add zc_Movement_PriceCorrective
 21.05.14                                        * add zc_Movement_TransferDebtIn
 20.05.14                                        * ContractSigningDate -> Object_Contract_View.StartDate
 17.05.14                                        * add StatusId = zc_Enum_Status_Complete
 13.05.14                                        * add calc GoodsName
 03.05.14                                        * add zc_Enum_DocumentTaxKind_CorrectivePrice()
 30.04.14                                                       *
п 23.04.14                                        * add печатаем всегда все корректировки
 14.04.14                                                       *
 10.04.14                                                       *
 09.04.14                                                       *
 08.04.14                                                       *
 07.04.14                                                       *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_TaxCorrective_Print (inMovementId := 7418138, inisClientCopy:= FALSE, inSession:= zfCalc_UserAdmin()); -- FETCH ALL "<unnamed portal 14>";
-- SELECT * FROM gpSelect_Movement_TaxCorrective_Print (inMovementId := 5812683, inisClientCopy:= FALSE ,inSession:= zfCalc_UserAdmin()); -- FETCH ALL "<unnamed portal 15>";
