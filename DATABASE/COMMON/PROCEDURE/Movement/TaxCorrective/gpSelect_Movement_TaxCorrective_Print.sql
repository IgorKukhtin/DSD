-- Function: gpSelect_Movement_TaxCorrective_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_TaxCorrective_Print (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_TaxCorrective_Print(
    IN inMovementId        Integer  , -- ���� ���������
    IN inisClientCopy      Boolean  , -- ����� ��� �������
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE vbMovementId_TaxCorrective Integer;
    DECLARE vbStatusId_TaxCorrective Integer;
    DECLARE vbIsLongUKTZED Boolean;

    DECLARE vbGoodsPropertyId Integer;
    DECLARE vbGoodsPropertyId_basis Integer;

    DECLARE vbNotNDSPayer_INN TVarChar;

    DECLARE vbOperDate_begin TDateTime;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Sale());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!�������!!!
     vbNotNDSPayer_INN := '100000000000';

     -- ������������ <��������� ��������> � ��� ���������
     SELECT COALESCE (tmpMovement.MovementId_TaxCorrective, 0) AS MovementId_TaxCorrective
          , Movement_TaxCorrective.StatusId                    AS StatusId_TaxCorrective
          , CASE WHEN MovementDate_DateRegistered.ValueData > Movement_TaxCorrective.OperDate THEN MovementDate_DateRegistered.ValueData ELSE Movement_TaxCorrective.OperDate END AS OperDate_begin
          , COALESCE (ObjectBoolean_isLongUKTZED.ValueData, TRUE)    AS isLongUKTZED

            INTO vbMovementId_TaxCorrective, vbStatusId_TaxCorrective, vbOperDate_begin, vbIsLongUKTZED
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
          LEFT JOIN MovementDate AS MovementDate_DateRegistered
                                 ON MovementDate_DateRegistered.MovementId = tmpMovement.MovementId_TaxCorrective
                                AND MovementDate_DateRegistered.DescId = zc_MovementDate_DateRegistered()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = tmpMovement.MovementId_TaxCorrective
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN ObjectBoolean AS ObjectBoolean_isLongUKTZED
                                  ON ObjectBoolean_isLongUKTZED.ObjectId = MovementLinkObject_From.ObjectId 
                                 AND ObjectBoolean_isLongUKTZED.DescId = zc_ObjectBoolean_Juridical_isLongUKTZED()
     ;
/* ���� �����, �.�. �������� ���� ���������� � ������������� ���������, ���� ��� �������� �������� - "����� ��������" ��� ������� ��� ���� ������-��������
     -- ����� ������ ��������
     IF COALESCE (vbMovementId_TaxCorrective, 0) = 0 OR COALESCE (vbStatusId_TaxCorrective, 0) <> zc_Enum_Status_Complete()
     THEN
         IF COALESCE (vbMovementId_TaxCorrective, 0) = 0
         THEN
             RAISE EXCEPTION '������.�������� <%> �� ������.', (SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_TaxCorrective());
         END IF;
         IF vbStatusId_TaxCorrective = zc_Enum_Status_Erased()
         THEN
             RAISE EXCEPTION '������.�������� <%> � <%> �� <%> ������.', (SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_TaxCorrective()), (SELECT ValueData FROM MovementString WHERE MovementId = vbMovementId_TaxCorrective AND DescId = zc_MovementString_InvNumberPartner()), (SELECT DATE (OperDate) FROM Movement WHERE Id = vbMovementId_TaxCorrective);
         END IF;
         IF vbStatusId_TaxCorrective = zc_Enum_Status_UnComplete()
         THEN
             RAISE EXCEPTION '������.�������� <%> � <%> �� <%> �� ��������.', (SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_TaxCorrective()), (SELECT ValueData FROM MovementString WHERE MovementId = vbMovementId_TaxCorrective AND DescId = zc_MovementString_InvNumberPartner()), (SELECT DATE (OperDate) FROM Movement WHERE Id = vbMovementId_TaxCorrective);
         END IF;
         -- ��� ��� �������� ������
         RAISE EXCEPTION '������.�������� <%>.', (SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_TaxCorrective());
     END IF;
*/

     -- ������������ ��������
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
     -- ������������ ��������
     vbGoodsPropertyId_basis:= zfCalc_GoodsPropertyId (0, zc_Juridical_Basis(), 0); -- (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = zc_Juridical_Basis() AND DescId = zc_ObjectLink_Juridical_GoodsProperty());


     -- ������ �� ���� �������������� + ���������: ��������� + �������� �����
     OPEN Cursor1 FOR
     WITH tmpMovement AS
          (SELECT Movement_find.Id
                , MovementBoolean_isPartner.ValueData AS isPartner
           FROM Movement
                LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Master
                                               ON MovementLinkMovement_Master.MovementId = Movement.Id
                                              AND MovementLinkMovement_Master.DescId = zc_MovementLinkMovement_Master()
                -- �������� ������ ��� �������������
                LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Master_find
                                               ON MovementLinkMovement_Master_find.MovementChildId = MovementLinkMovement_Master.MovementChildId
                                              AND MovementLinkMovement_Master_find.DescId = zc_MovementLinkMovement_Master()
                INNER JOIN Movement AS Movement_find ON Movement_find.Id  = COALESCE (MovementLinkMovement_Master_find.MovementId, Movement.Id)
                                                    AND Movement_find.StatusId = zc_Enum_Status_Complete()
                LEFT JOIN MovementBoolean AS MovementBoolean_isPartner
                                          ON MovementBoolean_isPartner.MovementId = MovementLinkMovement_Master.MovementChildId
                                         AND MovementBoolean_isPartner.DescId = zc_MovementBoolean_isPartner()
                
           WHERE Movement.Id = inMovementId
             AND Movement.DescId = zc_Movement_TaxCorrective()
          UNION
           SELECT MovementLinkMovement_Master.MovementId AS Id
                , MovementBoolean_isPartner.ValueData    AS isPartner
           FROM Movement
                INNER JOIN MovementLinkMovement AS MovementLinkMovement_Master
                                                ON MovementLinkMovement_Master.MovementChildId = Movement.Id
                                               AND MovementLinkMovement_Master.DescId = zc_MovementLinkMovement_Master()
                INNER JOIN Movement AS Movement_Master ON Movement_Master.Id  = MovementLinkMovement_Master.MovementId
                                                      AND Movement_Master.StatusId = zc_Enum_Status_Complete()
                LEFT JOIN MovementBoolean AS MovementBoolean_isPartner
                                          ON MovementBoolean_isPartner.MovementId = Movement.Id
                                         AND MovementBoolean_isPartner.DescId = zc_MovementBoolean_isPartner()   

           WHERE Movement.Id = inMovementId
             AND Movement.DescId IN (zc_Movement_ReturnIn(), zc_Movement_TransferDebtIn(), zc_Movement_PriceCorrective())
          )

    , tmpMI AS
       (SELECT MovementItem.Id                        AS Id
             , MovementItem.MovementId                AS MovementId
             , MovementItem.ObjectId                  AS GoodsId
             , MovementItem.Amount                    AS Amount
             , MIFloat_Price.ValueData                AS Price
             , MIFloat_CountForPrice.ValueData        AS CountForPrice
             , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
             , COALESCE (MIBoolean_isAuto.ValueData, TRUE)   AS isAuto
             , COALESCE (MIFloat_NPP.ValueData, 0)    AS NPP
             , ObjectLink_GoodsGroup.ChildObjectId    AS GoodsGroupId
             , tmpMovement.isPartner
        FROM tmpMovement
             INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovement.Id
                                    AND MovementItem.DescId     = zc_MI_Master()
                                    AND MovementItem.isErased   = FALSE
                                    AND MovementItem.Amount     <> 0
             
             LEFT JOIN MovementItemFloat AS MIFloat_NPP
                                         ON MIFloat_NPP.MovementItemId = MovementItem.Id
                                        AND MIFloat_NPP.DescId = zc_MIFloat_NPP()
             LEFT JOIN MovementItemBoolean AS MIBoolean_isAuto
                                           ON MIBoolean_isAuto.MovementItemId = MovementItem.Id
                                          AND MIBoolean_isAuto.DescId = zc_MIBoolean_isAuto()

             LEFT JOIN MovementItemFloat AS MIFloat_Price
                                         ON MIFloat_Price.MovementItemId = MovementItem.Id
                                        AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                        -- AND MIFloat_Price.ValueData <> 0
             LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                         ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                        AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                              ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                             AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
             LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup
                                  ON ObjectLink_GoodsGroup.ObjectId = MovementItem.ObjectId
                                 AND ObjectLink_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
       )
    , tmpGoods     AS (SELECT DISTINCT tmpMI.GoodsId FROM tmpMI)
    , tmpUKTZED    AS (SELECT tmp.GoodsGroupId, lfGet_Object_GoodsGroup_CodeUKTZED (tmp.GoodsGroupId) AS CodeUKTZED FROM (SELECT DISTINCT tmpMI.GoodsGroupId FROM tmpMI) AS tmp)
    , tmpTaxImport AS (SELECT tmp.GoodsGroupId, lfGet_Object_GoodsGroup_TaxImport (tmp.GoodsGroupId) AS TaxImport FROM (SELECT DISTINCT tmpMI.GoodsGroupId FROM tmpMI) AS tmp)
    , tmpDKPP      AS (SELECT tmp.GoodsGroupId, lfGet_Object_GoodsGroup_DKPP (tmp.GoodsGroupId) AS DKPP FROM (SELECT DISTINCT tmpMI.GoodsGroupId FROM tmpMI) AS tmp)
    , tmpTaxAction AS (SELECT tmp.GoodsGroupId, lfGet_Object_GoodsGroup_TaxAction (tmp.GoodsGroupId) AS TaxAction FROM (SELECT DISTINCT tmpMI.GoodsGroupId FROM tmpMI) AS tmp)

    , tmpObject_GoodsPropertyValue AS
       (SELECT ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
             , ObjectLink_GoodsPropertyValue_Goods.ChildObjectId      AS GoodsId
             , COALESCE (ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId, 0)  AS GoodsKindId
             , Object_GoodsPropertyValue.ValueData  AS Name
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

             INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                   ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                  AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
             INNER JOIN tmpGoods ON tmpGoods.GoodsId = ObjectLink_GoodsPropertyValue_Goods.ChildObjectId
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
             , tmpObject_GoodsPropertyValue.ArticleGLN
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
             INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                   ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                  AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
             INNER JOIN tmpGoods ON tmpGoods.GoodsId = ObjectLink_GoodsPropertyValue_Goods.ChildObjectId
             LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                  ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                 AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
       )
  , tmpMITax AS (SELECT * FROM lpSelect_TaxFromTaxCorrective ((SELECT MLM.MovementChildId FROM MovementLinkMovement AS MLM WHERE MLM.MovementId = inMovementId AND MLM.DescId = zc_MovementLinkMovement_Child())))

      -- ���������
      SELECT inMovementId                                                   AS inMovementId
           , Movement.Id			                            AS MovementId
           , Movement.InvNumber			                            AS InvNumber
           , Movement.OperDate				                    AS OperDate
           -- , 'J1201006'::TVarChar                                           AS CHARCODE
           , CASE WHEN vbOperDate_begin  < '01.04.2016' THEN 'J1201207'
                  WHEN Movement.OperDate < '01.03.2017' THEN 'J1201208'
                  ELSE 'J1201209'
             END ::TVarChar AS CHARCODE
           -- , '������ �.�.'::TVarChar                                        AS N10
           , CASE WHEN Object_PersonalSigning.PersonalName <> '' 
                  THEN zfConvert_FIO (Object_PersonalSigning.PersonalName, 1)
                  ELSE CASE WHEN Object_PersonalBookkeeper_View.PersonalName <> '' 
                            THEN zfConvert_FIO (Object_PersonalBookkeeper_View.PersonalName, 1) 
                            ELSE '����� �.�.' 
                       END
             END                                                :: TVarChar AS N10
           -- , '�.�. �������'::TVarChar                                        AS N10
           , '������ � ��������� �������'::TVarChar                         AS N9
           , CASE WHEN MovementLinkObject_DocumentTaxKind.ObjectId IN (zc_Enum_DocumentTaxKind_CorrectivePrice(), zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical())
                       THEN '��i�� �i��'
                  WHEN MovementBoolean_isCopy.ValueData = TRUE
                       THEN '����������� �������'
                  WHEN tmpMI.isPartner = TRUE
                       THEN '�����I�'
                  ELSE '����������'
             END :: TVarChar AS KindName
           , MovementBoolean_PriceWithVAT.ValueData                         AS PriceWithVAT
           , MovementFloat_VATPercent.ValueData                             AS VATPercent
           , CAST (REPEAT (' ', 7 - LENGTH (MovementString_InvNumberPartner.ValueData)) || MovementString_InvNumberPartner.ValueData AS TVarChar) AS InvNumberPartner

           , CAST (COALESCE (MovementFloat_TotalSummPVAT.ValueData, 0) - COALESCE (MovementFloat_TotalSummMVAT.ValueData, 0) AS TFloat) AS TotalSummVAT
           , MovementFloat_TotalSummMVAT.ValueData                          AS TotalSummMVAT
           , MovementFloat_TotalSummPVAT.ValueData                          AS TotalSummPVAT
           , MovementFloat_TotalSumm.ValueData                              AS TotalSumm

           , View_Contract.InvNumber         		                    AS ContractName
           , ObjectDate_Signing.ValueData                                   AS ContractSigningDate
           , View_Contract.ContractKindName                                 AS ContractKind

           , CAST (REPEAT (' ', 7 - LENGTH (MS_DocumentChild_InvNumberPartner.ValueData)) || MS_DocumentChild_InvNumberPartner.ValueData AS TVarChar) AS InvNumber_Child
           , Movement_child.OperDate                                        AS OperDate_Child

           , CASE WHEN inisClientCopy=TRUE
                  THEN 'X' ELSE '' END                                      AS CopyForClient
           , CASE WHEN inisClientCopy=TRUE
                  THEN '' ELSE 'X' END                                      AS CopyForUs

           , Movement_child.Id       AS x11
           , Movement_child.OperDate AS x12
           , '51' ::TVarChar         AS PZOB           -- ���� ��� �����
           , vbOperDate_begin        AS OperDate_begin -- ���� ��� �����

           , CASE WHEN Movement.OperDate < '01.01.2015' AND (COALESCE (MovementFloat_TotalSummPVAT.ValueData, 0) - COALESCE (MovementFloat_TotalSummMVAT.ValueData, 0)) > 10000
                  THEN TRUE
                  WHEN Movement.OperDate >= '01.01.2015' AND Movement_child.OperDate >= '01.01.2015' AND OH_JuridicalDetails_From.INN <> vbNotNDSPayer_INN
                       AND COALESCE (MovementFloat_TotalSummPVAT.ValueData, 0) >= 0
                  THEN TRUE
                  ELSE FALSE
             END :: Boolean AS isERPN -- ϳ����� ��������� � ���� �������� !!!��� ����� ��� ����� �� 01.04.2016!!!

           , CASE WHEN vbOperDate_begin >= '01.04.2016' AND OH_JuridicalDetails_From.INN <> vbNotNDSPayer_INN
                       AND COALESCE (MovementFloat_TotalSummPVAT.ValueData, 0) < 0
                       THEN 'X'
                  WHEN vbOperDate_begin >= '01.04.2016' AND OH_JuridicalDetails_From.INN = vbNotNDSPayer_INN
                       THEN 'X'
                  WHEN vbOperDate_begin >= '01.04.2016' 
                        THEN ''
                  WHEN Movement.OperDate < '01.01.2015' AND (COALESCE (MovementFloat_TotalSummPVAT.ValueData, 0) - COALESCE (MovementFloat_TotalSummMVAT.ValueData, 0)) > 10000
                       THEN 'X'
                  WHEN Movement.OperDate >= '01.01.2015' AND Movement_child.OperDate >= '01.01.2015' AND OH_JuridicalDetails_From.INN <> vbNotNDSPayer_INN
                       THEN 'X'
                  ELSE ''
             END :: TVarChar AS ERPN -- ϳ����� ��������� � ���� �������������� (���������)

           , CASE WHEN OH_JuridicalDetails_From.INN <> vbNotNDSPayer_INN AND Movement_child.OperDate >= '01.02.2015'
                  THEN CASE WHEN COALESCE (MovementFloat_TotalSummPVAT.ValueData, 0) < 0 THEN '' ELSE 'X' END
                  ELSE ''
             END :: TVarChar AS ERPN2 -- ϳ����� ��������� � ���� ��������

           , CASE WHEN OH_JuridicalDetails_From.INN = vbNotNDSPayer_INN
                  THEN 'X' ELSE '' END                                      AS NotNDSPayer
           , CASE WHEN OH_JuridicalDetails_From.INN = vbNotNDSPayer_INN
                  THEN TRUE ELSE FALSE END :: Boolean                       AS isNotNDSPayer
           , CASE WHEN OH_JuridicalDetails_From.INN = vbNotNDSPayer_INN
                  THEN '0' ELSE '' END                                      AS NotNDSPayerC1
           , CASE WHEN OH_JuridicalDetails_From.INN = vbNotNDSPayer_INN
                  THEN '2' ELSE '' END                                      AS NotNDSPayerC2

           , ObjectString_FromAddress.ValueData                             AS PartnerAddress_From

           , OH_JuridicalDetails_To.FullName                                AS JuridicalName_To
           , OH_JuridicalDetails_To.JuridicalAddress                        AS JuridicalAddress_To

           , OH_JuridicalDetails_To.OKPO                                    AS OKPO_To
           , OH_JuridicalDetails_To.INN                                     AS INN_To
           , OH_JuridicalDetails_To.NumberVAT                               AS NumberVAT_To
         -- , COALESCE (Object_Personal_View.PersonalName, OH_JuridicalDetails_To.AccounterName) :: TVarChar AS AccounterName_To 
           , CASE WHEN Object_PersonalSigning.PersonalName <> '' 
                  THEN zfConvert_FIO (Object_PersonalSigning.PersonalName, 1)
                  ELSE CASE WHEN COALESCE (Object_PersonalBookkeeper_View.PersonalName,'') <> '' 
                            THEN zfConvert_FIO (Object_PersonalBookkeeper_View.PersonalName, 1)
                            ELSE '����� �.�.' /*'�.�. �������'*/ 
                       END  
             END                                                :: TVarChar AS AccounterName_To
           , CASE WHEN Object_PersonalSigning.PersonalName <> '' 
                  THEN PersonalSigning_INN.ValueData
                  ELSE CASE WHEN Object_PersonalBookkeeper_View.PersonalName <> '' 
                            THEN PersonalBookkeeper_INN.ValueData
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
                                    , inGLNCodeJuridical_partner := ObjectString_Partner_GLNCodeJuridical.ValueData
                                    , inGLNCodeJuridical         := ObjectString_Juridical_GLNCode.ValueData
                                     ) AS BuyerGLNCode

           , zfCalc_GLNCodeCorporate (inGLNCode                  := 'ok'
                                    , inGLNCodeCorporate_partner := ObjectString_Partner_GLNCodeCorporate.ValueData
                                    , inGLNCodeCorporate_retail  := ObjectString_Retail_GLNCodeCorporate.ValueData
                                    , inGLNCodeCorporate_main    := ObjectString_JuridicalTo_GLNCode.ValueData
                                     ) AS SupplierGLNCode


           , CASE WHEN OH_JuridicalDetails_From.INN = vbNotNDSPayer_INN
                  THEN '���������'
             ELSE OH_JuridicalDetails_From.FullName END                     AS JuridicalName_From
           , CASE WHEN OH_JuridicalDetails_From.INN = vbNotNDSPayer_INN
                  THEN '���������'
             ELSE OH_JuridicalDetails_From.JuridicalAddress END             AS JuridicalAddress_From

           , OH_JuridicalDetails_From.OKPO                                  AS OKPO_From
           , OH_JuridicalDetails_From.INN                                   AS INN_From
           , OH_JuridicalDetails_From.InvNumberBranch                       AS InvNumberBranch_From
           , OH_JuridicalDetails_From.NumberVAT                             AS NumberVAT_From
           , OH_JuridicalDetails_From.AccounterName                         AS AccounterName_From
           , OH_JuridicalDetails_From.BankAccount                           AS BankAccount_From
           , OH_JuridicalDetails_From.BankName                              AS BankName_From
           , OH_JuridicalDetails_From.MFO                                   AS BankMFO_From
           , CASE WHEN OH_JuridicalDetails_From.INN = vbNotNDSPayer_INN
                  THEN ''
             ELSE OH_JuridicalDetails_From.Phone END                        AS Phone_From

           , tmpMI.Id                                                       AS Id
           , Object_Goods.ObjectCode                                        AS GoodsCode

           , CASE WHEN Movement.OperDate < '01.01.2017'
                       THEN ''

                  WHEN ObjectString_Goods_UKTZED.ValueData <> ''
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
              END :: TVarChar AS GoodsCodeUKTZED

           , CASE WHEN Movement.OperDate < '01.01.2017' THEN ''
                  WHEN ObjectString_Goods_TaxImport.ValueData <> '' THEN ObjectString_Goods_TaxImport.ValueData
                  WHEN tmpTaxImport.TaxImport <> '' THEN tmpTaxImport.TaxImport
                  ELSE ''
             END :: TVarChar AS GoodsCodeTaxImport

           , CASE WHEN Movement.OperDate < '01.01.2017' THEN ''
                  WHEN ObjectString_Goods_DKPP.ValueData <> '' THEN ObjectString_Goods_DKPP.ValueData
                  WHEN tmpDKPP.DKPP <> '' THEN tmpDKPP.DKPP
                  ELSE ''
             END :: TVarChar AS GoodsCodeDKPP

           , CASE WHEN Movement.OperDate < '01.01.2017' THEN ''
                  WHEN ObjectString_Goods_TaxAction.ValueData <> '' THEN ObjectString_Goods_TaxAction.ValueData
                  WHEN tmpTaxAction.TaxAction <> '' THEN tmpTaxAction.TaxAction
                  ELSE ''
             END :: TVarChar AS GoodsCodeTaxAction

           , (CASE WHEN MovementLinkObject_DocumentTaxKind.ObjectId = zc_Enum_DocumentTaxKind_Prepay() THEN '���������� �� ����.�������' WHEN tmpObject_GoodsPropertyValue.Name <> '' THEN tmpObject_GoodsPropertyValue.Name WHEN tmpObject_GoodsPropertyValue_basis.Name <> '' THEN tmpObject_GoodsPropertyValue_basis.Name ELSE Object_Goods.ValueData || CASE WHEN COALESCE (Object_GoodsKind.Id, zc_Enum_GoodsKind_Main()) = zc_Enum_GoodsKind_Main() THEN '' ELSE ' ' || Object_GoodsKind.ValueData END END) :: TVarChar AS GoodsName
           , CASE WHEN MovementLinkObject_DocumentTaxKind.ObjectId = zc_Enum_DocumentTaxKind_Prepay() THEN '���������� �� ����.�������' WHEN tmpObject_GoodsPropertyValue.Name <> '' THEN tmpObject_GoodsPropertyValue.Name WHEN tmpObject_GoodsPropertyValue_basis.Name <> '' THEN tmpObject_GoodsPropertyValue_basis.Name ELSE Object_Goods.ValueData END AS GoodsName_two
           , Object_GoodsKind.ValueData                             AS GoodsKindName
           , Object_Measure.ValueData                               AS MeasureName
           , CASE WHEN Object_Measure.ObjectCode=1 THEN '0301'
                  WHEN Object_Measure.ObjectCode=2 THEN '2009'
             ELSE ''     END                                        AS MeasureCode
           , COALESCE (tmpObject_GoodsPropertyValueGroup.Article, COALESCE (tmpObject_GoodsPropertyValue.Article, ''))    AS Article_Juridical
           , COALESCE (tmpObject_GoodsPropertyValue.BarCode, '')    AS BarCode_Juridical
           , COALESCE (tmpObject_GoodsPropertyValueGroup.ArticleGLN, COALESCE (tmpObject_GoodsPropertyValue.ArticleGLN, '')) AS ArticleGLN_Juridical
           , COALESCE (tmpObject_GoodsPropertyValue.BarCodeGLN, '') AS BarCodeGLN_Juridical

           , CASE WHEN MovementLinkObject_DocumentTaxKind.ObjectId NOT IN (zc_Enum_DocumentTaxKind_CorrectivePrice(), zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical())
                  THEN tmpMI.Amount
                  ELSE NULL  END                                            AS Amount
           , CASE WHEN MovementLinkObject_DocumentTaxKind.ObjectId NOT IN (zc_Enum_DocumentTaxKind_CorrectivePrice(), zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical())
                  THEN tmpMI.Price / CASE WHEN tmpMI.CountForPrice > 0 THEN tmpMI.CountForPrice ELSE 1 END
                  ELSE NULL  END                                            AS Price

           , CASE WHEN MovementLinkObject_DocumentTaxKind.ObjectId IN (zc_Enum_DocumentTaxKind_CorrectivePrice(), zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical())
                  THEN tmpMI.Amount
                  ELSE NULL  END                                            AS Amount_for_PriceCor
           , CASE WHEN MovementLinkObject_DocumentTaxKind.ObjectId IN (zc_Enum_DocumentTaxKind_CorrectivePrice(), zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical())
                  THEN tmpMI.Price / CASE WHEN tmpMI.CountForPrice > 0 THEN tmpMI.CountForPrice ELSE 1 END
                  ELSE NULL  END                                            AS Price_for_PriceCor

           , CAST (CASE WHEN tmpMI.CountForPrice > 0
                           THEN CAST ( (COALESCE (tmpMI.Amount, 0)) * tmpMI.Price / tmpMI.CountForPrice AS NUMERIC (16, 2))
                           ELSE CAST ( (COALESCE (tmpMI.Amount, 0)) * tmpMI.Price AS NUMERIC (16, 2))
                   END AS TFloat)                                           AS AmountSumm

           , CAST (REPEAT (' ', 4 - LENGTH (MovementString_InvNumberBranch.ValueData)) || MovementString_InvNumberBranch.ValueData AS TVarChar) AS InvNumberBranch
           , CAST (REPEAT (' ', 4 - LENGTH (MovementString_InvNumberBranch_Child.ValueData)) || MovementString_InvNumberBranch_Child.ValueData AS TVarChar) AS InvNumberBranch_Child

           , MovementString_InvNumberMark.ValueData     AS InvNumberMark
           , COALESCE (MovementDate_OperDatePartner.ValueData, Movement_ReturnIn.OperDate) AS OperDatePartner_ReturnIn
           , COALESCE (MovementString_InvNumberPartner_ReturnIn.ValueData, Movement_ReturnIn.InvNumber) AS InvNumberPartner_ReturnIn
