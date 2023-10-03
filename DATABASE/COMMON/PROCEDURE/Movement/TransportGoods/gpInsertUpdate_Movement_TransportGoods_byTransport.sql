-- Function: gpInsertUpdate_Movement_TransportGoods_byTransport ()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_TransportGoods_byTransport (Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_TransportGoods_byTransport(
    IN inMovementId_Sale               Integer  , --
    IN inMovementId_TransportGoods     Integer  ,
   OUT outMovementId_TransportGoods    Integer  ,
    IN inMovementId_Transport          Integer  ,
    
    IN inSession                       TVarChar    -- ������ ������������

)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId       Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);

     --�������� 
     IF COALESCE (inMovementId_Transport,0) = 0
     THEN   
          RAISE EXCEPTION '������. �� ������ �������� �������� �����'; 
     END IF;
     
     -- ���� ��� ��� - �������
     outMovementId_TransportGoods:= 
                         lpInsertUpdate_Movement_TransportGoods (ioId              := tmpTransportGoods.Id         ::Integer
                                                               , inInvNumber       := tmpTransportGoods.InvNumber  ::TVarChar
                                                               , inOperDate        := tmpTransportGoods.OperDate   ::TDateTime
                                                               , inMovementId_Sale := inMovementId_Sale
                                                               , inInvNumberMark   := tmpTransportGoods.InvNumberMark ::TVarChar
                                                               , inCarId           := (SELECT MLO.ObjectId                      --������ � ��������� �����
                                                                                       FROM MovementLinkObject AS MLO
                                                                                       WHERE MLO.MovementId = inMovementId_Transport
                                                                                         AND MLO.DescId = zc_MovementLinkObject_Car()
                                                                                       )
                                                               , inCarTrailerId    := (SELECT MLO.ObjectId                      --������ � ��������� �����
                                                                                       FROM MovementLinkObject AS MLO
                                                                                       WHERE MLO.MovementId = inMovementId_Transport
                                                                                         AND MLO.DescId = zc_MovementLinkObject_CarTrailer()
                                                                                       )  ::Integer
                                                               , inPersonalDriverId:= (SELECT MLO.ObjectId                      --���� � ��������� �����
                                                                                       FROM MovementLinkObject AS MLO
                                                                                       WHERE MLO.MovementId = inMovementId_Transport
                                                                                         AND MLO.DescId = zc_MovementLinkObject_PersonalDriver()
                                                                                       )
                                                               , inRouteId         := (SELECT MovementItem.ObjectId             --������� � ��������� �����
                                                                                       FROM MovementItem
                                                                                       WHERE MovementItem.MovementId = inMovementId_Transport 
                                                                                         AND MovementItem.DescId     = zc_MI_Master()
                                                                                         AND MovementItem.isErased   = FALSE
                                                                                       LIMIT 1
                                                                                       )
                                                                 -- ������� ����/���������� - 1
                                                               , inMemberId1       := (SELECT MLO.ObjectId                      --���� � ��������� �����
                                                                                       FROM MovementLinkObject AS MLO
                                                                                       WHERE MLO.MovementId = inMovementId_Transport
                                                                                         AND MLO.DescId = zc_MovementLinkObject_PersonalDriver()
                                                                                       )
                                                                 -- ��������� (����������� ����� �����������������) - 2
                                                               , inMemberId2       := tmpTransportGoods.MemberId2
                                                                 -- ³����� �������� - 3
                                                               , inMemberId3       := tmpTransportGoods.MemberId3
                                                                 -- ���� (����������� ����� �����������������) - 4
                                                               , inMemberId4       := tmpTransportGoods.MemberId4
                                                                 -- ������� ����/���������� - 1
                                                               , inMemberId5       := tmpTransportGoods.MemberId5
                                                                 -- ���� ����/���������� - ����� ��� 1
                                                               , inMemberId6       := tmpTransportGoods.MemberId6
                                                                 --  ������� (����������� ����� �����������������) - �����
                                                               , inMemberId7       := tmpTransportGoods.MemberId7
                                                                 --
                                                               , inUserId          := vbUserId
                                                                )
                          FROM  gpGet_Movement_TransportGoods(inMovementId      := inMovementId_TransportGoods :: Integer
                                                            , inMovementId_Sale := inMovementId_Sale           :: Integer  
                                                            , inOperDate        :=(SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId_Sale) :: TDateTime 
                                                            , inSession         := inSession :: TVarChar
                                                              ) AS tmpTransportGoods 
                        ;

   IF vbUserId = 9457 OR vbUserId = 5
   THEN
         RAISE EXCEPTION '����. ��. <%>', outMovementId_TransportGoods; 
   END IF; 

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 02.10.23         *
*/

-- ����
--