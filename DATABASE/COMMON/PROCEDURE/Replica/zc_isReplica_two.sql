-- Function: _replica.zc_isReplica_two()

-- DROP FUNCTION _replica.zc_isReplica_two();

CREATE OR REPLACE FUNCTION _replica.zc_isReplica_two()
RETURNS Boolean
AS
$BODY$
BEGIN 
     RETURN TRUE;
END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 20.02.21                                        *
*/

-- ����
SELECT _replica.zc_isReplica_two();
