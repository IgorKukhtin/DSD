alter PROCEDURE "DBA"."_pgSelect_Bill_Sale" (in @inStartDate date, in @inEndDate date)
result(ObjectId Integer, BillId Integer, InvNumber TVarCharLongLong, BillNumberClient1 TVarCharLongLong, OperDate Date, OperDatePartner Date, PriceWithVAT smallint, VATPercent TSumm, ChangePercent  TSumm, FromId_Postgres Integer, ToId_Postgres Integer
     , PaidKindId_Postgres Integer, ContractId Integer, CarId Integer, PersonalDriverId Integer, RouteId Integer, RouteSortingId_Postgres Integer, PersonalId_Postgres Integer
     , isFl smallint, StatusId smallint, zc_rvYes smallint, Id_Postgres integer)
begin
  declare local temporary table _tmpBill_NotNalog(
       BillId Integer not null
     , CodeIM Integer not null
  ) on commit preserve rows;
  //
  declare local temporary table _tmpList(
       ObjectId Integer
     , BillId_calc Integer null
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
     , PaidKindId_Postgres Integer
     , ContractId Integer
     , CarId Integer
     , PersonalDriverId Integer

     , RouteId  Integer
     , RouteSortingId_Postgres  Integer
     , PersonalId_Postgres  Integer
     , isFl smallint
     , StatusId smallint
     , Id_Postgres integer
  ) on commit preserve rows;

  insert into _tmpBill_NotNalog (BillId, CodeIM)
           select Bill.Id as BillId, max(case when isnull(Goods.ParentId,0) = 1730 then 30103 else 30101 end) as CodeIM
           from dba.Bill
                join dba.BillItems on BillItems.BillId = Bill.Id and BillItems.OperCount<>0
                left join dba.GoodsProperty on GoodsProperty.Id = BillItems.GoodsPropertyId
                left join dba.Goods on Goods.Id = GoodsProperty.GoodsId
           where Bill.BillDate between @inStartDate and @inEndDate
             and Bill.BillKind in (zc_bkSaleToClient())
         -- and Bill.BillNumber = 121710
/*            and Bill.FromId<>1022 -- ������ 1
            and Bill.FromId<>1037 -- ������ 1037
            and Bill.ToId<>1037 -- ������ 1037
            and Bill.ToId<>1037 -- ������ 1037*/
            and Bill.MoneyKindId = zc_mkBN()
            and Bill.Id <> 1634846
         -- and 1=0
           group by BillId;
/*
 update dba.Bill left outer join _tmpBill_NotNalog on _tmpBill_NotNalog.BillId = Bill.Id
        set Bill.Id_Postgres = null
 where Bill.BillDate between @inStartDate and @inEndDate
   and Bill.BillKind in (zc_bkSaleToClient())
   and Bill.FromId<>1022 -- ������ 1
   and Bill.FromId<>1037 -- ������ 1037
   and Bill.ToId<>1022 -- ������ 1
   and Bill.ToId<>1037 -- ������ 1037
   and Bill.MoneyKindId = zc_mkBN()
   and _tmpBill_NotNalog.BillId is null
   and Bill.Id_Postgres is not null
   and Bill.Id <> 1634846;


 SELECT * FROM Movement where Descid = zc_Movement_ReturnIn() and OperDate between '01.12.2013' and '31.12.2013'
and StatusId = zc_Enum_Status_UnComplete()
 

 update Movement set StatusId = zc_Enum_Status_Erased() where Descid = zc_Movement_ReturnIn() and OperDate between '01.12.2013' and '31.12.2013'
and StatusId = zc_Enum_Status_UnComplete()

 update dba.Bill
        left outer join (select Bill.Id as BillId
                         from dba.Bill'
                              join dba.BillItems on BillItems.BillId = Bill.Id and BillItems.OperCount<>0
                         where Bill.BillDate '2013-12-01' and '2013-12-31'
                           and Bill.BillKind in (zc_bkReturnToUnit())
                        ) as Bill_find on Bill_find.BillId = Bill.Id
        set Bill.Id_Postgres = null
 where Bill.BillDate between '2013-12-01' and '2013-12-31'
   and Bill.BillKind in (zc_bkReturnToUnit())
   and Bill_find.BillId is null
   and Bill.Id_Postgres is not null;
*/
insert into _tmpList (ObjectId, InvNumber_all, InvNumber, BillNumberClient1, OperDate, OperDatePartner, PriceWithVAT, VATPercent, ChangePercent, FromId_Postgres, ToId_Postgres
                    , PaidKindId_Postgres, ContractId, CarId, PersonalDriverId, RouteId, RouteSortingId_Postgres, PersonalId_Postgres, isFl, StatusId, Id_Postgres)
