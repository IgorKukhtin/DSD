-- Function: gpSelect_Movement_GoodsQuality_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_GoodsQuality_Print (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_GoodsQuality_Print(
    IN inMovementId         Integer  , -- ключ Документа
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

--    DECLARE vbMovementId_SalePack Integer;
--    DECLARE vbStatusId_SalePack Integer;

    DECLARE vbOperDate  TDateTime;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;

    DECLARE vbGoodsPropertyId       Integer;
    DECLARE vbGoodsPropertyId_basis Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Sale());
     vbUserId:= inSession;


     -- определяется параметр
     vbOperDate := (SELECT OperDate FROM Movement WHERE Id = inMovementId);

     vbGoodsPropertyId:= (SELECT ObjectLink_Juridical_GoodsProperty.ChildObjectId
                          FROM Movement
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                            ON MovementLinkObject_To.MovementId = Movement.Id
                                                           AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                               LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                    ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                                                   AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                               LEFT JOIN ObjectLink AS ObjectLink_Juridical_GoodsProperty
                                                    ON ObjectLink_Juridical_GoodsProperty.ObjectId = COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MovementLinkObject_To.ObjectId)
                                                   AND ObjectLink_Juridical_GoodsProperty.DescId = zc_ObjectLink_Juridical_GoodsProperty()
                          WHERE Movement.Id = inMovementId
                         );
     -- определяется параметр
     vbGoodsPropertyId_basis:= (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = zc_Juridical_Basis() AND DescId = zc_ObjectLink_Juridical_GoodsProperty());


     -- Данные: заголовок + строчная часть для ФОРМЫ 1
     OPEN Cursor1 FOR
     WITH tmpObject_GoodsPropertyValue AS
       (SELECT ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
             , ObjectLink_GoodsPropertyValue_Goods.ChildObjectId                   AS GoodsId
             , COALESCE (ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId, 0) AS GoodsKindId
             , Object_GoodsPropertyValue.ValueData  AS Name
             , ObjectFloat_Amount.ValueData         AS Amount
             , ObjectString_BarCode.ValueData       AS BarCode
             , ObjectString_Article.ValueData       AS Article
             , ObjectString_GroupName.ValueData     AS GroupName
        FROM (SELECT vbGoodsPropertyId AS GoodsPropertyId WHERE vbGoodsPropertyId <> 0
             ) AS tmpGoodsProperty
             INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                   ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = tmpGoodsProperty.GoodsPropertyId
                                  AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
             LEFT JOIN Object AS Object_GoodsPropertyValue ON Object_GoodsPropertyValue.Id = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
             LEFT JOIN ObjectFloat AS ObjectFloat_Amount
                                   ON ObjectFloat_Amount.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                  AND ObjectFloat_Amount.DescId = zc_ObjectFloat_GoodsPropertyValue_Amount()

             LEFT JOIN ObjectString AS ObjectString_BarCode
                                    ON ObjectString_BarCode.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                   AND ObjectString_BarCode.DescId = zc_ObjectString_GoodsPropertyValue_BarCode()
             LEFT JOIN ObjectString AS ObjectString_Article
                                    ON ObjectString_Article.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                   AND ObjectString_Article.DescId = zc_ObjectString_GoodsPropertyValue_Article()

             LEFT JOIN ObjectString AS ObjectString_GroupName
                                    ON ObjectString_GroupName.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                   AND ObjectString_GroupName.DescId = zc_ObjectString_GoodsPropertyValue_GroupName()

             LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                  ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                 AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
             LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                  ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                 AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
       )
     , tmpObject_GoodsPropertyValueGroup AS
       (SELECT tmpObject_GoodsPropertyValue.GoodsId
             , tmpObject_GoodsPropertyValue.Name
             , tmpObject_GoodsPropertyValue.BarCode
             , tmpObject_GoodsPropertyValue.Article
             , tmpObject_GoodsPropertyValue.GroupName
        FROM (SELECT MAX (tmpObject_GoodsPropertyValue.ObjectId) AS ObjectId, GoodsId FROM tmpObject_GoodsPropertyValue WHERE Name <> '' OR BarCode <> '' OR Article <> '' OR GroupName <> '' GROUP BY GoodsId
             ) AS tmpGoodsProperty_find
             LEFT JOIN tmpObject_GoodsPropertyValue ON tmpObject_GoodsPropertyValue.ObjectId =  tmpGoodsProperty_find.ObjectId
       )
     , tmpObject_GoodsPropertyValue_basis AS
       (SELECT ObjectLink_GoodsPropertyValue_Goods.ChildObjectId                   AS GoodsId
             , COALESCE (ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId, 0) AS GoodsKindId
             , Object_GoodsPropertyValue.ValueData  AS Name
        FROM (SELECT vbGoodsPropertyId_basis AS GoodsPropertyId
             ) AS tmpGoodsProperty
             INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                   ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = tmpGoodsProperty.GoodsPropertyId
                                  AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
             INNER JOIN Object AS Object_GoodsPropertyValue ON Object_GoodsPropertyValue.Id = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                           AND Object_GoodsPropertyValue.ValueData <> ''
             LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                  ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                 AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
             LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                  ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                 AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
       )

     , tmpMIGoods AS
       (SELECT DISTINCT MovementItem.ObjectId AS GoodsId
        FROM MovementItem
        WHERE MovementItem.MovementId =  inMovementId
          AND MovementItem.DescId     = zc_MI_Master()
          AND MovementItem.isErased   = FALSE
          AND MovementItem.Amount <> 0
       )

     , tmpGoodsQualityParams AS
       (
        SELECT
--           , Object_GoodsQuality.isErased    AS isErased
             Object_GoodsQuality.Id          AS Id
           , Object_GoodsQuality.ObjectCode  AS Code
           , Object_GoodsQuality.ValueData   AS Value17
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

           , GoodsQuality_Goods.ChildObjectId  AS GoodsId

           , Object_Quality.Id           AS QualityId
           , Object_Quality.ObjectCode   AS QualityCode
           , Object_Quality.ValueData    AS QualityName
           , OS_QualityComment.ValueData AS QualityComment



       FROM Object AS Object_GoodsQuality
--           LEFT JOIN (SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE UserId = vbUserId GROUP BY AccessKeyId) AS tmpRoleAccessKey ON NOT vbAccessKeyAll AND tmpRoleAccessKey.AccessKeyId = Object_GoodsQuality.AccessKeyId

           LEFT JOIN ObjectString AS ObjectString_Value1
                               ON ObjectString_Value1.ObjectId = Object_GoodsQuality.Id
                              AND ObjectString_Value1.DescId = zc_ObjectString_GoodsQuality_Value1()
           LEFT JOIN ObjectString AS ObjectString_Value2
                               ON ObjectString_Value2.ObjectId = Object_GoodsQuality.Id
                              AND ObjectString_Value2.DescId = zc_ObjectString_GoodsQuality_Value2()
           LEFT JOIN ObjectString AS ObjectString_Value3
                               ON ObjectString_Value3.ObjectId = Object_GoodsQuality.Id
                              AND ObjectString_Value3.DescId = zc_ObjectString_GoodsQuality_Value3()
           LEFT JOIN ObjectString AS ObjectString_Value4
                               ON ObjectString_Value4.ObjectId = Object_GoodsQuality.Id
                              AND ObjectString_Value4.DescId = zc_ObjectString_GoodsQuality_Value4()
           LEFT JOIN ObjectString AS ObjectString_Value5
                               ON ObjectString_Value5.ObjectId = Object_GoodsQuality.Id
                              AND ObjectString_Value5.DescId = zc_ObjectString_GoodsQuality_Value5()
           LEFT JOIN ObjectString AS ObjectString_Value6
                               ON ObjectString_Value6.ObjectId = Object_GoodsQuality.Id
                              AND ObjectString_Value6.DescId = zc_ObjectString_GoodsQuality_Value6()
           LEFT JOIN ObjectString AS ObjectString_Value7
                               ON ObjectString_Value7.ObjectId = Object_GoodsQuality.Id
                              AND ObjectString_Value7.DescId = zc_ObjectString_GoodsQuality_Value7()
           LEFT JOIN ObjectString AS ObjectString_Value8
                               ON ObjectString_Value8.ObjectId = Object_GoodsQuality.Id
                              AND ObjectString_Value8.DescId = zc_ObjectString_GoodsQuality_Value8()
           LEFT JOIN ObjectString AS ObjectString_Value9
                               ON ObjectString_Value9.ObjectId = Object_GoodsQuality.Id
                              AND ObjectString_Value9.DescId = zc_ObjectString_GoodsQuality_Value9()
           LEFT JOIN ObjectString AS ObjectString_Value10
                               ON ObjectString_Value10.ObjectId = Object_GoodsQuality.Id
                              AND ObjectString_Value10.DescId = zc_ObjectString_GoodsQuality_Value10()

           JOIN ObjectLink AS GoodsQuality_Goods
                           ON GoodsQuality_Goods.ObjectId = Object_GoodsQuality.Id
                          AND GoodsQuality_Goods.DescId = zc_ObjectLink_GoodsQuality_Goods()
           JOIN tmpMIGoods AS Object_Goods ON Object_Goods.GoodsId = GoodsQuality_Goods.ChildObjectId

           LEFT JOIN ObjectLink AS GoodsQuality_Quality
                                ON GoodsQuality_Quality.ObjectId = Object_GoodsQuality.Id
                               AND GoodsQuality_Quality.DescId = zc_ObjectLink_GoodsQuality_Quality()

           LEFT JOIN Object AS Object_Quality ON Object_Quality.Id = GoodsQuality_Quality.ChildObjectId
           LEFT JOIN ObjectString AS OS_QualityComment
                                  ON OS_QualityComment.ObjectId = Object_Quality.Id
                                 AND OS_QualityComment.DescId = zc_ObjectString_Quality_Comment()
/*
            LEFT JOIN ObjectLink AS ObjectLink_Quality_Juridical
                                 ON ObjectLink_Quality_Juridical.ObjectId = Object_Quality.Id
                                AND ObjectLink_Quality_Juridical.DescId = zc_ObjectLink_Quality_Juridical()
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Quality_Juridical.ChildObjectId
*/
        WHERE Object_GoodsQuality.DescId = zc_Object_GoodsQuality()
--          AND GoodsQuality_Goods.ChildObjectId = tmpMIGoods.GoodsId
--        AND (tmpRoleAccessKey.AccessKeyId IS NOT NULL OR vbAccessKeyAll)
       )

     , tmpMovement_GoodsQuality AS
       (
       SELECT
             Movement.Id                                        AS Id
           , Movement.InvNumber                                 AS InvNumber
           , Movement.OperDate                                  AS OperDate
           , Object_Status.ObjectCode                           AS StatusCode
           , Object_Status.ValueData                            AS StatusName
           , MD_OperDateCertificate.ValueData                   AS OperDateCertificate
           , MS_CertificateNumber.ValueData                     AS CertificateNumber
           , MS_CertificateSeries.ValueData                     AS CertificateSeries
           , MS_CertificateSeriesNumber.ValueData               AS CertificateSeriesNumber
           , MS_ExpertPrior.ValueData                           AS ExpertPrior
           , MS_ExpertLast.ValueData                            AS ExpertLast
           , MS_QualityNumber.ValueData                         AS QualityNumber
           , MB_Comment.ValueData                               AS Comment
           , Object_Quality.Id                                  AS QualityId
           , Object_Quality.ValueData   		                AS QualityName
           , 0                                                  AS ReportType

       FROM  Movement

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementDate AS MD_OperDateCertificate
                                   ON MD_OperDateCertificate.MovementId =  Movement.Id
                                  AND MD_OperDateCertificate.DescId = zc_MovementDate_OperDateCertificate()
            LEFT JOIN MovementString AS MS_CertificateNumber
                                     ON MS_CertificateNumber.MovementId =  Movement.Id
                                    AND MS_CertificateNumber.DescId = zc_MovementString_CertificateNumber()
            LEFT JOIN MovementString AS MS_CertificateSeries
                                     ON MS_CertificateSeries.MovementId =  Movement.Id
                                    AND MS_CertificateSeries.DescId = zc_MovementString_CertificateSeries()
            LEFT JOIN MovementString AS MS_CertificateSeriesNumber
                                     ON MS_CertificateSeriesNumber.MovementId =  Movement.Id
                                    AND MS_CertificateSeriesNumber.DescId = zc_MovementString_CertificateSeriesNumber()
            LEFT JOIN MovementString AS MS_ExpertPrior
                                     ON MS_ExpertPrior.MovementId =  Movement.Id
                                    AND MS_ExpertPrior.DescId = zc_MovementString_ExpertPrior()
            LEFT JOIN MovementString AS MS_ExpertLast
                                     ON MS_ExpertLast.MovementId =  Movement.Id
                                    AND MS_ExpertLast.DescId = zc_MovementString_ExpertLast()
            LEFT JOIN MovementString AS MS_QualityNumber
                                     ON MS_QualityNumber.MovementId =  Movement.Id
                                    AND MS_QualityNumber.DescId = zc_MovementString_QualityNumber()
            LEFT JOIN MovementBlob AS MB_Comment
                                   ON MB_Comment.MovementId =  Movement.Id
                                  AND MB_Comment.DescId = zc_MovementBlob_Comment()
            INNER JOIN MovementLinkObject AS MLO_Quality
                                         ON MLO_Quality.MovementId = Movement.Id
                                        AND MLO_Quality.DescId = zc_MovementLinkObject_Quality()
            INNER JOIN tmpGoodsQualityParams ON tmpGoodsQualityParams.QualityId = MLO_Quality.ObjectId

            LEFT JOIN Object AS Object_Quality ON Object_Quality.Id = MLO_Quality.ObjectId
       WHERE Movement.OperDate >= vbOperDate --BETWEEN inStartDate AND inEndDate
         AND Movement.DescId = zc_Movement_GoodsQuality()
       --AND Movement.StatusId = tmpStatus.StatusId
       -- AND ReportType IN ( 0, 1 ) -- два отчета отличающихся только картинкой и подписью, идут в 1 датасете
       ORDER BY Movement.OperDate DESC, Movement.Id DESC
       LIMIT 1
       )

      SELECT Movement.Id				                                            AS MovementId
           , Movement.InvNumber				                                        AS InvNumber
           , Movement.OperDate				                                        AS OperDate
           , COALESCE(MovementString_InvNumberPartner.ValueData,Movement.InvNumber) AS InvNumberPartner
