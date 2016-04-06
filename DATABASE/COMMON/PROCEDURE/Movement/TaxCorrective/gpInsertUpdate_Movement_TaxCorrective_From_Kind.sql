-- Function: gpInsertUpdate_Movement_TaxCorrective_From_Kind()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_TaxCorrective_From_Kind (Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_TaxCorrective_From_Kind (
    IN inMovementId             Integer  , -- ���� ���������
    IN inDocumentTaxKindId      Integer  , -- ��� ������������ ���������� ���������
    IN inDocumentTaxKindId_inf  Integer  , -- ��� ������������ ���������� ��������� � �������
    IN inIsTaxLink              Boolean  , -- ������� �������� � ���������
   OUT outDocumentTaxKindId     Integer  , --
   OUT outDocumentTaxKindName   TVarChar , --
   OUT outMovementId_Corrective Integer  , --
   OUT outMessageText           Text     ,
    IN inSession                TVarChar   -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId           Integer;

   DECLARE vbStatusId  Integer;
   DECLARE vbInvNumber TVarChar;

   DECLARE vbMovementId_Tax   Integer;
   DECLARE vbAmount_Tax       TFloat;

   DECLARE vbStartDate        TDateTime;
   DECLARE vbEndDate          TDateTime;

   DECLARE vbMovementDescId   Integer;
   DECLARE vbOperDate         TDateTime;
   DECLARE vbPriceWithVAT     Boolean ;
   DECLARE vbVATPercent       TFloat;
   DECLARE vbFromId           Integer;
   DECLARE vbToId             Integer;
   DECLARE vbPartnerId        Integer;
   DECLARE vbContractId       Integer;
   DECLARE vbBranchId         Integer;
   DECLARE vbDiscountPercent     TFloat;
   DECLARE vbExtraChargesPercent TFloat;

   DECLARE vbGoodsId     Integer;
   DECLARE vbGoodsKindId Integer;
   DECLARE vbAmount      TFloat;
   DECLARE vbOperPrice   TFloat;

   DECLARE curMI_ReturnIn refcursor;
   DECLARE curMI_Tax refcursor;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_TaxCorrective());

     -- ��� ������ ������������ ��������� � ������� "������" ��� ������������
     IF inDocumentTaxKindId_inf <> 0 THEN inDocumentTaxKindId:= inDocumentTaxKindId_inf; END IF;

     -- ��� ��� ������������ �� �������
     IF COALESCE (inDocumentTaxKindId, 0) = 0
     THEN inDocumentTaxKindId:= zc_Enum_DocumentTaxKind_Corrective();
     END IF;

     -- 
     IF inDocumentTaxKindId NOT IN (zc_Enum_DocumentTaxKind_Corrective(), zc_Enum_DocumentTaxKind_CorrectivePrice(), zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical())
     THEN
         RAISE EXCEPTION '������.������� ������ ��� �������������.';
     END IF;


     -- ������������ ��������� ��� <���������� ���������> �� "��������"
     SELECT Movement.StatusId
          , Movement.InvNumber
          , Movement.DescId AS MovementDescId
          , CASE WHEN Movement.DescId = zc_Movement_ReturnIn()
                      THEN MovementDate_OperDatePartner.ValueData -- ��������� � ����� �����������
                 ELSE Movement.OperDate  -- ��������� � ���������� inMovementId
            END AS OperDate
          , DATE_TRUNC ('MONTH', Movement.OperDate) AS StartDate
          , DATE_TRUNC ('MONTH', Movement.OperDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY' AS EndDate

          , MovementBoolean_PriceWithVAT.ValueData AS PriceWithVAT
          , MovementFloat_VATPercent.ValueData AS VATPercent
          , CASE WHEN Movement.DescId = zc_Movement_ReturnIn() THEN ObjectLink_Partner_Juridical.ChildObjectId ELSE MovementLinkObject_From.ObjectId END AS FromId
          , ObjectLink_Contract_JuridicalBasis.ChildObjectId AS ToId -- �� ���� - ������ ������� ��.���� �� ��������
          , CASE WHEN Movement.DescId = zc_Movement_ReturnIn() THEN MovementLinkObject_From.ObjectId ELSE MovementLinkObject_Partner.ObjectId END AS PartnerId
          , COALESCE (MovementLinkObject_ContractFrom.ObjectId, MovementLinkObject_Contract.ObjectId) AS ContractId
          , COALESCE (ObjectLink_Unit_Branch.ChildObjectId, 0) AS BranchId
          , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) < 0 THEN -1 * MovementFloat_ChangePercent.ValueData ELSE 0 END AS DiscountPercent
          , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) > 0 THEN MovementFloat_ChangePercent.ValueData ELSE 0 END AS ExtraChargesPercent
          , CASE WHEN Movement.DescId = zc_Movement_PriceCorrective() AND inDocumentTaxKindId = zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
                      THEN zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical() -- !!!�� ��������!!!
                 WHEN Movement.DescId = zc_Movement_PriceCorrective()
                      THEN zc_Enum_DocumentTaxKind_CorrectivePrice() -- !!!������ �����!!!
                 ELSE inDocumentTaxKindId -- !!!�� ��������!!!
            END AS DocumentTaxKindId
            INTO vbStatusId, vbInvNumber
               , vbMovementDescId, vbOperDate, vbStartDate, vbEndDate, vbPriceWithVAT, vbVATPercent, vbFromId, vbToId, vbPartnerId, vbContractId, vbBranchId
               , vbDiscountPercent, vbExtraChargesPercent, inDocumentTaxKindId
     FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                       ON MovementLinkObject_Partner.MovementId = Movement.Id
                                      AND MovementLinkObject_Partner.DescId = CASE WHEN Movement.DescId = zc_Movement_TransferDebtIn() THEN zc_MovementLinkObject_PartnerFrom() ELSE zc_MovementLinkObject_Partner() END
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                       ON MovementLinkObject_Contract.MovementId = Movement.Id
                                      AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_ContractFrom
                                       ON MovementLinkObject_ContractFrom.MovementId = Movement.Id
                                      AND MovementLinkObject_ContractFrom.DescId = zc_MovementLinkObject_ContractFrom()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                 ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
          LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                  ON MovementFloat_ChangePercent.MovementId = Movement.Id
                                 AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
          LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                  ON MovementFloat_VATPercent.MovementId =  Movement.Id
                                 AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
          LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                    ON MovementBoolean_PriceWithVAT.MovementId =  Movement.Id
                                   AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
          LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                               ON ObjectLink_Unit_Branch.ObjectId = MovementLinkObject_To.ObjectId
                              AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
          LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                               ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                              AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
          LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalBasis
                               ON ObjectLink_Contract_JuridicalBasis.ObjectId = COALESCE (MovementLinkObject_ContractFrom.ObjectId, MovementLinkObject_Contract.ObjectId)
                              AND ObjectLink_Contract_JuridicalBasis.DescId = zc_ObjectLink_Contract_JuridicalBasis()
     WHERE Movement.Id = inMovementId
    ;

     -- �������� - �����������/��������� ��������� �������� ������
     IF vbStatusId <> zc_Enum_Status_UnComplete() AND inDocumentTaxKindId <> zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
     THEN
         RAISE EXCEPTION '������.������������ <������������� � ���������> �� ��������� ��������� � <%> � ������� <%> �� ��������.', vbInvNumber, lfGet_Object_ValueData (vbStatusId);
     END IF;
     -- �������� - �����������/��������� ��������� �������� ������
     IF vbStatusId <> zc_Enum_Status_Complete() AND inDocumentTaxKindId = zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
     THEN
         RAISE EXCEPTION '������.������������ <������������� � ���������> �� ��������� ��������� � <%> � ������� <%> �� ��������.', vbInvNumber, lfGet_Object_ValueData (vbStatusId);
     END IF;


     -- ������� - ������
     CREATE TEMP TABLE _tmpMovement_PriceCorrective (MovementId Integer, MovementId_Corrective Integer, MovementId_Tax Integer) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpMI_Return (GoodsId Integer, GoodsKindId Integer, OperPrice TFloat, CountForPrice TFloat, Amount TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpMovement_find (MovementId_Corrective Integer, MovementId_Tax Integer) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpResult (MovementId_Corrective Integer, MovementId_Tax Integer, GoodsId Integer, GoodsKindId Integer, Amount TFloat, OperPrice TFloat, CountForPrice TFloat) ON COMMIT DROP;
     -- ������ ��� ������2 - �������� !!!��� �����������!!!
     CREATE TEMP TABLE _tmp1_SubQuery (MovementId Integer, OperDate TDateTime, isRegistered Boolean, Amount TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmp2_SubQuery (MovementId_Tax Integer, Amount TFloat) ON COMMIT DROP;


     IF inDocumentTaxKindId IN (zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical())
     THEN
         -- ������� ��� <������������� ����>
         INSERT INTO _tmpMovement_PriceCorrective (MovementId, MovementId_Corrective, MovementId_Tax)
            SELECT Movement.Id AS MovementId, COALESCE (MLM_Master.MovementId, 0) AS MovementId_Corrective, COALESCE (MLM_Child.MovementChildId, 0) AS MovementId_Tax
            FROM Movement
                 INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                                               ON MovementLinkObject_Contract.MovementId = Movement.Id
                                              AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                              AND MovementLinkObject_Contract.ObjectId = vbContractId
                 INNER JOIN MovementLinkObject ON MovementLinkObject.MovementId = Movement.Id
                                              AND MovementLinkObject.DescId = zc_MovementLinkObject_From()
                                              AND MovementLinkObject.ObjectId = vbFromId
                 INNER JOIN MovementLinkObject AS MovementLinkObject_to
                                               ON MovementLinkObject_to.MovementId = Movement.Id
                                              AND MovementLinkObject_to.DescId = zc_MovementLinkObject_To()
                                              AND MovementLinkObject_to.ObjectId = vbToId
                 LEFT JOIN MovementLinkMovement AS MLM_Master
                                                ON MLM_Master.MovementChildId = Movement.Id
                                               AND MLM_Master.DescId = zc_MovementLinkMovement_Master()
                 LEFT JOIN Movement AS Movement_Corrective ON Movement_Corrective.Id = MLM_Master.MovementId
                 LEFT JOIN MovementLinkMovement AS MLM_Child
                                                ON MLM_Child.MovementId = MLM_Master.MovementId
                                               AND MLM_Child.DescId = zc_MovementLinkMovement_Child()
            WHERE Movement.OperDate BETWEEN vbStartDate AND vbEndDate
              AND Movement.DescId = zc_Movement_PriceCorrective()
              AND Movement.StatusId = zc_Enum_Status_Complete()
              AND COALESCE (Movement_Corrective.StatusId, 0) <> zc_Enum_Status_Erased()
           ;

         -- ��������
         IF EXISTS (SELECT 1 FROM _tmpMovement_PriceCorrective GROUP BY _tmpMovement_PriceCorrective.MovementId HAVING COUNT(*) > 1)
         THEN
             RAISE EXCEPTION '������.� ������ ��������� <������������� ����> ������� ������ ��� ���� <������������� � ���������>.';
         END IF;


         -- ������� ��� <������������� ����>
         INSERT INTO _tmpMI_Return (GoodsId, GoodsKindId, OperPrice, CountForPrice, Amount)
            SELECT MovementItem.ObjectId AS GoodsId
                 , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                 , CASE WHEN vbPriceWithVAT = TRUE AND vbVATPercent <> 0
                             -- � "��������� ���������" ������ ����� ��� ���
                             THEN CAST (COALESCE (MIFloat_Price.ValueData, 0) / (1 + vbVATPercent / 100) AS NUMERIC (16, 2))
                        ELSE COALESCE (MIFloat_Price.ValueData, 0)
                   END AS OperPrice
                 , MIFloat_CountForPrice.ValueData AS CountForPrice
                 , SUM (MovementItem.Amount)       AS Amount
            FROM _tmpMovement_PriceCorrective
                 INNER JOIN MovementItem ON MovementItem.MovementId = _tmpMovement_PriceCorrective.MovementId
                                        AND MovementItem.DescId     = zc_MI_Master()
                                        AND MovementItem.isErased   = FALSE
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
            GROUP BY MovementItem.ObjectId
                   , MILinkObject_GoodsKind.ObjectId
                   , MIFloat_Price.ValueData 
                   , MIFloat_CountForPrice.ValueData
           ;
     ELSE
     -- ������� <������� �� ����������> ��� <������� ����� (������)> ��� <������������� ����>
     INSERT INTO _tmpMI_Return (GoodsId, GoodsKindId, OperPrice, CountForPrice, Amount)
        SELECT tmpMI.GoodsId
             , tmpMI.GoodsKindId
             , tmpMI.OperPrice
             , tmpMI.CountForPrice
             , tmpMI.Amount
        FROM (SELECT MovementItem.ObjectId AS GoodsId
                   , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                   , CASE WHEN vbPriceWithVAT = TRUE AND vbVATPercent <> 0
                               -- � "��������� ���������" ������ ����� ��� ���
                               THEN CAST (CASE WHEN vbDiscountPercent <> 0 OR vbExtraChargesPercent <> 0 THEN CAST ( (1 + (vbExtraChargesPercent - vbDiscountPercent) / 100) * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2)) ELSE COALESCE (MIFloat_Price.ValueData, 0) END
                                        / (1 + vbVATPercent / 100) AS NUMERIC (16, 2))
                          ELSE CASE WHEN vbDiscountPercent <> 0 OR vbExtraChargesPercent <> 0 THEN CAST ( (1 + (vbExtraChargesPercent - vbDiscountPercent) / 100) * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2)) ELSE COALESCE (MIFloat_Price.ValueData, 0) END
                     END AS OperPrice
                   , MIFloat_CountForPrice.ValueData AS CountForPrice
                   , SUM (CASE WHEN vbMovementDescId = zc_Movement_ReturnIn() THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) WHEN vbMovementDescId IN (zc_Movement_TransferDebtIn(), zc_Movement_PriceCorrective()) THEN MovementItem.Amount ELSE 0 END) AS Amount
              FROM MovementItem
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
                                              AND MIFloat_AmountPartner.ValueData <> 0
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                    ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
              WHERE MovementItem.MovementId = inMovementId
                AND MovementItem.DescId     = zc_MI_Master()
                AND MovementItem.isErased   = FALSE
              GROUP BY MovementItem.ObjectId
                     , MILinkObject_GoodsKind.ObjectId
                     , MIFloat_Price.ValueData 
                     , MIFloat_CountForPrice.ValueData
             ) AS tmpMI
        WHERE tmpMI.Amount <> 0
       ;
     END IF;

     IF inIsTaxLink = FALSE OR vbMovementDescId = zc_Movement_PriceCorrective()
     THEN 
          -- � ���� ������ �� ����� ��������, �� ���� ����� !!!������!!! <���������� ���������> ��� ���� � �������� <������� �� ����������> ��� <������� ����� (������)> ��� <������������� ����>
          WITH tmpMovement_Corrective AS (SELECT MLM_Master.MovementId AS MovementId_Corrective, COALESCE (MLM_Child.MovementChildId, 0) AS MovementId_Tax
                                          FROM MovementLinkMovement AS MLM_Master
                                               INNER JOIN Movement AS Movement_TaxCorrective ON Movement_TaxCorrective.Id = MLM_Master.MovementId
                                                                                            AND Movement_TaxCorrective.StatusId <> zc_Enum_Status_Erased()
                                               LEFT JOIN MovementLinkMovement AS MLM_Child
                                                                              ON MLM_Child.MovementId = MLM_Master.MovementId
                                                                             AND MLM_Child.DescId = zc_MovementLinkMovement_Child()
                                          WHERE MLM_Master.MovementChildId = inMovementId
                                            AND MLM_Master.DescId = zc_MovementLinkMovement_Master()
                                          GROUP BY MLM_Master.MovementId, COALESCE (MLM_Child.MovementChildId, 0)
                                         )
             , tmpMovement_Corrective_Count AS (SELECT COUNT(*) AS myCOUNT FROM tmpMovement_Corrective)
          INSERT INTO _tmpResult (MovementId_Corrective, MovementId_Tax, GoodsId, GoodsKindId, Amount, OperPrice, CountForPrice)
             SELECT COALESCE (tmpMovement_Corrective.MovementId_Corrective, 0)
                  , COALESCE (tmpMovement_Corrective.MovementId_Tax, 0)
                  , GoodsId, GoodsKindId, Amount, OperPrice, CountForPrice
             FROM _tmpMI_Return
                  LEFT JOIN tmpMovement_Corrective_Count ON tmpMovement_Corrective_Count.myCOUNT = 1
                  LEFT JOIN tmpMovement_Corrective ON tmpMovement_Corrective_Count.myCOUNT IS NOT NULL
            ;
     ELSE
         -- ������1 - ��������
         OPEN curMI_ReturnIn FOR
              SELECT GoodsId, GoodsKindId, Amount, OperPrice FROM _tmpMI_Return;

         -- ������ ����� �� �������1 - ��������
         LOOP
              -- ������ �� ���������
              FETCH curMI_ReturnIn INTO vbGoodsId, vbGoodsKindId, vbAmount, vbOperPrice;
              -- ���� ������ �����������, ����� �����
              IF NOT FOUND THEN EXIT; END IF;


     -- 
     DELETE FROM _tmp1_SubQuery;
     DELETE FROM _tmp2_SubQuery;
     -- ������ ��� ������2 - <���������> �������� !!!��� �����������!!!
     INSERT INTO _tmp1_SubQuery (MovementId, OperDate, isRegistered, Amount)
                         SELECT Movement.Id AS MovementId
                              , Movement.OperDate
                              , COALESCE (MB_Registered.ValueData, FALSE) AS isRegistered
                              , SUM (MovementItem.Amount) AS Amount
                         FROM MovementLinkObject AS MLO_Partner
                              INNER JOIN MovementLinkMovement AS MovementLinkMovement_Master
                                                              ON MovementLinkMovement_Master.MovementId = MLO_Partner.MovementId
                                                             AND MovementLinkMovement_Master.DescId = zc_MovementLinkMovement_Master()
                              INNER JOIN Movement ON Movement.Id = MovementLinkMovement_Master.MovementChildId
                                                 AND Movement.DescId = zc_Movement_Tax()
                                                 AND Movement.StatusId = zc_Enum_Status_Complete()
                                                 AND Movement.OperDate BETWEEN vbOperDate - INTERVAL '12 MONTH' AND vbOperDate - INTERVAL '1 DAY'
                              INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                            ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                           AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                                           AND (MovementLinkObject_Contract.ObjectId = vbContractId
                                                             OR (Movement.OperDate < '01.02.2016' AND vbBranchId = zc_Branch_Kiev())
                                                               )
                              INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                     AND MovementItem.ObjectId = vbGoodsId
                                                     AND MovementItem.DescId = zc_MI_Master()
                                                     AND MovementItem.isErased   = FALSE
                                                     AND MovementItem.Amount <> 0
                              INNER JOIN MovementItemFloat AS MIFloat_Price
                                                           ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                          AND MIFloat_Price.ValueData = vbOperPrice
                                                          AND MIFloat_Price.DescId = zc_MIFloat_Price()
                              LEFT JOIN MovementBoolean AS MB_Registered
                                                        ON MB_Registered.MovementId = Movement.Id
                                                       AND MB_Registered.DescId = zc_MovementBoolean_Registered()
                         WHERE MLO_Partner.ObjectId = vbPartnerId
                           AND MLO_Partner.DescId IN (zc_MovementLinkObject_To(), zc_MovementLinkObject_Partner())
                         GROUP BY Movement.Id
                                , Movement.OperDate
                                , MB_Registered.ValueData
                        UNION
                         -- !!! ��� ����� �� ��.�. ���� !!!
                         SELECT Movement.Id AS MovementId
                              , Movement.OperDate
                              , COALESCE (MB_Registered.ValueData, FALSE) AS isRegistered
                              , SUM (MovementItem.Amount) AS Amount
                         FROM MovementLinkObject AS MLO_To
                              INNER JOIN Movement ON Movement.Id = MLO_To.MovementId
                                                 AND Movement.DescId = zc_Movement_Tax()
                                                 AND Movement.StatusId = zc_Enum_Status_Complete()
                                                 AND Movement.OperDate BETWEEN vbOperDate - INTERVAL '12 MONTH' AND vbOperDate - INTERVAL '1 DAY'
                              /*INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                            ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                           AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                                           AND MovementLinkObject_Contract.ObjectId = vbContractId*/
                              INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                     AND MovementItem.ObjectId = vbGoodsId
                                                     AND MovementItem.DescId = zc_MI_Master()
                                                     AND MovementItem.isErased   = FALSE
                                                     AND MovementItem.Amount <> 0
                              INNER JOIN MovementItemFloat AS MIFloat_Price
                                                           ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                          AND MIFloat_Price.ValueData = vbOperPrice
                                                          AND MIFloat_Price.DescId = zc_MIFloat_Price()
                              LEFT JOIN MovementBoolean AS MB_Registered
                                                        ON MB_Registered.MovementId = Movement.Id
                                                       AND MB_Registered.DescId = zc_MovementBoolean_Registered()
                         WHERE MLO_To.ObjectId = vbFromId
                           AND MLO_To.DescId = zc_MovementLinkObject_To()
                           AND Movement.OperDate < '01.02.2016'
                           AND vbBranchId = zc_Branch_Kiev()
                         GROUP BY Movement.Id
                                , Movement.OperDate
                                , MB_Registered.ValueData;
                        
     -- ������ ��� ������2 - <�������������> � ���� <���������> �������� !!!��� �����������!!!
              WITH tmpMovement2 AS (SELECT Movement.Id
                                        , MIFloat_Price.ValueData AS Price
                                        , SUM (MovementItem.Amount) AS Amount
                                   FROM _tmp1_SubQuery AS tmpMovement_Tax
                                        INNER JOIN MovementLinkMovement AS MLM_Child
                                                                        ON MLM_Child.MovementChildId = tmpMovement_Tax.MovementId
                                                                       AND MLM_Child.DescId = zc_MovementLinkMovement_Child()
                                        INNER JOIN Movement ON Movement.Id       = MLM_Child.MovementId
                                                           AND Movement.DescId   = zc_Movement_TaxCorrective()
                                                           AND Movement.StatusId = zc_Enum_Status_Complete()
                                        INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                               AND MovementItem.ObjectId   = vbGoodsId
                                                               AND MovementItem.DescId     = zc_MI_Master()
                                                               AND MovementItem.isErased   = FALSE
                                        LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                                    ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                                   AND MIFloat_Price.DescId         = zc_MIFloat_Price()
                                                                   -- AND MIFloat_Price.ValueData      = vbOperPrice
                                   GROUP BY Movement.Id
                                          , MIFloat_Price.ValueData
                                  )
             /*WITH tmpMovement2 AS (SELECT Movement.Id
                                        , MIFloat_Price.ValueData AS Price
                                        , SUM (MovementItem.Amount) AS Amount
                                   FROM Movement
                                        INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                               AND MovementItem.ObjectId = vbGoodsId
                                                               AND MovementItem.DescId = zc_MI_Master()
                                                               AND MovementItem.isErased   = FALSE
                                        LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                                    ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                                   -- AND MIFloat_Price.ValueData = vbOperPrice
                                                                   AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                   WHERE Movement.DescId = zc_Movement_TaxCorrective()
                                     AND Movement.StatusId = zc_Enum_Status_Complete()
                                   GROUP BY Movement.Id
                                          , MIFloat_Price.ValueData
                                  )*/
                 , tmpMovement AS (SELECT tmpMovement2.Id
                                        , SUM (tmpMovement2.Amount) AS Amount
                                   FROM tmpMovement2
                                   WHERE tmpMovement2.Price = vbOperPrice
                                   GROUP BY tmpMovement2.Id)
     -- ��������� - !!!��� "�������" �������������!!!
     INSERT INTO _tmp2_SubQuery (MovementId_Tax, Amount)
                                   SELECT CASE WHEN MLM_Master.MovementChildId = inMovementId THEN 0 ELSE MLM_Child.MovementChildId END AS MovementId_Tax
                                        , SUM (Movement.Amount) AS Amount
                                   FROM tmpMovement AS Movement
                                        INNER JOIN MovementLinkMovement AS MLM_Child
                                                                        ON MLM_Child.MovementId = Movement.Id
                                                                       AND MLM_Child.DescId = zc_MovementLinkMovement_Child()
                                        INNER JOIN MovementLinkMovement AS MLM_Master
                                                                        ON MLM_Master.MovementId = Movement.Id
                                                                       AND MLM_Master.DescId = zc_MovementLinkMovement_Master()
                                   GROUP BY CASE WHEN MLM_Master.MovementChildId = inMovementId THEN 0 ELSE MLM_Child.MovementChildId END;

              -- ������2 - ��� ��������� !!!�� ������� ������� �������������!!! �� ������ � ����
              OPEN curMI_Tax FOR
                   SELECT tmpMovement_Tax.MovementId
                        , tmpMovement_Tax.Amount - COALESCE (tmpMovement_Corrective.Amount, 0) AS Amount
                         -- ��� ��� ��������� �� ����������, ����� � ����
                   FROM _tmp1_SubQuery AS tmpMovement_Tax
                        -- ��� !!!���!!! ������������� �� ����� � ���� (��� !!!����!!! ���������)
                        LEFT JOIN _tmp2_SubQuery AS tmpMovement_Corrective ON tmpMovement_Corrective.MovementId_Tax = tmpMovement_Tax.MovementId
                   WHERE tmpMovement_Tax.Amount > COALESCE (tmpMovement_Corrective.Amount, 0)
                     AND tmpMovement_Tax.isRegistered = FALSE
                   ORDER BY tmpMovement_Tax.OperDate DESC, 2 DESC
                  ;

              -- ������ ����� �� �������2 - ���������
              LOOP
                  -- ������ �� ���������
                  FETCH curMI_Tax INTO vbMovementId_Tax, vbAmount_Tax;
                  -- ���� ������ �����������, ��� ��� ���-�� ������� ����� �����
                  IF NOT FOUND OR vbAmount = 0 THEN EXIT; END IF;

                  --
                  IF vbAmount_Tax > vbAmount
                  THEN
                      -- ���������� � ��������� ������ ��� ������, !!!��������� � ����-����������!!!
                      INSERT INTO _tmpResult (MovementId_Corrective, MovementId_Tax, GoodsId, GoodsKindId, Amount, OperPrice, CountForPrice)
                         SELECT 0, vbMovementId_Tax, vbGoodsId, vbGoodsKindId, vbAmount, vbOperPrice, 1 AS CountForPrice;
                      -- �������� ���-�� ��� �� ������ �� ������
                      vbAmount:= 0;
                  ELSE
                      -- ���������� � ��������� ������ ��� ������, !!!��������� � ����-����������!!!
                      INSERT INTO _tmpResult (MovementId_Corrective, MovementId_Tax, GoodsId, GoodsKindId, Amount, OperPrice, CountForPrice)
                         SELECT 0, vbMovementId_Tax, vbGoodsId, vbGoodsKindId, vbAmount_Tax, vbOperPrice, 1 AS CountForPrice;
                      -- ��������� �� ���-�� ������� ����� � ���������� �����
                      vbAmount:= vbAmount - vbAmount_Tax;
                  END IF;

              END LOOP; -- ����� ����� �� �������2 - ���������
              CLOSE curMI_Tax; -- ������� ������2 - ���������

         END LOOP; -- ����� ����� �� �������1 - ��������
         CLOSE curMI_ReturnIn; -- ������� ������1 - ��������

     END IF; -- ��������� �������� � ��������� ��� �� �������� (�.�. ��� ������ � ����-���������)


     -- ��������
     IF NOT EXISTS (SELECT 1 FROM _tmpResult)
     THEN
         RAISE EXCEPTION '������.��������� �������� �� ������.';
     END IF;


     -- !!!�������� ��������� ������!!!!

     -- ������� �� <��������� ���������> ��� ���� � �������� <������� �� ����������> ��� <������� ����� (������)> ��� <������������� ����>
     INSERT INTO _tmpMovement_find (MovementId_Corrective, MovementId_Tax)
        SELECT MLM_Master.MovementId, COALESCE (MLM_Child.MovementChildId, 0)
        FROM MovementLinkMovement AS MLM_Master
             LEFT JOIN MovementLinkMovement AS MLM_Child
                                            ON MLM_Child.MovementId = MLM_Master.MovementId
                                           AND MLM_Child.DescId = zc_MovementLinkMovement_Child()
        WHERE MLM_Master.MovementChildId = inMovementId
          AND MLM_Master.DescId = zc_MovementLinkMovement_Master()
       UNION
        SELECT _tmpMovement_PriceCorrective.MovementId_Corrective, _tmpMovement_PriceCorrective.MovementId_Tax FROM _tmpMovement_PriceCorrective WHERE _tmpMovement_PriceCorrective.MovementId_Corrective > 0
      ;


     -- ��� ����-���������� ��������� �� <��������� ���������> ��� ����
     UPDATE _tmpResult SET MovementId_Corrective = _tmpMovement_find.MovementId_Corrective
     FROM _tmpMovement_find
     WHERE _tmpResult.MovementId_Tax = _tmpMovement_find.MovementId_Tax
       AND _tmpResult.MovementId_Corrective = 0
    ;


     -- �����������/��������������� ��������� <��������� ���������>
     PERFORM lpUnComplete_Movement (inMovementId       := tmpResult_update.MovementId_Corrective
                                  , inUserId           := vbUserId
                                   )
     FROM (SELECT DISTINCT MovementId_Corrective FROM _tmpResult WHERE MovementId_Corrective <> 0) AS tmpResult_update;

     -- ������� �������� ����� ��� ���� � <��������� ����������>
     PERFORM gpMovementItem_TaxCorrective_SetErased (inMovementItemId:= MovementItem.Id
                                                   , inSession       := inSession
                                                    )
     FROM (SELECT DISTINCT MovementId_Corrective FROM _tmpResult WHERE MovementId_Corrective <> 0) AS tmpResult_update
          INNER JOIN MovementItem ON MovementItem.MovementId = tmpResult_update.MovementId_Corrective
                                 AND MovementItem.DescId = zc_MI_Master()
                                 AND MovementItem.isErased = FALSE;

     -- ������� �������� <��������� ���������>
     PERFORM lpSetErased_Movement (inMovementId       := tmpResult_delete.MovementId_Corrective
                                 , inUserId           := vbUserId
                                  )
     FROM (SELECT DISTINCT _tmpMovement_find.MovementId_Corrective
           FROM _tmpMovement_find
                 LEFT JOIN _tmpResult ON _tmpResult.MovementId_Corrective = _tmpMovement_find.MovementId_Corrective
           WHERE _tmpResult.MovementId_Corrective IS NULL
          ) AS tmpResult_delete;



     -- ������ ��������� ��� ������������ <��������� ����������>
     PERFORM lpInsertUpdate_Movement_TaxCorrective (ioId               := tmpResult_update.MovementId_Corrective
                                                  , inInvNumber        := Movement.InvNumber
                                                  , inInvNumberPartner := COALESCE ((SELECT ValueData FROM MovementString WHERE MovementId = tmpResult_update.MovementId_Corrective AND DescId = zc_MovementString_InvNumberPartner()), '')
                                                  , inInvNumberBranch  := COALESCE ((SELECT ValueData FROM MovementString WHERE MovementId = tmpResult_update.MovementId_Corrective AND DescId = zc_MovementString_InvNumberBranch()), '')
                                                  , inOperDate         := vbOperDate
                                                  , inChecked          := COALESCE ((SELECT ValueData FROM MovementBoolean WHERE MovementId = tmpResult_update.MovementId_Corrective AND DescId = zc_MovementBoolean_Checked()), FALSE)
                                                  , inDocument         := COALESCE ((SELECT ValueData FROM MovementBoolean WHERE MovementId = tmpResult_update.MovementId_Corrective AND DescId = zc_MovementBoolean_Document()), FALSE)
                                                  , inPriceWithVAT     := FALSE -- � �������������� ���� ������ ����� ��� ��� -- vbPriceWithVAT
                                                  , inVATPercent       := vbVATPercent
                                                  , inFromId           := vbFromId
                                                  , inToId             := vbToId
                                                  , inPartnerId        := vbPartnerId
                                                  , inContractId       := vbContractId
                                                  , inDocumentTaxKindId:= inDocumentTaxKindId
                                                  , inUserId           := vbUserId
                                                   )
     FROM (SELECT DISTINCT MovementId_Corrective
           FROM _tmpResult
           WHERE MovementId_Corrective <> 0
          ) AS tmpResult_update
          INNER JOIN Movement ON Movement.Id = tmpResult_update.MovementId_Corrective;


     -- ������� ����� <��������� ���������>
     UPDATE _tmpResult SET MovementId_Corrective = tmpResult_insert.MovementId_Corrective
     FROM (SELECT lpInsertUpdate_Movement_TaxCorrective (ioId               :=0
                                                       , inInvNumber        := tmpResult_insert.InvNumber :: TVarChar
                                                       , inInvNumberPartner := tmpResult_insert.InvNumberPartner :: TVarChar
                                                       , inInvNumberBranch  := ''
                                                       , inOperDate         := vbOperDate
                                                       , inChecked          := FALSE
                                                       , inDocument         := FALSE
                                                       , inPriceWithVAT     := FALSE -- � �������������� ���� ������ ����� ��� ��� -- vbPriceWithVAT
                                                       , inVATPercent       := vbVATPercent
                                                       , inFromId           := vbFromId
                                                       , inToId             := vbToId
                                                       , inPartnerId        := vbPartnerId
                                                       , inContractId       := vbContractId
                                                       , inDocumentTaxKindId:= inDocumentTaxKindId
                                                       , inUserId           := vbUserId
                                                      ) AS MovementId_Corrective
                , tmpResult_insert.MovementId_Tax
           FROM (SELECT NEXTVAL ('movement_taxcorrective_seq') AS InvNumber
                      , lpInsertFind_Object_InvNumberTax (zc_Movement_TaxCorrective()
                                                        , vbOperDate, CASE WHEN vbOperDate >= '01.01.2016'
                                                                                THEN ''
                                                                           ELSE (SELECT ObjectString.ValueData
                                                                                 FROM (SELECT zfGet_Branch_AccessKey (lpGetAccessKey (vbUserId, zc_Enum_Process_InsertUpdate_Movement_TaxCorrective())) AS BranchId
                                                                                      ) AS tmp
                                                                                      INNER JOIN ObjectString ON ObjectString.ObjectId = tmp.BranchId AND ObjectString.DescId = zc_objectString_Branch_InvNumber()
                                                                                )
                                                                      END
                                                         ) AS InvNumberPartner
                      , tmpResult_insert.MovementId_Tax
                 FROM (SELECT DISTINCT MovementId_Tax FROM _tmpResult WHERE MovementId_Corrective = 0) AS tmpResult_insert
                ) AS tmpResult_insert
         ) AS tmpResult_insert
     WHERE _tmpResult.MovementId_Tax = tmpResult_insert.MovementId_Tax;


     -- ������� �������� ����� ������ � <��������� ����������>
     PERFORM lpInsertUpdate_MovementItem_TaxCorrective (ioId                 := 0
                                                      , inMovementId         := _tmpResult.MovementId_Corrective
                                                      , inGoodsId            := _tmpResult.GoodsId
                                                      , inAmount             := _tmpResult.Amount
                                                      , inPrice              := _tmpResult.OperPrice
                                                      , ioCountForPrice      := _tmpResult.CountForPrice
                                                      , inGoodsKindId        := _tmpResult.GoodsKindId
                                                      , inUserId             := vbUserId
                                                       )
     FROM _tmpResult;


     -- ��������� ����� � <��� ������������ ���������� ���������> � <������� �� ����������> ��� <������� ����� (������)> ��� <������������� ����>
     IF inDocumentTaxKindId = zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
     THEN
         -- ��� ���� ����������
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_DocumentTaxKind(), _tmpMovement_PriceCorrective.MovementId, inDocumentTaxKindId)
         FROM _tmpMovement_PriceCorrective;
     ELSE
         -- ��� ������ ���������
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_DocumentTaxKind(), inMovementId, inDocumentTaxKindId);
     END IF;

     IF inDocumentTaxKindId = zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
     THEN
          -- ������� ����� <���������� ���������> � <������������� ����>
          DELETE FROM MovementLinkMovement WHERE MovementId IN (SELECT MovementId_Corrective FROM _tmpMovement_PriceCorrective)
                                             AND MovementChildId IN (SELECT MovementId FROM _tmpMovement_PriceCorrective)
                                             AND DescId = zc_MovementLinkMovement_Master();
     ELSE
          -- ������������ ����� <���������� ���������> � <������� �� ����������> ��� <������� ����� (������)> ��� <������������� ����>
          PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Master(), MovementId_Corrective, inMovementId)
          FROM (SELECT DISTINCT MovementId_Corrective FROM _tmpResult) AS tmpResult_update;

          -- ������������ ����� <���������� ���������> � ����������
          PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Child(), MovementId_Corrective, MovementId_Tax)
          FROM (SELECT DISTINCT MovementId_Corrective, MovementId_Tax FROM _tmpResult ) AS tmpResult_update;
     END IF;


     -- ����������� �������� ����� �� <��������� ����������>
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId:= tmpResult_update.MovementId_Corrective)
     FROM (SELECT DISTINCT MovementId_Corrective FROM _tmpResult) AS tmpResult_update;


     -- ����� - �������� ��� <��������� ��������� (�������������)>
     outMessageText:= (SELECT MAX (COALESCE (lpComplete_Movement_TaxCorrective (inMovementId := tmpResult_complete.MovementId_Corrective
                                                                              , inUserId     := vbUserId)
                                           , ''))
                       FROM (SELECT DISTINCT MovementId_Corrective FROM _tmpResult) AS tmpResult_complete
                      );


     -- ���������
     IF (SELECT COUNT(*) FROM (SELECT DISTINCT MovementId_Corrective FROM _tmpResult) AS tmp) = 1
     THEN
         outMovementId_Corrective:= (SELECT MAX (MovementId_Corrective) FROM _tmpResult);
     END IF;

     -- ���������
     SELECT Object_TaxKind.Id, Object_TaxKind.ValueData
            INTO outDocumentTaxKindId, outDocumentTaxKindName
     FROM Object AS Object_TaxKind
     WHERE Object_TaxKind.Id = inDocumentTaxKindId;

