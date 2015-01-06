-- Int - BN
alter  PROCEDURE "DBA"."_pgSelect_Bill_Sale" (in @inStartDate date, in @inEndDate date)
result(ObjectId Integer, BillId Integer, OperDate Date, InvNumber_my Integer, InvNumber TVarCharLongLong, BillNumberClient1 TVarCharLongLong, OperDatePartner Date, PriceWithVAT smallint, VATPercent TSumm, ChangePercent  TSumm
     , FromId_Postgres Integer, ToId_Postgres Integer, FromId Integer, ClientId Integer
     , MoneyKindId Integer, PaidKindId_Postgres Integer, CodeIM Integer, ContractNumber TVarCharMedium, CarId Integer, PersonalDriverId Integer, RouteId_pg Integer, RouteSortingId_pg Integer, PersonalId_Postgres Integer
     , PriceListId_pg Integer
     , isOnlyUpdateInt smallint, isTare smallint, zc_rvYes smallint, Id_Postgres integer)
begin
  declare local temporary table _tmpBill_Scale(
       BillId Integer
     , primary key(BillId)
  ) on commit preserve rows;
  declare local temporary table _tmpPrice_Scale(
       BillId Integer
     , PriceListId Integer
     , primary key(BillId)
  ) on commit preserve rows;
  //
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
     , FromId Integer
     , ClientId Integer

     , MoneyKindId Integer
     , PaidKindId_Postgres Integer
     , CodeIM Integer
     , ContractNumber TVarCharMedium
     , CarId Integer
     , PersonalDriverId Integer

     , RouteId_pg  Integer
     , RouteSortingId_pg Integer
     , PersonalId_Postgres  Integer
     , isOnlyUpdateInt smallint
     , isTare smallint
     , Id_Postgres integer
  ) on commit preserve rows;
   //
   // 
   insert into _tmpPrice_Scale (BillId, PriceListId)
     select BillId, PriceListId
     from
      (select BillId, max (isnull(PriceListId, 0)) AS PriceListId
       from dba.ScaleHistory_byObvalka
       where InsertDate between @inStartDate-2 and @inEndDate+2
         and BillId <> 0
       group by BillId
     union 
       select BillId, max (isnull(PriceListId, 0)) AS PriceListId
       from dba.ScaleHistory
       where InsertDate between @inStartDate-2 and @inEndDate+2
         and BillId <> 0
       group by BillId
      ) as tmp;
   //
   insert into _tmpBill_Scale(BillId)
     select Id
     from
      (select Bill.Id, Bill.BillDate, max (fCalcCurrentBillDate_byPG (ScaleHistory_byObvalka.InsertDate,zc_rpTimeRemainsFree_H04(*)) ) as BillDate_calc
       from dba.Bill
            join dba.ScaleHistory_byObvalka on ScaleHistory_byObvalka.BillId=Bill.Id
       where Bill.BillDate between @inStartDate-3 and @inEndDate+3
         and Bill.BillKind = zc_bkSaleToClient()
       group by Bill.Id, Bill.BillDate
       having Bill.BillDate <> BillDate_calc
     union 
      select Bill.Id, Bill.BillDate, max (fCalcCurrentBillDate_byPG (ScaleHistory.InsertDate,zc_rpTimeRemainsFree_H10(*)) ) as BillDate_calc
       from dba.Bill
            join dba.ScaleHistory on ScaleHistory.BillId=Bill.Id
       where Bill.BillDate between @inStartDate-3 and @inEndDate+3
         and Bill.BillKind = zc_bkSaleToClient()
       group by Bill.Id, Bill.BillDate
       having Bill.BillDate <> BillDate_calc) as a;
 
   //
   --
   delete from dba._pgBillLoad_union;
   --
   if @inStartDate>=zc_def_StartDate_PG() or @inEndDate>=zc_def_StartDate_PG()-2
   then
     delete from dba._pgBillLoad_union;
     --
     -- Œ·˙Â‰ËÌÂÌËÂ √œ
     insert into dba._pgBillLoad_union (BillId, BillId_union, findId)
      select BillId, BillId_union, isnull(findId,0) as findId
      from
      (select Bill.Id as BillId, min (Bill_find.Id) as BillId_union
            , case when Bill.BillDate + isnull (_toolsView_Client_isChangeDate.addDay, 0) < zc_def_StartDate_PG() then zc_rvNo() else zc_rvYes() end as isBillDate
            , max (isnull(case when BillItems2.OperPrice<>0 and BillItems2.OperCount<>0 then BillItems2.Id else 0 end,0))as findId
      from dba.Bill
           left join _toolsView_Client_isChangeDate on _toolsView_Client_isChangeDate.ClientId = Bill.ToId
           left join dba.BillItems on BillItems.BillId = Bill.Id and BillItems.GoodsPropertyId = 5510 and BillItems.OperCount<>0 -- BillItems.OperCount<>0 and BillItems.GoodsPropertyId <> 5510 -- –”À‹ ¿ ¬¿–≈Õ¿ﬂ ‚ Ô‡ÍÂÚÂ ‰Îˇ Á‡ÔÂÍ‡ÌËˇ
           left join dba.BillItems as BillItems2 on BillItems2.BillId = Bill.Id
           left outer join dba.Bill as Bill_find on Bill_find.BillDate = Bill.BillDate
                                                and Bill_find.BillKind = Bill.BillKind
                                                and Bill_find.BillNumber = Bill.BillNumber
                                                and Bill_find.MoneyKindId = Bill.MoneyKindId
                                                and Bill_find.FromId = Bill.FromId
                                                and Bill_find.ToId = Bill.ToId
      where Bill.BillDate between @inStartDate and @inEndDate
        and Bill.BillDate >= zc_def_StartDate_PG() - 2
        and Bill.FromId in (zc_UnitId_StoreSale())
        and Bill.BillKind in (zc_bkSaleToClient())
        and (Bill.MoneyKindId = zc_mkBN())-- or isnull(Bill.Id_Postgres,0) <> 0)
        and BillItems.GoodsPropertyId is null
      group by Bill.Id, Bill.BillDate, isnull (_toolsView_Client_isChangeDate.addDay, 0)
      ) as tmp
      where isBillDate = zc_rvYes();
   end if;

   //
   --
   insert into _tmpList (ObjectId, InvNumber_all, InvNumber, BillNumberClient1, OperDate, OperDatePartner, PriceWithVAT, VATPercent, ChangePercent, FromId_Postgres, ToId_Postgres, FromId, ClientId
                       , MoneyKindId, PaidKindId_Postgres, CodeIM, ContractNumber, CarId, PersonalDriverId, RouteId_pg, RouteSortingId_pg, PersonalId_Postgres, isOnlyUpdateInt, isTare, Id_Postgres)
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
     , Bill.FromId
     , Bill.ToId as ClientId

     , Bill.MoneyKindId
     , case when Bill.MoneyKindId=zc_mkBN() then 3 else 4 end as PaidKindId_Postgres
     , Bill_find.CodeIM -- _pgInfoMoney.Id3_Postgres AS ContractId 
     , isnull (Contract.ContractNumber,'') as ContractNumber
     , null as CarId
     , null as PersonalDriverId

     , _pgRoute.RouteId_pg as RouteId_pg
     , UnitRoute.Id_Postgres_RouteSorting as RouteSortingId_pg
     , null as PersonalId_Postgres