--           , MovementString_InvNumberOrder.ValueData                                AS InvNumberOrder
           , COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate)   AS OperDatePartner
           , ObjectString_FromAddress.ValueData                                     AS PartnerAddress_From
           , ObjectString_ToAddress.ValueData                                       AS PartnerAddress_To
           , OH_JuridicalDetails_To.FullName                                        AS JuridicalName_To
           , OH_JuridicalDetails_To.JuridicalAddress                                AS JuridicalAddress_To
           , OH_JuridicalDetails_From.FullName                                      AS JuridicalName_From
           , OH_JuridicalDetails_From.JuridicalAddress                              AS JuridicalAddress_From
           , MovementItem.Id                                                        AS Id
           , Object_Goods.ObjectCode                                                AS GoodsCode
--           , Object_GoodsGroup.ValueData     AS GoodsGroupName
           , (CASE WHEN tmpObject_GoodsPropertyValue.Name <> '' THEN tmpObject_GoodsPropertyValue.Name WHEN tmpObject_GoodsPropertyValue_basis.Name <> '' THEN tmpObject_GoodsPropertyValue_basis.Name ELSE Object_Goods.ValueData END || CASE WHEN COALESCE (Object_GoodsKind.Id, zc_Enum_GoodsKind_Main()) = zc_Enum_GoodsKind_Main() THEN '' ELSE ' ' || Object_GoodsKind.ValueData END) :: TVarChar AS GoodsName
           , CASE WHEN tmpObject_GoodsPropertyValue.Name <> '' THEN tmpObject_GoodsPropertyValue.Name WHEN tmpObject_GoodsPropertyValue_basis.Name <> '' THEN tmpObject_GoodsPropertyValue_basis.Name ELSE Object_Goods.ValueData END AS GoodsName_two
           , COALESCE (tmpObject_GoodsPropertyValue.Name, '')                                   AS GoodsName_Juridical
           , Object_GoodsKind.ValueData                                                         AS GoodsKindName
