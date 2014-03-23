-- Int
alter  PROCEDURE "DBA"."_pgSelect_Bill_Sale" (in @inStartDate date, in @inEndDate date)
result(ObjectId Integer, BillId Integer, OperDate Date, InvNumber TVarCharLongLong, BillNumberClient1 TVarCharLongLong, OperDatePartner Date, PriceWithVAT smallint, VATPercent TSumm, ChangePercent  TSumm
     , FromId_Postgres Integer, ToId_Postgres Integer, ClientId Integer
     , PaidKindId_Postgres Integer, CodeIM Integer, ContractNumber TVarCharMedium, CarId Integer, PersonalDriverId Integer, RouteId Integer, RouteSortingId_Postgres Integer, PersonalId_Postgres Integer
     , isFl smallint, zc_rvYes smallint, Id_Postgres integer)
begin
  declare local temporary table _tmpList(
       ObjectId Integer
     , BillId_pg Integer null
     , BillNumberClient1 TVarCharLongLong
     , InvNumber_all TVarCharLongLong
     , InvNumber integer
     , OperDate Date
     , OperDatePartner Date

     , PriceWithVAT smallint
     , VATPercent TSumm
     , ChangePercent  TSumm

     , FromId_Postgres Integer
     , ToId_Postgres Integer
     , ClientId Integer
     , PaidKindId_Postgres Integer
     , CodeIM Integer
     , ContractNumber TVarCharMedium
     , CarId Integer
     , PersonalDriverId Integer

     , RouteId  Integer
     , RouteSortingId_Postgres  Integer
     , PersonalId_Postgres  Integer
     , isFl smallint
     , Id_Postgres integer
  ) on commit preserve rows;

insert into _tmpList (ObjectId, InvNumber_all, InvNumber, BillNumberClient1, OperDate, OperDatePartner, PriceWithVAT, VATPercent, ChangePercent, FromId_Postgres, ToId_Postgres, ClientId
                    , PaidKindId_Postgres, CodeIM, ContractNumber, CarId, PersonalDriverId, RouteId, RouteSortingId_Postgres, PersonalId_Postgres, isFl, Id_Postgres)
select Bill.Id as ObjectId

     , cast (Bill.BillNumber as TVarCharMedium) ||
       case when FromId_Postgres is null or ToId_Postgres is null or CodeIM = 0
                 then '-Ó¯Ë·Í‡' || case when FromId_Postgres is null then '-ÓÚ ÍÓ„Ó:' || UnitFrom.UnitName else '' end
                                || case when ToId_Postgres is null then '-ÍÓÏÛ:' || UnitTo.UnitName else '' end
                                || case when CodeIM = 0 then '-”œ ÒÚ‡Ú¸ˇ:???' else '' end
            else ''
       end as InvNumber_all
     , Bill.BillNumber as InvNumber
     , Bill.BillNumberClient1 as BillNumberClient1

     , Bill.BillDate as OperDate
     , OperDate + isnull(_toolsView_Client_isChangeDate.addDay,0) as OperDatePartner

     , Bill.isNds as PriceWithVAT
     , Bill.Nds as VATPercent
     , case when Bill.isByMinusDiscountTax=zc_rvYes() then -Bill.DiscountTax else Bill.DiscountTax end as ChangePercent

     , isnull (pgPersonalFrom.Id_Postgres, pgUnitFrom.Id_Postgres) as FromId_Postgres
     , _pgPartner.PartnerId_pg as ToId_Postgres
     , Bill.ToId as ClientId

     , case when Bill.MoneyKindId=zc_mkBN() then 3 else 4 end as PaidKindId_Postgres
     , 30201 as CodeIM -- _pgInfoMoney.Id3_Postgres AS ContractId 
     , isnull (Contract.ContractNumber,'') as ContractNumber
     , null as CarId
     , null as PersonalDriverId

     , null as RouteId
     , null as RouteSortingId_Postgres
     , null as PersonalId_Postgres

