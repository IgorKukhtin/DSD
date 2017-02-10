-- Function: gpGet_Object_Member (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_MemberContact (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_MemberContact(
    IN inId          Integer,        -- ���������� ���� 
    IN inSession     TVarChar        -- ������ ������������
)
RETURNS TABLE (EMail TVarChar, EMailSign TBlob) AS
$BODY$
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_Member());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
           ''::TVarChar AS Email
         , ''::TBlob    AS EMailSign;
   ELSE
       RETURN QUERY 
     SELECT 
         ObjectString_Email.ValueData           AS Email
       , ObjectBlob_EmailSign.ValueData         AS EmailSign

     FROM ObjectString AS ObjectString_Email 
             LEFT JOIN ObjectBlob AS ObjectBlob_EMailSign 
                                  ON ObjectBlob_EMailSign.ObjectId = ObjectString_Email.ObjectId
                                 AND ObjectBlob_EMailSign.DescId =  zc_ObjectBlob_Member_EMailSign()
          WHERE ObjectString_Email.ObjectId = inId 
            AND ObjectString_Email.DescId = zc_ObjectString_Member_Email();
     
   END IF;
   
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_MemberContact (Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 18.11.14                         * add 
*/

-- ����
-- SELECT * FROM gpSelect_Member('2')