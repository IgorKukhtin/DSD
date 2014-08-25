-- Int - NAL
alter  PROCEDURE "DBA"."_pgSelect_Bill_Sale_NAL" (in @inStartDate date, in @inEndDate date)
result(ObjectId Integer, BillId Integer, OperDate Date, InvNumber TVarCharLongLong, BillNumberClient1 TVarCharLongLong, OperDatePartner Date, PriceWithVAT smallint, VATPercent TSumm, ChangePercent  TSumm
     , FromId_Postgres Integer, ToId_Postgres Integer, FromId Integer, ClientId Integer
     , MoneyKindId Integer, PaidKindId_Postgres Integer, CodeIM Integer, OKPO TVarCharMedium, CarId Integer, PersonalDriverId Integer, RouteId_pg Integer, RouteSortingId_pg Integer, PersonalId_Postgres Integer
     , isOnlyUpdateInt smallint, zc_rvYes smallint, Id_Postgres integer)
begin
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
     , OKPO TVarCharMedium
     , CarId Integer
     , PersonalDriverId Integer

     , RouteId_pg  Integer
     , RouteSortingId_pg Integer
     , PersonalId_Postgres  Integer
     , Id_Postgres integer
  ) on commit preserve rows;
   //
   //
   //
   --
   insert into _tmpList (ObjectId, InvNumber_all, InvNumber, BillNumberClient1, OperDate, OperDatePartner, PriceWithVAT, VATPercent, ChangePercent, FromId_Postgres, ToId_Postgres, FromId, ClientId
                       , MoneyKindId, PaidKindId_Postgres, CodeIM, OKPO, CarId, PersonalDriverId, RouteId_pg, RouteSortingId_pg, PersonalId_Postgres, Id_Postgres)
   select Bill.Id as ObjectId

     , cast (Bill.BillNumber as TVarCharMedium) ||
       case when FromId_Postgres is null or ToId_Postgres is null or CodeIM = 0
                 then '-ошибка' || case when FromId_Postgres is null then '-от кого:' || UnitFrom.UnitName else '' end
                                || case when ToId_Postgres is null then '-кому:' || UnitTo.UnitName else '' end
                                --|| case when CodeIM = 0 then '-УП статья:???' else '' end
            else ''
       end as InvNumber_all
     , Bill.BillNumber as InvNumber
     , Bill.BillNumberClient1 as BillNumberClient1

     , Bill.BillDate as OperDate
     , OperDate + isnull(_toolsView_Client_isChangeDate.addDay,0) as OperDatePartner

     , Bill.isNds as PriceWithVAT
     , Bill.Nds as VATPercent
     , case when Bill.isByMinusDiscountTax=zc_rvYes() then -Bill.DiscountTax else Bill.DiscountTax end as ChangePercent

     , pgUnitFrom.Id_Postgres as FromId_Postgres
     , isnull (_pgPartner.PartnerId_pg, UnitTo.Id3_Postgres) as ToId_Postgres
     , Bill.FromId
     , Bill.ToId as ClientId

     , Bill.MoneyKindId
     , case when Bill.MoneyKindId=zc_mkBN() then 3 else 4 end as PaidKindId_Postgres
     , Bill_find.CodeIM
     , Bill_find.OKPO
     , null as CarId
     , null as PersonalDriverId

     , _pgRoute.RouteId_pg as RouteId_pg
     , UnitRoute.Id_Postgres_RouteSorting as RouteSortingId_pg
     , null as PersonalId_Postgres

--     , null as RouteId
--     , case when isnull(Bill.RouteUnitId,0) = Bill.ToId then ToId_Postgres else Unit_RouteSorting.Id_Postgres_RouteSorting end as RouteSortingId_Postgres
--     , _pgPersonal.Id2_Postgres as PersonalId_Postgres

     , Bill.Id_Postgres as Id_Postgres

