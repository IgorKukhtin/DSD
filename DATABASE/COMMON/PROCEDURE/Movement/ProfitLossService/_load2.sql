SELECT lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ContractMaster(), MovementItem.Id, report.ContractId_master)
     , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Contractchild(), MovementItem.Id, report.ContractId_child)
     , lpInsertUpdate_MovementItemFloat (zc_MIFloat_BonusValue(), MovementItem.Id, report.Value)
     , CASE WHEN COALESCE (MIString_Comment.ValueData, '') = '' THEN lpInsertUpdate_MovementItemString (zc_MIString_Comment(), MovementItem.Id, report.Comment) ELSE null END
, Movement.*
-- , report.*
FROM gpSelect_Movement_ProfitLossService (inStartDate:= '01.07.2014', inEndDate:= '31.07.2014', inIsErased:=false , inSession:= zfCalc_UserAdmin()) as Movement
inner join MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()
          LEFT JOIN MovementItemLinkObject AS MILinkObject_ContractChild
                                           ON MILinkObject_ContractChild.MovementItemId = MovementItem.Id
                                          AND MILinkObject_ContractChild.DescId = zc_MILinkObject_ContractChild()
          LEFT JOIN MovementItemString AS MIString_Comment
                                       ON MIString_Comment.MovementItemId = MovementItem.Id
                                      AND MIString_Comment.DescId = zc_MIString_Comment()
inner join gpReport_CheckBonus (inStartDate:= '01.07.2014', inEndDate:= '31.07.2014', inSession:= zfCalc_UserAdmin()) as report
on report.InvNumber_find = Movement.ContractInvNumber
and report.ConditionKindName = Movement.ContractConditionKindName and report.BonusKindId = Movement.BonusKindId
and report.Sum_Bonus between  Movement.AmountOut - 0 and Movement.AmountOut + 0
and report.Sum_Bonus <> 0 and Movement.AmountOut <> 0
where Movement.StatusCode = 2 -- "Проведен"
and Movement.isLoad = true
-- and MILinkObject_ContractChild.ObjectId is null

union 

SELECT lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ContractMaster(), MovementItem.Id, report.ContractId_master)
     , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Contractchild(), MovementItem.Id, report.ContractId_child)
     , lpInsertUpdate_MovementItemFloat (zc_MIFloat_BonusValue(), MovementItem.Id, report.Value)
     , CASE WHEN COALESCE (MIString_Comment.ValueData, '') = '' THEN lpInsertUpdate_MovementItemString (zc_MIString_Comment(), MovementItem.Id, report.Comment) ELSE null END
, Movement.*
-- , report.*
FROM gpSelect_Movement_ProfitLossService (inStartDate:= '01.06.2014', inEndDate:= '30.06.2014', inIsErased:=false , inSession:= zfCalc_UserAdmin()) as Movement
inner join MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()
          LEFT JOIN MovementItemLinkObject AS MILinkObject_ContractChild
                                           ON MILinkObject_ContractChild.MovementItemId = MovementItem.Id
                                          AND MILinkObject_ContractChild.DescId = zc_MILinkObject_ContractChild()
          LEFT JOIN MovementItemString AS MIString_Comment
                                       ON MIString_Comment.MovementItemId = MovementItem.Id
                                      AND MIString_Comment.DescId = zc_MIString_Comment()
inner join gpReport_CheckBonus (inStartDate:= '01.06.2014', inEndDate:= '30.06.2014', inSession:= zfCalc_UserAdmin()) as report
on report.InvNumber_find = Movement.ContractInvNumber
and report.ConditionKindName = Movement.ContractConditionKindName and report.BonusKindId = Movement.BonusKindId
and report.Sum_Bonus between  Movement.AmountOut - 0 and Movement.AmountOut + 0
and report.Sum_Bonus <> 0 and Movement.AmountOut <> 0
where Movement.StatusCode = 2 -- "Проведен"
and Movement.isLoad = true
-- and MILinkObject_ContractChild.ObjectId is null