if inSession = '5'
then
    RAISE EXCEPTION 'Admin - Errr _end ';
    -- '��������� �������� ����� 3 ���.'
end if;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Movement_TaxCorrective_From_Kind (Integer, Integer, Integer, Boolean, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 31.07.14                                        * add outMovementId_Corrective
 06.06.14                                        * add �������� - �����������/��������� ��������� �������� ������
 03.06.14                                        * add � ��������� ���� ������ ����� ��� ��� + � �������������� ���� ������ ����� ��� ���
 03.06.14                                        * add zc_Movement_PriceCorrective
 29.05.14                                        * add zc_MovementLinkObject_Partner
 20.05.14                                        * add zc_Movement_TransferDebtIn
 10.05.14                                        * add lpComplete_Movement_TaxCorrective
 01.05.14                                        * add lpInsertFind_Object_InvNumberTax
 10.04.14                                        * ALL
 13.02.14                                                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_TaxCorrective_From_Kind (inMovementId:= 3409416, inDocumentTaxKindId:= 0, inDocumentTaxKindId_inf:= 0, inIsTaxLink:= TRUE, inSession := '5');
-- SELECT * FROM gpInsertUpdate_Movement_TaxCorrective_From_Kind (inMovementId:= 3449385, inDocumentTaxKindId:= 0, inDocumentTaxKindId_inf:= 0, inIsTaxLink:= TRUE, inSession := '5');
