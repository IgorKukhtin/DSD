-- Function: gpInsertUpdate_Movement_IncomeMemberFuel()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_IncomeMemberFuel(Integer,TVarChar,TDateTime,TDateTime,TVarChar,Boolean,TFloat,TFloat,TFloat,TFloat,Integer,Integer,Integer,Integer,Integer,Integer,TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_IncomeMemberFuel(Integer,TVarChar,TDateTime,TDateTime,TVarChar,Boolean,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,Integer,Integer,Integer,Integer,Integer,Integer,TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_IncomeMemberFuel(Integer,TVarChar,TDateTime,TDateTime,TVarChar,Boolean,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,Integer,Integer,Integer,Integer,Integer,Integer,TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_IncomeMemberFuel(
 INOUT ioId                  Integer   , -- ���� ������� <��������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������

    IN inOperDatePartner     TDateTime , -- ���� ��������� � �����������
    IN inInvNumberPartner    TVarChar  , -- ����� ����

    IN inPriceWithVAT        Boolean   , -- ���� � ��� (��/���)
    IN inVATPercent          TFloat    , -- % ���
    IN inChangePrice         TFloat    , -- ������ � ����

   -- IN inStartOdometre       TFloat    , --
   -- IN inEndOdometre         TFloat    , --
    IN inAmountFuel          TFloat    , -- ����� ����
    IN inReparation          TFloat    , -- �����������
    IN inLimit               TFloat    , -- ����� ���
    IN inLimitDistance       TFloat    , -- ����� �����

    IN inLimitChange         TFloat    , -- ����� (�� ��������) ���
    IN inLimitDistanceChange TFloat    , -- ����� (�� ��������) �����

    IN inFromId              Integer   , -- �� ���� (� ���������)
 INOUT ioToId                Integer   , -- ���� (� ���������)
   OUT outToName             TVarChar  , -- ���� (� ���������)
    IN inPaidKindId          Integer   , -- ���� ���� ������ 
    IN inContractId          Integer   , -- ��������
    IN inRouteId             Integer   , -- �������
    IN inPersonalDriverId    Integer   , -- ��������� (��������)
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbToId Integer;
   DECLARE vbDescId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_IncomeFuel());
     -- ���������� ���� �������
     vbAccessKeyId:= lpGetAccessKey (vbUserId, zc_Enum_Process_InsertUpdate_Movement_IncomeFuel());

    -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- �������� - ��������� ��������� �������� ������
     PERFORM lfCheck_Movement_Parent (inMovementId:= ioId, inComment:= '���������');

     -- ��������� �������� ��� ��������� �����.
     vbDescId := (SELECT Object.DescId FROM Object WHERE Object.Id = inFromId);
     IF vbDescId = zc_Object_CardFuel()
        THEN
             vbToId := (SELECT OL_PersonalDriver.ChildObjectId
                        FROM ObjectLink AS OL_PersonalDriver 
                        WHERE OL_PersonalDriver.ObjectId = inFromId
                        AND OL_PersonalDriver.DescId = zc_ObjectLink_CardFuel_PersonalDriver());
     END IF;
     IF COALESCE (vbToId,0) <> 0 THEN ioToId:= vbToId; END IF;
     outToName := COALESCE((SELECT Object.ValueData FROM Object WHERE Object.Id = ioToId),'') ::TVarChar ;

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement_IncomeFuel (ioId               := ioId
                                               , inParentId         := NULL
                                               , inInvNumber        := inInvNumber
                                               , inOperDate         := inOperDate
                                               , inOperDatePartner  := inOperDatePartner
                                               , inInvNumberPartner := inInvNumberPartner
                                               , inPriceWithVAT     := inPriceWithVAT
                                               , inVATPercent       := inVATPercent
                                               , inChangePrice      := inChangePrice
                                               , inFromId           := inFromId
                                               , inToId             := ioToId
                                               , inPaidKindId       := inPaidKindId
                                               , inContractId       := inContractId
                                               , inRouteId          := inRouteId
                                               , inPersonalDriverId := inPersonalDriverId
                                               , inAccessKeyId      := vbAccessKeyId 
                                               , inUserId           := vbUserId 
                                                );

     -- ��������� �������� <>
     -- PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_StartOdometre(), ioId, inStartOdometre);
     -- ��������� �������� <>
     -- PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_EndOdometre(), ioId, inEndOdometre);
  
     -- ��������� �������� <����� ����>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_AmountFuel(), ioId, inAmountFuel);
     -- ��������� �������� <����������� �� 1 ��., ���.>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_Reparation(), ioId, inReparation);


     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_LimitChange(), ioId, inLimitChange);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_LimitDistanceChange(), ioId, inLimitDistanceChange);

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_Limit(), ioId, inLimit);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_LimitDistance(), ioId, inLimitDistance);

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
 LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 02.06.17         *
 07.12.13                                        * add lpGetAccess
 31.10.13                                        * add inOperDatePartner
 19.10.13                                        * add inChangePrice
 07.10.13                                        * add lpCheckRight
 06.10.13                                        * add lfCheck_Movement_Parent
 05.10.13                                        * add inInvNumberPartner
 04.10.13                                        * add lpInsertUpdate_Movement_IncomeFuel
 04.10.13                                        * add Route
 27.09.13                                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_IncomeFuel (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePrice:= 0, inFromId:= 1, ioToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')