--     , null as RouteId
--     , case when isnull(Bill.RouteUnitId,0) = Bill.ToId then ToId_Postgres else Unit_RouteSorting.Id_Postgres_RouteSorting end as RouteSortingId_Postgres
--     , _pgPersonal.Id2_Postgres as PersonalId_Postgres

     , Bill_find.isOnlyUpdateInt
     , (case when Bill_find.findId<>0 then zc_rvNo() else zc_rvYes() end) as isTare
     , (case when Bill_find.Id_Postgres<>0 then Bill_find.Id_Postgres else Bill.Id_Postgres end) as Id_Postgres

from
      -- —˚¸Â - ¡Õ
     (select Bill.Id, 0 as Id_Postgres, 30201 as CodeIM -- ÃˇÒÌÓÂ Ò˚¸Â
           , max (isnull (find1.Id, isnull (find2.Id,0))) as ContractId_find
           , zc_rvNo() as isOnlyUpdateInt
           , max(isnull(case when BillItems.OperPrice<>0 then BillItems.Id else 0 end,0))as findId
      from dba.Bill
           join dba.BillItems on BillItems.BillId = Bill.Id and BillItems.OperCount<>0
                      left outer join dba.Unit on Unit.Id = Bill.ToId
                      left outer join dba.ContractKind_byHistory as find1
                           on find1.ClientId = Unit.DolgByUnitID
                         and Bill.BillDate between find1.StartDate and find1.EndDate
                         and find1.ContractNumber <> ''
                      left outer join dba.ContractKind_byHistory as find2
                          on find2.ClientId = Unit.Id
                         and Bill.BillDate between find2.StartDate and find2.EndDate
                         and find2.ContractNumber <> ''
      where Bill.BillDate between @inStartDate and @inEndDate
        and Bill.FromId in (zc_UnitId_StoreMaterialBasis(), zc_UnitId_StorePF(), zc_UnitId_StoreSalePF())
        and Bill.BillKind in (zc_bkSaleToClient())
        and (Bill.MoneyKindId = zc_mkBN()) -- or isnull(Bill.Id_Postgres,0) <> 0)
        and Bill.FromId not in (3830, 3304) --  –Œ“ŒÕ ŒŒŒ (ı‡ÌÂÌËÂ) +  –Œ“ŒÕ ŒŒŒ
        and Bill.ToId not in (3830, 3304) --  –Œ“ŒÕ ŒŒŒ (ı‡ÌÂÌËÂ) +  –Œ“ŒÕ ŒŒŒ 