--           , Object_Measure.ValueData                                                           AS MeasureName

           , COALESCE (tmpObject_GoodsPropertyValue.GroupName, '')                              AS GroupName_Juridical
           , COALESCE (tmpObject_GoodsPropertyValue.Amount, 0)                                  AS AmountInPack_Juridical
           , COALESCE (tmpObject_GoodsPropertyValueGroup.Article, COALESCE (tmpObject_GoodsPropertyValue.Article, '')) AS Article_Juridical
           , COALESCE (tmpObject_GoodsPropertyValue.BarCode, '')                                AS BarCode_Juridical

           , MovementItem.Amount                                                                AS Amount
           , COALESCE (MIFloat_AmountPartner.ValueData, 0)                                      AS AmountPartner
           , COALESCE (MIFloat_BoxCount.ValueData, 0)                                           AS Box_Count
           , COALESCE (OF_Box_Weight.ValueData, 0) * COALESCE (MIFloat_BoxCount.ValueData, 0)   AS Box_Weight
           , CAST ((COALESCE (MIFloat_AmountPartner.ValueData, 0) * (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END )) AS TFloat) AS Netto_Weight
           , CAST ((COALESCE (MIFloat_AmountPartner.ValueData, 0) * (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END )) + (COALESCE (OF_Box_Weight.ValueData, 0) * COALESCE (MIFloat_BoxCount.ValueData, 0)) AS TFloat) AS Brutto_Weight

           , tmpGoodsQualityParams.Value17
           , tmpGoodsQualityParams.Value1
           , tmpGoodsQualityParams.Value2
           , tmpGoodsQualityParams.Value3
           , tmpGoodsQualityParams.Value4
           , tmpGoodsQualityParams.Value5
           , tmpGoodsQualityParams.Value6
           , tmpGoodsQualityParams.Value7
           , tmpGoodsQualityParams.Value8
           , tmpGoodsQualityParams.Value9
           , tmpGoodsQualityParams.Value10
           , tmpGoodsQualityParams.QualityName
           , tmpGoodsQualityParams.QualityComment

           , tmpMovement_GoodsQuality.InvNumber AS InvNumberQuality
           , tmpMovement_GoodsQuality.OperDate
           , tmpMovement_GoodsQuality.OperDateCertificate
           , tmpMovement_GoodsQuality.CertificateNumber
           , tmpMovement_GoodsQuality.CertificateSeries
           , tmpMovement_GoodsQuality.CertificateSeriesNumber
           , tmpMovement_GoodsQuality.ExpertPrior
           , tmpMovement_GoodsQuality.ExpertLast
           , tmpMovement_GoodsQuality.QualityNumber
           , tmpMovement_GoodsQuality.Comment
           , tmpMovement_GoodsQuality.QualityId
           , tmpMovement_GoodsQuality.QualityName
           , tmpMovement_GoodsQuality.ReportType


           , CAST (CASE WHEN Object_Measure.Id = zc_Measure_Kg() THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) ELSE 0 END AS TFloat) AS Amount5
           , 0                                                                                                                            AS Amount9
           , CAST (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) ELSE 0 END AS TFloat) AS Amount13

       FROM Movement

            INNER JOIN MovementItem ON MovementItem.MovementId =  Movement.Id
                                   AND MovementItem.DescId     = zc_MI_Master()
                                   AND MovementItem.isErased   = FALSE
                                   AND MovementItem.Amount <> 0
