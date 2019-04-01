-- update Object set valuedata = 'http://farmacy-dev2.neboley.dp.ua' where Id = zc_Enum_GlobalConst_ConnectParam()
-- update Object set valuedata = '' where Id = zc_Enum_GlobalConst_ConnectReportParam()

/*
select * from gpInsertUpdate_Object_RoleAction(ioId := 0 , inRoleId := 10356251 , inActionId := 1924690 ,  inSession := '3');

select * from gpSelect_Object_Action( inSession := '3');
select * from gpSelect_Object_RoleAction( inSession := '3') where roleId = 10356251  

select * 
 , gpInsertUpdate_Object_RoleAction (ioId := 0 , inRoleId := 10356251 , inActionId := b.Id ,  inSession := '3')
from gpSelect_Object_Action( inSession := '3')  as b

left join gpSelect_Object_RoleAction( inSession := '3') as a on roleId = 10356251 
-- and roleactionId = b.Id
and a.Id = b.Id
where roleactionId is null
*/
/*
select roleactionId , *
 , gpInsertUpdate_Object_RoleAction(ioId := roleactionId , inRoleId := 10356251 , inActionId := 899 ,  inSession := '3')
from gpSelect_Object_RoleAction( inSession := '3') as a
 join Object on Object.Id = a.Id
-- join ObjectDesc on ObjectDesc.Id = Object.DescId
where roleId = 10356251  
and Object.ValueData in ('actReport_UploadOptimaForm'
,'actReport_UploadOptimaForm'
,'actReport_Badm'
,'actReport_IncomeSample'
,'actReport_CheckPromoFarm'
,'actReport_MovementCheckFarm_Cross'

,'actNDSKind'
,'actOrderKind'
,'actMeasure'
,'actConditionsKeep'
,'actDiffKind'
,'actCashRegister'
,'actBankPOSTerminal'
,'actUnitBankPOSTerminal'
,'actAccountGroup'
,'actAccountDirection'
,'actAccount'
,'actInfoMoneyGroup'
,'actInfoMoneyDestination'
,'actInfoMoney'
,'actProfitLossGroup'
,'actProfitLossDirection'
,'actProfitLoss'
,'actUser'
,'actRole'
,'actRoleUnion'
,'actLog_CashRemains'
-- ,'actCheckNoCashRegister'
,'actCheckUnComplete'
,'actSetDefault'
,'actEmailSettings'
,'actEmailKind'
,'actEmailTools'
,'actEmail'
,'actConfirmedKind'
,'actReport_GoodsRemains_AnotherRetail'
,'actExportSalesForSuppClick'
,'actUnitForFarmacyCash'
-- ,'actRepriceUnitSheduler'
,'actColor'
,'actForms'
,'actMovementDesc'
,'actTestFormOpen'
,'actFiscal'
,'actJackdawsChecks'
,'actSaveData'
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
,''
) 

*/
-- 
-- Goods + GoodsGroup
-- 
-- 1.1. «¿Ã≈Õ»À» Goods -- select count(*) from Object where DescId = zc_Object_Goods();
update Object set ValueData = 'œÂÔ‡‡Ú _ ' || ((cast (tmp.Ord as Integer)) :: TVarChar)
from (select *, ROW_NUMBER() OVER (ORDER BY Id ASC) AS Ord from Object where DescId = zc_Object_Goods() /*limit 100*/) AS tmp
where Object.Id = tmp.Id;

-- 1.2. «¿Ã≈Õ»À» GoodsGroup
update Object set ValueData = '√ÛÔÔ‡ _ ' || ((cast (tmp.Ord as Integer)) :: TVarChar)
from (select *, ROW_NUMBER() OVER (ORDER BY Id ASC) AS Ord from Object where DescId = zc_Object_GoodsGroup()) AS tmp
where Object.Id = tmp.Id;


-- 
-- Unit + Retail + Area + ProvinceCity
-- 
-- 1.3.1. «¿Ã≈Õ»À» Unit - Group
update Object set ValueData = '√ÛÔÔ‡ ‡ÔÚÂÍ _ ' || ((cast (tmp.Ord as Integer)) :: TVarChar)
from (select *, ROW_NUMBER() OVER (ORDER BY Id ASC) AS Ord
      from Object
      where DescId = zc_Object_Unit()
        AND (Id IN (SELECT ChildObjectId FROM ObjectLink WHERE DescId = zc_ObjectLink_Unit_Parent())
          OR Id IN (SELECT ObjectId FROM ObjectLink WHERE ChildObjectId IS NULL AND DescId = zc_ObjectLink_Unit_Parent())
            )
     ) AS tmp
