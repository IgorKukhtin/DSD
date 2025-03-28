-- Function: gpInsertUpdate_Movement_Income()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Income (Integer, TVarChar, TVarChar, TVarChar, TVarChar, TDateTime, TDateTime, Boolean, TFloat, TFloat, Integer, Integer, Integer, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_Income(
 INOUT ioId                  Integer   , -- ���� ������� <�������� �����������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inInvNumberPartner    TVarChar  , -- ����� ��������� (�������)
    IN inInvNumberPack       TVarChar  , -- ����� ����������� ����
    IN inInvNumberInvoice    TVarChar  , -- ����� �����
    IN inOperDate            TDateTime , -- ���� ���������
    IN inOperDatePartner     TDateTime , -- ���� ��������� � �����������
    IN inPriceWithVAT        Boolean   , -- ���� � ��� (��/���)
    IN inVATPercent          TFloat    , --
    IN inDiscountTax         TFloat    , --
    IN inFromId              Integer   , -- �� ���� (� ���������)
    IN inToId                Integer   , -- ����
    IN inPaidKindId          Integer   , -- ��
    IN inComment             TVarChar  , -- ����������
    IN inUserId              Integer     -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
   DECLARE vbInvNumberPoint Integer;
BEGIN
     -- ��������
     IF COALESCE (inVATPercent, 0) <> COALESCE ((SELECT ObjectFloat_TaxKind_Value.ValueData
                                                 FROM ObjectLink AS OL_Partner_TaxKind
                                                      LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                                                            ON ObjectFloat_TaxKind_Value.ObjectId = OL_Partner_TaxKind.ChildObjectId 
                                                                           AND ObjectFloat_TaxKind_Value.DescId   = zc_ObjectFloat_TaxKind_Value()   
                                                 WHERE OL_Partner_TaxKind.ObjectId = inFromId
                                                   AND OL_Partner_TaxKind.DescId   = zc_ObjectLink_Partner_TaxKind()
                                                ), 0)
     THEN
         RAISE EXCEPTION '������.�������� <% ���> � ��������� = <%> �� ������������� �������� � ���������� = <%>.'
                       , '%'
                       , zfConvert_FloatToString (inVATPercent)
                       , zfConvert_FloatToString (COALESCE ((SELECT ObjectFloat_TaxKind_Value.ValueData
                                                             FROM ObjectLink AS OL_Partner_TaxKind
                                                                  LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                                                                        ON ObjectFloat_TaxKind_Value.ObjectId = OL_Partner_TaxKind.ChildObjectId 
                                                                                       AND ObjectFloat_TaxKind_Value.DescId   = zc_ObjectFloat_TaxKind_Value()   
                                                             WHERE OL_Partner_TaxKind.ObjectId = inFromId
                                                               AND OL_Partner_TaxKind.DescId   = zc_ObjectLink_Partner_TaxKind()
                                                            ), 0))
                        ;
     END IF;

     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;


     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Income(), inInvNumber, inOperDate, NULL, inUserId);

     -- ��������� �������� <���� � ��� (��/���)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PriceWithVAT(), ioId, inPriceWithVAT);
     -- ��������� ����� � <�� ���� (� ���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), ioId, inFromId);
     -- ��������� ����� � <���� (� ���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), ioId, inToId);
     -- ��������� ����� � <��>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidKind(), ioId, inPaidKindId);

     -- ��������� �������� <���>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_VATPercent(), ioId, inVATPercent);
     -- ��������� �������� <% ������>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_DiscountTax(), ioId, inDiscountTax);
     
     -- 
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDatePartner(), ioId, inOperDatePartner);

     -- ��������� <>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberPartner(), ioId, inInvNumberPartner);
     -- ��������� <>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberPack(), ioId, inInvNumberPack);
     -- ��������� <>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberInvoice(), ioId, inInvNumberInvoice);
     
     -- ��������� <����������>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);


     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (ioId);

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
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 29.06.23         *
 04.06.21         *
 08.02.21         *
*/

-- ����
--