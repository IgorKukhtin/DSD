create PROCEDURE "DBA"."_pgSelect_Bill_Sale" (in @inStartDate date, in @inEndDate date)
result(ObjectId Integer, BillId Integer, OperDate Date, InvNumber TVarCharLongLong, OperDatePartner Date, PriceWithVAT smallint, VATPercent TSumm, ChangePercent  TSumm, FromId_Postgres Integer, ToId_Postgres Integer
     , PaidKindId_Postgres Integer, CodeIM Integer, CarId Integer, PersonalDriverId Integer, RouteId Integer, RouteSortingId_Postgres Integer, PersonalId_Postgres Integer
     , isFl smallint, zc_rvYes smallint, Id_Postgres integer)
begin
  declare local temporary table _tmpList(
       ObjectId Integer
     , BillId_pg Integer null
     , InvNumber_all TVarCharLongLong
     , InvNumber integer
     , OperDate Date
     , OperDatePartner Date

     , PriceWithVAT smallint
     , VATPercent TSumm
     , ChangePercent  TSumm

     , FromId_Postgres Integer
     , ToId_Postgres Integer
     , PaidKindId_Postgres Integer
     , ContractId Integer
     , CarId Integer
     , PersonalDriverId Integer

     , RouteId  Integer
     , RouteSortingId_Postgres  Integer
     , PersonalId_Postgres  Integer
     , isFl smallint
     , Id_Postgres integer
  ) on commit preserve rows;

insert into _tmpList (ObjectId, InvNumber_all, InvNumber, OperDate, OperDatePartner, PriceWithVAT, VATPercent, ChangePercent, FromId_Postgres, ToId_Postgres
                    , PaidKindId_Postgres, ContractId, CarId, PersonalDriverId, RouteId, RouteSortingId_Postgres, PersonalId_Postgres, isFl, Id_Postgres)
select Bill.Id as ObjectId

     , cast (Bill.BillNumber as TVarCharMedium) ||
       case when FromId_Postgres is null or ToId_Postgres is null or ContractId = 0
                 then '-������' || case when FromId_Postgres is null then '-�� ����:' || UnitFrom.UnitName else '' end
                                || case when ToId_Postgres is null then '-����:' || UnitTo.UnitName else '' end
                                || case when ContractId = 0 then '-�������:???' else '' end
            else ''
       end as InvNumber_all
     , Bill.BillNumber as InvNumber

     , Bill.BillDate as OperDate
     , OperDate + isnull(_toolsView_Client_isChangeDate.addDay,0) as OperDatePartner

     , Bill.isNds as PriceWithVAT
     , Bill.Nds as VATPercent
     , case when Bill.isByMinusDiscountTax=zc_rvYes() then -Bill.DiscountTax else Bill.DiscountTax end as ChangePercent

     , isnull(pgPersonalFrom.Id2_Postgres, pgUnitFrom.Id_Postgres) as FromId_Postgres
     , _pgPartner.PartnerId_pg as ToId_Postgres
     , case when Bill.MoneyKindId=zc_mkBN() then 3 else 4 end as PaidKindId_Postgres
     , AS CodeIM 
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
       group by BillId;
     ) as Bill_find
     left outer join dba.Bill on Bill.Id = Bill_find.Id
     left outer join dba.Unit AS UnitFrom on UnitFrom.Id = Bill.FromId
     left outer join dba._pgUnit as pgUnitFrom on pgUnitFrom.Id=UnitFrom.pgUnitId

     left outer join (select JuridicalId_pg, PartnerId_pg, UnitId from dba._pgPartner where PartnerId_pg <> 0 and UnitId <>0 group by JuridicalId_pg, PartnerId_pg, UnitId
                     ) as _pgPartner on _pgPartner.UnitId = Bill.ToId
     left outer join dba.Unit AS UnitTo on UnitTo.Id = Bill.ToId

     -- left outer join dba._pgUnit as pgUnitTo on pgUnitTo.Id=UnitTo.pgUnitId
     left outer join dba._pgPersonal as pgPersonalFrom on pgPersonalFrom.Id = UnitFrom.PersonalId_Postgres
                                                      and 1=0
     left outer join dba.MoneyKind on MoneyKind.Id = Bill.MoneyKindId
     -- left outer join dba.Unit as Unit_RouteSorting on Unit_RouteSorting.Id = Bill.RouteUnitId
     -- left outer join dba._pgPersonal on _pgPersonal.Id = Unit_RouteSorting.PersonalId_Postgres
     left outer join dba._toolsView_Client_isChangeDate on _toolsView_Client_isChangeDate.ClientId = UnitTo.ID
                                                          and 1=0

