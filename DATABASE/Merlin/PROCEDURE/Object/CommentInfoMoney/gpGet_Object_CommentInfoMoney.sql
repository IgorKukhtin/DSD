-- Function: gpGet_Object_CommentInfoMoney()

DROP FUNCTION IF EXISTS gpGet_Object_CommentInfoMoney (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_CommentInfoMoney(
    IN inId          Integer,       --  
    IN inSession     TVarChar       -- ������ ������������ 
    )
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased Boolean
             , InfoMoneyKindId Integer, InfoMoneyKindName TVarChar
) AS
$BODY$
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_CommentInfoMoney());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)     AS Id
           , CAST (0 as Integer)     AS Code
           , CAST ('' as TVarChar)   AS Name
           , CAST (FALSE AS Boolean) AS isErased
           , CAST (0 as Integer)     AS InfoMoneyKindId
           , CAST ('' as TVarChar)   AS InfoMoneyKindName
           ;
   ELSE
       RETURN QUERY 
       SELECT Object.Id          AS Id
            , Object.ObjectCode  AS Code
            , Object.ValueData   AS Name
            , Object.isErased    AS isErased
            , Object_InfoMoneyKind.Id         AS InfoMoneyKindId
            , Object_InfoMoneyKind.ValueData  AS InfoMoneyKindName
       FROM Object
            LEFT JOIN ObjectLink AS ObjectLink_InfoMoneyKind
                                 ON ObjectLink_InfoMoneyKind.ObjectId = Object.Id
                                AND ObjectLink_InfoMoneyKind.DescId = zc_ObjectLink_CommentInfoMoney_InfoMoneyKind()
            LEFT JOIN Object AS Object_InfoMoneyKind ON Object_InfoMoneyKind.Id = ObjectLink_InfoMoneyKind.ChildObjectId
       WHERE Object.DescId = zc_Object_CommentInfoMoney()
         AND Object.Id = inId;
   END IF;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 12.01.22          *        
*/

-- ����
-- SELECT * FROM gpGet_Object_CommentInfoMoney(2,'2')