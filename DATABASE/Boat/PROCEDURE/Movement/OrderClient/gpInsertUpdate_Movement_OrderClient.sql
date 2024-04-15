-- Function: gpInsertUpdate_Movement_OrderClient()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderClient(Integer, TVarChar, TVarChar, TDateTime, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderClient(Integer, TVarChar, TVarChar, TDateTime, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderClient(Integer, TVarChar, TVarChar, TDateTime, Boolean, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderClient(Integer, TVarChar, TVarChar, TDateTime, Boolean, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderClient(Integer, TVarChar, TVarChar, TDateTime, Boolean, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderClient(Integer, TVarChar, TVarChar, TDateTime, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat
                                                          , Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderClient(Integer, TVarChar, TVarChar, TDateTime, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                          , Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderClient(Integer, TVarChar, TVarChar, TDateTime, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                          , Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_OrderClient(
 INOUT ioId                  Integer   , -- ���� ������� <�������� �����������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inInvNumberPartner    TVarChar  , -- ����� ��������� (�������)
    IN inOperDate            TDateTime , -- ���� ���������
    IN inPriceWithVAT        Boolean   , -- ���� � ��� (��/���)
    IN inVATPercent          TFloat    , --
    IN inDiscountTax         TFloat    , --
    IN inDiscountNextTax     TFloat    , -- 
 INOUT ioSummTax             TFloat    , -- C���� ������������������ ������, ��� ���
 INOUT ioSummReal            TFloat    , -- ����� ������������������ �����, � ������ ���� ������, ��� ����������, ����� ������� ��� ���
    IN inTransportSumm_load  TFloat    , --���������
    --IN inNPP                 TFloat    , -- ����������� ������
    IN inFromId              Integer   , -- �� ���� (� ���������)
    IN inToId                Integer   , -- ����
    IN inPaidKindId          Integer   , -- �� 
    IN inTaxKindId           Integer  ,  -- ��� ���
    IN inProductId           Integer   , -- �����
    IN inMovementId_Invoice  Integer   , -- ����
    IN inComment             TVarChar  , -- ����������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_OrderClient());
    vbUserId := lpGetUserBySession (inSession);

    --    
    SELECT tmp.ioId , tmp.ioSummTax, tmp.ioSummReal
           INTO ioId, ioSummTax, ioSummReal
    FROM lpInsertUpdate_Movement_OrderClient(ioId, inInvNumber, inInvNumberPartner
                                           , inOperDate
                                           , inPriceWithVAT
                                           , inVATPercent, inDiscountTax, inDiscountNextTax
                                           , ioSummTax, ioSummReal
                                           , inTransportSumm_load
                                           , inFromId, inToId
                                           , inPaidKindId
                                           , inProductId
                                           , inMovementId_Invoice
                                           , inComment
                                           , vbUserId
                                            ) AS tmp;

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 15.04.24         * inTaxKindId
 01.06.23         * inTransportSumm_load
 15.02.21         *
*/

-- ����
--