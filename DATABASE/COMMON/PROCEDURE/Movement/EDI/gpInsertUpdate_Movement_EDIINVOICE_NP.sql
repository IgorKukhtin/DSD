-- Function: gpInsertUpdate_Movement_EDI()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_EDIINVOICE_NP (TVarChar, TVarChar, TDateTime, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TBLOB, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_EDIINVOICE_NP(
    IN inDoc_UUID            TVarChar  , -- id ���������
    IN indocNumber           TVarChar  , -- ����� ���������
    IN indocDate             TDateTime , -- ���� ���������
    IN inJuridicalName       TVarChar  , -- ��. ����
    IN inGLNSender           TVarChar  , -- ��������� ������������� ����������
    IN inGLNReceiver         TVarChar  , -- ��������� ������������� ����������
    IN inDelivery_place_GLN  TVarChar  , -- ����� ��������
    IN inDeliveryNoteNumber  TVarChar  , -- ����� ���������
    IN inContractNumber      TVarChar  , -- ����� ��������   
    IN inInvoiceLines        TBLOB     , -- Json ������ �������
    
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS TABLE (MovementId Integer, IsInsert Boolean) 
AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbIsUpdate Boolean;

   DECLARE vbMovementId Integer;
   DECLARE vbMovementReturnInId Integer;
   DECLARE vbGoodsPropertyId Integer;
   DECLARE vbPartnerId Integer;
   DECLARE vbJuridicalId Integer;
   DECLARE vbDescCode TVarChar;
   DECLARE vbisLoad Boolean;
   
   vbDeliveryNoteNumber TVarChar;
   vbJuridicalName TVarChar;
   vbDelivery_place_GLN TVarChar; 
   vbJuridicalSaveId Integer;
   vbMasterEDI Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_EDI());
    vbUserId:= lpGetUserBySession (inSession);

    vbMovementId := NULL;
    vbIsUpdate := False;

    -- ��������
    IF (SELECT COUNT (*)
        FROM Movement
             INNER JOIN MovementString AS MovementString_Uuid
                                       ON MovementString_Uuid.MovementId =  Movement.Id
                                      AND MovementString_Uuid.DescId = zc_MovementString_Uuid()
                                      AND MovementString_Uuid.ValueData = inDoc_UUID
             INNER JOIN MovementFloat AS MovementFloat_MovementDesc
                                      ON MovementFloat_MovementDesc.MovementId =  Movement.Id
                                     AND MovementFloat_MovementDesc.DescId = zc_MovementFloat_MovementDesc()
                                     AND MovementFloat_MovementDesc.ValueData = zc_Movement_ReturnIn()
        WHERE Movement.DescId = zc_Movement_EDI()
          AND Movement.OperDate >= indocDate - Interval '30 DAY'
          AND Movement.OperDate <= indocDate + Interval '30 DAY'
          AND Movement.StatusId <> zc_Enum_Status_Erased()
        ) > 1
    THEN
      RAISE EXCEPTION '������.�������� EDI � <%> �� <%> �� ����������� GLN = <%> �������� ������ 1 ����.', indocNumber, DATE (indocDate), inGLNReceiver;
    END IF;
     
    -- ������� �������� 
    vbMovementId:= (SELECT Movement.Id
                    FROM Movement
                         INNER JOIN MovementString AS MovementString_Uuid
                                                   ON MovementString_Uuid.MovementId =  Movement.Id
                                                  AND MovementString_Uuid.DescId = zc_MovementString_Uuid()
                                                  AND MovementString_Uuid.ValueData = inDoc_UUID
                         INNER JOIN MovementFloat AS MovementFloat_MovementDesc
                                                  ON MovementFloat_MovementDesc.MovementId =  Movement.Id
                                                 AND MovementFloat_MovementDesc.DescId = zc_MovementFloat_MovementDesc()
                                                 AND MovementFloat_MovementDesc.ValueData = zc_Movement_ReturnIn()
                    WHERE Movement.DescId = zc_Movement_EDI()
                      AND Movement.OperDate >= indocDate - Interval '30 DAY'
                      AND Movement.OperDate <= indocDate + Interval '30 DAY'
                      AND Movement.StatusId <> zc_Enum_Status_Erased()
                    );
     
    -- ���� �� �����
    IF COALESCE (vbMovementId, 0) = 0
    THEN
        -- ����� ��������� �� ������������
        vbIsInsert:= TRUE;
        
        -- ��������� <��������>
        vbMovementId := lpInsertUpdate_Movement (vbMovementId, zc_Movement_EDI(), indocNumber, indocDate, NULL);

        -- ���������
        PERFORM lpInsertUpdate_MovementString (zc_MovementString_Uuid(), vbMovementId, inDoc_UUID);
        
        -- ���������
        PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_MovementDesc(), vbMovementId, zc_Movement_ReturnIn());
        
        -- ���������
        PERFORM lpInsertUpdate_MovementString (zc_MovementString_GLNCode(), vbMovementId, inGLNSender);

        -- ���������
        PERFORM lpInsert_Movement_EDIEvents(vbMovementId, '�������� DOCUMENTINVOICE_NP �� EDIn', vbUserId);
    ELSE
        vbIsInsert:= FALSE;
        
       SELECT MovementString_InvNumberSaleLink.ValueData AS DeliveryNoteNumber
            , MovementString_JuridicalName.ValueData     AS JuridicalName
            , MovementString_GLNPlaceCode.ValueData      AS GLNPlaceCode
            , MovementLinkObject_Juridical.ObjectId      AS Juridical
            , MovementLinkMovement_MasterEDI.MovementId  AS MasterEDI              
       INTO vbDeliveryNoteNumber, vbJuridicalName, vbDelivery_place_GLN, vbJuridicalSaveId, vbMasterEDI
       FROM Movement
       
            LEFT JOIN MovementString AS MovementString_InvNumberSaleLink
                                     ON MovementString_InvNumberSaleLink.MovementId =  Movement.Id
                                    AND MovementString_InvNumberSaleLink.DescId = zc_MovementString_InvNumberSaleLink()
       
            LEFT JOIN MovementString AS MovementString_JuridicalName
                                     ON MovementString_JuridicalName.MovementId =  Movement.Id
                                    AND MovementString_JuridicalName.DescId = zc_MovementString_JuridicalName()
       
            LEFT JOIN MovementString AS MovementString_GLNPlaceCode
                                     ON MovementString_GLNPlaceCode.MovementId =  Movement.Id
                                    AND MovementString_GLNPlaceCode.DescId = zc_MovementString_GLNPlaceCode()
       
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                         ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                        AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
       
            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_MasterEDI
                                           ON MovementLinkMovement_MasterEDI.MovementChildId = Movement.Id 
                                          AND MovementLinkMovement_MasterEDI.DescId = zc_MovementLinkMovement_MasterEDI()
       
       WHERE Movement.DescId = zc_Movement_EDI()
         AND Movement.Id = vbMovementId;
        
    END IF;

    -- ���������
    IF COALESCE (inDeliveryNoteNumber, '') <> COALESCE (vbDeliveryNoteNumber, '')
    THEN
       vbIsUpdate := TRUE;

      PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberSaleLink(), vbMovementId, inDeliveryNoteNumber);
    END IF;
        
    -- ���������
    IF COALESCE (inJuridicalName, '') <> COALESCE (vbJuridicalName, '')
    THEN
       vbIsUpdate := TRUE;

      PERFORM lpInsertUpdate_MovementString (zc_MovementString_JuridicalName(), vbMovementId, inJuridicalName);
    END IF;

    IF inDelivery_place_GLN <> ''
    THEN
    
       IF COALESCE (inDelivery_place_GLN, '') <> COALESCE (vbDelivery_place_GLN, '')
       THEN
         vbIsUpdate := TRUE;
         PERFORM lpInsertUpdate_MovementString (zc_MovementString_GLNPlaceCode(), vbMovementId, inDelivery_place_GLN);
       END IF;
       
       -- �������� ���������� ����� � ������ ��������
        vbPartnerId := COALESCE((SELECT MIN (ObjectId)
                   FROM ObjectString WHERE DescId = zc_ObjectString_Partner_GLNCode() AND ValueData = inDelivery_place_GLN), 0);
       IF vbPartnerId <> 0 THEN
          PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Partner(), vbMovementId, vbPartnerId);
       END IF;
    END IF;

    IF vbPartnerId <> 0 
    THEN -- ������� �� ���� �� �����������
       vbJuridicalId := COALESCE((SELECT ChildObjectId FROM ObjectLink WHERE DescId = zc_ObjectLink_Partner_Juridical() AND ObjectId = vbPartnerId), 0);
    END IF;

    IF COALESCE (vbJuridicalId, 0) <> COALESCE (vbJuridicalSaveId, 0)
    THEN
       vbIsUpdate := TRUE;

       -- ��������� <�� ����>
       PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Juridical(), vbMovementId, vbJuridicalId);
       -- ��������� <����>
       PERFORM lpInsertUpdate_MovementString (zc_MovementString_OKPO(), vbMovementId, (SELECT OKPO FROM ObjectHistory_JuridicalDetails_View WHERE JuridicalId = vbJuridicalId));

       -- ����� <������������� �������>
       -- vbGoodsPropertyID := (SELECT ChildObjectId FROM ObjectLink WHERE DescId = zc_ObjectLink_Juridical_GoodsProperty() AND ObjectId = vbJuridicalId);
       vbGoodsPropertyId := zfCalc_GoodsPropertyId ((SELECT MLO_Contract.ObjectId FROM MovementLinkObject AS MLO_Contract WHERE MLO_Contract.MovementId = vbMovementId AND MLO_Contract.DescId = zc_MovementLinkObject_Contract())
                                                  , vbJuridicalId
                                                  , vbPartnerId
                                                   );
       -- ��������� <������������� �������>
       PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_GoodsProperty(), vbMovementId, vbGoodsPropertyId);

    END IF;

    -- �������� ����� ������������
