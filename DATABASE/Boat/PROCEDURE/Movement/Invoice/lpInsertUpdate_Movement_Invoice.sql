-- Function: lpInsertUpdate_Movement_Invoice()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Invoice (Integer, Integer, TVarChar, TDateTime, TDateTime, TFloat, TFloat, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Invoice (Integer, Integer, TVarChar, TDateTime, TDateTime, TFloat, TFloat, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_Invoice(
 INOUT ioId               Integer  ,  --
    IN inParentId         Integer  ,  --
    IN inInvNumber        TVarChar ,  -- ����� ���������
    IN inOperDate         TDateTime,  --
    IN inPlanDate         TDateTime,  -- �������� ���� ������ �� �����
    IN inVATPercent       TFloat   ,  --
    IN inAmount           TFloat   ,  --
    IN inInvNumberPartner TVarChar ,  -- ����� ��������� - External Nr
    IN inReceiptNumber    TVarChar ,  -- ����������� ����� ��������� - Quittung Nr, ����������� ������ ��� Amount>0
    IN inComment          TVarChar ,  --
    IN inObjectId         Integer  ,  --
    IN inUnitId           Integer  ,  --
    IN inInfoMoneyId      Integer  ,  --
    IN inPaidKindId       Integer  ,  --
    IN inInvoiceKindId    Integer  ,
    IN inUserId           Integer      -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
     -- �������� - �������� ������ ���� �����������
     IF COALESCE (inObjectId, 0) = 0 THEN
        RAISE EXCEPTION '������.�� ���������� �������� <Lieferanten / Kunden>.';
     END IF;

     -- �������� - �������� ������ ���� �����������
     IF COALESCE (inInfoMoneyId, 0) = 0 THEN
        RAISE EXCEPTION '������.�� ���������� <�������� ����������>.';
     END IF;

     -- �������� - �������� ������ ���� �����������
     IF COALESCE (inInvoiceKindId, 0) = 0 THEN
        RAISE EXCEPTION '������.�� ���������� �������� <��� �����>.';
     END IF;

     -- �������� - �������� ������ ���� �����������
     IF zfConvert_StringToNumber (inReceiptNumber) = 0 AND inInvoiceKindId <> zc_Enum_InvoiceKind_Proforma()
     THEN
        RAISE EXCEPTION '������.�� ���������� �������� <Invoice No>.';
     END IF;

     -- ��������
     IF COALESCE (inVATPercent, 0) <> COALESCE ((SELECT ObjectFloat_TaxKind_Value.ValueData
                                                 FROM ObjectLink AS ObjectLink_TaxKind
                                                      LEFT JOIN Object ON Object.Id = ObjectLink_TaxKind.ObjectId
                                                      LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                                                            ON ObjectFloat_TaxKind_Value.ObjectId = ObjectLink_TaxKind.ChildObjectId
                                                                           AND ObjectFloat_TaxKind_Value.DescId   = zc_ObjectFloat_TaxKind_Value()
                                                 WHERE ObjectLink_TaxKind.ObjectId = inObjectId
                                                   AND ObjectLink_TaxKind.DescId   = CASE WHEN Object.DescId = zc_Object_Partner() THEN zc_ObjectLink_Partner_TaxKind() ELSE zc_ObjectLink_Client_TaxKind() END
                                                ), 0)
     THEN
         RAISE EXCEPTION '������.�������� <% ���> � ��������� = <%> �� ������������� �������� � <Lieferanten / Kunden> = <%>.'
                       , '%'
                       , zfConvert_FloatToString (inVATPercent)
                       , zfConvert_FloatToString (COALESCE ((SELECT ObjectFloat_TaxKind_Value.ValueData
                                                             FROM ObjectLink AS ObjectLink_TaxKind
                                                                  LEFT JOIN Object ON Object.Id = ObjectLink_TaxKind.ObjectId
                                                                  LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                                                                        ON ObjectFloat_TaxKind_Value.ObjectId = ObjectLink_TaxKind.ChildObjectId
                                                                                       AND ObjectFloat_TaxKind_Value.DescId   = zc_ObjectFloat_TaxKind_Value()
                                                             WHERE ObjectLink_TaxKind.ObjectId = inObjectId
                                                               AND ObjectLink_TaxKind.DescId   = CASE WHEN Object.DescId = zc_Object_Partner() THEN zc_ObjectLink_Partner_TaxKind() ELSE zc_ObjectLink_Client_TaxKind() END
                                                            ), 0))
                        ;
     END IF;


    -- inReceiptNumber ����������� ������ ��� Amount > 0
    IF (COALESCE (inAmount, 0) <= 0 AND inInvoiceKindId <> zc_Enum_InvoiceKind_Return()) OR inInvoiceKindId = zc_Enum_InvoiceKind_Proforma()
    THEN
        inReceiptNumber := NULL;
    ELSE
        -- ���� ����� ����� ��� ������, �.�. ����������� ��������
        IF EXISTS (SELECT 1
                   FROM MovementString
                        JOIN Movement ON Movement.Id       = MovementString.MovementId
                                     AND Movement.DescId   = zc_Movement_Invoice()
                                     AND Movement.StatusId <> zc_Enum_Status_Erased()
                   WHERE MovementString.DescId    = zc_MovementString_ReceiptNumber()
                     AND MovementString.ValueData = TRIM (inReceiptNumber)
                     -- ������ ��������
                     AND MovementString.MovementId <> ioId
                  )
        THEN
            -- ��� ��� ������
            inReceiptNumber:= 1 + COALESCE ((SELECT MAX (zfConvert_StringToNumber (MovementString.ValueData))
                                             FROM MovementString
                                                  JOIN Movement ON Movement.Id       = MovementString.MovementId
                                                               AND Movement.DescId   = zc_Movement_Invoice()
                                                               AND Movement.StatusId = zc_Enum_Status_Complete()
                                             WHERE MovementString.DescId = zc_MovementString_ReceiptNumber()
                                            ), 0);
            -- !!!�������� ������������!!! - ����� ��������

        END IF;

    END IF;


    -- ������� Parent
    IF inParentId > 0
    THEN
         -- ���� ������ �� ������ �������� - ����� ��� �����
         IF EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = ioId AND Movement.ParentId > 0 AND Movement.ParentId <> inParentId)
         THEN
             -- � ���. ParentId - ��� ����� ��� ����� - �������� ����� �� ������
             PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Invoice(), (SELECT Movement.ParentId FROM Movement WHERE Movement.Id = ioId), NULL);
         END IF;

         -- ���� ���� ��� ������, � � ������ ��� ����� �� ������ ��� ��� ����
         IF ioId > 0 AND (NOT EXISTS (SELECT 1 FROM MovementLinkMovement AS MLM JOIN Movement ON Movement.Id = MLM.MovementChildId AND Movement.StatusId <> zc_Enum_Status_Erased() WHERE MLM.MovementId = inParentId AND MLM.DescId = zc_MovementLinkMovement_Invoice())
                       OR inInvoiceKindId = zc_Enum_InvoiceKind_Pay()
                         )
         THEN
             -- � ���. ParentId - ��� ����� ��� ����� ���������� ����� �� ������
             PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Invoice(), inParentId, ioId);
         END IF;

    -- ���� ��� ����
    ELSEIF EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = ioId AND Movement.ParentId > 0)
    THEN
         -- � ���. ParentId - ��� ����� ��� ����� - �������� ����� �� ������
         PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Invoice(), (SELECT Movement.ParentId FROM Movement WHERE Movement.Id = ioId), NULL);
    END IF;


    -- ���������� ������� ��������/�������������
    vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- ��������� <��������>
    ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Invoice(), inInvNumber, inOperDate, inParentId, 0);

    -- ��������� ����� � <>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Object(), ioId, inObjectId);
    -- ��������� ����� � <>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Unit(), ioId, inUnitId);
    -- ��������� ����� � <>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidKind(), ioId, inPaidKindId);
    -- ��������� ����� � <>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_InfoMoney(), ioId, inInfoMoneyId);
    -- ��������� ����� � <>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_InvoiceKind(), ioId, inInvoiceKindId);


    -- ��������� <>
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Plan(), ioId, inPlanDate);

    -- ��������� �������� <% ���>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_VATPercent(), ioId, inVATPercent);
    -- ��������� �������� <����� �����>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_Amount(), ioId, inAmount);

    --  External Nr
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberPartner(), ioId, inInvNumberPartner);
    -- ����������� ����� ���������
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_ReceiptNumber(), ioId, inReceiptNumber);
    -- ����������
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);


    -- ���� ���� ��� ������ + � ������ ��� ����� �� ������ ��� ��� ����
    IF vbIsInsert = TRUE AND inParentId > 0
       AND (NOT EXISTS (SELECT 1 FROM MovementLinkMovement AS MLM JOIN Movement ON Movement.Id = MLM.MovementChildId AND Movement.StatusId <> zc_Enum_Status_Erased() WHERE MLM.MovementId = inParentId AND MLM.DescId = zc_MovementLinkMovement_Invoice())
         OR inInvoiceKindId = zc_Enum_InvoiceKind_Pay()
           )
    THEN
        -- � ���. ParentId - ��� ����� ��� ����� ���������� ����� �� ������
        PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Invoice(), inParentId, ioId);
    END IF;

    -- !!!�������� ����� �������� ����������� �������!!!
    IF vbIsInsert = FALSE
    THEN
        -- ��������� �������� <���� �������������>
        PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Update(), ioId, CURRENT_TIMESTAMP);
        -- ��������� �������� <������������ (�������������)>
        PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Update(), ioId, inUserId);
    ELSE
        IF vbIsInsert = TRUE
        THEN
            -- ��������� �������� <���� ��������>
            PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
            -- ��������� �������� <������������ (��������)>
            PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), ioId, inUserId);
        END IF;
    END IF;


    -- ��������� ��������
    PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 07.12.23         *
 02.02.21         *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_Movement_Invoice
