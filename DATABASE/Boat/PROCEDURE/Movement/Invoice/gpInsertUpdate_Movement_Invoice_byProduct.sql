-- Function: gpInsertUpdate_Movement_Invoice_byProduct()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Invoice_byProduct (Integer, TVarChar, TDateTime, Integer, Integer, TFloat, TFloat, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Invoice_byProduct(
 INOUT ioId                      Integer  ,  --
    IN inInvNumber               TVarChar ,  -- ����� ���������
    IN inOperDate                TDateTime,  --
    IN inMovementId_OrderClient  Integer,
    IN inClientId                Integer  ,  -- 
    IN inAmountIn                TFloat   ,  -- 
    IN inAmountOut               TFloat   ,  -- 
    IN inSession                 TVarChar     -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAmount TFloat;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := inSession;

    --��������, ���� ����� �������� ����� � ���� ����� ��� ������ ������
    IF EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = inMovementId_OrderClient AND Movement.StatusId = zc_Enum_Status_Complete())
    THEN
        RETURN;
    END IF;

     -- !!!
     IF inAmountIn <> 0 THEN
        vbAmount := inAmountIn;
     ELSE
        vbAmount := -1 * inAmountOut;
     END IF;

     -- ����������� ��������
     IF EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = ioId AND Movement.StatusId = zc_Enum_Status_Complete())
     THEN
         PERFORM lpUnComplete_Movement (inMovementId := ioId
                                      , inUserId     := vbUserId);
     END IF;

    IF COALESCE (ioId) = 0
    THEN
    -- ��������� <��������>
    ioId := lpInsertUpdate_Movement_Invoice (ioId               := 0                                   ::Integer
                                           , inInvNumber        := CAST (NEXTVAL ('movement_Invoice_seq') AS TVarChar)
                                           , inOperDate         := inOperDate
                                           , inPlanDate         := Null                                ::TDateTime
                                           , inVATPercent       := ObjectFloat_TaxKind_Value.ValueData ::TFloat
                                           , inAmount           := vbAmount                            ::TFloat
                                           , inInvNumberPartner := ''                                  ::TVarChar
                                           , inReceiptNumber    := ''                                  ::TVarChar
                                           , inComment          := ''                                  ::TVarChar
                                           , inObjectId         := inClientId
                                           , inUnitId           := Null                                ::Integer
                                           , inInfoMoneyId      := ObjectLink_InfoMoney.ChildObjectId  ::Integer
                                           , inPaidKindId       := zc_Enum_PaidKind_FirstForm()        ::Integer
                                           , inUserId           := vbUserId
                                           )
            FROM Object AS Object_Client
                 LEFT JOIN ObjectLink AS ObjectLink_TaxKind
                                      ON ObjectLink_TaxKind.ObjectId = Object_Client.Id
                                     AND ObjectLink_TaxKind.DescId = zc_ObjectLink_Client_TaxKind()
       
                 LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                       ON ObjectFloat_TaxKind_Value.ObjectId = ObjectLink_TaxKind.ChildObjectId
                                      AND ObjectFloat_TaxKind_Value.DescId = zc_ObjectFloat_TaxKind_Value()

                 LEFT JOIN ObjectLink AS ObjectLink_InfoMoney
                                      ON ObjectLink_InfoMoney.ObjectId = Object_Client.Id
                                     AND ObjectLink_InfoMoney.DescId = zc_ObjectLink_Client_InfoMoney()

            WHERE Object_Client.Id = inClientId;
            -- ��������� ParentId
            PERFORM lpInsertUpdate_Movement (ioId, zc_Movement_Invoice(), inInvNumber, inOperDate, inMovementId_OrderClient, vbUserId);
    ELSE
        -- ������������� ���� ���������
        PERFORM lpInsertUpdate_Movement (ioId, zc_Movement_Invoice(), inInvNumber, inOperDate, inMovementId_OrderClient, vbUserId);
        --��������� ����� 
        PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_Amount(), ioId, vbAmount);
    END IF;

     -- 5.3. �������� ��������
     IF vbUserId = lpCheckRight (inSession, zc_Enum_Process_Complete_Invoice())
     THEN
          PERFORM lpComplete_Movement_Invoice (inMovementId := ioId
                                             , inUserId     := vbUserId);
     END IF;
     
     -- ��������� ����� ��������� <�����> � ���������� <����>
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Invoice(), inMovementId_OrderClient, ioId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 02.02.21         *

*/