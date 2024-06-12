-- Function: gpSelect_MovementItem_TaxCorrective()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_TaxCorrective (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_TaxCorrective(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inisErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, LineNum Integer, LineNumTaxOld Integer, LineNumTax Integer, isAuto Boolean
             , LineNumTaxCorr_calc Integer, LineNumTaxCorr Integer, LineNumTaxNew Integer, AmountTax_calc TFloat
             , GoodsId Integer, GoodsCode Integer, GoodsCodeUKTZED TVarChar, GoodsName TVarChar
             , GoodsName_its TVarChar
             , GoodsGroupNameFull TVarChar, MeasureName TVarChar
             , Amount TFloat
             , Price TFloat, CountForPrice TFloat
             , GoodsKindId Integer, GoodsKindName  TVarChar
             , AmountSumm TFloat
             , SummTaxDiff_calc TFloat
             , PriceTax_calc TFloat
             , isErased Boolean
              )
AS
$BODY$
  DECLARE vbOperDate     TDateTime;
  DECLARE vbOperDate_rus TDateTime;
  DECLARE vbOperDate_Tax TDateTime;
  DECLARE vbDocumentTaxKindId     Integer; -- вид Корректировки
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_TaxCorrective());

     -- определяются параметры для <Корректировка>
     vbDocumentTaxKindId:= (SELECT MLO_DocumentTaxKind.ObjectId
                            FROM MovementLinkObject AS MLO_DocumentTaxKind
                            WHERE MLO_DocumentTaxKind.MovementId = inMovementId
                              AND MLO_DocumentTaxKind.DescId     = zc_MovementLinkObject_DocumentTaxKind()
                           );


     --
     IF inShowAll THEN

     -- определили
     vbOperDate := (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId);
     -- определили
     SELECT CASE WHEN MovementString_InvNumberRegistered_Child.ValueData <> '' 
                      THEN COALESCE (MovementDate_DateRegistered_Child.ValueData, Movement_child.OperDate)
                 ELSE CURRENT_DATE
            END
          , Movement_child.OperDate AS OperDate_Tax
            INTO vbOperDate_rus, vbOperDate_Tax
     FROM MovementLinkMovement AS MLM
          INNER JOIN Movement AS Movement_child 
                              ON Movement_child.Id = MLM.MovementChildId
                             AND Movement_child.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Complete())
 
          LEFT JOIN MovementDate AS MovementDate_DateRegistered_Child
                                 ON MovementDate_DateRegistered_Child.MovementId = Movement_child.Id
                                AND MovementDate_DateRegistered_Child.DescId     = zc_MovementDate_DateRegistered()
          LEFT JOIN MovementString AS MovementString_InvNumberRegistered_Child
                                   ON MovementString_InvNumberRegistered_Child.MovementId = Movement_child.Id
                                  AND MovementString_InvNumberRegistered_Child.DescId     = zc_MovementString_InvNumberRegistered()
     WHERE MLM.MovementId = inMovementId 
       AND MLM.DescId     = zc_MovementLinkMovement_Child();


     -- Результат
     RETURN QUERY
     WITH
     tmpMITax AS (SELECT tmp.Kind, tmp.GoodsId, tmp.GoodsKindId, tmp.Price, tmp.LineNum, tmp.GoodsName_its
                  FROM lpSelect_TaxFromTaxCorrective ((SELECT MLM.MovementChildId
                                                       FROM MovementLinkMovement AS MLM
                                                       WHERE MLM.MovementId = inMovementId 
                                                         AND MLM.DescId = zc_MovementLinkMovement_Child())
                                                     ) AS tmp
                  )

   -- данные из налоговой свойство zc_MIBoolean_Goods_Name_new
   , tmpName_new AS (SELECT DISTINCT
                            MovementItem.ObjectId           AS GoodsId
                          , MILinkObject_GoodsKind.ObjectId AS GoodsKindId
                          , TRUE AS isName_new
                     FROM (SELECT MLM.MovementChildId AS MovementId_tax
                           FROM MovementLinkMovement AS MLM
                           WHERE MLM.MovementId = inMovementId 
                             AND MLM.DescId = zc_MovementLinkMovement_Child()
                          ) AS tmp 
                          INNER JOIN MovementItem ON MovementItem.MovementId = tmp.MovementId_tax
                                                 AND MovementItem.DescId     = zc_MI_Master()
                                                 AND MovementItem.isErased   = FALSE
                          INNER JOIN MovementItemBoolean AS MIBoolean_Goods_Name_new
                                                         ON MIBoolean_Goods_Name_new.MovementItemId = MovementItem.Id
                                                        AND MIBoolean_Goods_Name_new.DescId = zc_MIBoolean_Goods_Name_new()
                                                        AND COALESCE (MIBoolean_Goods_Name_new.ValueData, FALSE) = TRUE
                          LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                           ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                     )
                          
   , tmpPrice AS (SELECT tmp.GoodsId
                       , tmp.GoodsKindId
                       , tmp.ValuePrice 
                  FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= zc_PriceList_Basis(), inOperDate:= vbOperDate) AS tmp
                  )

       -- Результат     
       SELECT
             0                                      AS Id
           , 0                                      AS LineNum    
           , 0                                      AS LineNumTaxOld
           , 0                                      AS LineNumTax
           , TRUE                                   AS isAuto
           , 0                                      AS LineNumTaxCorr_calc
           , 0                                      AS LineNumTaxCorr
           , 0                                      AS LineNumTaxNew
           , 0                            :: TFloat AS AmountTax_calc


           , tmpGoods.GoodsId                       AS GoodsId
           , tmpGoods.GoodsCode                     AS GoodsCode

           , CASE -- на дату у товара
                  WHEN ObjectString_Goods_UKTZED_new.ValueData <> '' AND ObjectDate_Goods_UKTZED_new.ValueData <= vbOperDate_Tax
                       THEN ObjectString_Goods_UKTZED_new.ValueData
                  -- у товара
                  ELSE COALESCE (ObjectString_Goods_UKTZED.ValueData,'')
             END :: TVarChar AS GoodsCodeUKTZED

           , tmpGoods.GoodsName                     AS GoodsName 
           , CAST (NULL AS TVarChar)                AS GoodsName_its
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_Measure.ValueData                    AS MeasureName

           , CAST (NULL AS TFloat)                  AS Amount
           , CAST (COALESCE (tmpPrice_kind.ValuePrice, tmpPrice.ValuePrice) AS TFloat) AS Price
           , CAST (1 AS TFloat)                     AS CountForPrice
           , Object_GoodsKind.Id                    AS GoodsKindId
           , Object_GoodsKind.ValueData             AS GoodsKindName
           , CAST (NULL AS TFloat)                  AS AmountSumm
           , CAST (NULL AS TFloat)                  AS SummTaxDiff_calc
           , CAST (NULL AS TFloat)                  AS PriceTax_calc
           , FALSE                                  AS isErased

       FROM (SELECT Object_Goods.Id           AS GoodsId
                  , Object_Goods.ObjectCode   AS GoodsCode
                  , Object_Goods.ValueData    AS GoodsName
                  , CASE WHEN ObjectLink_Goods_InfoMoney.ChildObjectId IN (zc_Enum_InfoMoney_20901(), zc_Enum_InfoMoney_30101(), zc_Enum_InfoMoney_30201()) THEN zc_Enum_GoodsKind_Main() ELSE 0 END AS GoodsKindId -- Ирна + Готовая продукция + Доходы Мясное сырье
             FROM Object_InfoMoney_View
                  JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                  ON ObjectLink_Goods_InfoMoney.ChildObjectId = Object_InfoMoney_View.InfoMoneyId
                                 AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                  JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Goods_InfoMoney.ObjectId
                                             AND Object_Goods.isErased = FALSE
             WHERE Object_InfoMoney_View.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10100(), zc_Enum_InfoMoneyDestination_20900(), zc_Enum_InfoMoneyDestination_21000(), zc_Enum_InfoMoneyDestination_21100(), zc_Enum_InfoMoneyDestination_30100())
            ) AS tmpGoods
            LEFT JOIN (SELECT MovementItem.ObjectId                         AS GoodsId
                            , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                             AND MovementItem.DescId     = zc_MI_Master()
                                             AND MovementItem.isErased   = tmpIsErased.isErased
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                      ) AS tmpMI ON tmpMI.GoodsId     = tmpGoods.GoodsId
                                AND tmpMI.GoodsKindId = tmpGoods.GoodsKindId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpGoods.GoodsKindId

            -- приязываем 2 раза по виду товара и без
            LEFT JOIN tmpPrice ON tmpPrice.GoodsId = tmpGoods.GoodsId
                              AND tmpPrice.GoodsKindId IS NULL
            LEFT JOIN tmpPrice AS tmpPrice_kind 
                               ON tmpPrice_kind.GoodsId = tmpGoods.GoodsId
                              AND COALESCE (tmpPrice_kind.GoodsKindId,0) = COALESCE (tmpGoods.GoodsKindId,0)

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpGoods.GoodsId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectString AS ObjectString_Goods_UKTZED
                                   ON ObjectString_Goods_UKTZED.ObjectId = tmpGoods.GoodsId
                                  AND ObjectString_Goods_UKTZED.DescId = zc_ObjectString_Goods_UKTZED()
            LEFT JOIN ObjectString AS ObjectString_Goods_UKTZED_new
                                   ON ObjectString_Goods_UKTZED_new.ObjectId = tmpGoods.GoodsId
                                  AND ObjectString_Goods_UKTZED_new.DescId = zc_ObjectString_Goods_UKTZED_new()
            LEFT JOIN ObjectDate AS ObjectDate_Goods_UKTZED_new
                                 ON ObjectDate_Goods_UKTZED_new.ObjectId = tmpGoods.GoodsId
                                AND ObjectDate_Goods_UKTZED_new.DescId = zc_ObjectDate_Goods_UKTZED_new()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpGoods.GoodsId 
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = COALESCE (ObjectLink_Goods_Measure.ChildObjectId, zc_Measure_Sh())

       WHERE tmpMI.GoodsId IS NULL

      UNION ALL
       SELECT
             MovementItem.Id                        AS Id
           , CAST (ROW_NUMBER() OVER (ORDER BY CASE WHEN vbOperDate_rus < zc_DateEnd_GoodsRus() AND ObjectString_Goods_RUS.ValueData <> ''
                                                         THEN ObjectString_Goods_RUS.ValueData
                                                    ELSE --CASE WHEN ObjectString_Goods_BUH.ValueData <> '' THEN ObjectString_Goods_BUH.ValueData ELSE Object_Goods.ValueData END
                                                         CASE WHEN ObjectString_Goods_BUH.ValueData <> '' AND vbOperDate_Tax >= ObjectDate_BUH.ValueData THEN Object_Goods.ValueData
                                                              WHEN COALESCE (tmpName_new.isName_new, FALSE) = TRUE THEN Object_Goods.ValueData
                                                              WHEN ObjectString_Goods_BUH.ValueData <> '' THEN ObjectString_Goods_BUH.ValueData
                                                              ELSE Object_Goods.ValueData
                                                         END
                                               END
                                             , Object_GoodsKind.ValueData
                                             , MovementItem.Id
                                     ) AS Integer) AS LineNum    
           , CASE WHEN COALESCE (MIBoolean_isAuto.ValueData, True) = True THEN COALESCE (tmpMITax1.LineNum, tmpMITax2.LineNum) ELSE COALESCE(MIFloat_NPP.ValueData,0) END  :: Integer AS LineNumTaxOld
           , CASE WHEN COALESCE (MIBoolean_isAuto.ValueData, True) = True THEN COALESCE (tmpMITax1.LineNum, tmpMITax2.LineNum) ELSE COALESCE(MIFloat_NPP.ValueData,0) END  :: Integer AS LineNumTax