--           , COALESCE (MovementFloat_VATPercent.ValueData, 0) AS VATPercent

           , Movement_Sale.InvNumber                        AS InvNumber_Sale
           , MovementString_InvNumberPartner_Sale.ValueData AS InvNumberPartner_Sale
           , MovementString_InvNumberOrder_Sale.ValueData   AS InvNumberOrder_Sale
           , MovementDate_OperDatePartner_Sale.ValueData    AS OperDatePartner_Sale

           , MovementString_InvNumberPartnerEDI.ValueData  AS InvNumberPartnerEDI
           , MovementDate_OperDatePartnerEDI.ValueData     AS OperDatePartnerEDI
           , COALESCE(MovementLinkMovement_ChildEDI.MovementChildId, 0) AS EDIId
           , COALESCE(MovementFloat_Amount.ValueData, 0) AS SendDeclarAmount

           --, COALESCE (tmpMITax1.LineNum, tmpMITax2.LineNum) :: Integer AS LineNum
           , CASE WHEN tmpMI.isAuto = TRUE THEN COALESCE (tmpMITax1.LineNum, tmpMITax2.LineNum) ELSE tmpMI.NPP END :: Integer AS LineNum
           , CASE WHEN MovementLinkObject_DocumentTaxKind.ObjectId NOT IN (zc_Enum_DocumentTaxKind_CorrectivePrice(), zc_Enum_DocumentTaxKind_Corrective(),zc_Enum_DocumentTaxKind_Prepay())
                  THEN 'X' ELSE '' END    AS TaxKind --�������  ������� �������������

       FROM tmpMI
            LEFT JOIN tmpUKTZED ON tmpUKTZED.GoodsGroupId = tmpMI.GoodsGroupId
            LEFT JOIN tmpTaxImport ON tmpTaxImport.GoodsGroupId = tmpMI.GoodsGroupId
            LEFT JOIN tmpDKPP ON tmpDKPP.GoodsGroupId = tmpMI.GoodsGroupId
            LEFT JOIN tmpTaxAction ON tmpTaxAction.GoodsGroupId = tmpMI.GoodsGroupId

            LEFT JOIN MovementBoolean AS MovementBoolean_isCopy
                                      ON MovementBoolean_isCopy.MovementId = tmpMI.MovementId
                                     AND MovementBoolean_isCopy.DescId = zc_MovementBoolean_isCopy()

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_ChildEDI
                                           ON MovementLinkMovement_ChildEDI.MovementId = tmpMI.MovementId
                                          AND MovementLinkMovement_ChildEDI.DescId = zc_MovementLinkMovement_ChildEDI()

            LEFT JOIN MovementFloat AS MovementFloat_Amount
                                    ON MovementFloat_Amount.MovementId =  MovementLinkMovement_ChildEDI.MovementChildId
                                   AND MovementFloat_Amount.DescId = zc_MovementFloat_Amount()

            LEFT JOIN MovementDate AS MovementDate_OperDatePartnerEDI
                                   ON MovementDate_OperDatePartnerEDI.MovementId =  MovementLinkMovement_ChildEDI.MovementChildId
                                  AND MovementDate_OperDatePartnerEDI.DescId = zc_MovementDate_OperDatePartner()

            LEFT JOIN MovementString AS MovementString_InvNumberPartnerEDI
                                     ON MovementString_InvNumberPartnerEDI.MovementId =  MovementLinkMovement_ChildEDI.MovementChildId
                                    AND MovementString_InvNumberPartnerEDI.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMI.GoodsKindId

            LEFT JOIN ObjectString AS ObjectString_Goods_UKTZED
                                   ON ObjectString_Goods_UKTZED.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_UKTZED.DescId = zc_ObjectString_Goods_UKTZED()
            LEFT JOIN ObjectString AS ObjectString_Goods_TaxImport
                                   ON ObjectString_Goods_TaxImport.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_TaxImport.DescId = zc_ObjectString_Goods_TaxImport()
            LEFT JOIN ObjectString AS ObjectString_Goods_DKPP
                                   ON ObjectString_Goods_DKPP.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_DKPP.DescId = zc_ObjectString_Goods_DKPP()
            LEFT JOIN ObjectString AS ObjectString_Goods_TaxAction
                                   ON ObjectString_Goods_TaxAction.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_TaxAction.DescId = zc_ObjectString_Goods_TaxAction()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = COALESCE (ObjectLink_Goods_Measure.ChildObjectId, zc_Measure_Sh())

            LEFT JOIN tmpObject_GoodsPropertyValue ON tmpObject_GoodsPropertyValue.GoodsId = tmpMI.GoodsId
                                                  AND tmpObject_GoodsPropertyValue.GoodsKindId = tmpMI.GoodsKindId
            LEFT JOIN tmpObject_GoodsPropertyValueGroup ON tmpObject_GoodsPropertyValueGroup.GoodsId = tmpMI.GoodsId
                                                       AND tmpObject_GoodsPropertyValue.GoodsId IS NULL
            LEFT JOIN tmpObject_GoodsPropertyValue_basis ON tmpObject_GoodsPropertyValue_basis.GoodsId = tmpMI.GoodsId
                                                        AND tmpObject_GoodsPropertyValue_basis.GoodsKindId = tmpMI.GoodsKindId
                                                  -- AND tmpObject_GoodsPropertyValue.Name <> ''
            LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                 ON ObjectLink_Goods_InfoMoney.ObjectId = Object_Goods.Id 
                                AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
            -- LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