--            +++ качественное сюда выбрать и подвязать по гудс-ид для начала
--*****************************************************************************************************************
            LEFT JOIN tmpGoodsQualityParams ON tmpGoodsQualityParams.GoodsId = MovementItem.ObjectId
--*****************************************************************************************************************
--            INNER JOIN tmpMovement_GoodsQuality ON tmpMovement_GoodsQuality.QualityId = tmpGoodsQualityParams.QualityId
            LEFT JOIN tmpMovement_GoodsQuality ON tmpMovement_GoodsQuality.QualityId = tmpGoodsQualityParams.QualityId             -- ONLY FOR TEST!!!!!!

            LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                        ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
            LEFT JOIN MovementItemFloat AS MIFloat_BoxCount
                                        ON MIFloat_BoxCount.MovementItemId = MovementItem.Id
                                       AND MIFloat_BoxCount.DescId = zc_MIFloat_BoxCount()
            LEFT JOIN MovementItemLinkObject AS MILinkObject_Box
                                             ON MILinkObject_Box.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Box.DescId = zc_MILinkObject_Box()
            LEFT JOIN ObjectFloat AS OF_Box_Weight
                                  ON OF_Box_Weight.ObjectId = MILinkObject_Box.ObjectId
                                 AND OF_Box_Weight.DescId = zc_ObjectFloat_Box_Weight()

            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                  ON ObjectFloat_Weight.ObjectId = MovementItem.ObjectId
                                 AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()


            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()

            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

            LEFT JOIN tmpObject_GoodsPropertyValue ON tmpObject_GoodsPropertyValue.GoodsId = MovementItem.ObjectId
                                                  AND tmpObject_GoodsPropertyValue.GoodsKindId = COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
            LEFT JOIN tmpObject_GoodsPropertyValueGroup ON tmpObject_GoodsPropertyValueGroup.GoodsId = MovementItem.ObjectId
                                                       AND tmpObject_GoodsPropertyValue.GoodsId IS NULL
            LEFT JOIN tmpObject_GoodsPropertyValue_basis ON tmpObject_GoodsPropertyValue_basis.GoodsId = MovementItem.ObjectId
                                                        AND tmpObject_GoodsPropertyValue_basis.GoodsKindId = COALESCE (MILinkObject_GoodsKind.ObjectId, 0)

-- MOVEMENT


            LEFT JOIN MovementFloat AS MovementFloat_TotalCountKg
                                    ON MovementFloat_TotalCountKg.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCountKg.DescId = zc_MovementFloat_TotalCountKg()

            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId =  Movement.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
--            LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_From.Id

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId IN ( zc_MovementLinkObject_Contract(), zc_MovementLinkObject_ContractTo())
            LEFT JOIN Object_Contract_View AS View_Contract ON View_Contract.ContractId = MovementLinkObject_Contract.ObjectId


            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                 ON ObjectLink_Partner_Juridical.ObjectId = Object_To.Id
                                AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()


            LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_To
                                                                ON OH_JuridicalDetails_To.JuridicalId = COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, Object_To.Id)
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) >= OH_JuridicalDetails_To.StartDate
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) <  OH_JuridicalDetails_To.EndDate

            LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_From
                                                                ON OH_JuridicalDetails_From.JuridicalId = COALESCE (View_Contract.JuridicalBasisId, Object_From.Id)
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) >= OH_JuridicalDetails_From.StartDate
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) <  OH_JuridicalDetails_From.EndDate

            LEFT JOIN ObjectString AS ObjectString_FromAddress
                                   ON ObjectString_FromAddress.ObjectId = MovementLinkObject_From.ObjectId
                                  AND ObjectString_FromAddress.DescId = zc_ObjectString_Partner_Address()

            LEFT JOIN ObjectString AS ObjectString_ToAddress
                                   ON ObjectString_ToAddress.ObjectId = MovementLinkObject_To.ObjectId
                                  AND ObjectString_ToAddress.DescId = zc_ObjectString_Partner_Address()
      WHERE Movement.Id = inMovementId

      ORDER BY MovementItem.MovementId, MovementItem.Id
