-- Function: gpInsertUpdateMobile_Movement_OrderExternal()

DROP FUNCTION IF EXISTS gpInsertUpdateMobile_Movement_OrderExternal (TVarChar, TVarChar, TDateTime, Integer, Integer, Integer, Integer, Boolean, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdateMobile_Movement_OrderExternal (TVarChar, TVarChar, TDateTime, Integer, Integer, Integer, Integer, Integer, Boolean, TFloat, TFloat, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdateMobile_Movement_OrderExternal(
    IN inGUID                TVarChar  , -- ���������� ���������� �������������
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inComment             TVarChar  , -- ����������
    IN inPartnerId           Integer   , -- ����������
    IN inUnitId              Integer   , -- �������������
    IN inPaidKindId          Integer   , -- ���� ���� ������
    IN inContractId          Integer   , -- ��������
    IN inPriceListId         Integer   , -- ����� ����
    IN inPriceWithVAT        Boolean   , -- ���� � ��� (��/���)
    IN inVATPercent          TFloat    , -- % ���
    IN inChangePercent       TFloat    , -- (-)% ������ (+)% �������
    IN inInsertDate          TDateTime , -- ����/����� �������� ������ �� ���� ���� ����� ������ � ������� + ��������� ������ ���� ���� ������ �����
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbisInsert Boolean;
   DECLARE vbId Integer;
   DECLARE vbOperDatePartner TDateTime;
   DECLARE vbRouteId Integer;
   DECLARE vbPersonalId Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbPrinted Boolean;
BEGIN
      -- �������� ���� ������������ �� ����� ���������
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_OrderExternal());
      vbUserId:= lpGetUserBySession (inSession);
      
      -- ����������� �������������� ������ �� ����������� ����������� ��������������
      SELECT MovementString_GUID.MovementId 
           , Movement_OrderExternal.StatusId
      INTO vbId 
         , vbStatusId
      FROM MovementString AS MovementString_GUID
           JOIN Movement AS Movement_OrderExternal
                         ON Movement_OrderExternal.Id = MovementString_GUID.MovementId
                        AND Movement_OrderExternal.DescId = zc_Movement_OrderExternal()
      WHERE MovementString_GUID.DescId = zc_MovementString_GUID() 
        AND MovementString_GUID.ValueData = inGUID;

      vbisInsert:= (COALESCE(vbId, 0) = 0);
                                                                                       
      vbOperDatePartner:= inOperDate + (COALESCE ((SELECT ValueData FROM ObjectFloat 
                                                   WHERE ObjectId = inPartnerId 
                                                     AND DescId = zc_ObjectFloat_Partner_PrepareDayCount()
                                                  ), 0) :: TVarChar || ' DAY') :: INTERVAL;

      -- ����������� �������������� �������� ��� ������
      SELECT ObjectLink_Partner_Route.ChildObjectId
      INTO vbRouteId
      FROM ObjectLink AS ObjectLink_Partner_Route
      WHERE ObjectLink_Partner_Route.DescId = zc_ObjectLink_Partner_Route()
        AND ObjectLink_Partner_Route.ObjectId = inPartnerId;

      -- ����������� ����������� �� ��� ������ ��� ��� �� �����
      SELECT ObjectLink_Partner_MemberTake.ChildObjectId
      INTO vbPersonalId
      FROM ObjectLink AS ObjectLink_Partner_MemberTake
      WHERE ObjectLink_Partner_MemberTake.ObjectId = inPartnerId
        AND ObjectLink_Partner_MemberTake.DescId = CASE EXTRACT (DOW FROM inOperDate + ((COALESCE ((SELECT ObjectFloat.ValueData 
                                                                                                     FROM ObjectFloat 
                                                                                                     WHERE ObjectFloat.ObjectId = inPartnerId
                                                                                                       AND ObjectFloat.DescId = zc_ObjectFloat_Partner_PrepareDayCount()), 0)
                                                                                        + COALESCE ((SELECT ObjectFloat.ValueData 
                                                                                                     FROM ObjectFloat 
                                                                                                     WHERE ObjectFloat.ObjectId = inPartnerId 
                                                                                                       AND ObjectFloat.DescId = zc_ObjectFloat_Partner_DocumentDayCount()), 0)
                                                                                         )::TVarChar || ' DAY'
                                                                                       )::Interval
                                                                )
                                                        WHEN 1 THEN zc_ObjectLink_Partner_MemberTake1()
                                                        WHEN 2 THEN zc_ObjectLink_Partner_MemberTake2()
                                                        WHEN 3 THEN zc_ObjectLink_Partner_MemberTake3()
                                                        WHEN 4 THEN zc_ObjectLink_Partner_MemberTake4()
                                                        WHEN 5 THEN zc_ObjectLink_Partner_MemberTake5()
                                                        WHEN 6 THEN zc_ObjectLink_Partner_MemberTake6()
                                                        WHEN 0 THEN zc_ObjectLink_Partner_MemberTake7()
                                                   END;

      IF (vbisInsert = FALSE) AND (vbStatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_Erased()))
      THEN -- ���� ������ ���������, �� �����������
           SELECT outPrinted INTO vbPrinted FROM lpUnComplete_Movement_OrderExternal (inMovementId:= vbId, inUserId:= vbUserId);
      END IF;

      vbId:= lpInsertUpdate_Movement_OrderExternal (ioId              := vbId
                                                  , inInvNumber       := inInvNumber
                                                  , inInvNumberPartner:= COALESCE ((SELECT MS.ValueData FROM MovementString AS MS WHERE MS.MovementId = vbId AND MS.DescId = zc_MovementString_InvNumberPartner()), '')
                                                  , inOperDate        := inOperDate
                                                  , inOperDatePartner := vbOperDatePartner
                                                  , inOperDateMark    := inOperDate
                                                  , inPriceWithVAT    := inPriceWithVAT
                                                  , inVATPercent      := inVATPercent
                                                  , inChangePercent   := inChangePercent    
                                                  , inFromId          := inPartnerId
                                                  , inToId            := inUnitId
                                                  , inPaidKindId      := inPaidKindId
                                                  , inContractId      := inContractId
                                                  , inRouteId         := vbRouteId
                                                  , inRouteSortingId  := NULL
                                                  , inPersonalId      := vbPersonalId
                                                  , inPriceListId     := inPriceListId
                                                  , inPartnerId       := NULL
                                                  , inUserId:= vbUserId
                                                   );

      -- ��������� �������� <���������� ���������� �������������>                       
      PERFORM lpInsertUpdate_MovementString (zc_MovementString_GUID(), vbId, inGUID);   
      -- �����������
      PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), vbId, inComment);

      IF vbisInsert 
      THEN
           -- ��������� ����� � <������������>
           PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_Insert(), vbId, vbUserId);
      END IF;

      -- ��������� �������� <���� ��������>
      -- ������������ ��� �������� � ��� ����., ����� ���� ��������
      PERFORM lpInsertUpdate_MovementDate(zc_MovementDate_Insert(), vbId, CURRENT_TIMESTAMP);

      -- ��������� �������� <����/����� �������� ������ �� ��������� ����������>
      PERFORM lpInsertUpdate_MovementDate(zc_MovementDate_InsertMobile(), vbId, inInsertDate);

      -- !!!�������� - �� �������� ������!!!
      -- SELECT outPrinted INTO vbPrinted FROM lpComplete_Movement_OrderExternal (inMovementId:= vbId, inUserId:= vbUserId);
      -- !!!�������� - ������� ������!!!
      PERFORM lpSetErased_Movement (inMovementId:= vbId, inUserId:= vbUserId);

      RETURN vbId;                                                                      
END;                                                                                    
$BODY$                                                                                  
  LANGUAGE plpgsql VOLATILE;                                                            

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   �������� �.�.
 28.02.17                                                         *
*/

-- ����
/* SELECT * FROM gpInsertUpdateMobile_Movement_OrderExternal (inGUID:= '{A539F063-B6B2-4089-8741-B40014ED51D7}'
                                                            , inInvNumber:= '-1'
                                                            , inOperDate:= CURRENT_DATE
                                                            , inComment:= '�������� ������' 
                                                            , inPartnerId:= 17819
                                                            , inUnitId:= 8459 
                                                            , inPaidKindId:= zc_Enum_PaidKind_SecondForm()
                                                            , inContractId:= 16687
                                                            , inPriceListId:= 18840
                                                            , inPriceWithVAT:= false
                                                            , inVATPercent:= 20
                                                            , inChangePercent:= 5
                                                            , inInsertDate:= CURRENT_TIMESTAMP 
                                                            , inSession:= zfCalc_UserAdmin()
                                                             )
*/
