-- Function: lpUpdate_Movement_Sale_Edi_byOrder()

DROP FUNCTION IF EXISTS lpUpdate_Movement_Sale_Edi_byOrder (Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpUpdate_Movement_Sale_Edi_byOrder(
    IN inId                    Integer    , -- ���� ������� <��������>
    IN inMovementId_Order      Integer    , -- ���� ���������
    IN inUserId                Integer      -- ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbMovementId_EDI Integer;
BEGIN

    -- �����
    vbMovementId_EDI:= (SELECT MovementChildId FROM MovementLinkMovement WHERE MovementId = inMovementId_Order AND DescId = zc_MovementLinkMovement_Order() AND MovementChildId <> 0);

    -- ���� ����
    IF vbMovementId_EDI <> 0 
       -- OR EXISTS (SELECT MovementChildId FROM MovementLinkMovement WHERE MovementId = inId AND DescId = zc_MovementLinkMovement_Sale() AND MovementChildId <> 0)
    THEN
        IF vbMovementId_EDI <> 0
        THEN
            -- !!!�������� � ��������� EDI �������!!!
            PERFORM lpInsertUpdate_MovementString (zc_MovementString_Desc(), vbMovementId_EDI, (SELECT MovementDesc.Code FROM MovementDesc WHERE MovementDesc.Id = zc_Movement_Sale()));
        END IF;

        -- ������������ ����� � ��������� ����. � EDI (����� �� ��� � � ������)
        PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Sale(), inId, vbMovementId_EDI);
    END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 04.02.15                                        *
*/

-- ����
-- SELECT * FROM lpUpdate_Movement_Sale_Edi_byOrder (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inCarId:= 0, inPaidKindId:= 1, inContractId:= 0, inPersonalDriverId:= 0, inRouteId:= 0, inRouteSortingId:= 0, inSession:= '2')
