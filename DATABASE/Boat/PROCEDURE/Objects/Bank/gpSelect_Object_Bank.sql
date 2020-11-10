-- Function: gpSelect_Object_Bank(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_Bank (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Bank(
    IN inIsShowAll   Boolean,       -- ������� �������� ��������� �� / ��� 
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , IBAN TVarChar, Comment TVarChar
             , InsertName TVarChar
             , InsertDate TDateTime
             , isErased boolean) AS
$BODY$BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

     RETURN QUERY
     SELECT Object_Bank.Id               AS Id
          , Object_Bank.ObjectCode       AS Code
          , Object_Bank.ValueData        AS Name
          , ObjectString_IBAN.ValueData  AS IBAN
          , ObjectString_Comment.ValueData  AS Comment
          , Object_Insert.ValueData      AS InsertName
          , ObjectDate_Insert.ValueData  AS InsertDate
          , Object_Bank.isErased         AS isErased
     FROM Object AS Object_Bank
        LEFT JOIN ObjectString AS ObjectString_IBAN
                               ON ObjectString_IBAN.ObjectId = Object_Bank.Id
                              AND ObjectString_IBAN.DescId = zc_ObjectString_Bank_IBAN()
        LEFT JOIN ObjectString AS ObjectString_Comment
                               ON ObjectString_Comment.ObjectId = Object_Bank.Id
                              AND ObjectString_Comment.DescId = zc_ObjectString_Bank_Comment()  

        LEFT JOIN ObjectLink AS ObjectLink_Insert
                             ON ObjectLink_Insert.ObjectId = Object_Bank.Id
                            AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
        LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId 
 
        LEFT JOIN ObjectDate AS ObjectDate_Insert
                             ON ObjectDate_Insert.ObjectId = Object_Bank.Id
                            AND ObjectDate_Insert.DescId = zc_ObjectDate_Protocol_Insert()
     WHERE Object_Bank.DescId = zc_Object_Bank();

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.11.20         *
*/

-- ����
-- SELECT * FROM gpSelect_Object_Bank('2')