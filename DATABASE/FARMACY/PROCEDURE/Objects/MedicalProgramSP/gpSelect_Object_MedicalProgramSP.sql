
-- Function: gpSelect_Object_MedicalProgramSP(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_MedicalProgramSP(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_MedicalProgramSP(
    IN inSPKindId           Integer  ,     -- ���� ���. ��������
    IN inSession            TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , SPKindId Integer, SPKindName TVarChar
             , ProgramId TVarChar
             , isErased boolean) AS
$BODY$
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_MedicalProgramSP());

   RETURN QUERY 
     SELECT Object_MedicalProgramSP.Id                 AS Id
          , Object_MedicalProgramSP.ObjectCode         AS Code
          , Object_MedicalProgramSP.ValueData          AS Name

          , Object_SPKind.Id                           AS SPKindId
          , Object_SPKind.ValueData                    AS SPKindName

          , ObjectString_ProgramId.ValueData           AS ProgramId

          , Object_MedicalProgramSP.isErased           AS isErased
     FROM Object AS Object_MedicalProgramSP

         LEFT JOIN ObjectLink AS ObjectLink_MedicalProgramSP_SPKind
                              ON ObjectLink_MedicalProgramSP_SPKind.ObjectId = Object_MedicalProgramSP.Id
                             AND ObjectLink_MedicalProgramSP_SPKind.DescId = zc_ObjectLink_MedicalProgramSP_SPKind()
         LEFT JOIN Object AS Object_SPKind ON Object_SPKind.Id = ObjectLink_MedicalProgramSP_SPKind.ChildObjectId

         LEFT JOIN ObjectString AS ObjectString_ProgramId 	
                                ON ObjectString_ProgramId.ObjectId = Object_MedicalProgramSP.Id
                               AND ObjectString_ProgramId.DescId = zc_ObjectString_MedicalProgramSP_ProgramId()

     WHERE Object_MedicalProgramSP.DescId = zc_Object_MedicalProgramSP()
       AND (ObjectLink_MedicalProgramSP_SPKind.ChildObjectId = inSPKindId OR inSPKindId = 0);
  
END;
$BODY$
 
LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 01.10.21                                                       *

*/

-- ����
-- 
SELECT * FROM gpSelect_Object_MedicalProgramSP(0,'2')