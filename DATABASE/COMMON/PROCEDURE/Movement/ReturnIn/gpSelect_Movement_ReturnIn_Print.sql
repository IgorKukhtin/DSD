-- Function: gpSelect_Movement_ReturnIn_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_ReturnIn_Print (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_ReturnIn_Print(
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
    DECLARE vbPaidKindId Integer;
    DECLARE vbContractId Integer;
    DECLARE vbIsChangePrice Boolean;
    DECLARE vbIsDiscountPrice Boolean;

    DECLARE vbOperSumm_MVAT TFloat;
    DECLARE vbOperSumm_PVAT TFloat;

    DECLARE vbStoreKeeperName TVarChar;
    DECLARE vbOperDate     TDateTime;   
    DECLARE vbOperDatePartner TDateTime;
    DECLARE vbFromId       Integer;
    DECLARE vbPersonalId   Integer;
    DECLARE vbPersonalName TVarChar;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_ReturnIn());
     vbUserId:= inSession;


     -- ��������� �� �����������
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

     -- ��������� �� ���������
     SELECT Movement.DescId
          , Movement.StatusId
          , Movement.OperDate
          , MovementDate_OperDatePartner.ValueData
          , COALESCE (MovementBoolean_PriceWithVAT.ValueData, TRUE) AS PriceWithVAT
          , COALESCE (MovementFloat_VATPercent.ValueData, 0)        AS VATPercent
          , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) < 0 THEN -MovementFloat_ChangePercent.ValueData ELSE 0 END AS DiscountPercent
          , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) > 0 THEN MovementFloat_ChangePercent.ValueData ELSE 0 END AS ExtraChargesPercent
          , zfCalc_GoodsPropertyId (MovementLinkObject_Contract.ObjectId, COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MovementLinkObject_From.ObjectId), MovementLinkObject_From.ObjectId) AS GoodsPropertyId
          , zfCalc_GoodsPropertyId (0, zc_Juridical_Basis(), 0)     AS GoodsPropertyId_basis
          , COALESCE (MovementLinkObject_PaidKind.ObjectId, 0)      AS PaidKindId
          , COALESCE (MovementLinkObject_Contract.ObjectId, 0)      AS ContractId
          , COALESCE (ObjectBoolean_isDiscountPrice.ValueData, FALSE) AS isDiscountPrice
          , MovementLinkObject_From.ObjectId                          AS FromId
            INTO vbDescId, vbStatusId, vbOperDate, vbOperDatePartner, vbPriceWithVAT, vbVATPercent, vbDiscountPercent, vbExtraChargesPercent, vbGoodsPropertyId, vbGoodsPropertyId_basis, vbPaidKindId, vbContractId, vbIsDiscountPrice, vbFromId
     FROM Movement
          LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                 ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                AND MovementDate_OperDatePartner.DescId     = zc_MovementDate_OperDatePartner()
          LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                    ON MovementBoolean_PriceWithVAT.MovementId = Movement.Id
                                   AND MovementBoolean_PriceWithVAT.DescId     = zc_MovementBoolean_PriceWithVAT()
          LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                  ON MovementFloat_VATPercent.MovementId = Movement.Id
                                 AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
          LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                  ON MovementFloat_ChangePercent.MovementId = Movement.Id
                                 AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                       ON MovementLinkObject_Contract.MovementId = Movement.Id
                                      AND MovementLinkObject_Contract.DescId IN (zc_MovementLinkObject_Contract(), zc_MovementLinkObject_ContractFrom())
          LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                       ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                      AND MovementLinkObject_PaidKind.DescId IN (zc_MovementLinkObject_PaidKind(), zc_MovementLinkObject_PaidKindFrom())
          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                               ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                              AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
          LEFT JOIN ObjectBoolean AS ObjectBoolean_isDiscountPrice
                                  ON ObjectBoolean_isDiscountPrice.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                 AND ObjectBoolean_isDiscountPrice.DescId = zc_ObjectBoolean_Juridical_isDiscountPrice() 
          /*LEFT JOIN ObjectLink AS ObjectLink_Juridical_GoodsProperty
                               ON ObjectLink_Juridical_GoodsProperty.ObjectId = COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MovementLinkObject_From.ObjectId)
                              AND ObjectLink_Juridical_GoodsProperty.DescId = zc_ObjectLink_Juridical_GoodsProperty()
          LEFT JOIN ObjectLink AS ObjectLink_JuridicalBasis_GoodsProperty
                               ON ObjectLink_JuridicalBasis_GoodsProperty.ObjectId = zc_Juridical_Basis()
                              AND ObjectLink_JuridicalBasis_GoodsProperty.DescId = zc_ObjectLink_Juridical_GoodsProperty()
                              AND ObjectLink_Juridical_GoodsProperty.ChildObjectId IS NULL*/
     WHERE Movement.Id = inMovementId;


     -- !!!���� ���������� - ���� �� ������ � ����!!!
     vbIsChangePrice:= vbIsDiscountPrice = TRUE
                    OR vbPaidKindId = zc_Enum_PaidKind_FirstForm()
                    OR ((vbDiscountPercent > 0 OR vbExtraChargesPercent > 0)
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


    -- ����� ������ ��������
    -- IF COALESCE (vbStatusId, 0) <> zc_Enum_Status_Complete()
    IF COALESCE (vbStatusId, 0) = zc_Enum_Status_UnComplete()
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


    /*IF vbDiscountPercent <> 0
    THEN
        -- ������ ����
        SELECT CASE WHEN NOT vbPriceWithVAT OR vbVATPercent = 0
                         -- ���� ���� ��� ��� ��� %���=0
                         THEN OperSumm
                    WHEN vbPriceWithVAT AND 1=1
                         -- ���� ���� c ���
                         THEN CAST ( (OperSumm) / (1 + vbVATPercent / 100) AS NUMERIC (16, 2))
                    WHEN vbPriceWithVAT
                         -- ���� ���� c ��� (������� ����� ���� ���� �������� ������ ��� =1/6 )
                         THEN OperSumm - CAST ( (OperSumm) / (100 / vbVATPercent + 1) AS NUMERIC (16, 2))
               END AS OperSumm_MVAT
               -- ����� � ���
             , CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                         -- ���� ���� � ���
                         THEN (OperSumm)
                    WHEN vbVATPercent > 0
                         -- ���� ���� ��� ���
                         THEN CAST ( (1 + vbVATPercent / 100) * (OperSumm) AS NUMERIC (16, 2))
               END AS OperSumm_PVAT
               INTO vbOperSumm_MVAT, vbOperSumm_PVAT
        FROM
       (SELECT SUM (CASE WHEN tmpMI.CountForPrice <> 0
                              THEN CAST (tmpMI.Amount * tmpMI.Price / tmpMI.CountForPrice AS NUMERIC (16, 2))
                         ELSE CAST (tmpMI.Amount * tmpMI.Price AS NUMERIC (16, 2))
                    END
                   ) AS OperSumm
        FROM (SELECT MovementItem.ObjectId AS GoodsId
                   , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                   , CASE WHEN vbDiscountPercent <> 0
                               THEN CAST ( (1 - vbDiscountPercent / 100) * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2))
                          WHEN vbExtraChargesPercent <> 0
                               THEN CAST ( (1 + vbExtraChargesPercent / 100) * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2))
                          ELSE COALESCE (MIFloat_Price.ValueData, 0)
                     END AS Price
                   , COALESCE (MIFloat_CountForPrice.ValueData, 0) AS CountForPrice
                   , SUM (CASE WHEN Movement.DescId = zc_Movement_Sale() THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) WHEN Movement.DescId = zc_Movement_TransferDebtOut() THEN MovementItem.Amount ELSE 0 END) AS Amount
              FROM MovementItem
                   INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                   INNER JOIN MovementItemFloat AS MIFloat_Price
                                                ON MIFloat_Price.MovementItemId = MovementItem.Id
                                               AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                               AND MIFloat_Price.ValueData <> 0
                   LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                               ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                              AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
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
                     , MIFloat_Price.ValueData
                     , MIFloat_CountForPrice.ValueData
             ) AS tmpMI
        ) AS tmpMI;
    END IF;*/


     -- ����������� ����������� �� ��� ������
     vbPersonalId:= COALESCE ((SELECT ObjectLink_Partner_MemberTake.ChildObjectId
                               FROM ObjectLink AS ObjectLink_Partner_MemberTake
                               WHERE ObjectLink_Partner_MemberTake.ObjectId = vbFromId
                                 AND ObjectLink_Partner_MemberTake.DescId = CASE EXTRACT (DOW FROM vbOperDate)
                                                                                WHEN 1 THEN zc_ObjectLink_Partner_MemberTake1()
                                                                                WHEN 2 THEN zc_ObjectLink_Partner_MemberTake2()
                                                                                WHEN 3 THEN zc_ObjectLink_Partner_MemberTake3()
                                                                                WHEN 4 THEN zc_ObjectLink_Partner_MemberTake4()
                                                                                WHEN 5 THEN zc_ObjectLink_Partner_MemberTake5()
                                                                                WHEN 6 THEN zc_ObjectLink_Partner_MemberTake6()
                                                                                WHEN 0 THEN zc_ObjectLink_Partner_MemberTake7()
                                                                            END
                              ), 0);
     -- �������� ������ �� vbPersonalId
     vbPersonalName:= (SELECT Object.ValueData FROM Object WHERE Object.Id = vbPersonalId);
     
     --
     OPEN Cursor1 FOR
       WITH tmpCorrective AS (SELECT MLM_TaxCorrective.MovementId, MLM_TaxCorrective.MovementChildId
                              FROM MovementLinkMovement AS MLM_TaxCorrective
                              WHERE MLM_TaxCorrective.MovementChildId = inMovementId
                                AND MLM_TaxCorrective.DescId = zc_MovementLinkMovement_Master()
                              LIMIT 1)
       SELECT
             Movement.Id                                AS Id
           , zfFormat_BarCode (zc_BarCodePref_Movement(), Movement.Id) AS IdBarCode
           , Movement.InvNumber                         AS InvNumber
           , COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) AS OperDate
           , Object_Status.ObjectCode                   AS StatusCode
           , Object_Status.ValueData         	        AS StatusName

           , COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) AS OperDatePartner
           , CASE WHEN Movement.DescId = zc_Movement_ReturnIn()
                       THEN MovementString_InvNumberPartner.ValueData
                  WHEN Movement.DescId = zc_Movement_TransferDebtIn() AND MovementString_InvNumberPartner.ValueData <> ''
                       THEN COALESCE (MovementString_InvNumberPartner.ValueData, Movement.InvNumber)
                  WHEN Movement.DescId = zc_Movement_TransferDebtIn() AND MovementString_InvNumberPartner.ValueData = ''
                       THEN Movement.InvNumber
                  ELSE COALESCE (MovementString_InvNumberPartner.ValueData, Movement.InvNumber)
             END AS InvNumberPartner

           , MovementString_InvNumberMark.ValueData         AS InvNumberMark
           , vbPriceWithVAT                                 AS PriceWithVAT
           , vbVATPercent                                   AS VATPercent
           , vbExtraChargesPercent - vbDiscountPercent      AS ChangePercent

           , MovementFloat_TotalCount.ValueData             AS TotalCount
           , MovementFloat_TotalCountKg.ValueData           AS TotalCountKg
           , MovementFloat_TotalCountSh.ValueData           AS TotalCountSh

           , CASE WHEN Movement.DescId = zc_Movement_PriceCorrective() THEN 1 ELSE 1 END * MovementFloat_TotalSummMVAT.ValueData AS TotalSummMVAT
           , CASE WHEN Movement.DescId = zc_Movement_PriceCorrective() THEN 1 ELSE 1 END * MovementFloat_TotalSummPVAT.ValueData AS TotalSummPVAT
           , CASE WHEN Movement.DescId = zc_Movement_PriceCorrective() THEN 1 ELSE 1 END * (MovementFloat_TotalSummPVAT.ValueData - MovementFloat_TotalSummMVAT.ValueData) AS SummVAT
           , CASE WHEN Movement.DescId = zc_Movement_PriceCorrective() THEN 1 ELSE 1 END * MovementFloat_TotalSumm.ValueData AS TotalSumm

           , CASE WHEN Movement.DescId = zc_Movement_PriceCorrective() THEN -1 ELSE 1 END * MovementFloat_TotalSummMVAT.ValueData AS TotalSummMVAT_sign
           , CASE WHEN Movement.DescId = zc_Movement_PriceCorrective() THEN -1 ELSE 1 END * MovementFloat_TotalSummPVAT.ValueData AS TotalSummPVAT_sign
           , CASE WHEN Movement.DescId = zc_Movement_PriceCorrective() THEN -1 ELSE 1 END * (MovementFloat_TotalSummPVAT.ValueData - MovementFloat_TotalSummMVAT.ValueData) AS SummVAT_sign
           , CASE WHEN Movement.DescId = zc_Movement_PriceCorrective() THEN -1 ELSE 1 END * MovementFloat_TotalSumm.ValueData AS TotalSumm_sign

           , COALESCE (Object_Partner.ValueData, Object_From.ValueData) AS FromName
           , Object_To.ValueData               		    AS ToName
           , (Object_PaidKind.Id - 2) :: TVarChar           AS PaidKindName_user
           , Object_PaidKind.ValueData         		    AS PaidKindName
           , View_Contract.InvNumber        		    AS ContractName
           , ObjectDate_Signing.ValueData                   AS ContractSigningDate
           , View_Contract.ContractKindName                 AS ContractKind

           , ObjectString_FromAddress.ValueData             AS PartnerAddress_From
           , OH_JuridicalDetails_From.FullName              AS JuridicalName_From
           , OH_JuridicalDetails_From.JuridicalAddress      AS JuridicalAddress_From
           , OH_JuridicalDetails_From.OKPO                  AS OKPO_From
           , OH_JuridicalDetails_From.INN                   AS INN_From
           , OH_JuridicalDetails_From.NumberVAT             AS NumberVAT_From
           , OH_JuridicalDetails_From.AccounterName         AS AccounterName_From
           , OH_JuridicalDetails_From.Phone                 AS Phone_From

           , OH_JuridicalDetails_To.FullName                AS JuridicalName_To
           , OH_JuridicalDetails_To.JuridicalAddress        AS JuridicalAddress_To
           , OH_JuridicalDetails_To.OKPO                    AS OKPO_To
           , OH_JuridicalDetails_To.INN                     AS INN_To
           , OH_JuridicalDetails_To.NumberVAT               AS NumberVAT_To
           , OH_JuridicalDetails_To.AccounterName           AS AccounterName_To
           , OH_JuridicalDetails_To.Phone                   AS Phone_To

           , COALESCE (Object_Member_Driver.ValueData, vbPersonalName)  AS MemberName_Driver
           --, vbPersonalName                                 AS PersonalName         -- ���������� 

           , CASE WHEN ObjectLink_Contract_JuridicalDocument.ChildObjectId > 0 THEN TRUE ELSE FALSE END AS isJuridicalDocument

           , (SELECT MS_InvNumberPartner.ValueData
              FROM MovementLinkMovement AS MLM_Master
                   LEFT JOIN MovementString AS MS_InvNumberPartner ON MS_InvNumberPartner.MovementId = MLM_Master.MovementId
                                                                  AND MS_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
              WHERE MLM_Master.MovementChildId = inMovementId
                AND MLM_Master.DescId = zc_MovementLinkMovement_Master()
             LIMIT 1) AS InvNumberPartner_TaxCorrective

           , Movement_Sale.InvNumber                        AS InvNumber_Sale
           , MovementString_InvNumberPartner_Sale.ValueData AS InvNumberPartner_Sale
           , CASE WHEN zfConvert_StringToNumber (MovementString_InvNumberOrder_Sale.ValueData) <> 0
                       THEN zfConvert_StringToNumber (MovementString_InvNumberOrder_Sale.ValueData) :: TVarChar
                  ELSE MovementString_InvNumberOrder_Sale.ValueData
             END AS InvNumberOrder_Sale
           , MovementDate_OperDatePartner_Sale.ValueData    AS OperDatePartner_Sale

           -- , CASE WHEN View_Contract.InfoMoneyId = zc_Enum_InfoMoney_30101() THEN '������� �.�.' ELSE '' END AS StoreKeeper -- ���������
           , vbStoreKeeperName                              AS StoreKeeper
           , Object_BankAccount.Name                        AS BankAccount_ByContract
           , Object_BankAccount.MFO                         AS BankMFO_ByContract
           , Object_BankAccount.BankName                    AS BankName_ByContract

           , MovementString_Comment.ValueData               AS Comment

       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId     = zc_MovementString_Comment()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_DocumentTaxKind
                                         ON MovementLinkObject_DocumentTaxKind.MovementId = Movement.Id
                                        AND MovementLinkObject_DocumentTaxKind.DescId = zc_MovementLinkObject_DocumentTaxKind()

            LEFT JOIN tmpCorrective ON tmpCorrective.MovementChildId = Movement.Id

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_child
                                           ON MovementLinkMovement_child.MovementId = tmpCorrective.MovementId
                                          AND MovementLinkMovement_child.DescId = zc_MovementLinkMovement_Child()
            LEFT JOIN MovementLinkObject AS MovementLinkObject_DocumentTaxKind_Child
                                         ON MovementLinkObject_DocumentTaxKind_Child.MovementId = MovementLinkMovement_child.MovementChildId
                                        AND MovementLinkObject_DocumentTaxKind_Child.DescId = zc_MovementLinkObject_DocumentTaxKind()

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


            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId =  Movement.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
            LEFT JOIN MovementString AS MovementString_InvNumberMark
                                     ON MovementString_InvNumberMark.MovementId =  Movement.Id
                                    AND MovementString_InvNumberMark.DescId = zc_MovementString_InvNumberMark()

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()
            LEFT JOIN MovementFloat AS MovementFloat_TotalCountKg
                                    ON MovementFloat_TotalCountKg.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCountKg.DescId = zc_MovementFloat_TotalCountKg()
            LEFT JOIN MovementFloat AS MovementFloat_TotalCountSh
                                    ON MovementFloat_TotalCountSh.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCountSh.DescId = zc_MovementFloat_TotalCountSh()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummMVAT
                                    ON MovementFloat_TotalSummMVAT.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummMVAT.DescId = zc_MovementFloat_TotalSummMVAT()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummPVAT
                                    ON MovementFloat_TotalSummPVAT.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummPVAT.DescId = zc_MovementFloat_TotalSummPVAT()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PartnerFrom
                                         ON MovementLinkObject_PartnerFrom.MovementId = Movement.Id
                                        AND MovementLinkObject_PartnerFrom.DescId = zc_MovementLinkObject_PartnerFrom()
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = MovementLinkObject_PartnerFrom.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
            LEFT JOIN ObjectString AS ObjectString_FromAddress
                                   ON ObjectString_FromAddress.ObjectId = COALESCE (MovementLinkObject_PartnerFrom.ObjectId, Object_From.Id)
                                  AND ObjectString_FromAddress.DescId = zc_ObjectString_Partner_Address()



            LEFT JOIN MovementLinkObject AS MovementLinkObject_Member_Driver
                                         ON MovementLinkObject_Member_Driver.MovementId = Movement.Id
                                        AND MovementLinkObject_Member_Driver.DescId = zc_MovementLinkObject_Member()
            LEFT JOIN Object AS Object_Member_Driver ON Object_Member_Driver.Id = MovementLinkObject_Member_Driver.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            /*LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                         ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                        AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()*/
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = vbPaidKindId -- MovementLinkObject_PaidKind.ObjectId

            /*LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId IN (zc_MovementLinkObject_Contract(), zc_MovementLinkObject_ContractFrom())*/
            LEFT JOIN Object_Contract_View AS View_Contract ON View_Contract.ContractId = vbContractId -- MovementLinkObject_Contract.ObjectId
            LEFT JOIN ObjectDate AS ObjectDate_Signing
                                 ON ObjectDate_Signing.ObjectId = vbContractId -- MovementLinkObject_Contract.ObjectId
                                AND ObjectDate_Signing.DescId = zc_ObjectDate_Contract_Signing()
                                AND View_Contract.InvNumber <> '-'

            LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalDocument
                                 ON ObjectLink_Contract_JuridicalDocument.ObjectId = vbContractId -- MovementLinkObject_Contract.ObjectId
                                AND ObjectLink_Contract_JuridicalDocument.DescId = zc_ObjectLink_Contract_JuridicalDocument()
                                AND vbPaidKindId = zc_Enum_PaidKind_SecondForm()