where Object.Id = tmp.Id;

-- 1.3.2. «¿Ã≈Õ»À» Unit - Unit
update Object set ValueData = '¿ÔÚÂÍ‡ _ ' || ((cast (tmp.Ord as Integer)) :: TVarChar)
from (select *, ROW_NUMBER() OVER (ORDER BY Id ASC) AS Ord
      from Object
      where DescId = zc_Object_Unit()
        AND Id NOT IN (SELECT COALESCE (ChildObjectId, 0) FROM ObjectLink WHERE DescId = zc_ObjectLink_Unit_Parent())
        AND Id NOT IN (SELECT ObjectId FROM ObjectLink WHERE ChildObjectId IS NULL AND DescId = zc_ObjectLink_Unit_Parent())
 ) AS tmp
where Object.Id = tmp.Id;
-- 1.3.3. «¿Ã≈Õ»À» zc_ObjectString_Unit_Address
update ObjectString set ValueData = '¿‰ÂÒ _ ' || ((cast (tmp.Ord as Integer)) :: TVarChar)
from (select *, ROW_NUMBER() OVER (ORDER BY Id ASC) AS Ord
      from Object
      where DescId = zc_Object_Unit()
        AND Id NOT IN (SELECT COALESCE (ChildObjectId, 0) FROM ObjectLink WHERE DescId = zc_ObjectLink_Unit_Parent())
        AND Id NOT IN (SELECT ObjectId FROM ObjectLink WHERE ChildObjectId IS NULL AND DescId = zc_ObjectLink_Unit_Parent())
 ) AS tmp
where ObjectString.ValueData <> ''
  AND ObjectString.ObjectId = tmp.Id
  AND ObjectString.DescId = zc_ObjectString_Unit_Address();
-- 1.3.3. «¿Ã≈Õ»À» zc_ObjectString_Unit_Phone
update ObjectString set ValueData = ''  where ObjectString.DescId = zc_ObjectString_Unit_Phone();
-- 1.3.4.1. «¿Ã≈Õ»À» zc_Object_Area
update Object set ValueData = '–Â„ËÓÌ _ ' || ((cast (tmp.Ord as Integer)) :: TVarChar)
from (select *, ROW_NUMBER() OVER (ORDER BY Id ASC) AS Ord
      from Object
      where DescId = zc_Object_Area()
 ) AS tmp
where Object.Id = tmp.Id;
-- 1.3.4.2. «¿Ã≈Õ»À» zc_Object_ProvinceCity
update Object set ValueData = ' –‡ÈÓÌ _ ' || ((cast (tmp.Ord as Integer)) :: TVarChar)
from (select *, ROW_NUMBER() OVER (ORDER BY Id ASC) AS Ord
      from Object
      where DescId = zc_Object_ProvinceCity()
 ) AS tmp
where Object.Id = tmp.Id;
-- 1.3.5. «¿Ã≈Õ»À» zc_Object_Retail
update Object set ValueData = ' “Ó„Ó‚‡ˇ —ÂÚ¸ _ ' || ((cast (tmp.Ord as Integer)) :: TVarChar)
from (select *, ROW_NUMBER() OVER (ORDER BY Id ASC) AS Ord
      from Object
      where DescId = zc_Object_Retail()
 ) AS tmp
where Object.Id = tmp.Id;
-- 1.3.6. «¿Ã≈Õ»À» zc_Object_MarginCategory
update Object set ValueData = '  ‡ÚÂ„ÓËˇ Ì‡ˆÂÌÍË _ ' || ((cast (tmp.Ord as Integer)) :: TVarChar)
from (select *, ROW_NUMBER() OVER (ORDER BY Id ASC) AS Ord
      from Object
      where DescId = zc_Object_MarginCategory()
      and Id <> 1327351 -- !!!_œ≈–≈Œ÷≈Õ ¿ œŒ ¬—≈… —≈“»
 ) AS tmp
where Object.Id = tmp.Id;



  
-- 
-- Juridical
-- 
-- 1.4.1. «¿Ã≈Õ»À» Juridical - main
update Object set ValueData = 'Õ‡¯Â ﬁ ÎËˆÓ _ ' || ((cast (tmp.Ord as Integer)) :: TVarChar)
from (select *, ROW_NUMBER() OVER (ORDER BY Id ASC) AS Ord
      from Object
      where DescId = zc_Object_Juridical()
        AND Id IN (SELECT ObjectId FROM ObjectBoolean WHERE DescId = zc_ObjectBoolean_Juridical_isCorporate() AND ValueData = TRUE)
     ) AS tmp
