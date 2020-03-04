-- Function: gpInsert_Movement_TechnicalRediscount_RedCheck()

DROP FUNCTION IF EXISTS gpInsert_Movement_TechnicalRediscount_RedCheck (Integer, TVarChar);

CREATE OR REPLACE FUNCTION public.gpInsert_Movement_TechnicalRediscount_RedCheck (
   IN inUnitId integer,
  OUT outMovementId integer,
    IN inSession public.tvarchar
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_TechnicalRediscount());
     
     -- ��������� <��������>
     outMovementId := lpInsertUpdate_Movement_TechnicalRediscount (ioId               := 0
                                                                 , inInvNumber        := CAST (NEXTVAL ('Movement_TechnicalRediscount_seq') AS TVarChar)
                                                                 , inOperDate         := CURRENT_DATE
                                                                 , inUnitId           := inUnitId
                                                                 , inComment          := ''
                                                                 , inisRedCheck       := True
                                                                 , inUserId           := vbUserId
                                                                  );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
ALTER FUNCTION gpInsert_Movement_TechnicalRediscount_RedCheck (Integer, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 15.02.20                                                       *
*/