/*
  and (((UnitFrom.pgUnitId is not null
     or UnitFrom.PersonalId_Postgres is not null
     or pgUnitFrom.Id_Postgres_Branch is not null)
    and (UnitTo.pgUnitId is null
     and UnitTo.PersonalId_Postgres is null
     and pgUnitTo.Id_Postgres_Branch is null)
     and isnull(UnitFrom.ParentId,0)<>4137 -- �� ����-���
     and isnull(UnitTo.ParentId,0)<>4137) -- �� ����-���
     or Bill.BillKind = zc_bkSaleToClient())
-- and Bill.Id_Postgres is not null
*/
union all
select Bill.Id as ObjectId
     , case when FromId_Postgres is null then '������ �����-' +fUnit.UnitName + '-'
            when isnull(Bill.BillId_byLoad,0)<>0 then '������ ��� � Int-'
            else ''
       end + cast (Bill.BillNumber as TVarCharMedium)+'-f' as InvNumber_all
     , Bill.BillNumber as InvNumber
     , Bill.BillDate - isnull(_toolsView_Client_isChangeDate.addDay,0) as OperDate

     , Bill.BillDate as OperDatePartner

     , Bill.isNds as PriceWithVAT
     , Bill.Nds as VATPercent
     , case when Bill.isByMinusDiscountTax=zc_rvYes() then -Bill.DiscountTax else Bill.DiscountTax end as ChangePercent

     , isnull(pgPersonalFrom.Id2_Postgres, pgUnitFrom.Id_Postgres) as FromId_Postgres
     , UnitTo.Id3_Postgres as ToId_Postgres
     , MoneyKind.Id_Postgres as PaidKindId_Postgres
     , null as ContractId
     , null as CarId
     , null as PersonalDriverId

     , null as RouteId
     , case when isnull(Bill.RouteUnitId,0) = Bill.ToId then ToId_Postgres else Unit_RouteSorting.Id_Postgres_RouteSorting end as RouteSortingId_Postgres
     , _pgPersonal.Id2_Postgres as PersonalId_Postgres

     , zc_rvYes() as isFl

     , Bill.Id_Postgres as Id_Postgres
from dba.fBill as Bill
     left outer join dba.Bill AS Bill_find on Bill_find.Id = Bill.BillId_byLoad

     left outer join dba._fUnit_byLoadView AS fUnitFrom on fUnitFrom.UnitId = Bill.FromId and fUnitFrom.Id_byLoad <> 0
     left outer join dba._fUnit_byLoadView AS fUnitTo on fUnitTo.UnitId = Bill.ToId and fUnitTo.Id_byLoad <> 0

     left outer join dba.fUnit on fUnit.Id = Bill.FromId

     left outer join dba.Unit AS UnitFrom on UnitFrom.Id = fUnitFrom.Id_byLoad
     left outer join dba.Unit AS UnitTo on UnitTo.Id = fUnitTo.Id_byLoad

     left outer join dba._pgUnit as pgUnitFrom on pgUnitFrom.Id=UnitFrom.pgUnitId
     left outer join dba._pgUnit as pgUnitTo on pgUnitTo.Id=UnitTo.pgUnitId
     left outer join dba._pgPersonal as pgPersonalFrom on pgPersonalFrom.Id=UnitFrom.PersonalId_Postgres
                                                      and pgPersonalFrom.Id2_Postgres>0
     left outer join dba.MoneyKind on MoneyKind.Id = Bill.MoneyKindId
     left outer join dba.Unit as Unit_RouteSorting on Unit_RouteSorting.Id = Bill.RouteUnitId and 1=0
     left outer join dba._pgPersonal on _pgPersonal.Id = Unit_RouteSorting.PersonalId_Postgres
     left outer join dba._toolsView_Client_isChangeDate on _toolsView_Client_isChangeDate.ClientId = UnitTo.ID
where Bill.BillDate between @inStartDate and @inEndDate
-- and Bill.BillNumber = 121710
  and Bill_find.Id is null
  and Bill.BillKind in (zc_bkSaleToClient())
  and Bill.FromId<>1022 -- ������ 1
  and Bill.FromId<>1037 -- ������ 1037
  and Bill.ToId<>1022 -- ������ 1
  and Bill.ToId<>1037 -- ������ 1037
