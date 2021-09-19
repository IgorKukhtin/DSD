-- Function: gpInsertUpdate_Movement_Send()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Send (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Send (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Send (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Send (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Send (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Send (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar, Boolean, Boolean, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Send (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar, Boolean, Boolean, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Send(
 INOUT ioId                  Integer   , -- ���� ������� <�������� �����������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inFromId              Integer   , -- �� ���� (� ���������)
    IN inToId                Integer   , -- ���� (� ���������)
    IN inComment             TVarChar  , -- ����������
    IN inChecked             Boolean   , -- ��������
    IN inisComplete          Boolean   , -- ������� �����������
    IN inNumberSeats         Integer   , -- ���������� ����
    IN inDriverSunId         Integer   , -- �������� ���������� �����
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbUserUnitId Integer;
   DECLARE vbParentId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Send());
     vbUserId := inSession;
    
/*     IF COALESCE (ioId, 0) <> 0 AND (COALESCE (inFromId, 0) = 0 OR COALESCE (inToId, 0) = 0)
     THEN 
       RAISE EXCEPTION '������. �� ��������� �������������..';             
     END IF;     
*/
     IF EXISTS(SELECT * FROM gpSelect_Object_RoleUser (inSession) AS Object_RoleUser
               WHERE Object_RoleUser.ID = vbUserId AND Object_RoleUser.RoleId = 308121) -- ��� ���� "������ ������"
     THEN
     
        vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
        IF vbUnitKey = '' THEN
          vbUnitKey := '0';
        END IF;
        vbUserUnitId := vbUnitKey::Integer;
        vbParentId := 0;
        
        IF COALESCE (vbUserUnitId, 0) = 0
        THEN 
          RAISE EXCEPTION '������. �� ������� ������������� ����������.';     
        END IF;     
        
        IF vbUserId in (12325076, 6406669, 3999086, 16175938, 4000094, 6002014, 6025400, 16411862)
        THEN
          SELECT ObjectLink_Unit_Parent.ChildObjectId
          INTO vbParentId
          FROM ObjectLink AS ObjectLink_Unit_Parent
          WHERE  ObjectLink_Unit_Parent.DescId = zc_ObjectLink_Unit_Parent()
            AND ObjectLink_Unit_Parent.ObjectId = vbUserUnitId;
        END IF;

        IF COALESCE (ioId, 0) <> 0
        THEN
          IF EXISTS(SELECT 
                            1 
                    FROM Movement
                         INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                         INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                    WHERE Movement.Id = ioId 
                      AND COALESCE (MovementLinkObject_From.ObjectId, 0) <> COALESCE (vbUserUnitId, 0) 
                      AND COALESCE (MovementLinkObject_To.ObjectId, 0) <> COALESCE (vbUserUnitId, 0) 
                      AND COALESCE (MovementLinkObject_From.ObjectId, 0) <> COALESCE (vbParentId, 0) 
                      AND COALESCE (MovementLinkObject_To.ObjectId, 0) <> COALESCE (vbParentId, 0))
          THEN
            RAISE EXCEPTION '������. ��������� ������������� ���������..';                       
          END IF;
        END IF;
        
        IF COALESCE (inFromId, 0) <> COALESCE (vbUserUnitId, 0) AND COALESCE (inToId, 0) <> COALESCE (vbUserUnitId, 0) AND
           COALESCE (inFromId, 0) <> COALESCE (vbParentId, 0) AND COALESCE (inToId, 0) <> COALESCE (vbParentId, 0) 
        THEN 
          RAISE EXCEPTION '������. ��� ��������� �������� ������ � �������������� <%>.', (SELECT ValueData FROM Object WHERE ID = vbUserUnitId);     
        END IF;     
        
        IF (COALESCE (ioId, 0) = 0 OR inToId <> (SELECT MovementLinkObject_To.ObjectId FROM MovementLinkObject AS MovementLinkObject_To
                                                 WHERE MovementLinkObject_To.MovementId = ioId
                                                   AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()))
          AND inToId = (SELECT ObjectLink_Unit_UnitOverdue.ChildObjectId FROM ObjectLink AS ObjectLink_Unit_UnitOverdue
                        WHERE ObjectLink_Unit_UnitOverdue.ObjectId = vbUserUnitId
                          AND ObjectLink_Unit_UnitOverdue.DescId = zc_ObjectLink_Unit_UnitOverdue()) 
        THEN 
          RAISE EXCEPTION '������. ��� ��������� ��������� ����������� �� ����������� ����� �����.';     
        END IF;     
        
     END IF;     

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement_Send (ioId               := ioId
                                         , inInvNumber        := inInvNumber
                                         , inOperDate         := inOperDate
                                         , inFromId           := inFromId
                                         , inToId             := inToId
                                         , inComment          := inComment
                                         , inChecked          := inChecked
                                         , inisComplete       := inisComplete
                                         , inNumberSeats      := inNumberSeats
                                         , inDriverSunId      := inDriverSunId
                                         , inUserId           := vbUserId
                                          );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 18.12.18                                                       *  
 15.11.16         * inisComplete
 28.06.16         * 
 29.05.15                                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_Send (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')