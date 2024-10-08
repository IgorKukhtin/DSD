-- Function: gpInsertUpdate_Movement_ReturnOut()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ReturnOut
   (Integer, TVarChar, TDateTime, TVarChar, TDateTime, Boolean, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ReturnOut
   (Integer, TVarChar, TDateTime, TVarChar, Boolean, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ReturnOut
   (Integer, TVarChar, TDateTime, TVarChar, Boolean, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ReturnOut
   (Integer, TVarChar, TDateTime, TVarChar, Boolean, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_ReturnOut(
 INOUT ioId                  Integer   , -- ���� ������� <�������� �����������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inInvNumberPartner    TVarChar  , -- ����� ���������
    --IN inOperDatePartner     TDateTime , -- ���� ��������� ���������� -- ����������� � ��������� ���������
    IN inPriceWithVAT        Boolean   , -- ���� � ��� (��/���)
    IN inFromId              Integer   , -- �� ���� (� ���������)
    IN inToId                Integer   , -- ����
    IN inNDSKindId           Integer   , -- ���� ���
    IN inParentId            Integer   , -- ��������� ���������
    IN inReturnTypeId        Integer   , -- ��� ��������
    IN inLegalAddressId      Integer   , -- ����������� ����� ����������
    IN inActualAddressId     Integer   , -- ����������� ����� ����������
    IN inComment             TVarChar  , -- ����������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     --vbUserId := inSession;
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ReturnOut());

     ioId := lpInsertUpdate_Movement_ReturnOut(ioId
                                             , inInvNumber
                                             , inOperDate
                                             , inInvNumberPartner
--                                             , inOperDatePartner
                                             , inPriceWithVAT
                                             , inFromId
                                             , inToId
                                             , inNDSKindId
                                             , inParentId
                                             , inReturnTypeId
                                             , inLegalAddressId
                                             , inActualAddressId
                                             , inComment
                                             , vbUserId);


END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ������ �.�.
 22.11.19         *
 28.05.18                                                                     * 
 15.09.16         *
 06.02.15                         *

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_ReturnOut (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inOperDateMark:= '01.01.2013', inInvNumberPartner:= 'xxx', inFromId:= 1, inPersonalId:= 0, inRouteId:= 0, inRouteSortingId:= 0, inSession:= '2')