--     , null as RouteId
--     , case when isnull(Bill.RouteUnitId,0) = Bill.ToId then ToId_Postgres else Unit_RouteSorting.Id_Postgres_RouteSorting end as RouteSortingId_Postgres
--     , _pgPersonal.Id2_Postgres as PersonalId_Postgres

     , zc_rvNo() as isFl
     , (Bill.Id_Postgres) as Id_Postgres

from (select Bill.Id
      from dba.Bill
           join dba.BillItems on BillItems.BillId = Bill.Id and BillItems.OperCount<>0
      where Bill.BillDate between @inStartDate and @inEndDate
        and Bill.FromId in (zc_UnitId_StoreMaterialBasis(),zc_UnitId_StorePF())
        and Bill.BillKind in (zc_bkSaleToClient())
        and Bill.MoneyKindId = zc_mkBN()
--       and Bill.BillNumber = 1635
--       and Bill.Id = 1260716
       group by Bill.Id
     union
      select Bill.Id
      from dba.Bill
           join dba.BillItems on BillItems.BillId = Bill.Id and BillItems.OperCount<>0 and BillItems.GoodsPropertyId = 5510 -- –”À‹ ¿ ¬¿–≈Õ¿ﬂ ‚ Ô‡ÍÂÚÂ ‰Îˇ Á‡ÔÂÍ‡ÌËˇ
      where Bill.BillDate between @inStartDate and @inEndDate
        and Bill.FromId in (zc_UnitId_StoreSale())
        and Bill.BillKind in (zc_bkSaleToClient())
        and Bill.MoneyKindId = zc_mkBN()
--       and Bill.BillNumber = 1635
--       and Bill.Id = 1260716
       group by Bill.Id
     ) as Bill_find

     left outer join dba.Bill on Bill.Id = Bill_find.Id
     left outer join (SELECT max (isnull (find1.Id, isnull (find2.Id,0))) as Id, Unit.Id as ClientId
                      from dba.Unit
                      left outer join dba.ContractKind_byHistory as find1
                           on find1.ClientId = Unit.DolgByUnitID
                         and @inStartDate between find1.StartDate and find1.EndDate
                         and find1.ContractNumber <> ''
                      left outer join dba.ContractKind_byHistory as find2
                          on find2.ClientId = Unit.Id
                         and @inStartDate between find2.StartDate and find2.EndDate
                         and find2.ContractNumber <> ''
                      group by Unit.Id
                     ) as Contract_find on Contract_find.ClientId = Bill.ToId
     left outer join dba.ContractKind_byHistory as Contract on Contract.Id = Contract_find.Id

     left outer join dba.Unit AS UnitFrom on UnitFrom.Id = Bill.FromId
     left outer join dba._pgUnit as pgUnitFrom on pgUnitFrom.Id=UnitFrom.pgUnitId

     left outer join (select max (isnull(_pgPartner.PartnerId_pg,0)) as PartnerId_pg, OKPO, UnitId, Main from dba._pgPartner where trim(OKPO) <> '' and _pgPartner.PartnerId_pg <> 0 and UnitId <>0 and Main <> 0 group by OKPO, UnitId, Main
                     ) as _pgPartner on _pgPartner.UnitId = Bill.ToId -- _find
/*
     left outer join (select max (isnull(_pgPartner.PartnerId_pg,0)) as PartnerId_pg, OKPO, Main
                      from dba._pgPartner
                      where JuridicalId_pg<>0 and _pgPartner.PartnerId_pg <> 0 and UnitId <>0
                      group by OKPO, Main
                     ) as _pgPartner on _pgPartner.OKPO = _pgPartner_find.OKPO
                                    and _pgPartner.Main = _pgPartner_find.Main
*/
     left outer join dba.Unit AS UnitTo on UnitTo.Id = Bill.ToId

     -- left outer join dba._pgUnit as pgUnitTo on pgUnitTo.Id=UnitTo.pgUnitId
     left outer join dba._pgPersonal as pgPersonalFrom on pgPersonalFrom.Id = UnitFrom.PersonalId_Postgres
                                                      and 1=0
     left outer join dba.MoneyKind on MoneyKind.Id = Bill.MoneyKindId
     -- left outer join dba.Unit as Unit_RouteSorting on Unit_RouteSorting.Id = Bill.RouteUnitId
     -- left outer join dba._pgPersonal on _pgPersonal.Id = Unit_RouteSorting.PersonalId_Postgres
     left outer join dba._toolsView_Client_isChangeDate on _toolsView_Client_isChangeDate.ClientId = UnitTo.ID
                                                          and 1=0
     -- left outer join dba._pgInfoMoney on _pgInfoMoney.ObjectCode = 30201

