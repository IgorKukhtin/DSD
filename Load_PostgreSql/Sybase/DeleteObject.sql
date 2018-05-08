DO $$
BEGIN

     CREATE TEMP TABLE _tmp_del (ObjectId Integer) ON COMMIT DROP;
     INSERT INTO _tmp_del (ObjectId )
      select Object .Id
-- select  *
from Object 
where DescId = zc_Object_GoodsGroup()
 -- and id not in (select ChildObjectId from ObjectLink where DescId = zc_ObjectLink_GoodsGroup_parent())
 and id not in (select ChildObjectId from ObjectLink where ChildObjectId > 0);

  DELETE FROM ObjectLink WHERE ObjectId in (select ObjectId from _tmp_del);
  -- DELETE FROM ObjectString WHERE ObjectId in (select ObjectId from _tmp_del);
  -- DELETE FROM ObjectBLOB WHERE ObjectId in (select ObjectId from _tmp_del);
  -- DELETE FROM ObjectFloat WHERE ObjectId in (select ObjectId from _tmp_del);
  DELETE FROM ObjectProtocol WHERE ObjectId in (select ObjectId from _tmp_del);
  -- DELETE FROM ObjectBoolean WHERE ObjectId in (select ObjectId from _tmp_del);
  -- DELETE FROM ObjectDate WHERE ObjectId in (select ObjectId from _tmp_del);
  DELETE FROM Object WHERE Id in (select ObjectId from _tmp_del);

END $$;




select lpDelete_Object (Object.Id, '5') 
from Object
where DescId = zc_Object_ContractGoods();


select * 
from Object
where DescId = zc_Object_ContractGoods()


select lpDelete_Object (userroleId, '5')
from gpSelect_Object_RoleUser( inSession := '5') as a where name = 'ú-Êëèìåíòüåâ Ê.È.'


select lpDelete_Object (Object.Id, '5') 
from (
select Id from gpSelect_Object_ToolsWeighing( inSession := '5')
where ParentId = 344844 or id = 344771
) as Object



-- 1 - !!!!!!!!!!!!!!!!!!!!
-- select * from Object where ObjectCode=4 and DescId = zc_Object_Branch()
select lpInsertUpdate_ObjectLink (zc_ObjectLink_Unit_Branch(), Id, (select Id from Object where ObjectCode=4 and DescId = zc_Object_Branch()))
-- select *
from Object
where Id = 298605 --  ÎÃÎÐÅÍÊÎ íîâûé äèñòðèáüþòîð
union
select lpInsertUpdate_ObjectLink (zc_ObjectLink_Unit_Branch(), Id, (select Id from Object where ObjectCode=10 and DescId = zc_Object_Branch()))
-- select *
from Object
where Id = 256624 --  Ìåðæèºâñüêèé Î.Â. ÔÎÏ äèñòðèáüþòîð

union
select lpInsertUpdate_ObjectLink (zc_ObjectLink_Unit_Branch(), Id, (select Id from Object where ObjectCode=6 and DescId = zc_Object_Branch()))
-- select *
from Object
where Id in (79447, 329598, 78274) -- Ïðåì³óì Ôóäñ ÒÎÂ


select    -- gpInsertUpdate_Object_RoleProcess (ioId :=  b.roleprocessid , inRoleId := tmpRole.RoleId , inProcessId := a.Id ,  inSession := '5')
          b.roleprocessid , tmpRole.RoleId  , a.Id 
from (select 279795  as RoleId -- Áóõãàëòåð Êèåâ
 union select 279937 as RoleId -- Áóõãàëòåð ÊÐÈÂÎÉ ÐÎÃ
 union select 279916 as RoleId -- Áóõãàëòåð ÍÈÊÎËÀÅÂ
 union select 279931 as RoleId -- Áóõãàëòåð ÕÀÐÜÊÎÂ 
 union select 279922 as RoleId -- Áóõãàëòåð ×ÅÐÊÀÑÑÛ
     ) as tmpRole
