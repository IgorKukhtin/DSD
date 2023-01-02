-- Function: gpGet_CurrentDateTimeUTC()

DROP FUNCTION IF EXISTS gpGet_CurrentDateTimeUTC(TVarChar);

CREATE OR REPLACE FUNCTION gpGet_CurrentDateTimeUTC(
   OUT outDateTime   TDateTime ,    -- ���������
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TDateTime
AS
$BODY$
BEGIN
	
  outDateTime := CURRENT_TIMESTAMP at time zone 'UTC';
    
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_CurrentDateTimeUTC(TVarChar) OWNER TO postgres;



/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 30.12.22                                                       *   

*/

-- ����
-- 
select gpGet_CurrentDateTimeUTC('')