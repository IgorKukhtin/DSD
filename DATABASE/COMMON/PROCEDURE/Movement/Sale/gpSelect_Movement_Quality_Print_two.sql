-- Function: gpSelect_Movement_Quality_Print_two()

DROP FUNCTION IF EXISTS gpSelect_Movement_Quality_Print_two (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Quality_Print_two(
    IN inMovementId         Integer  , -- ключ Документа
    in inisAll              Boolean  , --
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE vbGoodsPropertyId Integer;

    DECLARE vbOperDate  TDateTime;
    DECLARE vbOperDatePartner TDateTime;
    DECLARE vbIsLongUKTZED Boolean;
    DECLARE vbToId Integer;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
     vbUserId:= lpGetUserBySession (inSession);


     -- параметр из документа - !!!временно!!!
     vbOperDate:= (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId);
     -- параметр из документа
     vbOperDatePartner:= (SELECT MovementDate.ValueData FROM MovementDate WHERE MovementDate.MovementId = inMovementId AND MovementDate.DescId = zc_MovementDate_OperDatePartner());
                                
     -- Юр лицо
     vbToId := (SELECT MovementLinkObject_To.ObjectId AS ToId
                FROM MovementLinkObject AS MovementLinkObject_To
                WHERE MovementLinkObject_To.MovementId = inMovementId
                  AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                );

   /*  -- выбираем все док для печати качественных   (1 или все)
     CREATE TEMP TABLE tmpMovement (Id Integer) ON COMMIT DROP;
     INSERT INTO tmpMovement (Id)
          SELECT DISTINCT Movement_Sale.Id AS Id
          FROM Movement
              LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Child
                                             ON MovementLinkMovement_Child.MovementId = Movement.Id
                                            AND MovementLinkMovement_Child.DescId = zc_MovementLinkMovement_Child()
              INNER JOIN Movement AS Movement_Sale ON Movement_Sale.Id = MovementLinkMovement_Child.MovementChildId
                                                  AND Movement_Sale.StatusId = zc_Enum_Status_Complete()
              INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                            ON MovementLinkObject_To.MovementId = Movement_Sale.Id
                                           AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                           AND MovementLinkObject_To.ObjectId = vbToId
          WHERE Movement.DescId = zc_Movement_QualityDoc()
            AND Movement.OperDate = vbOperDate
            AND Movement.StatusId = zc_Enum_Status_Complete()
            AND inisAll = TRUE
         UNION ALL
          SELECT inMovementId AS Id
          WHERE inisAll = FALSE
         ;

     -- параметр из документа
     vbIsLongUKTZED:= TRUE;

     -- определяется параметр
     --vbGoodsPropertyId:=
     CREATE TEMP TABLE tmpGoodsProperty (MovementId Integer, GoodsPropertyId Integer) ON COMMIT DROP;
     INSERT INTO tmpGoodsProperty (MovementId, GoodsPropertyId)
       SELECT DISTINCT Movement.Id AS MovementId
            , zfCalc_GoodsPropertyId (MovementLinkObject_Contract.ObjectId
                                    , COALESCE (ObjectLink_Partner_Juridical.ChildObjectId
                                    , MovementLinkObject_To.ObjectId)
                                    , MovementLinkObject_To.ObjectId
                                     ) AS GoodsPropertyId
       FROM tmpMovement AS Movement
            LEFT JOIN MovementLinkMovement AS MLM_Child
                                           ON MLM_Child.MovementChildId = Movement.Id
                                          AND MLM_Child.DescId          = zc_MovementLinkMovement_Child()
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = MLM_Child.MovementId
                                        AND MovementLinkObject_Contract.DescId     = zc_MovementLinkObject_Contract()
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = MLM_Child.MovementChildId
                                        AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                 ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                                AND ObjectLink_Partner_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()
       ;
*/
     CREATE TEMP TABLE tmpCursor1 (MovementId Integer
                              , InvNumber  TVarChar
                              , OperDate TDateTime
                              , InvNumberPartner TVarChar
                              , OperDatePartner TDateTime
                              , JuridicalName_From  TVarChar
                              , JuridicalAddress_From  TVarChar
                              , Phone_From  TVarChar
                              , ContractName  TVarChar
                              , PartnerName  TVarChar
                              , GoodsGroupName  TVarChar
                              , MeasureName  TVarChar
                              , GoodsCode  TVarChar
                              , CodeUKTZED TVarChar
                              , Article_Juridical  TVarChar
                              , Quality2_Juridical  TVarChar
                              , Quality10_Juridical  TVarChar
                              , GoodsName TVarChar
                              , GoodsKindName TVarChar
                              , AmountPartner  TFloat
                              , AmountPartner_str TVarChar
                              , Amount5 TFloat
                              , Amount9  TFloat
                              , Amount13 TFloat
                              , OperDateIn TDateTime
                              , OperDateIn_str4 TDateTime
                              , OperDateOut TDateTime
                              , OperDate_end TDateTime
                              , OperDate_part TDateTime
                              , NormInDays_gk_str TVarChar
                              , CarModelName TVarChar
                              , CarName TVarChar
                              , isJuridicalBasis Boolean
                              , Main_str TVarChar
                              , QualityCode TVarChar
                              , QualityName TVarChar
                              , QualityComment Text
                              , Value17  Text
                              , Value1 TVarChar
                              , Value2 TVarChar
                              , Value3 TVarChar
                              , Value4 TVarChar
                              , Value5 TVarChar
                              , Value6 TVarChar
                              , Value7 TVarChar
                              , Value8 TVarChar
                              , Value9 TVarChar
                              , Value10 TVarChar
                              , Value11_gk TVarChar
                              , InvNumber_Quality TVarChar
                              , OperDate_Quality TDateTime
                              , OperDateCertificate TVarChar
                              , CertificateNumber TVarChar
                              , CertificateSeries TVarChar
                              , CertificateSeriesNumber TVarChar
                              , ExpertPrior Text
                              , ExpertLast Text
                              , QualityNumber TVarChar
                              , QualityComment_Movement Text
                              , ReportType TVarChar
                              , InvNumber_Order TVarChar) ON COMMIT DROP;
     INSERT INTO tmpCursor1 (MovementId, InvNumber, OperDate, InvNumberPartner, OperDatePartner
                        , JuridicalName_From, JuridicalAddress_From, Phone_From, ContractName, PartnerName
                        , GoodsGroupName, MeasureName, GoodsCode, CodeUKTZED, Article_Juridical
                        , Quality2_Juridical, Quality10_Juridical
                        , GoodsName , GoodsKindName , AmountPartner, AmountPartner_str
                        , Amount5 , Amount9, Amount13
                        , OperDateIn, OperDateIn_str4 , OperDateOut , OperDate_end , OperDate_part
                        , NormInDays_gk_str , CarModelName, CarName
                        , isJuridicalBasis, Main_str
                        , QualityCode, QualityName, QualityComment
                        , Value17  , Value1 , Value2, Value3, Value4, Value5, Value6, Value7, Value8, Value9, Value10, Value11_gk
                        , InvNumber_Quality, OperDate_Quality, OperDateCertificate, CertificateNumber, CertificateSeries, CertificateSeriesNumber
                        , ExpertPrior, ExpertLast
                        , QualityNumber, QualityComment_Movement
                        , ReportType, InvNumber_Order)
  WITH
  tmpMovement AS (
          SELECT DISTINCT Movement_Sale.Id AS Id
          FROM Movement
              LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Child
                                             ON MovementLinkMovement_Child.MovementId = Movement.Id
                                            AND MovementLinkMovement_Child.DescId = zc_MovementLinkMovement_Child()
              INNER JOIN Movement AS Movement_Sale ON Movement_Sale.Id = MovementLinkMovement_Child.MovementChildId
                                                  AND Movement_Sale.StatusId = zc_Enum_Status_Complete()
              INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                            ON MovementLinkObject_To.MovementId = Movement_Sale.Id
                                           AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                           AND MovementLinkObject_To.ObjectId = vbToId
          WHERE Movement.DescId = zc_Movement_QualityDoc()
            AND Movement.OperDate = vbOperDate
            AND Movement.StatusId = zc_Enum_Status_Complete()
            AND inisAll = TRUE
         UNION ALL
          SELECT inMovementId AS Id
          WHERE inisAll = FALSE
         )

   , tmpGoodsProperty AS(
       SELECT DISTINCT Movement.Id AS MovementId
            , zfCalc_GoodsPropertyId (MovementLinkObject_Contract.ObjectId
                                    , COALESCE (ObjectLink_Partner_Juridical.ChildObjectId
                                    , MovementLinkObject_To.ObjectId)
                                    , MovementLinkObject_To.ObjectId
                                     ) AS GoodsPropertyId
       FROM tmpMovement AS Movement
            LEFT JOIN MovementLinkMovement AS MLM_Child
                                           ON MLM_Child.MovementChildId = Movement.Id
                                          AND MLM_Child.DescId          = zc_MovementLinkMovement_Child()
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = MLM_Child.MovementId
                                        AND MovementLinkObject_Contract.DescId     = zc_MovementLinkObject_Contract()
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = MLM_Child.MovementChildId
                                        AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                 ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                                AND ObjectLink_Partner_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()
      )

,
tmpMI AS
            (SELECT MovementItem.MovementId
                  , MovementItem.ObjectId
                  , SUM (MovementItem.Amount) :: TFloat AS Amount
                  , SUM (CASE WHEN Movement.DescId = zc_Movement_SendOnPrice() THEN MovementItem.Amount ELSE MIFloat_AmountPartner.ValueData END) :: TFloat AS AmountPartner
                  , MILO_GoodsKind.ObjectId             AS GoodsKindId
                  , ObjectLink_GoodsGroup.ChildObjectId AS GoodsGroupId
             FROM tmpMovement
                  INNER JOIN Movement ON Movement.Id = tmpMovement.Id
                  INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                         AND MovementItem.DescId     = zc_MI_Master()
                                         AND MovementItem.isErased   = FALSE

                  INNER JOIN MovementItemFloat AS MIFloat_Price
                                               ON MIFloat_Price.MovementItemId = MovementItem.Id
                                              AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                              AND MIFloat_Price.ValueData <> 0
                  LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                              ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                             AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                  LEFT JOIN MovementItemLinkObject AS MILO_GoodsKind
                                                   ON MILO_GoodsKind.MovementItemId = MovementItem.Id
                                                  AND MILO_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                  LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup
                                       ON ObjectLink_GoodsGroup.ObjectId = MovementItem.ObjectId
                                      AND ObjectLink_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
             WHERE ((MIFloat_AmountPartner.ValueData <> 0 AND Movement.DescId <> zc_Movement_SendOnPrice())
                 OR (MovementItem.Amount <> 0 AND Movement.DescId = zc_Movement_SendOnPrice())
                   )
             GROUP BY MovementItem.MovementId
                    , MovementItem.ObjectId
                    , MILO_GoodsKind.ObjectId
                    , ObjectLink_GoodsGroup.ChildObjectId
            )
          , tmpMIGoodsByGoodsKind AS
                            (SELECT tmpMI.*
                                    -- для вида товара - Вид оболонки, №4
                                  , ObjectString_GK_Value1.ValueData     AS Value1_gk
                                    -- для вида товара - Вид пакування/стан продукції
                                  , ObjectString_GK_Value11.ValueData    AS Value11_gk
                                    -- для вида товара - срок годности в днях
                                  , ObjectFloat_GK_NormInDays.ValueData  AS NormInDays_gk
                                    -- Уменьшение на N дней от даты покупателя в качественном
                                  , ObjectFloat_GK_DaysQ.ValueData       AS DaysQ_gk
                             FROM tmpMI
                                  JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                                                  ON ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId = tmpMI.ObjectId
                                                 AND ObjectLink_GoodsByGoodsKind_Goods.DescId        = zc_ObjectLink_GoodsByGoodsKind_Goods()
                                  JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                                  ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId      = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                 AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId        = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
                                                 AND ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId = tmpMI.GoodsKindId
                                  LEFT JOIN ObjectString AS ObjectString_GK_Value1
                                                         ON ObjectString_GK_Value1.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                        AND ObjectString_GK_Value1.DescId   = zc_ObjectString_GoodsByGoodsKind_Quality1()
                                  LEFT JOIN ObjectString AS ObjectString_GK_Value11
                                                         ON ObjectString_GK_Value11.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                        AND ObjectString_GK_Value11.DescId   = zc_ObjectString_GoodsByGoodsKind_Quality11()
                                  LEFT JOIN ObjectFloat AS ObjectFloat_GK_NormInDays
                                                        ON ObjectFloat_GK_NormInDays.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                       AND ObjectFloat_GK_NormInDays.DescId   = zc_ObjectFloat_GoodsByGoodsKind_NormInDays()
                                  LEFT JOIN ObjectFloat AS ObjectFloat_GK_DaysQ
                                                        ON ObjectFloat_GK_DaysQ.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                       AND ObjectFloat_GK_DaysQ.DescId   = zc_ObjectFloat_GoodsByGoodsKind_DaysQ()
                            )
          , tmpMIGoods AS (SELECT DISTINCT tmpMI.ObjectId AS GoodsId FROM tmpMI)
            -- на дату
          , tmpUKTZED AS (SELECT tmp.GoodsGroupId, lfGet_Object_GoodsGroup_CodeUKTZED_onDate (tmp.GoodsGroupId, vbOperDatePartner) AS CodeUKTZED
                          FROM (SELECT DISTINCT tmpMI.GoodsGroupId FROM tmpMI) AS tmp)

          , tmpGoodsQuality AS
            (SELECT tmpMIGoods.GoodsId          AS GoodsId
                  , Object_Quality.Id           AS QualityId
                  , Object_Quality.ObjectCode   AS QualityCode
                  , Object_Quality.ValueData    AS QualityName
                  , OS_QualityComment.ValueData AS QualityComment

                  , Object_GoodsQuality.ValueData AS Value17
                  , ObjectString_Value1.ValueData AS Value1
                  , ObjectString_Value2.ValueData AS Value2
                  , ObjectString_Value3.ValueData AS Value3
                  , ObjectString_Value4.ValueData AS Value4
                  , ObjectString_Value5.ValueData AS Value5
                  , ObjectString_Value6.ValueData AS Value6
                  , ObjectString_Value7.ValueData AS Value7
                  , ObjectString_Value8.ValueData AS Value8
                  , ObjectString_Value9.ValueData AS Value9
                  , ObjectString_Value10.ValueData AS Value10
              FROM tmpMIGoods
                   INNER JOIN ObjectLink AS ObjectLink_GoodsQuality_Goods
                                         ON ObjectLink_GoodsQuality_Goods.ChildObjectId = tmpMIGoods.GoodsId
                                        AND ObjectLink_GoodsQuality_Goods.DescId = zc_ObjectLink_GoodsQuality_Goods()

                   INNER JOIN Object AS Object_GoodsQuality ON Object_GoodsQuality.Id        = ObjectLink_GoodsQuality_Goods.ObjectId
                                                           AND (Object_GoodsQuality.isErased = FALSE
                                                           --OR vbUserId = 5
                                                               )

                   LEFT JOIN ObjectLink AS ObjectLink_GoodsQuality_Quality
                                        ON ObjectLink_GoodsQuality_Quality.ObjectId = ObjectLink_GoodsQuality_Goods.ObjectId
                                       AND ObjectLink_GoodsQuality_Quality.DescId = zc_ObjectLink_GoodsQuality_Quality()

                   LEFT JOIN Object AS Object_Quality ON Object_Quality.Id = ObjectLink_GoodsQuality_Quality.ChildObjectId
                   LEFT JOIN ObjectString AS OS_QualityComment
                                          ON OS_QualityComment.ObjectId = ObjectLink_GoodsQuality_Quality.ChildObjectId
                                         AND OS_QualityComment.DescId = zc_ObjectString_Quality_Comment()
                   INNER JOIN ObjectFloat AS ObjectFloat_Quality_NumberPrint
                                          ON ObjectFloat_Quality_NumberPrint.ObjectId = ObjectLink_GoodsQuality_Quality.ChildObjectId
                                         AND ObjectFloat_Quality_NumberPrint.DescId = zc_ObjectFloat_Quality_NumberPrint()
                                         AND ObjectFloat_Quality_NumberPrint.ValueData IN (1, 4) -- !!!так захардкодил!!!, вообще их пока 2: вторая для консервов, первая все остальное

                   LEFT JOIN ObjectString AS ObjectString_Value1
                                          ON ObjectString_Value1.ObjectId = ObjectLink_GoodsQuality_Goods.ObjectId
                                         AND ObjectString_Value1.DescId = zc_ObjectString_GoodsQuality_Value1()
                   LEFT JOIN ObjectString AS ObjectString_Value2
                                          ON ObjectString_Value2.ObjectId = ObjectLink_GoodsQuality_Goods.ObjectId
                                         AND ObjectString_Value2.DescId = zc_ObjectString_GoodsQuality_Value2()
                   LEFT JOIN ObjectString AS ObjectString_Value3
                                          ON ObjectString_Value3.ObjectId = ObjectLink_GoodsQuality_Goods.ObjectId
                                         AND ObjectString_Value3.DescId = zc_ObjectString_GoodsQuality_Value3()
                   LEFT JOIN ObjectString AS ObjectString_Value4
                                          ON ObjectString_Value4.ObjectId = ObjectLink_GoodsQuality_Goods.ObjectId
                                         AND ObjectString_Value4.DescId = zc_ObjectString_GoodsQuality_Value4()
                   LEFT JOIN ObjectString AS ObjectString_Value5
                                          ON ObjectString_Value5.ObjectId = ObjectLink_GoodsQuality_Goods.ObjectId
                                         AND ObjectString_Value5.DescId = zc_ObjectString_GoodsQuality_Value5()
                   LEFT JOIN ObjectString AS ObjectString_Value6
                                          ON ObjectString_Value6.ObjectId = ObjectLink_GoodsQuality_Goods.ObjectId
                                         AND ObjectString_Value6.DescId = zc_ObjectString_GoodsQuality_Value6()
                   LEFT JOIN ObjectString AS ObjectString_Value7
                                          ON ObjectString_Value7.ObjectId = ObjectLink_GoodsQuality_Goods.ObjectId
                                         AND ObjectString_Value7.DescId = zc_ObjectString_GoodsQuality_Value7()
                   LEFT JOIN ObjectString AS ObjectString_Value8
                                          ON ObjectString_Value8.ObjectId = ObjectLink_GoodsQuality_Goods.ObjectId
                                         AND ObjectString_Value8.DescId = zc_ObjectString_GoodsQuality_Value8()
                   LEFT JOIN ObjectString AS ObjectString_Value9
                                          ON ObjectString_Value9.ObjectId = ObjectLink_GoodsQuality_Goods.ObjectId
                                         AND ObjectString_Value9.DescId = zc_ObjectString_GoodsQuality_Value9()
                   LEFT JOIN ObjectString AS ObjectString_Value10
                                          ON ObjectString_Value10.ObjectId = ObjectLink_GoodsQuality_Goods.ObjectId
                                         AND ObjectString_Value10.DescId = zc_ObjectString_GoodsQuality_Value10()
            )

          , tmpMovement_find AS
            (SELECT MovementLinkObject_Quality.ObjectId         AS QualityId
                  , MovementLinkMovement_Master.MovementChildId AS MovementId
                  , MovementDate_OperDateIn.ValueData           AS OperDateIn
                  , MovementDate_OperDateOut.ValueData          AS OperDateOut
                  , MovementLinkObject_Car.ObjectId             AS CarId
                  , MS_QualityNumber.ValueData                  AS QualityNumber
                  , MD_OperDateCertificate.ValueData            AS OperDateCertificate
                  , MS_CertificateNumber.ValueData              AS CertificateNumber
                  , MS_CertificateSeries.ValueData              AS CertificateSeries
                  , MS_CertificateSeriesNumber.ValueData        AS CertificateSeriesNumber
             FROM tmpMovement
                  INNER JOIN MovementLinkMovement AS MovementLinkMovement_Child
                                                  ON MovementLinkMovement_Child.MovementChildId = tmpMovement.Id
                                                 AND MovementLinkMovement_Child.DescId = zc_MovementLinkMovement_Child()
                  INNER JOIN Movement ON Movement.Id = MovementLinkMovement_Child.MovementId
                                     AND Movement.StatusId = zc_Enum_Status_Complete()
                  LEFT JOIN MovementDate AS MovementDate_OperDateIn
                                         ON MovementDate_OperDateIn.MovementId =  MovementLinkMovement_Child.MovementId
                                        AND MovementDate_OperDateIn.DescId = zc_MovementDate_OperDateIn()
                  LEFT JOIN MovementDate AS MovementDate_OperDateOut
                                         ON MovementDate_OperDateOut.MovementId =  MovementLinkMovement_Child.MovementId
                                        AND MovementDate_OperDateOut.DescId = zc_MovementDate_OperDateOut()
                  LEFT JOIN MovementLinkObject AS MovementLinkObject_Car
                                               ON MovementLinkObject_Car.MovementId = MovementLinkMovement_Child.MovementId
                                              AND MovementLinkObject_Car.DescId = zc_MovementLinkObject_Car()

                  LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Master
                                                 ON MovementLinkMovement_Master.MovementId = MovementLinkMovement_Child.MovementId
                                                AND MovementLinkMovement_Master.DescId = zc_MovementLinkMovement_Master()
                  LEFT JOIN MovementLinkObject AS MovementLinkObject_Quality
                                               ON MovementLinkObject_Quality.MovementId = MovementLinkMovement_Master.MovementChildId
                                              AND MovementLinkObject_Quality.DescId = zc_MovementLinkObject_Quality()

                  LEFT JOIN Movement AS Movement_QualityNumber
                                     ON Movement_QualityNumber.OperDate = DATE_TRUNC ('DAY', MovementDate_OperDateIn.ValueData)
                                    AND Movement_QualityNumber.DescId = zc_Movement_QualityNumber()
                                    AND Movement_QualityNumber.StatusId = zc_Enum_Status_Complete()

                  LEFT JOIN MovementString AS MS_QualityNumber
                                           ON MS_QualityNumber.MovementId = COALESCE (Movement_QualityNumber.Id, MovementLinkMovement_Child.MovementId) -- tmpMovement_find.MovementId
                                          AND MS_QualityNumber.DescId = zc_MovementString_QualityNumber()
                  LEFT JOIN MovementDate AS MD_OperDateCertificate
                                         ON MD_OperDateCertificate.MovementId = COALESCE (Movement_QualityNumber.Id, MovementLinkMovement_Child.MovementId) -- tmpMovement_find.MovementId
                                        AND MD_OperDateCertificate.DescId = zc_MovementDate_OperDateCertificate()
                  LEFT JOIN MovementString AS MS_CertificateNumber
                                           ON MS_CertificateNumber.MovementId = COALESCE (Movement_QualityNumber.Id, MovementLinkMovement_Child.MovementId) -- tmpMovement_find.MovementId
                                          AND MS_CertificateNumber.DescId = zc_MovementString_CertificateNumber()
                  LEFT JOIN MovementString AS MS_CertificateSeries
                                           ON MS_CertificateSeries.MovementId = COALESCE (Movement_QualityNumber.Id, MovementLinkMovement_Child.MovementId) -- tmpMovement_find.MovementId
                                          AND MS_CertificateSeries.DescId = zc_MovementString_CertificateSeries()
                  LEFT JOIN MovementString AS MS_CertificateSeriesNumber
                                           ON MS_CertificateSeriesNumber.MovementId = COALESCE (Movement_QualityNumber.Id, MovementLinkMovement_Child.MovementId) -- tmpMovement_find.MovementId
                                          AND MS_CertificateSeriesNumber.DescId = zc_MovementString_CertificateSeriesNumber()
            )

          , tmpMovement_QualityParams AS
            (SELECT DISTINCT
                    tmpMovement_find.QualityId
                  , Movement.Id                                        AS Id
                  , Movement.InvNumber                                 AS InvNumber
                  , Movement.OperDate                                  AS OperDate
                  , MS_ExpertPrior.ValueData                           AS ExpertPrior
                  , MS_ExpertLast.ValueData                            AS ExpertLast
                  , MB_Comment.ValueData                               AS Comment
                  , 0                                                  AS ReportType
                  , tmpMovement_find.OperDateIn                        AS OperDateIn
                  , tmpMovement_find.OperDateOut                       AS OperDateOut
                  , tmpMovement_find.CarId                             AS CarId
                  , tmpMovement_find.QualityNumber
                  , tmpMovement_find.OperDateCertificate
                  , tmpMovement_find.CertificateNumber
                  , tmpMovement_find.CertificateSeries
                  , tmpMovement_find.CertificateSeriesNumber
             FROM tmpMovement_find
                  LEFT JOIN Movement ON Movement.Id = tmpMovement_find.MovementId
                  LEFT JOIN MovementString AS MS_ExpertPrior
                                           ON MS_ExpertPrior.MovementId =  tmpMovement_find.MovementId
                                          AND MS_ExpertPrior.DescId = zc_MovementString_ExpertPrior()
                  LEFT JOIN MovementString AS MS_ExpertLast
                                           ON MS_ExpertLast.MovementId =  tmpMovement_find.MovementId
                                          AND MS_ExpertLast.DescId = zc_MovementString_ExpertLast()
                  LEFT JOIN MovementBlob AS MB_Comment
                                         ON MB_Comment.MovementId =  tmpMovement_find.MovementId
                                        AND MB_Comment.DescId = zc_MovementBlob_Comment()
            )
       -- список Названия покупателя для товаров + GoodsKindId
     , tmpObject_GoodsPropertyValue AS (SELECT ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                             , ObjectLink_GoodsPropertyValue_Goods.ChildObjectId                   AS GoodsId
                                             , COALESCE (ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId, 0) AS GoodsKindId
                                             , Object_GoodsPropertyValue.ValueData  AS Name
                                             , ObjectString_Article.ValueData       AS Article
                                               -- Значение ГОСТ, ДСТУ,ТУ (КУ)
                                             , ObjectString_Quality.ValueData       AS Quality
                                               -- Строк придатності (КУ)
                                             , ObjectString_Quality2.ValueData      AS Quality2
                                               -- Умови зберігання (КУ)
                                             , ObjectString_Quality10.ValueData     AS Quality10
                                               --
                                             , tmpGoodsProperty.MovementId
                                        FROM (SELECT tmpGoodsProperty.GoodsPropertyId, tmpGoodsProperty.MovementId
                                              FROM tmpGoodsProperty
                                              WHERE tmpGoodsProperty.GoodsPropertyId <> 0
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
                                             LEFT JOIN ObjectString AS ObjectString_Article
                                                                    ON ObjectString_Article.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                                   AND ObjectString_Article.DescId = zc_ObjectString_GoodsPropertyValue_Article()
                                             LEFT JOIN ObjectString AS ObjectString_Quality
                                                                    ON ObjectString_Quality.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                                   AND ObjectString_Quality.DescId = zc_ObjectString_GoodsPropertyValue_Quality()
                                                                   AND ObjectString_Quality.ValueData <> ''
                                             LEFT JOIN ObjectString AS ObjectString_Quality2
                                                                    ON ObjectString_Quality2.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                                   AND ObjectString_Quality2.DescId = zc_ObjectString_GoodsPropertyValue_Quality2()
                                             LEFT JOIN ObjectString AS ObjectString_Quality10
                                                                    ON ObjectString_Quality10.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                                   AND ObjectString_Quality10.DescId = zc_ObjectString_GoodsPropertyValue_Quality10()
                                       )
       -- список Названия для товаров (нужны если не найдем по GoodsKindId)
     , tmpObject_GoodsPropertyValueGroup AS (SELECT tmpObject_GoodsPropertyValue.GoodsId
                                                  , tmpObject_GoodsPropertyValue.Name
                                                  , tmpObject_GoodsPropertyValue.Article
                                                  , tmpObject_GoodsPropertyValue.Quality
                                                  , tmpObject_GoodsPropertyValue.Quality2
                                                  , tmpObject_GoodsPropertyValue.Quality10
                                             FROM (SELECT MAX (tmpObject_GoodsPropertyValue.ObjectId) AS ObjectId, GoodsId FROM tmpObject_GoodsPropertyValue WHERE Name <> '' GROUP BY GoodsId
                                                  ) AS tmpGoodsProperty_find
                                                  LEFT JOIN tmpObject_GoodsPropertyValue ON tmpObject_GoodsPropertyValue.ObjectId =  tmpGoodsProperty_find.ObjectId
                                            )

     , tmpMovement_Params AS (SELECT Movement.Id
                                   , Movement.InvNumber
                                   , Movement.OperDate
                                   , COALESCE (MovementString_InvNumberPartner.ValueData, Movement.InvNumber) AS InvNumberPartner
                                   , COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate)     AS OperDatePartner
                                   , OH_JuridicalDetails_From.FullName                                        AS JuridicalName_From
                                   , OH_JuridicalDetails_From.JuridicalAddress                                AS JuridicalAddress_From
                                   , OH_JuridicalDetails_From.Phone                                           AS Phone_From
                                   , OH_JuridicalDetails_To.OKPO                                              AS OKPO_To
                                   , View_Contract.InvNumber        		                              AS ContractName
                                   , Object_To.ValueData                                                      AS PartnerName
                                   , MovementString_InvNumberOrder.ValueData                                  AS InvNumber_Order
                              FROM tmpMovement
                                   INNER JOIN Movement ON Movement.Id = tmpMovement.Id
                                   LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                                ON MovementLinkObject_From.MovementId = Movement.Id
                                                               AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                   LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                                ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                               AND MovementLinkObject_Contract.DescId IN (zc_MovementLinkObject_Contract(), zc_MovementLinkObject_ContractTo())
                                   LEFT JOIN Object_Contract_View AS View_Contract ON View_Contract.ContractId = MovementLinkObject_Contract.ObjectId

                                   LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                                                ON MovementLinkObject_Partner.MovementId = Movement.Id
                                                               AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
                                   LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                                ON MovementLinkObject_To.MovementId = Movement.Id
                                                               AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                   LEFT JOIN Object AS Object_To ON Object_To.Id = COALESCE (MovementLinkObject_Partner.ObjectId, MovementLinkObject_To.ObjectId)

                                   LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                                          ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                                         AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                                   LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                                            ON MovementString_InvNumberPartner.MovementId = Movement.Id
                                                           AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

                                   LEFT JOIN MovementString AS MovementString_InvNumberOrder
                                                            ON MovementString_InvNumberOrder.MovementId = Movement.Id
                                                           AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()

                                   LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                                        ON ObjectLink_Unit_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                                                       AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                                   LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_From
                                                                                       ON OH_JuridicalDetails_From.JuridicalId = COALESCE (View_Contract.JuridicalBasisId, COALESCE (ObjectLink_Unit_Juridical.ChildObjectId, zc_Juridical_Basis()))
                                                                                      AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) >= OH_JuridicalDetails_From.StartDate
                                                                                      AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) <  OH_JuridicalDetails_From.EndDate
                                   LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_To
                                                                                       ON OH_JuridicalDetails_To.JuridicalId = View_Contract.JuridicalId
                                                                                      AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) >= OH_JuridicalDetails_To.StartDate
                                                                                      AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) <  OH_JuridicalDetails_To.EndDate
                              )

           , tmpNewQuality AS (SELECT DISTINCT ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId AS GoodsId
                               FROM ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                                    JOIN ObjectBoolean AS ObjectBoolean_NewQuality
                                                       ON ObjectBoolean_NewQuality.ObjectId  = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                      AND ObjectBoolean_NewQuality.DescId    = zc_ObjectBoolean_GoodsByGoodsKind_NewQuality()
                                                      AND ObjectBoolean_NewQuality.ValueData = TRUE
                               WHERE ObjectLink_GoodsByGoodsKind_Goods.DescId = zc_ObjectLink_GoodsByGoodsKind_Goods()
                              )
      -- Результат
      SELECT Movement.Id				                              AS MovementId
           , Movement.InvNumber				                              AS InvNumber
           , Movement.OperDate				                              AS OperDate
           , Movement.InvNumberPartner
           , Movement.OperDatePartner

           , Movement.JuridicalName_From
           , Movement.JuridicalAddress_From
           , Movement.Phone_From
           , Movement.ContractName
           , Movement.PartnerName

           , Object_GoodsGroup.ValueData                                              AS GoodsGroupName
           , Object_Measure.ValueData                                                 AS MeasureName
           , Object_Goods.ObjectCode                                                  AS GoodsCode

           , CASE -- на дату у товара
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
              END                 :: TVarChar AS CodeUKTZED

           , COALESCE (tmpObject_GoodsPropertyValueGroup.Article,   COALESCE (tmpObject_GoodsPropertyValue.Article, ''))      AS Article_Juridical
         --, COALESCE (tmpObject_GoodsPropertyValueGroup.Quality,   tmpObject_GoodsPropertyValue.Quality, tmpGoodsQuality.Value17) AS Quality_Juridical

             -- Строк придатності (КУ) - подставляется для вида товара - срок годности в днях
           , CASE WHEN tmpMIGoodsByGoodsKind.NormInDays_gk > 0 THEN zfConvert_FloatToString (tmpMIGoodsByGoodsKind.NormInDays_gk) || ' діб'
                  ELSE COALESCE (tmpObject_GoodsPropertyValueGroup.Quality2,  COALESCE (tmpObject_GoodsPropertyValue.Quality2, ''))
             END AS Quality2_Juridical
             -- Умови зберігання (КУ)
           , tmpGoodsQuality.Value10 AS Quality10_Juridical
         --, COALESCE (tmpObject_GoodsPropertyValueGroup.Quality10, COALESCE (tmpObject_GoodsPropertyValue.Quality10, '')) AS Quality10_Juridical

           , (CASE WHEN COALESCE (tmpObject_GoodsPropertyValueGroup.Name, tmpObject_GoodsPropertyValue.Name) <> '' THEN COALESCE (tmpObject_GoodsPropertyValueGroup.Name, tmpObject_GoodsPropertyValue.Name) ELSE Object_Goods.ValueData END
           || CASE WHEN COALESCE (Object_GoodsKind.Id, zc_Enum_GoodsKind_Main()) = zc_Enum_GoodsKind_Main() THEN '' ELSE ' ' || Object_GoodsKind.ValueData END
             ) :: TVarChar AS GoodsName
           , (CASE WHEN COALESCE (Object_GoodsKind.Id, zc_Enum_GoodsKind_Main()) = zc_Enum_GoodsKind_Main() THEN '' ELSE Object_GoodsKind.ValueData END) :: TVarChar AS GoodsKindName

           , tmpMI.AmountPartner                                                                                AS AmountPartner
           , CAST (CASE WHEN Object_Measure.Id = zc_Measure_Kg() THEN tmpMI.AmountPartner:: TVarChar ELSE CAST (tmpMI.AmountPartner AS NUMERIC (16,0) ) ||' шт' END AS TVarChar) AS AmountPartner_str
           , CAST (CASE WHEN Object_Measure.Id = zc_Measure_Kg() THEN tmpMI.AmountPartner ELSE 0 END AS TFloat) AS Amount5
           , 0                                                                                                  AS Amount9
           , CAST (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpMI.AmountPartner ELSE 0 END AS TFloat) AS Amount13

           , tmpMovement_QualityParams.OperDateIn
             -- Уменьшение на N дней от даты покупателя в качественном
           , (tmpMovement_QualityParams.OperDateIn + (CASE WHEN tmpMIGoodsByGoodsKind.DaysQ_gk <> 0 THEN (tmpMIGoodsByGoodsKind.DaysQ_gk) :: TVarChar ELSE '0' END || ' DAY') :: INTERVAl) :: TDateTime AS OperDateIn_str4
             --
           , tmpMovement_QualityParams.OperDateOut

             -- + для вида товара ПЛЮС срок годности в днях
           , (tmpMovement_QualityParams.OperDateIn + (CASE WHEN tmpMIGoodsByGoodsKind.NormInDays_gk > 0 THEN (tmpMIGoodsByGoodsKind.NormInDays_gk) :: TVarChar ELSE '0' END || ' DAY') :: INTERVAl) :: TDateTime AS OperDate_end

             -- 2393 - КОВБАСКИ БАВАРСЬКІ С/К в/г ПРЕМІЯ 120 гр/шт + 2222 + 2369
           , CASE WHEN tmpNewQuality.GoodsId > 0
                       THEN tmpMovement_QualityParams.OperDateIn + (CASE WHEN tmpMIGoodsByGoodsKind.NormInDays_gk > 0 THEN (tmpMIGoodsByGoodsKind.NormInDays_gk) :: TVarChar ELSE '0' END || ' DAY') :: INTERVAl
                  ELSE tmpMovement_QualityParams.OperDateIn
             END :: TDateTime AS OperDate_part

             -- для вида товара - срок годности в днях
           , (zfConvert_FloatToString (tmpMIGoodsByGoodsKind.NormInDays_gk) || ' діб') :: TVarChar AS NormInDays_gk_str

           , (COALESCE (Object_CarModel.ValueData,'') || COALESCE (' ' || Object_CarType.ValueData, '') ) ::TVarChar AS CarModelName
           , Object_Car.ValueData             AS CarName
           , TRUE                 :: Boolean  AS isJuridicalBasis

             -- МЕТРО Кеш енд Кері Україна ТОВ
           , CASE WHEN Movement.OKPO_To = '32049199' THEN 'ДЕКЛАРАЦІЯ ПОСТАЧАЛЬНИКА' ELSE 'Декларація виробника' END :: TVarChar AS Main_str

           , tmpGoodsQuality.QualityCode

           , tmpGoodsQuality.QualityName
           , tmpGoodsQuality.QualityComment
             -- Значение ГОСТ, ДСТУ,ТУ (КУ)
           , COALESCE (tmpGoodsQuality.Value17, tmpObject_GoodsPropertyValueGroup.Quality, tmpObject_GoodsPropertyValue.Quality, tmpGoodsQuality.Value17)  :: TVarChar AS Value17   --, tmpGoodsQuality.Value17
             -- для вида товара - Вид оболонки, №4
           , CASE WHEN tmpMIGoodsByGoodsKind.Value1_gk <> '' THEN tmpMIGoodsByGoodsKind.Value1_gk ELSE tmpGoodsQuality.Value1 END :: TVarChar AS Value1
             --
           , tmpGoodsQuality.Value2
           , tmpGoodsQuality.Value3
           , tmpGoodsQuality.Value4
           , tmpGoodsQuality.Value5
           , tmpGoodsQuality.Value6
           , tmpGoodsQuality.Value7
           , tmpGoodsQuality.Value8
           , tmpGoodsQuality.Value9
           , tmpGoodsQuality.Value10
             -- для вида товара - Вид пакування/стан продукції
           , tmpMIGoodsByGoodsKind.Value11_gk

           , tmpMovement_QualityParams.InvNumber            AS InvNumber_Quality
           , tmpMovement_QualityParams.OperDate             AS OperDate_Quality
           , tmpMovement_QualityParams.OperDateCertificate
           , tmpMovement_QualityParams.CertificateNumber
           , tmpMovement_QualityParams.CertificateSeries
           , tmpMovement_QualityParams.CertificateSeriesNumber
           , tmpMovement_QualityParams.ExpertPrior
           , tmpMovement_QualityParams.ExpertLast
           , tmpMovement_QualityParams.QualityNumber
           , tmpMovement_QualityParams.Comment              AS QualityComment_Movement
           , tmpMovement_QualityParams.ReportType

           , Movement.InvNumber_Order

       FROM tmpMI
            INNER JOIN tmpMovement_Params AS Movement ON Movement.Id =  tmpMI.MovementId

            LEFT JOIN tmpNewQuality ON tmpNewQuality.GoodsId = tmpMI.ObjectId

            LEFT JOIN tmpMIGoodsByGoodsKind ON tmpMIGoodsByGoodsKind.ObjectId    = tmpMI.ObjectId
                                           AND tmpMIGoodsByGoodsKind.GoodsKindId = tmpMI.GoodsKindId

            LEFT JOIN Object AS Object_Goods     ON Object_Goods.Id     = tmpMI.ObjectId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMI.GoodsKindId

            INNER JOIN tmpGoodsQuality ON tmpGoodsQuality.GoodsId = tmpMI.ObjectId
            LEFT JOIN tmpMovement_QualityParams ON tmpMovement_QualityParams.QualityId = tmpGoodsQuality.QualityId

            LEFT JOIN tmpUKTZED ON tmpUKTZED.GoodsGroupId = tmpMI.GoodsGroupId
            LEFT JOIN ObjectString AS ObjectString_Goods_UKTZED
                                   ON ObjectString_Goods_UKTZED.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_UKTZED.DescId = zc_ObjectString_Goods_UKTZED()
            LEFT JOIN ObjectString AS ObjectString_Goods_UKTZED_new
                                   ON ObjectString_Goods_UKTZED_new.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_UKTZED_new.DescId = zc_ObjectString_Goods_UKTZED_new()
            LEFT JOIN ObjectDate AS ObjectDate_Goods_UKTZED_new
                                 ON ObjectDate_Goods_UKTZED_new.ObjectId = Object_Goods.Id
                                AND ObjectDate_Goods_UKTZED_new.DescId = zc_ObjectDate_Goods_UKTZED_new()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                 ON ObjectLink_Goods_InfoMoney.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                 ON ObjectLink_Goods_GoodsGroup.ObjectId = tmpMI.ObjectId
                                AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
            LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpMI.ObjectId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN tmpObject_GoodsPropertyValue ON tmpObject_GoodsPropertyValue.GoodsId     = Object_Goods.Id
                                                  AND tmpObject_GoodsPropertyValue.GoodsKindId = Object_GoodsKind.Id
                                                  AND tmpObject_GoodsPropertyValue.MovementId  = tmpMI.MovementId
            LEFT JOIN tmpObject_GoodsPropertyValueGroup ON tmpObject_GoodsPropertyValueGroup.GoodsId = Object_Goods.Id
                                                       AND tmpObject_GoodsPropertyValue.GoodsId      IS NULL

            LEFT JOIN Object AS Object_Car ON Object_Car.Id = tmpMovement_QualityParams.CarId
            LEFT JOIN ObjectLink AS ObjectLink_Car_CarModel ON ObjectLink_Car_CarModel.ObjectId = Object_Car.Id
                                                           AND ObjectLink_Car_CarModel.DescId = zc_ObjectLink_Car_CarModel()
            LEFT JOIN Object AS Object_CarModel ON Object_CarModel.Id = ObjectLink_Car_CarModel.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Car_CarType
                                 ON ObjectLink_Car_CarType.ObjectId = Object_Car.Id
                                AND ObjectLink_Car_CarType.DescId = zc_ObjectLink_Car_CarType()
            LEFT JOIN Object AS Object_CarType ON Object_CarType.Id = ObjectLink_Car_CarType.ChildObjectId

      ORDER BY Movement.Id
             , tmpGoodsQuality.QualityCode
             , Object_GoodsGroup.ValueData
             , Object_Goods.ValueData
             , Object_GoodsKind.ValueData
      ;


