-- Function: gpInsertUpdate_Movement_OrderPartner()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderPartner(Integer, TVarChar, TVarChar, TDateTime, TDateTime, Boolean, TFloat, TFloat, TFloat
                                                           , Integer, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderPartner(Integer, TVarChar, TVarChar, TDateTime, TDateTime, Boolean, TFloat, TFloat, TFloat
                                                           , Integer, Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_OrderPartner(
 INOUT ioId                  Integer   , -- ���� ������� <�������� �����������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inInvNumberPartner    TVarChar  , -- ����� ��������� (�������)
    IN inOperDate            TDateTime , -- ���� ���������
    IN inOperDatePartner     TDateTime , -- ���� ��������
    IN inPriceWithVAT        Boolean   , -- ���� � ��� (��/���)
    IN inVATPercent          TFloat    , --
    IN inDiscountTax         TFloat    , --
    IN inDiscountNextTax     TFloat    , --
    IN inFromId              Integer   , -- �� ���� (� ���������)
    IN inToId                Integer   , -- ����
    IN inPaidKindId          Integer   , -- ��
    IN inMovementId_Invoice  Integer   , -- ����
    IN inComment             TVarChar  , -- ����������
    IN inSession             TVarChar    -- ������ ������������
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbOldContractId Integer;
   DECLARE vbDeferment Integer;
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_OrderPartner());
    vbUserId := lpGetUserBySession (inSession);

    --    
    ioId := lpInsertUpdate_Movement_OrderPartner(ioId
                                               , inInvNumber, inInvNumberPartner
                                               , inOperDate, inOperDatePartner
                                               , inPriceWithVAT
                                               , inVATPercent
                                               , inDiscountTax, inDiscountNextTax
                                               , inFromId, inToId
                                               , inPaidKindId
                                               , inMovementId_Invoice
                                               , inComment
                                               , vbUserId);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 04.06.21         *
 12.04.21         *
*/

-- ����
--