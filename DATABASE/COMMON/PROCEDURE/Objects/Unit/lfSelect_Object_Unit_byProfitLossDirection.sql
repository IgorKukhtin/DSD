-- Function: lfSelect_Object_Unit_byProfitLossDirection ()

--DROP FUNCTION IF EXISTS lfSelect_Object_Unit_byProfitLossDirection ();

CREATE OR REPLACE FUNCTION lfSelect_Object_Unit_byProfitLossDirection()

RETURNS TABLE (UnitId Integer, UnitCode Integer, UnitName TVarChar,
               ProfitLossGroupId Integer, ProfitLossGroupCode Integer, ProfitLossGroupName TVarChar, 
               ProfitLossDirectionId Integer, ProfitLossDirectionCode Integer, ProfitLossDirectionName TVarChar,
               BranchId Integer, BranchCode Integer, BranchName TVarChar,
               UnitId_parent0 Integer, UnitCode_parent0 Integer, UnitName_parent0 TVarChar,
               UnitId_parent1 Integer, UnitCode_parent1 Integer, UnitName_parent1 TVarChar
              )
AS
$BODY$
BEGIN

     RETURN QUERY 
       SELECT 
             _tmpObject_Unit.UnitId   AS UnitId
           , _tmpObject_Unit.UnitCode AS UnitCode
           , _tmpObject_Unit.UnitName AS UnitName
          
           , View_ProfitLossDirection.ProfitLossGroupId
           , View_ProfitLossDirection.ProfitLossGroupCode
           , View_ProfitLossDirection.ProfitLossGroupName

           , View_ProfitLossDirection.ProfitLossDirectionId
           , View_ProfitLossDirection.ProfitLossDirectionCode
           , View_ProfitLossDirection.ProfitLossDirectionName

           , Object_Branch.Id         AS BranchId
           , Object_Branch.ObjectCode AS BranchCode
           , Object_Branch.ValueDAta  AS BranchName

           , Object_Unit_parent0.Id         AS UnitId_parent0
           , Object_Unit_parent0.ObjectCode AS UnitCode_parent0
           , Object_Unit_parent0.ValueData  AS UnitName_parent0
           
           , Object_Unit_parent1.Id         AS UnitId_parent1
           , Object_Unit_parent1.ObjectCode AS UnitCode_parent1
           , Object_Unit_parent1.ValueData  AS UnitName_parent1

       FROM (SELECT Object_Unit_parent0.Id
                  , Object_Unit_parent0.ObjectCode
                  , Object_Unit_parent0.ValueData
                  , CASE WHEN tmp.myNumber = 1 THEN Object_Unit_parent0.Id ELSE NULL END AS finId1
                  , CASE WHEN tmp.myNumber = 2 THEN Object_Unit_parent0.Id ELSE NULL END AS finId2
             FROM Object AS Object_Unit_parent0 -- Это самый верхний уровень
                  JOIN ObjectLink AS ObjectLink_Unit_Parent
                                  ON ObjectLink_Unit_Parent.ObjectId = Object_Unit_parent0.Id
                                 AND ObjectLink_Unit_Parent.DescId = zc_ObjectLink_Unit_Parent()
                  JOIN (SELECT 1 AS myNumber UNION ALL SELECT 2 AS myNumber) AS tmp ON tmp.myNumber = 1 OR Object_Unit_parent0.ObjectCode <> 20000
             WHERE Object_Unit_parent0.DescId = zc_Object_Unit()
               AND ObjectLink_Unit_Parent.ChildObjectId IS NULL
            ) AS Object_Unit_parent0

            LEFT JOIN ObjectLink AS ObjectLink_Unit_Child -- Это следующий уровень после самого верхнего
                                 ON ObjectLink_Unit_Child.ChildObjectId = Object_Unit_parent0.finId1
                                AND ObjectLink_Unit_Child.DescId = zc_ObjectLink_Unit_Parent()
            LEFT JOIN Object AS Object_Unit_parent1 ON Object_Unit_parent1.Id = COALESCE (ObjectLink_Unit_Child.ObjectId, Object_Unit_parent0.finId2)

            LEFT JOIN ObjectLink AS ObjectLink_Unit_ProfitLossDirection -- "Аналитика ОПиУ - направление" установлена !!!только!!! у следующего после самого верхнего уровня или ...
                                 ON ObjectLink_Unit_ProfitLossDirection.ObjectId = COALESCE (ObjectLink_Unit_Child.ObjectId, Object_Unit_parent0.finId2)
                                AND ObjectLink_Unit_ProfitLossDirection.DescId = zc_ObjectLink_Unit_ProfitLossDirection()
            LEFT JOIN Object_ProfitLossDirection_View AS View_ProfitLossDirection ON View_ProfitLossDirection.ProfitLossDirectionId = ObjectLink_Unit_ProfitLossDirection.ChildObjectId

                       -- это все подразделения где ParentId_main - следующий уровень после самого верхнего
            LEFT JOIN (SELECT CASE WHEN ObjectLink_Unit_Parent8.ChildObjectId IS NULL
                                      THEN Object_Unit.Id -- NULL, т.е. раньше было: если верхний уровень не установлен, тогда Object_Unit и есть самый верхний (и он по идее не нужен)
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
                      ) AS _tmpObject_Unit ON _tmpObject_Unit.ParentId_main = COALESCE (ObjectLink_Unit_Child.ObjectId, Object_Unit_parent0.finId2)
                      LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                                           ON ObjectLink_Unit_Branch.ObjectId = _tmpObject_Unit.UnitId
                                          AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
                      LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_Unit_Branch.ChildObjectId
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION lfSelect_Object_Unit_byProfitLossDirection () OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.03.14                                        * add Level-0
 12.11.13                                        * add Object_ProfitLossDirection_View
 21.10.13                                        * err
 26.08.13                                        *
*/

/*
select *
from (
SELECT a.ProfitLossGroupId as ProfitLossGroupId1, (lfGet_Object_Unit_byProfitLossDirection (a.UnitId)).ProfitLossGroupId as ProfitLossGroupId2
     , a.ProfitLossDirectionId as ProfitLossDirectionId1, (lfGet_Object_Unit_byProfitLossDirection (a.UnitId)).ProfitLossDirectionId as ProfitLossDirectionId2
     , a.*
FROM lfSelect_Object_Unit_byProfitLossDirection ()  as a
) as aa
where coalesce (ProfitLossGroupId2, 0) <> coalesce (ProfitLossGroupId1, 0) or coalesce (ProfitLossDirectionId2, 0) <> coalesce (ProfitLossDirectionId1, 0)
*/

-- тест
-- SELECT UnitId_parent0, UnitCode_parent0, UnitName_parent0, UnitId_parent1, UnitCode_parent1, UnitName_parent1 FROM lfSelect_Object_Unit_byProfitLossDirection () GROUP BY UnitId_parent0, UnitCode_parent0, UnitName_parent0, UnitId_parent1, UnitCode_parent1, UnitName_parent1 ORDER BY UnitCode_parent0, UnitCode_parent1
-- SELECT UnitCode_parent0, UnitName_parent0, UnitCode_parent1, UnitName_parent1, UnitCode, UnitName FROM lfSelect_Object_Unit_byProfitLossDirection () ORDER BY UnitCode_parent0, UnitCode_parent1, UnitCode
-- SELECT * FROM lfSelect_Object_Unit_byProfitLossDirection () ORDER BY UnitCode_parent0, UnitCode_parent1, UnitCode
