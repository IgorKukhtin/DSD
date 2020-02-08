-- Function: gpSelect_ScaleCeh_SubjectDoc()

DROP FUNCTION IF EXISTS gpSelect_ScaleCeh_SubjectDoc (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ScaleCeh_SubjectDoc(
    IN inSession          TVarChar      -- ������ ������������
)
RETURNS TABLE (SubjectDocId   Integer
             , SubjectDocCode Integer
             , SubjectDocName TVarChar
             , isErased        Boolean
              )
AS
$BODY$
   DECLARE vbUserId     Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId:= lpGetUserBySession (inSession);


    -- ���������
    RETURN QUERY
       SELECT Object_SubjectDoc.Id         AS SubjectDocId
            , Object_SubjectDoc.ObjectCode AS SubjectDocCode
            , Object_SubjectDoc.ValueData  AS SubjectDocName
            , Object_SubjectDoc.isErased   AS isErased
       FROM Object AS Object_SubjectDoc
       WHERE Object_SubjectDoc.DescId = zc_Object_SubjectDoc()
         AND Object_SubjectDoc.ObjectCode <> 0
         AND Object_SubjectDoc.isErased = FALSE
       ORDER BY 3
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_ScaleCeh_SubjectDoc (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 07.02.20                                        *
*/

-- ����
-- SELECT * FROM gpSelect_ScaleCeh_SubjectDoc (inSession:=zfCalc_UserAdmin())