where Object.Id = tmp.Id;
-- 1.4.2. «¿Ã≈Õ»À» Juridical - NO main
update Object set ValueData = 'ﬁ ÎËˆÓ _ ' || ((cast (tmp.Ord as Integer)) :: TVarChar)
from (select *, ROW_NUMBER() OVER (ORDER BY Id ASC) AS Ord
      from Object
      where DescId = zc_Object_Juridical()
        AND Id NOT IN (SELECT ObjectId FROM ObjectBoolean WHERE DescId = zc_ObjectBoolean_Juridical_isCorporate() AND ValueData = TRUE)
     ) AS tmp
where Object.Id = tmp.Id;
-- 1.4.3. «¿Ã≈Õ»À» Contract
update Object set ValueData = addstr || 'ƒÓ„Ó‚Ó _ ' || ((cast (tmp.Ord as Integer)) :: TVarChar)
from (select Object.*, ROW_NUMBER() OVER (ORDER BY Id ASC) AS Ord
              , case when Object.ValueData ilike '%ÓÚÒÓ˜Í‡%' then 'ÓÚÒÓ˜Í‡ '
                     when Object.ValueData ilike '%Ù‡ÍÚ%' then 'Ù‡ÍÚ '
                     else ''
                end as addstr
              , Object_Jur.ValueData AS JurName
      from Object
           inner join ObjectLink on ObjectLink.ObjectId = Object.Id and ObjectLink.DescId = zc_ObjectLink_Contract_Juridical()
           join Object As Object_Jur on Object_Jur.Id = ObjectLink.ChildObjectId
      where DescId = zc_Object_Contract()
     ) AS tmp
where Object.Id = tmp.Id;

-- 1.4.2. «¿Ã≈Õ»À» BankAccount
update Object set ValueData = '–/Ò˜ÂÚ _ ' || ((cast (tmp.Ord as Integer)) :: TVarChar)
from (select *, ROW_NUMBER() OVER (ORDER BY Id ASC) AS Ord
      from Object
      where DescId = zc_Object_BankAccount()
     ) AS tmp
where Object.Id = tmp.Id;

-- 1.4.2. «¿Ã≈Õ»À» DiscountCard
update Object set ValueData = 'ƒËÒÍÓÌÚ Í‡Ú‡ _ ' || ((cast (tmp.Ord as Integer)) :: TVarChar)
from (select *, ROW_NUMBER() OVER (ORDER BY Id ASC) AS Ord
      from Object
      where DescId = zc_Object_DiscountCard()
     ) AS tmp
where Object.Id = tmp.Id;

-- 1.4.2. «¿Ã≈Õ»À» BarCode
update Object set ValueData = 'ÿ/ÍÓ‰ _ ' || ((cast (tmp.Ord as Integer)) :: TVarChar)
from (select *, ROW_NUMBER() OVER (ORDER BY Id ASC) AS Ord
      from Object
      where DescId = zc_Object_BarCode()
     ) AS tmp
where Object.Id = tmp.Id;



-- 
-- Member + Personal + User
-- 
-- 1.5.1. «¿Ã≈Õ»À» Member
update Object set ValueData = '‘»Œ _ ' || ((cast (tmp.Ord as Integer)) :: TVarChar)
from (select *, ROW_NUMBER() OVER (ORDER BY Id ASC) AS Ord
      from Object
      where DescId = zc_Object_Member()
     ) AS tmp
where Object.Id = tmp.Id;
-- 1.5.2. «¿Ã≈Õ»À» Personal
update Object set ValueData = Object_Member.ValueData
from ObjectLink 
     LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink.ChildObjectId
where Object.Id = ObjectLink.ObjectId
  AND ObjectLink.DescId = zc_ObjectLink_Personal_Member();
-- 1.5.3. «¿Ã≈Õ»À» User
update Object set ValueData = 'œÓÎ¸ÁÓ‚‡ÚÂÎ¸ ‘»Œ _ ' || ((cast (tmp.Ord as Integer)) :: TVarChar)
from (select *, ROW_NUMBER() OVER (ORDER BY Id ASC) AS Ord
      from Object
      where DescId = zc_Object_User()
      and ObjectCode not in (0, -10)
     ) AS tmp
where Object.Id = tmp.Id;
-- 1.5.4. «¿Ã≈Õ»À» zc_ObjectString_User_
update ObjectString set ValueData = ''  where ObjectString.ObjectId in (select Id from Object where DescId = zc_Object_User() and ObjectCode not in (0, -10));






