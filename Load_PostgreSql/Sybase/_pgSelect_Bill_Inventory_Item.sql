alter PROCEDURE "DBA"."_pgSelect_Bill_Inventory_Item" (in @inIsGlobalLoad smallint, in @inStartDate date, in @inEndDate date)
result(ObjectId Integer, MovementId Integer, BillNumber TVarCharShort, BillDate Date, UnitId Integer, GoodsId Integer, Amount TSumm, PartionGoodsDate date, Summ TSumm, HeadCount TSumm, myCount TSumm, PartionGoods TVarCharMedium, GoodsKindId Integer, AssetId Integer, isCar smallint, Id_Postgres Integer)
begin
  --
  declare local temporary table _tmpList_Remains_byKindPackage(
  UnitId integer not null,
  GoodsPropertyId integer not null,
  KindPackageId integer not null,
  PartionDate date not null,
  StartCount TSumm not null,
  StartSummIn TSumm not null,
  EndCount TSumm not null,
  EndSummIn TSumm not null,
  primary key (UnitId,GoodsPropertyId,KindPackageId,PartionDate),
  ) on commit preserve rows;
  --
  declare local temporary table _tmpList_Remains_byPartionStr(
  UnitId integer not null,
  GoodsPropertyId integer not null,
  KindPackageId integer not null,
  PartionStr_MB TVarCharMedium not null,
  StartCount TSumm not null,
  StartCount_sh TSumm not null,
  StartSummIn TSumm not null,
  EndCount TSumm not null,
  EndCount_sh TSumm not null,
  EndSummIn TSumm not null,
  primary key (UnitId,GoodsPropertyId,KindPackageId,PartionStr_MB),
  ) on commit preserve rows;
  //
  -- by Calc ALL remains
  declare local temporary table _tmpList_Unit(
  UnitId integer not null,
  isPartionDate smallint not null,
  BillId integer null,
  primary key(UnitId),
  ) on commit delete rows;
  //
  -- by PartionStr
  declare local temporary table _tmpList_GoodsProperty_isPartion(
  GoodsPropertyId integer not null,
  primary key(GoodsPropertyId),
  ) on commit delete rows;
  declare local temporary table _tmpList_GoodsProperty_isPartion_myRecalc(
  GoodsPropertyId integer not null,
  primary key(GoodsPropertyId),
  ) on commit delete rows;
  -- by remains PartionStr
  declare local temporary table _tmpList_GoodsProperty_isPartionStr_calcRemains(
  GoodsPropertyId integer not null,
  primary key(GoodsPropertyId),
  ) on commit delete rows;
  //
  //
  //
  -- !!!start @inIsGlobalLoad!!!
  if @inIsGlobalLoad=zc_rvYes()
  then
      select 0 as ObjectId
           , _pgCar.MovementId_pg as MovementId
           , _pgCar.Name as BillNumber
           , @inEndDate as OperDate
           , _pgCar.Id as UnitId
           , tmpFuel.Id_Postgres_Fuel as GoodsId
           , isnull(case when tmpFuel.Id_Postgres_Fuel = Goods_7003.Id_Postgres_Fuel then _pgCar.a11
                         when tmpFuel.Id_Postgres_Fuel = Goods_7001.Id_Postgres_Fuel then _pgCar.a21
                         when tmpFuel.Id_Postgres_Fuel = Goods_7004.Id_Postgres_Fuel then _pgCar.a31
                         when tmpFuel.Id_Postgres_Fuel = Goods_7005.Id_Postgres_Fuel then _pgCar.a41
             end, 0) as Amount
           , null as PartionGoodsDate
           , isnull(case when tmpFuel.Id_Postgres_Fuel = Goods_7003.Id_Postgres_Fuel then _pgCar.a12
                         when tmpFuel.Id_Postgres_Fuel = Goods_7001.Id_Postgres_Fuel then _pgCar.a22
                         when tmpFuel.Id_Postgres_Fuel = Goods_7004.Id_Postgres_Fuel then _pgCar.a32
                         when tmpFuel.Id_Postgres_Fuel = Goods_7005.Id_Postgres_Fuel then _pgCar.a42
             end, 0) as Summ
           , 0 as HeadCount
           , 0 as myCount
           , '' as PartionGoods
           , 0 as GoodsKindId
           , 0 as AssetId
           , zc_rvYes() as isCar
           , 0 as Id_Postgres
      from (select Id_Postgres_Fuel from dba.Goods, dba.GoodsProperty where GoodsId = Goods.Id and GoodsCode=7001
           union all
            select Id_Postgres_Fuel from dba.Goods, dba.GoodsProperty where GoodsId = Goods.Id and GoodsCode=7003
           union all
            select Id_Postgres_Fuel from dba.Goods, dba.GoodsProperty where GoodsId = Goods.Id and GoodsCode=7004
           union all
            select Id_Postgres_Fuel from dba.Goods, dba.GoodsProperty where GoodsId = Goods.Id and GoodsCode=7005
           ) as tmpFuel
           left join _pgCar on 1=1
           left outer join (select Id_Postgres_Fuel from dba.Goods, dba.GoodsProperty where GoodsId = Goods.Id and GoodsCode=7001)as Goods_7001 on 1=1
           left outer join (select Id_Postgres_Fuel from dba.Goods, dba.GoodsProperty where GoodsId = Goods.Id and GoodsCode=7003)as Goods_7003 on 1=1
           left outer join (select Id_Postgres_Fuel from dba.Goods, dba.GoodsProperty where GoodsId = Goods.Id and GoodsCode=7004)as Goods_7004 on 1=1
           left outer join (select Id_Postgres_Fuel from dba.Goods, dba.GoodsProperty where GoodsId = Goods.Id and GoodsCode=7005)as Goods_7005 on 1=1
      where @inEndDate = '2013-09-30'
        and Amount <> 0 or Summ <> 0
      order by 3, 6;
      --!!!
      return;
  end if;
  -- !!!end @inIsGlobalLoad!!!
  //
  // 
  //
  -- !!! create List Unit - 1 !!! 
  insert into _tmpList_Unit (UnitId, isPartionDate)
    select Unit.Id, isnull (isUnit.isPartionDate, zc_rvNo())
    from dba.Unit
         left outer join dba.isUnit on isUnit.UnitId = Unit.Id
    where (isUnit.UnitId is not null or Unit.ParentId = 4137)
      and Unit.Id not in (zc_UnitId_StoreReturnBrak(), zc_UnitId_StoreReturn())
