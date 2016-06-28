-- Function: gpSelect_Object_Email()

DROP FUNCTION IF EXISTS gpSelect_Object_Email(TVarChar);


CREATE OR REPLACE FUNCTION gpSelect_Object_Email(
    IN inSession       TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,
               EmailKindId Integer, EmailKindName TVarChar
               ) AS
$BODY$
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Email());

   RETURN QUERY 
   SELECT Object_Email.Id             AS Id
        , Object_Email.ObjectCode     AS Code
        , Object_Email.ValueData      AS Name
        , Object_EmailKind.Id         AS EmailKindId
        , Object_EmailKind.ValueData  AS EmailKindName
   FROM Object AS Object_Email
      LEFT JOIN ObjectLink AS ObjectLink_EmailKind
                           ON ObjectLink_EmailKind.ObjectId = Object_Email.Id
                          AND ObjectLink_EmailKind.DescId = zc_ObjectLink_Email_EmailKind()
      LEFT JOIN Object AS Object_EmailKind ON Object_EmailKind.Id = ObjectLink_EmailKind.ChildObjectId

   WHERE Object_Email.DescId = zc_Object_Email()

;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 27.06.16         *

*/

-- ����
--SELECT * FROM gpSelect_Object_Email ('2')