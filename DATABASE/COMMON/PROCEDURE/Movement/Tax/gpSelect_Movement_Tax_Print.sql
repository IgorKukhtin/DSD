 -- Function: gpSelect_Movement_Tax_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_Tax_Print (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Tax_Print(
    IN inMovementId        Integer  , -- ���� ���������
    IN inisClientCopy      Boolean  , -- ����� ��� �������
    IN inSession           TVarChar    -- ������ ������������
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

    DECLARE vbMovementId_Sale Integer;
    DECLARE vbMovementId_Tax Integer;
    DECLARE vbStatusId_Tax Integer;
    DECLARE vbDocumentTaxKindId Integer;

    DECLARE vbCurrencyPartnerId Integer;

    DECLARE vbOperDate_begin TDateTime;

    DECLARE vbPriceWithVAT Boolean;
    DECLARE vbVATPercent TFloat;
    DECLARE vbNotNDSPayer_INN TVarChar;
 
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Sale());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!�������!!!
     vbNotNDSPayer_INN := '100000000000';

     -- ������������ <��������� ��������> � ��� ���������
     SELECT COALESCE (tmpMovement.MovementId_Tax, 0)                  AS MovementId_Tax
          , Movement_Tax.StatusId                                     AS StatusId_Tax
          , MovementLinkObject_DocumentTaxKind.ObjectId               AS DocumentTaxKindId
          , COALESCE (MovementBoolean_PriceWithVAT.ValueData, TRUE)   AS PriceWithVAT
          , COALESCE (MovementFloat_VATPercent.ValueData, 0)          AS VATPercent
          , COALESCE (MovementLinkObject_CurrencyPartner.ObjectId, zc_Enum_Currency_Basis()) AS CurrencyPartnerId
          , zfCalc_GoodsPropertyId (MovementLinkObject_Contract.ObjectId, MovementLinkObject_To.ObjectId, 0) AS GoodsPropertyId
          , zfCalc_GoodsPropertyId (0, zc_Juridical_Basis(), 0)       AS GoodsPropertyId_basis
          -- , ObjectLink_Juridical_GoodsProperty.ChildObjectId         AS GoodsPropertyId
          -- , ObjectLink_JuridicalBasis_GoodsProperty.ChildObjectId    AS GoodsPropertyId_basis

          , CASE WHEN MovementDate_DateRegistered.ValueData > Movement_Tax.OperDate THEN MovementDate_DateRegistered.ValueData ELSE Movement_Tax.OperDate END AS OperDate_begin
          
            INTO vbMovementId_Tax, vbStatusId_Tax, vbDocumentTaxKindId, vbPriceWithVAT, vbVATPercent, vbCurrencyPartnerId, vbGoodsPropertyId, vbGoodsPropertyId_basis
               , vbOperDate_begin
     FROM (SELECT CASE WHEN Movement.DescId = zc_Movement_Tax()
                            THEN inMovementId
                       ELSE MovementLinkMovement_Master.MovementChildId
                  END AS MovementId_Tax
           FROM Movement
                LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Master
                                               ON MovementLinkMovement_Master.MovementId = Movement.Id
                                              AND MovementLinkMovement_Master.DescId = zc_MovementLinkMovement_Master()
           WHERE Movement.Id = inMovementId
          ) AS tmpMovement
          LEFT JOIN Movement AS Movement_Tax ON Movement_Tax.Id = tmpMovement.MovementId_Tax

          LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Master
                                         ON MovementLinkMovement_Master.MovementChildId = tmpMovement.MovementId_Tax
                                        AND MovementLinkMovement_Master.DescId = zc_MovementLinkMovement_Master()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_CurrencyPartner
                                       ON MovementLinkObject_CurrencyPartner.MovementId = MovementLinkMovement_Master.MovementId
                                      AND MovementLinkObject_CurrencyPartner.DescId = zc_MovementLinkObject_CurrencyPartner()

          LEFT JOIN MovementDate AS MovementDate_DateRegistered
                                 ON MovementDate_DateRegistered.MovementId = tmpMovement.MovementId_Tax
                                AND MovementDate_DateRegistered.DescId = zc_MovementDate_DateRegistered()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_DocumentTaxKind
                                       ON MovementLinkObject_DocumentTaxKind.MovementId = tmpMovement.MovementId_Tax
                                      AND MovementLinkObject_DocumentTaxKind.DescId = zc_MovementLinkObject_DocumentTaxKind()
          LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                    ON MovementBoolean_PriceWithVAT.MovementId = tmpMovement.MovementId_Tax
                                   AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
          LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                  ON MovementFloat_VATPercent.MovementId = tmpMovement.MovementId_Tax
                                 AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                       ON MovementLinkObject_Contract.MovementId = tmpMovement.MovementId_Tax
                                      AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = tmpMovement.MovementId_Tax
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

          /*LEFT JOIN ObjectLink AS ObjectLink_Juridical_GoodsProperty
                               ON ObjectLink_Juridical_GoodsProperty.ObjectId = MovementLinkObject_To.ObjectId
                              AND ObjectLink_Juridical_GoodsProperty.DescId = zc_ObjectLink_Juridical_GoodsProperty()
          LEFT JOIN ObjectLink AS ObjectLink_JuridicalBasis_GoodsProperty
                               ON ObjectLink_JuridicalBasis_GoodsProperty.ObjectId = zc_Juridical_Basis()
                              AND ObjectLink_JuridicalBasis_GoodsProperty.DescId = zc_ObjectLink_Juridical_GoodsProperty()
                              -- AND ObjectLink_Juridical_GoodsProperty.ChildObjectId IS NULL*/
     ;

     -- ����� ������ ��������
     IF COALESCE (vbMovementId_Tax, 0) = 0 OR COALESCE (vbStatusId_Tax, 0) <> zc_Enum_Status_Complete()
     THEN
         IF COALESCE (vbMovementId_Tax, 0) = 0
         THEN
             RAISE EXCEPTION '������.�������� <%> �� ������.', (SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_Tax());
         END IF;
         IF vbStatusId_Tax = zc_Enum_Status_Erased()
         THEN
             RAISE EXCEPTION '������.�������� <%> � <%> �� <%> ������.', (SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_Tax()), (SELECT ValueData FROM MovementString WHERE MovementId = vbMovementId_Tax AND DescId = zc_MovementString_InvNumberPartner()), (SELECT DATE (OperDate) FROM Movement WHERE Id = vbMovementId_Tax);
         END IF;
         IF vbStatusId_Tax = zc_Enum_Status_UnComplete()
         THEN
             RAISE EXCEPTION '������.�������� <%> � <%> �� <%> �� ��������.', (SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_Tax()), (SELECT ValueData FROM MovementString WHERE MovementId = vbMovementId_Tax AND DescId = zc_MovementString_InvNumberPartner()), (SELECT DATE (OperDate) FROM Movement WHERE Id = vbMovementId_Tax);
         END IF;
         -- ��� ��� �������� ������
         RAISE EXCEPTION '������.�������� <%>.', (SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_Tax());
     END IF;


     -- ������������ <������� ����������> ��� <������� ����� (������)>
     SELECT COALESCE(CASE WHEN Movement.DescId IN (zc_Movement_Sale(), zc_Movement_TransferDebtOut())
                               THEN inMovementId
                          ELSE MovementLinkMovement_Master.MovementId
                     END, 0)
            INTO vbMovementId_Sale
     FROM Movement
          LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Master
                                         ON MovementLinkMovement_Master.MovementChildId = Movement.Id
                                        AND MovementLinkMovement_Master.DescId = zc_MovementLinkMovement_Master()
     WHERE Movement.Id = inMovementId;


     -- ������ �� ��������� ���������
     OPEN Cursor1 FOR
       SELECT
             Movement.Id                                AS Id
           , Movement.InvNumber                         AS InvNumber
           , Movement.OperDate                          AS OperDate
           , CASE WHEN Movement.OperDate < '01.01.2015' THEN 'J1201006' WHEN vbOperDate_begin < '01.04.2016' THEN 'J1201007' ELSE 'J1201008' END ::TVarChar AS CHARCODE
           -- , '������ �.�.'::TVarChar                    AS N10
           , CASE WHEN Object_PersonalSigning.PersonalName <> '' 
                  THEN zfConvert_FIO (Object_PersonalSigning.PersonalName, 1)
                  ELSE CASE WHEN Object_PersonalBookkeeper_View.PersonalName <> '' 
                            THEN zfConvert_FIO (Object_PersonalBookkeeper_View.PersonalName, 1)
                            ELSE '����� �.�.' 
                       END 
             END                            :: TVarChar AS N10
           , '������ � ��������� �������'::TVarChar     AS N9
/*
           , CASE WHEN OH_JuridicalDetails_To.INN = vbNotNDSPayer_INN
                  THEN ''
             ELSE CAST (REPEAT (' ', 7 - LENGTH (MovementString_InvNumberPartner.ValueData)) || MovementString_InvNumberPartner.ValueData AS TVarChar)
             END                                        AS InvNumberPartner
*/
           ,  CAST (REPEAT (' ', 7 - LENGTH (MovementString_InvNumberPartner.ValueData)) || MovementString_InvNumberPartner.ValueData AS TVarChar) AS InvNumberPartner

           , vbPriceWithVAT                             AS PriceWithVAT
           , vbVATPercent                               AS VATPercent

           , CASE WHEN vbCurrencyPartnerId = zc_Enum_Currency_Basis() and COALESCE (ObjectBoolean_Vat.ValueData, False) = False THEN MovementFloat_TotalSummMVAT.ValueData ELSE 0 END AS TotalSummMVAT
           , CASE WHEN vbCurrencyPartnerId = zc_Enum_Currency_Basis() and COALESCE (ObjectBoolean_Vat.ValueData, False) = False THEN MovementFloat_TotalSummPVAT.ValueData ELSE 0 END AS TotalSummPVAT
           , CASE WHEN vbCurrencyPartnerId = zc_Enum_Currency_Basis() and COALESCE (ObjectBoolean_Vat.ValueData, False) = False THEN COALESCE (MovementFloat_TotalSummPVAT.ValueData, 0) - COALESCE (MovementFloat_TotalSummMVAT.ValueData, 0) ELSE 0 END AS SummVAT
           , MovementFloat_TotalSumm.ValueData AS TotalSumm

           , CASE WHEN vbCurrencyPartnerId = zc_Enum_Currency_Basis() and COALESCE (ObjectBoolean_Vat.ValueData, False) = False THEN 0 ELSE MovementFloat_TotalSummMVAT.ValueData END AS TotalSummMVAT_11
           , CASE WHEN vbCurrencyPartnerId = zc_Enum_Currency_Basis() and COALESCE (ObjectBoolean_Vat.ValueData, False) = False THEN 0 ELSE MovementFloat_TotalSummPVAT.ValueData END AS TotalSummPVAT_11
           , CASE WHEN vbCurrencyPartnerId = zc_Enum_Currency_Basis() and COALESCE (ObjectBoolean_Vat.ValueData, False) = False THEN 0 ELSE COALESCE (MovementFloat_TotalSummPVAT.ValueData, 0) - COALESCE (MovementFloat_TotalSummMVAT.ValueData, 0) END AS SummVAT_11

           , Object_From.ValueData             		    AS FromName
           , Object_To.ValueData               		    AS ToName

           , View_Contract.InvNumber         		    AS ContractName
           , ObjectDate_Signing.ValueData               AS ContractSigningDate
           , View_Contract.ContractKindName             AS ContractKind

           , ObjectString_ToAddress.ValueData           AS PartnerAddress_To

           --, OH_JuridicalDetails_To.FullName            AS JuridicalName_To
           , CASE WHEN OH_JuridicalDetails_To.INN = vbNotNDSPayer_INN
                  THEN '���������'
             ELSE OH_JuridicalDetails_To.FullName END   AS JuridicalName_To
           , CASE WHEN OH_JuridicalDetails_To.INN = vbNotNDSPayer_INN
                  THEN ''
             ELSE OH_JuridicalDetails_To.JuridicalAddress END AS JuridicalAddress_To


--           , OH_JuridicalDetails_To.JuridicalAddress    AS JuridicalAddress_To
           , OH_JuridicalDetails_To.OKPO                AS OKPO_To
           , OH_JuridicalDetails_To.INN                 AS INN_To
           , OH_JuridicalDetails_To.NumberVAT           AS NumberVAT_To
           , OH_JuridicalDetails_To.AccounterName       AS AccounterName_To
           , OH_JuridicalDetails_To.BankAccount         AS BankAccount_To
           , OH_JuridicalDetails_To.BankName            AS BankName_To
           , OH_JuridicalDetails_To.MFO                 AS BankMFO_To
--           , OH_JuridicalDetails_To.Phone               AS Phone_To
           , CASE WHEN OH_JuridicalDetails_To.INN = vbNotNDSPayer_INN
                  THEN ''
             ELSE OH_JuridicalDetails_To.Phone END      AS Phone_To


           /*, ObjectString_BuyerGLNCode.ValueData        AS BuyerGLNCode
           , ObjectString_SupplierGLNCode.ValueData     AS SupplierGLNCode*/
           , zfCalc_GLNCodeJuridical (inGLNCode                  := 'ok'
                                    , inGLNCodeJuridical_partner := ObjectString_Partner_GLNCodeJuridical.ValueData
                                    , inGLNCodeJuridical         := ObjectString_Juridical_GLNCode.ValueData
                                     ) AS BuyerGLNCode

           , zfCalc_GLNCodeCorporate (inGLNCode                  := 'ok'
                                    , inGLNCodeCorporate_partner := ObjectString_Partner_GLNCodeCorporate.ValueData
                                    , inGLNCodeCorporate_retail  := ObjectString_Retail_GLNCodeCorporate.ValueData
                                    , inGLNCodeCorporate_main    := ObjectString_JuridicalFrom_GLNCode.ValueData
                                     ) AS SupplierGLNCode

           , OH_JuridicalDetails_From.FullName          AS JuridicalName_From
           , OH_JuridicalDetails_From.JuridicalAddress  AS JuridicalAddress_From
           , OH_JuridicalDetails_From.OKPO              AS OKPO_From
           , OH_JuridicalDetails_From.INN               AS INN_From
           , OH_JuridicalDetails_From.NumberVAT         AS NumberVAT_From
           , CASE WHEN Object_PersonalSigning.PersonalName <> '' 
                  THEN zfConvert_FIO (Object_PersonalSigning.PersonalName, 1)
                  ELSE CASE WHEN Object_PersonalBookkeeper_View.PersonalName <> '' 
                            THEN zfConvert_FIO (Object_PersonalBookkeeper_View.PersonalName, 1)
                            ELSE '����� �.�.' 
                       END
              END                           :: TVarChar AS AccounterName_From
           , CASE WHEN Object_PersonalSigning.PersonalName <> '' 
                  THEN PersonalSigning_INN.ValueData
                  ELSE CASE WHEN Object_PersonalBookkeeper_View.PersonalName <> '' 
                            THEN PersonalBookkeeper_INN.ValueData
                            ELSE '2649713447' 
                       END
              END                           :: TVarChar AS AccounterINN_From
           , OH_JuridicalDetails_From.BankAccount       AS BankAccount_From
           , OH_JuridicalDetails_From.BankName          AS BankName_From
           , OH_JuridicalDetails_From.MFO               AS BankMFO_From
           , OH_JuridicalDetails_From.Phone             AS Phone_From

           , MovementString_InvNumberPartnerEDI.ValueData  AS InvNumberPartnerEDI
           , COALESCE (MovementDate_COMDOC.ValueData, COALESCE (Movement_EDI.OperDate, MovementDate_OperDatePartnerEDI.ValueData))    AS OperDatePartnerEDI_tax
           , COALESCE (MovementDate_COMDOC.ValueData, COALESCE (Movement_EDI.OperDate, MovementDate_OperDatePartnerEDI.ValueData))    AS OperDatePartnerEDI

           , CASE WHEN inisClientCopy = TRUE
                  THEN 'X' ELSE '' END                  AS CopyForClient
           , CASE WHEN inisClientCopy = TRUE
                  THEN '' ELSE 'X' END                  AS CopyForUs
           , CASE WHEN (COALESCE (MovementFloat_TotalSummPVAT.ValueData, 0) - COALESCE (MovementFloat_TotalSummMVAT.ValueData, 0)) > 10000
                  THEN 'X' ELSE '' END                  AS ERPN

           , CASE WHEN OH_JuridicalDetails_To.INN = vbNotNDSPayer_INN
                    OR vbCurrencyPartnerId <> zc_Enum_Currency_Basis()
                  THEN 'X' ELSE '' END                  AS NotNDSPayer
           , CASE WHEN OH_JuridicalDetails_To.INN = vbNotNDSPayer_INN
                    OR vbCurrencyPartnerId <> zc_Enum_Currency_Basis()
                  THEN TRUE ELSE FALSE END :: Boolean   AS isNotNDSPayer

           , CASE WHEN vbCurrencyPartnerId <> zc_Enum_Currency_Basis()
                       THEN '0'
                  WHEN OH_JuridicalDetails_To.INN = vbNotNDSPayer_INN
                       THEN '0'
             END AS NotNDSPayerC1
           , CASE WHEN vbCurrencyPartnerId <> zc_Enum_Currency_Basis()
                       THEN '7'
                  WHEN OH_JuridicalDetails_To.INN = vbNotNDSPayer_INN
                       THEN '2'
             END AS NotNDSPayerC2

           , CAST (REPEAT (' ', 4 - LENGTH (MovementString_InvNumberBranch.ValueData)) || MovementString_InvNumberBranch.ValueData AS TVarChar) AS InvNumberBranch

           , COALESCE(MovementLinkMovement_Sale.MovementChildId, 0) AS EDIId

           , COALESCE(MovementFloat_Amount.ValueData, 0) AS SendDeclarAmount
           , CASE WHEN vbDocumentTaxKindId <> zc_Enum_DocumentTaxKind_Tax() THEN 'X' ELSE '' END AS TaxKind -- ��� ������� ��
           , vbOperDate_begin AS OperDate_begin -- ���� ��� �����
       FROM Movement
            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Sale
                                           ON MovementLinkMovement_Sale.MovementId = inMovementId
                                          AND MovementLinkMovement_Sale.DescId = zc_MovementLinkMovement_Sale()

            LEFT JOIN MovementFloat AS MovementFloat_Amount
                                    ON MovementFloat_Amount.MovementId =  MovementLinkMovement_Sale.MovementChildId
                                   AND MovementFloat_Amount.DescId = zc_MovementFloat_Amount()
 
            LEFT JOIN Movement AS Movement_EDI ON Movement_EDI.Id =  MovementLinkMovement_Sale.MovementChildId

            LEFT JOIN MovementDate AS MovementDate_COMDOC
                                   ON MovementDate_COMDOC.MovementId =  MovementLinkMovement_Sale.MovementChildId
                                  AND MovementDate_COMDOC.DescId = zc_MovementDate_COMDOC()


            LEFT JOIN MovementDate AS MovementDate_OperDatePartnerEDI
                                   ON MovementDate_OperDatePartnerEDI.MovementId =  MovementLinkMovement_Sale.MovementChildId
                                  AND MovementDate_OperDatePartnerEDI.DescId = zc_MovementDate_OperDatePartner()

            LEFT JOIN MovementString AS MovementString_InvNumberPartnerEDI
                                     ON MovementString_InvNumberPartnerEDI.MovementId =  MovementLinkMovement_Sale.MovementChildId
                                    AND MovementString_InvNumberPartnerEDI.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN MovementString AS MovementString_InvNumberBranch
                                     ON MovementString_InvNumberBranch.MovementId =  Movement.Id
                                    AND MovementString_InvNumberBranch.DescId = zc_MovementString_InvNumberBranch()

            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId =  Movement.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummMVAT
                                    ON MovementFloat_TotalSummMVAT.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummMVAT.DescId = zc_MovementFloat_TotalSummMVAT()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummPVAT
                                    ON MovementFloat_TotalSummPVAT.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummPVAT.DescId = zc_MovementFloat_TotalSummPVAT()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

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


            LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                         ON MovementLinkObject_Partner.MovementId = Movement.Id
                                        AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
            LEFT JOIN ObjectString AS ObjectString_ToAddress
                                   ON ObjectString_ToAddress.ObjectId = MovementLinkObject_Partner.ObjectId
                                  AND ObjectString_ToAddress.DescId = zc_ObjectString_Partner_Address()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

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
            /*LEFT JOIN ObjectString AS ObjectString_BuyerGLNCode
                                   ON ObjectString_BuyerGLNCode.ObjectId = OH_JuridicalDetails_To.JuridicalId
                                  AND ObjectString_BuyerGLNCode.DescId = zc_ObjectString_Juridical_GLNCode()
            LEFT JOIN ObjectString AS ObjectString_SupplierGLNCode
                                   ON ObjectString_SupplierGLNCode.ObjectId = OH_JuridicalDetails_From.JuridicalId
                                  AND ObjectString_SupplierGLNCode.DescId = zc_ObjectString_Juridical_GLNCode()*/

            LEFT JOIN ObjectString AS ObjectString_Partner_GLNCodeJuridical
                                   ON ObjectString_Partner_GLNCodeJuridical.ObjectId = COALESCE (MovementLinkObject_Partner.ObjectId, Object_To.Id)
                                  AND ObjectString_Partner_GLNCodeJuridical.DescId = zc_ObjectString_Partner_GLNCodeJuridical()
            LEFT JOIN ObjectString AS ObjectString_Partner_GLNCodeCorporate
                                   ON ObjectString_Partner_GLNCodeCorporate.ObjectId = COALESCE (MovementLinkObject_Partner.ObjectId, Object_To.Id)
                                  AND ObjectString_Partner_GLNCodeCorporate.DescId = zc_ObjectString_Partner_GLNCodeCorporate()

            LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                 ON ObjectLink_Juridical_Retail.ObjectId = OH_JuridicalDetails_To.JuridicalId
                                AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
            LEFT JOIN ObjectString AS ObjectString_Juridical_GLNCode
                                   ON ObjectString_Juridical_GLNCode.ObjectId = OH_JuridicalDetails_To.JuridicalId
                                  AND ObjectString_Juridical_GLNCode.DescId = zc_ObjectString_Juridical_GLNCode()
            LEFT JOIN ObjectString AS ObjectString_Retail_GLNCodeCorporate
                                   ON ObjectString_Retail_GLNCodeCorporate.ObjectId = ObjectLink_Juridical_Retail.ChildObjectId
                                  AND ObjectString_Retail_GLNCodeCorporate.DescId = zc_ObjectString_Retail_GLNCodeCorporate()

            LEFT JOIN ObjectString AS ObjectString_JuridicalFrom_GLNCode
                                   ON ObjectString_JuridicalFrom_GLNCode.ObjectId = OH_JuridicalDetails_From.JuridicalId
                                  AND ObjectString_JuridicalFrom_GLNCode.DescId = zc_ObjectString_Juridical_GLNCode()

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

          LEFT JOIN ObjectBoolean AS ObjectBoolean_Vat
                                  ON ObjectBoolean_Vat.ObjectId = View_Contract.ContractId
                                 AND ObjectBoolean_Vat.DescId = zc_ObjectBoolean_Contract_Vat()

       WHERE Movement.Id =  vbMovementId_Tax
         AND Movement.StatusId = zc_Enum_Status_Complete()
      ;
     RETURN NEXT Cursor1;

     -- ������ �� �������� ����� ���������
     OPEN Cursor2 FOR
     WITH tmpObject_GoodsPropertyValue AS
       (SELECT ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
             , ObjectLink_GoodsPropertyValue_Goods.ChildObjectId                   AS GoodsId
             , COALESCE (ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId, 0) AS GoodsKindId
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
             LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                  ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                 AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
             LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                  ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                 AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
       )

       SELECT
             Object_Goods.ObjectCode                AS GoodsCode
           , (CASE WHEN vbDocumentTaxKindId = zc_Enum_DocumentTaxKind_Prepay()
                        THEN '���������� �� ����.�������'
                   ELSE CASE WHEN tmpObject_GoodsPropertyValue.Name <> ''
                                  THEN tmpObject_GoodsPropertyValue.Name
                             WHEN tmpObject_GoodsPropertyValue_basis.Name <> ''
                                  THEN tmpObject_GoodsPropertyValue_basis.Name
                             ELSE Object_Goods.ValueData || CASE WHEN COALESCE (Object_GoodsKind.Id, zc_Enum_GoodsKind_Main()) = zc_Enum_GoodsKind_Main() THEN '' ELSE ' ' || Object_GoodsKind.ValueData END
                        END
              END) :: TVarChar AS GoodsName
           , (CASE WHEN vbDocumentTaxKindId = zc_Enum_DocumentTaxKind_Prepay() THEN '���������� �� ����.�������'
                   ELSE CASE WHEN tmpObject_GoodsPropertyValue.Name <> ''
                                  THEN tmpObject_GoodsPropertyValue.Name
                             WHEN tmpObject_GoodsPropertyValue_basis.Name <> ''
                                  THEN tmpObject_GoodsPropertyValue_basis.Name
                             ELSE Object_Goods.ValueData
                        END
             END) :: TVarChar AS GoodsName_two
           , Object_GoodsKind.ValueData             AS GoodsKindName
           , Object_Measure.ValueData               AS MeasureName
           , CASE WHEN Object_Measure.ObjectCode=1 THEN '0301'
                  WHEN Object_Measure.ObjectCode=2 THEN '2009'
             ELSE ''     END                        AS MeasureCode


           , MovementItem.Amount                    AS Amount
           , MovementItem.Amount                    AS AmountPartner
           , MIFloat_Price.ValueData                AS Price
           , MIFloat_CountForPrice.ValueData        AS CountForPrice

           , COALESCE (tmpObject_GoodsPropertyValue.Name, '')       AS GoodsName_Juridical
           , COALESCE (tmpObject_GoodsPropertyValueGroup.Article, COALESCE (tmpObject_GoodsPropertyValue.Article, '')) AS Article_Juridical
           , COALESCE (tmpObject_GoodsPropertyValue.BarCode, '')    AS BarCode_Juridical
           , COALESCE (tmpObject_GoodsPropertyValueGroup.ArticleGLN, COALESCE (tmpObject_GoodsPropertyValue.ArticleGLN, '')) AS ArticleGLN_Juridical
           , COALESCE (tmpObject_GoodsPropertyValue.BarCodeGLN, '') AS BarCodeGLN_Juridical


           , CAST (CASE WHEN MIFloat_CountForPrice.ValueData > 0
                           THEN CAST (MovementItem.Amount * MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 2))
                        ELSE CAST (MovementItem.Amount * MIFloat_Price.ValueData AS NUMERIC (16, 2))
                   END AS TFloat) AS AmountSumm

           , CASE WHEN vbPriceWithVAT = TRUE
                  THEN CAST (MIFloat_Price.ValueData - MIFloat_Price.ValueData * (vbVATPercent / (vbVATPercent + 100)) AS NUMERIC (16, 4))
                  ELSE MIFloat_Price.ValueData
             END / CASE WHEN MIFloat_CountForPrice.ValueData <> 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END
             AS PriceNoVAT

           , CASE WHEN vbPriceWithVAT = FALSE
                  THEN CAST (MIFloat_Price.ValueData + MIFloat_Price.ValueData * (vbVATPercent / 100) AS NUMERIC (16, 4))
                  ELSE MIFloat_Price.ValueData
             END / CASE WHEN MIFloat_CountForPrice.ValueData <> 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END
             AS PriceWVAT

           , CAST (CASE WHEN vbCurrencyPartnerId = zc_Enum_Currency_Basis()
                             THEN MovementItem.Amount * CASE WHEN vbPriceWithVAT = TRUE
                                                                  THEN (MIFloat_Price.ValueData - MIFloat_Price.ValueData * (vbVATPercent / (vbVATPercent + 100)))
                                                                  ELSE MIFloat_Price.ValueData
                                                         END / CASE WHEN MIFloat_CountForPrice.ValueData <> 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END
                             ELSE 0
                   END AS NUMERIC (16, 2)) AS AmountSummNoVAT
           , CAST (CASE WHEN vbCurrencyPartnerId <> zc_Enum_Currency_Basis()
                             THEN MovementItem.Amount * CASE WHEN vbPriceWithVAT = TRUE
                                                                  THEN (MIFloat_Price.ValueData - MIFloat_Price.ValueData * (vbVATPercent / (vbVATPercent + 100)))
                                                                  ELSE MIFloat_Price.ValueData
                                                         END / CASE WHEN MIFloat_CountForPrice.ValueData <> 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END
                             ELSE 0
                   END AS NUMERIC (16, 2)) AS AmountSummNoVAT_11

           , CAST (MovementItem.Amount * CASE WHEN vbPriceWithVAT = FALSE
                                              THEN MIFloat_Price.ValueData + MIFloat_Price.ValueData * (vbVATPercent / 100)
                                              ELSE MIFloat_Price.ValueData
                                         END / CASE WHEN MIFloat_CountForPrice.ValueData <> 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END
                   AS NUMERIC (16, 3)) AS AmountSummWVAT

           , CAST (MovementItem.Amount * CASE WHEN vbPriceWithVAT = TRUE
                                              THEN (MIFloat_Price.ValueData - MIFloat_Price.ValueData * (vbVATPercent / (vbVATPercent + 100)))
                                              ELSE MIFloat_Price.ValueData
                                          END / CASE WHEN MIFloat_CountForPrice.ValueData <> 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END
                   AS NUMERIC (16, 2)) AS AmountSummNoVAT_12

       FROM MovementItem
            INNER JOIN MovementItemFloat AS MIFloat_Price
                                         ON MIFloat_Price.MovementItemId = MovementItem.Id
                                        AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                        -- AND MIFloat_Price.ValueData <> 0
            LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                        ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                       AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

            LEFT JOIN tmpObject_GoodsPropertyValue ON tmpObject_GoodsPropertyValue.GoodsId = MovementItem.ObjectId
                                                  AND tmpObject_GoodsPropertyValue.GoodsKindId = COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
            LEFT JOIN tmpObject_GoodsPropertyValueGroup ON tmpObject_GoodsPropertyValueGroup.GoodsId = MovementItem.ObjectId
                                                       AND tmpObject_GoodsPropertyValue.GoodsId IS NULL
            LEFT JOIN tmpObject_GoodsPropertyValue_basis ON tmpObject_GoodsPropertyValue_basis.GoodsId = MovementItem.ObjectId
                                                        AND tmpObject_GoodsPropertyValue_basis.GoodsKindId = COALESCE (MILinkObject_GoodsKind.ObjectId, 0)

       WHERE MovementItem.MovementId = vbMovementId_Tax
         AND MovementItem.DescId     = zc_MI_Master()
         AND MovementItem.isErased   = FALSE
         AND MovementItem.Amount <> 0
       ORDER BY Object_Goods.ValueData
              , Object_GoodsKind.ValueData
      ;
     RETURN NEXT Cursor2;


     -- ������ �� ������� ������� � ���������
     OPEN Cursor3 FOR
     WITH
     tmpMovementTaxCount AS
     (
     SELECT CASE
            WHEN (vbMovementId_Sale <> 0 AND vbMovementId_Tax<>0 AND MovementLinkObject_DocumentTaxKind.ObjectId=80787)--���-��������� 80787=��������� �������
            THEN 1 ELSE 0 END                       AS CountTaxId
     FROM MovementLinkObject AS MovementLinkObject_DocumentTaxKind
     WHERE MovementLinkObject_DocumentTaxKind.DescId = zc_MovementLinkObject_DocumentTaxKind()
       AND MovementLinkObject_DocumentTaxKind.MovementId = vbMovementId_Tax
     )
     ,
     tmpTax AS
      (SELECT MovementItem.ObjectId                  AS GoodsId
            , MIFloat_Price.ValueData                AS Price
            , SUM (MovementItem.Amount)              AS Amount
       FROM MovementItem
            INNER JOIN MovementItemFloat AS MIFloat_Price
                                         ON MIFloat_Price.MovementItemId = MovementItem.Id
                                        AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                        -- AND MIFloat_Price.ValueData <> 0
       WHERE MovementItem.MovementId = vbMovementId_Tax
         AND MovementItem.DescId     = zc_MI_Master()
         AND MovementItem.isErased   = FALSE
       GROUP BY MovementItem.ObjectId
              , MIFloat_Price.ValueData
      )
    , tmpSale AS
       (SELECT MovementItem.ObjectId     			AS GoodsId
             , CASE WHEN MovementFloat_ChangePercent.ValueData <> 0
                         THEN CAST ( (1 + MovementFloat_ChangePercent.ValueData / 100) * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2))
                    ELSE COALESCE (MIFloat_Price.ValueData, 0)
               END AS Price
             , SUM (CASE WHEN Movement.DescId = zc_Movement_Sale()
                              THEN COALESCE (MIFloat_AmountPartner.ValueData, 0)
                              ELSE MovementItem.Amount
                    END) AS Amount
       FROM MovementItem
            INNER JOIN MovementItemFloat AS MIFloat_Price
                                         ON MIFloat_Price.MovementItemId = MovementItem.Id
                                        AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                        -- AND MIFloat_Price.ValueData <> 0
            LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                        ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
            LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId
            LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                    ON MovementFloat_ChangePercent.MovementId = MovementItem.MovementId
                                   AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
       WHERE MovementItem.MovementId = vbMovementId_Sale
         AND MovementItem.DescId     = zc_MI_Master()
         AND MovementItem.isErased   = FALSE
       GROUP BY MovementItem.ObjectId
              , MIFloat_Price.ValueData
              , MovementFloat_ChangePercent.ValueData
      )

       SELECT GoodsId
            , Object_Goods.ObjectCode        AS GoodsCode
            , Object_Goods.ValueData         AS GoodsName
            , Price                          AS Price
            , CAST (COALESCE(tmpMovementTaxCount.CountTaxId, 0) AS Integer) AS CountTaxId
            , SUM (SaleAmount)               AS SaleAmount
            , SUM (TaxAmount)                AS TaxAmount
       FROM (SELECT tmpSale.GoodsId
                  , tmpSale.Price
                  , tmpSale.Amount AS SaleAmount
                  , 0              AS TaxAmount
             FROM tmpSale
             WHERE tmpSale.Amount <> 0
           UNION ALL
             SELECT tmpTax.GoodsId
                  , tmpTax.Price
                  , 0             AS SaleAmount
                  , tmpTax.Amount AS TaxAmount
             FROM tmpTax
          ) AS tmp
           LEFT JOIN Object AS Object_Goods ON Object_Goods.Id =  tmp.GoodsId
           LEFT JOIN tmpMovementTaxCount ON 1=1
       GROUP BY tmp.GoodsId
              , Object_Goods.ObjectCode
              , Object_Goods.ValueData
              , tmp.Price
              , tmpMovementTaxCount.CountTaxId
       HAVING SUM (tmp.SaleAmount) <>  SUM (tmp.TaxAmount)
      ;
     RETURN NEXT Cursor3;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_Tax_Print (Integer, Boolean, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 29.01.16         *
 21.04.15                        * add MovementDate_COMDOC
 14.01.15                                                       *
 30.12.14                                                       * add MeasureCode
 23.07.14                                        * add tmpObject_GoodsPropertyValueGroup and ArticleGLN
 05.06.14                                        * restore ContractSigningDate
 04.06.14                                        * add tmpObject_GoodsPropertyValue.Name
 21.05.14                                        * add zc_Movement_TransferDebtOut
 20.05.14                                        * ContractSigningDate -> Object_Contract_View.StartDate
 19.05.14                                        * add MovementFloat_ChangePercent
 17.05.14                                        * add StatusId = zc_Enum_Status_Complete
 13.05.14                                        * add calc GoodsName
 07.05.14                       * add CHARCODE
 24.04.14                                                       * add zc_MovementString_InvNumberBranch
 11.04.14                                                       *
 02.04.14                                                       *  PriceWVAT PriceNoVAT round to 2 sign
 01.04.14                                                       *  MIFloat_Price.ValueData <> 0
 31.03.14                                                       *  + inisClientCopy
 23.03.14                                        * rename zc_MovementLinkMovement_Child -> zc_MovementLinkMovement_Master
 06.03.14                                                       *
 24.02.14                                                       *  add PriceNoVAT, PriceWVAT, AmountSummNoVAT, AmountSummWVAT
 19.02.14                                                       *  add by juridical
 07.02.14                                                       *  change to Cursor
 05.02.14                                                       *
*/

/*

�� ����������������, ��� ��������� ���������, ������� ����������� � �����  � �������������� � 01.04 - ������ ���� � ����� �����.
� 01.04 �� ����� ����� ���������� �������������� � ��������� �����. ��� ������� 100%. 
����� ��������� �� �� ��������� � ����� � 01.04, � �� ����������� ���� ���������� � 01.04

1) �.1.���� � ������� �� ����� ������ ��� ��� ���� �������, ������ ��� ����������� � ���������� �������.
���������� ������� �������������� "����������" �������� ������� � ������� ��������������. ����� ������� ������� ������������� �� ����� � ����������, � �������� ������� ������������ ������� ������������� (� �������� ������ �������  ���� �������� ������������ �������).
2) � �� ��� 20  ������� -  ��/� �� ��������� ����������, �.�. � ��������� ������ ���� ��������, ���������� �������� ����������:
- ������� ��������� ��� ����������� � ������ ������ � �/� �� ����������� ��������
- ������ � ������������� ��� � �/�

����� ����� ������� �� ������ �� ���� ��������� ��� ����, ��� � �� �������� "���� �����������"  - ������ ���� ����� �������� �� ���������������, ������� ��� �������� �� ����������� ��������� ��� � ������ ... ����� ������ ��� ����
����� - "���� �����������" ��������� ��������������� � ���� �������:
- ��� �������� ��������� ���-��� � 1 ������ (��� ����� ���� ��������)
- ��� �������� � ����� (��� ����� ���� ��������)
- ��� �������� � ����� ����������� (��� ����� �������� ���� �����������)

�� ������ ���������, �.�. ������ ��� ���� � ����������� � ����� ����� ������ � ����� , 2,3 ������, ������� ����������� ����� ����� ������� � �����������, ������������� ������ ���
����������� ����� - ��, 01 ������, �� ������� ��� � � ��� �� ���� ���������, �� ������� ���� ����������� ������������� 1-2 ������, � �.�. ���� �������� ��� �� ������ ���� ����� �� 5 ������

*/

-- ����
-- SELECT * FROM gpSelect_Movement_Tax_Print (inMovementId:= 171760, inisClientCopy:= FALSE ,inSession:= zfCalc_UserAdmin());