union

SELECT lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ContractMaster(), MovementItem.Id, report.ContractId_master)
     , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Contractchild(), MovementItem.Id, report.ContractId_child)
     , lpInsertUpdate_MovementItemFloat (zc_MIFloat_BonusValue(), MovementItem.Id, report.Value)
     , CASE WHEN COALESCE (MIString_Comment.ValueData, '') = '' THEN lpInsertUpdate_MovementItemString (zc_MIString_Comment(), MovementItem.Id, report.Comment) ELSE null END
, Movement.*
-- , report.*
FROM gpSelect_Movement_ProfitLossService (inStartDate:= '01.08.2014', inEndDate:= '31.08.2014', inIsErased:=false , inSession:= zfCalc_UserAdmin()) as Movement
inner join MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()
          LEFT JOIN MovementItemLinkObject AS MILinkObject_ContractChild
                                           ON MILinkObject_ContractChild.MovementItemId = MovementItem.Id
                                          AND MILinkObject_ContractChild.DescId = zc_MILinkObject_ContractChild()
          LEFT JOIN MovementItemString AS MIString_Comment
                                       ON MIString_Comment.MovementItemId = MovementItem.Id
                                      AND MIString_Comment.DescId = zc_MIString_Comment()
inner join gpReport_CheckBonus (inStartDate:= '01.08.2014', inEndDate:= '31.08.2014', inSession:= zfCalc_UserAdmin()) as report
on report.InvNumber_find = Movement.ContractInvNumber
and report.ConditionKindName = Movement.ContractConditionKindName and report.BonusKindId = Movement.BonusKindId
and report.Sum_Bonus between  Movement.AmountOut - 0 and Movement.AmountOut + 0
and report.Sum_Bonus <> 0 and Movement.AmountOut <> 0
where Movement.StatusCode = 2 -- "Проведен"
and Movement.isLoad = true
-- and MILinkObject_ContractChild.ObjectId is null

union 

SELECT lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ContractMaster(), MovementItem.Id, report.ContractId_master)
     , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Contractchild(), MovementItem.Id, report.ContractId_child)
     , lpInsertUpdate_MovementItemFloat (zc_MIFloat_BonusValue(), MovementItem.Id, report.Value)
     , CASE WHEN COALESCE (MIString_Comment.ValueData, '') = '' THEN lpInsertUpdate_MovementItemString (zc_MIString_Comment(), MovementItem.Id, report.Comment) ELSE null END
, Movement.*
-- , report.*
FROM gpSelect_Movement_ProfitLossService (inStartDate:= '01.09.2014', inEndDate:= '30.09.2014', inIsErased:=false , inSession:= zfCalc_UserAdmin()) as Movement
inner join MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()
          LEFT JOIN MovementItemLinkObject AS MILinkObject_ContractChild
                                           ON MILinkObject_ContractChild.MovementItemId = MovementItem.Id
                                          AND MILinkObject_ContractChild.DescId = zc_MILinkObject_ContractChild()
          LEFT JOIN MovementItemString AS MIString_Comment
                                       ON MIString_Comment.MovementItemId = MovementItem.Id
                                      AND MIString_Comment.DescId = zc_MIString_Comment()
inner join gpReport_CheckBonus (inStartDate:= '01.09.2014', inEndDate:= '30.09.2014', inSession:= zfCalc_UserAdmin()) as report
on report.InvNumber_find = Movement.ContractInvNumber
and report.ConditionKindName = Movement.ContractConditionKindName and report.BonusKindId = Movement.BonusKindId
and report.Sum_Bonus between  Movement.AmountOut - 0 and Movement.AmountOut + 0
and report.Sum_Bonus <> 0 and Movement.AmountOut <> 0
where Movement.StatusCode = 2 -- "Проведен"
and Movement.isLoad = true
-- and MILinkObject_ContractChild.ObjectId is null
union