--       ORDER BY MovementString_InvNumberPartner.ValueData
      ;
     RETURN NEXT Cursor1;


--******************************************************************************************************************************************

     -- Данные: заголовок + строчная часть ДЛЯ ФОРМЫ 2
     OPEN Cursor2 FOR
     WITH tmpObject_GoodsPropertyValue AS
       (SELECT ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
             , ObjectLink_GoodsPropertyValue_Goods.ChildObjectId                   AS GoodsId
             , COALESCE (ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId, 0) AS GoodsKindId
             , Object_GoodsPropertyValue.ValueData  AS Name
             , ObjectFloat_Amount.ValueData         AS Amount
             , ObjectString_BarCode.ValueData       AS BarCode
             , ObjectString_Article.ValueData       AS Article
             , ObjectString_GroupName.ValueData     AS GroupName
        FROM (SELECT vbGoodsPropertyId AS GoodsPropertyId WHERE vbGoodsPropertyId <> 0
             ) AS tmpGoodsProperty
             INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                   ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = tmpGoodsProperty.GoodsPropertyId
                                  AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
             LEFT JOIN Object AS Object_GoodsPropertyValue ON Object_GoodsPropertyValue.Id = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
             LEFT JOIN ObjectFloat AS ObjectFloat_Amount
                                   ON ObjectFloat_Amount.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                  AND ObjectFloat_Amount.DescId = zc_ObjectFloat_GoodsPropertyValue_Amount()

             LEFT JOIN ObjectString AS ObjectString_BarCode
                                    ON ObjectString_BarCode.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                   AND ObjectString_BarCode.DescId = zc_ObjectString_GoodsPropertyValue_BarCode()
             LEFT JOIN ObjectString AS ObjectString_Article
                                    ON ObjectString_Article.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                   AND ObjectString_Article.DescId = zc_ObjectString_GoodsPropertyValue_Article()

             LEFT JOIN ObjectString AS ObjectString_GroupName
                                    ON ObjectString_GroupName.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                   AND ObjectString_GroupName.DescId = zc_ObjectString_GoodsPropertyValue_GroupName()

             LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                  ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                 AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
             LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                  ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                 AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
       )
     , tmpObject_GoodsPropertyValueGroup AS
       (SELECT tmpObject_GoodsPropertyValue.GoodsId
             , tmpObject_GoodsPropertyValue.Name
             , tmpObject_GoodsPropertyValue.BarCode
             , tmpObject_GoodsPropertyValue.Article
             , tmpObject_GoodsPropertyValue.GroupName
        FROM (SELECT MAX (tmpObject_GoodsPropertyValue.ObjectId) AS ObjectId, GoodsId FROM tmpObject_GoodsPropertyValue WHERE Name <> '' OR BarCode <> '' OR Article <> '' OR GroupName <> '' GROUP BY GoodsId
             ) AS tmpGoodsProperty_find
             LEFT JOIN tmpObject_GoodsPropertyValue ON tmpObject_GoodsPropertyValue.ObjectId =  tmpGoodsProperty_find.ObjectId
       )
     , tmpObject_GoodsPropertyValue_basis AS
       (SELECT ObjectLink_GoodsPropertyValue_Goods.ChildObjectId                   AS GoodsId
             , COALESCE (ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId, 0) AS GoodsKindId
             , Object_GoodsPropertyValue.ValueData  AS Name
        FROM (SELECT vbGoodsPropertyId_basis AS GoodsPropertyId
             ) AS tmpGoodsProperty
             INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                   ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = tmpGoodsProperty.GoodsPropertyId
                                  AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
             INNER JOIN Object AS Object_GoodsPropertyValue ON Object_GoodsPropertyValue.Id = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                           AND Object_GoodsPropertyValue.ValueData <> ''
             LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                  ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                 AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
             LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                  ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                 AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
       )

     , tmpMIGoods AS
       (SELECT DISTINCT MovementItem.ObjectId AS GoodsId
        FROM MovementItem
        WHERE MovementItem.MovementId =  inMovementId
          AND MovementItem.DescId     = zc_MI_Master()
          AND MovementItem.isErased   = FALSE
          AND MovementItem.Amount <> 0
       )

     , tmpGoodsQualityParams AS
       (
        SELECT
--           , Object_GoodsQuality.isErased    AS isErased
             Object_GoodsQuality.Id          AS Id
           , Object_GoodsQuality.ObjectCode  AS Code
           , Object_GoodsQuality.ValueData   AS Value17
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

           , GoodsQuality_Goods.ChildObjectId  AS GoodsId

           , Object_Quality.Id           AS QualityId
           , Object_Quality.ObjectCode   AS QualityCode
           , Object_Quality.ValueData    AS QualityName
           , OS_QualityComment.ValueData AS QualityComment



       FROM Object AS Object_GoodsQuality
--           LEFT JOIN (SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE UserId = vbUserId GROUP BY AccessKeyId) AS tmpRoleAccessKey ON NOT vbAccessKeyAll AND tmpRoleAccessKey.AccessKeyId = Object_GoodsQuality.AccessKeyId

           LEFT JOIN ObjectString AS ObjectString_Value1
                               ON ObjectString_Value1.ObjectId = Object_GoodsQuality.Id
                              AND ObjectString_Value1.DescId = zc_ObjectString_GoodsQuality_Value1()
           LEFT JOIN ObjectString AS ObjectString_Value2
                               ON ObjectString_Value2.ObjectId = Object_GoodsQuality.Id
                              AND ObjectString_Value2.DescId = zc_ObjectString_GoodsQuality_Value2()
           LEFT JOIN ObjectString AS ObjectString_Value3
                               ON ObjectString_Value3.ObjectId = Object_GoodsQuality.Id
                              AND ObjectString_Value3.DescId = zc_ObjectString_GoodsQuality_Value3()
           LEFT JOIN ObjectString AS ObjectString_Value4
                               ON ObjectString_Value4.ObjectId = Object_GoodsQuality.Id
                              AND ObjectString_Value4.DescId = zc_ObjectString_GoodsQuality_Value4()
           LEFT JOIN ObjectString AS ObjectString_Value5
                               ON ObjectString_Value5.ObjectId = Object_GoodsQuality.Id
                              AND ObjectString_Value5.DescId = zc_ObjectString_GoodsQuality_Value5()
           LEFT JOIN ObjectString AS ObjectString_Value6
                               ON ObjectString_Value6.ObjectId = Object_GoodsQuality.Id
                              AND ObjectString_Value6.DescId = zc_ObjectString_GoodsQuality_Value6()
           LEFT JOIN ObjectString AS ObjectString_Value7
                               ON ObjectString_Value7.ObjectId = Object_GoodsQuality.Id
                              AND ObjectString_Value7.DescId = zc_ObjectString_GoodsQuality_Value7()
           LEFT JOIN ObjectString AS ObjectString_Value8
                               ON ObjectString_Value8.ObjectId = Object_GoodsQuality.Id
                              AND ObjectString_Value8.DescId = zc_ObjectString_GoodsQuality_Value8()
           LEFT JOIN ObjectString AS ObjectString_Value9
                               ON ObjectString_Value9.ObjectId = Object_GoodsQuality.Id
                              AND ObjectString_Value9.DescId = zc_ObjectString_GoodsQuality_Value9()
           LEFT JOIN ObjectString AS ObjectString_Value10
                               ON ObjectString_Value10.ObjectId = Object_GoodsQuality.Id
                              AND ObjectString_Value10.DescId = zc_ObjectString_GoodsQuality_Value10()

           JOIN ObjectLink AS GoodsQuality_Goods
                           ON GoodsQuality_Goods.ObjectId = Object_GoodsQuality.Id
                          AND GoodsQuality_Goods.DescId = zc_ObjectLink_GoodsQuality_Goods()
           JOIN tmpMIGoods AS Object_Goods ON Object_Goods.GoodsId = GoodsQuality_Goods.ChildObjectId

           LEFT JOIN ObjectLink AS GoodsQuality_Quality
                                ON GoodsQuality_Quality.ObjectId = Object_GoodsQuality.Id
                               AND GoodsQuality_Quality.DescId = zc_ObjectLink_GoodsQuality_Quality()

           LEFT JOIN Object AS Object_Quality ON Object_Quality.Id = GoodsQuality_Quality.ChildObjectId
           LEFT JOIN ObjectString AS OS_QualityComment
                                  ON OS_QualityComment.ObjectId = Object_Quality.Id
                                 AND OS_QualityComment.DescId = zc_ObjectString_Quality_Comment()
/*
            LEFT JOIN ObjectLink AS ObjectLink_Quality_Juridical
                                 ON ObjectLink_Quality_Juridical.ObjectId = Object_Quality.Id
                                AND ObjectLink_Quality_Juridical.DescId = zc_ObjectLink_Quality_Juridical()
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Quality_Juridical.ChildObjectId
*/
        WHERE Object_GoodsQuality.DescId = zc_Object_GoodsQuality()
--          AND GoodsQuality_Goods.ChildObjectId = tmpMIGoods.GoodsId
--        AND (tmpRoleAccessKey.AccessKeyId IS NOT NULL OR vbAccessKeyAll)
       )

     , tmpMovement_GoodsQuality AS
       (
       SELECT
             Movement.Id                                        AS Id
           , Movement.InvNumber                                 AS InvNumber
           , Movement.OperDate                                  AS OperDate
           , Object_Status.ObjectCode                           AS StatusCode
           , Object_Status.ValueData                            AS StatusName
           , MD_OperDateCertificate.ValueData                   AS OperDateCertificate
           , MS_CertificateNumber.ValueData                     AS CertificateNumber
           , MS_CertificateSeries.ValueData                     AS CertificateSeries
           , MS_CertificateSeriesNumber.ValueData               AS CertificateSeriesNumber
           , MS_ExpertPrior.ValueData                           AS ExpertPrior
           , MS_ExpertLast.ValueData                            AS ExpertLast
           , MS_QualityNumber.ValueData                         AS QualityNumber
           , MB_Comment.ValueData                               AS Comment
           , Object_Quality.Id                                  AS QualityId
           , Object_Quality.ValueData   		                AS QualityName
           , 0                                                  AS ReportType

       FROM  Movement

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementDate AS MD_OperDateCertificate
                                   ON MD_OperDateCertificate.MovementId =  Movement.Id
                                  AND MD_OperDateCertificate.DescId = zc_MovementDate_OperDateCertificate()
            LEFT JOIN MovementString AS MS_CertificateNumber
                                     ON MS_CertificateNumber.MovementId =  Movement.Id
                                    AND MS_CertificateNumber.DescId = zc_MovementString_CertificateNumber()
            LEFT JOIN MovementString AS MS_CertificateSeries
                                     ON MS_CertificateSeries.MovementId =  Movement.Id
                                    AND MS_CertificateSeries.DescId = zc_MovementString_CertificateSeries()
            LEFT JOIN MovementString AS MS_CertificateSeriesNumber
                                     ON MS_CertificateSeriesNumber.MovementId =  Movement.Id
                                    AND MS_CertificateSeriesNumber.DescId = zc_MovementString_CertificateSeriesNumber()
            LEFT JOIN MovementString AS MS_ExpertPrior
                                     ON MS_ExpertPrior.MovementId =  Movement.Id
                                    AND MS_ExpertPrior.DescId = zc_MovementString_ExpertPrior()
            LEFT JOIN MovementString AS MS_ExpertLast
                                     ON MS_ExpertLast.MovementId =  Movement.Id
                                    AND MS_ExpertLast.DescId = zc_MovementString_ExpertLast()
            LEFT JOIN MovementString AS MS_QualityNumber
                                     ON MS_QualityNumber.MovementId =  Movement.Id
                                    AND MS_QualityNumber.DescId = zc_MovementString_QualityNumber()
            LEFT JOIN MovementBlob AS MB_Comment
                                   ON MB_Comment.MovementId =  Movement.Id
                                  AND MB_Comment.DescId = zc_MovementBlob_Comment()
            INNER JOIN MovementLinkObject AS MLO_Quality
                                         ON MLO_Quality.MovementId = Movement.Id
                                        AND MLO_Quality.DescId = zc_MovementLinkObject_Quality()
            INNER JOIN tmpGoodsQualityParams ON tmpGoodsQualityParams.QualityId = MLO_Quality.ObjectId

            LEFT JOIN Object AS Object_Quality ON Object_Quality.Id = MLO_Quality.ObjectId
       WHERE Movement.OperDate >= vbOperDate --BETWEEN inStartDate AND inEndDate
         AND Movement.DescId = zc_Movement_GoodsQuality()
       --AND Movement.StatusId = tmpStatus.StatusId
       ORDER BY Movement.OperDate DESC, Movement.Id DESC
       LIMIT 1
       )

      SELECT Movement.Id				                                            AS MovementId
           , Movement.InvNumber				                                        AS InvNumber
           , Movement.OperDate				                                        AS OperDate

           , COALESCE(MovementString_InvNumberPartner.ValueData,Movement.InvNumber) AS InvNumberPartner