-- MOVEMENT
            LEFT JOIN Movement ON Movement.Id = tmpMI.MovementId
            LEFT JOIN MovementLinkObject AS MovementLinkObject_DocumentTaxKind
                                         ON MovementLinkObject_DocumentTaxKind.MovementId = Movement.Id
                                        AND MovementLinkObject_DocumentTaxKind.DescId = zc_MovementLinkObject_DocumentTaxKind()
            LEFT JOIN MovementString AS MovementString_InvNumberBranch
                                     ON MovementString_InvNumberBranch.MovementId =  Movement.Id
                                    AND MovementString_InvNumberBranch.DescId = zc_MovementString_InvNumberBranch()

            LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                      ON MovementBoolean_PriceWithVAT.MovementId =  Movement.Id
                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()

            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId =  Movement.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

            LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                    ON MovementFloat_VATPercent.MovementId =  Movement.Id
                                   AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummMVAT
                                    ON MovementFloat_TotalSummMVAT.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummMVAT.DescId = zc_MovementFloat_TotalSummMVAT()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummPVAT
                                    ON MovementFloat_TotalSummPVAT.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummPVAT.DescId = zc_MovementFloat_TotalSummPVAT()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Branch
                                         ON MovementLinkObject_Branch.MovementId = Movement.Id
                                        AND MovementLinkObject_Branch.DescId = zc_MovementLinkObject_Branch()
            LEFT JOIN ObjectLink AS ObjectLink_Branch_PersonalBookkeeper
                                 ON ObjectLink_Branch_PersonalBookkeeper.ObjectId = MovementLinkObject_Branch.ObjectId
                                AND ObjectLink_Branch_PersonalBookkeeper.DescId = zc_ObjectLink_Branch_PersonalBookkeeper()
            LEFT JOIN Object_Personal_View AS Object_PersonalBookkeeper_View ON Object_PersonalBookkeeper_View.PersonalId = ObjectLink_Branch_PersonalBookkeeper.ChildObjectId

            LEFT JOIN ObjectString AS PersonalBookkeeper_INN
                                   ON PersonalBookkeeper_INN.ObjectId = Object_PersonalBookkeeper_View.MemberId 
                                  AND PersonalBookkeeper_INN.DescId = zc_ObjectString_Member_INN()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
            LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_From.Id

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_To
                                                                ON OH_JuridicalDetails_To.JuridicalId = Object_To.Id
                                                               AND Movement.OperDate >= OH_JuridicalDetails_To.StartDate AND Movement.OperDate < OH_JuridicalDetails_To.EndDate
            LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_From
                                                                ON OH_JuridicalDetails_From.JuridicalId = Object_From.Id
                                                               AND Movement.OperDate >= OH_JuridicalDetails_From.StartDate AND Movement.OperDate < OH_JuridicalDetails_From.EndDate

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                         ON MovementLinkObject_Partner.MovementId = Movement.Id
                                        AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
            LEFT JOIN ObjectString AS ObjectString_FromAddress
                                   ON ObjectString_FromAddress.ObjectId = MovementLinkObject_Partner.ObjectId
                                  AND ObjectString_FromAddress.DescId = zc_ObjectString_Partner_Address()

            /*LEFT JOIN ObjectString AS ObjectString_BuyerGLNCode
                                   ON ObjectString_BuyerGLNCode.ObjectId = OH_JuridicalDetails_To.JuridicalId
                                  AND ObjectString_BuyerGLNCode.DescId = zc_ObjectString_Juridical_GLNCode()
            LEFT JOIN ObjectString AS ObjectString_SupplierGLNCode
                                   ON ObjectString_SupplierGLNCode.ObjectId = OH_JuridicalDetails_From.JuridicalId
                                  AND ObjectString_SupplierGLNCode.DescId = zc_ObjectString_Juridical_GLNCode()*/

            LEFT JOIN ObjectString AS ObjectString_Partner_GLNCodeJuridical
                                   ON ObjectString_Partner_GLNCodeJuridical.ObjectId = COALESCE (MovementLinkObject_Partner.ObjectId, Object_From.Id)
                                  AND ObjectString_Partner_GLNCodeJuridical.DescId = zc_ObjectString_Partner_GLNCodeJuridical()
            LEFT JOIN ObjectString AS ObjectString_Partner_GLNCodeCorporate
                                   ON ObjectString_Partner_GLNCodeCorporate.ObjectId = COALESCE (MovementLinkObject_Partner.ObjectId, Object_From.Id)
                                  AND ObjectString_Partner_GLNCodeCorporate.DescId = zc_ObjectString_Partner_GLNCodeCorporate()

            LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                 ON ObjectLink_Juridical_Retail.ObjectId = OH_JuridicalDetails_From.JuridicalId
                                AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
            LEFT JOIN ObjectString AS ObjectString_Juridical_GLNCode
                                   ON ObjectString_Juridical_GLNCode.ObjectId = OH_JuridicalDetails_From.JuridicalId
                                  AND ObjectString_Juridical_GLNCode.DescId = zc_ObjectString_Juridical_GLNCode()
            LEFT JOIN ObjectString AS ObjectString_Retail_GLNCodeCorporate
                                   ON ObjectString_Retail_GLNCodeCorporate.ObjectId = ObjectLink_Juridical_Retail.ChildObjectId
                                  AND ObjectString_Retail_GLNCodeCorporate.DescId = zc_ObjectString_Retail_GLNCodeCorporate()

            LEFT JOIN ObjectString AS ObjectString_JuridicalTo_GLNCode
                                   ON ObjectString_JuridicalTo_GLNCode.ObjectId = OH_JuridicalDetails_To.JuridicalId
                                  AND ObjectString_JuridicalTo_GLNCode.DescId = zc_ObjectString_Juridical_GLNCode()


            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
            LEFT JOIN Object_Contract_View AS View_Contract ON View_Contract.ContractId = MovementLinkObject_Contract.ObjectId
            LEFT JOIN ObjectDate AS ObjectDate_Signing
                                 ON ObjectDate_Signing.ObjectId = MovementLinkObject_Contract.ObjectId
                                AND ObjectDate_Signing.DescId = zc_ObjectDate_Contract_Signing()
                                AND View_Contract.InvNumber <> '-'

            LEFT JOIN ObjectLink AS ObjectLink_Contract_PersonalSigning
                                 ON ObjectLink_Contract_PersonalSigning.ObjectId = View_Contract.ContractId
                                AND ObjectLink_Contract_PersonalSigning.DescId = zc_ObjectLink_Contract_PersonalSigning()
            LEFT JOIN Object_Personal_View AS Object_PersonalSigning ON Object_PersonalSigning.PersonalId = ObjectLink_Contract_PersonalSigning.ChildObjectId   

            LEFT JOIN ObjectString AS PersonalSigning_INN
                                   ON PersonalSigning_INN.ObjectId = Object_PersonalSigning.MemberId 
                                  AND PersonalSigning_INN.DescId = zc_ObjectString_Member_INN()

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_child
                                           ON MovementLinkMovement_child.MovementId = Movement.Id
                                          AND MovementLinkMovement_child.DescId = zc_MovementLinkMovement_Child()
            LEFT JOIN Movement AS Movement_child ON Movement_child.Id = MovementLinkMovement_child.MovementChildId
                                                AND Movement_child.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Complete())
            LEFT JOIN MovementLinkObject AS MovementLinkObject_DocumentTaxKind_Child
                                         ON MovementLinkObject_DocumentTaxKind_Child.MovementId = MovementLinkMovement_child.MovementChildId
                                        AND MovementLinkObject_DocumentTaxKind_Child.DescId = zc_MovementLinkObject_DocumentTaxKind()

