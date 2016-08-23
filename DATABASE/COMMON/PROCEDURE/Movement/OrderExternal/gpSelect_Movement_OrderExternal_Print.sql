-- Function: gpSelect_Movement_OrderExternal_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_OrderExternal_Print (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_OrderExternal_Print(
    IN inMovementId        Integer  , -- ���� ���������
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;

    DECLARE vbGoodsPropertyId Integer;
    DECLARE vbGoodsPropertyId_basis Integer;

    DECLARE vbDescId Integer;
    DECLARE vbStatusId Integer;
    DECLARE vbPriceWithVAT Boolean;
    DECLARE vbVATPercent TFloat;
    DECLARE vbDiscountPercent TFloat;
    DECLARE vbExtraChargesPercent TFloat;
    DECLARE vbContractId Integer;
    DECLARE vbRetailId Integer;
    DECLARE vbFromId Integer;
    DECLARE vbIsOrderByLine Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderExternal());
     vbUserId:= lpGetUserBySession (inSession);


     -- ��������� �� ���������
     SELECT Movement.DescId
          , Movement.StatusId
          , COALESCE (MovementBoolean_PriceWithVAT.ValueData, TRUE) AS PriceWithVAT
          , COALESCE (MovementFloat_VATPercent.ValueData, 0)        AS VATPercent
          , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) < 0 THEN -MovementFloat_ChangePercent.ValueData ELSE 0 END AS DiscountPercent
          , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) > 0 THEN MovementFloat_ChangePercent.ValueData ELSE 0 END  AS ExtraChargesPercent
          , zfCalc_GoodsPropertyId (MovementLinkObject_Contract.ObjectId, COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MovementLinkObject_From.ObjectId), MovementLinkObject_From.ObjectId) AS GoodsPropertyId
          , zfCalc_GoodsPropertyId (0, zc_Juridical_Basis(), 0)      AS GoodsPropertyId_basis
          , COALESCE (MovementLinkObject_Contract.ObjectId, 0)      AS ContractId
          , COALESCE (MovementLinkObject_Retail.ObjectId, 0)        AS RetailId
          , COALESCE (MovementLinkObject_From.ObjectId, 0)          AS FromId
          -- , ObjectLink_Juridical_GoodsProperty.ChildObjectId AS GoodsPropertyId
          -- , ObjectLink_JuridicalBasis_GoodsProperty.ChildObjectId AS GoodsPropertyId_basis
          , CASE WHEN Movement.AccessKeyId = zc_Enum_Process_AccessKey_DocumentKiev() THEN TRUE ELSE FALSE END AS isOrderByLine
            INTO vbDescId, vbStatusId, vbPriceWithVAT, vbVATPercent, vbDiscountPercent, vbExtraChargesPercent, vbGoodsPropertyId, vbGoodsPropertyId_basis, vbContractId, vbRetailId, vbFromId, vbIsOrderByLine
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
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Retail
                                       ON MovementLinkObject_Retail.MovementId = Movement.Id
                                      AND MovementLinkObject_Retail.DescId = zc_MovementLinkObject_Retail()
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
                              AND ObjectLink_Juridical_GoodsProperty.DescId = zc_ObjectLink_Juridical_GoodsProperty()
          LEFT JOIN ObjectLink AS ObjectLink_JuridicalBasis_GoodsProperty
                               ON ObjectLink_JuridicalBasis_GoodsProperty.ObjectId = zc_Juridical_Basis()
                              AND ObjectLink_JuridicalBasis_GoodsProperty.DescId = zc_ObjectLink_Juridical_GoodsProperty()
                              AND ObjectLink_Juridical_GoodsProperty.ChildObjectId IS NULL*/
     WHERE Movement.Id = inMovementId;


     -- ����� ������ ��������
     IF COALESCE (vbStatusId, 0) <> zc_Enum_Status_Complete()
     THEN
         IF vbStatusId = zc_Enum_Status_Erased()
         THEN
             RAISE EXCEPTION '������.�������� <%> � <%> �� <%> ������.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
         END IF;
         IF vbStatusId = zc_Enum_Status_UnComplete()
         THEN
             RAISE EXCEPTION '������.�������� <%> � <%> �� <%> �� ��������.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
         END IF;
         -- ��� ��� �������� ������
         RAISE EXCEPTION '������.�������� <%>.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId);
     END IF;


     --
     OPEN Cursor1 FOR
       WITH tmpMovement AS (SELECT Movement_find.Id AS MovementId
                            FROM (SELECT inMovementId AS MovementId WHERE vbRetailId <> 0) AS tmpMovement
                                 INNER JOIN Movement ON Movement.Id = tmpMovement.MovementId
                                 INNER JOIN Movement AS Movement_find ON Movement_find.OperDate = Movement.OperDate
                                                                     AND Movement_find.DescId   = Movement.DescId
                                                                     AND Movement_find.StatusId = zc_Enum_Status_Complete()
                                 INNER JOIN MovementLinkObject AS MovementLinkObject_From_find
                                                               ON MovementLinkObject_From_find.MovementId = Movement_find.Id
                                                              AND MovementLinkObject_From_find.DescId = zc_MovementLinkObject_From()
                                                              AND MovementLinkObject_From_find.ObjectId = vbFromId
                                 INNER JOIN MovementLinkObject AS MovementLinkObject_Retail_find
                                                               ON MovementLinkObject_Retail_find.MovementId = Movement_find.Id
                                                              AND MovementLinkObject_Retail_find.DescId = zc_MovementLinkObject_Retail()
                                                              AND MovementLinkObject_Retail_find.ObjectId = vbRetailId
                           UNION
                            SELECT inMovementId AS MovementId WHERE vbRetailId = 0
                           )
      SELECT Movement.Id                                AS Id
           , zfFormat_BarCode (zc_BarCodePref_Movement(), Movement.Id) AS IdBarCode
           , tmpMovement_total.InvNumber :: TVarChar    AS InvNumber
           , Movement.OperDate                          AS OperDate
           , MovementDate_OperDatePartner.ValueData     AS OperDatePartner
           , CASE WHEN MovementDate_OperDateMark.ValueData >= Movement.OperDate THEN '���� ���������� : ' || (DATE (MovementDate_OperDateMark.ValueData) :: TVarChar) ELSE '' END AS OperDateMark

           , MovementString_InvNumberPartner.ValueData  AS InvNumberPartner
           , MovementString_Comment.ValueData           AS Comment

           , vbPriceWithVAT                             AS PriceWithVAT
           , vbVATPercent                               AS VATPercent
           , vbExtraChargesPercent - vbDiscountPercent  AS ChangePercent

           , tmpMovement_total.TotalCount
           , tmpMovement_total.TotalCountKg
           , tmpMovement_total.TotalCountSh

           , tmpMovement_total.TotalSummMVAT
           , tmpMovement_total.TotalSummPVAT
           , tmpMovement_total.SummVAT
           , tmpMovement_total.TotalSumm

           , Object_Partner.ValueData                   AS PartnerName
           , Object_From.ObjectCode                     AS FromCode
           , Object_From.ValueData                      AS FromName
           , Object_To.ValueData               		AS ToName
           , Object_PaidKind.ValueData         		AS PaidKindName
           , View_Contract.InvNumber        		AS ContractName
           , View_Contract.ContractTagName              AS ContractTagName

           , OH_JuridicalDetails_From.FullName          AS JuridicalName_From
           , OH_JuridicalDetails_From.JuridicalAddress  AS JuridicalAddress_From
           , OH_JuridicalDetails_From.OKPO              AS OKPO_From

           , OH_JuridicalDetails_To.FullName            AS JuridicalName_To
           , OH_JuridicalDetails_To.JuridicalAddress    AS JuridicalAddress_To
           , OH_JuridicalDetails_To.OKPO                AS OKPO_To

           , Object_Personal.ValueData                  AS PersonalName
           , Object_Route.ValueData                     AS RouteName
           , Object_RouteSorting.ValueData              AS RouteSortingName

           , vbIsOrderByLine                            AS isOrderByLine

       FROM (SELECT inMovementId AS MovementId
                  , STRING_AGG (COALESCE (Movement.InvNumber, '*'), '; ')           AS InvNumber
                  , SUM (COALESCE (MovementFloat_TotalCount.ValueData, 0))         AS TotalCount
                  , SUM (COALESCE (MovementFloat_TotalCountKg.ValueData, 0))       AS TotalCountKg
                  , SUM (COALESCE (MovementFloat_TotalCountSh.ValueData, 0))       AS TotalCountSh

                  , SUM (COALESCE (MovementFloat_TotalSummMVAT.ValueData, 0))      AS TotalSummMVAT
                  , SUM (COALESCE (MovementFloat_TotalSummPVAT.ValueData, 0))      AS TotalSummPVAT
                  , SUM (COALESCE (MovementFloat_TotalSummPVAT.ValueData) - COALESCE (MovementFloat_TotalSummMVAT.ValueData, 0)) AS SummVAT
                  , SUM (COALESCE (MovementFloat_TotalSumm.ValueData, 0))          AS TotalSumm
             FROM tmpMovement
                  LEFT JOIN Movement ON Movement.Id =  tmpMovement.MovementId
                  LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                          ON MovementFloat_TotalCount.MovementId =  tmpMovement.MovementId
                                         AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()
                  LEFT JOIN MovementFloat AS MovementFloat_TotalCountKg
                                          ON MovementFloat_TotalCountKg.MovementId =  tmpMovement.MovementId
                                         AND MovementFloat_TotalCountKg.DescId = zc_MovementFloat_TotalCountKg()
                  LEFT JOIN MovementFloat AS MovementFloat_TotalCountSh
                                          ON MovementFloat_TotalCountSh.MovementId =  tmpMovement.MovementId
                                         AND MovementFloat_TotalCountSh.DescId = zc_MovementFloat_TotalCountSh()

                  LEFT JOIN MovementFloat AS MovementFloat_TotalSummMVAT
                                          ON MovementFloat_TotalSummMVAT.MovementId =  tmpMovement.MovementId
                                         AND MovementFloat_TotalSummMVAT.DescId = zc_MovementFloat_TotalSummMVAT()
                  LEFT JOIN MovementFloat AS MovementFloat_TotalSummPVAT
                                          ON MovementFloat_TotalSummPVAT.MovementId =  tmpMovement.MovementId
                                         AND MovementFloat_TotalSummPVAT.DescId = zc_MovementFloat_TotalSummPVAT()
                  LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                          ON MovementFloat_TotalSumm.MovementId =  tmpMovement.MovementId
                                         AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
            ) AS tmpMovement_total

            LEFT JOIN Movement ON Movement.Id = tmpMovement_total.MovementId
                             
            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
            LEFT JOIN MovementDate AS MovementDate_OperDateMark
                                   ON MovementDate_OperDateMark.MovementId =  Movement.Id
                                  AND MovementDate_OperDateMark.DescId = zc_MovementDate_OperDateMark()
            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId =  Movement.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                         ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                        AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

            /*LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId IN (zc_MovementLinkObject_Contract(), zc_MovementLinkObject_ContractFrom())*/
            LEFT JOIN Object_Contract_View AS View_Contract ON View_Contract.ContractId = vbContractId -- MovementLinkObject_Contract.ObjectId

            -- �� ����������� ������� ��.����
            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                 ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                                AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()

            LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_From
                                                                ON OH_JuridicalDetails_From.JuridicalId = ObjectLink_Partner_Juridical.ChildObjectId
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) >= OH_JuridicalDetails_From.StartDate
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) <  OH_JuridicalDetails_From.EndDate

            LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_To
                                                                ON OH_JuridicalDetails_To.JuridicalId = View_Contract.JuridicalBasisId
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) >= OH_JuridicalDetails_To.StartDate
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) <  OH_JuridicalDetails_To.EndDate

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Personal
                                         ON MovementLinkObject_Personal.MovementId = Movement.Id
                                        AND MovementLinkObject_Personal.DescId = zc_MovementLinkObject_Personal()
            LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = MovementLinkObject_Personal.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Route
                                         ON MovementLinkObject_Route.MovementId = Movement.Id
                                        AND MovementLinkObject_Route.DescId = zc_MovementLinkObject_Route()
            LEFT JOIN Object AS Object_Route ON Object_Route.Id = MovementLinkObject_Route.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_RouteSorting
                                         ON MovementLinkObject_RouteSorting.MovementId = Movement.Id
                                        AND MovementLinkObject_RouteSorting.DescId = zc_MovementLinkObject_RouteSorting()
            LEFT JOIN Object AS Object_RouteSorting ON Object_RouteSorting.Id = MovementLinkObject_RouteSorting.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                         ON MovementLinkObject_Partner.MovementId = Movement.Id
                                        AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
                                        AND vbRetailId = 0
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = COALESCE (MovementLinkObject_Partner.ObjectId, vbRetailId)
      ;
    RETURN NEXT Cursor1;

    OPEN Cursor2 FOR
     WITH tmpObject_GoodsPropertyValue AS
       (SELECT ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
             , ObjectLink_GoodsPropertyValue_Goods.ChildObjectId      AS GoodsId
             , COALESCE (ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId, 0)  AS GoodsKindId
             , Object_GoodsPropertyValue.ValueData  AS Name
             , ObjectFloat_Amount.ValueData         AS Amount
             , ObjectString_BarCode.ValueData       AS BarCode
             , ObjectString_Article.ValueData       AS Article
             , ObjectString_BarCodeGLN.ValueData    AS BarCodeGLN
             , ObjectString_ArticleGLN.ValueData    AS ArticleGLN
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

             LEFT JOIN ObjectString AS ObjectString_BarCodeGLN
                                    ON ObjectString_BarCodeGLN.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                   AND ObjectString_BarCodeGLN.DescId = zc_ObjectString_GoodsPropertyValue_BarCodeGLN()
             LEFT JOIN ObjectString AS ObjectString_ArticleGLN
                                    ON ObjectString_ArticleGLN.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                   AND ObjectString_ArticleGLN.DescId = zc_ObjectString_GoodsPropertyValue_ArticleGLN()

             LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                  ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                 AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
             LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                  ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                 AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
        WHERE Object_GoodsPropertyValue.ValueData  <> ''
           OR ObjectString_BarCode.ValueData       <> ''
           OR ObjectString_Article.ValueData       <> ''
           OR ObjectString_BarCodeGLN.ValueData    <> ''
           OR ObjectString_ArticleGLN.ValueData    <> ''
       )
     , tmpObject_GoodsPropertyValueGroup AS
       (SELECT tmpObject_GoodsPropertyValue.GoodsId
             , tmpObject_GoodsPropertyValue.Article
        FROM (SELECT MAX (tmpObject_GoodsPropertyValue.ObjectId) AS ObjectId, GoodsId FROM tmpObject_GoodsPropertyValue WHERE Article <> '' OR ArticleGLN <> '' GROUP BY GoodsId
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
             LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                  ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                 AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
             LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                  ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                 AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
       )
          , tmpMovement AS (SELECT Movement_find.Id AS MovementId
                            FROM (SELECT inMovementId AS MovementId WHERE vbRetailId <> 0) AS tmpMovement
                                 INNER JOIN Movement ON Movement.Id = tmpMovement.MovementId
                                 INNER JOIN Movement AS Movement_find ON Movement_find.OperDate = Movement.OperDate
                                                                     AND Movement_find.DescId   = Movement.DescId
                                                                     AND Movement_find.StatusId = zc_Enum_Status_Complete()
                                 INNER JOIN MovementLinkObject AS MovementLinkObject_From_find
                                                               ON MovementLinkObject_From_find.MovementId = Movement_find.Id
                                                              AND MovementLinkObject_From_find.DescId = zc_MovementLinkObject_From()
                                                              AND MovementLinkObject_From_find.ObjectId = vbFromId
                                 INNER JOIN MovementLinkObject AS MovementLinkObject_Retail_find
                                                               ON MovementLinkObject_Retail_find.MovementId = Movement_find.Id
                                                              AND MovementLinkObject_Retail_find.DescId = zc_MovementLinkObject_Retail()
                                                              AND MovementLinkObject_Retail_find.ObjectId = vbRetailId
                           UNION
                            SELECT inMovementId AS MovementId WHERE vbRetailId = 0
                           )
       SELECT
             CASE WHEN vbIsOrderByLine = TRUE THEN row_number() OVER (ORDER BY tmpMI.MovementItemId) ELSE 0 END :: Integer AS LineNum
           , zfFormat_BarCode (zc_BarCodePref_Object(), COALESCE (View_GoodsByGoodsKind.Id, Object_Goods.Id)) AS IdBarCode
           , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull
           , Object_GoodsGroup.ValueData                AS GoodsGroupName
           , Object_Goods.ObjectCode  			AS GoodsCode
           , Object_Goods.ValueData                     AS GoodsName
           , CASE WHEN tmpObject_GoodsPropertyValue.Name <> '' THEN tmpObject_GoodsPropertyValue.Name WHEN tmpObject_GoodsPropertyValue_basis.Name <> '' THEN tmpObject_GoodsPropertyValue_basis.Name ELSE Object_Goods.ValueData END AS GoodsName_two
           , Object_GoodsKind.ValueData      AS GoodsKindName
           , Object_Measure.ValueData        AS MeasureName

           , tmpMI.Amount                    AS Amount
           , tmpMI.AmountSecond              AS AmountSecond
           , tmpMI.Price                     AS Price
           , tmpMI.CountForPrice             AS CountForPrice

           , CASE WHEN vbPriceWithVAT = FALSE OR vbVATPercent = 0
                       -- ���� ���� ��� ��� ��� %��� = 0
                       THEN tmpMI.AmountSumm
                       -- ���� ���� � ���
                  ELSE CAST ((tmpMI.Summ / (1 + vbVATPercent / 100)) AS NUMERIC (16, 2))
             END AS SummMVAT
           , tmpMI.Summ AS SummPVAT

       FROM (SELECT tmpMI.MovementItemId
                  , tmpMI.GoodsId
                  , tmpMI.GoodsKindId
                  , tmpMI.Price
                  , tmpMI.CountForPrice
                  , tmpMI.Amount
                  , tmpMI.AmountSecond
                  , tmpMI.Summ
                  , CAST ((tmpMI.Amount + tmpMI.AmountSecond) * tmpMI.Price / CASE WHEN tmpMI.CountForPrice <> 0 THEN tmpMI.CountForPrice ELSE 1 END AS NUMERIC (16, 2)) AS AmountSumm
             FROM
            (SELECT MAX (MovementItem.Id) AS MovementItemId
                  , MovementItem.ObjectId AS GoodsId
                  , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                  , CASE WHEN vbDiscountPercent <> 0
                              THEN CAST ( (1 - vbDiscountPercent / 100) * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2))
                         WHEN vbExtraChargesPercent <> 0
                              THEN CAST ( (1 + vbExtraChargesPercent / 100) * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2))
                         ELSE COALESCE (MIFloat_Price.ValueData, 0)
                    END AS Price
                  , MIFloat_CountForPrice.ValueData AS CountForPrice
                  , SUM (MovementItem.Amount) AS Amount
                  , SUM (COALESCE (MIFloat_AmountSecond.ValueData, 0)) AS AmountSecond
                  , SUM (COALESCE (MIFloat_Summ.ValueData, 0)) AS Summ
             FROM tmpMovement
                  INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovement.MovementId
                                         AND MovementItem.DescId     = zc_MI_Master()
                                         AND MovementItem.isErased   = FALSE
                  LEFT JOIN MovementItemFloat AS MIFloat_Price
                                              ON MIFloat_Price.MovementItemId = MovementItem.Id
                                             AND MIFloat_Price.DescId = zc_MIFloat_Price()
                  LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                              ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                             AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
                  LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                              ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                             AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                  LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                              ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                             AND MIFloat_Summ.DescId = zc_MIFloat_Summ()

                  LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                   ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                  AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
             GROUP BY MovementItem.ObjectId
                    , MILinkObject_GoodsKind.ObjectId
                    , MIFloat_Price.ValueData
                    , MIFloat_CountForPrice.ValueData
            ) AS tmpMI
            ) AS tmpMI

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                 ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
            LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMI.GoodsKindId

            LEFT JOIN Object_GoodsByGoodsKind_View AS View_GoodsByGoodsKind ON View_GoodsByGoodsKind.GoodsId = Object_Goods.Id
                                                                           AND View_GoodsByGoodsKind.GoodsKindId = Object_GoodsKind.Id

            LEFT JOIN tmpObject_GoodsPropertyValue ON tmpObject_GoodsPropertyValue.GoodsId = tmpMI.GoodsId
                                                  AND tmpObject_GoodsPropertyValue.GoodsKindId = tmpMI.GoodsKindId
            LEFT JOIN tmpObject_GoodsPropertyValueGroup ON tmpObject_GoodsPropertyValueGroup.GoodsId = tmpMI.GoodsId
                                                       AND tmpObject_GoodsPropertyValue.GoodsId IS NULL
            LEFT JOIN tmpObject_GoodsPropertyValue_basis ON tmpObject_GoodsPropertyValue_basis.GoodsId = tmpMI.GoodsId
                                                        AND tmpObject_GoodsPropertyValue_basis.GoodsKindId = tmpMI.GoodsKindId

          LEFT JOIN ObjectString AS ObjectString_Goods_GroupNameFull
                                 ON ObjectString_Goods_GroupNameFull.ObjectId = tmpMI.GoodsId
                                AND ObjectString_Goods_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()

       WHERE tmpMI.Amount <> 0 OR tmpMI.AmountSecond <> 0
       -- ORDER BY ObjectString_Goods_GroupNameFull.ValueData, Object_Goods.ValueData, Object_GoodsKind.ValueData
       ;

    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_OrderExternal_Print (Integer,TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 02.11.14                                        *
*/

-- ����
-- SELECT * FROM gpSelect_Movement_OrderExternal_Print (inMovementId := 388160, inSession:= zfCalc_UserAdmin())