----Cursor 2
     CREATE TEMP TABLE tmpCursor2 (MovementId Integer
                              , InvNumber  TVarChar
                              , OperDate TDateTime
                              , InvNumberPartner TVarChar
                              , OperDatePartner TDateTime
                              , JuridicalName_From  TVarChar
                              , JuridicalAddress_From  TVarChar
                              , PartnerName  TVarChar
                              , GoodsGroupName  TVarChar
                              , MeasureName  TVarChar
                              , GoodsCode  TVarChar
                              , CodeUKTZED TVarChar
                              , Article_Juridical  TVarChar
                              , Quality2_Juridical  TVarChar
                              , Quality10_Juridical  TVarChar
                              , GoodsName TVarChar
                              , GoodsKindName TVarChar
                              , AmountPartner  TFloat
                              , Amount5 TFloat
                              , Amount9  TFloat
                              , Amount13 TFloat
                              , OperDateIn TDateTime
                              , OperDateIn_str4 TVarChar
                              , OperDateOut TDateTime
                              , OperDate_end TDateTime
                              , NormInDays_gk_str TVarChar

                              , CarModelName TVarChar
                              , CarName TVarChar
                              , isJuridicalBasis Boolean
                              , Main_str TVarChar

                              , NumberPrint TFloat
                              , QualityCode TVarChar
                              , QualityName TVarChar
                              , QualityComment Text
                              , Value17  Text
                              , Value1 TVarChar
                              , Value2 TVarChar
                              , Value3 TVarChar
                              , Value4 TVarChar
                              , Value5 TVarChar
                              , Value6 TVarChar
                              , Value7 TVarChar
                              , Value8 TVarChar
                              , Value9 TVarChar
                              , Value10 TVarChar
                              , Value11_gk TVarChar
                              , InvNumber_Quality TVarChar
                              , OperDate_Quality TDateTime
                              , OperDateCertificate TVarChar
                              , CertificateNumber TVarChar
                              , CertificateSeries TVarChar
                              , CertificateSeriesNumber TVarChar
                              , ExpertPrior Text
                              , ExpertLast Text
                              , QualityNumber TVarChar
                              , QualityComment_Movement Text
                              , ReportType TVarChar
                              , MovementId_find Integer) ON COMMIT DROP;

     INSERT INTO tmpCursor2 (MovementId, InvNumber, OperDate, InvNumberPartner, OperDatePartner
                        , JuridicalName_From, JuridicalAddress_From, PartnerName
                        , GoodsGroupName, MeasureName, GoodsCode, CodeUKTZED, Article_Juridical
                        , Quality2_Juridical, Quality10_Juridical
                        , GoodsName , GoodsKindName , AmountPartner
                        , Amount5 , Amount9, Amount13
                        , OperDateIn, OperDateIn_str4 , OperDateOut , OperDate_end
                        , NormInDays_gk_str , CarModelName, CarName
                        , isJuridicalBasis, Main_str , NumberPrint
                        , QualityCode, QualityName, QualityComment
                        , Value17  , Value1 , Value2, Value3, Value4, Value5, Value6, Value7, Value8, Value9, Value10, Value11_gk
                        , InvNumber_Quality, OperDate_Quality, OperDateCertificate, CertificateNumber, CertificateSeries, CertificateSeriesNumber
                        , ExpertPrior, ExpertLast
                        , QualityNumber, QualityComment_Movement
                        , ReportType, MovementId_find)

       WITH
       tmpMovement AS (
          SELECT DISTINCT Movement_Sale.Id AS Id
          FROM Movement
              LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Child
                                             ON MovementLinkMovement_Child.MovementId = Movement.Id
                                            AND MovementLinkMovement_Child.DescId = zc_MovementLinkMovement_Child()
              INNER JOIN Movement AS Movement_Sale ON Movement_Sale.Id = MovementLinkMovement_Child.MovementChildId
                                                  AND Movement_Sale.StatusId = zc_Enum_Status_Complete()
              INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                            ON MovementLinkObject_To.MovementId = Movement_Sale.Id
                                           AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                           AND MovementLinkObject_To.ObjectId = vbToId
          WHERE Movement.DescId = zc_Movement_QualityDoc()
            AND Movement.OperDate = vbOperDate
            AND Movement.StatusId = zc_Enum_Status_Complete()
            AND inisAll = TRUE
         UNION ALL
          SELECT inMovementId AS Id
          WHERE inisAll = FALSE
         )

   , tmpGoodsProperty AS(
       SELECT DISTINCT Movement.Id AS MovementId
            , zfCalc_GoodsPropertyId (MovementLinkObject_Contract.ObjectId
                                    , COALESCE (ObjectLink_Partner_Juridical.ChildObjectId
                                    , MovementLinkObject_To.ObjectId)
                                    , MovementLinkObject_To.ObjectId
                                     ) AS GoodsPropertyId
       FROM tmpMovement AS Movement
            LEFT JOIN MovementLinkMovement AS MLM_Child
                                           ON MLM_Child.MovementChildId = Movement.Id
                                          AND MLM_Child.DescId          = zc_MovementLinkMovement_Child()
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = MLM_Child.MovementId
                                        AND MovementLinkObject_Contract.DescId     = zc_MovementLinkObject_Contract()
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = MLM_Child.MovementChildId
                                        AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                 ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                                AND ObjectLink_Partner_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()
      )

     , tmpMI AS
                    (SELECT MovementItem.MovementId
                          , MovementItem.ObjectId
                          , SUM (MovementItem.Amount) :: TFloat AS Amount
                          , SUM (CASE WHEN Movement.DescId = zc_Movement_SendOnPrice() THEN MovementItem.Amount ELSE MIFloat_AmountPartner.ValueData END) :: TFloat AS AmountPartner
                          , MILO_GoodsKind.ObjectId             AS GoodsKindId
                          , ObjectLink_GoodsGroup.ChildObjectId AS GoodsGroupId
                     FROM tmpMovement
                          INNER JOIN Movement ON Movement.Id = tmpMovement.Id
                          INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                 AND MovementItem.DescId     = zc_MI_Master()
                                                 AND MovementItem.isErased   = FALSE
                          INNER JOIN MovementItemFloat AS MIFloat_Price
                                                       ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                      AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                                      AND MIFloat_Price.ValueData <> 0
                          LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                      ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                     AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                          LEFT JOIN MovementItemLinkObject AS MILO_GoodsKind
                                                           ON MILO_GoodsKind.MovementItemId = MovementItem.Id
                                                          AND MILO_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                          LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup
                                               ON ObjectLink_GoodsGroup.ObjectId = MovementItem.ObjectId
                                              AND ObjectLink_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
                     WHERE ((MIFloat_AmountPartner.ValueData <> 0 AND Movement.DescId <> zc_Movement_SendOnPrice())
                         OR (MovementItem.Amount <> 0 AND Movement.DescId = zc_Movement_SendOnPrice())
                           )
                     GROUP BY MovementItem.MovementId
                            , MovementItem.ObjectId
                            , MILO_GoodsKind.ObjectId
                            , ObjectLink_GoodsGroup.ChildObjectId
                    )
          , tmpMIGoodsByGoodsKind AS
                            (SELECT tmpMI.*
                                  , ObjectString_GK_Value1.ValueData     AS Value1_gk
                                  , ObjectString_GK_Value11.ValueData    AS Value11_gk
                                  , ObjectFloat_GK_NormInDays.ValueData  AS NormInDays_gk
                                  , ObjectFloat_GK_DaysQ.ValueData       AS DaysQ_gk
                             FROM tmpMI
                                  JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                                                  ON ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId = tmpMI.ObjectId
                                                 AND ObjectLink_GoodsByGoodsKind_Goods.DescId        = zc_ObjectLink_GoodsByGoodsKind_Goods()
                                  JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                                  ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId      = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                 AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId        = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
                                                 AND ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId = tmpMI.GoodsKindId
                                  LEFT JOIN ObjectString AS ObjectString_GK_Value1
                                                         ON ObjectString_GK_Value1.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                        AND ObjectString_GK_Value1.DescId   = zc_ObjectString_GoodsByGoodsKind_Quality1()
                                  LEFT JOIN ObjectString AS ObjectString_GK_Value11
                                                         ON ObjectString_GK_Value11.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                        AND ObjectString_GK_Value11.DescId   = zc_ObjectString_GoodsByGoodsKind_Quality11()
                                  LEFT JOIN ObjectFloat AS ObjectFloat_GK_NormInDays
                                                        ON ObjectFloat_GK_NormInDays.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                       AND ObjectFloat_GK_NormInDays.DescId   = zc_ObjectFloat_GoodsByGoodsKind_NormInDays()
                                  LEFT JOIN ObjectFloat AS ObjectFloat_GK_DaysQ
                                                        ON ObjectFloat_GK_DaysQ.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                       AND ObjectFloat_GK_DaysQ.DescId   = zc_ObjectFloat_GoodsByGoodsKind_DaysQ()
                            )
          , tmpMIGoods AS (SELECT DISTINCT tmpMI.ObjectId AS GoodsId FROM tmpMI)
          , tmpUKTZED AS (SELECT tmp.GoodsGroupId, lfGet_Object_GoodsGroup_CodeUKTZED (tmp.GoodsGroupId) AS CodeUKTZED FROM (SELECT DISTINCT tmpMI.GoodsGroupId FROM tmpMI) AS tmp)
          , tmpGoodsQuality AS
                              (SELECT tmpMIGoods.GoodsId          AS GoodsId
                                    , Object_Quality.Id           AS QualityId
                                    , Object_Quality.ObjectCode   AS QualityCode
                                    , Object_Quality.ValueData    AS QualityName
                                    , OS_QualityComment.ValueData AS QualityComment
                                    , ObjectFloat_Quality_NumberPrint.ValueData AS NumberPrint

                                    , Object_GoodsQuality.ValueData AS Value17
                                    , ObjectString_Value1.ValueData AS Value1
                                    , ObjectString_Value2.ValueData AS Value2
                                    , ObjectString_Value3.ValueData AS Value3
                                    , ObjectString_Value4.ValueData AS Value4
                                    , ObjectString_Value5.ValueData AS Value5
                                    , ObjectString_Value6.ValueData AS Value6
                                    , ObjectString_Value7.ValueData AS Value7
                                    , ObjectString_Value8.ValueData AS Value8
                                    , ObjectString_Value9.ValueData AS Value9
                                    , ObjectString_Value10.ValueData AS Value10
                                FROM tmpMIGoods
                                     INNER JOIN ObjectLink AS ObjectLink_GoodsQuality_Goods
                                                           ON ObjectLink_GoodsQuality_Goods.ChildObjectId = tmpMIGoods.GoodsId
                                                          AND ObjectLink_GoodsQuality_Goods.DescId = zc_ObjectLink_GoodsQuality_Goods()

                                     INNER JOIN Object AS Object_GoodsQuality ON Object_GoodsQuality.Id        = ObjectLink_GoodsQuality_Goods.ObjectId
                                                                             AND (Object_GoodsQuality.isErased = FALSE
                                                                             --OR vbUserId = 5
                                                                                 )

                                     LEFT JOIN ObjectLink AS ObjectLink_GoodsQuality_Quality
                                                          ON ObjectLink_GoodsQuality_Quality.ObjectId = ObjectLink_GoodsQuality_Goods.ObjectId
                                                         AND ObjectLink_GoodsQuality_Quality.DescId = zc_ObjectLink_GoodsQuality_Quality()

                                     LEFT JOIN Object AS Object_Quality ON Object_Quality.Id = ObjectLink_GoodsQuality_Quality.ChildObjectId
                                     LEFT JOIN ObjectString AS OS_QualityComment
                                                            ON OS_QualityComment.ObjectId = ObjectLink_GoodsQuality_Quality.ChildObjectId
                                                           AND OS_QualityComment.DescId = zc_ObjectString_Quality_Comment()
                                     INNER JOIN ObjectFloat AS ObjectFloat_Quality_NumberPrint
                                                            ON ObjectFloat_Quality_NumberPrint.ObjectId = ObjectLink_GoodsQuality_Quality.ChildObjectId
                                                           AND ObjectFloat_Quality_NumberPrint.DescId = zc_ObjectFloat_Quality_NumberPrint()
                                                           AND ObjectFloat_Quality_NumberPrint.ValueData >= 2 -- !!!так захардкодил!!!

                                     LEFT JOIN ObjectString AS ObjectString_Value1
                                                            ON ObjectString_Value1.ObjectId = ObjectLink_GoodsQuality_Goods.ObjectId
                                                           AND ObjectString_Value1.DescId = zc_ObjectString_GoodsQuality_Value1()
                                     LEFT JOIN ObjectString AS ObjectString_Value2
                                                            ON ObjectString_Value2.ObjectId = ObjectLink_GoodsQuality_Goods.ObjectId
                                                           AND ObjectString_Value2.DescId = zc_ObjectString_GoodsQuality_Value2()
                                     LEFT JOIN ObjectString AS ObjectString_Value3
                                                            ON ObjectString_Value3.ObjectId = ObjectLink_GoodsQuality_Goods.ObjectId
                                                           AND ObjectString_Value3.DescId = zc_ObjectString_GoodsQuality_Value3()
                                     LEFT JOIN ObjectString AS ObjectString_Value4
                                                            ON ObjectString_Value4.ObjectId = ObjectLink_GoodsQuality_Goods.ObjectId
                                                           AND ObjectString_Value4.DescId = zc_ObjectString_GoodsQuality_Value4()
                                     LEFT JOIN ObjectString AS ObjectString_Value5
                                                            ON ObjectString_Value5.ObjectId = ObjectLink_GoodsQuality_Goods.ObjectId
                                                           AND ObjectString_Value5.DescId = zc_ObjectString_GoodsQuality_Value5()
                                     LEFT JOIN ObjectString AS ObjectString_Value6
                                                            ON ObjectString_Value6.ObjectId = ObjectLink_GoodsQuality_Goods.ObjectId
                                                           AND ObjectString_Value6.DescId = zc_ObjectString_GoodsQuality_Value6()
                                     LEFT JOIN ObjectString AS ObjectString_Value7
                                                            ON ObjectString_Value7.ObjectId = ObjectLink_GoodsQuality_Goods.ObjectId
                                                           AND ObjectString_Value7.DescId = zc_ObjectString_GoodsQuality_Value7()
                                     LEFT JOIN ObjectString AS ObjectString_Value8
                                                            ON ObjectString_Value8.ObjectId = ObjectLink_GoodsQuality_Goods.ObjectId
                                                           AND ObjectString_Value8.DescId = zc_ObjectString_GoodsQuality_Value8()
                                     LEFT JOIN ObjectString AS ObjectString_Value9
                                                            ON ObjectString_Value9.ObjectId = ObjectLink_GoodsQuality_Goods.ObjectId
                                                           AND ObjectString_Value9.DescId = zc_ObjectString_GoodsQuality_Value9()
                                     LEFT JOIN ObjectString AS ObjectString_Value10
                                                            ON ObjectString_Value10.ObjectId = ObjectLink_GoodsQuality_Goods.ObjectId
                                                           AND ObjectString_Value10.DescId = zc_ObjectString_GoodsQuality_Value10()
                              )

          , tmpMovement_find AS
                               (SELECT MovementLinkObject_Quality.ObjectId         AS QualityId
                                     , MovementLinkMovement_Master.MovementChildId AS MovementId
                                     , MovementDate_OperDateIn.ValueData           AS OperDateIn
                                     , MovementDate_OperDateOut.ValueData          AS OperDateOut
                                     , MovementLinkObject_Car.ObjectId             AS CarId
                                     , MS_QualityNumber.ValueData                         AS QualityNumber
                                     , MD_OperDateCertificate.ValueData                   AS OperDateCertificate
                                     , MS_CertificateNumber.ValueData                     AS CertificateNumber
                                     , MS_CertificateSeries.ValueData                     AS CertificateSeries
                                     , MS_CertificateSeriesNumber.ValueData               AS CertificateSeriesNumber
                                FROM tmpMovement
                                     INNER JOIN Movement ON Movement.Id = tmpMovement.Id
                                                        AND Movement.StatusId = zc_Enum_Status_Complete()
                                     INNER JOIN MovementLinkMovement AS MovementLinkMovement_Child
                                                                     ON MovementLinkMovement_Child.MovementChildId = Movement.Id
                                                                    AND MovementLinkMovement_Child.DescId = zc_MovementLinkMovement_Child()

                                     LEFT JOIN MovementDate AS MovementDate_OperDateIn
                                                            ON MovementDate_OperDateIn.MovementId =  MovementLinkMovement_Child.MovementId
                                                           AND MovementDate_OperDateIn.DescId = zc_MovementDate_OperDateIn()
                                     LEFT JOIN MovementDate AS MovementDate_OperDateOut
                                                            ON MovementDate_OperDateOut.MovementId =  MovementLinkMovement_Child.MovementId
                                                           AND MovementDate_OperDateOut.DescId = zc_MovementDate_OperDateOut()
                                     LEFT JOIN MovementLinkObject AS MovementLinkObject_Car
                                                                  ON MovementLinkObject_Car.MovementId = MovementLinkMovement_Child.MovementId
                                                                 AND MovementLinkObject_Car.DescId = zc_MovementLinkObject_Car()

                                     LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Master
                                                                    ON MovementLinkMovement_Master.MovementId = MovementLinkMovement_Child.MovementId
                                                                   AND MovementLinkMovement_Master.DescId = zc_MovementLinkMovement_Master()
                                     LEFT JOIN MovementLinkObject AS MovementLinkObject_Quality
                                                                  ON MovementLinkObject_Quality.MovementId = MovementLinkMovement_Master.MovementChildId
                                                                 AND MovementLinkObject_Quality.DescId = zc_MovementLinkObject_Quality()

                                     LEFT JOIN Movement AS Movement_QualityNumber
                                                        ON Movement_QualityNumber.OperDate = DATE_TRUNC ('DAY', MovementDate_OperDateIn.ValueData)
                                                       AND Movement_QualityNumber.DescId = zc_Movement_QualityNumber()
                                                       AND Movement_QualityNumber.StatusId = zc_Enum_Status_Complete()

                                     LEFT JOIN MovementString AS MS_QualityNumber
                                                              ON MS_QualityNumber.MovementId = COALESCE (Movement_QualityNumber.Id, MovementLinkMovement_Child.MovementId) -- tmpMovement_find.MovementId
                                                             AND MS_QualityNumber.DescId = zc_MovementString_QualityNumber()
                                     LEFT JOIN MovementDate AS MD_OperDateCertificate
                                                            ON MD_OperDateCertificate.MovementId = COALESCE (Movement_QualityNumber.Id, MovementLinkMovement_Child.MovementId) -- tmpMovement_find.MovementId
                                                           AND MD_OperDateCertificate.DescId = zc_MovementDate_OperDateCertificate()
                                     LEFT JOIN MovementString AS MS_CertificateNumber
                                                              ON MS_CertificateNumber.MovementId = COALESCE (Movement_QualityNumber.Id, MovementLinkMovement_Child.MovementId) -- tmpMovement_find.MovementId
                                                             AND MS_CertificateNumber.DescId = zc_MovementString_CertificateNumber()
                                     LEFT JOIN MovementString AS MS_CertificateSeries
                                                              ON MS_CertificateSeries.MovementId = COALESCE (Movement_QualityNumber.Id, MovementLinkMovement_Child.MovementId) -- tmpMovement_find.MovementId
                                                             AND MS_CertificateSeries.DescId = zc_MovementString_CertificateSeries()
                                     LEFT JOIN MovementString AS MS_CertificateSeriesNumber
                                                              ON MS_CertificateSeriesNumber.MovementId = COALESCE (Movement_QualityNumber.Id, MovementLinkMovement_Child.MovementId) -- tmpMovement_find.MovementId
                                                             AND MS_CertificateSeriesNumber.DescId = zc_MovementString_CertificateSeriesNumber()
                               )

          , tmpMovement_QualityParams AS
                                        (SELECT DISTINCT
                                                tmpMovement_find.QualityId
                                              , Movement.Id                                        AS Id
                                              , Movement.InvNumber                                 AS InvNumber
                                              , Movement.OperDate                                  AS OperDate
                                              , MS_ExpertPrior.ValueData                           AS ExpertPrior
                                              , MS_ExpertLast.ValueData                            AS ExpertLast
                                              , MB_Comment.ValueData                               AS Comment
                                              , tmpMovement_find.MovementId                        AS MovementId_find
                                              , 0                                                  AS ReportType
                                              , tmpMovement_find.OperDateIn                        AS OperDateIn
                                              , tmpMovement_find.OperDateOut                       AS OperDateOut
                                              , tmpMovement_find.CarId                             AS CarId
                                              , tmpMovement_find.QualityNumber
                                              , tmpMovement_find.OperDateCertificate
                                              , tmpMovement_find.CertificateNumber
                                              , tmpMovement_find.CertificateSeries
                                              , tmpMovement_find.CertificateSeriesNumber
                                         FROM tmpMovement_find
                                              LEFT JOIN Movement ON Movement.Id = tmpMovement_find.MovementId
                                              LEFT JOIN MovementString AS MS_ExpertPrior
                                                                       ON MS_ExpertPrior.MovementId =  tmpMovement_find.MovementId
                                                                      AND MS_ExpertPrior.DescId = zc_MovementString_ExpertPrior()
                                              LEFT JOIN MovementString AS MS_ExpertLast
                                                                       ON MS_ExpertLast.MovementId =  tmpMovement_find.MovementId
                                                                      AND MS_ExpertLast.DescId = zc_MovementString_ExpertLast()
                                              LEFT JOIN MovementBlob AS MB_Comment
                                                                     ON MB_Comment.MovementId =  tmpMovement_find.MovementId
                                                                    AND MB_Comment.DescId = zc_MovementBlob_Comment()
                                        )
       -- список Названия покупателя для товаров + GoodsKindId
     , tmpObject_GoodsPropertyValue AS (SELECT ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                             , ObjectLink_GoodsPropertyValue_Goods.ChildObjectId                   AS GoodsId
                                             , COALESCE (ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId, 0) AS GoodsKindId
                                             , Object_GoodsPropertyValue.ValueData  AS Name
                                             , ObjectString_Article.ValueData       AS Article
                                               -- Значение ГОСТ, ДСТУ,ТУ (КУ)
                                             , ObjectString_Quality.ValueData       AS Quality
                                               -- Строк придатності (КУ)
                                             , ObjectString_Quality2.ValueData      AS Quality2
                                               -- Умови зберігання (КУ)
                                             , ObjectString_Quality10.ValueData     AS Quality10
                                               --
                                             , tmpGoodsProperty.MovementId
                                        FROM (SELECT tmpGoodsProperty.GoodsPropertyId, tmpGoodsProperty.MovementId
                                              FROM tmpGoodsProperty
                                              WHERE tmpGoodsProperty.GoodsPropertyId <> 0
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
                                             LEFT JOIN ObjectString AS ObjectString_Article
                                                                    ON ObjectString_Article.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                                   AND ObjectString_Article.DescId = zc_ObjectString_GoodsPropertyValue_Article()
                                             LEFT JOIN ObjectString AS ObjectString_Quality
                                                                    ON ObjectString_Quality.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                                   AND ObjectString_Quality.DescId = zc_ObjectString_GoodsPropertyValue_Quality()
                                                                   AND ObjectString_Quality.ValueData <> ''
                                             LEFT JOIN ObjectString AS ObjectString_Quality2
                                                                    ON ObjectString_Quality2.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                                   AND ObjectString_Quality2.DescId = zc_ObjectString_GoodsPropertyValue_Quality2()
                                             LEFT JOIN ObjectString AS ObjectString_Quality10
                                                                    ON ObjectString_Quality10.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                                   AND ObjectString_Quality10.DescId = zc_ObjectString_GoodsPropertyValue_Quality10()
                                       )
       -- список Названия для товаров (нужны если не найдем по GoodsKindId)
     , tmpObject_GoodsPropertyValueGroup AS (SELECT tmpObject_GoodsPropertyValue.GoodsId
                                                  , tmpObject_GoodsPropertyValue.Name
                                                  , tmpObject_GoodsPropertyValue.Article
                                                  , tmpObject_GoodsPropertyValue.Quality
                                                  , tmpObject_GoodsPropertyValue.Quality2
                                                  , tmpObject_GoodsPropertyValue.Quality10
                                             FROM (SELECT MAX (tmpObject_GoodsPropertyValue.ObjectId) AS ObjectId, GoodsId FROM tmpObject_GoodsPropertyValue WHERE Name <> '' GROUP BY GoodsId
                                                  ) AS tmpGoodsProperty_find
                                                  LEFT JOIN tmpObject_GoodsPropertyValue ON tmpObject_GoodsPropertyValue.ObjectId =  tmpGoodsProperty_find.ObjectId
                                            )
     , tmpMovement_Params AS (SELECT Movement.Id
                                   , Movement.InvNumber
                                   , Movement.OperDate
                                   , Object_To.ValueData                                                      AS PartnerName
                                   , COALESCE (MovementString_InvNumberPartner.ValueData, Movement.InvNumber) AS InvNumberPartner
                                   , COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate)     AS OperDatePartner
                                   , OH_JuridicalDetails_From.FullName                                        AS JuridicalName_From
                                   , OH_JuridicalDetails_From.JuridicalAddress                                AS JuridicalAddress_From
                                   , OH_JuridicalDetails_To.OKPO                                              AS OKPO_To
                              FROM tmpMovement
                                   INNER JOIN Movement ON Movement.Id = tmpMovement.Id

                                   LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                                ON MovementLinkObject_From.MovementId = Movement.Id
                                                               AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                   LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                                ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                               AND MovementLinkObject_Contract.DescId IN (zc_MovementLinkObject_Contract(), zc_MovementLinkObject_ContractTo())
                                   LEFT JOIN Object_Contract_View AS View_Contract ON View_Contract.ContractId = MovementLinkObject_Contract.ObjectId

                                   LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                                                ON MovementLinkObject_Partner.MovementId = Movement.Id
                                                               AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
                                   LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                                ON MovementLinkObject_To.MovementId = Movement.Id
                                                               AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                   LEFT JOIN Object AS Object_To ON Object_To.Id = COALESCE (MovementLinkObject_Partner.ObjectId, MovementLinkObject_To.ObjectId)

                                   LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                                          ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                                         AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                                   LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                                            ON MovementString_InvNumberPartner.MovementId = Movement.Id
                                                           AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

                                   LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                                        ON ObjectLink_Unit_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                                                       AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                                   LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_From
                                                                                       ON OH_JuridicalDetails_From.JuridicalId = COALESCE (View_Contract.JuridicalBasisId, COALESCE (ObjectLink_Unit_Juridical.ChildObjectId, zc_Juridical_Basis()))
                                                                                      AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) >= OH_JuridicalDetails_From.StartDate
                                                                                      AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) <  OH_JuridicalDetails_From.EndDate
                                   LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_To
                                                                                       ON OH_JuridicalDetails_To.JuridicalId = View_Contract.JuridicalId
                                                                                      AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) >= OH_JuridicalDetails_To.StartDate
                                                                                      AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) <  OH_JuridicalDetails_To.EndDate
                              )

      -- Результат
      SELECT Movement.Id   AS MovementId
           , Movement.InvNumber
           , Movement.OperDate
           , Movement.InvNumberPartner
           , Movement.OperDatePartner
           , Movement.JuridicalName_From
           , Movement.JuridicalAddress_From
           , Movement.PartnerName

           , Object_GoodsGroup.ValueData AS GoodsGroupName
           , Object_Measure.ValueData    AS MeasureName
           , Object_Goods.ObjectCode     AS GoodsCode

           , CASE WHEN ObjectString_Goods_UKTZED.ValueData <> ''
                       THEN CASE WHEN vbIsLongUKTZED = TRUE THEN ObjectString_Goods_UKTZED.ValueData ELSE SUBSTRING (ObjectString_Goods_UKTZED.ValueData FROM 1 FOR 4) END

                  WHEN tmpUKTZED.CodeUKTZED <> ''
                       THEN CASE WHEN vbIsLongUKTZED = TRUE THEN tmpUKTZED.CodeUKTZED ELSE SUBSTRING (tmpUKTZED.CodeUKTZED FROM 1 FOR 4) END

                  WHEN ObjectLink_Goods_InfoMoney.ChildObjectId IN (zc_Enum_InfoMoney_20901(), zc_Enum_InfoMoney_30101())
                       THEN '1601'
                  WHEN ObjectLink_Goods_InfoMoney.ChildObjectId IN (zc_Enum_InfoMoney_21001(), zc_Enum_InfoMoney_30102())
                       THEN '1602'
                  WHEN ObjectLink_Goods_InfoMoney.ChildObjectId = zc_Enum_InfoMoney_30103()
                       THEN '1905'
                  ELSE '0'
              END :: TVarChar AS CodeUKTZED

           , COALESCE (tmpObject_GoodsPropertyValueGroup.Article,   COALESCE (tmpObject_GoodsPropertyValue.Article, ''))      AS Article_Juridical
         --, COALESCE (tmpObject_GoodsPropertyValueGroup.Quality,   tmpObject_GoodsPropertyValue.Quality, tmpGoodsQuality.Value17) AS Quality_Juridical

             -- Строк придатності (КУ) - подставляется для вида товара - срок годности в днях
           , CASE WHEN tmpMIGoodsByGoodsKind.NormInDays_gk > 0 THEN zfConvert_FloatToString (tmpMIGoodsByGoodsKind.NormInDays_gk) || ' діб'
                  ELSE COALESCE (tmpObject_GoodsPropertyValueGroup.Quality2,  COALESCE (tmpObject_GoodsPropertyValue.Quality2, ''))
             END AS Quality2_Juridical
             -- Умови зберігання (КУ)
           , tmpGoodsQuality.Value10 AS Quality10_Juridical
         --, COALESCE (tmpObject_GoodsPropertyValueGroup.Quality10, COALESCE (tmpObject_GoodsPropertyValue.Quality10, '')) AS Quality10_Juridical

           , (CASE WHEN COALESCE (tmpObject_GoodsPropertyValueGroup.Name, tmpObject_GoodsPropertyValue.Name) <> '' THEN COALESCE (tmpObject_GoodsPropertyValueGroup.Name, tmpObject_GoodsPropertyValue.Name) ELSE Object_Goods.ValueData END
           || CASE WHEN COALESCE (Object_GoodsKind.Id, zc_Enum_GoodsKind_Main()) = zc_Enum_GoodsKind_Main() THEN '' ELSE ' ' || Object_GoodsKind.ValueData END
             ) :: TVarChar AS GoodsName
           , (CASE WHEN COALESCE (Object_GoodsKind.Id, zc_Enum_GoodsKind_Main()) = zc_Enum_GoodsKind_Main() THEN '' ELSE Object_GoodsKind.ValueData END) :: TVarChar AS GoodsKindName

           , tmpMI.AmountPartner                                                                                AS AmountPartner
           , CAST (CASE WHEN Object_Measure.Id = zc_Measure_Sh()
                             THEN tmpMI.AmountPartner * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END
                        ELSE tmpMI.AmountPartner
                   END AS TFloat) AS Amount5
           , 0 AS Amount9
           , 0 AS Amount13

           , Movement.OperDate AS OperDateIn
           -- в качественное для страницы №4 - zc_ObjectFloat_GoodsByGoodsKind_DaysQ - если св-во заполнено выводим 3 даты через зпт, 1) дата пок - 1 - DaysQ  2)дата пок - DaysQ 3)дата пок если не заполнено выводим "дата пок"
           , CASE WHEN COALESCE (tmpMIGoodsByGoodsKind.DaysQ_gk,0) = 0 THEN zfConvert_DateToString (Movement.OperDatePartner)
                  ELSE zfConvert_DateToString (Movement.OperDatePartner)||', '
                    || zfConvert_DateToString (Movement.OperDatePartner - ((tmpMIGoodsByGoodsKind.DaysQ_gk)     :: TVarChar || ' DAY') :: INTERVAl) ||', '
                    || zfConvert_DateToString (Movement.OperDatePartner - ((tmpMIGoodsByGoodsKind.DaysQ_gk + 1) :: TVarChar || ' DAY') :: INTERVAl)
             END :: TVarChar AS OperDateIn_str4
           , Movement.OperDate AS OperDateOut

           , (tmpMovement_QualityParams.OperDateIn + (CASE WHEN tmpMIGoodsByGoodsKind.NormInDays_gk > 0 THEN (tmpMIGoodsByGoodsKind.NormInDays_gk) :: TVarChar ELSE '0' END || ' DAY') :: INTERVAl) :: TDateTime AS OperDate_end
           , (zfConvert_FloatToString (tmpMIGoodsByGoodsKind.NormInDays_gk) || ' діб') :: TVarChar AS NormInDays_gk_str

           , '' :: TVarChar    AS CarModelName
           , '' :: TVarChar    AS CarName
           , TRUE :: Boolean   AS isJuridicalBasis

             -- МЕТРО Кеш енд Кері Україна ТОВ
           , CASE WHEN Movement.OKPO_To = '32049199' THEN 'ДЕКЛАРАЦІЯ ПОСТАЧАЛЬНИКА' ELSE 'Декларація виробника' END :: TVarChar AS Main_str

           , tmpGoodsQuality.NumberPrint
           , tmpGoodsQuality.QualityCode
           , tmpGoodsQuality.QualityName
           , tmpGoodsQuality.QualityComment
             -- Значение ГОСТ, ДСТУ,ТУ (КУ)
           , tmpGoodsQuality.Value17
             -- для вида товара - Вид оболонки, №4
           , CASE WHEN tmpMIGoodsByGoodsKind.Value1_gk <> '' THEN tmpMIGoodsByGoodsKind.Value1_gk ELSE tmpGoodsQuality.Value1 END :: TVarChar AS Value1
             --
           , tmpGoodsQuality.Value2
           , tmpGoodsQuality.Value3
           , tmpGoodsQuality.Value4
           , tmpGoodsQuality.Value5
           , tmpGoodsQuality.Value6
           , tmpGoodsQuality.Value7
           , tmpGoodsQuality.Value8
           , tmpGoodsQuality.Value9
           , tmpGoodsQuality.Value10

             -- для вида товара - Вид пакування/стан продукції
           , tmpMIGoodsByGoodsKind.Value11_gk

           , tmpMovement_QualityParams.InvNumber AS InvNumber_Quality
           , tmpMovement_QualityParams.OperDate AS OperDate_Quality
           , tmpMovement_QualityParams.OperDateCertificate
           , tmpMovement_QualityParams.CertificateNumber
           , tmpMovement_QualityParams.CertificateSeries
           , tmpMovement_QualityParams.CertificateSeriesNumber
           , tmpMovement_QualityParams.ExpertPrior
           , tmpMovement_QualityParams.ExpertLast
           , tmpMovement_QualityParams.QualityNumber
           , tmpMovement_QualityParams.Comment AS QualityComment_Movement
           , tmpMovement_QualityParams.ReportType
           , tmpMovement_QualityParams.MovementId_find

       FROM tmpMI
            INNER JOIN tmpMovement_Params AS Movement ON Movement.Id =  tmpMI.MovementId

            LEFT JOIN Object AS Object_Goods     ON Object_Goods.Id     = tmpMI.ObjectId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMI.GoodsKindId

            INNER JOIN tmpGoodsQuality ON tmpGoodsQuality.GoodsId = tmpMI.ObjectId
            LEFT JOIN tmpMovement_QualityParams ON tmpMovement_QualityParams.QualityId = tmpGoodsQuality.QualityId

            LEFT JOIN tmpMIGoodsByGoodsKind ON tmpMIGoodsByGoodsKind.ObjectId    = tmpMI.ObjectId
                                           AND tmpMIGoodsByGoodsKind.GoodsKindId = tmpMI.GoodsKindId

            LEFT JOIN tmpUKTZED ON tmpUKTZED.GoodsGroupId = tmpMI.GoodsGroupId
            LEFT JOIN ObjectString AS ObjectString_Goods_UKTZED
                                   ON ObjectString_Goods_UKTZED.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_UKTZED.DescId = zc_ObjectString_Goods_UKTZED()
            LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                 ON ObjectLink_Goods_InfoMoney.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()

            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                  ON ObjectFloat_Weight.ObjectId = tmpMI.ObjectId
                                 AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                 ON ObjectLink_Goods_GoodsGroup.ObjectId = tmpMI.ObjectId
                                AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
            LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpMI.ObjectId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN tmpObject_GoodsPropertyValue ON tmpObject_GoodsPropertyValue.GoodsId     = Object_Goods.Id
                                                  AND tmpObject_GoodsPropertyValue.GoodsKindId = Object_GoodsKind.Id
                                                  AND tmpObject_GoodsPropertyValue.MovementId  = tmpMI.MovementId
            LEFT JOIN tmpObject_GoodsPropertyValueGroup ON tmpObject_GoodsPropertyValueGroup.GoodsId = Object_Goods.Id
                                                       AND tmpObject_GoodsPropertyValue.GoodsId      IS NULL
      ORDER BY Movement.Id
             , tmpGoodsQuality.QualityCode
             , Object_Goods.ValueData, Object_GoodsKind.ValueData
       ;

     -- Данные: заголовок + строчная часть для ФОРМЫ 1
     OPEN Cursor1 FOR
      SELECT *
      FROM tmpCursor1;
     RETURN NEXT Cursor1;


     -- Данные: заголовок + строчная часть ДЛЯ ФОРМЫ 2
     OPEN Cursor2 FOR
      SELECT *
      FROM tmpCursor2;
     RETURN NEXT Cursor2;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 14.05.21         *
 19.02.21         * add DaysQ_gk
 24.07.19         *
 13.01.17         * add CodeUKTZED
 31.03.15                                        * all
 11.02.15                                                       *
*/

-- SELECT * FROM gpSelect_Movement_Quality_Print_two(inMovementId := 19042873 , inisAll := 'True' ,  inSession := '5'); --FETCH ALL "<unnamed portal 9>";
