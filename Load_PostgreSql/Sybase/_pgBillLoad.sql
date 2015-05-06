create table dba._pgBillLoad
(Id integer not null default autoincrement,
BillNumber TVarCharMedium not null,
FromId Integer not null,
ToId Integer not null,
PRIMARY KEY (BillNumber, FromId, ToId));

-- delete from dba._pgBillLoad ;
insert into dba._pgBillLoad (BillNumber, FromId, ToId)
      select '226926' as InvNumber, zc_UnitId_StoreSale()        as FromId, 0 as ToId -- Склад реализации
union select '227199' as InvNumber, zc_UnitId_StoreSale()        as FromId, 0 as ToId -- Склад реализации
union select '221222' as InvNumber, zc_UnitId_StoreSale()        as FromId, 0 as ToId -- Склад реализации
union select '213917' as InvNumber, zc_UnitId_StoreSale()        as FromId, 0 as ToId -- Склад реализации
union select '211817' as InvNumber, zc_UnitId_StoreSale()        as FromId, 0 as ToId -- Склад реализации

union select '201775' as InvNumber, zc_UnitId_StoreSale()        as FromId, 0 as ToId -- Склад реализации
union select '199470' as InvNumber, zc_UnitId_StoreSale()        as FromId, 0 as ToId -- Склад реализации
union select '202242' as InvNumber, zc_UnitId_StoreSale()        as FromId, 0 as ToId -- Склад реализации
union select '199435' as InvNumber, zc_UnitId_StoreSale()        as FromId, 0 as ToId -- Склад реализации

union select '4658' as InvNumber, zc_UnitId_StoreSale()        as FromId, 0 as ToId -- Склад реализации
union select '189170' as InvNumber, zc_UnitId_StoreSale()        as FromId, 0 as ToId -- Склад реализации
union select '189172' as InvNumber, zc_UnitId_StoreSale()        as FromId, 0 as ToId -- Склад реализации

union select '199409' as InvNumber, zc_UnitId_StorePF()            as FromId, 0 as ToId -- Склад ОХЛАЖДЕНКА
union select '199409' as InvNumber, zc_UnitId_StoreMaterialBasis() as FromId, 0 as ToId -- Склад МИНУСОВКА
union select '199409' as InvNumber, zc_UnitId_StoreSalePF()        as FromId, 0 as ToId -- Склад реализации мясо
union select '199407' as InvNumber, zc_UnitId_StorePF()            as FromId, 0 as ToId -- Склад ОХЛАЖДЕНКА
union select '199407' as InvNumber, zc_UnitId_StoreMaterialBasis() as FromId, 0 as ToId -- Склад МИНУСОВКА
union select '199407' as InvNumber, zc_UnitId_StoreSalePF()        as FromId, 0 as ToId -- Склад реализации мясо

union select '198727' as InvNumber, zc_UnitId_StorePF()            as FromId, 0 as ToId -- Склад ОХЛАЖДЕНКА
union select '198727' as InvNumber, zc_UnitId_StoreMaterialBasis() as FromId, 0 as ToId -- Склад МИНУСОВКА
union select '198727' as InvNumber, zc_UnitId_StoreSalePF()        as FromId, 0 as ToId -- Склад реализации мясо

union select '227021' as InvNumber, zc_UnitId_StorePF()            as FromId, 0 as ToId -- Склад ОХЛАЖДЕНКА
union select '227021' as InvNumber, zc_UnitId_StoreMaterialBasis() as FromId, 0 as ToId -- Склад МИНУСОВКА
union select '227021' as InvNumber, zc_UnitId_StoreSalePF()        as FromId, 0 as ToId -- Склад реализации мясо


-- !!!!!!
union select '111' as InvNumber, zc_UnitId_StoreSale()          as FromId, 0 as ToId -- Склад реализации
union select '222' as InvNumber, zc_UnitId_StorePF()            as FromId, 0 as ToId -- Склад ОХЛАЖДЕНКА
union select '333' as InvNumber, zc_UnitId_StoreMaterialBasis() as FromId, 0 as ToId -- Склад МИНУСОВКА
union select '444' as InvNumber, zc_UnitId_StoreSalePF()        as FromId, 0 as ToId -- Склад реализации мясо
-- !!!!!!


delete from dba._pgBillLoad ;
insert into dba._pgBillLoad (BillNumber, FromId, ToId)
select BillNumber, FromId, ToId from Bill where fromId in (zc_UnitId_StorePF(), zc_UnitId_StoreMaterialBasis(), zc_UnitId_StoreSalePF()) 
                                         and BillKind = zc_bkSaleToClient()
                                         and ToId in (select Id from dba.Unit where UnitCode in (1125))
                                         and BillDate between '2014-11-01' and '2014-11-30'
                                         and BillNumber  = '195154'


