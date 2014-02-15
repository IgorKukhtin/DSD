-- Function: lfSelect_Object_Unit_byProfitLossDirection ()

DROP FUNCTION IF EXISTS lfSelect_Object_Unit_byProfitLossDirection ();

CREATE OR REPLACE FUNCTION lfSelect_Object_Unit_byProfitLossDirection()

RETURNS TABLE (UnitId Integer, UnitCode Integer, UnitName TVarChar,
               ProfitLossGroupId Integer, ProfitLossGroupCode Integer, ProfitLossGroupName TVarChar, 
               ProfitLossDirectionId Integer, ProfitLossDirectionCode Integer, ProfitLossDirectionName TVarChar,
               UnitId_parent0 Integer, UnitCode_parent0 Integer, UnitName_parent0 TVarChar,
               UnitId_parent1 Integer, UnitCode_parent1 Integer, UnitName_parent1 TVarChar)
AS
$BODY$
BEGIN

     RETURN QUERY 
       SELECT 
             _tmpObject_Unit.UnitId
           , _tmpObject_Unit.UnitCode
           , _tmpObject_Unit.UnitName
          
           , View_ProfitLossDirection.ProfitLossGroupId
           , View_ProfitLossDirection.ProfitLossGroupCode
           , View_ProfitLossDirection.ProfitLossGroupName

           , View_ProfitLossDirection.ProfitLossDirectionId
           , View_ProfitLossDirection.ProfitLossDirectionCode
           , View_ProfitLossDirection.ProfitLossDirectionName

           , Object_Unit_parent0.Id         AS UnitId_parent0
           , Object_Unit_parent0.ObjectCode AS UnitCode_parent0
           , Object_Unit_parent0.ValueData  AS UnitName_parent0
           
           , Object_Unit_parent1.Id         AS UnitId_parent1
           , Object_Unit_parent1.ObjectCode AS UnitCode_parent1
           , Object_Unit_parent1.ValueData  AS UnitName_parent1

       FROM Object AS Object_Unit_parent0 -- ��� ����� ������� �������
            JOIN ObjectLink AS ObjectLink_Unit_Parent
                            ON ObjectLink_Unit_Parent.ObjectId = Object_Unit_parent0.Id
                           AND ObjectLink_Unit_Parent.DescId = zc_ObjectLink_Unit_Parent()

            LEFT JOIN ObjectLink AS ObjectLink_Unit_Child -- ��� ��������� ������� ����� ������ ��������
                                 ON ObjectLink_Unit_Child.ChildObjectId = Object_Unit_parent0.Id
                                AND ObjectLink_Unit_Parent.DescId = zc_ObjectLink_Unit_Parent()
            LEFT JOIN Object AS Object_Unit_parent1 ON Object_Unit_parent1.Id = ObjectLink_Unit_Child.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Unit_ProfitLossDirection -- "��������� ���� - �����������" ����������� !!!������!!! � ���������� ����� ������ �������� ������ 
                                 ON ObjectLink_Unit_ProfitLossDirection.ObjectId = ObjectLink_Unit_Child.ObjectId
                                AND ObjectLink_Unit_ProfitLossDirection.DescId = zc_ObjectLink_Unit_ProfitLossDirection()
            LEFT JOIN Object_ProfitLossDirection_View AS View_ProfitLossDirection ON View_ProfitLossDirection.ProfitLossDirectionId = ObjectLink_Unit_ProfitLossDirection.ChildObjectId

                       -- ��� ��� ������������� ��� ParentId_main - ��������� ������� ����� ������ ��������
            LEFT JOIN (SELECT CASE WHEN ObjectLink_Unit_Parent8.ChildObjectId IS NULL
                                      THEN NULL -- ���� ������� ������� �� ����������, ����� Object_Unit � ���� ����� ������� (� �� �� ���� �� �����)
                                   WHEN ObjectLink_Unit_Parent7.ChildObjectId IS NULL
                                      THEN ObjectLink_Unit_Parent8.ObjectId
                                   WHEN ObjectLink_Unit_Parent6.ChildObjectId IS NULL
                                      THEN ObjectLink_Unit_Parent7.ObjectId
                                   WHEN ObjectLink_Unit_Parent5.ChildObjectId IS NULL
                                      THEN ObjectLink_Unit_Parent6.ObjectId
                                   WHEN ObjectLink_Unit_Parent4.ChildObjectId IS NULL
                                      THEN ObjectLink_Unit_Parent5.ObjectId
                                   WHEN ObjectLink_Unit_Parent3.ChildObjectId IS NULL
                                      THEN ObjectLink_Unit_Parent4.ObjectId
                                   WHEN ObjectLink_Unit_Parent2.ChildObjectId IS NULL
                                      THEN ObjectLink_Unit_Parent3.ObjectId
                                   WHEN ObjectLink_Unit_Parent1.ChildObjectId IS NULL
                                      THEN ObjectLink_Unit_Parent2.ObjectId
                                   WHEN ObjectLink_Unit_Parent0.ChildObjectId IS NULL
                                      THEN ObjectLink_Unit_Parent1.ObjectId
                              END AS ParentId_main
                            , Object_Unit.Id         AS UnitId
                            , Object_Unit.ObjectCode AS UnitCode
                            , Object_Unit.ValueData  AS UnitName
                       FROM Object AS Object_Unit
                            LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent8
                                                 ON ObjectLink_Unit_Parent8.ObjectId = Object_Unit.Id
                                                AND ObjectLink_Unit_Parent8.DescId = zc_ObjectLink_Unit_Parent()
                            LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent7
                                                 ON ObjectLink_Unit_Parent7.ObjectId = ObjectLink_Unit_Parent8.ChildObjectId
                                                AND ObjectLink_Unit_Parent7.DescId = zc_ObjectLink_Unit_Parent()
                            LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent6
                                                 ON ObjectLink_Unit_Parent6.ObjectId = ObjectLink_Unit_Parent7.ChildObjectId
                                                AND ObjectLink_Unit_Parent6.DescId = zc_ObjectLink_Unit_Parent()
                            LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent5
                                                 ON ObjectLink_Unit_Parent5.ObjectId = ObjectLink_Unit_Parent6.ChildObjectId
                                                AND ObjectLink_Unit_Parent5.DescId = zc_ObjectLink_Unit_Parent()
                            LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent4
                                                 ON ObjectLink_Unit_Parent4.ObjectId = ObjectLink_Unit_Parent5.ChildObjectId
                                                AND ObjectLink_Unit_Parent4.DescId = zc_ObjectLink_Unit_Parent()
                            LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent3
                                                 ON ObjectLink_Unit_Parent3.ObjectId = ObjectLink_Unit_Parent4.ChildObjectId
                                                AND ObjectLink_Unit_Parent3.DescId = zc_ObjectLink_Unit_Parent()
                            LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent2
                                                 ON ObjectLink_Unit_Parent2.ObjectId = ObjectLink_Unit_Parent3.ChildObjectId
                                                AND ObjectLink_Unit_Parent2.DescId = zc_ObjectLink_Unit_Parent()
                            LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent1
                                                 ON ObjectLink_Unit_Parent1.ObjectId = ObjectLink_Unit_Parent2.ChildObjectId
                                                AND ObjectLink_Unit_Parent1.DescId = zc_ObjectLink_Unit_Parent()
                            LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent0
                                                 ON ObjectLink_Unit_Parent0.ObjectId = ObjectLink_Unit_Parent1.ChildObjectId
                                                AND ObjectLink_Unit_Parent0.DescId = zc_ObjectLink_Unit_Parent()
                       WHERE Object_Unit.DescId = zc_Object_Unit()
                      ) AS _tmpObject_Unit ON _tmpObject_Unit.ParentId_main = ObjectLink_Unit_Child.ObjectId

       WHERE Object_Unit_parent0.DescId = zc_Object_Unit()
         AND ObjectLink_Unit_Parent.ChildObjectId IS NULL;

END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION lfSelect_Object_Unit_byProfitLossDirection () OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 12.11.13                                        * add Object_ProfitLossDirection_View
 21.10.13                                        * err
 26.08.13                                        *
*/

-- ����
-- SELECT UnitId_parent0, UnitCode_parent0, UnitName_parent0, UnitId_parent1, UnitCode_parent1, UnitName_parent1 FROM lfSelect_Object_Unit_byProfitLossDirection () GROUP BY UnitId_parent0, UnitCode_parent0, UnitName_parent0, UnitId_parent1, UnitCode_parent1, UnitName_parent1 ORDER BY UnitCode_parent0, UnitCode_parent1
-- SELECT UnitCode_parent0, UnitName_parent0, UnitCode_parent1, UnitName_parent1, UnitCode, UnitName FROM lfSelect_Object_Unit_byProfitLossDirection () ORDER BY UnitCode_parent0, UnitCode_parent1, UnitCode
-- SELECT * FROM lfSelect_Object_Unit_byProfitLossDirection () ORDER BY UnitCode_parent0, UnitCode_parent1, UnitCode