-- and 1=0
;

   //
   update _tmpList  set  _tmpList.BillId_pg = _tmpList2.BillId_pg
   from (select max (ObjectId) as BillId_pg, InvNumber, OperDate, PriceWithVAT, VATPercent, ChangePercent, FromId_Postgres, ToId_Postgres, PaidKindId_Postgres from _tmpList where isFl = zc_rvNo() group by InvNumber, OperDate, PriceWithVAT, VATPercent, ChangePercent, FromId_Postgres, ToId_Postgres, PaidKindId_Postgres having count()>1) as _tmpList2
   where isFl = zc_rvNo()
     and _tmpList.InvNumber = _tmpList2.InvNumber
     and _tmpList.OperDate = _tmpList2.OperDate
     and _tmpList.PriceWithVAT = _tmpList2.PriceWithVAT
     and _tmpList.VATPercent = _tmpList2.VATPercent
     and _tmpList.ChangePercent = _tmpList2.ChangePercent
     and _tmpList.FromId_Postgres = _tmpList2.FromId_Postgres
     and _tmpList.ToId_Postgres = _tmpList2.ToId_Postgres
     and _tmpList.PaidKindId_Postgres = _tmpList2.PaidKindId_Postgres
   ;
   //
   update dba.Bill left outer join _tmpList on _tmpList.ObjectId = Bill.Id set Bill.BillId_pg   = _tmpList.BillId_pg
   where Bill.BillDate between @inStartDate and @inEndDate;
   // 
   -- result
   select isnull(_tmpList2.ObjectId, _tmpList.ObjectId)as ObjectId
        , ifnull(_tmpList2.ObjectId, _tmpList.ObjectId, 0) as BillId
        , isnull(_tmpList2.OperDate, _tmpList.OperDate)as OperDate
        , isnull(_tmpList2.InvNumber_all, _tmpList.InvNumber_all) as InvNumber
        , isnull(_tmpList2.OperDatePartner, _tmpList.OperDatePartner)as OperDatePartner
        , isnull(_tmpList2.PriceWithVAT, _tmpList.PriceWithVAT)as PriceWithVAT
        , isnull(_tmpList2.VATPercent, _tmpList.VATPercent)as VATPercent
        , isnull(_tmpList2.ChangePercent, _tmpList.ChangePercent)as ChangePercent
        , isnull(_tmpList2.FromId_Postgres, _tmpList.FromId_Postgres)as FromId_Postgres
        , isnull(_tmpList2.ToId_Postgres, _tmpList.ToId_Postgres)as ToId_Postgres
        , isnull(_tmpList2.PaidKindId_Postgres, _tmpList.PaidKindId_Postgres)as PaidKindId_Postgres
        , isnull(_tmpList2.ContractId, _tmpList.ContractId)as ContractId
        , isnull(_tmpList2.CarId, _tmpList.CarId)as CarId
        , isnull(_tmpList2.PersonalDriverId, _tmpList.PersonalDriverId) as PersonalDriverId
        , isnull(_tmpList2.RouteId, _tmpList.RouteId) as RouteId
        , isnull(_tmpList2.RouteSortingId_Postgres, _tmpList.RouteSortingId_Postgres) as RouteSortingId_Postgres
        , isnull(_tmpList2.PersonalId_Postgres, _tmpList.PersonalId_Postgres) as PersonalId_Postgres
        , isnull(_tmpList2.isFl, _tmpList.isFl) as isFl
        , zc_rvYes() as zc_rvYes
        , isnull(_tmpList2.Id_Postgres, _tmpList.Id_Postgres) as Id_Postgres
   from _tmpList left outer join _tmpList as _tmpList2 on _tmpList2.ObjectId = _tmpList.BillId_pg
   group by ObjectId, BillId, InvNumber, OperDate, OperDatePartner, PriceWithVAT, VATPercent, ChangePercent, FromId_Postgres, ToId_Postgres, PaidKindId_Postgres
          , ContractId, CarId, PersonalDriverId, RouteId, RouteSortingId_Postgres, PersonalId_Postgres, isFl, Id_Postgres
   order by 3, 4, 1
   ;

end
//
-- call dba._pgSelect_Bill_Sale ('2013-07-01', '2013-07-07')