-- Function: gpSelect_Movement_Quality_Condra()

DROP FUNCTION IF EXISTS gpSelect_Movement_Quality_Condra (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Quality_Condra(
    IN inMovementId         Integer  , -- ключ Документа
    IN inSession            TVarChar   -- сессия пользователя
)
RETURNS TABLE (MovementId_sale        Integer
             , MovementId_edi         Integer
               -- DocumentId
             , DocumentId_vch         TVarChar
               -- DealId
             , DealId                 TVarChar
               -- VchasnoId
             , VchasnoId              TVarChar
               -- ІД Desadv
             , DocId_vch              TVarChar

             , InvNumber_order        TVarChar
             , InvNumber              TVarChar
             , FileName               TVarChar
             , sender_gln             TVarChar
             , recipient_gln          TVarChar
             , buyer_gln              TVarChar
             , number                 TVarChar
             , document_function_code TVarChar
             , FileName_pdf           TVarChar
             , doc_to_attach_id       TVarChar
             , doc_to_attach_number   TVarChar
             , MetaData               Text

               -- Тип сертифікату (quality_certificate, manufacturers_declaration)
             , certificate_type TVarChar
               -- Опис сертифікату (1-256 символів)
             , description      TVarChar
               -- Номер сертифікату (1-128 символів)
             , number_Quality_vch      TVarChar
               -- Дата видачі сертифікату
             , date_of_issue    TDateTime
               -- Дата початку дії сертифікату
             , active_from      TDateTime
               -- Дата закінчення дії сертифікату
             , active_to        TDateTime
               -- доступні значення 'time_limited' or 'batch_limited'".
             , domain           TVarChar
               -- № партии
             , batch_number     TVarChar

             , MetaData_goods   Text
             , MetaData_active  TVarChar
              )
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbPartnerId Integer;
    DECLARE vbPaidKindId Integer;
    DECLARE vbContractId Integer;
    DECLARE vbGoodsPropertyId Integer;
    DECLARE vbGoodsPropertyId_basis Integer;
    DECLARE vbOperDate TDateTime;
    DECLARE vbIsGoodsCode Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);


     -- параметр из документа
     vbOperDate  := (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId);
     vbPaidKindId:= (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId IN (zc_MovementLinkObject_PaidKind(), zc_MovementLinkObject_PaidKindTo()));
     vbContractId:= (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId IN (zc_MovementLinkObject_Contract(), zc_MovementLinkObject_ContractTo()));
     vbPartnerId := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId IN (zc_MovementLinkObject_To()));
     vbGoodsPropertyId:= (SELECT zfCalc_GoodsPropertyId (vbContractId
                                                       , COALESCE ((SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbPartnerId AND OL.DescId = zc_ObjectLink_Partner_Juridical()), vbPartnerId)
                                                       , vbPartnerId
                                                        ));
     -- параметр
     vbGoodsPropertyId_basis:= (SELECT zfCalc_GoodsPropertyId (0, zc_Juridical_Basis(), 0));

     -- Параметры - захардкодили
     SELECT -- ТОВАРИСТВО З ОБМЕЖЕНОЮ ВІДПОВІДАЛЬНІСТЮ"АРІТЕЙЛ"
            CASE WHEN OH_JuridicalDetails_To.OKPO = '41135005'
                      THEN TRUE
                      ELSE FALSE
            END AS isGoodsCode

            INTO vbIsGoodsCode

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

     --
     RETURN QUERY
       WITH tmpMI AS (SELECT DISTINCT
                             MovementItem.ObjectId AS GoodsId
                           , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                      FROM MovementItem
                           LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                       ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                      AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                            ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                      WHERE MovementItem.MovementId = inMovementId
                        AND MovementItem.DescId     = zc_MI_Master()
                        AND MovementItem.isErased   = FALSE
                        AND MIFloat_AmountPartner.ValueData > 0
                     )
     , tmpObject_GoodsPropertyValue AS
                    (SELECT ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                          , ObjectLink_GoodsPropertyValue_Goods.ChildObjectId                   AS GoodsId
                          , COALESCE (ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId, 0) AS GoodsKindId
                          , Object_GoodsPropertyValue.ValueData  AS Name
                            --
                          , ObjectString_Article.ValueData       AS Article
                          , ObjectString_ArticleGLN.ValueData    AS ArticleGLN
                          , ObjectString_BarCode.ValueData       AS BarCode
                          , ObjectString_BarCodeGLN.ValueData    AS BarCodeGLN
                     FROM (SELECT vbGoodsPropertyId AS GoodsPropertyId WHERE vbGoodsPropertyId <> 0
                          ) AS tmpGoodsProperty
                          INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                                ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = tmpGoodsProperty.GoodsPropertyId
                                               AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
                          LEFT JOIN Object AS Object_GoodsPropertyValue ON Object_GoodsPropertyValue.Id = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                          LEFT JOIN ObjectString AS ObjectString_BarCode
                                                 ON ObjectString_BarCode.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                AND ObjectString_BarCode.DescId = zc_ObjectString_GoodsPropertyValue_BarCode()
                          LEFT JOIN ObjectString AS ObjectString_BarCodeGLN
                                                 ON ObjectString_BarCodeGLN.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                AND ObjectString_BarCodeGLN.DescId = zc_ObjectString_GoodsPropertyValue_BarCodeGLN()
                          LEFT JOIN ObjectString AS ObjectString_Article
                                                 ON ObjectString_Article.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                AND ObjectString_Article.DescId = zc_ObjectString_GoodsPropertyValue_Article()
                          LEFT JOIN ObjectString AS ObjectString_ArticleGLN
                                                 ON ObjectString_ArticleGLN.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                AND ObjectString_ArticleGLN.DescId = zc_ObjectString_GoodsPropertyValue_ArticleGLN()
                          INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                                ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                               AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
                                               -- Только эти товары
                                               AND ObjectLink_GoodsPropertyValue_Goods.ChildObjectId IN (SELECT DISTINCT tmpMI.GoodsId FROM tmpMI)
                          LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                               ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                              AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
                    )
     , tmpObject_GoodsPropertyValueGroup AS
                    (SELECT tmpObject_GoodsPropertyValue.GoodsId
                          , tmpObject_GoodsPropertyValue.BarCode
                          , tmpObject_GoodsPropertyValue.BarCodeGLN
                          , tmpObject_GoodsPropertyValue.Article
                          , tmpObject_GoodsPropertyValue.ArticleGLN
                     FROM (SELECT MAX (tmpObject_GoodsPropertyValue.ObjectId) AS ObjectId, GoodsId FROM tmpObject_GoodsPropertyValue WHERE BarCode <> '' OR BarCodeGLN <> '' GROUP BY GoodsId
                          ) AS tmpGoodsProperty_find
                          LEFT JOIN tmpObject_GoodsPropertyValue ON tmpObject_GoodsPropertyValue.ObjectId =  tmpGoodsProperty_find.ObjectId
                    )
     , tmpObject_GoodsPropertyValue_basis AS
                    (SELECT ObjectLink_GoodsPropertyValue_Goods.ChildObjectId AS GoodsId
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
                                               -- Только эти товары
                                               AND ObjectLink_GoodsPropertyValue_Goods.ChildObjectId IN (SELECT DISTINCT tmpMI.GoodsId FROM tmpMI)
                          LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                               ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                              AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
                    )
          , tmpDataMI AS
                   (SELECT (CASE WHEN tmpObject_GoodsPropertyValue.Name <> '' THEN tmpObject_GoodsPropertyValue.Name WHEN tmpObject_GoodsPropertyValue_basis.Name <> '' THEN tmpObject_GoodsPropertyValue_basis.Name ELSE Object_Goods.ValueData END || CASE WHEN COALESCE (Object_GoodsKind.Id, zc_Enum_GoodsKind_Main()) = zc_Enum_GoodsKind_Main() THEN '' ELSE ' ' || Object_GoodsKind.ValueData END) :: TVarChar AS GoodsName
                         , CASE WHEN 1=1 OR COALESCE (tmpObject_GoodsPropertyValueGroup.BarCodeGLN, COALESCE (tmpObject_GoodsPropertyValue.BarCodeGLN, '')) <> ''
                                THEN COALESCE (tmpObject_GoodsPropertyValueGroup.BarCodeGLN, COALESCE (tmpObject_GoodsPropertyValue.BarCodeGLN, ''))
                                ELSE COALESCE (tmpObject_GoodsPropertyValueGroup.BarCode,    COALESCE (tmpObject_GoodsPropertyValue.BarCode, ''))
                           END AS BarCodeGLN_Juridical
                    FROM tmpMI
                         LEFT JOIN tmpObject_GoodsPropertyValue ON tmpObject_GoodsPropertyValue.GoodsId = tmpMI.GoodsId
                                                               AND tmpObject_GoodsPropertyValue.GoodsKindId = tmpMI.GoodsKindId
                                                               AND (tmpObject_GoodsPropertyValue.Article <> ''
                                                                 OR tmpObject_GoodsPropertyValue.ArticleGLN <> ''
                                                                 OR tmpObject_GoodsPropertyValue.Name <> ''
                                                                   )
                         LEFT JOIN tmpObject_GoodsPropertyValueGroup ON tmpObject_GoodsPropertyValueGroup.GoodsId = tmpMI.GoodsId
                                                                    AND tmpObject_GoodsPropertyValue.GoodsId IS NULL
                         LEFT JOIN tmpObject_GoodsPropertyValue_basis ON tmpObject_GoodsPropertyValue_basis.GoodsId = tmpMI.GoodsId
                                                                     AND tmpObject_GoodsPropertyValue_basis.GoodsKindId = tmpMI.GoodsKindId

                         LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
                         LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMI.GoodsKindId
                         LEFT JOIN ObjectString AS ObjectString_Goods_BUH
                                                ON ObjectString_Goods_BUH.ObjectId = tmpMI.GoodsId
                                               AND ObjectString_Goods_BUH.DescId = zc_ObjectString_Goods_BUH()
                         LEFT JOIN ObjectDate AS ObjectDate_BUH
                                              ON ObjectDate_BUH.ObjectId = tmpMI.GoodsId
                                             AND ObjectDate_BUH.DescId = zc_ObjectDate_Goods_BUH()

                    ORDER BY CASE WHEN vbGoodsPropertyId IN (83954  -- Метро
                                                           , 83963  -- Ашан
                                                           , 404076 -- Новус
                                                           , 83956  -- Фора
                                                            )
                                       THEN zfConvert_StringToNumber (COALESCE (tmpObject_GoodsPropertyValueGroup.Article, COALESCE (tmpObject_GoodsPropertyValue.Article, '0')))
                                  ELSE '0'
                             END :: Integer
                           , CASE WHEN vbIsGoodsCode = TRUE THEN Object_Goods.ObjectCode ELSE 0 END
                           , CASE WHEN ObjectString_Goods_BUH.ValueData <> '' AND vbOperDate >= ObjectDate_BUH.ValueData THEN ObjectString_Goods_BUH.ValueData ELSE Object_Goods.ValueData END
                           , Object_GoodsKind.ValueData
                           , Object_Goods.ValueData, Object_GoodsKind.ValueData
                   )

          , tmpData AS (SELECT Movement.Id               AS MovementId
                             , Movement.InvNumber        AS InvNumber
                             , MovementDate_OperDatePartner.ValueData AS OperDatePartner
                             , Movement_order.Id         AS MovementId_order
                             , Movement_EDI.Id           AS MovementId_edi
                           --, MovementString_InvNumberPartner.ValueData AS InvNumber_order
                             , MovementString_InvNumberPartner_order.ValueData AS InvNumber_order
                               --
                             , zfCalc_GLNCodeCorporate (inGLNCode                  := ObjectString_Partner_GLNCode.ValueData
                                                      , inGLNCodeCorporate_partner := ObjectString_Partner_GLNCodeCorporate.ValueData
                                                      , inGLNCodeCorporate_retail  := ObjectString_Retail_GLNCodeCorporate.ValueData
                                                      , inGLNCodeCorporate_main    := ObjectString_JuridicalFrom_GLNCode.ValueData
                                                       ) AS SenderGLNCode
                               -- GLN одержувача повідомлення
                             , zfCalc_GLNCodeRetail
                                          (inGLNCode               := ObjectString_Partner_GLNCode.ValueData
                                         , inGLNCodeRetail_partner := CASE WHEN TRIM (ObjectString_Partner_GLNCodeRetail.ValueData) = '4823036500001' THEN ObjectString_Partner_GLNCodeJuridical.ValueData ELSE ObjectString_Partner_GLNCodeRetail.ValueData END
                                         , inGLNCodeRetail         := ObjectString_Retail_GLNCode.ValueData
                                         , inGLNCodeJuridical      := ObjectString_Juridical_GLNCode.ValueData
                                          ) AS RecipientGLNCode

                               -- GLN покупця
                             , zfCalc_GLNCodeJuridical (inGLNCode                  := ObjectString_Partner_GLNCode.ValueData
                                                      , inGLNCodeJuridical_partner := ObjectString_Partner_GLNCodeJuridical.ValueData
                                                      , inGLNCodeJuridical         := ObjectString_Juridical_GLNCode.ValueData
                                                       ) AS BuyerGLNCode

                               -- GLN місця доставки
                             , ObjectString_Partner_GLNCode.ValueData     AS DeliveryPlaceGLNCode

                               -- DocumentId
                             , MovementString_DocumentId_vch.ValueData    AS DocumentId_vch
                               -- DealId
                             , MovementString_DealId.ValueData            AS DealId
                               -- VchasnoId
                             , MovementString_VchasnoId.ValueData         AS VchasnoId
                               -- ІД Desadv
                             , MovementString_DocId_vch.ValueData         AS DocId_vch

                        FROM MovementLinkMovement AS MovementLinkMovement_Order
                             LEFT JOIN Movement AS Movement_order ON Movement_order.Id = MovementLinkMovement_Order.MovementChildId
                             LEFT JOIN MovementString AS MovementString_InvNumberPartner_order
                                                      ON MovementString_InvNumberPartner_order.MovementId = Movement_order.Id
                                                     AND MovementString_InvNumberPartner_order.DescId     = zc_MovementString_InvNumberPartner()

                             LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Order_edi
                                                            ON MovementLinkMovement_Order_edi.MovementId = Movement_order.Id
                                                           AND MovementLinkMovement_Order_edi.DescId = zc_MovementLinkMovement_Order()
                             LEFT JOIN Movement AS Movement_EDI ON Movement_EDI.Id = MovementLinkMovement_Order_edi.MovementChildId
                             LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                                      ON MovementString_InvNumberPartner.MovementId = Movement_EDI.Id
                                                     AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

                             -- DealId
                             LEFT JOIN MovementString AS MovementString_DealId
                                                      ON MovementString_DealId.MovementId = Movement_EDI.Id
                                                     AND MovementString_DealId.DescId = zc_MovementString_DealId()
                             -- DocumentId
                             LEFT JOIN MovementString AS MovementString_DocumentId_vch
                                                      ON MovementString_DocumentId_vch.MovementId = Movement_EDI.Id
                                                     AND MovementString_DocumentId_vch.DescId = zc_MovementString_DocumentId_vch()
                             -- VchasnoId
                             LEFT JOIN MovementString AS MovementString_VchasnoId
                                                      ON MovementString_VchasnoId.MovementId = Movement_EDI.Id
                                                     AND MovementString_VchasnoId.DescId = zc_MovementString_VchasnoId()
                             -- ІД Desadv
                             LEFT JOIN MovementString AS MovementString_DocId_vch
                                                      ON MovementString_DocId_vch.MovementId = Movement_EDI.Id
                                                     AND MovementString_DocId_vch.DescId     = zc_MovementString_DocId_vch()


                             LEFT JOIN Movement ON Movement.Id = inMovementId
                             LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                                    ON MovementDate_OperDatePartner.MovementId = inMovementId
                                                   AND MovementDate_OperDatePartner.DescId     = zc_MovementDate_OperDatePartner()

                             LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                          ON MovementLinkObject_From.MovementId = inMovementId
                                                         AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                             LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
                             LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                                  ON ObjectLink_Unit_Juridical.ObjectId = Object_From.Id
                                                 AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                                                 AND vbContractId = 0


                             LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                                          ON MovementLinkObject_Partner.MovementId = inMovementId
                                                         AND MovementLinkObject_Partner.DescId     = zc_MovementLinkObject_Partner()
                             LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                          ON MovementLinkObject_To.MovementId = inMovementId
                                                         AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                             LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

                             LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                  ON ObjectLink_Partner_Juridical.ObjectId = Object_To.Id
                                                 AND ObjectLink_Partner_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()

                             LEFT JOIN Object_Contract_View AS View_Contract ON View_Contract.ContractId = vbContractId -- MovementLinkObject_Contract.ObjectId
                             LEFT JOIN ObjectDate AS ObjectDate_Signing
                                                  ON ObjectDate_Signing.ObjectId = View_Contract.ContractId -- MovementLinkObject_Contract.ObjectId
                                                 AND ObjectDate_Signing.DescId = zc_ObjectDate_Contract_Signing()
                                                 AND View_Contract.InvNumber <> '-'

                             -- Юридическое лицо(печать док.)
                             LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalDocument
                                                  ON ObjectLink_Contract_JuridicalDocument.ObjectId = View_Contract.ContractId -- MovementLinkObject_Contract.ObjectId
                                                 AND ObjectLink_Contract_JuridicalDocument.DescId = zc_ObjectLink_Contract_JuridicalDocument()
                                                 AND vbPaidKindId = zc_Enum_PaidKind_SecondForm()
                             -- Дата для Юр. лица история(печать док.)
                             LEFT JOIN ObjectDate AS ObjectDate_JuridicalDoc_Next
                                                  ON ObjectDate_JuridicalDoc_Next.ObjectId = View_Contract.ContractId -- MovementLinkObject_Contract.ObjectId
                                                 AND ObjectDate_JuridicalDoc_Next.DescId   = zc_ObjectDate_Contract_JuridicalDoc_Next()
                                                 AND vbPaidKindId = zc_Enum_PaidKind_SecondForm()
                                                 AND ObjectDate_JuridicalDoc_Next.ValueData <= MovementDate_OperDatePartner.ValueData
                             -- Юридическое лицо история(печать док.)
                             LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalDoc_Next
                                                  ON ObjectLink_Contract_JuridicalDoc_Next.ObjectId = ObjectDate_JuridicalDoc_Next.ObjectId
                                                 AND ObjectLink_Contract_JuridicalDoc_Next.DescId   = zc_ObjectLink_Contract_JuridicalDoc_Next()
                                                 AND vbPaidKindId = zc_Enum_PaidKind_SecondForm()

                             LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate
                                                                         AS OH_JuridicalDetails_From
                                                                         ON OH_JuridicalDetails_From.JuridicalId = COALESCE (ObjectLink_Contract_JuridicalDoc_Next.ChildObjectId
                                                                                                                           , ObjectLink_Contract_JuridicalDocument.ChildObjectId
                                                                                                                           , View_Contract.JuridicalBasisId
                                                                                                                           , ObjectLink_Unit_Juridical.ChildObjectId
                                                                                                                           , Object_From.Id
                                                                                                                            )
                                                                        AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) >= OH_JuridicalDetails_From.StartDate
                                                                        AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) <  OH_JuridicalDetails_From.EndDate
                             LEFT JOIN ObjectString AS ObjectString_JuridicalFrom_GLNCode
                                                    ON ObjectString_JuridicalFrom_GLNCode.ObjectId = OH_JuridicalDetails_From.JuridicalId
                                                   AND ObjectString_JuridicalFrom_GLNCode.DescId = zc_ObjectString_Juridical_GLNCode()

                             LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate
                                                                         AS OH_JuridicalDetails_To
                                                                         ON OH_JuridicalDetails_To.JuridicalId = COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, Object_To.Id)
                                                                        AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) >= OH_JuridicalDetails_To.StartDate
                                                                        AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) <  OH_JuridicalDetails_To.EndDate
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

                        WHERE MovementLinkMovement_Order.MovementId = inMovementId
                          AND MovementLinkMovement_Order.DescId     = zc_MovementLinkMovement_Order()
                       )
       -- Результат
       SELECT
              tmpData.MovementId AS MovementId_sale
              -- DocumentId
            , tmpData.MovementId_edi
              -- DocumentId
            , tmpData.DocumentId_vch
              -- DealId
            , tmpData.DealId
              -- VchasnoId
            , tmpData.VchasnoId
              -- ІД Desadv
            , tmpData.DocId_vch

            , tmpData.InvNumber_order
            , tmpData.InvNumber
              -- имя отправляемого файла (с диска)
            , (gpGet.outFileName || '.pdf') :: TVarChar AS FileName
              --
            , COALESCE (tmpData.SenderGLNCode, '')         :: TVarChar  AS sender_gln
            , CASE WHEN tmpData.RecipientGLNCode <> '' THEN tmpData.RecipientGLNCode ELSE COALESCE (tmpData.BuyerGLNCode, '') END :: TVarChar AS recipient_gln
            , COALESCE (tmpData.BuyerGLNCode, '')          :: TVarChar AS buyer_gln
            , ('Doc_' || COALESCE (tmpData.InvNumber, '')) :: TVarChar AS number -- tmpData.InvNumber_order
            , '2002'                                       :: TVarChar AS document_function_code
            , ''                                           :: TVarChar AS FileName_pdf
          --, COALESCE (gpGet.outFileName, '')             :: TVarChar AS FileName_pdf

              -- ІД Desadv
            , COALESCE (tmpData.DocId_vch, '')             :: TVarChar AS doc_to_attach_id -- DocumentId_vch -- VchasnoId -- tmpData.DealId
            , COALESCE (tmpData.InvNumber_order, '')       :: TVarChar AS doc_to_attach_number

              -- джейсон с описанием
            , ('{"sender_gln": "' || COALESCE (tmpData.SenderGLNCode, '') || '",'
             ||'"recipient_gln": "' || CASE WHEN tmpData.RecipientGLNCode <> '' THEN tmpData.RecipientGLNCode ELSE COALESCE (tmpData.BuyerGLNCode, '') END || '",'
             ||'"buyer_gln": "' || COALESCE (tmpData.BuyerGLNCode, '') || '",'
             ||'"number": "' || COALESCE (tmpData.InvNumber, '') || '",' -- tmpData.InvNumber
             ||'"document_function_code": "2002",'
             ||'"file": "' || COALESCE (gpGet.outFileName, '') || '.pdf' || '",'
             ||'"doc_to_attach_id": "'  || COALESCE (tmpData.DocId_vch, '') || '",' -- DocumentId_vch -- VchasnoId
             ||'"doc_to_attach_number": "' || COALESCE (tmpData.InvNumber_order, '') || '"'
             ||'}') :: Text AS MetaData

               -- Тип сертифікату (quality_certificate, manufacturers_declaration)
           --, 'manufacturers_declaration' ::TVarChar AS certificate_type
             , 'quality_certificate' ::TVarChar AS certificate_type
               -- Опис сертифікату (1-256 символів)
           --, zfCalc_InvNumber_isErased ('', tmpData.InvNumber, tmpData.OperDatePartner, zc_Enum_Status_Complete()) AS description
             , ('N ' || tmpData.InvNumber || ' ' || zfConvert_DateToString (tmpData.OperDatePartner)) :: TVarChar AS description
           --, ('test : ' || tmpData.InvNumber) :: TVarChar AS description
               -- Номер сертифікату (1-128 символів)
             , tmpData.InvNumber AS number_Quality_vch
               -- Дата видачі сертифікату
             , tmpData.OperDatePartner AS date_of_issue
               -- Дата початку дії сертифікату
             , tmpData.OperDatePartner AS active_from
               -- Дата закінчення дії сертифікату
             , (tmpData.OperDatePartner + INTERVAL '1 MONTH') :: TDateTime AS active_to

               -- доступні значення 'time_limited' or 'batch_limited'".
             , 'batch_limited' :: TVarChar AS domain 
               -- № партии
             , tmpData.MovementId :: TVarChar AS batch_number
             
              -- джейсон - Товары
             , ('{"products": ['
              || (SELECT STRING_AGG ('{' || '"ean_code": ' || '"' || tmpDataMI.BarCodeGLN_Juridical || '",'
                                         || '"title": '    || '"' || REPLACE (tmpDataMI.GoodsName, '"', '\"') || '"}'
                                   , ',' 
                                    ) 
                  FROM tmpDataMI
                 )
              ||']'
              ||'}'
               ) :: Text AS MetaData_goods
               
               -- джейсон - Активувати - змінити статус на active
             , '{"status": "active"}' :: TVarChar AS MetaData_active
             

       FROM gpGet_Movement_Quality_ReportName_export (inMovementId, inSession) AS gpGet
            LEFT JOIN tmpData ON tmpData.MovementId = inMovementId
     ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 15.07.25                                        *
*/

-- тест
-- SELECT right (MetaData, 200), MetaData_goods, * FROM gpSelect_Movement_Quality_Condra (inMovementId:= 31811109 , inSession:= zfCalc_UserAdmin());