SELECT lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ContractMaster(), MovementItem.Id, report.ContractId_master)
     , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Contractchild(), MovementItem.Id, report.ContractId_child)
     , lpInsertUpdate_MovementItemFloat (zc_MIFloat_BonusValue(), MovementItem.Id, report.Value)
     , CASE WHEN COALESCE (MIString_Comment.ValueData, '') = '' THEN lpInsertUpdate_MovementItemString (zc_MIString_Comment(), MovementItem.Id, report.Comment) ELSE null END
, Movement.*
-- , report.*
FROM gpSelect_Movement_ProfitLossService (inStartDate:= '01.10.2014', inEndDate:= '31.10.2014', inIsErased:=false , inSession:= zfCalc_UserAdmin()) as Movement
inner join MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()
          LEFT JOIN MovementItemLinkObject AS MILinkObject_ContractChild
                                           ON MILinkObject_ContractChild.MovementItemId = MovementItem.Id
                                          AND MILinkObject_ContractChild.DescId = zc_MILinkObject_ContractChild()
          LEFT JOIN MovementItemString AS MIString_Comment
                                       ON MIString_Comment.MovementItemId = MovementItem.Id
                                      AND MIString_Comment.DescId = zc_MIString_Comment()
inner join gpReport_CheckBonus (inStartDate:= '01.10.2014', inEndDate:= '31.10.2014', inSession:= zfCalc_UserAdmin()) as report
on report.InvNumber_find = Movement.ContractInvNumber
and report.ConditionKindName = Movement.ContractConditionKindName and report.BonusKindId = Movement.BonusKindId
and report.Sum_Bonus between  Movement.AmountOut - 0 and Movement.AmountOut + 0
and report.Sum_Bonus <> 0 and Movement.AmountOut <> 0
where Movement.StatusCode = 2 -- "Проведен"
and Movement.isLoad = true
-- and MILinkObject_ContractChild.ObjectId is null

union 

SELECT lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ContractMaster(), MovementItem.Id, report.ContractId_master)
     , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Contractchild(), MovementItem.Id, report.ContractId_child)
     , lpInsertUpdate_MovementItemFloat (zc_MIFloat_BonusValue(), MovementItem.Id, report.Value)
     , CASE WHEN COALESCE (MIString_Comment.ValueData, '') = '' THEN lpInsertUpdate_MovementItemString (zc_MIString_Comment(), MovementItem.Id, report.Comment) ELSE null END
, Movement.*
-- , report.*
FROM gpSelect_Movement_ProfitLossService (inStartDate:= '01.11.2014', inEndDate:= '30.11.2014', inIsErased:=false , inSession:= zfCalc_UserAdmin()) as Movement
inner join MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()
          LEFT JOIN MovementItemLinkObject AS MILinkObject_ContractChild
                                           ON MILinkObject_ContractChild.MovementItemId = MovementItem.Id
                                          AND MILinkObject_ContractChild.DescId = zc_MILinkObject_ContractChild()
          LEFT JOIN MovementItemString AS MIString_Comment
                                       ON MIString_Comment.MovementItemId = MovementItem.Id
                                      AND MIString_Comment.DescId = zc_MIString_Comment()
inner join gpReport_CheckBonus (inStartDate:= '01.11.2014', inEndDate:= '30.11.2014', inSession:= zfCalc_UserAdmin()) as report
on report.InvNumber_find = Movement.ContractInvNumber
and report.ConditionKindName = Movement.ContractConditionKindName and report.BonusKindId = Movement.BonusKindId
and report.Sum_Bonus between  Movement.AmountOut - 0 and Movement.AmountOut + 0
and report.Sum_Bonus <> 0 and Movement.AmountOut <> 0
where Movement.StatusCode = 2 -- "Проведен"
and Movement.isLoad = true
-- and MILinkObject_ContractChild.ObjectId is null

