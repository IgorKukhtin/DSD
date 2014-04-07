-- Fl
alter PROCEDURE "DBA"."_pgSelect_Bill_Sale" (in @inStartDate date, in @inEndDate date)
result(ObjectId Integer, BillId Integer, InvNumber TVarCharLongLong, BillNumberClient1 TVarCharLongLong, BillNumberClient2 TVarCharLongLong, OperDate Date, OperDatePartner Date, PriceWithVAT smallint, VATPercent TSumm, ChangePercent  TSumm
     , FromId_Postgres Integer, ToId_Postgres Integer, ClientId Integer
     , MoneyKindId Integer, PaidKindId_Postgres Integer, CodeIM Integer, ContractNumber TVarCharMedium, CarId Integer, PersonalDriverId Integer, RouteId Integer, RouteSortingId_Postgres Integer, PersonalId_Postgres Integer
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
     , BillNumberClient2 TVarCharLongLong
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
     , MoneyKindId Integer
     , PaidKindId_Postgres Integer
     , CodeIM Integer
     , ContractNumber TVarCharMedium
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
           select Bill.Id as BillId, max(case when isnull(Goods.ParentId,0) = 1730 then 30103 when Goods.Id = 2514 and 1=0 then 30201 else 30101 end) as CodeIM
           from dba.Bill
                join dba.BillItems on BillItems.BillId = Bill.Id and BillItems.OperCount<>0
                                  and BillItems.GoodsPropertyId<>1041 -- ÊÎÂÁÀÑÍI ÂÈÐÎÁÈ
                left join dba.GoodsProperty on GoodsProperty.Id = BillItems.GoodsPropertyId
                left join dba.Goods on Goods.Id = GoodsProperty.GoodsId
           where Bill.BillDate between @inStartDate and @inEndDate
             and Bill.BillKind in (zc_bkSaleToClient())
         -- and Bill.BillNumber = 121710
/*            and Bill.FromId<>1022 -- ÂÈÇÀÐÄ 1
            and Bill.FromId<>1037 -- ÂÈÇÀÐÄ 1037
            and Bill.ToId<>1037 -- ÂÈÇÀÐÄ 1037
            and Bill.ToId<>1037 -- ÂÈÇÀÐÄ 1037*/
            and (Bill.MoneyKindId = zc_mkBN() or isnull(Bill.Id_Postgres,0) <> 0)
            and Bill.Id <> 1634846
         -- and 1=0
           group by BillId;
/*
 update dba.Bill left outer join _tmpBill_NotNalog on _tmpBill_NotNalog.BillId = Bill.Id
        set Bill.Id_Postgres = null
 where Bill.BillDate between @inStartDate and @inEndDate
   and Bill.BillKind in (zc_bkSaleToClient())
   and Bill.FromId<>1022 -- ÂÈÇÀÐÄ 1
   and Bill.FromId<>1037 -- ÂÈÇÀÐÄ 1037
   and Bill.ToId<>1022 -- ÂÈÇÀÐÄ 1
   and Bill.ToId<>1037 -- ÂÈÇÀÐÄ 1037
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
insert into _tmpList (ObjectId, InvNumber_all, InvNumber, BillNumberClient1, BillNumberClient2, OperDate, OperDatePartner, PriceWithVAT, VATPercent, ChangePercent, FromId_Postgres, ToId_Postgres, ClientId
                    , MoneyKindId, PaidKindId_Postgres, CodeIM, ContractNumber, CarId, PersonalDriverId, RouteId, RouteSortingId_Postgres, PersonalId_Postgres, isFl, StatusId, Id_Postgres)
select Bill.Id as ObjectId
     , cast (Bill.BillNumber as TVarCharMedium) ||
       case when FromId_Postgres is null or ToId_Postgres is null or CodeIM = 0
                 then '-îøèáêà' || case when FromId_Postgres is null then '-îò êîãî:' || UnitFrom.UnitName else '' end
                                || case when ToId_Postgres is null then '-êîìó:' || UnitTo.UnitName else '' end
                                || case when CodeIM = 0 then '-ÓÏ ñòàòüÿ:???' else '' end
            else ''
       end as InvNumber_all
     , Bill.BillNumber as InvNumber
     , case when trim(isnull(Bill_find.BillNumberClient1,''))<>'' then Bill_find.BillNumberClient1 else Bill.BillNumberClient1 end as BillNumberClient1
     , Bill.BillNumberClient2 as BillNumberClient2
     , isnull (Bill_find.BillDate, Bill.BillDate) as OperDate
     , Bill.BillDate as OperDatePartner

     , Bill.isNds as PriceWithVAT
     , Bill.Nds as VATPercent
     , case when Bill.isByMinusDiscountTax=zc_rvYes() then -Bill.DiscountTax else Bill.DiscountTax end as ChangePercent

     , isnull (pgPersonalFrom.Id_Postgres, pgUnitFrom.Id_Postgres) as FromId_Postgres
     , _pgPartner.PartnerId_pg as ToId_Postgres
     , Bill.ToId as ClientId
     , Bill.MoneyKindId
     , case when Bill.MoneyKindId=zc_mkBN() then 3 else 4 end as PaidKindId_Postgres
     , _tmpBill_NotNalog.CodeIM as CodeIM -- _pgInfoMoney.Id3_Postgres as ContractId -- isnull (_pgContract_30103.ContractId_pg, isnull (_pgContract_30101.ContractId_pg, 0)) as ContractId
     , isnull(Contract.ContractNumber,'') as ContractNumber
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

     left outer join dba.Bill_i AS Bill_find on Bill_find.Id = Bill.BillId_byLoad
     left outer join (select max (Unit_byLoad.Id_byLoad) as Id_byLoad, UnitId from dba.Unit_byLoad where Unit_byLoad.Id_byLoad <> 0 group by UnitId
                     ) as Unit_byLoad_To on Unit_byLoad_To.UnitId = Bill.ToId
                                        and Bill_find.Id is null
     left outer join (select JuridicalId_pg, PartnerId_pg, UnitId from dba._pgPartner where PartnerId_pg <> 0 and UnitId <>0 group by JuridicalId_pg, PartnerId_pg, UnitId
                     ) as _pgPartner on _pgPartner.UnitId = isnull (Bill_find.ToId, Unit_byLoad_To.Id_byLoad)
     left outer join dba.Unit AS UnitTo on UnitTo.Id = Bill.ToId

     /*left outer join (select _pgPartner.JuridicalId_pg, max (_pgPartner.ContractId_pg) as ContractId_pg
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
                                           and _tmpBill_NotNalog.CodeIM = 30103*/
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

     left outer join dba.Unit AS UnitFrom on UnitFrom.Id = case when Bill.FromId in (1388, -- 'ÃÐÈÂÀ Ð.'
                                                                                     1799, -- 'ÄÐÎÂÎÐÓÁ'
                                                                                     1288, -- 'ÈÙÈÊ Ê.'
                                                                                     956, -- 'ÊÎÆÓØÊÎ Ñ.'
                                                                                     1390, -- 'ÍßÉÊÎ Â.'
                                                                                     5460, -- 'ÎËÅÉÍÈÊ Ì.Â.'
                                                                                     324, -- 'ÑÅÌÅÍÅÂ Ñ.'
                                                                                     3010, -- 'ÒÀÒÀÐ×ÅÍÊÎ Å.'
                                                                                     5446, -- 'ÒÊÀ×ÅÍÊÎ ËÞÁÎÂÜ'
                                                                                     4792, -- 'ÒÐÅÒÜßÊÎÂ Î.Í.'
                                                                                     980, -- 'ÒÓËÅÍÊÎ Ñ.'
                                                                                     2436  -- 'ØÅÂÖÎÂ È.'
                                                                                   , 1374 -- ÁÓÔÀÍÎÂ Ä.

                                                                                    ,1022 -- ÂÈÇÀÐÄ 1
                                                                                    ,1037 -- ÂÈÇÀÐÄ 1037
                                                                                     )
                                                                     then 5 else Bill.FromId end 
     left outer join dba._pgUnit as pgUnitFrom on pgUnitFrom.Id = UnitFrom.pgUnitId
     left outer join dba._pgPersonal as pgPersonalFrom on pgPersonalFrom.Id = UnitFrom.PersonalId_Postgres
     -- left outer join dba._pgInfoMoney on _pgInfoMoney.ObjectCode = _tmpBill_NotNalog.CodeIM
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
        , _tmpList.BillNumberClient2 as BillNumberClient2
        , isnull(_tmpList2.OperDate, _tmpList.OperDate)as OperDate
        , isnull(_tmpList2.OperDatePartner, _tmpList.OperDatePartner)as OperDatePartner
        , isnull(_tmpList2.PriceWithVAT, _tmpList.PriceWithVAT)as PriceWithVAT
        , isnull(_tmpList2.VATPercent, _tmpList.VATPercent)as VATPercent
        , isnull(_tmpList2.ChangePercent, _tmpList.ChangePercent)as ChangePercent
        , isnull(_tmpList2.FromId_Postgres, _tmpList.FromId_Postgres)as FromId_Postgres
        , isnull(_tmpList2.ToId_Postgres, _tmpList.ToId_Postgres)as ToId_Postgres
        , _tmpList.ClientId as ClientId
        , _tmpList.MoneyKindId as MoneyKindId
        , isnull(_tmpList2.PaidKindId_Postgres, _tmpList.PaidKindId_Postgres)as PaidKindId_Postgres
        , isnull(_tmpList2.CodeIM, _tmpList.CodeIM)as CodeIM
        , isnull (_tmpList.ContractNumber, '') as ContractNumber
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
   group by ObjectId, BillId, InvNumber, BillNumberClient1, BillNumberClient2, OperDate, OperDatePartner, PriceWithVAT, VATPercent, ChangePercent, FromId_Postgres, ToId_Postgres, ClientId, MoneyKindId, PaidKindId_Postgres
          , CodeIM, ContractNumber, CarId, PersonalDriverId, RouteId, RouteSortingId_Postgres, PersonalId_Postgres, isFl, StatusId, Id_Postgres
   order by 5, 3, 1
   ;

end
//
-- call dba._pgSelect_Bill_Sale ('2013-12-01', '2013-12-31')