--       and Bill.BillNumber = 1635
--       and Bill.Id = 1260716
       group by Bill.Id
     union
      -- √œ (—˚¸Â) - ¡Õ
      select Bill.Id, 0 as Id_Postgres, 30201 as CodeIM -- ÃˇÒÌÓÂ Ò˚¸Â
           , max (isnull (find1.Id, isnull (find2.Id,0))) as ContractId_find
           , zc_rvYes() as isOnlyUpdateInt
           , max(isnull(case when BillItems.OperPrice<>0 then BillItems.Id else 0 end,0))as findId
      from dba.Bill
           join dba.BillItems on BillItems.BillId = Bill.Id and BillItems.OperCount<>0 and BillItems.GoodsPropertyId = 5510 -- –”À‹ ¿ ¬¿–≈Õ¿ﬂ ‚ Ô‡ÍÂÚÂ ‰Îˇ Á‡ÔÂÍ‡ÌËˇ
                      left outer join dba.Unit on Unit.Id = Bill.ToId
                      left outer join dba.ContractKind_byHistory as find1
                           on find1.ClientId = Unit.DolgByUnitID
                         and Bill.BillDate between find1.StartDate and find1.EndDate
                         and find1.ContractNumber <> ''
                      left outer join dba.ContractKind_byHistory as find2
                          on find2.ClientId = Unit.Id
                         and Bill.BillDate between find2.StartDate and find2.EndDate
                         and find2.ContractNumber <> ''
      where Bill.BillDate between @inStartDate and @inEndDate
        and Bill.FromId in (zc_UnitId_StoreSale())
        and Bill.BillKind in (zc_bkSaleToClient())
        and (Bill.MoneyKindId = zc_mkBN()) -- or isnull(Bill.Id_Postgres,0) <> 0)