union 

SELECT lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ContractMaster(), MovementItem.Id, report.ContractId_master)
     , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Contractchild(), MovementItem.Id, report.ContractId_child)
     , lpInsertUpdate_MovementItemFloat (zc_MIFloat_BonusValue(), MovementItem.Id, report.Value)
     , CASE WHEN COALESCE (MIString_Comment.ValueData, '') = '' THEN lpInsertUpdate_MovementItemString (zc_MIString_Comment(), MovementItem.Id, report.Comment) ELSE null END
, Movement.*
-- , report.*
FROM gpSelect_Movement_ProfitLossService (inStartDate:= '01.12.2014', inEndDate:= '31.12.2014', inIsErased:=false , inSession:= zfCalc_UserAdmin()) as Movement
inner join MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()
          LEFT JOIN MovementItemLinkObject AS MILinkObject_ContractChild
                                           ON MILinkObject_ContractChild.MovementItemId = MovementItem.Id
                                          AND MILinkObject_ContractChild.DescId = zc_MILinkObject_ContractChild()
          LEFT JOIN MovementItemString AS MIString_Comment
                                       ON MIString_Comment.MovementItemId = MovementItem.Id
                                      AND MIString_Comment.DescId = zc_MIString_Comment()
inner join gpReport_CheckBonus (inStartDate:= '01.12.2014', inEndDate:= '30.12.2014', inSession:= zfCalc_UserAdmin()) as report
on report.InvNumber_find = Movement.ContractInvNumber
and report.ConditionKindName = Movement.ContractConditionKindName and report.BonusKindId = Movement.BonusKindId
and report.Sum_Bonus between  Movement.AmountOut - 0 and Movement.AmountOut + 0
and report.Sum_Bonus <> 0 and Movement.AmountOut <> 0
where Movement.StatusCode = 2 -- "Проведен"
and Movement.isLoad = true
-- and MILinkObject_ContractChild.ObjectId is null

union 

SELECT lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ContractMaster(), MovementItem.Id, report.ContractId_master)
     , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Contractchild(), MovementItem.Id, report.ContractId_child)
     , lpInsertUpdate_MovementItemFloat (zc_MIFloat_BonusValue(), MovementItem.Id, report.Value)
     , CASE WHEN COALESCE (MIString_Comment.ValueData, '') = '' THEN lpInsertUpdate_MovementItemString (zc_MIString_Comment(), MovementItem.Id, report.Comment) ELSE null END
, Movement.*
-- , report.*
FROM gpSelect_Movement_ProfitLossService (inStartDate:= '01.01.2015', inEndDate:= '31.01.2015', inIsErased:=false , inSession:= zfCalc_UserAdmin()) as Movement
inner join MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()
          LEFT JOIN MovementItemLinkObject AS MILinkObject_ContractChild
                                           ON MILinkObject_ContractChild.MovementItemId = MovementItem.Id
                                          AND MILinkObject_ContractChild.DescId = zc_MILinkObject_ContractChild()
          LEFT JOIN MovementItemString AS MIString_Comment
                                       ON MIString_Comment.MovementItemId = MovementItem.Id
                                      AND MIString_Comment.DescId = zc_MIString_Comment()
inner join gpReport_CheckBonus (inStartDate:= '01.01.2015', inEndDate:= '01.01.2015', inSession:= zfCalc_UserAdmin()) as report
on report.InvNumber_find = Movement.ContractInvNumber
and report.ConditionKindName = Movement.ContractConditionKindName and report.BonusKindId = Movement.BonusKindId
and report.Sum_Bonus between  Movement.AmountOut - 0 and Movement.AmountOut + 0
and report.Sum_Bonus <> 0 and Movement.AmountOut <> 0
where Movement.StatusCode = 2 -- "Проведен"
and Movement.isLoad = true
-- and MILinkObject_ContractChild.ObjectId is null