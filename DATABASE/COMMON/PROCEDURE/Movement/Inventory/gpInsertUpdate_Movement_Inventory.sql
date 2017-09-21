-- Function: gpInsertUpdate_Movement_Inventory()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Inventory (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Inventory (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Inventory(
 INOUT ioId                  Integer   , -- ���� ������� <�������� ������� ����������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inFromId              Integer   , -- �� ���� (� ���������)
    IN inToId                Integer   , -- ���� (� ���������)
    IN inGoodsGroupId        Integer   , -- ������ ������
 INOUT ioisGoodsGroupIn      Boolean   , -- ������ ����. ������
 INOUT ioisGoodsGroupExc     Boolean   , -- ����� ����. ������
    IN inSession             TVarChar    -- ������ ������������
)                               
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
   
   DECLARE vbisGoodsGroupIn  Boolean;
   DECLARE vbisGoodsGroupExc Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Inventory());

     -- �������� ������� �������� ������ ����. ������ / ����� ����. ������ (��� ���� ����� ������������ �� ���� �������� ��� �����)
     SELECT COALESCE (MovementBoolean_GoodsGroupIn.ValueData, FALSE)  :: Boolean AS isGoodsGroupIn
          , COALESCE (MovementBoolean_GoodsGroupExc.ValueData, FALSE) :: Boolean AS isGoodsGroupExc
          INTO vbisGoodsGroupIn, vbisGoodsGroupExc
     FROM Movement
          LEFT JOIN MovementBoolean AS MovementBoolean_GoodsGroupIn
                                    ON MovementBoolean_GoodsGroupIn.MovementId = Movement.Id
                                   AND MovementBoolean_GoodsGroupIn.DescId = zc_MovementBoolean_GoodsGroupIn()

          LEFT JOIN MovementBoolean AS MovementBoolean_GoodsGroupExc
                                    ON MovementBoolean_GoodsGroupExc.MovementId = Movement.Id
                                   AND MovementBoolean_GoodsGroupExc.DescId = zc_MovementBoolean_GoodsGroupExc()
     WHERE Movement.Id = ioId;
     
     --
     IF ioisGoodsGroupIn <> vbisGoodsGroupIn AND ioisGoodsGroupIn = TRUE
     THEN
          ioisGoodsGroupExc := NOT ioisGoodsGroupIn;
     END IF;
     IF ioisGoodsGroupExc <> vbisGoodsGroupExc AND ioisGoodsGroupIn = TRUE
     THEN
          ioisGoodsGroupIn := NOT ioisGoodsGroupExc;
     END IF; 
     
     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement_Inventory (ioId               := ioId
                                              , inInvNumber        := inInvNumber
                                              , inOperDate         := inOperDate
                                              , inFromId           := inFromId
                                              , inToId             := inToId
                                              , inGoodsGroupId     := inGoodsGroupId
                                              , inisGoodsGroupIn   := ioisGoodsGroupIn
                                              , inisGoodsGroupExc  := ioisGoodsGroupExc
                                              , inUserId           := vbUserId
                                               );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 18.09.17         *
 29.05.15                                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_Inventory (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inSession:= '2')