select Bill.Id as ObjectId
     , cast (Bill.BillNumber as TVarCharMedium) ||
       case when FromId_Postgres is null or ToId_Postgres is null or ContractId is null
                 then '-������' || case when FromId_Postgres is null then '-�� ����:' || UnitFrom.UnitName else '' end
                                || case when ToId_Postgres is null then '-����:' || UnitTo.UnitName else '' end
                                || case when ContractId is null then '-�������:???' else '' end
            else ''
       end as InvNumber_all
     , Bill.BillNumber as InvNumber
     , Bill.BillNumberClient1 as BillNumberClient1
     , isnull (Bill_find.BillDate, Bill.BillDate) as OperDate
     , Bill.BillDate as OperDatePartner

     , Bill.isNds as PriceWithVAT
     , Bill.Nds as VATPercent
     , case when Bill.isByMinusDiscountTax=zc_rvYes() then -Bill.DiscountTax else Bill.DiscountTax end as ChangePercent

     , isnull (pgPersonalFrom.Id_Postgres, pgUnitFrom.Id_Postgres) as FromId_Postgres
     , _pgPartner.PartnerId_pg as ToId_Postgres
     , case when Bill.MoneyKindId=zc_mkBN() then 3 else 4 end as PaidKindId_Postgres
     , isnull (_pgContract_30103.ContractId_pg, isnull (_pgContract_30101.ContractId_pg, 0)) as ContractId
     , null as CarId
     , null as PersonalDriverId

     , null as RouteId
     , null as RouteSortingId_Postgres
     , null as PersonalId_Postgres

     , zc_rvYes() as isFl
     , isnull(Bill.StatusId, zc_rvNo()) as StatusId

     , Bill.Id_Postgres as Id_Postgres