left join gpSelect_Object_Process( inSession := '5') as a
         on EnumName in ('zc_Enum_Process_InsertUpdate_Movement_Sale'
                       , 'zc_Enum_Process_Complete_Sale'
                       , 'zc_Enum_Process_SetErased_Sale'
                       , 'zc_Enum_Process_UnComplete_Sale'

                       , 'zc_Enum_Process_InsertUpdate_MI_Sale'
                       , 'zc_Enum_Process_SetErased_MI_Sale'
                       , 'zc_Enum_Process_SetUnErased_MI_Sale'

                       , 'zc_Enum_Process_InsertUpdate_Movement_ReturnIn'
                       , 'zc_Enum_Process_Complete_ReturnIn'
                       , 'zc_Enum_Process_UnComplete_ReturnIn'
                       , 'zc_Enum_Process_SetErased_ReturnIn'

                       , 'zc_Enum_Process_InsertUpdate_MI_ReturnIn'
                       , 'zc_Enum_Process_SetErased_MI_ReturnIn'
                       , 'zc_Enum_Process_SetUnErased_MI_ReturnIn'
                        )
left join gpSelect_Object_RoleProcess( inSession := '5') as b
         on b.RoleId = tmpRole.RoleId -- Áóõãàëòåð ÊÐÈÂÎÉ ÐÎÃ
        and Process_EnumName = EnumName
where Process_EnumName is null




-- 2.1 - !!!!!!!!!!!!!!!!!!!! Change Sale FromId
select lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), Movement.Id, ObjectLink_Partner_Juridical.ObjectId)
     , lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidKindFrom(), Movement.Id, Object_Contract_View.PaidKindId)
     , lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ContractFrom(), Movement.Id, Object_Contract_View.ContractId)
-- select *
from Movement
     inner join MovementLinkObject AS MovementLinkObject_From
                                   ON MovementLinkObject_From.MovementId = Movement.Id
                                  AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                  AND MovementLinkObject_From.ObjectId = 8423 -- ô. Îäåññà
     inner join MovementLinkObject AS MovementLinkObject_PaidKind
                                   ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                  AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
                                  AND MovementLinkObject_PaidKind.ObjectId = zc_Enum_PaidKind_FirstForm()
     inner join ObjectLink AS ObjectLink_Partner_Juridical
                           ON ObjectLink_Partner_Juridical.ObjectId = 298605 --  ÎÃÎÐÅÍÊÎ íîâûé äèñòðèáüþòîð
                          AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
     inner join Object_Contract_View ON Object_Contract_View.JuridicalId = ObjectLink_Partner_Juridical.ChildObjectId
                                    AND Object_Contract_View.InfoMoneyId = zc_Enum_InfoMoney_30101()
where Movement.OperDate >= '01.06.2014'
  and Movement.DescId = zc_Movement_Sale();


-- 2.2 - !!!!!!!!!!!!!!!!!!!! Change ReturnIn ToId
select lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), Movement.Id, ObjectLink_Partner_Juridical.ObjectId)
     , lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidKindTo(), Movement.Id, Object_Contract_View.PaidKindId)
     , lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ContractTo(), Movement.Id, Object_Contract_View.ContractId)
-- select *
from Movement
     inner join MovementLinkObject AS MovementLinkObject_From
                                   ON MovementLinkObject_From.MovementId = Movement.Id
                                  AND MovementLinkObject_From.DescId = zc_MovementLinkObject_To()
                                  AND MovementLinkObject_From.ObjectId = 8423 -- ô. Îäåññà
     inner join MovementLinkObject AS MovementLinkObject_PaidKind
                                   ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                  AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
                                  AND MovementLinkObject_PaidKind.ObjectId = zc_Enum_PaidKind_FirstForm()
     inner join ObjectLink AS ObjectLink_Partner_Juridical
                           ON ObjectLink_Partner_Juridical.ObjectId = 298605 --  ÎÃÎÐÅÍÊÎ íîâûé äèñòðèáüþòîð
                          AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
     inner join Object_Contract_View ON Object_Contract_View.JuridicalId = ObjectLink_Partner_Juridical.ChildObjectId
                                    AND Object_Contract_View.InfoMoneyId = zc_Enum_InfoMoney_30101()
where Movement.OperDate >= '01.06.2014'
  and Movement.DescId = zc_Movement_ReturnIn();


