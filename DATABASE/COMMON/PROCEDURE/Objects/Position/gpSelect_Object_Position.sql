-- Function: gpSelect_Object_Position(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_Position(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Position(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,
               SheetWorkTimeId Integer, SheetWorkTimeName TVarChar,
               isErased boolean) AS
$BODY$
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Position());

   RETURN QUERY 
     SELECT 
           Object_Position.Id             AS Id
         , Object_Position.ObjectCode     AS Code
         , Object_Position.ValueData      AS Name

         , Object_SheetWorkTime.Id        AS SheetWorkTimeId 
         , Object_SheetWorkTime.ValueData AS SheetWorkTimeName

         , Object_Position.isErased       AS isErased

     FROM Object AS Object_Position
          LEFT JOIN ObjectLink AS ObjectLink_Position_SheetWorkTime
                               ON ObjectLink_Position_SheetWorkTime.ObjectId = Object_Position.Id
                              AND ObjectLink_Position_SheetWorkTime.DescId = zc_ObjectLink_Position_SheetWorkTime()
          LEFT JOIN Object AS Object_SheetWorkTime ON Object_SheetWorkTime.Id = ObjectLink_Position_SheetWorkTime.ChildObjectId

     WHERE Object_Position.DescId = zc_Object_Position();
  
END;
$BODY$
 
LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Position(TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 16.11.16         * add SheetWorkTime
 01.07.13         *              
*/

-- ����
-- SELECT * FROM gpSelect_Object_Position('2')