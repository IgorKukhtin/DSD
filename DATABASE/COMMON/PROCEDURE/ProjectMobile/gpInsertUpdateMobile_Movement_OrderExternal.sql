-- Function: gpInsertUpdateMobile_Movement_OrderExternal()

DROP FUNCTION IF EXISTS gpInsertUpdateMobile_Movement_OrderExternal (TVarChar, TVarChar, TDateTime, Integer, Integer, Integer, Integer, Boolean, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdateMobile_Movement_OrderExternal(
    IN inGUID                TVarChar  , -- ���������� ���������� �������������
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inPartnerId           Integer   , -- ����������
    IN inPaidKindId          Integer   , -- ���� ���� ������
    IN inContractId          Integer   , -- ��������
    IN inPriceListId         Integer   , -- ����� ����
    IN inPriceWithVAT        Boolean   , -- ���� � ��� (��/���)
    IN inVATPercent          TFloat    , -- % ���
    IN inChangePercent       TFloat    , -- (-)% ������ (+)% �������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbId Integer;
   DECLARE vbPersonalId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbOperDatePartner TDateTime;
   DECLARE vbRouteId Integer;
BEGIN
      -- �������� ���� ������������ �� ����� ���������
      vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_OrderExternal());

      -- ���������� ���������
      SELECT PersonalId, UnitId INTO vbPersonalId, vbUnitId FROM gpGetMobile_Object_Const (inSession);

      SELECT MovementString_GUID.MovementId 
      INTO vbId 
      FROM MovementString AS MovementString_GUID
           JOIN Movement AS Movement_OrderExternal
                         ON Movement_OrderExternal.Id = MovementString_GUID.MovementId
                        AND Movement_OrderExternal.DescId = zc_Movement_OrderExternal()
      WHERE MovementString_GUID.DescId = zc_MovementString_GUID() 
        AND MovementString_GUID.ValueData = inGUID;
                                                                                       
      vbOperDatePartner:= inOperDate + (COALESCE ((SELECT ValueData FROM ObjectFloat 
                                                   WHERE ObjectId = inPartnerId 
                                                     AND DescId = zc_ObjectFloat_Partner_PrepareDayCount()
                                                  ), 0) :: TVarChar || ' DAY') :: INTERVAL;

      SELECT ObjectLink_Partner_Route.ChildObjectId
      INTO vbRouteId
      FROM ObjectLink AS ObjectLink_Partner_Route
      WHERE ObjectLink_Partner_Route.DescId = zc_ObjectLink_Partner_Route()
        AND ObjectLink_Partner_Route.ObjectId = inPartnerId;

      vbId:= lpInsertUpdate_Movement_OrderExternal (ioId:= vbId
                                                  , inInvNumber:= inInvNumber
                                                  , inInvNumberPartner:= inInvNumber
                                                  , inOperDate:= inOperDate
                                                  , inOperDatePartner:= vbOperDatePartner
                                                  , inOperDateMark:= inOperDate
                                                  , inPriceWithVAT:= inPriceWithVAT
                                                  , inVATPercent:= inVATPercent
                                                  , inChangePercent:= inChangePercent    
                                                  , inFromId:= inPartnerId
                                                  , inToId:= vbUnitId
                                                  , inPaidKindId:= inPaidKindId
                                                  , inContractId:= inContractId
                                                  , inRouteId:= vbRouteId
                                                  , inRouteSortingId:= 0
                                                  , inPersonalId:= vbPersonalId
                                                  , inPriceListId:= inPriceListId
                                                  , inPartnerId:= inPartnerId
                                                  , inUserId:= vbUserId
                                                   );

      -- ��������� �������� <���������� ���������� �������������>                       
      PERFORM lpInsertUpdate_MovementString (zc_MovementString_GUID(), vbId, inGUID);   
                                                                                        
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
                                                            , inPartnerId:= NULL
                                                            , inPaidKindId:= NULL
                                                            , inContractId:= NULL
                                                            , inPriceListId:= NULL
                                                            , inPriceWithVAT:= true
                                                            , inVATPercent:= 20
                                                            , inChangePercent:= 5
                                                            , inSession:= zfCalc_UserAdmin()
                                                             )
*/
