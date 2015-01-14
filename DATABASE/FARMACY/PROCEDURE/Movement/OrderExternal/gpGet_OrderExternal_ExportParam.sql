-- Function: gpGet_Object_City()

DROP FUNCTION IF EXISTS gpGet_OrderExternal_ExportParam(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_OrderExternal_ExportParam(
    IN inMovementId  Integer,       -- ���� ������� <������>
    IN inSession     TVarChar       -- ������ ������������
)

RETURNS TABLE (DefaultFileName TVarChar, ExportType Integer) AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbJuridicalId Integer;
  DECLARE vbUnitName TVarChar;
  DECLARE vbMainJuridicalName TVarChar;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());
   vbUserId := lpGetUserBySession (inSession);

   SELECT FromId, ToName, Object_Unit_View.JuridicalName INTO vbJuridicalId, vbUnitName, vbMainJuridicalName
       FROM Movement_OrderExternal_View 
            LEFT JOIN Object_Unit_View ON Object_Unit_View.Id = ToId
       WHERE Movement_OrderExternal_View.Id = inMovementId;

   IF vbJuridicalId = 59611 THEN --������

       RETURN QUERY
       SELECT
         ('����� - '||COALESCE(vbMainJuridicalName, '')||' �� '||COALESCE(vbUnitName, ''))::TVarChar
        , 5;
       RETURN;
   END IF;

   IF vbJuridicalId = 59610 THEN --����

       RETURN QUERY
       SELECT
         ('����� - '||COALESCE(vbMainJuridicalName, '')||' �� '||COALESCE(vbUnitName, ''))::TVarChar
        , 5;
       RETURN;
   END IF;

   RETURN QUERY
   SELECT
      ('����� - '||COALESCE(vbMainJuridicalName, '')||' �� '||COALESCE(vbUnitName, ''))::TVarChar
    , 3;


END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_OrderExternal_ExportParam(integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 16.12.14                         *  

*/

-- ����
-- SELECT * FROM gpGet_Object_City (0, '2')