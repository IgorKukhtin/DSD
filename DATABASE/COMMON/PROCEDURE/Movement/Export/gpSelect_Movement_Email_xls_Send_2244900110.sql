-- Function: gpSelect_Movement_Email_xls_Send(Integer, tvarchar)

DROP FUNCTION IF EXISTS gpSelect_Movement_Email_xls_Send_2244900110 (Integer, tvarchar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Email_xls_Send_2244900110(
    IN inMovementId           Integer   ,
    IN inSession              TVarChar    -- сессия пользователя
)
RETURNS TABLE (Ord          TVarChar
             , GoodsCode    Integer
             --, BarCode      TVarChar
             , GoodsName    TVarChar
             , GoodsKindName TVarChar
             , MeasureName     TVarChar
             , Amount       TFloat
             , PriceNoVAT      TFloat
             , AmountSummNoVAT TFloat
             --, VATPercent      TFloat
               )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbPartnerId Integer;
   DECLARE vbOperDatePartner TDateTime;
   DECLARE vbOperDate        TDateTime;
   DECLARE vbDescId Integer;

   DECLARE vbGoodsPropertyId Integer;
   DECLARE vbGoodsPropertyId_basis Integer;
   DECLARE vbExportKindId Integer;

   DECLARE vbPaidKindId Integer;
   DECLARE vbChangePercent TFloat;
DECLARE vbIsProcess_BranchIn Boolean;

   DECLARE vbIsChangePrice Boolean;
   DECLARE vbIsDiscountPrice Boolean;

    DECLARE vbPriceWithVAT Boolean;
    DECLARE vbVATPercent TFloat;
    DECLARE vbDiscountPercent TFloat;
    DECLARE vbExtraChargesPercent TFloat;
    DECLARE vbOKPO TVarChar;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Email_Send());
     vbUserId := lpGetUserBySession (inSession);

     vbOKPO:= (SELECT OH_JuridicalDetails.OKPO
               FROM MovementLinkObject
                    LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                         ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject.ObjectId
                                        AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                    LEFT JOIN ObjectHistory_JuridicalDetails_View AS OH_JuridicalDetails
                                                                  ON OH_JuridicalDetails.JuridicalId = ObjectLink_Partner_Juridical.ChildObjectId
               WHERE MovementLinkObject.MovementId = inMovementId
                 AND MovementLinkObject.DescId = zc_MovementLinkObject_To()
               );

    --проверка  эта процедура для ОКПО 2244900110 Недавній Олександр Миколайович ФОП
    IF vbOKPO <> '2244900110' THEN RETURN; END IF;
    
     -- Таблица для результата
     CREATE TEMP TABLE _Result (RowData TBlob) ON COMMIT DROP;


     -- параметры из документа
     SELECT tmp.DescId
          , tmp.OperDate
          , tmp.OperDatePartner
          , tmp.PartnerId
          , tmp.GoodsPropertyId
          , tmp.GoodsPropertyId_basis
          , tmp.ExportKindId
          , tmp.PaidKindId
          , tmp.ChangePercent
          , tmp.isDiscountPrice_juridical

          , tmp.PriceWithVAT
          , tmp.VATPercent
          , tmp.DiscountPercent
          , tmp.ExtraChargesPercent
          
            INTO vbDescId, vbOperDate, vbOperDatePartner, vbPartnerId, vbGoodsPropertyId, vbGoodsPropertyId_basis, vbExportKindId, vbPaidKindId, vbChangePercent, vbIsDiscountPrice
               , vbPriceWithVAT, vbVATPercent, vbDiscountPercent, vbExtraChargesPercent
     FROM (WITH tmpExportJuridical AS (SELECT DISTINCT tmp.PartnerId, tmp.ExportKindId FROM lpSelect_Object_ExportJuridical_list() AS tmp)
           SELECT Movement.OperDate AS OperDate
                , Movement.DescId
                , MovementDate_OperDatePartner.ValueData AS OperDatePartner
                , Object_Partner.Id AS PartnerId
                , zfCalc_GoodsPropertyId (MovementLinkObject_Contract.ObjectId, COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, Object_Partner.Id), Object_Partner.Id) AS GoodsPropertyId
                , zfCalc_GoodsPropertyId (0, zc_Juridical_Basis(), 0) AS GoodsPropertyId_basis
                , tmpExportJuridical.ExportKindId
                , MovementLinkObject_PaidKind.ObjectId AS PaidKindId
                , COALESCE (MovementFloat_ChangePercent.ValueData, 0) AS ChangePercent
                , COALESCE (ObjectBoolean_isDiscountPrice.ValueData, FALSE) AS isDiscountPrice_juridical
          , COALESCE (MovementBoolean_PriceWithVAT.ValueData, TRUE) AS PriceWithVAT
          , COALESCE (MovementFloat_VATPercent.ValueData, 0)        AS VATPercent
          , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) < 0 THEN -1 * MovementFloat_ChangePercent.ValueData ELSE 0 END AS DiscountPercent
          , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) > 0 THEN      MovementFloat_ChangePercent.ValueData ELSE 0 END AS ExtraChargesPercent
           FROM Movement
                LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                       ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                      AND MovementDate_OperDatePartner.DescId     = zc_MovementDate_OperDatePartner()
                LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                        ON MovementFloat_ChangePercent.MovementId = Movement.Id
                                       AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
                LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                             ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                            AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
                LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                             ON MovementLinkObject_Contract.MovementId = Movement.Id
                                            AND MovementLinkObject_Contract.DescId IN (zc_MovementLinkObject_Contract(), zc_MovementLinkObject_ContractTo())
                LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                             ON MovementLinkObject_From.MovementId = Movement.Id
                                            AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                             ON MovementLinkObject_To.MovementId = Movement.Id
                                            AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = CASE WHEN Movement.DescId = zc_Movement_Sale() THEN MovementLinkObject_To.ObjectId ELSE MovementLinkObject_From.ObjectId END
                LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                     ON ObjectLink_Partner_Juridical.ObjectId = Object_Partner.Id
                                    AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                LEFT JOIN ObjectBoolean AS ObjectBoolean_isDiscountPrice
                                        ON ObjectBoolean_isDiscountPrice.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                       AND ObjectBoolean_isDiscountPrice.DescId = zc_ObjectBoolean_Juridical_isDiscountPrice()
                LEFT JOIN tmpExportJuridical ON tmpExportJuridical.PartnerId = Object_Partner.Id
          LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                    ON MovementBoolean_PriceWithVAT.MovementId = Movement.Id
                                   AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
          LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                   ON MovementFloat_VATPercent.MovementId = Movement.Id
                                 AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()

           WHERE Movement.Id = inMovementId
          ) AS tmp
    ;


     -- !!!надо определить - есть ли скидка в цене!!!
     vbIsChangePrice:= vbIsDiscountPrice = TRUE                              -- у Юр лица есть галка
                    OR vbPaidKindId = zc_Enum_PaidKind_FirstForm()           -- это БН
                    OR (vbChangePercent <> 0                                 -- в шапке есть скидка, но есть хоть один элемент со скидкой = 0%
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
     vbIsProcess_BranchIn:= EXISTS (SELECT Id FROM Object_Unit_View WHERE Id = (SELECT ObjectId FROM MovementLinkObject WHERE MovementId = inMovementId AND DescId = zc_MovementLinkObject_To()) AND BranchId = (SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.BranchId));

     -- !!!1.Формат XLS - IN (zc_Enum_ExportKind_Logistik41750857(), zc_Enum_ExportKind_Nedavn2244900110())

     IF vbExportKindId IN (zc_Enum_ExportKind_Logistik41750857(), zc_Enum_ExportKind_Nedavn2244900110())
     THEN
        -- Результат
        RETURN QUERY
        WITH tmpObject_GoodsPropertyValue AS
                (SELECT ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                      , ObjectLink_GoodsPropertyValue_Goods.ChildObjectId                   AS GoodsId
                      , COALESCE (ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId, 0) AS GoodsKindId
                      , ObjectString_BarCode.ValueData                                      AS BarCode
                      , ObjectString_Article.ValueData                                      AS Article
                      , Object_GoodsPropertyValue.ValueData  AS Name
                      , COALESCE (ObjectBoolean_Weigth.ValueData, FALSE) :: Boolean AS isWeigth
                 FROM (SELECT vbGoodsPropertyId AS GoodsPropertyId WHERE vbGoodsPropertyId <> 0
                      ) AS tmpGoodsProperty
                      INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                            ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = tmpGoodsProperty.GoodsPropertyId
                                           AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
                      LEFT JOIN Object AS Object_GoodsPropertyValue ON Object_GoodsPropertyValue.Id = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                      LEFT JOIN ObjectString AS ObjectString_BarCode
                                             ON ObjectString_BarCode.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                            AND ObjectString_BarCode.DescId = zc_ObjectString_GoodsPropertyValue_BarCode()
                      LEFT JOIN ObjectString AS ObjectString_Article
                                             ON ObjectString_Article.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                            AND ObjectString_Article.DescId = zc_ObjectString_GoodsPropertyValue_Article()

                      LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                           ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                          AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
                      LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                           ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                          AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
                      LEFT JOIN ObjectBoolean AS ObjectBoolean_Weigth
                                     ON ObjectBoolean_Weigth.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                    AND ObjectBoolean_Weigth.DescId = zc_ObjectBoolean_GoodsPropertyValue_Weigth()
             )
           , tmpObject_GoodsPropertyValueGroup AS
                (SELECT tmpObject_GoodsPropertyValue.ObjectId
                      , tmpObject_GoodsPropertyValue.GoodsId
                      , tmpObject_GoodsPropertyValue.BarCode
                      , tmpObject_GoodsPropertyValue.Article
                      , tmpObject_GoodsPropertyValue.Name
                 FROM (SELECT MAX (tmpObject_GoodsPropertyValue.ObjectId) AS ObjectId, GoodsId FROM tmpObject_GoodsPropertyValue WHERE Article <> '' GROUP BY GoodsId
                      ) AS tmpGoodsProperty_find
                      LEFT JOIN tmpObject_GoodsPropertyValue ON tmpObject_GoodsPropertyValue.ObjectId =  tmpGoodsProperty_find.ObjectId
                )
           , tmpObject_GoodsPropertyValue_basis AS
                (SELECT ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                      , ObjectLink_GoodsPropertyValue_Goods.ChildObjectId AS GoodsId
                      , COALESCE (ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId, 0) AS GoodsKindId
                      , ObjectString_BarCode.ValueData                                      AS BarCode
                      , ObjectString_Article.ValueData                                      AS Article
                      , Object_GoodsPropertyValue.ValueData  AS Name
                 FROM (SELECT vbGoodsPropertyId_basis AS GoodsPropertyId
                      ) AS tmpGoodsProperty
                      INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                            ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = tmpGoodsProperty.GoodsPropertyId
                                           AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
                      LEFT JOIN Object AS Object_GoodsPropertyValue ON Object_GoodsPropertyValue.Id = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                      LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                           ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                          AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
                      LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                           ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                          AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()

                      LEFT JOIN ObjectString AS ObjectString_BarCode
                                             ON ObjectString_BarCode.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                            AND ObjectString_BarCode.DescId = zc_ObjectString_GoodsPropertyValue_BarCode()
                      LEFT JOIN ObjectString AS ObjectString_Article
                                             ON ObjectString_Article.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                            AND ObjectString_Article.DescId = zc_ObjectString_GoodsPropertyValue_Article()
                )

 -- строки док
 , tmpMI AS (SELECT MovementItem.ObjectId
                  , COALESCE (MILinkObject_GoodsKind.ObjectId, zc_GoodsKind_Basis()) AS GoodsKindId
                  , CASE WHEN MIFloat_ChangePercent.ValueData <> 0 AND vbIsChangePrice = TRUE -- !!!для НАЛ не учитываем, но НЕ всегда!!!
                              THEN zfCalc_PriceTruncate (inOperDate     := vbOperDatePartner
                                                       , inChangePercent:= MIFloat_ChangePercent.ValueData
                                                       , inPrice        := MIFloat_Price.ValueData
                                                       , inIsWithVAT    := vbPriceWithVAT
                                                        )
                         WHEN vbDiscountPercent <> 0 AND vbIsChangePrice = TRUE AND vbDescId <> zc_Movement_Sale()
                              THEN zfCalc_PriceTruncate (inOperDate     := vbOperDatePartner
                                                       , inChangePercent:= -1 * vbDiscountPercent
                                                       , inPrice        := MIFloat_Price.ValueData
                                                       , inIsWithVAT    := vbPriceWithVAT
                                                        )
                         WHEN vbExtraChargesPercent <> 0 AND vbIsChangePrice = TRUE AND vbDescId <> zc_Movement_Sale()
                              THEN zfCalc_PriceTruncate (inOperDate     := vbOperDatePartner
                                                       , inChangePercent:= -1 * vbExtraChargesPercent
                                                       , inPrice        := MIFloat_Price.ValueData
                                                       , inIsWithVAT    := vbPriceWithVAT
                                                        )
                         ELSE COALESCE (MIFloat_Price.ValueData, 0)
                    END AS Price

                  , MIFloat_CountForPrice.ValueData AS CountForPrice
                  , SUM (MovementItem.Amount) AS Amount
                  , SUM (CASE WHEN Movement.DescId IN (zc_Movement_Sale())
                                   THEN COALESCE (MIFloat_AmountPartner.ValueData, 0)
                              WHEN Movement.DescId IN (zc_Movement_SendOnPrice()) AND vbIsProcess_BranchIn = TRUE
                                   THEN COALESCE (MIFloat_AmountPartner.ValueData, 0)
                              ELSE MovementItem.Amount

                         END) AS AmountPartner

             FROM MovementItem
                  LEFT JOIN MovementItemFloat AS MIFloat_Price
                                               ON MIFloat_Price.MovementItemId = MovementItem.Id
                                              AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                              --AND MIFloat_Price.ValueData <> 0
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

             WHERE MovementItem.MovementId = inMovementId
               AND MovementItem.DescId     = zc_MI_Master()
               AND MovementItem.isErased   = FALSE
             GROUP BY MovementItem.ObjectId
                    , MILinkObject_GoodsKind.ObjectId
                    ,CASE WHEN MIFloat_ChangePercent.ValueData <> 0 AND vbIsChangePrice = TRUE -- !!!для НАЛ не учитываем, но НЕ всегда!!!
                                THEN zfCalc_PriceTruncate (inOperDate     := vbOperDatePartner
                                                         , inChangePercent:= MIFloat_ChangePercent.ValueData
                                                         , inPrice        := MIFloat_Price.ValueData
                                                         , inIsWithVAT    := vbPriceWithVAT
                                                          )
                           WHEN vbDiscountPercent <> 0 AND vbIsChangePrice = TRUE AND vbDescId <> zc_Movement_Sale()
                                THEN zfCalc_PriceTruncate (inOperDate     := vbOperDatePartner
                                                         , inChangePercent:= -1 * vbDiscountPercent
                                                         , inPrice        := MIFloat_Price.ValueData
                                                         , inIsWithVAT    := vbPriceWithVAT
                                                          )
                           WHEN vbExtraChargesPercent <> 0 AND vbIsChangePrice = TRUE AND vbDescId <> zc_Movement_Sale()
                                THEN zfCalc_PriceTruncate (inOperDate     := vbOperDatePartner
                                                         , inChangePercent:= -1 * vbExtraChargesPercent
                                                         , inPrice        := MIFloat_Price.ValueData
                                                         , inIsWithVAT    := vbPriceWithVAT
                                                          )
                           ELSE COALESCE (MIFloat_Price.ValueData, 0)
                      END

                    , MIFloat_CountForPrice.ValueData
                    , MIFloat_ChangePercent.ValueData
             HAVING SUM (CASE WHEN Movement.DescId IN (zc_Movement_Sale())
                                   THEN COALESCE (MIFloat_AmountPartner.ValueData, 0)
                              WHEN Movement.DescId IN (zc_Movement_SendOnPrice()) AND vbIsProcess_BranchIn = TRUE
                                   THEN COALESCE (MIFloat_AmountPartner.ValueData, 0)
                              ELSE MovementItem.Amount

                         END) <> 0
            )
   -- результат
   , tmpRes AS (
                SELECT COALESCE (tmpObject_GoodsPropertyValue.BarCode, COALESCE (tmpObject_GoodsPropertyValueGroup.BarCode, COALESCE (tmpObject_GoodsPropertyValue_basis.BarCode, '')))  :: TVarChar AS BarCode
                     , Object_Goods.ObjectCode        AS GoodsCode

                     , (CASE WHEN tmpObject_GoodsPropertyValue.Name            <> '' THEN tmpObject_GoodsPropertyValue.Name
                             WHEN tmpObject_GoodsPropertyValueGroup.Name       <> '' THEN tmpObject_GoodsPropertyValueGroup.Name
                             WHEN tmpObject_GoodsPropertyValue_basis.Name      <> '' THEN tmpObject_GoodsPropertyValue_basis.Name
                             --WHEN tmpObject_GoodsPropertyValueGroup_basis.Name <> '' THEN tmpObject_GoodsPropertyValueGroup_basis.Name
                             ELSE Object_Goods.ValueData
                        END
                     --|| CASE WHEN COALESCE (Object_GoodsKind.Id, zc_Enum_GoodsKind_Main()) = zc_Enum_GoodsKind_Main() THEN '' ELSE ' ' || Object_GoodsKind.ValueData END
                       ) :: TVarChar AS GoodsName
                     , (CASE WHEN tmpObject_GoodsPropertyValue.Name            <> '' THEN tmpObject_GoodsPropertyValue.Name
                             WHEN tmpObject_GoodsPropertyValueGroup.Name       <> '' THEN tmpObject_GoodsPropertyValueGroup.Name
                             WHEN tmpObject_GoodsPropertyValue_basis.Name      <> '' THEN tmpObject_GoodsPropertyValue_basis.Name
                             --WHEN tmpObject_GoodsPropertyValueGroup_basis.Name <> '' THEN tmpObject_GoodsPropertyValueGroup_basis.Name
                             ELSE Object_Goods.ValueData
                        END) :: TVarChar AS GoodsName_two

                     , ('(' || Object_Goods.ObjectCode :: TVarChar || ') ' || Object_Goods.ValueData || CASE WHEN COALESCE (tmpMI.GoodsKindId, zc_Enum_GoodsKind_Main()) = zc_Enum_GoodsKind_Main() THEN '' ELSE ' ' || Object_GoodsKind.ValueData END) :: TVarChar AS GoodsName_full

                     , Object_GoodsKind.ValueData      AS GoodsKindName
                     , Object_Measure.ValueData        AS MeasureName
                     
                     , tmpMI.AmountPartner      AS Amount
                     --, CASE WHEN tmpMI.CountForPrice > 1 THEN tmpMI.Price / tmpMI.CountForPrice ELSE tmpMI.Price END AS Price
                     , tmpMI.Price 
                       -- ШТ
                     , (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() AND COALESCE (tmpObject_GoodsPropertyValue.isWeigth,FALSE) = FALSE
                                  THEN tmpMI.Amount
                             ELSE 0
                        END) AS CountSh
                       -- ВЕС
                     , (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()
                                  THEN tmpMI.Amount * COALESCE (ObjectFloat_Weight.ValueData, 0)
                             WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Kg()
                                  THEN tmpMI.Amount
                             ELSE 0
                       END) AS CountKg
                       -- ВЕС - только если весовой
                     , (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()
                                  THEN 0
                             WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Kg()
                                  THEN tmpMI.Amount
                             ELSE 0
                       END) AS CountKg_only
                       -- для ШТ, если сво-во tmpObject_GoodsPropertyValue.isWeigth = TRUE, нужно єто кол-во снять с итого шт.
                     , (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() AND COALESCE (tmpObject_GoodsPropertyValue.isWeigth, FALSE) = TRUE
                                  THEN tmpMI.Amount
                             ELSE 0
                       END) AS CountSh_Kg


                       -- сумма по ценам док-та
                     , CASE WHEN -- !!!захардкодил временно для БН с НДС!!!
                                 vbPriceWithVAT = TRUE AND vbPaidKindId = zc_Enum_PaidKind_FirstForm()
                                 THEN CAST (tmpMI.AmountPartner
                                            -- расчет цены без НДС, до 4 знаков
                                          * CAST (tmpMI.Price - tmpMI.Price * (vbVATPercent / (vbVATPercent + 100)) AS NUMERIC (16, 4))
                                          / CASE WHEN tmpMI.CountForPrice <> 0 THEN tmpMI.CountForPrice ELSE 1 END
                                           AS NUMERIC (16, 2))
          
                            WHEN tmpMI.CountForPrice <> 0
                                 THEN CAST (tmpMI.AmountPartner * (tmpMI.Price / tmpMI.CountForPrice) AS NUMERIC (16, 2))
          
                            WHEN tmpMI.CountForPrice <> 0
                                 THEN CAST (tmpMI.AmountPartner * (tmpMI.Price / tmpMI.CountForPrice) AS NUMERIC (16, 2))
                            ELSE CAST (tmpMI.AmountPartner * tmpMI.Price AS NUMERIC (16, 2))
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


                FROM tmpMI
                     
                     LEFT JOIN tmpObject_GoodsPropertyValue ON tmpObject_GoodsPropertyValue.GoodsId = tmpMI.ObjectId
                                                           AND tmpObject_GoodsPropertyValue.GoodsKindId = COALESCE (tmpMI.GoodsKindId, 0)
                                                           -- AND tmpObject_GoodsPropertyValue.BarCode <> ''
                                                           -- AND tmpObject_GoodsPropertyValue.Article <> ''
                     LEFT JOIN tmpObject_GoodsPropertyValueGroup ON tmpObject_GoodsPropertyValueGroup.GoodsId = tmpMI.ObjectId
                                                                AND tmpObject_GoodsPropertyValue.GoodsId IS NULL
                     LEFT JOIN tmpObject_GoodsPropertyValue_basis ON tmpObject_GoodsPropertyValue_basis.GoodsId = tmpMI.ObjectId
                                                                 AND tmpObject_GoodsPropertyValue_basis.GoodsKindId = COALESCE (tmpMI.GoodsKindId, 0)

                     LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.ObjectId
                     LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMI.GoodsKindId

                     LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                          ON ObjectLink_Goods_Measure.ObjectId = tmpMI.ObjectId
                                         AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                     LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() AND COALESCE (tmpObject_GoodsPropertyValue.isWeigth,FALSE) = TRUE
                                                                                    THEN zc_Measure_Kg()
                                                                                    ELSE ObjectLink_Goods_Measure.ChildObjectId
                                                                               END
            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                  ON ObjectFloat_Weight.ObjectId = tmpMI.ObjectId
                                 AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
               ORDER BY Object_Goods.ValueData, Object_GoodsKind.ValueData
               )

     SELECT ROW_NUMBER() OVER(ORDER BY tmpRes.GoodsName) :: TVarChar AS Ord
          , tmpRes.GoodsCode     :: Integer
          --, tmpRes.BarCode       :: TVarChar 
          , tmpRes.GoodsName     ::TVarChar
          , tmpRes.GoodsKindName ::TVarChar
          , tmpRes.MeasureName   ::TVarChar
          , tmpRes.Amount        ::TFloat
          , tmpRes.PriceNoVAT         ::TFloat
          , tmpRes.AmountSummNoVAT    ::TFloat
          --, vbVATPercent              ::TFloat AS VATPercent
     FROM tmpRes   
     ;
     ELSE
         RAISE EXCEPTION 'Ошибка.Для выгрузки <%> не предусмотрен формат XSL', lfGet_Object_ValueData_sh (vbExportKindId);
     END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.04.21         *
 25.03.21                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_Email_xls_Send (inMovementId:= 21495529 , inSession:= zfCalc_UserAdmin())