---- ������ ����� � ��
            LEFT JOIN tmpMITax AS tmpMITax1 ON tmpMITax1.Kind        = 1
                                           AND tmpMITax1.GoodsId     = Object_Goods.Id
                                           AND tmpMITax1.GoodsKindId = Object_GoodsKind.Id
                                           AND tmpMITax1.Price       = tmpMI.Price
            LEFT JOIN tmpMITax AS tmpMITax2 ON tmpMITax2.Kind        = 2
                                           AND tmpMITax2.GoodsId     = Object_Goods.Id
                                           AND tmpMITax2.Price       = tmpMI.Price
                                           AND tmpMITax1.GoodsId     IS NULL
----
            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Child_Sale
                                           ON MovementLinkMovement_Child_Sale.MovementChildId = MovementLinkMovement_Child.MovementChildId
                                          AND MovementLinkMovement_Child_Sale.DescId = zc_MovementLinkMovement_Master()
                                          AND MovementLinkObject_DocumentTaxKind_Child.ObjectId = zc_Enum_DocumentTaxKind_Tax() -- ���������
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

--   09.07.14
            LEFT JOIN Movement AS Movement_ReturnIn ON Movement_ReturnIn.Id = inMovementId

            LEFT JOIN MovementString AS MovementString_InvNumberMark
                                     ON MovementString_InvNumberMark.MovementId =  Movement_ReturnIn.Id
                                    AND MovementString_InvNumberMark.DescId = zc_MovementString_InvNumberMark()
            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId =  Movement_ReturnIn.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
            LEFT JOIN MovementString AS MovementString_InvNumberPartner_ReturnIn
                                     ON MovementString_InvNumberPartner_ReturnIn.MovementId =  Movement_ReturnIn.Id
                                    AND MovementString_InvNumberPartner_ReturnIn.DescId = zc_MovementString_InvNumberPartner()

