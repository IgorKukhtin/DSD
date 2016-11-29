-- Function: gpGet_Object_PersonalPosition(Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_PersonalPosition (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_PersonalPosition (
    IN inId          Integer,       -- ����������
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (PositionId Integer, PositionName TVarChar
               ) AS
$BODY$
BEGIN

     RETURN QUERY
     SELECT Object_Position.Id          AS PositionId
          , Object_Position.ValueData   AS PositionName
     FROM Object AS Object_Position
     WHERE Object_Position.Id = inId;
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 28.11.16         *
*/

-- ����
-- SELECT * FROM gpGet_Object_PersonalPosition (8466 , '2')