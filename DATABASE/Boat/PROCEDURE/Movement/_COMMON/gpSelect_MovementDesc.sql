--Function: gpSelect_Object(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_MovementDesc(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementDesc(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, DocumentDesc TVarChar, DocumentName TVarChar, FormId Integer, FormName TVarChar)
AS
$BODY$
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_PaidKind());

   RETURN QUERY 
   SELECT 
        MovementDesc.Id,
        MovementDesc.Code,
        MovementDesc.ItemName,
        Object.Id, 
        Object.ValueData

   FROM MovementDesc
        LEFT JOIN Object ON Object.Id = MovementDesc.FormId;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 23.01.14                         *

*/

-- ����
-- SELECT * FROM gpSelect_MovementDesc('2')
