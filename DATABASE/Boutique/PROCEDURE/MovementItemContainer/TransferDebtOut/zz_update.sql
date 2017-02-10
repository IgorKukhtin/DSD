update MovementItemContainer set AccountId                   = aaa.AccountId
                               , ObjectId_Analyzer           = aaa.ObjectId_Analyzer
                               , WhereObjectId_Analyzer      = aaa.WhereObjectId_Analyzer
                               , ObjectIntId_Analyzer        = aaa.ObjectIntId_Analyzer
                               , ObjectExtId_Analyzer        = aaa.ObjectExtId_Analyzer
                               , ContainerIntId_Analyzer     = case when aaa.ContainerIntId_Analyzer <> 0  THEN aaa.ContainerIntId_Analyzer ELSE null end

-- select  *
from (
select 
       Container.ObjectId as AccountId
      , MovementItem.ObjectId as ObjectId_Analyzer

      , CASE WHEN CLO_Goods.ObjectId > 0
                  then CASE WHEN  MovementItemContainer.isActive = FALSE
                                then CASE WHEN MovementLinkObject_Partner.ObjectId <> 0 THEN MovementLinkObject_Partner.ObjectId ELSE MovementLinkObject_To.ObjectId END -- Êîìó
                            else CASE WHEN MovementLinkObject_PartnerFrom.ObjectId <> 0 THEN MovementLinkObject_PartnerFrom.ObjectId ELSE MovementLinkObject_From.ObjectId END -- 
                       end
                  else CASE WHEN  MovementItemContainer.isActive = FALSE
                                then CASE WHEN MovementLinkObject_PartnerFrom.ObjectId <> 0 THEN MovementLinkObject_PartnerFrom.ObjectId ELSE MovementLinkObject_From.ObjectId END -- 
                            else CASE WHEN MovementLinkObject_Partner.ObjectId <> 0 THEN MovementLinkObject_Partner.ObjectId ELSE MovementLinkObject_To.ObjectId END -- Êîìó
                       end
        end AS WhereObjectId_Analyzer

      ,  MILinkObject_GoodsKind.ObjectId as ObjectIntId_Analyzer

      , CASE WHEN CLO_Goods.ObjectId > 0
                  then CASE WHEN  MovementItemContainer.isActive = FALSE
                                then CASE WHEN MovementLinkObject_PartnerFrom.ObjectId <> 0 THEN MovementLinkObject_PartnerFrom.ObjectId ELSE MovementLinkObject_From.ObjectId END -- 
                            else CASE WHEN MovementLinkObject_Partner.ObjectId <> 0 THEN MovementLinkObject_Partner.ObjectId ELSE MovementLinkObject_To.ObjectId END -- Êîìó
                       end
                  else CASE WHEN  MovementItemContainer.isActive = FALSE
                                then CASE WHEN MovementLinkObject_Partner.ObjectId <> 0 THEN MovementLinkObject_Partner.ObjectId ELSE MovementLinkObject_To.ObjectId END -- Êîìó
                            else CASE WHEN MovementLinkObject_PartnerFrom.ObjectId <> 0 THEN MovementLinkObject_PartnerFrom.ObjectId ELSE MovementLinkObject_From.ObjectId END -- 
                       end
        end AS ObjectExtId_Analyzer

      , coalesce (CLO_Partner.ObjectId, CLO_Juridical.ObjectId) as ObjectExtId_Analyzer2

      , CASE WHEN CLO_Goods.ObjectId > 0
                  then 0
             else MovementItemContainer2.ContainerId
        end AS ContainerIntId_Analyzer

, CASE WHEN  MovementItemContainer.isActive = FALSE
                                then MovementLinkObject_To.ObjectId
                            else MovementLinkObject_From.ObjectId
                       end as x1
, CLO_Juridical.ObjectId as x2

, MovementItemContainer.isActive
, MovementItemContainer.MovementItemId
, MovementItemContainer.Id As MIC_Id
, MovementItemContainer.MovementId

from MovementItemContainer
     inner join MovementItem ON MovementItem.Id = MovementItemContainer.MovementItemId
     inner join Container ON Container.Id = MovementItemContainer.ContainerId
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                    ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                   LEFT JOIN ContainerLinkObject AS CLO_Goods
                                                    ON CLO_Goods.ContainerId = MovementItemContainer.ContainerId
                                                   AND CLO_Goods.DescId = zc_ContainerLinkObject_Goods()

          LEFT JOIN (SELECT distinct
                         MovementItemContainer2.ContainerId
                       , not MovementItemContainer2.isActive as isActive
                       , MovementItemContainer2.MovementItemId
                     from MovementItemContainer AS MovementItemContainer2
                   LEFT JOIN ContainerLinkObject AS CLO_Goods
                                                    ON CLO_Goods.ContainerId = MovementItemContainer2.ContainerId
                                                   AND CLO_Goods.DescId = zc_ContainerLinkObject_Goods()
                     where MovementItemContainer2.MovementDescId in (zc_Movement_TransferDebtOut(), zc_Movement_TransferDebtIn())
                       and MovementItemContainer2.OperDate >= '01.01.2016' and MovementItemContainer2.OperDate < '01.03.2016'
                       and CLO_Goods.ContainerId is null
                    ) as MovementItemContainer2 on MovementItemContainer2.MovementItemId = MovementItemContainer.MovementItemId
                                               AND MovementItemContainer2.isActive = MovementItemContainer.isActive

         left join Container as Container2 ON Container2.Id = MovementItemContainer2.ContainerId
                   LEFT JOIN ContainerLinkObject AS CLO_Partner
                                                    ON CLO_Partner.ContainerId = MovementItemContainer2.ContainerId
                                                   AND CLO_Partner.DescId = zc_ContainerLinkObject_Partner()
                   LEFT JOIN ContainerLinkObject AS CLO_Juridical
                                                    ON CLO_Juridical.ContainerId = MovementItemContainer2.ContainerId
                                                   AND CLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()

          LEFT JOIN MovementLinkObject AS MovementLinkObject_PartnerFrom
                                       ON MovementLinkObject_PartnerFrom.MovementId = MovementItemContainer.MovementId
                                      AND MovementLinkObject_PartnerFrom.DescId = zc_MovementLinkObject_PartnerFrom()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                       ON MovementLinkObject_Partner.MovementId = MovementItemContainer.MovementId
                                      AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = MovementItemContainer.MovementId
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = MovementItemContainer.MovementId
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

/*          LEFT JOIN ObjectLink AS ObjectLink_Jur
                                  ON ObjectLink_Jur.ObjectId = MovementLinkObject_Partner.ObjectId
                                  AND ObjectLink_Jur.DescId = zc_ObjectLink_Partner_Juridical()*/

where MovementItemContainer.MovementDescId in (zc_Movement_TransferDebtOut(), zc_Movement_TransferDebtIn())
and MovementItemContainer.OperDate >= '01.01.2016' and MovementItemContainer.OperDate < '01.03.2016'
-- and MovementItemContainer.MovementId  in (3345178, 3353293 ) 

) as aaa
 where MovementItemContainer.Id = aaa.MIC_Id
 and MovementItemContainer.MovementId = aaa.MovementId