--   09.07.14

            LEFT JOIN MovementString AS MovementString_InvNumberBranch_Child
                                     ON MovementString_InvNumberBranch_Child.MovementId =  Movement_child.Id
                                    AND MovementString_InvNumberBranch_Child.DescId = zc_MovementString_InvNumberBranch()
            LEFT JOIN MovementString AS MS_DocumentChild_InvNumberPartner ON MS_DocumentChild_InvNumberPartner.MovementId = Movement_child.Id
                                                                         AND MS_DocumentChild_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()


       ORDER BY MovementString_InvNumberPartner.ValueData
              , Object_Goods.ValueData 
              , Object_GoodsKind.ValueData
      ;
     RETURN NEXT Cursor1;


     -- ������ �� ������� ��������� � ���� �������������
     OPEN Cursor2 FOR
     WITH tmpMovement AS
          (SELECT Movement_find.Id
                , MovementLinkMovement_Master.MovementChildId AS MovementId_Return
           FROM Movement
                LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Master
                                               ON MovementLinkMovement_Master.MovementId = Movement.Id
                                              AND MovementLinkMovement_Master.DescId = zc_MovementLinkMovement_Master()
                -- �������� ������ ��� �������������
                LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Master_find
                                               ON MovementLinkMovement_Master_find.MovementChildId = MovementLinkMovement_Master.MovementChildId
                                              AND MovementLinkMovement_Master_find.DescId = zc_MovementLinkMovement_Master()
                INNER JOIN Movement AS Movement_find ON Movement_find.Id  = COALESCE (MovementLinkMovement_Master_find.MovementId, Movement.Id)
                                                    AND Movement_find.StatusId IN (zc_Enum_Status_Complete())
           WHERE Movement.Id = inMovementId
             AND Movement.DescId = zc_Movement_TaxCorrective()
          UNION
           SELECT MovementLinkMovement_Master.MovementId AS Id
                , Movement.Id AS MovementId_Return
           FROM Movement
                INNER JOIN MovementLinkMovement AS MovementLinkMovement_Master
                                                ON MovementLinkMovement_Master.MovementChildId = Movement.Id
                                               AND MovementLinkMovement_Master.DescId = zc_MovementLinkMovement_Master()
                INNER JOIN Movement AS Movement_Master ON Movement_Master.Id  = MovementLinkMovement_Master.MovementId
                                                      AND Movement_Master.StatusId = zc_Enum_Status_Complete()
           WHERE Movement.Id = inMovementId
             AND Movement.DescId IN (zc_Movement_ReturnIn(), zc_Movement_TransferDebtIn(), zc_Movement_PriceCorrective())
          )
        , tmpMovementTaxCorrectiveCount AS
          (SELECT COALESCE (COUNT (*), 0) AS CountTaxId FROM tmpMovement)
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
        , tmpReturnIn AS
          (SELECT MovementItem.ObjectId     			        AS GoodsId
                , CASE WHEN MIFloat_ChangePercent.ValueData <> 0 AND Movement.DescId = zc_Movement_ReturnIn()
                            THEN CAST ( (1 + MIFloat_ChangePercent.ValueData       / 100) * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2))
                       WHEN MovementFloat_ChangePercent.ValueData <> 0 AND Movement.DescId <> zc_Movement_ReturnIn()
                            THEN CAST ( (1 + MovementFloat_ChangePercent.ValueData / 100) * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2))
                       ELSE COALESCE (MIFloat_Price.ValueData, 0)
                  END AS Price
                , SUM (CASE WHEN Movement.DescId = zc_Movement_ReturnIn()
                                 THEN COALESCE (MIFloat_AmountPartner.ValueData, 0)
                                 ELSE MovementItem.Amount
                       END) AS Amount
           FROM (SELECT MovementId_Return AS MovementId FROM tmpMovement GROUP BY MovementId_Return) AS tmpMovement
                INNER JOIN Movement ON Movement.Id = tmpMovement.MovementId
                                   AND Movement.DescId IN (zc_Movement_ReturnIn(), zc_Movement_TransferDebtIn(), zc_Movement_PriceCorrective())
                                   AND Movement.StatusId <> zc_Enum_Status_Erased() -- �� ����������� ������ ������������
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
           GROUP BY MovementItem.ObjectId
                  , MIFloat_Price.ValueData
                  , MIFloat_ChangePercent.ValueData
                  , Movement.DescId
                  , MovementFloat_ChangePercent.ValueData
          )

       , tmpTaxCorrective AS --�������� �������������
       (SELECT
             MovementItem.ObjectId                                          AS GoodsId
           , MIFloat_Price.ValueData                                        AS Price
           , SUM (MovementItem.Amount)                                      AS Amount
       FROM tmpMovementTaxCorrective
            INNER JOIN Movement ON Movement.Id =  tmpMovementTaxCorrective.Id
            INNER JOIN MovementItem ON MovementItem.MovementId =  Movement.Id
                                   AND MovementItem.DescId     = zc_MI_Master()
                                   AND MovementItem.isErased   = FALSE
                                   AND MovementItem.Amount <> 0
            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                    -- AND MIFloat_Price.ValueData <> 0
       GROUP BY MovementItem.ObjectId
              , MIFloat_Price.ValueData

       )
       -- ��� ������
       SELECT COALESCE (tmp.GoodsId, 1) AS GoodsId
            , CAST (tmpMovementTaxCorrectiveCount.CountTaxId AS Integer) AS CountTaxId
            , Object_Goods.ObjectCode         AS GoodsCode
            , Object_Goods.ValueData          AS GoodsName
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
                                    ON MovementFloat_TotalSummMVAT.MovementId = inMovementId
                                   AND MovementFloat_TotalSummMVAT.DescId = zc_MovementFloat_TotalSummMVAT()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummPVAT
                                    ON MovementFloat_TotalSummPVAT.MovementId = inMovementId
                                   AND MovementFloat_TotalSummPVAT.DescId = zc_MovementFloat_TotalSummPVAT()
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
            LEFT JOIN tmpMovementTaxCorrectiveCount ON 1 = 1
       -- !!! print all !!!
       -- WHERE tmpMovementTaxCount.DescId NOT IN (zc_Movement_TransferDebtIn(), zc_Movement_PriceCorrective()) OR tmp.GoodsId IS NOT NULL
     ;
    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_TaxCorrective_Print (Integer, Boolean, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
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
 24.04.14                                                       * add zc_MovementString_InvNumberBranch
 23.04.14                                        * add �������� ������ ��� �������������
 14.04.14                                                       *
 10.04.14                                                       *
 09.04.14                                                       *
 08.04.14                                                       *
 07.04.14                                                       *
*/

-- ����
-- SELECT * FROM gpSelect_Movement_TaxCorrective_Print (inMovementId := 185675, inisClientCopy:= FALSE, inSession:= zfCalc_UserAdmin());
-- SELECT * FROM gpSelect_Movement_TaxCorrective_Print (inMovementId := 520880, inisClientCopy:= FALSE ,inSession:= zfCalc_UserAdmin());