-- ============================
            --�� ����������� ������� ��.����
            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                 ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                                AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()

            LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_From
                                                                ON OH_JuridicalDetails_From.JuridicalId = COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, Object_From.Id)
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) >= OH_JuridicalDetails_From.StartDate
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) <  OH_JuridicalDetails_From.EndDate

            LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_To
                                                                ON OH_JuridicalDetails_To.JuridicalId = COALESCE (ObjectLink_Contract_JuridicalDocument.ChildObjectId, COALESCE (View_Contract.JuridicalBasisId, Object_To.Id))
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) >= OH_JuridicalDetails_To.StartDate
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) <  OH_JuridicalDetails_To.EndDate
-- bank account
            LEFT JOIN ObjectLink AS ObjectLink_Contract_BankAccount
                                 ON ObjectLink_Contract_BankAccount.ObjectId = View_Contract.ContractId
                                AND ObjectLink_Contract_BankAccount.DescId = zc_ObjectLink_Contract_BankAccount()

            LEFT JOIN Object_BankAccount_View AS Object_BankAccount ON Object_BankAccount.Id = ObjectLink_Contract_BankAccount.ChildObjectId


       WHERE Movement.Id =  inMovementId
         -- AND Movement.StatusId = zc_Enum_Status_Complete()
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
             , tmpObject_GoodsPropertyValue.BarCode
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
      , tmpMIPartionMovement AS (SELECT MovementItem.Id                               AS MovementItemId
                                      , MIPartionMovement.ObjectId                    AS GoodsId
                                      , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                                      , SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0)) AS AmountPartner
                                 FROM MovementItem
                                     LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                                                 ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                                AND MIFloat_MovementId.DescId = zc_MIFloat_MovementId()
                                       
                                     LEFT JOIN MovementItem AS MIPartionMovement
                                                            ON MIPartionMovement.MovementId = MIFloat_MovementId.ValueData :: Integer
                                                           AND MIPartionMovement.ObjectId   = MovementItem.ObjectId
                                                           AND MIPartionMovement.isErased   = FALSE
       
                                     LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                                 ON MIFloat_AmountPartner.MovementItemId = MIPartionMovement.Id
                                                                AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                                     LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                      ON MILinkObject_GoodsKind.MovementItemId = MIPartionMovement.Id
                                                                     AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                                                
                                 WHERE MovementItem.MovementId = inMovementId
                                   AND MovementItem.DescId     = zc_MI_Master()
                                   AND MovementItem.isErased   = FALSE
                                 GROUP BY MovementItem.Id
                                        , MIPartionMovement.ObjectId
                                        , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                                 )
           
       SELECT
             Object_Goods.ObjectCode  			AS GoodsCode
           , (CASE WHEN tmpObject_GoodsPropertyValue.Name <> '' THEN tmpObject_GoodsPropertyValue.Name WHEN tmpObject_GoodsPropertyValue_basis.Name <> '' THEN tmpObject_GoodsPropertyValue_basis.Name ELSE Object_Goods.ValueData || CASE WHEN COALESCE (Object_GoodsKind.Id, zc_Enum_GoodsKind_Main()) = zc_Enum_GoodsKind_Main() THEN '' ELSE ' ' || Object_GoodsKind.ValueData END END) :: TVarChar AS GoodsName
           , CASE WHEN tmpObject_GoodsPropertyValue.Name <> '' THEN tmpObject_GoodsPropertyValue.Name WHEN tmpObject_GoodsPropertyValue_basis.Name <> '' THEN tmpObject_GoodsPropertyValue_basis.Name ELSE Object_Goods.ValueData END AS GoodsName_two
           , Object_GoodsKind.ValueData      AS GoodsKindName
           , Object_Measure.ValueData        AS MeasureName

           , tmpMI.Amount                    AS Amount
           , tmpMI.AmountPartner             AS AmountPartner_abs
           , CASE WHEN Movement.DescId <> zc_Movement_PriceCorrective() THEN 1 ELSE -1 END * tmpMI.AmountPartner              AS AmountPartner
           , tmpMI.AmountPartner_PartionMovement
           
           , CASE WHEN Movement.DescId = zc_Movement_PriceCorrective() THEN -1 ELSE 1 END * tmpMI.Price / tmpMI.CountForPrice AS Price
           , tmpMI.CountForPrice             AS CountForPrice
           , CASE WHEN Movement.DescId = zc_Movement_PriceCorrective() THEN -1 ELSE 0 END * tmpMI.AmountPartner              AS AmountPartner_ashan

           , COALESCE (tmpObject_GoodsPropertyValue.Name, '')       AS GoodsName_Juridical
           , COALESCE (tmpObject_GoodsPropertyValue.Amount, 0)      AS AmountInPack_Juridical
           , COALESCE (tmpObject_GoodsPropertyValueGroup.Article, COALESCE (tmpObject_GoodsPropertyValue.Article, '')) AS Article_Juridical
           , COALESCE (tmpObject_GoodsPropertyValueGroup.BarCode, COALESCE (tmpObject_GoodsPropertyValue.BarCode, '')) AS BarCode_Juridical
           , COALESCE (tmpObject_GoodsPropertyValue.ArticleGLN, '') AS ArticleGLN_Juridical
           , COALESCE (tmpObject_GoodsPropertyValue.BarCodeGLN, '') AS BarCodeGLN_Juridical

             -- ����� �� ����� ���-��
           , CASE WHEN Movement.DescId = zc_Movement_PriceCorrective() THEN -1 ELSE 1 END
           * CASE WHEN tmpMI.CountForPrice <> 0
                       THEN CAST (tmpMI.AmountPartner * (tmpMI.Price / tmpMI.CountForPrice) AS NUMERIC (16, 2))
                  ELSE CAST (tmpMI.AmountPartner * tmpMI.Price AS NUMERIC (16, 2))
             END AS AmountSumm

             -- ������ ���� ��� ���, �� 4 ������
           , CASE WHEN Movement.DescId = zc_Movement_PriceCorrective() THEN -1 ELSE 1 END
           * CASE WHEN vbPriceWithVAT = TRUE
                  THEN CAST (tmpMI.Price - tmpMI.Price * (vbVATPercent / 100) AS NUMERIC (16, 4))
                  ELSE tmpMI.Price
             END / tmpMI.CountForPrice
             AS PriceNoVAT

             -- ������ ���� � ���, �� 4 ������
           , CASE WHEN vbPriceWithVAT <> TRUE
                  THEN CAST (tmpMI.Price + tmpMI.Price * (vbVATPercent / 100) AS NUMERIC (16, 4))
                  ELSE tmpMI.Price
             END / tmpMI.CountForPrice
             AS PriceWVAT

             -- ������ ����� ��� ���, �� 2 ������
           , CAST (tmpMI.AmountPartner * CASE WHEN vbPriceWithVAT = TRUE
                                              THEN (tmpMI.Price - tmpMI.Price * (vbVATPercent / 100))
                                              ELSE tmpMI.Price
                                         END / CASE WHEN tmpMI.CountForPrice <> 0 THEN tmpMI.CountForPrice ELSE 1 END
                   AS NUMERIC (16, 2)) AS AmountSummNoVAT

             -- ������ ����� � ���, �� 3 ������
           , CAST (tmpMI.AmountPartner * CASE WHEN vbPriceWithVAT <> TRUE
                                              THEN tmpMI.Price + tmpMI.Price * (vbVATPercent / 100)
                                              ELSE tmpMI.Price
                                         END / CASE WHEN tmpMI.CountForPrice <> 0 THEN tmpMI.CountForPrice ELSE 1 END
                   AS NUMERIC (16, 3)) AS AmountSummWVAT

       FROM (SELECT MovementItem.ObjectId AS GoodsId
                  , MovementItem.MovementId
                  , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                  , CASE WHEN MIFloat_ChangePercent.ValueData <> 0 AND vbIsChangePrice = TRUE -- !!!��� ��� �� ���������, �� �� ������!!!
                              THEN zfCalc_PriceTruncate (inOperDate     := vbOperDatePartner
                                                       , inChangePercent:= MIFloat_ChangePercent.ValueData
                                                       , inPrice        := MIFloat_Price.ValueData
                                                       , inIsWithVAT    := vbPriceWithVAT
                                                        )
                         WHEN vbDiscountPercent <> 0 AND vbIsChangePrice = TRUE AND vbDescId <> zc_Movement_ReturnIn()
                              THEN zfCalc_PriceTruncate (inOperDate     := vbOperDatePartner
                                                       , inChangePercent:= -1 * vbDiscountPercent
                                                       , inPrice        := MIFloat_Price.ValueData
                                                       , inIsWithVAT    := vbPriceWithVAT
                                                        )
                         WHEN vbExtraChargesPercent <> 0 AND vbIsChangePrice = TRUE AND vbDescId <> zc_Movement_ReturnIn()
                              THEN zfCalc_PriceTruncate (inOperDate     := vbOperDatePartner
                                                       , inChangePercent:= 1 * vbExtraChargesPercent
                                                       , inPrice        := MIFloat_Price.ValueData
                                                       , inIsWithVAT    := vbPriceWithVAT
                                                        )
                         ELSE COALESCE (MIFloat_Price.ValueData, 0)
                    END AS Price
                  , CASE WHEN MIFloat_CountForPrice.ValueData <> 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END AS CountForPrice
                  , (MovementItem.Amount) AS Amount
                  , (CASE WHEN Movement.DescId IN (zc_Movement_ReturnIn(), zc_Movement_SendOnPrice())
                                   THEN COALESCE (MIFloat_AmountPartner.ValueData, 0)
                                   ELSE MovementItem.Amount
                     END) AS AmountPartner
                  , (tmpMIPartionMovement.AmountPartner) AS AmountPartner_PartionMovement
             FROM MovementItem
                  LEFT JOIN MovementItemFloat AS MIFloat_Price
                                              ON MIFloat_Price.MovementItemId = MovementItem.Id
                                             AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                              -- AND MIFloat_Price.ValueData <> 0
                  LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                              ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                             AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()

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

                  LEFT JOIN tmpMIPartionMovement ON tmpMIPartionMovement.MovementItemId = MovementItem.Id
                                                AND tmpMIPartionMovement.GoodsId = MovementItem.ObjectId
                                                AND tmpMIPartionMovement.GoodsKindId = COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                                                  
             WHERE MovementItem.MovementId = inMovementId
               AND MovementItem.DescId     = zc_MI_Master()
               AND MovementItem.isErased   = FALSE
            ) AS tmpMI

            LEFT JOIN Movement ON Movement.Id = tmpMI.MovementId
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMI.GoodsKindId

            LEFT JOIN tmpObject_GoodsPropertyValue ON tmpObject_GoodsPropertyValue.GoodsId = tmpMI.GoodsId
                                                  AND tmpObject_GoodsPropertyValue.GoodsKindId = tmpMI.GoodsKindId
            LEFT JOIN tmpObject_GoodsPropertyValueGroup ON tmpObject_GoodsPropertyValueGroup.GoodsId = tmpMI.GoodsId
                                                       AND tmpObject_GoodsPropertyValue.GoodsId IS NULL
            LEFT JOIN tmpObject_GoodsPropertyValue_basis ON tmpObject_GoodsPropertyValue_basis.GoodsId = tmpMI.GoodsId
                                                        AND tmpObject_GoodsPropertyValue_basis.GoodsKindId = tmpMI.GoodsKindId
          
       WHERE tmpMI.AmountPartner <> 0
       ORDER BY Object_Goods.ValueData, Object_GoodsKind.ValueData
       ;
    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_ReturnIn_Print (Integer,TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 09.09.15         * add tmpMIPartionMovement
 28.01.15                                                       *
 16.07.14                                        * add tmpObject_GoodsPropertyValueGroup
 20.06.14                                                       * change InvNumberPartner
 17.06.14                                                       *
 12.06.14                                        * restore ContractSigningDate
 05.06.14                                        * restore ContractSigningDate
 04.06.14                                        * add tmpObject_GoodsPropertyValue.Name
 20.05.14                                        * add Object_Contract_View
 17.05.14                                        * add StatusId = zc_Enum_Status_Complete
 08.05.14                                        * all
 16.05.14                                        * add Object_Contract_InvNumber_View
 13.05.14                                        * add calc GoodsName
 23.04.14                                        * add InvNumberMark
 23.04.14                                                       *
 09.04.14                                        * add InvNumberPartner and JOIN MIFloat_AmountPartner
 07.02.14                                                       * change to Cursor
 06.02.14                                                       *
*/

-- ����
-- SELECT * FROM gpSelect_Movement_ReturnIn_Print (inMovementId:= 672146, inSession:= '2'); -- FETCH ALL "<unnamed portal 2>";
