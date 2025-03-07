-- Function: gpGet_Object_Unit_PersonalParam()

DROP FUNCTION IF EXISTS gpGet_Object_Unit_PersonalParam( TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Unit_PersonalParam(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (SessionCode Integer,
               StartDate TDateTime, EndDate TDateTime
) AS
$BODY$
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_Unit());
       RETURN QUERY
       SELECT (SELECT MAX (Object.ObjectCode) + 1
               FROM Object
               WHERE Object.DescId = zc_Object_MessagePersonalService()
               ) ::Integer AS SessionCode
              , (DATE_TRUNC ('MONTH', (CURRENT_DATE - INTERVAL '1 MONTH')::TDateTime)) ::TDateTime  AS StartDate
              , (DATE_TRUNC ('MONTH', CURRENT_DATE)  - INTERVAL '1 DAY' )              ::TDateTime AS EndDate
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 06.03.25         *
*/

-- ����
-- select * from gpGet_Object_Unit_PersonalParam(  inSession := '9457');
