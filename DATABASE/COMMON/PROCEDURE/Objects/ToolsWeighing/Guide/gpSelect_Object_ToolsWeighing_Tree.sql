-- Function: gpSelect_Object_ToolsWeighing_Tree()

DROP FUNCTION IF EXISTS gpSelect_Object_ToolsWeighing_Tree (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ToolsWeighing_Tree (
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,
               BranchCode Integer, ParentId Integer, isErased boolean
              )
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ToolsWeighing());
   vbUserId:= lpGetUserBySession (inSession);

   RETURN QUERY
       SELECT
             Object_ToolsWeighing_View.Id
           , Object_ToolsWeighing_View.Code

           , CASE WHEN Object_ToolsWeighing_View.Name = 'Scale_1'
                       THEN '���������� - (001)������ �����'

                  WHEN Object_ToolsWeighing_View.Name = 'Scale_101'
                       THEN '���������� - (101) ��������������' -- || COALESCE (Object_ToolsWeighing_View.BranchCode :: TVarChar, '???')

                  WHEN Object_ToolsWeighing_View.Name = 'Scale_201'
                       THEN '���������� - (201)�����'

                  WHEN Object_ToolsWeighing_View.Name = 'Scale_205'
                       THEN '���������� - (205)����'

                  WHEN Object_ToolsWeighing_View.Name = 'Scale_301'
                       THEN '���������� - (301)����� ������'

                  WHEN Object_ToolsWeighing_View.Name = 'Scale_302'
                       THEN '���������� - (302)����� ���������'

                  WHEN Object_ToolsWeighing_View.Name = 'Scale_303'
                       THEN '���������� - (303)����� ����������'

                  --
                  --
                  WHEN Object_ToolsWeighing_View.Name = 'ScaleCeh_1'
                       THEN '������������ - (001)����� ����������'

                  --
                  WHEN Object_ToolsWeighing_View.Name = 'ScaleCeh_101'
                       THEN '������������ - (101)����� ���� ��'

                  WHEN Object_ToolsWeighing_View.Name = 'ScaleCeh_102'
                       THEN '������������ - (102)��� ���������'

                  WHEN Object_ToolsWeighing_View.Name = 'ScaleCeh_103'
                       THEN '������������ - (103)��� �������'

                  WHEN Object_ToolsWeighing_View.Name = 'ScaleCeh_104'
                       THEN '������������ - (104)��� �������� (����������+����������)'

                  WHEN Object_ToolsWeighing_View.Name = 'ScaleCeh_105'
                       THEN '������������ - (105)����� ���� �� (��������������)'

                  WHEN Object_ToolsWeighing_View.Name = 'ScaleCeh_106'
                       THEN '������������ - (106)�����������'

                  --
                  WHEN Object_ToolsWeighing_View.Name = 'ScaleCeh_111'
                       THEN '������������ - (111)����� ���� �� - ��������������'
                  --
                  WHEN Object_ToolsWeighing_View.Name = 'ScaleCeh_112'
                       THEN '������������ - (112)����� ���������� - ��������������'
                  --
                  --
                  WHEN Object_ToolsWeighing_View.Name = 'ScaleCeh_201'
                       THEN '������������ - (201)����� - �����'

                  WHEN Object_ToolsWeighing_View.Name = 'ScaleCeh_202'
                       THEN '������������ - (202)����� - �����'

                  WHEN Object_ToolsWeighing_View.Name = 'ScaleCeh_301'
                       THEN '������������ - (301)����� ������'

                  WHEN Object_ToolsWeighing_View.Name = 'ScaleCeh_302'
                       THEN '������������ - (302)����� ���������'
                       
                  WHEN Object_ToolsWeighing_View.Name = 'ScaleCeh_303'
                       THEN '������������ - (303)����� ����������'

                  WHEN POSITION ('Scale_' IN Object_ToolsWeighing_View.Name) = 1
                   AND Object_ToolsWeighing_View.BranchCode > 0
                   AND Object_ToolsWeighing_View.BranchCode < 1000
                       THEN '���������� - ' || '(' || CASE WHEN Object_ToolsWeighing_View.BranchCode < 10 THEN '00' WHEN Object_ToolsWeighing_View.BranchCode < 100 THEN '0' ELSE '' END
                                            || Object_ToolsWeighing_View.BranchCode :: TVarChar || ')'
                                            || COALESCE ((SELECT Object.ValueData FROM Object
                                                          WHERE Object.DescId = zc_Object_Branch() AND Object.ObjectCode = Object_ToolsWeighing_View.BranchCode)
                                                       , Object_ToolsWeighing_View.Name)

                  WHEN POSITION ('Scale_' IN Object_ToolsWeighing_View.Name) = 1
                   AND Object_ToolsWeighing_View.BranchCode > 1000
                       THEN '�������� - ' || '(' || CASE WHEN Object_ToolsWeighing_View.BranchCode - 1000 < 10 THEN '00' WHEN Object_ToolsWeighing_View.BranchCode - 1000 < 100 THEN '0' ELSE '' END
                                          || (Object_ToolsWeighing_View.BranchCode - 1000) :: TVarChar || ')'
                                          || COALESCE ((SELECT Object.ValueData FROM Object
                                                        WHERE Object.DescId = zc_Object_Branch() AND Object.ObjectCode = Object_ToolsWeighing_View.BranchCode - 1000)
                                                     , Object_ToolsWeighing_View.Name)

                  ELSE Object_ToolsWeighing_View.Name

             END :: TvarChar AS Name

           , Object_ToolsWeighing_View.BranchCode
           , COALESCE (Object_ToolsWeighing_View.ParentId, 0) AS ParentId
           , Object_ToolsWeighing_View.isErased

       FROM (SELECT Object_ToolsWeighing_View.*
                  , CASE WHEN POSITION ('Scale_' IN Object_ToolsWeighing_View.Name) = 1
                              THEN zfConvert_StringToNumber (SUBSTRING (Object_ToolsWeighing_View.Name
                                                             FROM LENGTH ('Scale_') + 1
                                                             FOR LENGTH (Object_ToolsWeighing_View.Name) - LENGTH ('Scale_')
                                                            ))
                         WHEN POSITION ('ScaleCeh_' IN Object_ToolsWeighing_View.Name) = 1
                              THEN zfConvert_StringToNumber (SUBSTRING (Object_ToolsWeighing_View.Name
                                                             FROM LENGTH ('ScaleCeh_') + 1
                                                             FOR LENGTH (Object_ToolsWeighing_View.Name) - LENGTH ('ScaleCeh_')
                                                            ))
                         ELSE 0
                    END :: Integer AS BranchCode
             FROM Object_ToolsWeighing_View
             WHERE Object_ToolsWeighing_View.isLeaf = FALSE
            ) AS Object_ToolsWeighing_View

      UNION ALL
       SELECT
             0 AS Id,
             0 AS Code,
             CAST('���' AS TVarChar) AS Name,
             0 AS BranchCode,
             0 AS ParentId,
             FALSE AS isErased
       ORDER BY 4, 3
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 25.03.14                                                         *
*/

-- ����
-- SELECT * FROM gpSelect_Object_ToolsWeighing_Tree ('2') WHERE ParentId = 0 ORDER BY 3