-- !!!!!!!!!!!!!!!
-- !!! ERROR PF !!!
-- !!!!!!!!!!!!!!!
-- select * from 
-- update 
dba.Bill
set BillNumberNalog = 0
where BillDate between '2014-05-01' and '2014-09-01'
and FromId in (zc_UnitId_StoreMaterialBasis(), zc_UnitId_StorePF(), zc_UnitId_StoreSalePF())
and BillNumberNalog <> 0
and Bill.ToId in(
select Unit.Id -- trim(ClientInformation.OKPO) as OKPO, 
from dba.Unit
     left outer join dba.ClientInformation as ClientInformation_find on ClientInformation_find.ClientID = isnull(zf_ChangeIntToNull(Unit.InformationFromUnitId),Unit.Id)
                                                                    and trim(ClientInformation_find.OKPO) <> ''
     left outer join dba.ClientInformation as ClientInformation_child on ClientInformation_child.ClientID = Unit.Id
     join dba.ClientInformation on ClientInformation.ClientID = isnull(ClientInformation_find.ClientID,ClientInformation_child.ClientID)
                                                            and trim(ClientInformation.OKPO) <> ''
where trim(ClientInformation.OKPO) in ('38685495', '30982361', '33184262', '32294926', '32294905', '38939423', '38183389')
)



-- !!!!!!!!!!!!!!!
-- !!! LIST POK !!!
-- !!!!!!!!!!!!!!!
select Unit_inf.UnitName as GroupsName, isnull(ClientInformation.OKPO,'') as OKPO, Unit.Id AS Id_byLoad, Unit.UnitName -- , Unit_FindBill.Kind
from dba.Unit
     left outer join dba.Unit as Unit_inf on Unit_inf.ID = isnull(zf_ChangeIntToNull(Unit.InformationFromUnitId),Unit.Id)
     left outer join dba.ClientInformation as ClientInformation_find on ClientInformation_find.ClientID = Unit_inf.ID
                                                                    and ClientInformation_find.OKPO <> ''
     left outer join dba.ClientInformation as ClientInformation_child on ClientInformation_child.ClientID = Unit.Id
                                                                     and ClientInformation_child.OKPO <> ''
     left outer join dba.ClientInformation on ClientInformation.ClientID = isnull(ClientInformation_child.ClientID,ClientInformation_find.ClientID)
     inner join (select ToId as Id, 1 as kind from dba.Bill where FromId in (zc_UnitId_StoreSalePF(), zc_UnitId_StorePF(), zc_UnitId_StoreMaterialBasis()) and Bill.BillDate >= '2014-01-01' and BillKind = zc_bkSaleToClient() and Bill.MoneyKindId = zc_mkNal() group by ToId
               union 
                 select FromId as Id, 1 as kind from dba.Bill where ToId in (zc_UnitId_StoreSalePF(), zc_UnitId_StorePF(), zc_UnitId_StoreMaterialBasis()) and Bill.BillDate >= '2014-01-01' and BillKind = zc_bkReturnToUnit() and Bill.MoneyKindId = zc_mkNal() group by FromId
               union 
                 select ToId as Id, 1 as kind from dba.Bill left join dba.isUnit as isUnit_to on isUnit_to.UnitId = ToId where FromId in (zc_UnitId_StoreSalePF(), zc_UnitId_StorePF(), zc_UnitId_StoreMaterialBasis()) and isUnit_to.UnitId is null and Bill.BillDate >= '2014-01-01' and BillKind = zc_bkSendUnitToUnit() and Bill.MoneyKindId = zc_mkNal() group by ToId
               union 
                 select FromId as Id, 1 as kind from dba.Bill left join dba.isUnit as isUnit_from on isUnit_from.UnitId = FromId where ToId in (zc_UnitId_StoreSalePF(), zc_UnitId_StorePF(), zc_UnitId_StoreMaterialBasis()) and isUnit_from.UnitId is null and Bill.BillDate >= '2014-01-01' and BillKind = zc_bkSendUnitToUnit() and Bill.MoneyKindId = zc_mkNal() group by FromId

               union 
                 select ToId as Id, 2 as kind from dba.Bill where FromId in (zc_UnitId_StoreSale(),zc_UnitId_StoreReturn(),zc_UnitId_StoreReturnBrak()) and Bill.BillDate >= '2014-01-01' and BillKind = zc_bkSaleToClient() and Bill.MoneyKindId = zc_mkNal() group by ToId
               union 
                 select FromId as Id, 2 as kind from dba.Bill where ToId in (zc_UnitId_StoreSale(),zc_UnitId_StoreReturn(),zc_UnitId_StoreReturnBrak()) and Bill.BillDate >= '2014-01-01' and BillKind = zc_bkReturnToUnit() and Bill.MoneyKindId = zc_mkNal() group by FromId
               union 
                 select ToId as Id, 2 as kind from dba.Bill left join dba.isUnit as isUnit_to on isUnit_to.UnitId = ToId where FromId in (zc_UnitId_StoreSale(),zc_UnitId_StoreReturn(),zc_UnitId_StoreReturnBrak()) and isUnit_to.UnitId is null and Bill.BillDate >= '2014-01-01' and BillKind = zc_bkSendUnitToUnit() and Bill.MoneyKindId = zc_mkNal() group by ToId
               union 
                 select FromId as Id, 2 as kind from dba.Bill left join dba.isUnit as isUnit_from on isUnit_from.UnitId = FromId where ToId in (zc_UnitId_StoreSale(),zc_UnitId_StoreReturn(),zc_UnitId_StoreReturnBrak()) and isUnit_from.UnitId is null and Bill.BillDate >= '2014-01-01' and BillKind = zc_bkSendUnitToUnit() and Bill.MoneyKindId = zc_mkNal() group by FromId
                )as Unit_FindBill on Unit_FindBill.Id = Unit.Id and Kind = 1