--       and Bill.BillNumber = 1635
--       and Bill.Id = 1260716
      group by Bill.Id
     union
      -- √œ - ¡Õ
      select BillId_union AS Id, max  (isnull(Bill.Id_Postgres,0)) as Id_Postgres, 30101 as CodeIM -- √ÓÚÓ‚‡ˇ ÔÓ‰ÛÍˆËˇ
           , max (isnull (find1.Id, isnull (find2.Id,0))) as ContractId_find
           , zc_rvYes() as isOnlyUpdateInt
           , max (_pgBillLoad_union.findId) as findId
      from dba._pgBillLoad_union
            join dba.Bill on Bill.Id = _pgBillLoad_union.BillId
                      left outer join dba.Unit on Unit.Id = Bill.ToId
                      left outer join dba.ContractKind_byHistory as find1
                           on find1.ClientId = Unit.DolgByUnitID
                         and Bill.BillDate between find1.StartDate and find1.EndDate
                         and find1.ContractNumber <> ''
                      left outer join dba.ContractKind_byHistory as find2
                          on find2.ClientId = Unit.Id
                         and Bill.BillDate between find2.StartDate and find2.EndDate
                         and find2.ContractNumber <> ''
      group by BillId_union
     union
      -- ¬—≈ zc_bkSendUnitToUnit - ¡Õ and (isUnitTo.UnitId - ÌÂÚ)
      select Bill.Id, 0 as Id_Postgres, 30101 as CodeIM -- √ÓÚÓ‚‡ˇ ÔÓ‰ÛÍˆËˇ
           , max (isnull (find1.Id, isnull (find2.Id,0))) as ContractId_find
           , zc_rvNo() as isOnlyUpdateInt
           , max(isnull(case when BillItems.OperPrice<>0 then BillItems.Id else 0 end,0))as findId
      from dba.Bill
           left join dba.isUnit on isUnit.UnitId = Bill.ToId
           join dba.BillItems on BillItems.BillId = Bill.Id and BillItems.OperCount<>0
                      left outer join dba.Unit on Unit.Id = Bill.ToId
                      left outer join dba.ContractKind_byHistory as find1
                           on find1.ClientId = Unit.DolgByUnitID
                         and Bill.BillDate between find1.StartDate and find1.EndDate
                         and find1.ContractNumber <> ''
                      left outer join dba.ContractKind_byHistory as find2
                          on find2.ClientId = Unit.Id
                         and Bill.BillDate between find2.StartDate and find2.EndDate
                         and find2.ContractNumber <> ''
      where Bill.BillDate between @inStartDate and @inEndDate
        -- and Bill.FromId in (zc_UnitId_StoreSale())
        and Bill.BillKind in (zc_bkSendUnitToUnit())
        and (Bill.MoneyKindId = zc_mkBN()) --  or isnull(Bill.Id_Postgres,0) <> 0)
        and isUnit.UnitId is null
      group by Bill.Id
     ) as Bill_find

     left outer join dba.Bill on Bill.Id = Bill_find.Id
     /*left outer join (SELECT max (isnull (find1.Id, isnull (find2.Id,0))) as Id, Unit.Id as ClientId
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
                     ) as Contract_find on Contract_find.ClientId = Bill.ToId*/
     left outer join dba.ContractKind_byHistory as Contract on Contract.Id = Bill_find.ContractId_find -- Contract_find.Id

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
     left outer join dba.Unit AS UnitRoute on UnitRoute.Id = Bill.RouteUnitID
     left outer join dba.RouteGroup on RouteGroup.Id = UnitRoute.RouteGroupId
     left outer join dba._pgRoute on _pgRoute.Id = RouteGroup.RouteId_pg

     -- left outer join dba._pgUnit as pgUnitTo on pgUnitTo.Id=UnitTo.pgUnitId
     left outer join dba._pgPersonal as pgPersonalFrom on pgPersonalFrom.Id = UnitFrom.PersonalId_Postgres
                                                      and 1=0
     left outer join dba.MoneyKind on MoneyKind.Id = Bill.MoneyKindId
     -- left outer join dba.Unit as Unit_RouteSorting on Unit_RouteSorting.Id = Bill.RouteUnitId
     -- left outer join dba._pgPersonal on _pgPersonal.Id = Unit_RouteSorting.PersonalId_Postgres
     left outer join _tmpBill_Scale on _tmpBill_Scale.BillId = Bill_find.Id
     left outer join dba._toolsView_Client_isChangeDate on _toolsView_Client_isChangeDate.ClientId = UnitTo.ID
                                                       and _tmpBill_Scale.BillId is null
                                                          -- and 1=0
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
        , isnull(_tmpList2.InvNumber, _tmpList.InvNumber) as InvNumber_my
        , isnull(_tmpList2.InvNumber_all, _tmpList.InvNumber_all) as InvNumber
        , _tmpList.BillNumberClient1 as BillNumberClient1
        , isnull(_tmpList2.OperDatePartner, _tmpList.OperDatePartner)as OperDatePartner
        , isnull(_tmpList2.PriceWithVAT, _tmpList.PriceWithVAT)as PriceWithVAT
        , isnull(_tmpList2.VATPercent, _tmpList.VATPercent)as VATPercent
        , isnull(_tmpList2.ChangePercent, _tmpList.ChangePercent)as ChangePercent
        , isnull(_tmpList2.FromId_Postgres, _tmpList.FromId_Postgres)as FromId_Postgres
        , isnull(_tmpList2.ToId_Postgres, _tmpList.ToId_Postgres)as ToId_Postgres
        , _tmpList.FromId as FromId
        , _tmpList.ClientId as ClientId
        , _tmpList.MoneyKindId as MoneyKindId
        , isnull(_tmpList2.PaidKindId_Postgres, _tmpList.PaidKindId_Postgres)as PaidKindId_Postgres
        , isnull(_tmpList2.CodeIM, _tmpList.CodeIM)as CodeIM
        , isnull (_tmpList.ContractNumber, '') as ContractNumber
        , isnull(_tmpList2.CarId, _tmpList.CarId)as CarId
        , isnull(_tmpList2.PersonalDriverId, _tmpList.PersonalDriverId) as PersonalDriverId
        , _tmpList.RouteId_pg as RouteId_pg
        , _tmpList.RouteSortingId_pg as RouteSortingId_pg
        , isnull(_tmpList2.PersonalId_Postgres, _tmpList.PersonalId_Postgres) as PersonalId_Postgres
        , PriceList_byHistory.Id_Postgres as PriceListId_pg
        , _tmpList.isOnlyUpdateInt
        , _tmpList.isTare
        , zc_rvYes() as zc_rvYes
        , isnull(_tmpList2.Id_Postgres, _tmpList.Id_Postgres) as Id_Postgres
   from _tmpList left outer join _tmpList as _tmpList2 on 1=0  --_tmpList2.ObjectId = _tmpList.BillId_pg
        left outer join _tmpPrice_Scale on _tmpPrice_Scale.BillId = _tmpList.ObjectId
        left outer join dba.PriceList_byHistory on PriceList_byHistory.Id = _tmpPrice_Scale.PriceListId
   group by ObjectId, BillId, InvNumber_my, InvNumber, BillNumberClient1, OperDate, OperDatePartner, PriceWithVAT, VATPercent, ChangePercent, FromId_Postgres, ToId_Postgres, FromId, ClientId, MoneyKindId, PaidKindId_Postgres
          , CodeIM, ContractNumber, CarId, PersonalDriverId, RouteId_pg, RouteSortingId_pg, PersonalId_Postgres, _tmpList.isTare, _tmpList.isOnlyUpdateInt, PriceListId_pg, Id_Postgres
   order by 3, 4, CodeIM, 1
   ;

end
//
-- select * from dba._pgSelect_Bill_Sale ('2014-12-25', '2014-12-25') as a where InvNumber_my = 206764
/*
create table dba._pgBillLoad_union (BillId Integer, BillId_union Integer);
*/
