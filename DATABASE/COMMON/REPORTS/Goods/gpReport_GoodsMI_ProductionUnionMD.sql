-- Function: gpReport_GoodsMI_ProductionUnionMD ()

DROP FUNCTION IF EXISTS gpReport_GoodsMI_ProductionUnionMD (TDateTime, TDateTime,  Boolean, Boolean, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_GoodsMI_ProductionUnionMD (
    IN inStartDate          TDateTime ,
    IN inEndDate            TDateTime ,
    IN inGroupMovement      Boolean   ,
    IN inGroupPartion       Boolean   ,
    IN inGoodsGroupId       Integer   ,
    IN inGoodsId            Integer   ,
    IN inChildGoodsGroupId  Integer   ,
    IN inChildGoodsId       Integer   ,
    IN inFromId             Integer   ,    -- от кого
    IN inToId               Integer   ,    -- кому
    IN inSession            TVarChar       -- сессия пользователя
)
RETURNS SETOF refcursor
/*
RETURNS TABLE (InvNumber TVarChar, OperDate TDateTime
             , PartionGoods  TVarChar, GoodsGroupName TVarChar, GoodsCode Integer, GoodsName TVarChar
             , Amount TFloat, HeadCount TFloat, Summ TFloat
             , ChildPartionGoods TVarChar, ChildGoodsGroupName TVarChar, ChildGoodsCode Integer,  ChildGoodsName TVarChar
             , ChildAmount TFloat, ChildSumm TFloat
             , ChildPrice TFloat
             )
*/
AS
$BODY$
    DECLARE vbDescId Integer;
    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;
BEGIN

    -- Ограничения по товару
    CREATE TEMP TABLE _tmpGoods (GoodsId Integer) ON COMMIT DROP;
    CREATE TEMP TABLE _tmpChildGoods (ChildGoodsId Integer) ON COMMIT DROP;
    CREATE TEMP TABLE _tmpFromGroup (FromId Integer) ON COMMIT DROP;
    CREATE TEMP TABLE _tmpToGroup (ToId  Integer) ON COMMIT DROP;

    IF inGoodsGroupId <> 0
    THEN
        INSERT INTO _tmpGoods (GoodsId)
          SELECT GoodsId FROM  lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfObject_Goods_byGoodsGroup;
    ELSE IF inGoodsId <> 0
         THEN
             INSERT INTO _tmpGoods (GoodsId)
              SELECT inGoodsId;
         ELSE
             INSERT INTO _tmpGoods (GoodsId)
               SELECT Object.Id FROM Object WHERE DescId = zc_Object_Goods();
         END IF;
    END IF;

    IF inChildGoodsGroupId <> 0
    THEN
        INSERT INTO _tmpChildGoods (ChildGoodsId)
          SELECT GoodsId FROM  lfSelect_Object_Goods_byGoodsGroup (inChildGoodsGroupId) AS lfObject_Goods_byGoodsGroup;
    ELSE IF inChildGoodsId <> 0
         THEN
             INSERT INTO _tmpChildGoods (ChildGoodsId)
              SELECT inChildGoodsId;
         ELSE
             INSERT INTO _tmpChildGoods (ChildGoodsId)
               SELECT Object.Id FROM Object WHERE DescId = zc_Object_Goods();
         END IF;
    END IF;


    -- ограничения по ОТ КОГО
    IF inFromId <> 0
    THEN
        INSERT INTO _tmpFromGroup (FromId)
           SELECT UnitId FROM lfSelect_Object_Unit_byGroup (inFromId) AS lfSelect_Object_Unit_byGroup;
    ELSE
         INSERT INTO _tmpFromGroup (FromId)
          SELECT Id FROM Object_Unit_View;  --SELECT Id FROM Object WHERE DescId = zc_Object_Unit();
    END IF;

    -- ограничения по КОМУ
    IF inToId <> 0
    THEN
        INSERT INTO _tmpToGroup (ToId)
           SELECT UnitId FROM lfSelect_Object_Unit_byGroup (inToId) AS lfSelect_Object_Unit_byGroup;
    ELSE
        INSERT INTO _tmpToGroup (ToId)
          SELECT Id FROM Object_Unit_View ;   --SELECT Id FROM Object WHERE DescId = zc_Object_Unit();
    END IF;


    -- Результат
--    RETURN QUERY
     OPEN Cursor1 FOR

    -- ограничиваем по виду документа  , по от кого / кому
      WITH tmpMovement AS
                        (SELECT Movement.Id        AS MovementId
                              , Movement.InvNumber AS InvNumber
                              , Movement.OperDate  AS OperDate
                         FROM Movement
                              LEFT JOIN MovementLinkObject AS MovementLinkObject_From
				                           ON MovementLinkObject_From.MovementId = Movement.Id
						          AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
			      JOIN _tmpFromGroup on _tmpFromGroup.FromId = MovementLinkObject_From.ObjectId

  			      LEFT JOIN MovementLinkObject AS MovementLinkObject_To
				 		           ON MovementLinkObject_To.MovementId = Movement.Id
							  AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
			      JOIN _tmpToGroup on _tmpToGroup.ToId = MovementLinkObject_To.ObjectId


                         WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                           AND Movement.DescId  = zc_Movement_ProductionUnion() -- 9 --and   Movement.Id  = 386839
                            --and Movement.Id =  385759
                         GROUP BY Movement.Id
                                , Movement.InvNumber
                                , Movement.OperDate
                         )

  , tmpMI_Container AS (SELECT tmpMovement.MovementId AS MovementId
                             , tmpMovement.InvNumber
                             , tmpMovement.OperDate
                             --, tmpMovement.PartionGoods
                             , MovementItem.ObjectId AS GoodsId
                             , (MIContainer.Amount)    AS Amount
                             , MIFloat_HeadCount.ValueData AS HeadCount
                             , MovementItem.DescId         as MovementItemDescId
                             , MIContainer.DescId          as MIContainerDescId
                             , Container.ObjectId as  ContainerObjectId
                             , MovementItem.Id      as MovementItemId
                             , MovementItem.ParentId as MovementItemParentId
                             , COALESCE (ContainerLO_PartionGoods.ObjectId, 0) AS PartionGoodsId
                        FROM tmpMovement
                            JOIN MovementItemContainer AS MIContainer
                                                       ON MIContainer.MovementId = tmpMovement.MovementId
                            JOIN Container ON Container.Id = MIContainer.ContainerId

                            JOIN MovementItem ON MovementItem.Id = MIContainer.MovementItemId

	                    LEFT JOIN MovementItemFloat AS MIFloat_HeadCount
                                                        ON MIFloat_HeadCount.MovementItemId = MovementItem.Id
                                                       AND MIContainer.DescId =  zc_MIContainer_Count()
                                                       AND MIFloat_HeadCount.DescId = zc_MIFloat_Count()


                            LEFT JOIN ContainerLinkObject AS ContainerLO_PartionGoods
                                                          ON ContainerLO_PartionGoods.ContainerId = Container.Id
                                                         AND ContainerLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()

                        /*GROUP BY MovementItem.ObjectId
                               , COALESCE (Container.ObjectId, 0)
                               , MIFloat_HeadCount.ValueData
                               , tmpMovement.MovementId
                               , tmpMovement.InvNumber
                               , tmpMovement.OperDate
                               , tmpMovement.PartionGoods
                               , MovementItem.DescId ,MIContainer.DescId
                               , Container.ObjectId
                         */
                           )


     , tmpMI_Count AS (SELECT tmpMI_Container.MovementId
                             , tmpMI_Container.InvNumber
                             , tmpMI_Container.OperDate
                             , tmpMI_Container.PartionGoodsId
                             , tmpMI_Container.GoodsId
                             , 0 AS Summ
                             , SUM (tmpMI_Container.Amount) AS Amount
                             , tmpMI_Container.HeadCount
                             , tmpMI_Container.MovementItemDescId  as DescId
                             , tmpMI_Container.MovementItemId
                             , tmpMI_Container.MovementItemParentId

                        FROM tmpMI_Container

                        Where tmpMI_Container.MIContainerDescId = zc_MIContainer_Count()
                        GROUP BY tmpMI_Container.MovementId
                             , tmpMI_Container.InvNumber
                             , tmpMI_Container.OperDate
                             , tmpMI_Container.PartionGoodsId
                             , tmpMI_Container.GoodsId
                             , tmpMI_Container.HeadCount
                             , tmpMI_Container.MovementItemDescId
                             , tmpMI_Container.MovementItemId
                             , tmpMI_Container.MovementItemParentId
                        )

        , tmpMI_sum AS (SELECT tmpMI_Container.MovementId
                             , tmpMI_Container.InvNumber
                             , tmpMI_Container.OperDate
                             , tmpMI_Container.PartionGoodsId
                             , tmpMI_Container.GoodsId
                             , SUM (tmpMI_Container.Amount)  AS Summ
                             , 0 AS Amount
                             , tmpMI_Container.HeadCount
                             , tmpMI_Container.MovementItemDescId as DescId
                             , tmpMI_Container.MovementItemId
                             , tmpMI_Container.MovementItemParentId

                        FROM tmpMI_Container
                          -- JOIN (SELECT AccountID FROM Object_Account_View WHERE AccountGroupId = zc_Enum_AccountGroup_20000()
                          --       ) AS tmpAccount on tmpAccount.AccountID = tmpMI_Container.ContainerObjectId
                        Where tmpMI_Container.MIContainerDescId = zc_MIContainer_Summ()
                        GROUP BY tmpMI_Container.MovementId
                             , tmpMI_Container.InvNumber
                             , tmpMI_Container.OperDate
                             , tmpMI_Container.GoodsId
                             , tmpMI_Container.HeadCount
                             , tmpMI_Container.MovementItemDescId
                             , tmpMI_Container.MovementItemId
                             , tmpMI_Container.MovementItemParentId
                             , tmpMI_Container.PartionGoodsId
                           )


      SELECT CAST (tmpOperationGroup.InvNumber AS TVarChar)     AS InvNumber
           , CAST (tmpOperationGroup.OperDate AS TDateTime)     AS OperDate
           , CAST (Object_PartionGoods.ValueData AS TVarChar)   AS PartionGoods
           , Object_GoodsGroup.ValueData                        AS GoodsGroupName
           , Object_Goods.ObjectCode                            AS GoodsCode
           , Object_Goods.ValueData                             AS GoodsName
           , tmpOperationGroup.Amount :: TFloat                 AS Amount
           , tmpOperationGroup.HeadCount :: TFloat              AS HeadCount
           , tmpOperationGroup.Summ :: TFloat                   AS Summ
           , tmpOperationGroup.MasterId                         AS MasterId

      FROM (
            SELECT CASE WHEN inGroupMovement = True THEN tmpMI.InvNumber ELSE '' END                        AS InvNumber
                 , CASE WHEN inGroupMovement = True THEN tmpMI.OperDate ELSE CAST (Null AS TDateTime) END   AS OperDate
                 , CASE WHEN inGroupPartion = True THEN tmpMI.PartionGoodsId ELSE 0 END                     AS PartionGoodsId
                 , tmpMI.MasterId                                                                           AS MasterId
                 , tmpMI.GoodsId                                                                            AS GoodsId
                 , ABS (SUM(tmpMI.Summ))                                                                    AS Summ
                 , ABS (SUM(tmpMI.Amount))                                                                  AS Amount
                 , ABS (SUM(tmpMI.HeadCount))                                                               AS HeadCount

            FROM (SELECT  tmpMIMaster_Sum.InvNumber
                        , tmpMIMaster_Sum.OperDate
                        , tmpMIMaster_Sum.PartionGoodsId
                        , tmpMIMaster_Sum.GoodsId
                        , tmpMIMaster_Sum.Summ
                        , tmpMIMaster_Sum.Amount
                        , tmpMIMaster_Sum.HeadCount
                        , tmpMIMaster_Sum.MovementItemId AS MasterId
                  FROM tmpMI_sum AS tmpMIMaster_Sum
                  JOIN _tmpGoods ON _tmpGoods.GoodsId = tmpMIMaster_Sum.GoodsId
                  WHERE tmpMIMaster_Sum.DescId = zc_MI_Master()
                  UNION
                  SELECT  tmpMIMaster.InvNumber
                        , tmpMIMaster.OperDate
                        , tmpMIMaster.PartionGoodsId
                        , tmpMIMaster.GoodsId as GoodsId
                        , tmpMIMaster.Summ
                        , tmpMIMaster.Amount
                        , tmpMIMaster.HeadCount
                        , tmpMIMaster.MovementItemId AS MasterId
                  FROM tmpMI_Count AS tmpMIMaster
                  JOIN _tmpGoods ON _tmpGoods.GoodsId = tmpMIMaster.GoodsId
                  WHERE tmpMIMaster.DescId = zc_MI_Master()
--                   AND COALESCE (tmpMIChild.Amount, -1 ) <> 0

                ) AS tmpMI
	    GROUP BY CASE when inGroupMovement = True THEN tmpMI.InvNumber ELSE '' END
                   , CASE when inGroupMovement = True THEN tmpMI.OperDate ELSE CAST (Null AS TDateTime) END
                   , CASE when inGroupPartion = True THEN tmpMI.PartionGoodsId ELSE 0 END
                   , tmpMI.MasterId
                   , tmpMI.GoodsId
            ) AS tmpOperationGroup

             LEFT JOIN Object AS Object_Goods on Object_Goods.Id = tmpOperationGroup.GoodsId

             LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                  ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
             LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

             LEFT JOIN Object AS Object_PartionGoods
                              ON Object_PartionGoods.Id = tmpOperationGroup.PartionGoodsId
                             AND inGroupPartion = True

       ORDER BY
               tmpOperationGroup.MasterId
             , tmpOperationGroup.InvNumber
             , tmpOperationGroup.OperDate
             , Object_PartionGoods.ValueData
             , Object_GoodsGroup.ValueData
             , Object_Goods.ObjectCode
             , Object_Goods.ValueData

       ;
     RETURN NEXT Cursor1;

    -- Результат 2

     OPEN Cursor2 FOR

    -- ограничиваем по виду документа  , по от кого / кому
      WITH tmpMovement AS
                        (SELECT Movement.Id        AS MovementId
                              , Movement.InvNumber AS InvNumber
                              , Movement.OperDate  AS OperDate
                         FROM Movement
                              LEFT JOIN MovementLinkObject AS MovementLinkObject_From
				                           ON MovementLinkObject_From.MovementId = Movement.Id
						          AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
			      JOIN _tmpFromGroup on _tmpFromGroup.FromId = MovementLinkObject_From.ObjectId

  			      LEFT JOIN MovementLinkObject AS MovementLinkObject_To
				 		           ON MovementLinkObject_To.MovementId = Movement.Id
							  AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
			      JOIN _tmpToGroup on _tmpToGroup.ToId = MovementLinkObject_To.ObjectId


                         WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                           AND Movement.DescId  = zc_Movement_ProductionUnion() -- 9 --and   Movement.Id  = 386839
                            --and Movement.Id =  385759
                         GROUP BY Movement.Id
                                , Movement.InvNumber
                                , Movement.OperDate
                         )

  , tmpMI_Container AS (SELECT tmpMovement.MovementId       AS MovementId
                             , tmpMovement.InvNumber        AS InvNumber
                             , tmpMovement.OperDate         AS OperDate
                             --, tmpMovement.PartionGoods
                             , MovementItem.ObjectId        AS GoodsId
                             , (MIContainer.Amount)         AS Amount
                             , MIFloat_HeadCount.ValueData  AS HeadCount
                             , MovementItem.DescId          AS MovementItemDescId
                             , MIContainer.DescId           AS MIContainerDescId
                             , Container.ObjectId           AS ContainerObjectId
                             , MovementItem.Id              AS MovementItemId
                             , MovementItem.ParentId        AS MovementItemParentId
                             , COALESCE (ContainerLO_PartionGoods.ObjectId, 0) AS PartionGoodsId
                        FROM tmpMovement
                            JOIN MovementItemContainer AS MIContainer
                                                       ON MIContainer.MovementId = tmpMovement.MovementId
                            JOIN Container ON Container.Id = MIContainer.ContainerId

                            JOIN MovementItem ON MovementItem.Id = MIContainer.MovementItemId

	                    LEFT JOIN MovementItemFloat AS MIFloat_HeadCount
                                                        ON MIFloat_HeadCount.MovementItemId = MovementItem.Id
                                                       AND MIContainer.DescId =  zc_MIContainer_Count()
                                                       AND MIFloat_HeadCount.DescId = zc_MIFloat_Count()


                            LEFT JOIN ContainerLinkObject AS ContainerLO_PartionGoods
                                                          ON ContainerLO_PartionGoods.ContainerId = Container.Id
                                                         AND ContainerLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()

                        /*GROUP BY MovementItem.ObjectId
                               , COALESCE (Container.ObjectId, 0)
                               , MIFloat_HeadCount.ValueData
                               , tmpMovement.MovementId
                               , tmpMovement.InvNumber
                               , tmpMovement.OperDate
                               , tmpMovement.PartionGoods
                               , MovementItem.DescId ,MIContainer.DescId
                               , Container.ObjectId
                         */
                           )


     , tmpMI_Count AS (SELECT tmpMI_Container.MovementId
                             , tmpMI_Container.InvNumber
                             , tmpMI_Container.OperDate
                             , tmpMI_Container.PartionGoodsId
                             , tmpMI_Container.GoodsId
                             , 0                                    AS Summ
                             , SUM (tmpMI_Container.Amount)         AS Amount
                             , tmpMI_Container.HeadCount
                             , tmpMI_Container.MovementItemDescId   AS DescId
                             , tmpMI_Container.MovementItemId
                             , tmpMI_Container.MovementItemParentId

                        FROM tmpMI_Container

                        WHERE tmpMI_Container.MIContainerDescId = zc_MIContainer_Count()
                        GROUP BY tmpMI_Container.MovementId
                             , tmpMI_Container.InvNumber
                             , tmpMI_Container.OperDate
                             , tmpMI_Container.PartionGoodsId
                             , tmpMI_Container.GoodsId
                             , tmpMI_Container.HeadCount
                             , tmpMI_Container.MovementItemDescId
                             , tmpMI_Container.MovementItemId
                             , tmpMI_Container.MovementItemParentId
                        )

        , tmpMI_sum AS (SELECT tmpMI_Container.MovementId
                             , tmpMI_Container.InvNumber
                             , tmpMI_Container.OperDate
                             , tmpMI_Container.PartionGoodsId
                             , tmpMI_Container.GoodsId
                             , SUM (tmpMI_Container.Amount)         AS Summ
                             , 0                                    AS Amount
                             , tmpMI_Container.HeadCount
                             , tmpMI_Container.MovementItemDescId   AS DescId
                             , tmpMI_Container.MovementItemId
                             , tmpMI_Container.MovementItemParentId

                        FROM tmpMI_Container
                          -- JOIN (SELECT AccountID FROM Object_Account_View WHERE AccountGroupId = zc_Enum_AccountGroup_20000()
                          --       ) AS tmpAccount on tmpAccount.AccountID = tmpMI_Container.ContainerObjectId
                        WHERE tmpMI_Container.MIContainerDescId = zc_MIContainer_Summ()
                        GROUP BY tmpMI_Container.MovementId
                             , tmpMI_Container.InvNumber
                             , tmpMI_Container.OperDate
                             , tmpMI_Container.GoodsId
                             , tmpMI_Container.HeadCount
                             , tmpMI_Container.MovementItemDescId
                             , tmpMI_Container.MovementItemId
                             , tmpMI_Container.MovementItemParentId
                             , tmpMI_Container.PartionGoodsId
                           )


      SELECT tmpOperationGroup.MasterId                             AS MasterId
           , CAST (Object_PartionGoodsChild.ValueData AS TVarChar)  AS ChildPartionGoods
           , Object_GoodsGroupChild.ValueData                       AS ChildGoodsGroupName
           , Object_GoodsChild.ObjectCode                           AS ChildGoodsCode
           , Object_GoodsChild.ValueData                            AS ChildGoodsName
           , tmpOperationGroup.ChildAmount  :: TFloat               AS ChildAmount
           , tmpOperationGroup.ChildSumm :: TFloat                  AS ChildSumm
           , CASE WHEN tmpOperationGroup.ChildAmount <> 0 THEN COALESCE ((tmpOperationGroup.ChildSumm / tmpOperationGroup.ChildAmount) ,0) ELSE 0 END  :: TFloat  AS ChildPrice

      FROM (
            SELECT tmpMI.MasterId               AS MasterId
                 , tmpMI.ChildGoodsId           AS ChildGoodsId
                 , CASE when inGroupPartion = True THEN tmpMI.ChildPartionGoodsId ELSE 0 END AS ChildPartionGoodsId
                 , ABS (SUM(tmpMI.ChildSumm))   AS ChildSumm
                 , ABS (SUM(tmpMI.ChildAmount)) AS ChildAmount

            FROM (SELECT  tmpMIChild_Sum.MovementItemParentId       AS MasterId
                        , tmpMIChild_Sum.PartionGoodsId             AS ChildPartionGoodsId
                        , tmpMIChild_Sum.GoodsId                    AS ChildGoodsId
                        , tmpMIChild_Sum.Summ                       AS ChildSumm
                        , tmpMIChild_Sum.Amount                     AS ChildAmount
                  FROM tmpMI_sum AS tmpMIMaster_Sum
                       JOIN tmpMI_sum AS tmpMIChild_Sum ON tmpMIChild_Sum.MovementItemParentId = tmpMIMaster_Sum.MovementItemId
                                                       AND tmpMIChild_Sum.DescId = zc_MI_Child()
                       JOIN _tmpGoods ON _tmpGoods.GoodsId = tmpMIMaster_Sum.GoodsId
                       JOIN _tmpChildGoods ON _tmpChildGoods.ChildGoodsId = tmpMIChild_Sum.GoodsId
		                      --
                  WHERE tmpMIMaster_Sum.DescId = zc_MI_Master()

                  UNION

                  SELECT  tmpMIChild.MovementItemParentId           AS MasterId
                        , tmpMIChild.PartionGoodsId                 AS ChildPartionGoodsId
                        , tmpMIChild.GoodsId                        AS ChildGoodsId
                        , tmpMIChild.Summ                           AS ChildSumm
                        , tmpMIChild.Amount                         AS ChildAmount
                  FROM tmpMI_Count AS tmpMIMaster
                         LEFT JOIN tmpMI_Count AS tmpMIChild
                                ON tmpMIChild.MovementItemParentId = tmpMIMaster.MovementItemId
                               AND tmpMIChild.DescId = zc_MI_Child()
                         JOIN _tmpGoods ON _tmpGoods.GoodsId = tmpMIMaster.GoodsId
                         JOIN _tmpChildGoods ON _tmpChildGoods.ChildGoodsId = tmpMIChild.GoodsId

                  WHERE tmpMIMaster.DescId = zc_MI_Master()
                    AND COALESCE (tmpMIChild.Amount, -1 ) <> 0

                 ) AS tmpMI

	           GROUP BY   tmpMI.MasterId
                        , CASE WHEN inGroupPartion = True THEN tmpMI.ChildPartionGoodsId ELSE 0 END
                        , tmpMI.ChildGoodsId
            ) AS tmpOperationGroup


             LEFT JOIN Object AS Object_GoodsChild on Object_GoodsChild.Id = tmpOperationGroup.ChildGoodsId

             LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupChild
                                  ON ObjectLink_Goods_GoodsGroupChild.ObjectId = Object_GoodsChild.Id
                                 AND ObjectLink_Goods_GoodsGroupChild.DescId = zc_ObjectLink_Goods_GoodsGroup()
             LEFT JOIN Object AS Object_GoodsGroupChild ON Object_GoodsGroupChild.Id = ObjectLink_Goods_GoodsGroupChild.ChildObjectId

             LEFT JOIN Object AS Object_PartionGoodsChild
                              ON Object_PartionGoodsChild.Id = tmpOperationGroup.ChildPartionGoodsId
                             AND inGroupPartion = True

       ORDER BY tmpOperationGroup.MasterId,
               Object_PartionGoodsChild.ValueData
       ;
     RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpReport_GoodsMI_ProductionUnionMD (TDateTime, TDateTime, Integer, Boolean, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 02.12.14                                                       *



*/

-- тест
/*
BEGIN;
 select * from gpReport_GoodsMI_ProductionUnionMD(inStartDate := ('03.06.2014')::TDateTime , inEndDate := ('03.06.2014')::TDateTime , inGroupMovement := 'True' , inGroupPartion := 'True' , inGoodsGroupId := 0 , inGoodsId := 0 , inChildGoodsGroupId := 0 , inChildGoodsId :=0 , inFromId := 0 , inToId := 0 ,  inSession := '5');
COMMIT;
*/
