DROP FUNCTION IF EXISTS lpComplete_Movement_Invoice (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Invoice(
    IN inMovementId        Integer  , -- ���� ���������
    IN inUserId            Integer    -- ������������
)
RETURNS VOID
AS
$BODY$
    DECLARE vbObjectId Integer;
    DECLARE vbMovementId_OrderClient Integer;
    DECLARE vbInvoiceKindId          Integer;
    DECLARE vbTaxKindId              Integer;
    DECLARE vbVATPercent             TFloat;
    DECLARE vbAmount                 TFloat;
    DECLARE vbSum_OrderClient        TFloat;
    DECLARE vbSum_PrePay             TFloat;
BEGIN

    -- �����
    vbMovementId_OrderClient:= (SELECT Movement.ParentId FROM Movement WHERE Movement.Id = inMovementId);
    -- �����
    vbInvoiceKindId:= (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_InvoiceKind());
    -- �����
    vbTaxKindId:= (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_TaxKind());
    -- �����
    vbVATPercent:= COALESCE ((SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inMovementId AND MF.DescId = zc_MovementFloat_VATPercent()), 0);


    --
    IF COALESCE (vbTaxKindId, 0) = 0
    THEN
        RAISE EXCEPTION '������.�� ���������� �������� <��� ���>.';
    END IF;


    IF vbMovementId_OrderClient > 0
    THEN
        -- �������� - ��� ����� � ���� ��� ��� � %
        IF EXISTS (SELECT 1
                   FROM Movement
                        LEFT JOIN MovementFloat AS MF ON MF.MovementId = Movement.Id AND MF.DescId = zc_MovementFloat_VATPercent()
                        LEFT JOIN MovementLinkObject AS MLO ON MLO.MovementId = Movement.Id AND MLO.DescId = zc_MovementLinkObject_TaxKind()
                   WHERE Movement.ParentId = vbMovementId_OrderClient AND Movement.DescId = zc_Movement_Invoice() AND Movement.StatusId = zc_Enum_Status_Complete()
                     AND Movement.Id <> COALESCE (inMovementId, 0)
                     AND (COALESCE (MLO.ObjectId, 0) <> vbTaxKindId
                       OR COALESCE (MF.ValueData, 0) <> vbVATPercent
                         )
                  )
        THEN
            RAISE EXCEPTION '������.��� ������ �� ������� ��� ������������ C���� %� ��������� = <%> � % ��� = <%>.%���������� � ������� ����������� �������������.'
                          , CHR (13)
                          , (SELECT lfGet_Object_ValueData_sh (MLO.ObjectId)
                             FROM Movement
                                  LEFT JOIN MovementFloat AS MF ON MF.MovementId = Movement.Id AND MF.DescId = zc_MovementFloat_VATPercent()
                                  LEFT JOIN MovementLinkObject AS MLO ON MLO.MovementId = Movement.Id AND MLO.DescId = zc_MovementLinkObject_TaxKind()
                             WHERE Movement.ParentId = vbMovementId_OrderClient AND Movement.DescId = zc_Movement_Invoice() AND Movement.StatusId = zc_Enum_Status_Complete()
                               AND Movement.Id <> COALESCE (inMovementId, 0)
                               AND (COALESCE (MLO.ObjectId, 0) <> vbTaxKindId
                                 OR COALESCE (MF.ValueData, 0) <> vbVATPercent
                                   )
                             ORDER BY Movement.Id
                             LIMIT 1
                            )
                          , '%'
                          , (SELECT zfConvert_FloatToString (COALESCE (MF.ValueData, 0))
                             FROM Movement
                                  LEFT JOIN MovementFloat AS MF ON MF.MovementId = Movement.Id AND MF.DescId = zc_MovementFloat_VATPercent()
                                  LEFT JOIN MovementLinkObject AS MLO ON MLO.MovementId = Movement.Id AND MLO.DescId = zc_MovementLinkObject_TaxKind()
                             WHERE Movement.ParentId = vbMovementId_OrderClient AND Movement.DescId = zc_Movement_Invoice() AND Movement.StatusId = zc_Enum_Status_Complete()
                               AND Movement.Id <> COALESCE (inMovementId, 0)
                               AND (COALESCE (MLO.ObjectId, 0) <> vbTaxKindId
                                 OR COALESCE (MF.ValueData, 0) <> vbVATPercent
                                   )
                             ORDER BY Movement.Id
                             LIMIT 1
                            )
                          , CHR (13)
                            ;
        END IF;

        -- ���� � ������ ������ TaxKind ��� VATPercent
        IF vbTaxKindId  <> COALESCE ((SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = vbMovementId_OrderClient AND MLO.DescId = zc_MovementLinkObject_TaxKind()), 0)
        OR vbVATPercent <> COALESCE ((SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = vbMovementId_OrderClient AND MF.DescId = zc_MovementFloat_VATPercent()), 0)
        THEN
             -- ��������� � ����� ����� � <TaxKind>
             PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_TaxKind(), vbMovementId_OrderClient, vbTaxKindId);
             -- ��������� � ����� VATPercent
             PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_VATPercent(), vbMovementId_OrderClient, vbVATPercent);

             -- ����������� �������� ����� �� ���������
             PERFORM lpInsertUpdate_MovementFloat_TotalSumm_order (vbMovementId_OrderClient);

        END IF;

    END IF;


    -- �������� ���� ����� ����� �����. ����� ������� � ������ ��� ���� ��������� ����
    IF vbInvoiceKindId = zc_Enum_InvoiceKind_Pay() AND vbMovementId_OrderClient > 0
    THEN
         -- ����� �����
         vbAmount:= (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inMovementId AND MF.DescId = zc_MovementFloat_Amount());

         -- ����� ������ �������
         vbSum_OrderClient := (SELECT tmp.Basis_summ_transport
                               FROM gpSelect_Object_Product (inMovementId_OrderClient:= vbMovementId_OrderClient, inIsShowAll:= TRUE, inIsSale:= FALSE, inSession:= inUserId::TVarChar) AS tmp
                              );

         -- ����� ������ - ����������
         vbSum_PrePay :=(SELECT SUM (CASE WHEN MovementFloat_Amount.ValueData > 0 THEN  1 * MovementFloat_Amount.ValueData ELSE 0 END) ::TFloat AS Total_PrePay
                         FROM Movement
                             INNER JOIN MovementLinkObject AS MovementLinkObject_InvoiceKind
                                                           ON MovementLinkObject_InvoiceKind.MovementId = Movement.Id
                                                          AND MovementLinkObject_InvoiceKind.DescId = zc_MovementLinkObject_InvoiceKind()
                                                          AND MovementLinkObject_InvoiceKind.ObjectId = zc_Enum_InvoiceKind_PrePay()
                             LEFT JOIN MovementFloat AS MovementFloat_Amount
                                                     ON MovementFloat_Amount.MovementId = Movement.Id
                                                    AND MovementFloat_Amount.DescId = zc_MovementFloat_Amount()
                         WHERE Movement.DescId = zc_Movement_Invoice()
                           AND Movement.ParentId = vbMovementId_OrderClient
                           AND Movement.StatusId = zc_Enum_Status_Complete()
                        );
         --
         IF COALESCE (vbSum_OrderClient,0) - COALESCE (vbSum_PrePay,0) <> vbAmount
         THEN
             RAISE EXCEPTION '������. C���� � ������ <%> �� ������������� ����� ����� <%>.', CAST ((COALESCE (vbSum_OrderClient,0) - COALESCE (vbSum_PrePay,0)) AS NUMERIC (16,2)), CAST (vbAmount AS NUMERIC (16,2));
         END IF;

    END IF;


     -- �������� �� ���������
    /*vbObjectId:= (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Object());
    -- �� ������������� VATPercent
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_VATPercent(), inMovementId, COALESCE (ObjectFloat_TaxKind_Value.ValueData, 0))
    FROM ObjectLink AS ObjectLink_TaxKind
         LEFT JOIN Object ON Object.Id = ObjectLink_TaxKind.ObjectId
         LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                               ON ObjectFloat_TaxKind_Value.ObjectId = ObjectLink_TaxKind.ChildObjectId
                              AND ObjectFloat_TaxKind_Value.DescId   = zc_ObjectFloat_TaxKind_Value()
    WHERE ObjectLink_TaxKind.ObjectId = vbObjectId
      AND ObjectLink_TaxKind.DescId   = CASE WHEN Object.DescId = zc_Object_Partner() THEN zc_ObjectLink_Partner_TaxKind() ELSE zc_ObjectLink_Client_TaxKind() END
   ;*/



    -- 5.2. ����� - ����������� ������ ������ ��������� + ��������� ��������
    PERFORM lpComplete_Movement (inMovementId := inMovementId
                               , inDescId     := zc_Movement_Invoice()
                               , inUserId     := inUserId
                                );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 03.02.21         *
*/