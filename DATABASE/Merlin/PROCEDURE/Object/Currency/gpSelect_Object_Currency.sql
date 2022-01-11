-- Function: gpSelect_Object_Currency()

DROP FUNCTION IF EXISTS gpSelect_Object_Currency (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Currency(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased Boolean
             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar, UpdateDate TDateTime
) AS
$BODY$BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Currency());

   RETURN QUERY 
   SELECT Object_Currency.Id          AS Id
        , Object_Currency.ObjectCode  AS Code
        , Object_Currency.ValueData   AS Name
        , Object_Currency.isErased    AS isErased

        , Object_Insert.ValueData         AS InsertName
        , ObjectDate_Insert.ValueData     AS InsertDate
        , Object_Update.ValueData         AS UpdateName
        , ObjectDate_Update.ValueData     AS UpdateDate

       FROM Object AS Object_Currency
        LEFT JOIN ObjectLink AS ObjectLink_Insert
                             ON ObjectLink_Insert.ObjectId = Object_Currency.Id
                            AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
        LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId

        LEFT JOIN ObjectDate AS ObjectDate_Insert
                             ON ObjectDate_Insert.ObjectId = Object_Currency.Id
                            AND ObjectDate_Insert.DescId = zc_ObjectDate_Protocol_Insert()

        LEFT JOIN ObjectLink AS ObjectLink_Update
                             ON ObjectLink_Update.ObjectId = Object_Currency.Id
                            AND ObjectLink_Update.DescId = zc_ObjectLink_Protocol_Update()
        LEFT JOIN Object AS Object_Update ON Object_Update.Id = ObjectLink_Update.ChildObjectId

        LEFT JOIN ObjectDate AS ObjectDate_Update
                             ON ObjectDate_Update.ObjectId = Object_Currency.Id
                            AND ObjectDate_Update.DescId = zc_ObjectDate_Protocol_Update()
       WHERE Object_Currency.DescId = zc_Object_Currency()
   ;
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 11.01.22          *     
*/

-- ����
-- SELECT * FROM gpSelect_Object_Currency('2')