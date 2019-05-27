-- Function: gpInsertUpdate_Movement_SendPartionDate()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_SendPartionDate (Integer, TVarChar, TDateTime, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_SendPartionDate (Integer, TVarChar, TDateTime, Integer, TFloat, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_SendPartionDate(
 INOUT ioId                  Integer   , -- ���� ������� <�������� �����������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inUnitId              Integer   , --
    IN inChangePercent       TFloat    , -- % ������ (���� �� 1 ��� �� 6 ���)
    IN inChangePercentMin    TFloat    , -- % ������ (���� ������ ������)
    IN inComment             TVarChar  , -- ����������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbUserUnitId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_SendPartionDate());
     vbUserId := inSession;
    
     IF EXISTS(SELECT * FROM gpSelect_Object_RoleUser (inSession) AS Object_RoleUser
               WHERE Object_RoleUser.ID = vbUserId AND Object_RoleUser.RoleId = 308121) -- ��� ���� "������ ������"
     THEN
     
        vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
        IF vbUnitKey = '' THEN
          vbUnitKey := '0';
        END IF;
        vbUserUnitId := vbUnitKey::Integer;
        
        IF COALESCE (vbUserUnitId, 0) = 0
        THEN 
          RAISE EXCEPTION '������. �� ������� ������������� ����������.';     
        END IF;     
        
        IF COALESCE (inUnitId, 0) <> COALESCE (vbUserUnitId, 0)
        THEN 
          RAISE EXCEPTION '������. ��� ��������� �������� ������ � �������������� <%>.', (SELECT ValueData FROM Object WHERE ID = vbUserUnitId);     
        END IF;     
     END IF;     

     vbUnitId := (SELECT MovementLinkObject_Unit.ObjectId
                  FROM MovementLinkObject AS MovementLinkObject_Unit
                  WHERE MovementLinkObject_Unit.MovementId = ioId
                    AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit());

     -- E��� �������� ��. ������������� ��� ������ ����� �� ��������
     IF vbUnitId <> 0 AND vbUnitId <> inUnitId
     THEN
         --
         UPDATE MovementItem
         SET isErased = TRUE
         WHERE MovementItem.MovementId = ioId;
     END IF;
     
     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement_SendPartionDate (ioId               := ioId
                                                   , inInvNumber        := inInvNumber
                                                   , inOperDate         := inOperDate
                                                   , inUnitId           := inUnitId
                                                   , inChangePercent    := inChangePercent
                                                   , inChangePercentMin := inChangePercentMin
                                                   , inComment          := inComment
                                                   , inUserId           := vbUserId
                                                    );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 27.05.19         *
 02.04.19         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_SendPartionDate (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')