--           , COALESCE (tmpMITax1.LineNum, tmpMITax2.LineNum) :: Integer AS LineNumTax
           , COALESCE (MIBoolean_isAuto.ValueData, True) ::Boolean               AS isAuto

             -- № п/п который корректируется
           , COALESCE (MIFloat_NPPTax_calc.ValueData, 0)    :: Integer AS LineNumTaxCorr_calc
             -- № п/п в Корректировке - сквозная нумерация
           , COALESCE (MIFloat_NPP_calc.ValueData, 0)       :: Integer AS LineNumTaxCorr
             -- № п/п в Корректировке с новой ценой - сквозная нумерация
           , COALESCE (MIFloat_NPPTaxNew_calc.ValueData, 0) :: Integer AS LineNumTaxNew

           , COALESCE (MIFloat_AmountTax_calc.ValueData, 0) :: TFloat  AS AmountTax_calc
           
           , Object_Goods.Id                        AS GoodsId
           , Object_Goods.ObjectCode                AS GoodsCode

           , CASE -- на дату у товара
                  WHEN ObjectString_Goods_UKTZED_new.ValueData <> '' AND ObjectDate_Goods_UKTZED_new.ValueData <= vbOperDate_Tax
                       THEN ObjectString_Goods_UKTZED_new.ValueData
                  -- у товара
                  ELSE COALESCE (ObjectString_Goods_UKTZED.ValueData,'')
             END :: TVarChar AS GoodsCodeUKTZED

           , CASE WHEN vbOperDate_rus < zc_DateEnd_GoodsRus() AND ObjectString_Goods_RUS.ValueData <> ''
                       THEN ObjectString_Goods_RUS.ValueData
                  ELSE --CASE WHEN ObjectString_Goods_BUH.ValueData <> '' THEN ObjectString_Goods_BUH.ValueData ELSE Object_Goods.ValueData END
                       CASE WHEN ObjectString_Goods_BUH.ValueData <> '' AND vbOperDate_Tax >= ObjectDate_BUH.ValueData THEN Object_Goods.ValueData
                            WHEN COALESCE (tmpName_new.isName_new, FALSE) = TRUE THEN Object_Goods.ValueData
                            WHEN ObjectString_Goods_BUH.ValueData <> '' THEN ObjectString_Goods_BUH.ValueData
                            ELSE Object_Goods.ValueData
                       END
             END :: TVarChar                             AS GoodsName
           , COALESCE (tmpMITax1.GoodsName_its, tmpMITax2.GoodsName_its) :: TVarChar AS GoodsName_its
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_Measure.ValueData                    AS MeasureName

           , MovementItem.Amount                    AS Amount
           , MIFloat_Price.ValueData                AS Price
           , MIFloat_CountForPrice.ValueData        AS CountForPrice
           , Object_GoodsKind.Id                    AS GoodsKindId
           , Object_GoodsKind.ValueData             AS GoodsKindName

           , CAST (CASE WHEN MIFloat_CountForPrice.ValueData > 0
                           THEN CAST ( (COALESCE (MovementItem.Amount, 0)) * MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 2))
                           ELSE CAST ( (COALESCE (MovementItem.Amount, 0)) * MIFloat_Price.ValueData AS NUMERIC (16, 2))
                   END AS TFloat)                   AS AmountSumm

           , COALESCE (MIFloat_SummTaxDiff_calc.ValueData, 0) :: TFloat AS SummTaxDiff_calc
           , COALESCE (MIFloat_PriceTax_calc.ValueData, 0)    :: TFloat AS PriceTax_calc
           , MovementItem.isErased                  AS isErased

       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = tmpIsErased.isErased

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
            LEFT JOIN ObjectString AS ObjectString_Goods_RUS
                                   ON ObjectString_Goods_RUS.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_RUS.DescId = zc_ObjectString_Goods_RUS()
                        LEFT JOIN ObjectString AS ObjectString_Goods_BUH
                                               ON ObjectString_Goods_BUH.ObjectId = Object_Goods.Id
                                              AND ObjectString_Goods_BUH.DescId = zc_ObjectString_Goods_BUH()
                        LEFT JOIN ObjectDate AS ObjectDate_BUH
                                             ON ObjectDate_BUH.ObjectId = Object_Goods.Id
                                            AND ObjectDate_BUH.DescId = zc_ObjectDate_Goods_BUH()
            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()
            LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                        ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                       AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

            LEFT JOIN MovementItemFloat AS MIFloat_NPP
                                        ON MIFloat_NPP.MovementItemId = MovementItem.Id
                                       AND MIFloat_NPP.DescId = zc_MIFloat_NPP()
            LEFT JOIN MovementItemBoolean AS MIBoolean_isAuto
                                          ON MIBoolean_isAuto.MovementItemId = MovementItem.Id
                                         AND MIBoolean_isAuto.DescId = zc_MIBoolean_isAuto()

            LEFT JOIN MovementItemFloat AS MIFloat_NPPTax_calc
                                        ON MIFloat_NPPTax_calc.MovementItemId = MovementItem.Id
                                       AND MIFloat_NPPTax_calc.DescId = zc_MIFloat_NPPTax_calc()
            LEFT JOIN MovementItemFloat AS MIFloat_NPPTaxNew_calc
                                        ON MIFloat_NPPTaxNew_calc.MovementItemId = MovementItem.Id
                                       AND MIFloat_NPPTaxNew_calc.DescId = zc_MIFloat_NPPTaxNew_calc()
            LEFT JOIN MovementItemFloat AS MIFloat_NPP_calc
                                        ON MIFloat_NPP_calc.MovementItemId = MovementItem.Id
                                       AND MIFloat_NPP_calc.DescId = zc_MIFloat_NPP_calc()
            LEFT JOIN MovementItemFloat AS MIFloat_AmountTax_calc
                                        ON MIFloat_AmountTax_calc.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountTax_calc.DescId = zc_MIFloat_AmountTax_calc()

            LEFT JOIN MovementItemFloat AS MIFloat_SummTaxDiff_calc
                                        ON MIFloat_SummTaxDiff_calc.MovementItemId = MovementItem.Id
                                       AND MIFloat_SummTaxDiff_calc.DescId = zc_MIFloat_SummTaxDiff_calc()

            LEFT JOIN MovementItemFloat AS MIFloat_PriceTax_calc
                                        ON MIFloat_PriceTax_calc.MovementItemId = MovementItem.Id
                                       AND MIFloat_PriceTax_calc.DescId = zc_MIFloat_PriceTax_calc()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectString AS ObjectString_Goods_UKTZED
                                   ON ObjectString_Goods_UKTZED.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_UKTZED.DescId = zc_ObjectString_Goods_UKTZED()
            LEFT JOIN ObjectString AS ObjectString_Goods_UKTZED_new
                                   ON ObjectString_Goods_UKTZED_new.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_UKTZED_new.DescId = zc_ObjectString_Goods_UKTZED_new()
            LEFT JOIN ObjectDate AS ObjectDate_Goods_UKTZED_new
                                 ON ObjectDate_Goods_UKTZED_new.ObjectId = Object_Goods.Id
                                AND ObjectDate_Goods_UKTZED_new.DescId = zc_ObjectDate_Goods_UKTZED_new()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = COALESCE (ObjectLink_Goods_Measure.ChildObjectId, zc_Measure_Sh())

            LEFT JOIN tmpMITax AS tmpMITax1 ON tmpMITax1.Kind        = 1
                                           AND tmpMITax1.GoodsId     = Object_Goods.Id
                                           AND tmpMITax1.GoodsKindId = Object_GoodsKind.Id
                                           AND tmpMITax1.Price       = CASE WHEN vbDocumentTaxKindId IN (zc_Enum_DocumentTaxKind_CorrectivePrice()
                                                                                                       , zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical())
                                                                            THEN MIFloat_PriceTax_calc.ValueData
                                                                            ELSE MIFloat_Price.ValueData
                                                                       END
            LEFT JOIN tmpMITax AS tmpMITax2 ON tmpMITax2.Kind        = 2
                                           AND tmpMITax2.GoodsId     = Object_Goods.Id
                                           AND tmpMITax2.Price       = CASE WHEN vbDocumentTaxKindId IN (zc_Enum_DocumentTaxKind_CorrectivePrice()
                                                                                                       , zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical())
                                                                            THEN MIFloat_PriceTax_calc.ValueData
                                                                            ELSE MIFloat_Price.ValueData
                                                                       END
                                           AND tmpMITax1.GoodsId     IS NULL

            LEFT JOIN tmpName_new ON tmpName_new.GoodsId = Object_Goods.Id
                                 AND COALESCE (tmpName_new.GoodsKindId,0) = COALESCE (Object_GoodsKind.Id,0)
            ;
     ELSE

     RETURN QUERY
     WITH 
     tmpMITax AS (SELECT tmp.Kind, tmp.GoodsId, tmp.GoodsKindId, tmp.Price, tmp.LineNum, tmp.GoodsName_its
                  FROM lpSelect_TaxFromTaxCorrective ((SELECT MLM.MovementChildId
                                                       FROM MovementLinkMovement AS MLM
                                                       WHERE MLM.MovementId = inMovementId 
                                                         AND MLM.DescId = zc_MovementLinkMovement_Child())
                                                     ) AS tmp
                  )

   -- данные из налоговой свойство zc_MIBoolean_Goods_Name_new
   , tmpName_new AS (SELECT DISTINCT
                            MovementItem.ObjectId           AS GoodsId
                          , MILinkObject_GoodsKind.ObjectId AS GoodsKindId
                          , TRUE AS isName_new
                     FROM (SELECT MLM.MovementChildId AS MovementId_tax
                           FROM MovementLinkMovement AS MLM
                           WHERE MLM.MovementId = inMovementId 
                             AND MLM.DescId = zc_MovementLinkMovement_Child()
                          ) AS tmp 
                          INNER JOIN MovementItem ON MovementItem.MovementId = tmp.MovementId_tax
                                                 AND MovementItem.DescId     = zc_MI_Master()
                                                 AND MovementItem.isErased   = FALSE
                          INNER JOIN MovementItemBoolean AS MIBoolean_Goods_Name_new
                                                         ON MIBoolean_Goods_Name_new.MovementItemId = MovementItem.Id
                                                        AND MIBoolean_Goods_Name_new.DescId = zc_MIBoolean_Goods_Name_new()
                                                        AND COALESCE (MIBoolean_Goods_Name_new.ValueData, FALSE) = TRUE
                          LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                           ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                     )

       -- Результат     
       SELECT
             MovementItem.Id
           , CAST (ROW_NUMBER() OVER (ORDER BY CASE WHEN vbOperDate_rus < zc_DateEnd_GoodsRus() AND ObjectString_Goods_RUS.ValueData <> ''
                                                         THEN ObjectString_Goods_RUS.ValueData
                                                    ELSE --CASE WHEN ObjectString_Goods_BUH.ValueData <> '' THEN ObjectString_Goods_BUH.ValueData ELSE Object_Goods.ValueData END
                                                         CASE WHEN ObjectString_Goods_BUH.ValueData <> '' AND vbOperDate_Tax >= ObjectDate_BUH.ValueData THEN Object_Goods.ValueData
                                                              WHEN COALESCE (tmpName_new.isName_new, FALSE) = TRUE THEN Object_Goods.ValueData
                                                              WHEN ObjectString_Goods_BUH.ValueData <> '' THEN ObjectString_Goods_BUH.ValueData
                                                              ELSE Object_Goods.ValueData
                                                         END
                                               END
                                             , Object_GoodsKind.ValueData
                                             , MovementItem.Id
                                     ) AS Integer) AS LineNum    
           , CASE WHEN COALESCE (MIBoolean_isAuto.ValueData, True) = True THEN COALESCE (tmpMITax1.LineNum, tmpMITax2.LineNum) ELSE COALESCE(MIFloat_NPP.ValueData,0) END  :: Integer AS LineNumTaxOld
           , CASE WHEN COALESCE (MIBoolean_isAuto.ValueData, True) = True THEN COALESCE (tmpMITax1.LineNum, tmpMITax2.LineNum) ELSE COALESCE(MIFloat_NPP.ValueData,0) END  :: Integer AS LineNumTax 
           , COALESCE (MIBoolean_isAuto.ValueData, True) ::Boolean    AS isAuto

           , COALESCE (MIFloat_NPPTax_calc.ValueData, 0)    :: Integer AS LineNumTaxCorr_calc
           , COALESCE (MIFloat_NPP_calc.ValueData, 0)       :: Integer AS LineNumTaxCorr
           , COALESCE (MIFloat_NPPTaxNew_calc.ValueData, 0) :: Integer AS LineNumTaxNew
           , COALESCE (MIFloat_AmountTax_calc.ValueData, 0) :: TFloat  AS AmountTax_calc

           , Object_Goods.Id                        AS GoodsId
           , Object_Goods.ObjectCode                AS GoodsCode

           , CASE -- на дату у товара
                  WHEN ObjectString_Goods_UKTZED_new.ValueData <> '' AND ObjectDate_Goods_UKTZED_new.ValueData <= vbOperDate_Tax
                       THEN ObjectString_Goods_UKTZED_new.ValueData
                  -- у товара
                  ELSE COALESCE (ObjectString_Goods_UKTZED.ValueData,'')
             END :: TVarChar AS GoodsCodeUKTZED

           , CASE WHEN vbOperDate_rus < zc_DateEnd_GoodsRus() AND ObjectString_Goods_RUS.ValueData <> ''
                       THEN ObjectString_Goods_RUS.ValueData
                  ELSE --CASE WHEN ObjectString_Goods_BUH.ValueData <> '' THEN ObjectString_Goods_BUH.ValueData ELSE Object_Goods.ValueData END
                       CASE WHEN ObjectString_Goods_BUH.ValueData <> '' AND vbOperDate_Tax >= ObjectDate_BUH.ValueData THEN Object_Goods.ValueData
                            WHEN COALESCE (tmpName_new.isName_new, FALSE) = TRUE THEN Object_Goods.ValueData
                            WHEN ObjectString_Goods_BUH.ValueData <> '' THEN ObjectString_Goods_BUH.ValueData
                            ELSE Object_Goods.ValueData
                       END
             END :: TVarChar                             AS GoodsName
           , COALESCE (tmpMITax1.GoodsName_its, tmpMITax2.GoodsName_its) :: TVarChar AS GoodsName_its
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_Measure.ValueData                    AS MeasureName

           , MovementItem.Amount                    AS Amount
           , MIFloat_Price.ValueData                AS Price
           , MIFloat_CountForPrice.ValueData        AS CountForPrice
           , Object_GoodsKind.Id                    AS GoodsKindId
           , Object_GoodsKind.ValueData             AS GoodsKindName
           , CAST (CASE WHEN MIFloat_CountForPrice.ValueData > 0
                           THEN CAST ( (COALESCE (MovementItem.Amount, 0)) * MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 2))
                           ELSE CAST ( (COALESCE (MovementItem.Amount, 0)) * MIFloat_Price.ValueData AS NUMERIC (16, 2))
                   END AS TFloat)                   AS AmountSumm
           , COALESCE (MIFloat_SummTaxDiff_calc.ValueData, 0) :: TFloat AS SummTaxDiff_calc
           , COALESCE (MIFloat_PriceTax_calc.ValueData, 0)    :: TFloat AS PriceTax_calc
           , MovementItem.isErased                  AS isErased

       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = tmpIsErased.isErased
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
            LEFT JOIN ObjectString AS ObjectString_Goods_RUS
                                   ON ObjectString_Goods_RUS.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_RUS.DescId = zc_ObjectString_Goods_RUS()
                        LEFT JOIN ObjectString AS ObjectString_Goods_BUH
                                               ON ObjectString_Goods_BUH.ObjectId = Object_Goods.Id
                                              AND ObjectString_Goods_BUH.DescId = zc_ObjectString_Goods_BUH()
                        LEFT JOIN ObjectDate AS ObjectDate_BUH
                                             ON ObjectDate_BUH.ObjectId = Object_Goods.Id
                                            AND ObjectDate_BUH.DescId = zc_ObjectDate_Goods_BUH()                                  
            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()
            LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                        ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                       AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

            LEFT JOIN MovementItemFloat AS MIFloat_NPP
                                        ON MIFloat_NPP.MovementItemId = MovementItem.Id
                                       AND MIFloat_NPP.DescId = zc_MIFloat_NPP()
            LEFT JOIN MovementItemBoolean AS MIBoolean_isAuto
                                          ON MIBoolean_isAuto.MovementItemId = MovementItem.Id
                                         AND MIBoolean_isAuto.DescId = zc_MIBoolean_isAuto()

            LEFT JOIN MovementItemFloat AS MIFloat_NPPTax_calc
                                        ON MIFloat_NPPTax_calc.MovementItemId = MovementItem.Id
                                       AND MIFloat_NPPTax_calc.DescId = zc_MIFloat_NPPTax_calc()
            LEFT JOIN MovementItemFloat AS MIFloat_NPP_calc
                                        ON MIFloat_NPP_calc.MovementItemId = MovementItem.Id
                                       AND MIFloat_NPP_calc.DescId = zc_MIFloat_NPP_calc()
            LEFT JOIN MovementItemFloat AS MIFloat_NPPTaxNew_calc
                                        ON MIFloat_NPPTaxNew_calc.MovementItemId = MovementItem.Id
                                       AND MIFloat_NPPTaxNew_calc.DescId = zc_MIFloat_NPPTaxNew_calc()
            LEFT JOIN MovementItemFloat AS MIFloat_AmountTax_calc
                                        ON MIFloat_AmountTax_calc.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountTax_calc.DescId = zc_MIFloat_AmountTax_calc()
            LEFT JOIN MovementItemFloat AS MIFloat_PriceTax_calc
                                        ON MIFloat_PriceTax_calc.MovementItemId = MovementItem.Id
                                       AND MIFloat_PriceTax_calc.DescId = zc_MIFloat_PriceTax_calc()
            LEFT JOIN MovementItemFloat AS MIFloat_SummTaxDiff_calc
                                        ON MIFloat_SummTaxDiff_calc.MovementItemId = MovementItem.Id
                                       AND MIFloat_SummTaxDiff_calc.DescId = zc_MIFloat_SummTaxDiff_calc()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectString AS ObjectString_Goods_UKTZED
                                   ON ObjectString_Goods_UKTZED.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_UKTZED.DescId   = zc_ObjectString_Goods_UKTZED()
            LEFT JOIN ObjectString AS ObjectString_Goods_UKTZED_new
                                   ON ObjectString_Goods_UKTZED_new.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_UKTZED_new.DescId = zc_ObjectString_Goods_UKTZED_new()
            LEFT JOIN ObjectDate AS ObjectDate_Goods_UKTZED_new
                                 ON ObjectDate_Goods_UKTZED_new.ObjectId = Object_Goods.Id
                                AND ObjectDate_Goods_UKTZED_new.DescId = zc_ObjectDate_Goods_UKTZED_new()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = COALESCE (ObjectLink_Goods_Measure.ChildObjectId, zc_Measure_Sh())
            
            LEFT JOIN tmpMITax AS tmpMITax1 ON tmpMITax1.Kind        = 1
                                           AND tmpMITax1.GoodsId     = Object_Goods.Id
                                           AND tmpMITax1.GoodsKindId = Object_GoodsKind.Id
                                           AND tmpMITax1.Price       = CASE WHEN vbDocumentTaxKindId IN (zc_Enum_DocumentTaxKind_CorrectivePrice()
                                                                                                       , zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical())
                                                                            THEN MIFloat_PriceTax_calc.ValueData
                                                                            ELSE MIFloat_Price.ValueData
                                                                       END
            LEFT JOIN tmpMITax AS tmpMITax2 ON tmpMITax2.Kind        = 2
                                           AND tmpMITax2.GoodsId     = Object_Goods.Id
                                           AND tmpMITax2.Price       = CASE WHEN vbDocumentTaxKindId IN (zc_Enum_DocumentTaxKind_CorrectivePrice()
                                                                                                       , zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical())
                                                                            THEN MIFloat_PriceTax_calc.ValueData
                                                                            ELSE MIFloat_Price.ValueData
                                                                       END
                                           AND tmpMITax1.GoodsId     IS NULL

            LEFT JOIN tmpName_new ON tmpName_new.GoodsId = Object_Goods.Id
                                 AND COALESCE (tmpName_new.GoodsKindId,0) = COALESCE (Object_GoodsKind.Id,0)
            ;

     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_TaxCorrective (Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 09.08.21         *
 06.12.19         *
 12.04.18         * add PriceTax_calc
 04.04.18         * add SummTaxDiff_calc
 06.01.17         * 
 25.03.16         * add LineNum
 31.03.15         * 
 08.04.14                                        * add zc_Enum_InfoMoneyDestination_30100
 10.02.14                                                        *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_TaxCorrective (inMovementId:= 4229, inShowAll:= TRUE, inisErased:= TRUE, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItem_TaxCorrective (inMovementId:= 4229, inShowAll:= FALSE, inisErased:= FALSE, inSession:= zfCalc_UserAdmin())
