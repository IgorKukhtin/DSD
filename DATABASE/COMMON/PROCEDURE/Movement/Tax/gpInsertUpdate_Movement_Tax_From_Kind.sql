-- Function: gpInsertUpdate_Movement_Tax_From_Kind()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Tax_From_Kind (Integer, Integer, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Tax_From_Kind (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Tax_From_Kind (
    IN inMovementId                 Integer  , -- ���� ���������
    IN inDocumentTaxKindId          Integer  , -- ��� ������������ ���������� ���������
   OUT outInvNumberPartner_Master   TVarChar , --
   OUT outDocumentTaxKindName       TVarChar , --
    IN inSession                    TVarChar   -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbTaxId            Integer;
   DECLARE vbUserId           Integer;
   DECLARE vbOperDate         TDateTime;
   DECLARE vbStartDate        TDateTime;
   DECLARE vbEndDate          TDateTime;
   DECLARE vbInvNumber        TVarChar;
   DECLARE vbInvNumberPartner TVarChar;
   DECLARE vbPriceWithVAT     Boolean ;
   DECLARE vbVATPercent       TFloat;
   DECLARE vbFromId           Integer;
   DECLARE vbToId             Integer;
   DECLARE vbPartnerId        Integer;
   DECLARE vbContractId       Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Tax_From_Kind());
   
     -- 
     IF inDocumentTaxKindId <> zc_Enum_DocumentTaxKind_Tax()
     THEN
         RAISE EXCEPTION '������.��� ����.';
     END IF;


            IF inDocumentTaxKindId = zc_Enum_DocumentTaxKind_Tax()
            THEN
                -- �������� ��������� ��� ����������/�������� ����� ��
                SELECT MovementLinkMovement.MovementChildId 
                     , MovementSale.InvNumber
                     , MovementSale.InvNumberPartner_Master                     
                     , MovementSale.OperDate
                     , MovementSale.PriceWithVAT
                     , MovementSale.VATPercent
                     , ObjectLink_Contract_JuridicalBasis.ChildObjectId  -- �� ����
                     , ObjectLink_Partner_Juridical.ChildObjectId          -- ����
                     , MovementSale.ToId           	             -- ���������� 
                     , MovementSale.ContractId 
                       INTO vbTaxId, vbInvNumber, vbInvNumberPartner, vbOperDate, vbPriceWithVAT, vbVATPercent, vbFromId, vbToId, vbPartnerId, vbContractId
                FROM gpGet_Movement_Sale (inMovementId, CURRENT_DATE , inSession) AS MovementSale
                     LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                          ON ObjectLink_Partner_Juridical.ObjectId = MovementSale.ToId
                                         AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                     LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalBasis
                                          ON ObjectLink_Contract_JuridicalBasis.ObjectId = MovementSale.ContractId
                                         AND ObjectLink_Contract_JuridicalBasis.DescId = zc_ObjectLink_Contract_JuridicalBasis()
                     LEFT JOIN MovementLinkMovement ON MovementLinkMovement.MovementId = MovementSale.Id
                                                   AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Master();

                -- �������� ��������� ��� ����������/�������� ����� ��
                SELECT tmp.ioInvNumberPartner
                     , Object_DocumentTaxKind.ValueData
                     , tmp.ioId                   
                       INTO outInvNumberPartner_Master, outDocumentTaxKindName, vbTaxId
                FROM lpInsertUpdate_Movement_Tax (ioId := COALESCE (vbTaxId,0)
                                                , inInvNumber := vbInvNumber
                                                , ioInvNumberPartner := vbInvNumberPartner                    
                                                , inOperDate := vbOperDate
                                                , inChecked := FALSE
                                                , inDocument := FALSE
                                                , inPriceWithVAT := vbPriceWithVAT
                                                , inVATPercent := vbVATPercent
                                                , inFromId := vbFromId                                  -- �� ����
                                                , inToId := vbToId                                      -- ����
                                                , inPartnerId := vbPartnerId           	             -- ���������� 
                                                , inContractId := vbContractId
                                                , inDocumentTaxKindId := inDocumentTaxKindId
                                                , inUserId := vbUserId
                                                 ) AS tmp
                     LEFT JOIN Object AS Object_DocumentTaxKind ON Object_DocumentTaxKind.Id = inDocumentTaxKindID;

                -- ��������� ������� � ���������
                PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Master(), inMovementId, vbTaxId);
           
                -- ��������� 
                PERFORM lpInsertUpdate_MovementItem_Tax (ioId := COALESCE ( tmpGoodsTax.MovementItemId_Tax,0)    
                                                       , inMovementId := vbTaxId       
                                                       , inGoodsId := tmpGoodsSale.GoodsId
                                                       , inAmount := tmpGoodsSale.Amount_Sale
                                                       , inPrice := tmpGoodsSale.Price_Sale
                                                       , ioCountForPrice := tmpGoodsSale.CountForPrice_Sale
                                                       , inGoodsKindId := tmpGoodsSale.GoodsKindId
                                                       , inUserId := vbUserId)        
                FROM (SELECT MovementItem.ObjectId AS GoodsId
                           , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId 
                           , MIFloat_CountForPrice.ValueData AS CountForPrice_Sale
                           , MIFloat_Price.ValueData::TFloat AS Price_Sale
                           , SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0)) ::TFloat   AS Amount_Sale
                      FROM MovementItem 
                           JOIN MovementItemFloat AS MIFloat_Price
                                                  ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                 AND MIFloat_Price.DescId = zc_MIFloat_Price() 
                                                 AND MIFloat_Price.ValueData <> 0  
                           LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                       ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                      AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()                             
                           JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                  ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                 AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                                                 AND MIFloat_AmountPartner.ValueData <> 0    
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                            ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                      WHERE MovementItem.MovementId = inMovementId--130344--  --130344 --  
                        AND MovementItem.isErased = FALSE 
                      GROUP BY MovementItem.ObjectId
                             , MILinkObject_GoodsKind.ObjectId
                             , MIFloat_Price.ValueData 
                             , MIFloat_CountForPrice.ValueData 
                     ) AS tmpGoodsSale
                      LEFT JOIN (SELECT MovementItem.ObjectId AS GoodsId
                                      , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)  AS GoodsKindId
                                      , MIFloat_Price.ValueData::TFloat  AS Price_Tax
                                      , MovementItem.Amount::TFloat      AS Amount_Tax
                                      , MovementItem.Id AS MovementItemId_Tax 
                                 FROM Movement 
                                      JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                       AND MovementItem.Amount <> 0
                                                       AND MovementItem.isErased = FALSE 
                                      JOIN MovementItemFloat AS MIFloat_Price
                                                             ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                            AND MIFloat_Price.DescId = zc_MIFloat_Price() 
                                                            -- AND MIFloat_Price.ValueData <> 0
                                      LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                       ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                      AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                 WHERE Movement.Id = vbTaxId
                                   AND (Movement.StatusId = zc_Enum_Status_Complete() OR Movement.StatusId = zc_Enum_Status_UnComplete())
                                ) AS tmpGoodsTax ON tmpGoodsTax.GoodsId = tmpGoodsSale.GoodsId
                                                AND tmpGoodsTax.GoodsKindId = tmpGoodsSale.GoodsKindId
                                                AND tmpGoodsTax.Price_Tax = tmpGoodsSale.Price_Sale;

              -- ������� ������ ������ �� ���������                                   
               PERFORM gpMovementItem_Tax_SetErased (inMovementItemId := tmpGoodsTax.MovementItemId_Tax
                                                   , inSession := inSession)
               FROM (SELECT MovementItem.ObjectId AS GoodsId
                          , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)  AS GoodsKindId
                          , MIFloat_Price.ValueData::TFloat  AS Price_Tax
                          , MovementItem.Amount::TFloat      AS Amount_Tax
                          , MovementItem.Id AS MovementItemId_Tax 
                     FROM MovementItem
                          JOIN MovementItemFloat AS MIFloat_Price
                                                 ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                AND MIFloat_Price.DescId = zc_MIFloat_Price() 
                                                -- AND MIFloat_Price.ValueData <> 0
                          LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                           ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                     WHERE MovementItem.MovementId =  vbTaxId
                       AND MovementItem.Amount<>0
                       AND MovementItem.isErased = FALSE 
                    ) AS tmpGoodsTax 
                     LEFT JOIN (SELECT MovementItem.ObjectId AS GoodsId
                                     , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId 
                                     , MIFloat_CountForPrice.ValueData AS CountForPrice_Sale
                                     , MIFloat_Price.ValueData::TFloat AS Price_Sale
                                     , SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0)) ::TFloat   AS Amount_Sale
                                FROM MovementItem 
                                     JOIN MovementItemFloat AS MIFloat_Price
                                                            ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                           AND MIFloat_Price.DescId = zc_MIFloat_Price() 
                                                           AND MIFloat_Price.ValueData <> 0  
                                     LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                                 ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                                AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()                             
                                     JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                            ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                           AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                                                           AND MIFloat_AmountPartner.ValueData <> 0  
                                     LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                      ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                     AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                WHERE MovementItem.MovementId = inMovementId       --130344--  --130344 --  
                                  AND MovementItem.isErased = FALSE       
                                GROUP BY MovementItem.ObjectId
                                       , MILinkObject_GoodsKind.ObjectId
                                       , MIFloat_Price.ValueData 
                                       , MIFloat_CountForPrice.ValueData 
                            ) as tmpGoodsSale ON tmpGoodsSale.GoodsId = tmpGoodsTax.GoodsId
                                             AND tmpGoodsSale.GoodsKindId = tmpGoodsTax.GoodsKindId
                                             AND tmpGoodsSale.Price_Sale = tmpGoodsTax.Price_Tax 
               WHERE tmpGoodsSale.GoodsId IS NULL ;

            ELSE 

            IF inDocumentTaxKindId IN (zc_Enum_DocumentTaxKind_TaxSummaryJuridicalS(), zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR())
               THEN
               /* ������� ��������� ������� ��� ����� ���������� ������� / ��������� */
               CREATE TEMP TABLE _tmpGoodsSale (GoodsId Integer, GoodsKindId Integer, Price TFloat, CountForPrice TFloat, Amount TFloat) ON COMMIT DROP;
               
               /* �������� ��������� ��� ����������/�������� ����� �� */
               SELECT DATE_TRUNC ('Month', MovementSale.OperDate) -- '01.12.2013' :: TDateTime
                    , DATE_TRUNC ('Month', MovementSale.OperDate) + interval '1 month' - interval '1 day' -- '31.12.2013' :: TDateTime
             
                    , MovementLinkMovement.MovementChildId 
                    --, MovementSale.InvNumber
                    --, MovementSale.InvNumberPartner_Master  
                    , CASE WHEN (MovementLO_DocumentTaxKind.ObjectId = inDocumentTaxKindId AND Movement_Tax.StatusId <> zc_Enum_Status_Erased()) THEN Movement_Tax.InvNumber ELSE MovementSale.InvNumber END    
                    , CASE WHEN (MovementLO_DocumentTaxKind.ObjectId = inDocumentTaxKindId AND Movement_Tax.StatusId <> zc_Enum_Status_Erased()) THEN MovementSale.InvNumberPartner_Master ELSE '' END                                             
                    , MovementSale.OperDate
                    , MovementSale.PriceWithVAT
                    , MovementSale.VATPercent
                    , ObjectLink_Contract_JuridicalBasis.ChildObjectId    -- �� ����
                    , ObjectLink_Partner_Juridical.ChildObjectId          -- ����
                    , 0                                                   -- ����������   --MovementSale.ToId     -- ��� ��.���� �� ���� 
                    , MovementSale.ContractId 
                    
               INTO  vbStartDate, vbEndDate, vbTaxId, vbInvNumber, vbInvNumberPartner, vbOperDate, vbPriceWithVAT, vbVATPercent, vbFromId, vbToId, vbPartnerId, vbContractId

               FROM gpGet_Movement_Sale(inMovementId, CURRENT_DATE , inSession) AS MovementSale
               LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                    ON ObjectLink_Partner_Juridical.ObjectId = MovementSale.ToId
                                   AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
               
               LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalBasis
                                    ON ObjectLink_Contract_JuridicalBasis.ObjectId = MovementSale.ContractId
                                   AND ObjectLink_Contract_JuridicalBasis.DescId = zc_ObjectLink_Contract_JuridicalBasis()
               LEFT JOIN MovementLinkMovement ON MovementLinkMovement.MovementId = MovementSale.Id
                                             AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Master()
               LEFT JOIN Movement AS Movement_Tax ON Movement_Tax.Id = MovementLinkMovement.MovementChildId   
               LEFT JOIN MovementLinkObject AS MovementLO_DocumentTaxKind
                                            ON MovementLO_DocumentTaxKind.MovementId = MovementLinkMovement.MovementChildId
                                           AND MovementLO_DocumentTaxKind.DescId = zc_MovementLinkObject_DocumentTaxKind()
                                        -- AND (MovementLO_DocumentTaxKind.ObjectId = inDocumentTaxKindID OR inDocumentTaxKindID =0)
                                           
             ;
               -- ������� / ��������� ��, ��������� ��������� ���������
               SELECT tmp.ioInvNumberPartner
                    , Object_DocumentTaxKind.ValueData
                    , tmp.ioId                   
               INTO outInvNumberPartner_Master, outDocumentTaxKindName, vbTaxId
     
               FROM lpInsertUpdate_Movement_Tax(
                       ioId := COALESCE (vbTaxId,0)
                     , inInvNumber := vbInvNumber
                     , ioInvNumberPartner := vbInvNumberPartner                    
                     , inOperDate := vbEndDate
                     , inChecked := FALSE
                     , inDocument := FALSE
                     , inPriceWithVAT := vbPriceWithVAT
                     , inVATPercent := vbVATPercent
                     , inFromId := vbFromId                                  -- �� ����
                     , inToId := vbToId                                      -- ����
                     , inPartnerId := 0                                      -- ���������� 
                     , inContractId := vbContractId
                     , inDocumentTaxKindId := inDocumentTaxKindId
                     , inUserId := vbUserId ) as tmp

               LEFT JOIN Object AS Object_DocumentTaxKind ON Object_DocumentTaxKind.Id = inDocumentTaxKindID;
 
 
              -- ��������� ����� ���������� ������� � ���������
              PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Master(), Movement.Id, vbTaxId)
              FROM Movement 
                   JOIN MovementDate AS MovementDate_OperDatePartner
                                            ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                           AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner() 
                                           AND MovementDate_OperDatePartner.ValueData BETWEEN vbStartDate AND vbEndDate
                   JOIN MovementLinkObject AS MovementLinkObject_From
                                           ON MovementLinkObject_From.MovementId = Movement.Id
                                          AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                          AND MovementLinkObject_From.ObjectId NOT IN (8445, 8444) -- ����� ��������� + ����� ����������
                   JOIN MovementLinkObject AS MovementLinkObject_To
                                           ON MovementLinkObject_To.MovementId = Movement.Id
                                          AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                   JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                   ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                                  AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                  AND ObjectLink_Partner_Juridical.ChildObjectId = vbToId
                   JOIN MovementLinkObject AS MovementLinkObject_Contract
                                           ON MovementLinkObject_Contract.MovementId = Movement.Id
                                          AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                          AND MovementLinkObject_Contract.ObjectId = vbContractId
                                          
              WHERE Movement.StatusId <> zc_Enum_Status_Erased() -- zc_Enum_Status_Complete()
                AND Movement.DescId = zc_Movement_Sale();


          IF inDocumentTaxKindId = zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR()   ---zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerSR
             THEN 
                 -- ��������� ����� � <��� ������������ ���������� ���������> � ���������� �������
                 PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_DocumentTaxKind(), Movement.Id, zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalSR())
                 FROM Movement 
                      JOIN MovementDate AS MovementDate_OperDatePartner
                                        ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                       AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner() 
                                       AND MovementDate_OperDatePartner.ValueData BETWEEN vbStartDate AND vbEndDate
                      JOIN MovementLinkObject AS MovementLinkObject_To
                                              ON MovementLinkObject_To.MovementId = Movement.Id
                                             AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                             AND MovementLinkObject_To.ObjectId NOT IN (8445, 8444) -- ����� ��������� + ����� ����������
                      JOIN MovementLinkObject AS MovementLinkObject_From
                                              ON MovementLinkObject_From.MovementId = Movement.Id
                                             AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                      JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                      ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                                     AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                     AND ObjectLink_Partner_Juridical.ChildObjectId = vbToId
                      JOIN MovementLinkObject AS MovementLinkObject_Contract
                                              ON MovementLinkObject_Contract.MovementId = Movement.Id
                                             AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                             AND MovementLinkObject_Contract.ObjectId = vbContractId
                 WHERE Movement.StatusId <> zc_Enum_Status_Erased() -- zc_Enum_Status_Complete()
                   AND Movement.DescId = zc_Movement_ReturnIn();
          END IF;

              -- �������� ������ �� ���������� ������ � ���������, ���� (�������-�������)<0 ����������� �� ��  
              INSERT INTO _tmpGoodsSale (GoodsId, GoodsKindId, CountForPrice, Price, Amount)
                 select tmpGoods.GoodsId
                     , tmpGoods.GoodsKindId 
                     , tmpGoods.CountForPrice
                     , tmpGoods.Price
                     , sum (tmpGoods.Amount) ::TFloat   AS Amount
                 From (select MovementItem.ObjectId as GoodsId
                            , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId 
                            , MIFloat_CountForPrice.ValueData AS CountForPrice
                            , MIFloat_Price.ValueData::TFloat AS Price
                            , (COALESCE (MIFloat_AmountPartner.ValueData, 0)) ::TFloat   AS Amount
                       FROM Movement 
                            JOIN MovementDate AS MovementDate_OperDatePartner
                                              ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                             AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner() 
                                             AND MovementDate_OperDatePartner.ValueData BETWEEN vbStartDate AND vbEndDate ---BETWEEN '30.12.2013' and '31.12.2013'--
                            JOIN MovementLinkObject AS MovementLinkObject_To
                                                    ON MovementLinkObject_To.MovementId = Movement.Id
                                                   AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                            JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                           ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                                          AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                          AND ObjectLink_Partner_Juridical.ChildObjectId = vbToId
                            JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                   ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                  AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                                  AND MovementLinkObject_Contract.ObjectId = vbContractId
                            JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                             AND MovementItem.isErased = FALSE 
                            JOIN MovementItemFloat AS MIFloat_Price
                                                   ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                  AND MIFloat_Price.DescId = zc_MIFloat_Price() 
                                                  AND MIFloat_Price.ValueData <> 0
                            JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                   ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                  AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()                             
                            LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                        ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                       AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                                                       AND MIFloat_Price.ValueData <> 0 
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                       WHERE Movement.StatusId <> zc_Enum_Status_Erased() -- zc_Enum_Status_Complete()
                         AND Movement.DescId = zc_Movement_Sale()

                    UNION ALL 

                       SELECT  MovementItem.ObjectId as GoodsId
                             , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId 
                             , MIFloat_CountForPrice.ValueData AS CountForPrice
                             , MIFloat_Price.ValueData::TFloat AS Price
                             , (-1)*COALESCE (MIFloat_AmountPartner.ValueData, 0) ::TFloat   AS Amount
                       FROM Movement 
                            JOIN MovementDate AS MovementDate_OperDatePartner
                                              ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                             AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner() 
                                             AND MovementDate_OperDatePartner.ValueData BETWEEN vbStartDate AND vbEndDate
                            JOIN MovementLinkObject AS MovementLinkObject_From
                                                    ON MovementLinkObject_From.MovementId = Movement.Id
                                                   AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                            JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                            ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                                           AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                           AND ObjectLink_Partner_Juridical.ChildObjectId = vbToId
                            JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                   ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                  AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                                  AND MovementLinkObject_Contract.ObjectId = vbContractId
                            JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                             AND MovementItem.isErased = FALSE 
                            JOIN MovementItemFloat AS MIFloat_Price
                                                   ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                  AND MIFloat_Price.DescId = zc_MIFloat_Price() 
                                                  AND MIFloat_Price.ValueData <> 0
                            JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                   ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                  AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()                             
                            LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                        ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                       AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                                                       AND MIFloat_Price.ValueData <> 0 
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                       WHERE Movement.StatusId <> zc_Enum_Status_Erased() -- zc_Enum_Status_Complete()
                         AND Movement.DescId =zc_Movement_ReturnIn() 
                         AND inDocumentTaxKindID = zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR()
                       ) AS tmpGoods
                       GROUP BY  tmpGoods.GoodsId
                               , tmpGoods.GoodsKindId 
                               , tmpGoods.CountForPrice
                               , tmpGoods.Price
                       HAVING sum (tmpGoods.Amount) >0 

                         ;
              
               -- ��������� / ��������� ������ � ���������
               PERFORM lpInsertUpdate_MovementItem_Tax(
                       ioId := COALESCE ( tmpGoodsTax.MovementItemId_Tax,0)    
                     , inMovementId := vbTaxId       
                     , inGoodsId := _tmpGoodsSale.GoodsId
                     , inAmount := _tmpGoodsSale.Amount
                     , inPrice := _tmpGoodsSale.Price
                     , ioCountForPrice := _tmpGoodsSale.CountForPrice
                     , inGoodsKindId := _tmpGoodsSale.GoodsKindId
                     , inUserId := vbUserId)        
               FROM _tmpGoodsSale
                    LEFT JOIN (SELECT MovementItem.ObjectId AS GoodsId
                                    , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)  AS GoodsKindId
                                    , MIFloat_Price.ValueData::TFloat  AS Price_Tax
                                    , MovementItem.Amount::TFloat      AS Amount_Tax
                                    , MovementItem.Id AS MovementItemId_Tax 
                                FROM Movement 
                                      JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                       AND MovementItem.Amount<>0
                                                       AND MovementItem.isErased = FALSE 
                                      JOIN MovementItemFloat AS MIFloat_Price
                                                                 ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                                AND MIFloat_Price.DescId = zc_MIFloat_Price() 
                                                              --AND MIFloat_Price.ValueData <> 0
                                      LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                       ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                      AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                 WHERE Movement.Id =  vbTaxId
                                   AND (Movement.StatusId = zc_Enum_Status_Complete() OR Movement.StatusId = zc_Enum_Status_UnComplete())
                                 ) AS tmpGoodsTax ON tmpGoodsTax.GoodsId = _tmpGoodsSale.GoodsId
                                                 AND tmpGoodsTax.GoodsKindId = _tmpGoodsSale.GoodsKindId
                                                 AND tmpGoodsTax.Price_Tax = _tmpGoodsSale.Price;

              --������� ������ ������ �� ���������                                   
               PERFORM gpMovementItem_Tax_SetErased(
                       inMovementItemId := tmpGoodsTax.MovementItemId_Tax
                     , inSession := inSession)
               FROM (SELECT MovementItem.ObjectId AS GoodsId
                          , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)  AS GoodsKindId
                          , MIFloat_Price.ValueData::TFloat  AS Price_Tax
                          , MovementItem.Id AS MovementItemId_Tax 
                     FROM MovementItem
                          JOIN MovementItemFloat AS MIFloat_Price
                                                      ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                     AND MIFloat_Price.DescId = zc_MIFloat_Price() 
                                            
                          LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                           ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                     WHERE MovementItem.MovementId =  vbTaxId--173702 --  --
                      -- AND MovementItem.Amount<>0
                       AND MovementItem.isErased = FALSE 
                     ) AS tmpGoodsTax 
                     LEFT JOIN _tmpGoodsSale ON _tmpGoodsSale.GoodsId = tmpGoodsTax.GoodsId
                                            AND _tmpGoodsSale.GoodsKindId = tmpGoodsTax.GoodsKindId
                                            AND _tmpGoodsSale.Price = tmpGoodsTax.Price_Tax 
               WHERE _tmpGoodsSale.GoodsId IS NULL ;

            ELSE   
            IF inDocumentTaxKindId IN (zc_Enum_DocumentTaxKind_TaxSummaryPartnerS(), zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR())
               THEN
               /* ������� ��������� ������� ��� ����� ���������� ������ */
               CREATE TEMP TABLE _tmpGoodsSale (GoodsId Integer, GoodsKindId Integer, Price TFloat, CountForPrice TFloat, Amount TFloat) ON COMMIT DROP;
               
               /* �������� ��������� ��� ����������/�������� ����� �� */
               SELECT DATE_TRUNC ('Month', MovementSale.OperDate) -- '01.12.2013' :: TDateTime
                    , DATE_TRUNC ('Month', MovementSale.OperDate) + interval '1 month' - interval '1 day'  -- '31.12.2013' :: TDateTime
             
                    , CASE WHEN Movement_Tax.StatusId = zc_Enum_Status_Erased() THEN 0 ELSE MovementLinkMovement.MovementChildId END
                    --, MovementSale.InvNumber
                    , CASE WHEN (MovementLO_DocumentTaxKind.ObjectId = inDocumentTaxKindId AND Movement_Tax.StatusId <> zc_Enum_Status_Erased()) THEN Movement_Tax.InvNumber ELSE MovementSale.InvNumber END    
                    , CASE WHEN (MovementLO_DocumentTaxKind.ObjectId = inDocumentTaxKindId AND Movement_Tax.StatusId <> zc_Enum_Status_Erased()) THEN MovementSale.InvNumberPartner_Master ELSE '' END                                   
                    , MovementSale.OperDate
                    , MovementSale.PriceWithVAT
                    , MovementSale.VATPercent
                    , ObjectLink_Contract_JuridicalBasis.ChildObjectId    -- �� ����
                    , ObjectLink_Partner_Juridical.ChildObjectId          -- ����
                    , MovementSale.ToId                                   -- ���������� 
                    , MovementSale.ContractId 
                    
               INTO  vbStartDate, vbEndDate, vbTaxId, vbInvNumber, vbInvNumberPartner, vbOperDate, vbPriceWithVAT, vbVATPercent, vbFromId, vbToId, vbPartnerId, vbContractId

               FROM gpGet_Movement_Sale(inMovementId, CURRENT_DATE , inSession) AS MovementSale
               LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                    ON ObjectLink_Partner_Juridical.ObjectId = MovementSale.ToId
                                   AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
               
               LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalBasis
                                    ON ObjectLink_Contract_JuridicalBasis.ObjectId = MovementSale.ContractId
                                   AND ObjectLink_Contract_JuridicalBasis.DescId = zc_ObjectLink_Contract_JuridicalBasis()
               LEFT JOIN MovementLinkMovement ON MovementLinkMovement.MovementId = MovementSale.Id
                                             AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Master()
               LEFT JOIN Movement AS Movement_Tax ON Movement_Tax.Id = MovementLinkMovement.MovementChildId 
                                            --AND Movement_Tax.StatusId <> zc_Enum_Status_Erased() 
               LEFT JOIN MovementLinkObject AS MovementLO_DocumentTaxKind
                                                  ON MovementLO_DocumentTaxKind.MovementId = MovementLinkMovement.MovementChildId
                                                  AND MovementLO_DocumentTaxKind.DescId = zc_MovementLinkObject_DocumentTaxKind()
                                                 -- AND (MovementLO_DocumentTaxKind.ObjectId = inDocumentTaxKindID OR inDocumentTaxKindID =0)
               --where Movement_Tax.StatusId <> zc_Enum_Status_Erased() 
             ;
   
               SELECT tmp.ioInvNumberPartner
                    , Object_DocumentTaxKind.ValueData
                    , tmp.ioId                   
               INTO outInvNumberPartner_Master, outDocumentTaxKindName, vbTaxId

                -- ��� ��������� ���� �� �������� �� ��������?
               FROM lpInsertUpdate_Movement_Tax(
                       ioId := COALESCE (vbTaxId,0)
                     , inInvNumber := vbInvNumber
                     , ioInvNumberPartner := vbInvNumberPartner                    
                     , inOperDate := vbEndDate
                     , inChecked := FALSE
                     , inDocument := FALSE
                     , inPriceWithVAT := vbPriceWithVAT
                     , inVATPercent := vbVATPercent
                     , inFromId := vbFromId                                  -- �� ����
                     , inToId := vbToId                                      -- ����
                     , inPartnerId := vbPartnerId                            -- ���������� 
                     , inContractId := vbContractId
                     , inDocumentTaxKindId := inDocumentTaxKindId
                     , inUserId := vbUserId ) as tmp

               LEFT JOIN Object AS Object_DocumentTaxKind ON Object_DocumentTaxKind.Id = inDocumentTaxKindID;
 
 
              -- ��������� ����� ���������� ������� � ���������
              PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Master(), Movement.Id, vbTaxId)
              FROM Movement 
                   JOIN MovementDate AS MovementDate_OperDatePartner
                                            ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                           AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner() 
                                           AND MovementDate_OperDatePartner.ValueData BETWEEN vbStartDate AND vbEndDate
                   JOIN MovementLinkObject AS MovementLinkObject_From
                                           ON MovementLinkObject_From.MovementId = Movement.Id
                                          AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                          AND MovementLinkObject_From.ObjectId NOT IN (8445, 8444) -- ����� ��������� + ����� ����������
                   JOIN MovementLinkObject AS MovementLinkObject_To
                                           ON MovementLinkObject_To.MovementId = Movement.Id
                                          AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                          AND MovementLinkObject_To.ObjectId = vbPartnerId
                   JOIN MovementLinkObject AS MovementLinkObject_Contract
                                           ON MovementLinkObject_Contract.MovementId = Movement.Id
                                          AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                          AND MovementLinkObject_Contract.ObjectId = vbContractId
              WHERE Movement.StatusId <> zc_Enum_Status_Erased() -- zc_Enum_Status_Complete()
                AND Movement.DescId = zc_Movement_Sale();


          IF inDocumentTaxKindId = zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR()   ---zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerSR
             THEN 
                 -- ��������� ����� � <��� ������������ ���������� ���������> � inMovementMasterId
                 PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_DocumentTaxKind(), Movement.Id, zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerSR())
                 FROM Movement 
                      JOIN MovementDate AS MovementDate_OperDatePartner
                                        ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                       AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner() 
                                       AND MovementDate_OperDatePartner.ValueData BETWEEN vbStartDate AND vbEndDate
                      JOIN MovementLinkObject AS MovementLinkObject_To
                                              ON MovementLinkObject_To.MovementId = Movement.Id
                                             AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                             AND MovementLinkObject_To.ObjectId NOT IN (8445, 8444) -- ����� ��������� + ����� ����������
                      JOIN MovementLinkObject AS MovementLinkObject_From
                                              ON MovementLinkObject_From.MovementId = Movement.Id
                                             AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                             AND MovementLinkObject_From.ObjectId = vbPartnerId
                      JOIN MovementLinkObject AS MovementLinkObject_Contract
                                              ON MovementLinkObject_Contract.MovementId = Movement.Id
                                             AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                             AND MovementLinkObject_Contract.ObjectId = vbContractId
                 WHERE Movement.StatusId <> zc_Enum_Status_Erased() -- zc_Enum_Status_Complete()
                   AND Movement.DescId = zc_Movement_ReturnIn();
          END IF;

               
              INSERT INTO _tmpGoodsSale (GoodsId, GoodsKindId, CountForPrice, Price, Amount)
                select tmpGoods.GoodsId
                     , tmpGoods.GoodsKindId 
                     , tmpGoods.CountForPrice
                     , tmpGoods.Price
                     , sum (tmpGoods.Amount) ::TFloat   AS Amount
                From (select MovementItem.ObjectId as GoodsId
                           , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId 
                           , MIFloat_CountForPrice.ValueData AS CountForPrice
                           , MIFloat_Price.ValueData::TFloat AS Price
                           , COALESCE (MIFloat_AmountPartner.ValueData, 0) ::TFloat   AS Amount
                       FROM Movement 
                            JOIN MovementDate AS MovementDate_OperDatePartner
                                              ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                             AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner() 
                                             AND MovementDate_OperDatePartner.ValueData BETWEEN vbStartDate AND vbEndDate ---BETWEEN '30.12.2013' and '31.12.2013'--
                            JOIN MovementLinkObject AS MovementLinkObject_To
                                                    ON MovementLinkObject_To.MovementId = Movement.Id
                                                   AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                   AND MovementLinkObject_To.ObjectId = vbPartnerId
                            JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                   ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                  AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                                  AND MovementLinkObject_Contract.ObjectId = vbContractId
                            JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                             AND MovementItem.isErased = FALSE 
                            JOIN MovementItemFloat AS MIFloat_Price
                                                   ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                  AND MIFloat_Price.DescId = zc_MIFloat_Price() 
                                                  AND MIFloat_Price.ValueData <> 0
                            JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                   ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                  AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()                             
                            LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                        ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                       AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                                                       AND MIFloat_Price.ValueData <> 0 
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                       WHERE Movement.StatusId <> zc_Enum_Status_Erased() -- zc_Enum_Status_Complete()
                         AND Movement.DescId = zc_Movement_Sale()

                     UNION ALL 

                       SELECT  MovementItem.ObjectId as GoodsId
                             , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId 
                             , MIFloat_CountForPrice.ValueData AS CountForPrice
                             , MIFloat_Price.ValueData::TFloat AS Price
                             , (-1)*COALESCE (MIFloat_AmountPartner.ValueData, 0) ::TFloat   AS Amount
                       FROM Movement 
                            JOIN MovementDate AS MovementDate_OperDatePartner
                                              ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                             AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner() 
                                             AND MovementDate_OperDatePartner.ValueData BETWEEN vbStartDate AND vbEndDate
                            JOIN MovementLinkObject AS MovementLinkObject_From
                                                    ON MovementLinkObject_From.MovementId = Movement.Id
                                                   AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                   AND MovementLinkObject_From.ObjectId = vbPartnerId
                            JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                   ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                  AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                                  AND MovementLinkObject_Contract.ObjectId = vbContractId
                            JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                             AND MovementItem.isErased = FALSE 
                            JOIN MovementItemFloat AS MIFloat_Price
                                                   ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                  AND MIFloat_Price.DescId = zc_MIFloat_Price() 
                                                  AND MIFloat_Price.ValueData <> 0
                            JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                   ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                  AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()                             
                            LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                        ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                       AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                                                       AND MIFloat_Price.ValueData <> 0 
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                       WHERE Movement.StatusId <> zc_Enum_Status_Erased() -- zc_Enum_Status_Complete()
                         AND Movement.DescId =zc_Movement_ReturnIn() 
                         AND inDocumentTaxKindID = zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR()
                       ) AS tmpGoods
                       GROUP BY  tmpGoods.GoodsId
                               , tmpGoods.GoodsKindId 
                               , tmpGoods.CountForPrice
                               , tmpGoods.Price
                       HAVING sum (tmpGoods.Amount) >0 
                       
      ;

                -- ��������� / ��������� ������ � ���������
               PERFORM lpInsertUpdate_MovementItem_Tax(
                       ioId := COALESCE ( tmpGoodsTax.MovementItemId_Tax,0)    
                     , inMovementId := vbTaxId       
                     , inGoodsId := _tmpGoodsSale.GoodsId
                     , inAmount := _tmpGoodsSale.Amount
                     , inPrice := _tmpGoodsSale.Price
                     , ioCountForPrice := _tmpGoodsSale.CountForPrice
                     , inGoodsKindId := _tmpGoodsSale.GoodsKindId
                     , inUserId := vbUserId)        
               FROM _tmpGoodsSale
                    LEFT JOIN (SELECT MovementItem.ObjectId AS GoodsId
                                    , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)  AS GoodsKindId
                                    , MIFloat_Price.ValueData::TFloat                AS Price_Tax
                                    --, MovementItem.Amount::TFloat                    AS Amount_Tax
                                    , MovementItem.Id                                AS MovementItemId_Tax 
                                FROM Movement 
                                      JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                       AND MovementItem.Amount<>0
                                                       AND MovementItem.isErased = FALSE 
                                      JOIN MovementItemFloat AS MIFloat_Price
                                                             ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                            AND MIFloat_Price.DescId = zc_MIFloat_Price() 
                                                          --AND MIFloat_Price.ValueData <> 0
                                      LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                       ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                      AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                 WHERE Movement.Id =  vbTaxId--173702 --  --
                                   AND (Movement.StatusId = zc_Enum_Status_Complete() OR Movement.StatusId = zc_Enum_Status_UnComplete())
                                 ) AS tmpGoodsTax ON tmpGoodsTax.GoodsId = _tmpGoodsSale.GoodsId
                                                 AND tmpGoodsTax.GoodsKindId = _tmpGoodsSale.GoodsKindId
                                                 AND tmpGoodsTax.Price_Tax = _tmpGoodsSale.Price;

              --������� ������ ������ �� ���������                                   
               PERFORM gpMovementItem_Tax_SetErased(
                       inMovementItemId := tmpGoodsTax.MovementItemId_Tax
                     , inSession := inSession)
               FROM (SELECT MovementItem.ObjectId AS GoodsId
                          , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)  AS GoodsKindId
                          , MIFloat_Price.ValueData::TFloat  AS Price_Tax
                          , MovementItem.Id AS MovementItemId_Tax 
                     FROM MovementItem
                          JOIN MovementItemFloat AS MIFloat_Price
                                                      ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                     AND MIFloat_Price.DescId = zc_MIFloat_Price() 
                                            
                          LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                           ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                     WHERE MovementItem.MovementId =  vbTaxId--173702 --  --
                      -- AND MovementItem.Amount<>0
                       AND MovementItem.isErased = FALSE 
                     ) AS tmpGoodsTax 
                     LEFT JOIN _tmpGoodsSale ON _tmpGoodsSale.GoodsId = tmpGoodsTax.GoodsId
                                            AND _tmpGoodsSale.GoodsKindId = tmpGoodsTax.GoodsKindId
                                            AND _tmpGoodsSale.Price = tmpGoodsTax.Price_Tax 
               WHERE _tmpGoodsSale.GoodsId IS NULL ;
               
            ELSE 
                           
                  SELECT '12345/789'
                       , Object_DocumentTaxKind.ValueData
                  INTO outInvNumberPartner_Master, outDocumentTaxKindName

                  FROM Object AS Object_DocumentTaxKind
                  WHERE Object_DocumentTaxKind.Id = inDocumentTaxKindId;
            END IF; --zc_Enum_DocumentTaxKind_TaxSummaryPartnerS()
            END IF; --zc_Enum_DocumentTaxKind_TaxSummaryJuridicalS()
            END IF; -- zc_Enum_DocumentTaxKind_Tax()  
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Movement_Tax_From_Kind (Integer, Integer, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 29.03.14         *
 23.03.14                                        * all
 13.02.14                                                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_Tax_From_Kind(inMovementId := 21838, inDocumentTaxKindId:=80770, inSession := '5'); -- ���
-- SELECT gpInsertUpdate_Movement_Tax_From_Kind FROM gpInsertUpdate_Movement_Tax_From_Kind(inMovementId := 21838, inDocumentTaxKindId:=80770, inSession := '5'); -- ���

--select * from gpInsertUpdate_Movement_Tax_From_Kind(inMovementId := 153051 , inDocumentTaxKindId := 80789 ,  inSession := '5');

--select * from gpInsertUpdate_Movement_Tax_From_Kind(inMovementId := 156101 , inDocumentTaxKindId := 80790 ,  inSession := '5');
--select * from gpInsertUpdate_Movement_Tax_From_Kind(inMovementId := 26025 , inDocumentTaxKindId := 80790 ,  inSession := '5');
--select * from gpInsertUpdate_Movement_Tax_From_Kind(inMovementId := 24702 , inDocumentTaxKindId := 80790 ,  inSession := '5');
-- select * from gpInsertUpdate_Movement_Tax_From_Kind(inMovementId := 123778 , inDocumentTaxKindId := 80788 ,  inSession := '5');     
--select * from gpInsertUpdate_Movement_Tax_From_Kind(inMovementId := 16759 , inDocumentTaxKindId := zc_Enum_DocumentTaxKind_Tax() ,  inSession := '5');