--           , MovementString_InvNumberOrder.ValueData                                AS InvNumberOrder
           , COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate)   AS OperDatePartner


           , ObjectString_FromAddress.ValueData                                     AS PartnerAddress_From
           , ObjectString_ToAddress.ValueData                                       AS PartnerAddress_To

           , OH_JuridicalDetails_To.FullName                                        AS JuridicalName_To
           , OH_JuridicalDetails_To.JuridicalAddress                                AS JuridicalAddress_To

           , OH_JuridicalDetails_From.FullName                                      AS JuridicalName_From
           , OH_JuridicalDetails_From.JuridicalAddress                              AS JuridicalAddress_From

           , MovementItem.Id                                                        AS Id
           , Object_Goods.ObjectCode                                                AS GoodsCode
--           , Object_GoodsGroup.ValueData     AS GoodsGroupName
           , (CASE WHEN tmpObject_GoodsPropertyValue.Name <> '' THEN tmpObject_GoodsPropertyValue.Name WHEN tmpObject_GoodsPropertyValue_basis.Name <> '' THEN tmpObject_GoodsPropertyValue_basis.Name ELSE Object_Goods.ValueData END || CASE WHEN COALESCE (Object_GoodsKind.Id, zc_Enum_GoodsKind_Main()) = zc_Enum_GoodsKind_Main() THEN '' ELSE ' ' || Object_GoodsKind.ValueData END) :: TVarChar AS GoodsName
           , CASE WHEN tmpObject_GoodsPropertyValue.Name <> '' THEN tmpObject_GoodsPropertyValue.Name WHEN tmpObject_GoodsPropertyValue_basis.Name <> '' THEN tmpObject_GoodsPropertyValue_basis.Name ELSE Object_Goods.ValueData END AS GoodsName_two
           , COALESCE (tmpObject_GoodsPropertyValue.Name, '')                                   AS GoodsName_Juridical
           , Object_GoodsKind.ValueData                                                         AS GoodsKindName