/*
  and (((UnitFrom.pgUnitId is not null
     or UnitFrom.PersonalId_Postgres is not null
     or pgUnitFrom.Id_Postgres_Branch is not null)
    and (UnitTo.pgUnitId is null
     and UnitTo.PersonalId_Postgres is null
     and pgUnitTo.Id_Postgres_Branch is null)
     and isnull(UnitFrom.ParentId,0)<>4137 -- ÃŒ À»÷¿-¬—≈
     and isnull(UnitTo.ParentId,0)<>4137) -- ÃŒ À»÷¿-¬—≈
     or Bill.BillKind = zc_bkSaleToClient())
-- and Bill.Id_Postgres is not null
*/
;

   // 
   -- result
   select isnull(_tmpList2.ObjectId, _tmpList.ObjectId)as ObjectId
        , ifnull(_tmpList2.ObjectId, _tmpList.ObjectId, 0) as BillId
        , isnull(_tmpList2.OperDate, _tmpList.OperDate)as OperDate
        , isnull(_tmpList2.InvNumber_all, _tmpList.InvNumber_all) as InvNumber
        , _tmpList.BillNumberClient1 as BillNumberClient1
        , isnull(_tmpList2.OperDatePartner, _tmpList.OperDatePartner)as OperDatePartner
        , isnull(_tmpList2.PriceWithVAT, _tmpList.PriceWithVAT)as PriceWithVAT
        , isnull(_tmpList2.VATPercent, _tmpList.VATPercent)as VATPercent
        , isnull(_tmpList2.ChangePercent, _tmpList.ChangePercent)as ChangePercent
        , isnull(_tmpList2.FromId_Postgres, _tmpList.FromId_Postgres)as FromId_Postgres
        , isnull(_tmpList2.ToId_Postgres, _tmpList.ToId_Postgres)as ToId_Postgres
        , _tmpList.ClientId as ClientId
        , isnull(_tmpList2.PaidKindId_Postgres, _tmpList.PaidKindId_Postgres)as PaidKindId_Postgres
        , isnull(_tmpList2.CodeIM, _tmpList.CodeIM)as CodeIM
        , isnull (_tmpList.ContractNumber, '') as ContractNumber
        , isnull(_tmpList2.CarId, _tmpList.CarId)as CarId
        , isnull(_tmpList2.PersonalDriverId, _tmpList.PersonalDriverId) as PersonalDriverId
        , isnull(_tmpList2.RouteId, _tmpList.RouteId) as RouteId
        , isnull(_tmpList2.RouteSortingId_Postgres, _tmpList.RouteSortingId_Postgres) as RouteSortingId_Postgres
        , isnull(_tmpList2.PersonalId_Postgres, _tmpList.PersonalId_Postgres) as PersonalId_Postgres
        , isnull(_tmpList2.isFl, _tmpList.isFl) as isFl
        , zc_rvYes() as zc_rvYes
        , isnull(_tmpList2.Id_Postgres, _tmpList.Id_Postgres) as Id_Postgres
   from _tmpList left outer join _tmpList as _tmpList2 on 1=0  --_tmpList2.ObjectId = _tmpList.BillId_pg
   group by ObjectId, BillId, InvNumber, BillNumberClient1, OperDate, OperDatePartner, PriceWithVAT, VATPercent, ChangePercent, FromId_Postgres, ToId_Postgres, ClientId, PaidKindId_Postgres
          , CodeIM, ContractNumber, CarId, PersonalDriverId, RouteId, RouteSortingId_Postgres, PersonalId_Postgres, isFl, Id_Postgres
   order by 3, 4, 1
   ;

end
//
-- call dba._pgSelect_Bill_Sale ('2013-07-01', '2013-07-07')
