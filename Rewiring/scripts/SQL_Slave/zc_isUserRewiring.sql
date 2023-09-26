-- Function: _replica.zc_isUserRewiring()

-- DROP FUNCTION _replica.zc_isUserRewiring();

CREATE OR REPLACE FUNCTION _replica.zc_isUserRewiring()
RETURNS Boolean
AS
$BODY$
BEGIN 
     RETURN  session_user ILIKE '%s';
END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 21.09.23                                                       * 
*/

-- ����
-- SELECT _replica.zc_isUserRewiring();