--           , Object_Measure.ValueData                                                           AS MeasureName

           , COALESCE (tmpObject_GoodsPropertyValue.GroupName, '')                              AS GroupName_Juridical
           , COALESCE (tmpObject_GoodsPropertyValue.Amount, 0)                                  AS AmountInPack_Juridical
           , COALESCE (tmpObject_GoodsPropertyValueGroup.Article, COALESCE (tmpObject_GoodsPropertyValue.Article, '')) AS Article_Juridical
           , COALESCE (tmpObject_GoodsPropertyValue.BarCode, '')                                AS BarCode_Juridical

           , MovementItem.Amount                                                                AS Amount
           , COALESCE (MIFloat_AmountPartner.ValueData, 0)                                      AS AmountPartner
           , COALESCE (MIFloat_BoxCount.ValueData, 0)                                           AS Box_Count
           , COALESCE (OF_Box_Weight.ValueData, 0) * COALESCE (MIFloat_BoxCount.ValueData, 0)   AS Box_Weight
           , CAST ((COALESCE (MIFloat_AmountPartner.ValueData, 0) * (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END )) AS TFloat) AS Netto_Weight
           , CAST ((COALESCE (MIFloat_AmountPartner.ValueData, 0) * (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END )) + (COALESCE (OF_Box_Weight.ValueData, 0) * COALESCE (MIFloat_BoxCount.ValueData, 0)) AS TFloat) AS Brutto_Weight

           , tmpGoodsQualityParams.Value17
           , tmpGoodsQualityParams.Value1
           , tmpGoodsQualityParams.Value2
           , tmpGoodsQualityParams.Value3
           , tmpGoodsQualityParams.Value4
           , tmpGoodsQualityParams.Value5
           , tmpGoodsQualityParams.Value6
           , tmpGoodsQualityParams.Value7
           , tmpGoodsQualityParams.Value8
           , tmpGoodsQualityParams.Value9
           , tmpGoodsQualityParams.Value10
           , tmpGoodsQualityParams.QualityName
           , tmpGoodsQualityParams.QualityComment

           , tmpMovement_GoodsQuality.InvNumber AS InvNumberQuality
           , tmpMovement_GoodsQuality.OperDate
           , tmpMovement_GoodsQuality.OperDateCertificate
           , tmpMovement_GoodsQuality.CertificateNumber
           , tmpMovement_GoodsQuality.CertificateSeries
           , tmpMovement_GoodsQuality.CertificateSeriesNumber
           , tmpMovement_GoodsQuality.ExpertPrior
           , tmpMovement_GoodsQuality.ExpertLast
           , tmpMovement_GoodsQuality.QualityNumber
           , tmpMovement_GoodsQuality.Comment
           , tmpMovement_GoodsQuality.QualityId
           , tmpMovement_GoodsQuality.QualityName
           , tmpMovement_GoodsQuality.ReportType

           , CAST (CASE WHEN Object_Measure.Id = zc_Measure_Kg() THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) ELSE 0 END AS TFloat) AS Amount5
           , 0                                                                                                                            AS Amount9
           , CAST (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) ELSE 0 END AS TFloat) AS Amount13

       FROM Movement

            INNER JOIN MovementItem ON MovementItem.MovementId =  Movement.Id
                                   AND MovementItem.DescId     = zc_MI_Master()
                                   AND MovementItem.isErased   = FALSE
                                   AND MovementItem.Amount <> 0