from
      -- zc_bkSaleToClient(), zc_bkSendUnitToUnit - НАЛ AND (OKPO <> '') and (isUnitFrom - да) and (isUnitTo - нет) and (UnitTo.PersonalId_Postgres - нет) and (UnitTo.pgUnitId - нет)
     (select Bill.Id
           , Bill.OKPO
           , min (case when Bill.FromId in (zc_UnitId_StoreSale())
                            then 30101 -- Готовая продукция
                       when Bill.FromId in (zc_UnitId_StoreMaterialBasis(), zc_UnitId_StorePF(), zc_UnitId_StoreSalePF())
                            then 30201 -- Мясное сырье
                       when Bill.FromId in (zc_UnitId_StoreReturn(),zc_UnitId_StoreReturnBrak(),zc_UnitId_StoreReturnUtil())
                            then 30301 -- Переработка
                       when GoodsProperty.InfoMoneyCode in (20700)
                            then 30502 -- Прочие товары
                       else 30501 -- Прочие доходы
                  end )as CodeIM
      from (select Bill.Id
                 , Bill.FromId
                 , isnull (Information1.OKPO, isnull (Information2.OKPO, '')) AS OKPO
            from dba.Bill
                 left outer join dba.isUnit AS isUnitFrom on isUnitFrom.UnitId = Bill.FromId
                 left outer join dba.isUnit AS isUnitTo on isUnitTo.UnitId = Bill.ToId
                 left outer join dba.Unit AS UnitTo on UnitTo.Id = Bill.ToId
                 left outer join dba.Unit AS UnitFrom on UnitFrom.Id = Bill.FromId
                 left outer join dba.ClientInformation as Information1 on Information1.ClientID = UnitTo.InformationFromUnitID
                                                                      and Information1.OKPO <> ''
                 left outer join dba.ClientInformation as Information2 on Information2.ClientID = UnitTo.Id
            where Bill.BillDate between @inStartDate and @inEndDate
              and Bill.BillKind in (zc_bkSaleToClient(), zc_bkSendUnitToUnit())
              and Bill.MoneyKindId = zc_mkNal()
              and Bill.FromId not in (3830, 3304) -- КРОТОН ООО (хранение) + КРОТОН ООО
              and Bill.ToId not in (3830, 3304) -- КРОТОН ООО (хранение) + КРОТОН ООО 
              and isUnitFrom.UnitId is not null
              and isUnitTo.UnitId is null
              and (isnull (UnitTo.PersonalId_Postgres, 0) = 0 OR Bill.FromId = zc_UnitId_StoreSale())
              and isnull (UnitTo.pgUnitId, 0) = 0
              and OKPO <> ''
           ) as Bill
           join dba.BillItems on BillItems.BillId = Bill.Id and BillItems.OperCount<>0
           left outer join dba.GoodsProperty on GoodsProperty.Id = BillItems.GoodsPropertyId
                                            and GoodsProperty.InfoMoneyCode not in (20501) --  Оборотная тара
      group by Bill.Id, Bill.OKPO
     ) as Bill_find
     left outer join dba.Bill on Bill.Id = Bill_find.Id

     left outer join dba.Unit AS UnitFrom on UnitFrom.Id = Bill.FromId
     left outer join dba._pgUnit as pgUnitFrom on pgUnitFrom.Id=UnitFrom.pgUnitId

     left outer join (select max (isnull(_pgPartner.PartnerId_pg,0)) as PartnerId_pg, OKPO, UnitId, Main from dba._pgPartner where trim(OKPO) <> '' and _pgPartner.PartnerId_pg <> 0 and UnitId <>0 and Main <> 0 group by OKPO, UnitId, Main
                     ) as _pgPartner on _pgPartner.UnitId = Bill.ToId -- _find

     left outer join dba.Unit AS UnitTo on UnitTo.Id = Bill.ToId
     left outer join dba.Unit AS UnitRoute on UnitRoute.Id = Bill.RouteUnitID
     left outer join dba.RouteGroup on RouteGroup.Id = UnitRoute.RouteGroupId
     left outer join dba._pgRoute on _pgRoute.Id = RouteGroup.RouteId_pg

     left outer join dba.MoneyKind on MoneyKind.Id = Bill.MoneyKindId

     left outer join dba._toolsView_Client_isChangeDate on _toolsView_Client_isChangeDate.ClientId = UnitTo.ID
                                                       and 1=0
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
        , _tmpList.FromId as FromId
        , _tmpList.ClientId as ClientId
        , _tmpList.MoneyKindId as MoneyKindId
        , isnull(_tmpList2.PaidKindId_Postgres, _tmpList.PaidKindId_Postgres)as PaidKindId_Postgres
        , isnull(_tmpList2.CodeIM, _tmpList.CodeIM)as CodeIM
        , isnull(_tmpList2.OKPO, _tmpList.OKPO)as OKPO
        , isnull(_tmpList2.CarId, _tmpList.CarId)as CarId
        , isnull(_tmpList2.PersonalDriverId, _tmpList.PersonalDriverId) as PersonalDriverId
        , _tmpList.RouteId_pg as RouteId_pg
        , _tmpList.RouteSortingId_pg as RouteSortingId_pg
        , isnull(_tmpList2.PersonalId_Postgres, _tmpList.PersonalId_Postgres) as PersonalId_Postgres
        , zc_rvNo()  as isOnlyUpdateInt
        , zc_rvYes() as zc_rvYes
        , isnull(_tmpList2.Id_Postgres, _tmpList.Id_Postgres) as Id_Postgres
   from _tmpList left outer join _tmpList as _tmpList2 on 1=0  --_tmpList2.ObjectId = _tmpList.BillId_pg
   group by ObjectId, BillId, InvNumber, BillNumberClient1, OperDate, OperDatePartner, PriceWithVAT, VATPercent, ChangePercent, FromId_Postgres, ToId_Postgres, FromId, ClientId, MoneyKindId, PaidKindId_Postgres
          , CodeIM, OKPO, CarId, PersonalDriverId, RouteId_pg, RouteSortingId_pg, PersonalId_Postgres, Id_Postgres
   order by 3, 4, CodeIM, 1
   ;

end
//
-- select * from dba._pgSelect_Bill_Sale_NAL ('2014-06-01', '2014-06-30') as a where Id_Postgres <>0
