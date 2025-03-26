CREATE TABLE _MIContainer_2024_06_07(
   Id             BIGSERIAL NOT NULL PRIMARY KEY,
   DescId         INTEGER,
   MovementId     INTEGER,
   ContainerId    INTEGER,
   Amount         TFloat,
   OperDate       TDateTime,
   MovementItemId Integer,
   ParentId       BigInt,
   isActive       Boolean,

   MovementDescId integer,
   AnalyzerId integer,
   AccountId integer,
   ObjectId_analyzer integer,
   WhereObjectId_analyzer integer,
   ContainerId_analyzer integer,

   ObjectIntId_analyzer integer,
   ObjectExtId_analyzer integer,

   ContainerIntId_analyzer integer,
   AccountId_analyzer integer
)

/*
delete from _MIContainer_2024_06_07;
insert into _MIContainer_2024_06_07 (Id, DescId, MovementId, ContainerId, Amount, OperDate, MovementItemId, ParentId, isActive
                                   , MovementDescId, AnalyzerId, AccountId, ObjectId_analyzer, WhereObjectId_analyzer
                                   , ContainerId_analyzer, ObjectIntId_analyzer, ObjectExtId_analyzer, ContainerIntId_analyzer, AccountId_analyzer
                                    )

select Id, DescId, MovementId, ContainerId, Amount, OperDate, MovementItemId, ParentId, isActive
     , MovementDescId, AnalyzerId, AccountId, ObjectId_analyzer, WhereObjectId_analyzer
     , ContainerId_analyzer, ObjectIntId_analyzer, ObjectExtId_analyzer, ContainerIntId_analyzer, AccountId_analyzer
from MovementItemContainer
where MovementItemContainer.MovementId = 28170990;


-- update MovementItem set isErased = true where isErased = false and Amount = 0 and MovementId = 28170990;
-- select gpComplete_All_Sybase (28170990, false, '')

*/
       with new_ AS (select ContainerId, sum (Amount) AS Amount, MovementItemId, DescId
                     from MovementItemContainer
                     where MovementId = 28170990
                     group by ContainerId, MovementItemId, DescId
                    )
          , old_ AS (select ContainerId, sum (Amount) AS Amount, MovementItemId, DescId
                     from _MIContainer_2024_06_07
                     where MovementId = 28170990
                     group by ContainerId, MovementItemId, DescId
                    )

       SELECT COALESCE (new_.MovementItemId, old_.MovementItemId) AS MovementItemId
            , COALESCE (new_.ContainerId, old_.ContainerId) AS ContainerId
            , COALESCE (new_.DescId, old_.DescId) AS DescId
            , new_.Amount AS Amount_new , old_.Amount AS Amount_old
            , *
       FROM new_
            FULL JOIN old_ ON old_.ContainerId     = new_.ContainerId
                          AND old_.MovementItemId  = new_.MovementItemId
       WHERE COALESCE (new_.Amount, 0) <> COALESCE  (old_.Amount, 0)
         and COALESCE (new_.DescId, old_.DescId) = 1
       ORDER BY COALESCE (new_.MovementItemId, old_.MovementItemId)
              , COALESCE (new_.ContainerId, old_.ContainerId)
              , COALESCE (new_.DescId, old_.DescId)



     -- all
      with new_ AS (select ObjectId_analyzer, coalesce (ObjectIntId_Analyzer, 0) as ObjectIntId_Analyzer,  sum (Amount) AS Amount, descId -- , ContainerId
                     from MovementItemContainer
                     where MovementId = 28170990
-- and ObjectId_analyzer = 3733
     --                  AND DescId = 2
                      group by DescId, ObjectId_analyzer, ObjectIntId_Analyzer
                    )
          , old_ AS (select ObjectId_analyzer, coalesce (ObjectIntId_Analyzer, 0) as ObjectIntId_Analyzer, sum  (Amount) AS Amount, descId -- , ContainerId
                     from _MIContainer_2024_06_07 AS MovementItemContainer
                     where MovementId = 28170990
   --                    AND DescId = 2
-- and ObjectId_analyzer = 3733
                      group by DescId, ObjectId_analyzer, ObjectIntId_Analyzer
                    )

       SELECT new_.Amount AS Amount_new , old_.Amount AS Amount_old
            , Object.*, Object_2.ValueData
            , *
       FROM new_
            FULL JOIN old_ ON old_.ObjectIntId_Analyzer   = new_.ObjectIntId_Analyzer
                          AND old_.ObjectId_analyzer  = new_.ObjectId_analyzer
                          AND old_.descId  = new_.descId

            LEFT JOIN Object ON Object.Id = COALESCE (new_.ObjectId_analyzer, old_.ObjectId_analyzer) -- Container.ObjectId
            LEFT JOIN Object AS Object_2 ON Object_2.Id = COALESCE (new_.ObjectIntId_Analyzer, old_.ObjectIntId_Analyzer)

       WHERE COALESCE (new_.Amount, 0) <> COALESCE  (old_.Amount, 0)
       ORDER BY COALESCE (new_.ObjectId_analyzer, old_.ObjectId_analyzer)
              , Object_2.ValueData
              , ABS (COALESCE (new_.Amount , old_.Amount)) desc



     -- count
      with new_ AS (select ObjectId_analyzer, coalesce (ObjectIntId_Analyzer, 0) as ObjectIntId_Analyzer,  sum (Amount) AS Amount -- , ContainerId
                     from MovementItemContainer
                     where MovementId = 28170990
-- and ObjectId_analyzer = 3733
                       AND DescId = 1
                      group by DescId, ObjectId_analyzer, ObjectIntId_Analyzer
                    )
          , old_ AS (select ObjectId_analyzer, coalesce (ObjectIntId_Analyzer, 0) as ObjectIntId_Analyzer, sum  (Amount) AS Amount -- , ContainerId
                     from _MIContainer_2024_06_07 AS MovementItemContainer
                     where MovementId = 28170990
                       AND DescId = 1
-- and ObjectId_analyzer = 3733
                      group by DescId, ObjectId_analyzer, ObjectIntId_Analyzer
                    )

       SELECT new_.Amount AS Amount_new , old_.Amount AS Amount_old
            , Object.*, Object_2.ValueData
            , *
       FROM new_
            FULL JOIN old_ ON old_.ObjectIntId_Analyzer   = new_.ObjectIntId_Analyzer
                          AND old_.ObjectId_analyzer  = new_.ObjectId_analyzer

            LEFT JOIN Object ON Object.Id = COALESCE (new_.ObjectId_analyzer, old_.ObjectId_analyzer) -- Container.ObjectId
            LEFT JOIN Object AS Object_2 ON Object_2.Id = COALESCE (new_.ObjectIntId_Analyzer, old_.ObjectIntId_Analyzer)

       WHERE COALESCE (new_.Amount, 0) <> COALESCE  (old_.Amount, 0)
       ORDER BY COALESCE (new_.ObjectId_analyzer, old_.ObjectId_analyzer)
              , Object_2.ValueData
              , ABS (COALESCE (new_.Amount , old_.Amount)) desc
