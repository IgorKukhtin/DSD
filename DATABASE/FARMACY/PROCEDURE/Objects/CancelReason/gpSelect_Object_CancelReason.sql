-- Function: gpSelect_Object_CancelReason()

--DROP FUNCTION IF EXISTS gpSelect_Object_CancelReason(TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_CancelReason(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_CancelReason(
    IN inMovementId    Integer   ,    -- ��������
    IN inSession       TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased boolean) AS
$BODY$BEGIN
   
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Area()());
   
   IF COALESCE (inMovementId, 0) <> 0 AND
      EXISTS(SELECT * FROM MovementLinkObject AS MovementLinkObject_CheckSourceKind
             WHERE MovementLinkObject_CheckSourceKind.MovementId =  inMovementId
               AND MovementLinkObject_CheckSourceKind.DescId = zc_MovementLinkObject_CheckSourceKind()
               AND MovementLinkObject_CheckSourceKind.ObjectId = zc_Enum_CheckSourceKind_Tabletki())
   THEN

     RETURN QUERY 
     SELECT Object_CancelReason.Id                             AS Id 
          , Object_CancelReason.ObjectCode                     AS Code
          , Object_CancelReason.ValueData                      AS Name
          , Object_CancelReason.isErased                       AS isErased
     FROM Object AS Object_CancelReason
     WHERE Object_CancelReason.DescId = zc_Object_CancelReason()
       AND Object_CancelReason.ObjectCode in (4, 5);
     
   ELSE

     RETURN QUERY 
     SELECT Object_CancelReason.Id                             AS Id 
          , Object_CancelReason.ObjectCode                     AS Code
          , Object_CancelReason.ValueData                      AS Name
          , Object_CancelReason.isErased                       AS isErased
     FROM Object AS Object_CancelReason

     WHERE Object_CancelReason.DescId = zc_Object_CancelReason();
   
   END IF;
  
END;$BODY$


LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_CancelReason(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------

 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 03.09.20                                                       *
*/

-- ����
-- 
SELECT * FROM gpSelect_Object_CancelReason(31812138, '3')