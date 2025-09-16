-- Function: gpInsertUpdate_Movement_StaffListMember ()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_StaffListMember (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Boolean, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_StaffListMember(
 INOUT ioId                  Integer   , -- ���� ������� <��������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inMemberId            Integer   , -- 
    IN inPositionId          Integer   , --
    IN inPositionLevelId     Integer   , --
    IN inUnitId              Integer   , --
    IN inPositionId_old      Integer   , --
    IN inPositionLevelId_old Integer   , --
    IN inUnitId_old          Integer   , --
    IN inReasonOutId         Integer   , --
    IN inStaffListKindId     Integer   , --
    IN inisOfficial          Boolean   , --
    IN inisMain              Boolean   , --
    IN inComment             TVarChar  , --
    IN inSession             TVarChar    -- ������ ������������
)     
                      
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_StaffListMember());
     vbUserId:= lpGetUserBySession (inSession);

     --��������
     IF COALESCE (inMemberId,0) = 0
     THEN
          RAISE EXCEPTION '������.<���. ����> ������ ���� ���������.';
     END IF;                                                  

     -- ��������� <��������>
     ioId:= lpInsertUpdate_Movement_StaffListMember ( ioId                  := ioId
                                                    , inInvNumber           := inInvNumber
                                                    , inOperDate            := inOperDate
                                                    , inMemberId            := inMemberId 
                                                    , inPositionId          := inPositionId
                                                    , inPositionLevelId     := inPositionLevelId    
                                                    , inUnitId              := inUnitId             
                                                    , inPositionId_old      := inPositionId_old     
                                                    , inPositionLevelId_old := inPositionLevelId_old
                                                    , inUnitId_old          := inUnitId_old         
                                                    , inReasonOutId         := inReasonOutId        
                                                    , inStaffListKindId     := inStaffListKindId    
                                                    , inisOfficial          := inisOfficial         
                                                    , inisMain              := inisMain             
                                                    , inComment             := inComment            
                                                    , inUserId              := vbUserId
                                                     );  
 
 
     -- !!! �������� !!!
    IF  vbUserId = 9457 THEN
        RAISE EXCEPTION 'Admin - Test = OK';
    END IF;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 15.09.25         *
*/

-- ����
--