from _tmpBill_NotNalog
     left outer join dba.Bill on Bill.Id = _tmpBill_NotNalog.BillId
     left outer join dba.Bill_i AS Bill_find on Bill_find.Id = Bill.BillId_byLoad
     left outer join (select max (Unit_byLoad.Id_byLoad) as Id_byLoad, UnitId from dba.Unit_byLoad where Unit_byLoad.Id_byLoad <> 0 group by UnitId
                     ) as Unit_byLoad_To on Unit_byLoad_To.UnitId = Bill.ToId
                                        and Bill_find.Id is null
     left outer join (select JuridicalId_pg, PartnerId_pg, UnitId from dba._pgPartner where PartnerId_pg <> 0 and UnitId <>0 group by JuridicalId_pg, PartnerId_pg, UnitId
                     ) as _pgPartner on _pgPartner.UnitId = isnull (Bill_find.ToId, Unit_byLoad_To.Id_byLoad)
     left outer join dba.Unit AS UnitTo on UnitTo.Id = Bill.ToId

     left outer join (select _pgPartner.JuridicalId_pg, max (_pgPartner.ContractId_pg) as ContractId_pg
                      from dba._pgPartner
                      where _pgPartner.JuridicalId_pg <> 0 and _pgPartner.ContractId_pg <> 0 and _pgPartner.CodeIM = '30101'
                      group by _pgPartner.JuridicalId_pg
                     ) as _pgContract_30101 on _pgContract_30101.JuridicalId_pg = _pgPartner.JuridicalId_pg
                                           and _tmpBill_NotNalog.CodeIM = 30101
     left outer join (select _pgPartner.JuridicalId_pg, max (_pgPartner.ContractId_pg) as ContractId_pg
                      from dba._pgPartner
                      where _pgPartner.JuridicalId_pg <> 0 and _pgPartner.ContractId_pg <> 0 and _pgPartner.CodeIM = '30103'
                      group by _pgPartner.JuridicalId_pg
                     ) as _pgContract_30103 on _pgContract_30103.JuridicalId_pg = _pgPartner.JuridicalId_pg
                                           and _tmpBill_NotNalog.CodeIM = 30103
     /*left outer join (select _pgPartner.PartnerId_pg, max (isnull(_pgContract_find.ContractId_pg, _pgPartner.ContractId_pg)) as ContractId_pg
                      from dba._pgPartner
                           left outer join (select _pgPartner.PartnerId_pg, max (_pgPartner.ContractId_pg) as ContractId_pg
                                            from dba._pgPartner
                                            where _pgPartner.PartnerId_pg <> 0 and _pgPartner.ContractId_pg <> 0 and _pgPartner.CodeIM = '30101'
                                            group by _pgPartner.PartnerId_pg
                                           ) as _pgContract_find on _pgContract_find.PartnerId_pg = _pgPartner.PartnerId_pg
                      where _pgPartner.PartnerId_pg <> 0 and _pgPartner.ContractId_pg <> 0
                      group by _pgPartner.PartnerId_pg
                     ) as _pgContract on _pgContract.PartnerId_pg = _pgPartner.PartnerId_pg*/

     left outer join dba.Unit AS UnitFrom on UnitFrom.Id = case when Bill.FromId in (1388, -- '����� �.'
                                                                                     1799, -- '��������'
                                                                                     1288, -- '���� �.'
                                                                                     956, -- '������� �.'
                                                                                     1390, -- '����� �.'
                                                                                     5460, -- '������� �.�.'
                                                                                     324, -- '������� �.'
                                                                                     3010, -- '���������� �.'
                                                                                     5446, -- '�������� ������'
                                                                                     4792, -- '��������� �.�.'
                                                                                     980, -- '������� �.'
                                                                                     2436  -- '������ �.'

                                                                                    ,1022 -- ������ 1
                                                                                    ,1037 -- ������ 1037
                                                                                     )
                                                                     then 5 else Bill.FromId end 
     left outer join dba._pgUnit as pgUnitFrom on pgUnitFrom.Id = UnitFrom.pgUnitId
     left outer join dba._pgPersonal as pgPersonalFrom on pgPersonalFrom.Id = UnitFrom.PersonalId_Postgres
;

   //
/*
   update _tmpList  set  _tmpList.BillId_calc = _tmpList2.BillId_calc
   from (select max (ObjectId) as BillId_calc, InvNumber, OperDate, PriceWithVAT, VATPercent, ChangePercent, FromId_Postgres, ToId_Postgres, PaidKindId_Postgres from _tmpList group by InvNumber, OperDate, PriceWithVAT, VATPercent, ChangePercent, FromId_Postgres, ToId_Postgres, PaidKindId_Postgres having count()>1) as _tmpList2
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
   update dba.Bill left outer join _tmpList on _tmpList.ObjectId = Bill.Id set Bill.BillId_calc   = _tmpList.BillId_calc
   where Bill.BillDate between @inStartDate and @inEndDate;
*/
   // 
   -- result
   select isnull(_tmpList2.ObjectId, _tmpList.ObjectId)as ObjectId
        , ifnull(_tmpList2.ObjectId, _tmpList.ObjectId, 0) as BillId
        , isnull(_tmpList2.InvNumber_all, _tmpList.InvNumber_all) as InvNumber
        , _tmpList.BillNumberClient1 as BillNumberClient1
        , isnull(_tmpList2.OperDate, _tmpList.OperDate)as OperDate
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
        , _tmpList.StatusId as StatusId
        , zc_rvYes() as zc_rvYes
        , isnull(_tmpList2.Id_Postgres, _tmpList.Id_Postgres) as Id_Postgres
   from _tmpList left outer join _tmpList as _tmpList2 on 1=0 -- _tmpList2.ObjectId = _tmpList.BillId_calc
   group by ObjectId, BillId, InvNumber, BillNumberClient1, OperDate, OperDatePartner, PriceWithVAT, VATPercent, ChangePercent, FromId_Postgres, ToId_Postgres, PaidKindId_Postgres
          , ContractId, CarId, PersonalDriverId, RouteId, RouteSortingId_Postgres, PersonalId_Postgres, isFl, StatusId, Id_Postgres
   order by 4, 3, 1
   ;

end
//
-- call dba._pgSelect_Bill_Sale ('2013-12-01', '2013-12-31')