--            +++ качественное сюда выбрать и подвязать по гудс-ид для начала
--*****************************************************************************************************************
            LEFT JOIN tmpGoodsQualityParams ON tmpGoodsQualityParams.GoodsId = MovementItem.ObjectId
--*****************************************************************************************************************
   --         INNER JOIN tmpMovement_GoodsQuality ON tmpMovement_GoodsQuality.QualityId = tmpGoodsQualityParams.QualityId
            LEFT JOIN tmpMovement_GoodsQuality ON tmpMovement_GoodsQuality.QualityId = tmpGoodsQualityParams.QualityId             -- ONLY FOR TEST!!!!!!

            LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                        ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
            LEFT JOIN MovementItemFloat AS MIFloat_BoxCount
                                        ON MIFloat_BoxCount.MovementItemId = MovementItem.Id
                                       AND MIFloat_BoxCount.DescId = zc_MIFloat_BoxCount()
            LEFT JOIN MovementItemLinkObject AS MILinkObject_Box
                                             ON MILinkObject_Box.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Box.DescId = zc_MILinkObject_Box()
            LEFT JOIN ObjectFloat AS OF_Box_Weight
                                  ON OF_Box_Weight.ObjectId = MILinkObject_Box.ObjectId
                                 AND OF_Box_Weight.DescId = zc_ObjectFloat_Box_Weight()

            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                  ON ObjectFloat_Weight.ObjectId = MovementItem.ObjectId
                                 AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()


            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()

            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

            LEFT JOIN tmpObject_GoodsPropertyValue ON tmpObject_GoodsPropertyValue.GoodsId = MovementItem.ObjectId
                                                  AND tmpObject_GoodsPropertyValue.GoodsKindId = COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
            LEFT JOIN tmpObject_GoodsPropertyValueGroup ON tmpObject_GoodsPropertyValueGroup.GoodsId = MovementItem.ObjectId
                                                       AND tmpObject_GoodsPropertyValue.GoodsId IS NULL
            LEFT JOIN tmpObject_GoodsPropertyValue_basis ON tmpObject_GoodsPropertyValue_basis.GoodsId = MovementItem.ObjectId
                                                        AND tmpObject_GoodsPropertyValue_basis.GoodsKindId = COALESCE (MILinkObject_GoodsKind.ObjectId, 0)

-- MOVEMENT


            LEFT JOIN MovementFloat AS MovementFloat_TotalCountKg
                                    ON MovementFloat_TotalCountKg.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCountKg.DescId = zc_MovementFloat_TotalCountKg()

            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId =  Movement.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
--            LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_From.Id

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId IN ( zc_MovementLinkObject_Contract(), zc_MovementLinkObject_ContractTo())
            LEFT JOIN Object_Contract_View AS View_Contract ON View_Contract.ContractId = MovementLinkObject_Contract.ObjectId


            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                 ON ObjectLink_Partner_Juridical.ObjectId = Object_To.Id
                                AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()


            LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_To
                                                                ON OH_JuridicalDetails_To.JuridicalId = COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, Object_To.Id)
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) >= OH_JuridicalDetails_To.StartDate
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) <  OH_JuridicalDetails_To.EndDate

            LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_From
                                                                ON OH_JuridicalDetails_From.JuridicalId = COALESCE (View_Contract.JuridicalBasisId, Object_From.Id)
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) >= OH_JuridicalDetails_From.StartDate
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) <  OH_JuridicalDetails_From.EndDate

            LEFT JOIN ObjectString AS ObjectString_FromAddress
                                   ON ObjectString_FromAddress.ObjectId = MovementLinkObject_From.ObjectId
                                  AND ObjectString_FromAddress.DescId = zc_ObjectString_Partner_Address()

            LEFT JOIN ObjectString AS ObjectString_ToAddress
                                   ON ObjectString_ToAddress.ObjectId = MovementLinkObject_To.ObjectId
                                  AND ObjectString_ToAddress.DescId = zc_ObjectString_Partner_Address()
      WHERE Movement.Id = inMovementId

      ORDER BY MovementItem.MovementId, MovementItem.Id
--       ORDER BY MovementString_InvNumberPartner.ValueData
      ;
     RETURN NEXT Cursor2;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_GoodsQuality_Print (Integer,TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 11.02.15                                                       * all
*/

-- тест
/*
BEGIN;
 SELECT * FROM gpSelect_Movement_GoodsQuality_Print (inMovementId := 130359, inSession:= '5');
COMMIT;
*/

