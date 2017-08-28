-- Function: gpGet_Object_City()

DROP FUNCTION IF EXISTS gpGet_OrderExternal_ExportParam(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_OrderExternal_ExportParam(
    IN inMovementId  Integer,       -- ���� ������� <������>
    IN inSession     TVarChar       -- ������ ������������
)

RETURNS TABLE (DefaultFileName TVarChar, ExportType Integer) AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbContractId Integer;
  DECLARE vbJuridicalId Integer;
  DECLARE vbUnitName TVarChar;
  DECLARE vbSubject TVarChar;
  DECLARE vbMainJuridicalName TVarChar;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());
   vbUserId := lpGetUserBySession (inSession);


      SELECT FromId, REPLACE (REPLACE (ToName, '/', '_'), '\', '_'), Object_Unit_View.JuridicalName
             INTO vbJuridicalId, vbUnitName, vbMainJuridicalName
       FROM Movement_OrderExternal_View 
            LEFT JOIN Object_Unit_View ON Object_Unit_View.Id = ToId
       WHERE Movement_OrderExternal_View.Id = inMovementId;


   IF vbJuridicalId = 59611 THEN --������

      SELECT replace(replace(Object_ImportExportLink_View.StringKey, '|', ''), '*', ' ') INTO vbSubject
      FROM 
          MovementLinkObject 
    
                LEFT JOIN MovementLinkObject AS UnitLink ON UnitLink.DescId = zc_MovementLinkObject_To()
                                                        AND UnitLink.movementid = MovementLinkObject.MovementId
                LEFT JOIN Object_ImportExportLink_View ON Object_ImportExportLink_View.MainId = UnitLink.objectid
                                                      AND Object_ImportExportLink_View.LinkTypeId = zc_Enum_ImportExportLinkType_ClientEmailSubject()
                                                      AND Object_ImportExportLink_View.ValueId = MovementLinkObject.ObjectId  
 
    WHERE MovementLinkObject.DescId = zc_MovementLinkObject_Contract()
      AND MovementLinkObject.MovementId = inMovementId;

       RETURN QUERY
       SELECT
         COALESCE(vbSubject, ('����� - '||COALESCE(vbMainJuridicalName, '')||' �� '||COALESCE(vbUnitName, '')))::TVarChar
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
 14.01.15                         *  
 16.12.14                         *  

*/

-- ����
-- 
SELECT * FROM gpGet_OrderExternal_ExportParam (13692, '2')