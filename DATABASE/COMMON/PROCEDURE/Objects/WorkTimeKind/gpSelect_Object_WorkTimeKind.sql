-- Function: gpSelect_Object_WorkTimeKind (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_WorkTimeKind (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_WorkTimeKind(
    IN inSession        TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , ShortName TVarChar
             , Value     TVarChar
             , EnumName  TVarChar
             , Tax       TFloat
             , Summ      TFloat
             , isErased Boolean) AS
$BODY$BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_WorkTimeKind());

   RETURN QUERY 
   SELECT
        Object_WorkTimeKind.Id           AS Id 
      , Object_WorkTimeKind.ObjectCode   AS Code
      , Object_WorkTimeKind.ValueData    AS Name
      
      , ObjectString_ShortName.ValueData AS ShortName 
      , zfCalc_ViewWorkHour (0, ObjectString_ShortName.ValueData) AS Value
      , ObjectString_Enum.ValueData      AS EnumName
      , ObjectFloat_Tax.ValueData        AS Tax
      , COALESCE (ObjectFloat_Summ.ValueData,0) ::TFloat AS Summ
      , Object_WorkTimeKind.isErased     AS isErased
      
   FROM OBJECT AS Object_WorkTimeKind
        LEFT JOIN ObjectString AS ObjectString_Enum
                               ON ObjectString_Enum.ObjectId = Object_WorkTimeKind.Id
                              AND ObjectString_Enum.DescId = zc_ObjectString_Enum()

        LEFT JOIN ObjectString AS ObjectString_ShortName
                               ON ObjectString_ShortName.ObjectId = Object_WorkTimeKind.Id
                              AND ObjectString_ShortName.DescId = zc_objectString_WorkTimeKind_ShortName()
                              
        LEFT JOIN ObjectFloat AS ObjectFloat_Tax
                              ON ObjectFloat_Tax.ObjectId = Object_WorkTimeKind.Id
                             AND ObjectFloat_Tax.DescId = zc_ObjectFloat_WorkTimeKind_Tax()
        LEFT JOIN ObjectFloat AS ObjectFloat_Summ
                              ON ObjectFloat_Summ.ObjectId = Object_WorkTimeKind.Id
                             AND ObjectFloat_Summ.DescId = zc_ObjectFloat_WorkTimeKind_Summ()
                               
   WHERE Object_WorkTimeKind.DescId = zc_Object_WorkTimeKind();
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_WorkTimeKind (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 04.06.20         *
 05.12.17         *
 01.10.13         *

*/

-- ����
-- SELECT * FROM gpSelect_Object_WorkTimeKind('2')
