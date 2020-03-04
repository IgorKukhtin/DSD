-- Function: gpInsert_Movement_TechnicalRediscount_Add()

DROP FUNCTION IF EXISTS gpInsert_Movement_TechnicalRediscount_Add (Integer, TVarChar);

CREATE OR REPLACE FUNCTION public.gpInsert_Movement_TechnicalRediscount_Add (
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
                                                                 , inisRedCheck       := False
                                                                 , inUserId           := vbUserId
                                                                  );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
ALTER FUNCTION gpInsert_Movement_TechnicalRediscount_Add (Integer, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 04.03.20                                                       *
*/