--      and Unit.ParentId in (4188)
-- and 1=0
    ;
  -- !!! add List Unit - 2 !!! 
/*  insert into _tmpList_Unit (BillId, UnitId, isPartionDate)
    select isnull(_tmp.BillId, 0), isnull (Unit.Id, 0), isnull (isUnit.isPartionDate, zc_rvNo())
    from dba._pgPersonal
         join dba.Unit on Unit.PersonalId_Postgres = _pgPersonal.Id
         left outer join dba.isUnit on isUnit.UnitId = Unit.Id
         left outer join _tmpList_Unit on _tmpList_Unit.UnitId = Unit.Id
         left outer join (select BillId, _pgPersonal.Id from dba._pgPersonal join dba.Unit on Unit.PersonalId_Postgres = _pgPersonal.Id join _tmpList_Unit on _tmpList_Unit.UnitId = Unit.Id) as _tmp on _tmp.Id = _pgPersonal.Id
    where _tmpList_Unit.UnitId is null
   union all
    select isnull(_tmp.BillId, 0), isnull (Unit.Id, 0), isnull (isUnit.isPartionDate, zc_rvNo())
    from dba._pgUnit
         join dba.Unit on Unit.pgUnitId = _pgUnit.Id
         left outer join dba.isUnit on isUnit.UnitId = Unit.Id
         left outer join _tmpList_Unit on _tmpList_Unit.UnitId = Unit.Id
         left outer join (select BillId, _pgUnit.Id from dba._pgUnit join dba.Unit on Unit.pgUnitId = _pgUnit.Id join _tmpList_Unit on _tmpList_Unit.UnitId = Unit.Id) as _tmp on _tmp.Id = _pgUnit.Id
    where _tmpList_Unit.UnitId is null*/;
  //
  //
  --
  if @inStartDate >= zc_def_StartDate_PartionStr_MB_SummIn()
  then
      delete from dba.tmpReport_RecalcOperation_ListNo_isPartionStr_MB;
      -- Create List GoodsProperty isPartion
      insert into _tmpList_GoodsProperty_isPartion (GoodsPropertyId)
        select GoodsPropertyID from dba._toolsView_GoodsProperty_Obvalka_isPartionStr_MB;
      -- Create List Goods
      insert into _tmpList_GoodsProperty_isPartionStr_calcRemains (GoodsPropertyId)
        select GoodsPropertyID from _tmpList_GoodsProperty_isPartion;
  end if;

      -- 0.1 Create List GoodsProperty isPartion
      insert into _tmpList_GoodsProperty_isPartion_myRecalc (GoodsPropertyId)
        select GoodsPropertyID from dba._toolsView_GoodsProperty_Obvalka_isPartionStr_MB_TWO;
      -- 0.2
      delete from dba.tmpReport_RecalcOperation_ListNo_isPartionStr_MB;
      insert into dba.tmpReport_RecalcOperation_ListNo_isPartionStr_MB (GoodsPropertyId)
         select BillItems.GoodsPropertyId
         from dba.Bill
           left outer join dba.BillItems on BillItems.BillId = Bill.Id and BillItems.OperCount <> 0
           left outer join _tmpList_GoodsProperty_isPartion_myRecalc on _tmpList_GoodsProperty_isPartion_myRecalc.GoodsPropertyId = BillItems.GoodsPropertyId
         where Bill.BillDate between MONTHS (@inStartDate, -1) and @inEndDate
           and Bill.BillKind not in (zc_bkProductionInZakaz())
           and (Bill.FromId in (zc_UnitId_Cex(), zc_UnitId_CexDelikatesy())
             or Bill.ToId in (zc_UnitId_Cex(), zc_UnitId_CexDelikatesy()))
           and _tmpList_GoodsProperty_isPartion_myRecalc.GoodsPropertyId > 0
         group by BillItems.GoodsPropertyId;
      -- 0.3
      delete from _tmpList_GoodsProperty_isPartion where GoodsPropertyId in (select tmpReport_RecalcOperation_ListNo_isPartionStr_MB.GoodsPropertyId from dba.tmpReport_RecalcOperation_ListNo_isPartionStr_MB);
      delete from _tmpList_GoodsProperty_isPartionStr_calcRemains where GoodsPropertyId in (select tmpReport_RecalcOperation_ListNo_isPartionStr_MB.GoodsPropertyId from dba.tmpReport_RecalcOperation_ListNo_isPartionStr_MB);



    -- calc remains only by PartionStr
    call dba.pInsert_ReportRemainsAll_byKindPackage_onPartionStr (@inEndDate, @inEndDate);
    -- calc remains by all
    call dba.pInsert_ReportRemainsAll_byKindPackage_onSumm (@inEndDate, @inEndDate);
    -- my delete
    delete from _tmpList_Remains_byKindPackage where GoodsPropertyId in (select GoodsPropertyID from _tmpList_GoodsProperty_isPartionStr_calcRemains);


    // 
    -- result
    select 0 as ObjectId
         , Bill.Id_Postgres as MovementId
         , Bill.BillNumber
         , Bill.BillDate
         , _tmpList_Remains_byKindPackage.UnitId
         , GoodsProperty.Id_Postgres as GoodsId
         , sum (EndCount) as Amount
         , _tmpList_Remains_byKindPackage.PartionDate as PartionGoodsDate
         , sum (case when Goods.ParentId=686 and @inEndDate>='2013-01-01' then 0 else EndSummIn end) as Summ
         , 0 as HeadCount
         , 0 as myCount
         , '' as PartionGoods
         , KindPackage.Id_Postgres as GoodsKindId
         , 0 as AssetId
         , zc_rvNo() as isCar
         , 0 as Id_Postgres
    from _tmpList_Remains_byKindPackage
         left outer join (select Bill.Id as BillId, Unit_find.Id as UnitId
                          from dba.Bill
                               left outer join dba.Unit AS UnitFrom on UnitFrom.Id = Bill.FromId
                               left outer join dba._pgUnit as pgUnitFrom on pgUnitFrom.Id = UnitFrom.pgUnitId
                               left outer join dba._pgPersonal as pgPersonalFrom on pgPersonalFrom.Id = UnitFrom.PersonalId_Postgres
                                                                                and pgPersonalFrom.Id_Postgres > 0
                               left outer join dba.Unit AS Unit_find on Unit_find.pgUnitId = pgUnitFrom.Id or Unit_find.PersonalId_Postgres = pgPersonalFrom.Id
                          where Bill.BillDate = @inEndDate
                            and Bill.BillKind in (zc_bkProductionInFromReceipt())
                            and Bill.isRemains = zc_rvYes()
                          group by BillId, UnitId
                         ) as _tmp on _tmp.UnitId = _tmpList_Remains_byKindPackage.UnitId

         left outer join dba.Bill on Bill.Id = _tmp.BillId
         left outer join dba.GoodsProperty on GoodsProperty.Id = _tmpList_Remains_byKindPackage.GoodsPropertyId
         left outer join dba.Goods on Goods.Id = GoodsProperty.GoodsId
         left outer join dba.KindPackage on KindPackage.Id = _tmpList_Remains_byKindPackage.KindPackageId
                                        and Goods.ParentId not in(686,1670,2387,2849,5874) where MovementId <> 0 --  “‡‡ + —€– + ’À≈¡ + —-œ≈–≈–¿¡Œ“ ¿ + “”ÿ≈Õ ¿

    group by Bill.Id_Postgres
           , Bill.BillNumber
           , Bill.BillDate
           , _tmpList_Remains_byKindPackage.UnitId
           , GoodsProperty.Id_Postgres
           , _tmpList_Remains_byKindPackage.PartionDate
           , KindPackage.Id_Postgres
    order by 4, 3, 5
   ;

end
go
//
-- call dba._pgSelect_Bill_Inventory_Item (zc_rvNo(), '2012-12-01', '2012-12-31')
-- call dba._pgSelect_Bill_Inventory_Item (zc_rvYes(), '2013-09-01', '2013-09-30')