-- 3.1 - !!!!!!!!!!!!!!!!!!!! SendOnPrice -> Sale
select lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), Movement.Id, ObjectLink_Partner_Juridical.ObjectId)
     , lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidKind(), Movement.Id, Object_Contract_View.PaidKindId)
     , lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), Movement.Id, Object_Contract_View.ContractId)
     , lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PriceList(), Movement.Id, zc_PriceList_Basis())
     , lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PriceWithVAT(), Movement.Id, FALSE)
     , lpInsertUpdate_MovementFloat (zc_MovementFloat_VATPercent(), Movement.Id, 20)
     , lpInsertUpdate_MovementDate (zc_MovementDate_OperDatePartner(), Movement.Id, Movement.OperDate)
     , lpInsertUpdate_Movement (Movement.Id, zc_Movement_Sale(), Movement.InvNumber , Movement.OperDate, Movement.ParentId , 80540)
-- select *
from Movement
     inner join MovementLinkObject AS MovementLinkObject_From
                                   ON MovementLinkObject_From.MovementId = Movement.Id
                                  AND MovementLinkObject_From.DescId = zc_MovementLinkObject_To()
                                  AND MovementLinkObject_From.ObjectId = 8423 -- ô. Îäåññà
     inner join ObjectLink AS ObjectLink_Partner_Juridical
                           ON ObjectLink_Partner_Juridical.ObjectId = 298605 --  ÎÃÎÐÅÍÊÎ íîâûé äèñòðèáüþòîð
                          AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
     inner join Object_Contract_View ON Object_Contract_View.JuridicalId = ObjectLink_Partner_Juridical.ChildObjectId
                                    AND Object_Contract_View.InfoMoneyId = zc_Enum_InfoMoney_30101()
where Movement.OperDate >= '01.06.2014'
  and Movement.DescId = zc_Movement_SendOnPrice();

-- 3.2 - !!!!!!!!!!!!!!!!!!!! SendOnPrice -> ReturnIn
select lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), Movement.Id, ObjectLink_Partner_Juridical.ObjectId)
     , lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidKind(), Movement.Id, Object_Contract_View.PaidKindId)
     , lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), Movement.Id, Object_Contract_View.ContractId)
     , lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PriceList(), Movement.Id, zc_PriceList_Basis())
     , lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PriceWithVAT(), Movement.Id, FALSE)
     , lpInsertUpdate_MovementFloat (zc_MovementFloat_VATPercent(), Movement.Id, 20)
     , lpInsertUpdate_MovementDate (zc_MovementDate_OperDatePartner(), Movement.Id, Movement.OperDate)
     , lpInsertUpdate_Movement (Movement.Id, zc_Movement_ReturnIn(), Movement.InvNumber , Movement.OperDate, Movement.ParentId , 80540)
-- select *
from Movement
     inner join MovementLinkObject AS MovementLinkObject_From
                                   ON MovementLinkObject_From.MovementId = Movement.Id
                                  AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                  AND MovementLinkObject_From.ObjectId = 8423 -- ô. Îäåññà
     inner join ObjectLink AS ObjectLink_Partner_Juridical
                           ON ObjectLink_Partner_Juridical.ObjectId = 298605 --  ÎÃÎÐÅÍÊÎ íîâûé äèñòðèáüþòîð
                          AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
     inner join Object_Contract_View ON Object_Contract_View.JuridicalId = ObjectLink_Partner_Juridical.ChildObjectId
                                    AND Object_Contract_View.InfoMoneyId = zc_Enum_InfoMoney_30101()
where Movement.OperDate >= '01.06.2014'
  and Movement.DescId = zc_Movement_SendOnPrice();




-- start !!!!!!!!!!SCALE!!!!!!!!!!
select lpDelete_Object (aaa.Id, '5')
from gpSelect_Object_ToolsWeighing( inSession := '5') as aaa
where ParentId in (select aa.Id from gpSelect_Object_ToolsWeighing( inSession := '5') as aa
                   where aa.ParentId in (select a.id from gpSelect_Object_ToolsWeighing( inSession := '5') as a where a.ParentId = 432585))
order by 1

select lpDelete_Object (aa.Id, '5')
from gpSelect_Object_ToolsWeighing( inSession := '5') as aa
where aa.ParentId in (select a.id from gpSelect_Object_ToolsWeighing( inSession := '5') as a where a.ParentId = 432585)
order by 1

select lpDelete_Object (a.Id, '5')
from gpSelect_Object_ToolsWeighing( inSession := '5') as a
where ParentId = 432585

order by 1

select lpDelete_Object (432585, '5')
-- end !!!!!!!!!!SCALE!!!!!!!!!!
