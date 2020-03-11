-- Function: gpInsertUpdate_Movement_TechnicalRediscount()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_TechnicalRediscount (Integer, TVarChar, TDateTime, Integer, TVarChar, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_TechnicalRediscount(
 INOUT ioId                  Integer   , -- ���� ������� <�������� ������� ����������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inUnitId              Integer   , -- �������������
    IN inComment             TVarChar  , -- ����������
    IN inisRedCheck          Boolean  ,  -- ������� ���
    IN inisAdjustment        Boolean  ,  -- ������������� ��������� ���������
    IN inSession             TVarChar    -- ������ ������������
)                               
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     IF COALESCE(ioId, 0) = 0
     THEN
        vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_TechnicalRediscount());
     ELSE
        vbUserId:= lpGetUserBySession (inSession);
     END IF;
     
     
     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement_TechnicalRediscount (ioId               := ioId
                                                        , inInvNumber        := inInvNumber
                                                        , inOperDate         := inOperDate
                                                        , inUnitId           := inUnitId
                                                        , inComment          := inComment
                                                        , inisRedCheck       := inisRedCheck
                                                        , inisAdjustment     := inisAdjustment
                                                        , inUserId           := vbUserId
                                                         );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
ALTER FUNCTION gpInsertUpdate_Movement_TechnicalRediscount (Integer, TVarChar, TDateTime, Integer, TVarChar, Boolean, Boolean, TVarChar) OWNER TO postgres;
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 15.02.20                                                       *
*/