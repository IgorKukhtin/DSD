-- Function: gpGet_OrderInternalPromo_ExportParam()

DROP FUNCTION IF EXISTS gpGet_OrderInternalPromo_ExportParam(integer, integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_OrderInternalPromo_ExportParam(
    IN inMovementId  Integer,       -- ���� ������� <������>
    IN inJuridicalId Integer      , -- ���������
    IN inSession     TVarChar       -- ������ ������������
)

RETURNS TABLE (DefaultFileName TVarChar, ExportType Integer) AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbStatusId Integer;
  DECLARE vbMainJuridicalName TVarChar;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());
   vbUserId := lpGetUserBySession (inSession);
  
   -- ����������
   SELECT StatusId
   INTO vbStatusId
   FROM Movement
   WHERE Movement.Id = inMovementId;


   -- ��������� - ��� ���� ���������
   RETURN QUERY
   SELECT
      '������������ �����'::TVarChar
    , 3 AS ExportType
     ;


END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_OrderInternalPromo_ExportParam(integer, integer, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 08.08.21                                                       *

*/

-- ����
--
 SELECT * FROM gpGet_OrderInternalPromo_ExportParam (inMovementId := 23631157 , inJuridicalId := 59611 , inSession := '3')