-- join MovementItemContainer on MovementItemContainer.Id = aaa.MIC_Id
   --                        and MovementItemContainer.MovementId = aaa.MovementId

 and 
-- where 
(coalesce (MovementItemContainer.AccountId, 0) <> aaa.AccountId
   or coalesce (MovementItemContainer.ObjectId_Analyzer, 0) <> aaa.ObjectId_Analyzer
   or coalesce (MovementItemContainer.WhereObjectId_Analyzer, 0) <> aaa.WhereObjectId_Analyzer
   or coalesce (MovementItemContainer.ObjectIntId_Analyzer, 0) <> aaa.ObjectIntId_Analyzer
or coalesce (MovementItemContainer.ObjectExtId_Analyzer, 0) <> aaa.ObjectExtId_Analyzer
or coalesce (MovementItemContainer.ContainerIntId_Analyzer, 0) <> aaa.ContainerIntId_Analyzer
)
-- select * from gpReComplete_Movement_TransferDebtOut(inMovementId := 3345178 ,  inSession :=zc_Enum_Process_Auto_PrimeCost() :: TvarChar);
-- select * from gpReComplete_Movement_TransferDebtIn(inMovementId := 3353293,  inSession :=zc_Enum_Process_Auto_PrimeCost() :: TvarChar);