where Unit.Id not in (select UnitId from dba._pgPartner where PartnerId_pg <> 0)
order by 2, 1, 4



-- !!!!!!!!!!!!!!!
-- !!! LIST POST !!!
-- !!!!!!!!!!!!!!!
select Unit_inf.UnitName as GroupsName, isnull(ClientInformation.OKPO,'') as OKPO, Unit.Id AS Id_byLoad, Unit.UnitName -- , Unit_FindBill.Kind
from dba.Unit
     left outer join dba.Unit as Unit_inf on Unit_inf.ID = isnull(zf_ChangeIntToNull(Unit.InformationFromUnitId),Unit.Id)
     left outer join dba.ClientInformation as ClientInformation_find on ClientInformation_find.ClientID = Unit_inf.ID
                                                                    and ClientInformation_find.OKPO <> ''
     left outer join dba.ClientInformation as ClientInformation_child on ClientInformation_child.ClientID = Unit.Id
                                                                     and ClientInformation_child.OKPO <> ''
     left outer join dba.ClientInformation on ClientInformation.ClientID = isnull(ClientInformation_child.ClientID,ClientInformation_find.ClientID)
     inner join (select ToId as Id, 1 as kind from dba.Bill where FromId in (zc_UnitId_StoreSalePF(), zc_UnitId_StorePF(), zc_UnitId_StoreMaterialBasis()) and Bill.BillDate >= '2014-01-01' and BillKind = zc_bkReturnToClient() and Bill.MoneyKindId = zc_mkNal() group by ToId
               union 
                 select FromId as Id, 1 as kind from dba.Bill where ToId in (zc_UnitId_StoreSalePF(), zc_UnitId_StorePF(), zc_UnitId_StoreMaterialBasis()) and Bill.BillDate >= '2014-01-01' and BillKind = zc_bkIncomeToUnit() and Bill.MoneyKindId = zc_mkNal() group by FromId

               union 
                 select ToId as Id, 2 as kind from dba.Bill where FromId not in (zc_UnitId_StoreSalePF(), zc_UnitId_StorePF(), zc_UnitId_StoreMaterialBasis()) and Bill.BillDate >= '2014-01-01' and BillKind = zc_bkReturnToClient() and Bill.MoneyKindId = zc_mkNal() group by ToId
               union 
                 select FromId as Id, 2 as kind from dba.Bill where ToId not in (zc_UnitId_StoreSalePF(), zc_UnitId_StorePF(), zc_UnitId_StoreMaterialBasis()) and Bill.BillDate >= '2014-01-01' and BillKind = zc_bkIncomeToUnit() and Bill.MoneyKindId = zc_mkNal() group by FromId
                )as Unit_FindBill on Unit_FindBill.Id = Unit.Id and Kind = 2

where Unit.Id not in (select UnitId from dba._pgPartner where PartnerId_pg <> 0)
  and OKPO = ''
order by 2, 1, 4