/*    IF vbIsInsert = TRUE
    THEN
        PERFORM lpInsert_LockUnique (inKeyData:= 'Movement'
                                       || ';' || zc_Movement_EDI() :: TVarChar
                                       || ';' || inOrderInvNumber
                                       || ';' || zfConvert_DateToString (inOrderOperDate)
                                       || ';' || inGLNPlace
                                   , inUserId:= vbUserId);
    END IF;
*/

    
    -- �������� ������
    inInvoiceLines := replace(inInvoiceLines, '{"LineItem":', '');
    inInvoiceLines := replace(inInvoiceLines, '}}', '}');

    inInvoiceLines := replace(inInvoiceLines, '"LineNumber"',          '"linenumber"');
    inInvoiceLines := replace(inInvoiceLines, '"EAN"',                 '"ean"');
    inInvoiceLines := replace(inInvoiceLines, '"BuyerItemCode"',       '"buyeritemcode"');
    inInvoiceLines := replace(inInvoiceLines, '"ItemDescription"',     '"itemdescription"');
    inInvoiceLines := replace(inInvoiceLines, '"InvoiceQuantity"',     '"invoicequantity"');
    inInvoiceLines := replace(inInvoiceLines, '"UnitOfMeasure"',       '"unitofmeasure"');
    inInvoiceLines := replace(inInvoiceLines, '"InvoiceUnitNetPrice"', '"invoiceunitnetprice"');
    inInvoiceLines := replace(inInvoiceLines, '"TaxRate"',             '"taxrate"');
    inInvoiceLines := replace(inInvoiceLines, '"NetAmount"',           '"netamount"');
    
    CREATE TEMP TABLE tmpInvoiceLines
    (
       LineNumber          Integer,
       EAN                 TVarChar,
       BuyerItemCode       TVarChar,
       ItemDescription     TVarChar,
       InvoiceQuantity     TFloat,
       UnitOfMeasure       TVarChar,
       InvoiceUnitNetPrice TFloat,
       TaxRate             TFloat,
       NetAmount           TFloat
    ) ON COMMIT DROP;

    INSERT INTO tmpInvoiceLines
    SELECT *
    FROM json_populate_recordset(null::tmpInvoiceLines, replace(replace(replace(inInvoiceLines, '&quot;', '\"'), CHR(9),''), CHR(10),'')::json);

    PERFORM gpInsertUpdate_MI_EDIINVOICE_NP(inMovementId          := vbMovementId
                                          , inGoodsPropertyId     := vbGoodsPropertyId
                                          , inLineNumber          := IL.LineNumber
                                          , inEAN                 := IL.EAN
                                          , inGLNCode             := il.BuyerItemCode
                                          , inGoodsName           := IL.ItemDescription
                                          , inAmountPartner       := IL.InvoiceQuantity
                                          , inPricePartner        := IL.InvoiceUnitNetPrice
                                          , inSummPartner         := IL.NetAmount
                                          , inSession             := inSession)
    FROM tmpInvoiceLines AS IL; 
    
    -- ������ ID �������� ����������
    WITH tmpMovementReturnIn AS (SELECT DISTINCT MI_ReturnOut.Movementid AS Id
                                 FROM Movement 

                                      INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                             AND MovementItem.DescId = zc_MI_Master() 
                                                             AND MovementItem.iserased = False
                                                              
                                      INNER JOIN MovementItemFloat AS MIFloat_MovementSalleId 
                                                                   ON MIFloat_MovementSalleId.DescId = zc_MIFloat_MovementId()
                                                                  AND MIFloat_MovementSalleId.ValueData = Movement.Id 
                                                                   
                                      INNER JOIN MovementItem AS MI_ReturnOut
                                                              ON MI_ReturnOut.Id = MIFloat_MovementSalleId.MovementItemId
                                                             AND MI_ReturnOut.DescId = zc_MI_Master()                                                            
                                                             AND MI_ReturnOut.iserased = False
                                       

                                 WHERE Movement.InvNumber = inDeliveryNoteNumber
                                   AND Movement.DescId = zc_Movement_Sale())
                                   
                                   
       , tmpMIReturnIn AS (SELECT MovementItem.*
                           FROM tmpMovementReturnIn AS Movement

                                INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                       AND MovementItem.DescId = zc_MI_Master() 
                                                       AND MovementItem.iserased = False

                           )
       , tmpAmountPartner AS (SELECT *
                              FROM MovementItemFloat AS MIFloat_AmountPartner 
                              WHERE MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                                AND MIFloat_AmountPartner.MovementItemId in (SELECT tmpMIReturnIn.Id FROM tmpMIReturnIn)

                             )
       , tmpReturnIn AS (SELECT MovementItem.MovementId
                              , MovementItem.ObjectId
                              , SUM(MIFloat_AmountPartner.ValueData)::TFloat AS Amount
                         FROM tmpMIReturnIn AS MovementItem

                              INNER JOIN tmpAmountPartner AS MIFloat_AmountPartner 
                                                          ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id 
                                                          
                         GROUP BY MovementItem.MovementId
                                , MovementItem.ObjectId 
                         )
       , tmpReturnInSum AS (SELECT MovementItem.MovementId
                              , SUM(MovementItem.Amount)::TFloat   AS Amount
                              , string_agg(MovementItem.ObjectId::Text, ',' ORDER BY MovementItem.ObjectId) AS GoodsList
                         FROM tmpReturnIn AS MovementItem
                         GROUP BY MovementItem.MovementId
                         )

       , tmpMIEDI AS (SELECT MovementItem.*
                      FROM MovementItem 
                      WHERE MovementItem.MovementId = vbMovementId
                        AND MovementItem.DescId = zc_MI_Master() 
                        AND MovementItem.iserased = False

                        )
       , tmpAmountPartnerEDI AS (SELECT *
                              FROM MovementItemFloat AS MIFloat_AmountPartner 
                              WHERE MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                                AND MIFloat_AmountPartner.MovementItemId in (SELECT tmpMIEDI.Id FROM tmpMIEDI)

                             )
       , tmpEDI AS (SELECT MovementItem.MovementId
                         , MovementItem.ObjectId
                         , SUM(MIFloat_AmountPartner.ValueData)::TFloat AS Amount
                    FROM tmpMIEDI AS MovementItem

                         INNER JOIN tmpAmountPartnerEDI AS MIFloat_AmountPartner 
                                                        ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id 
                                                          
                    GROUP BY MovementItem.MovementId
                           , MovementItem.ObjectId 
                    )
       , tmpEDISum AS (SELECT MovementItem.MovementId
                            , SUM(MovementItem.Amount)::TFloat   AS Amount
                            , string_agg(MovementItem.ObjectId::Text, ',' ORDER BY MovementItem.ObjectId) AS GoodsList
                       FROM tmpEDI AS MovementItem
                       GROUP BY MovementItem.MovementId
                       )
                                                                
    SELECT MAX(tmpReturnInSum.MovementId)
    INTO vbMovementReturnInId
    FROM tmpReturnInSum
    
         INNER JOIN tmpEDISum ON tmpEDISum.Amount = tmpReturnInSum.Amount
                             AND tmpEDISum.GoodsList = tmpReturnInSum.GoodsList;

    -- ������������ ����� <������� �� ����������> � EDI
    IF COALESCE(vbMovementReturnInId, 0) <> COALESCE(vbMasterEDI, 0) 
    THEN
      vbIsUpdate := TRUE;
      PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_MasterEDI(), vbMovementReturnInId, vbMovementId);
    
      -- ���������
      IF COALESCE ((SELECT MLO_Contract.ObjectId FROM MovementLinkObject AS MLO_Contract WHERE MLO_Contract.MovementId = vbMovementReturnInId AND MLO_Contract.DescId = zc_MovementLinkObject_Contract()), 0) <> 0
      THEN
        PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), vbMovementId, (SELECT MLO_Contract.ObjectId FROM MovementLinkObject AS MLO_Contract WHERE MLO_Contract.MovementId = vbMovementReturnInId AND MLO_Contract.DescId = zc_MovementLinkObject_Contract()));
      END IF;
    END IF;
      

    -- ��������� ��������
    IF vbIsInsert = TRUE OR vbIsUpdate = TRUE
    THEN
      PERFORM lpInsert_MovementProtocol (vbMovementId, vbUserId, vbIsInsert);    
    END IF;

    RETURN QUERY
    SELECT vbMovementId, vbIsInsert;
                      
    --RAISE EXCEPTION '������. % % %', vbMovementId, vbMovementReturnInId, vbIsUpdate;           

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 05.06.24                                                       *

*/

-- ����
--
  