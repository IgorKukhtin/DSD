alter PROCEDURE "DBA"."_pgSelect_Bill_Inventory_Item" (in @inIsGlobalLoad smallint, in @inStartDate date, in @inEndDate date)
result(ObjectId Integer, MovementId Integer, BillNumber TVarCharShort, BillDate Date, UnitId Integer, GoodsId Integer, Amount TSumm, PartionGoodsDate date, Price TSumm, Summ TSumm, HeadCount TSumm, myCount TSumm, PartionGoods TVarCharMedium, GoodsKindId Integer, AssetId Integer, isCar smallint, InfoMoneyCode Integer, Id_Postgres Integer)
begin
  --
  declare @saveRemains smallint;
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
  declare local temporary table _tmpList_Bill(
  UnitId integer not null,
  BillId integer null,
  primary key(UnitId),
  ) on commit delete rows;
  declare local temporary table _tmpList_Bill_find(
  UnitId integer not null,
  BillId integer null,
  primary key(UnitId),
  ) on commit delete rows;
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
      raiserror 21000 '@inIsGlobalLoad=zc_rvYes()';
      --
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
         -- left outer join dba._pgUnit on _pgUnit.Id = Unit.pgUnitId
         -- left outer join dba._pgPersonal on _pgPersonal.Id = Unit.PersonalId_Postgres
         -- left outer join dba.Unit AS Unit_find on Unit_find.pgUnitId = _pgUnit.Id or Unit_find.PersonalId_Postgres = _pgPersonal.Id
    where (isUnit.UnitId is not null or Unit.ParentId = 4137) -- MO
      and Unit.Id not in (zc_UnitId_StoreReturnBrak(), zc_UnitId_StoreReturn())
    group by Unit.Id, isUnit.isPartionDate
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
         where Bill.BillDate between zf_Calc_DateStart_byMinusMonth(@inEndDate) and @inEndDate
           and Bill.BillKind not in (zc_bkProductionInZakaz())
           and (Bill.FromId in (zc_UnitId_Cex(), zc_UnitId_CexDelikatesy())
             or Bill.ToId in (zc_UnitId_Cex(), zc_UnitId_CexDelikatesy()))
           and _tmpList_GoodsProperty_isPartion_myRecalc.GoodsPropertyId > 0
         group by BillItems.GoodsPropertyId;
      -- 0.3
      delete from _tmpList_GoodsProperty_isPartion where GoodsPropertyId in (select tmpReport_RecalcOperation_ListNo_isPartionStr_MB.GoodsPropertyId from dba.tmpReport_RecalcOperation_ListNo_isPartionStr_MB);
      delete from _tmpList_GoodsProperty_isPartionStr_calcRemains where GoodsPropertyId in (select tmpReport_RecalcOperation_ListNo_isPartionStr_MB.GoodsPropertyId from dba.tmpReport_RecalcOperation_ListNo_isPartionStr_MB);


   -- !!!!!!!!!!!!!
   -- set @saveRemains = zc_rvYes();
   set @saveRemains = zc_rvNo();
   -- !!!!!!!!!!!!!

   if @saveRemains = zc_rvYes()
   then 
    print '-----@saveRemains = zc_rvYes()';
    -- calc remains only by PartionStr
    call dba.pInsert_ReportRemainsAll_byKindPackage_onPartionStr (@inEndDate, @inEndDate);
    -- my delete
    delete from _tmpList_Remains_byPartionStr where PartionStr_MB = '';
    -- calc remains by all
    call dba.pInsert_ReportRemainsAll_byKindPackage_onSumm (@inEndDate, @inEndDate);
    -- my delete
    delete from _tmpList_Remains_byKindPackage where GoodsPropertyId in (select GoodsPropertyID from _tmpList_GoodsProperty_isPartionStr_calcRemains);
    -- Minus by PartionStr
    update _tmpList_Remains_byKindPackage join _tmpList_Remains_byPartionStr on _tmpList_Remains_byPartionStr.GoodsPropertyId = _tmpList_Remains_byKindPackage.GoodsPropertyId and _tmpList_Remains_byPartionStr.UnitId = _tmpList_Remains_byKindPackage.UnitId
       set _tmpList_Remains_byKindPackage.StartCount = _tmpList_Remains_byKindPackage.StartCount - _tmpList_Remains_byPartionStr.StartCount
         , _tmpList_Remains_byKindPackage.StartSummIn = _tmpList_Remains_byKindPackage.StartSummIn - _tmpList_Remains_byPartionStr.StartSummIn
         , _tmpList_Remains_byKindPackage.EndCount = _tmpList_Remains_byKindPackage.EndCount - _tmpList_Remains_byPartionStr.EndCount
         , _tmpList_Remains_byKindPackage.EndSummIn = _tmpList_Remains_byKindPackage.EndSummIn - _tmpList_Remains_byPartionStr.EndSummIn;
    -- insert Minus by PartionStr
    insert into _tmpList_Remains_byKindPackage (UnitId,GoodsPropertyId,KindPackageId,PartionDate, StartCount,StartSummIn,EndCount,EndSummIn)
      select _tmpList_Remains_byPartionStr.UnitId,
             _tmpList_Remains_byPartionStr.GoodsPropertyId,
             _tmpList_Remains_byPartionStr.KindPackageId,
             zc_DateStart() as PartionDate,
             sum (_tmpList_Remains_byPartionStr.StartCount),
             sum (_tmpList_Remains_byPartionStr.StartSummIn),
             sum (_tmpList_Remains_byPartionStr.EndCount),
             sum (_tmpList_Remains_byPartionStr.EndSummIn)
      from _tmpList_Remains_byPartionStr left outer join _tmpList_Remains_byKindPackage on _tmpList_Remains_byKindPackage.GoodsPropertyId =_tmpList_Remains_byPartionStr.GoodsPropertyId and _tmpList_Remains_byKindPackage.UnitId =_tmpList_Remains_byPartionStr.UnitId
      where _tmpList_Remains_byKindPackage.GoodsPropertyId is null
      group by _tmpList_Remains_byPartionStr.UnitId,
               _tmpList_Remains_byPartionStr.GoodsPropertyId,
               _tmpList_Remains_byPartionStr.KindPackageId;
    //
    -- save Remains
    delete from dba.tmpReport_RecalcOperation_Remains;
    insert into dba.tmpReport_RecalcOperation_Remains (UnitId,GoodsPropertyId,KindPackageId, PartionDate, StartCount,StartSummIn,EndCount,EndSummIn)
      select UnitId, GoodsPropertyId, KindPackageId,PartionDate, StartCount,StartSummIn,EndCount,EndSummIn from _tmpList_Remains_byKindPackage;
    -- save Remains by PartionStr
    delete from dba.tmpReport_RecalcOperation_Remains_byPartionStr;
    insert into dba.tmpReport_RecalcOperation_Remains_byPartionStr (UnitId,GoodsPropertyId,KindPackageId, PartionStr_MB, StartCount, StartCount_sh, StartSummIn, EndCount, EndCount_sh, EndSummIn)
      select UnitId, GoodsPropertyId, KindPackageId, PartionStr_MB, StartCount, StartCount_sh, StartSummIn, EndCount, EndCount_sh, EndSummIn from _tmpList_Remains_byPartionStr;

   else
     -- restore remains no PartionStr
     insert into _tmpList_Remains_byKindPackage (UnitId,GoodsPropertyId,KindPackageId,PartionDate,StartCount,StartSummIn,EndCount,EndSummIn)
        select UnitId, GoodsPropertyId, KindPackageId,PartionDate,StartCount,StartSummIn,EndCount,EndSummIn from dba.tmpReport_RecalcOperation_Remains;
     -- restore remains only by PartionStr
     insert into _tmpList_Remains_byPartionStr (UnitId,GoodsPropertyId,KindPackageId, PartionStr_MB, StartCount, StartCount_sh, StartSummIn, EndCount, EndCount_sh, EndSummIn)
        select UnitId, GoodsPropertyId, KindPackageId, PartionStr_MB, StartCount, 0 as StartCount_sh, StartSummIn, EndCount, 0 as EndCount_sh, EndSummIn from dba.tmpReport_RecalcOperation_Remains_byPartionStr;
   end if;


    // 
    -- Calculate PartionDate - TMÖ and ÌÍÌÀ
    update _tmpList_Remains_byKindPackage
          set _tmpList_Remains_byKindPackage.PartionDate = GoodsProperty.BillDate
    from dba.Unit
       , (select GoodsProperty.GoodsPropertyId, GoodsProperty.UnitId, max (Bill.BillDate) as BillDate
          from (select GoodsProperty.Id as GoodsPropertyId, _tmpList_Remains_byKindPackage.UnitId
                from dba.GoodsProperty
                     inner join _tmpList_Remains_byKindPackage on _tmpList_Remains_byKindPackage.GoodsPropertyId = GoodsProperty.Id
                where GoodsProperty.InfoMoneyCode in (20201, 20202, 20205, 20301, 20302, 20303, 20304, 20305)
                group by GoodsProperty.Id, _tmpList_Remains_byKindPackage.UnitId
                ) as GoodsProperty
                join dba.BillItems on BillItems.GoodsPropertyId = GoodsProperty.GoodsPropertyId
                                  and BillItems.BillKind = zc_bkSendUnitToUnit()
                                  and BillItems.OperCount <>0
                join dba.Bill on Bill.Id = BillItems.BillId
                             -- and Bill.FromId in (zc_UnitId_Composition(), zc_UnitId_CompositionZ())
                             and Bill.ToId = GoodsProperty.UnitId
          group by GoodsProperty.GoodsPropertyId, GoodsProperty.UnitId
         ) as GoodsProperty
     where _tmpList_Remains_byKindPackage.UnitId = Unit.Id and Unit.ParentId = 4137 -- MO
       and _tmpList_Remains_byKindPackage.GoodsPropertyId = GoodsProperty.GoodsPropertyId
       and _tmpList_Remains_byKindPackage.UnitId = GoodsProperty.UnitId;
    // 
    // 
    insert into _tmpList_Bill_find (BillId,UnitId)
                          select max (Bill.Id) as BillId, Bill.FromId as UnitId -- Unit_find.Id as UnitId
                          from dba.Bill
                               -- left outer join dba.Unit AS UnitFrom on UnitFrom.Id = Bill.FromId
                               -- left outer join dba._pgUnit as pgUnitFrom on pgUnitFrom.Id = UnitFrom.pgUnitId
                               -- left outer join dba._pgPersonal as pgPersonalFrom on pgPersonalFrom.Id = UnitFrom.PersonalId_Postgres
                               --                                                  and pgPersonalFrom.Id_Postgres > 0
                               -- left outer join dba.Unit AS Unit_find on Unit_find.pgUnitId = pgUnitFrom.Id or Unit_find.PersonalId_Postgres = pgPersonalFrom.Id
                          where Bill.BillDate = @inEndDate
                            and Bill.BillKind in (zc_bkProductionInFromReceipt())
                            and Bill.isRemains = zc_rvYes()
                            and Bill.Id_Postgres <> 0
                          group by UnitId;
    --
    insert into _tmpList_Bill(UnitId,BillId)
    select _tmpList_Remains_byKindPackage.UnitId, _tmp.BillId
    from (select UnitId from _tmpList_Remains_byKindPackage group by UnitId) as _tmpList_Remains_byKindPackage
         join dba.Unit on Unit.Id = _tmpList_Remains_byKindPackage.UnitId
         left outer join (select max (Unit.Id) as UnitId_find, isnull (Unit_find.pgUnitId,isnull (-Unit_find.PersonalId_Postgres, Unit.Id)) as myId
                          from dba.Unit
                               left outer join dba.isUnit on isUnit.UnitId = Unit.Id
                               left outer join dba._pgUnit on _pgUnit.Id = Unit.pgUnitId and isnull(Unit.ParentId,0) <> 4137 -- MO
                               left outer join dba._pgPersonal on _pgPersonal.Id = Unit.PersonalId_Postgres and Unit.ParentId = 4137 -- MO
                               left outer join dba.Unit AS Unit_find on Unit_find.pgUnitId = _pgUnit.Id or Unit_find.PersonalId_Postgres = _pgPersonal.Id
                          where isUnit.UnitId is not null or Unit.ParentId = 4137 -- MO
                          group by Unit_find.pgUnitId, Unit_find.PersonalId_Postgres, isnull (Unit_find.pgUnitId,isnull (-Unit_find.PersonalId_Postgres, Unit.Id))
                         ) as tmpUnit on myId = case when Unit.ParentId = 4137 then isnull(-Unit.PersonalId_Postgres,Unit.Id)
                                                     else isnull(Unit.pgUnitId,Unit.Id)
                                                end
--                                         (tmpUnit.pgUnitId = Unit.pgUnitId and isnull(Unit.ParentId,0) <> 4137) -- MO
--                                      or (tmpUnit.PersonalId_Postgres = Unit.PersonalId_Postgres and Unit.ParentId = 4137) -- MO
--                                      or (tmpUnit.UnitId_find = Unit.Id)
         left outer join _tmpList_Bill_find as _tmp on _tmp.UnitId = tmpUnit.UnitId_find
     where _tmp.BillId <>0;

    //
    print '----------- Start Finish';
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
         , case when BI_find.OperCount > 0 then BI_find.SummIn / BI_find.OperCount else 0 end as Price
         , sum (case when (Goods.ParentId=686 and @inEndDate>='2013-01-01')
                        or GoodsProperty.InfoMoneyCode not in (10101 -- Ìÿñíîå ñûðüå
                                                              ,10102 -- 
                                                              ,10103 -- 
                                                              ,10104 -- 
                                                              ,10105 -- 
                                                              ,10201 -- Ïðî÷åå ñûðüå
                                                              ,10202 -- 
                                                              ,10203 -- 
                                                              ,10204 -- 
                                                              ,20601 -- Ïðî÷èå ìàòåðèàëû
                                                              ,30101 -- Ïðîäóêöèÿ
                                                              ,30102 --
                                                              ,30103 --
                                                              ,30301 -- Ïåðåðàáîòêà
                                                              )
                          then 0 else EndSummIn end) as Summ
         , 0 as HeadCount
         , 0 as myCount
         , '' as PartionGoods
         , KindPackage.Id_Postgres as GoodsKindId
         , 0 as AssetId
         , zc_rvNo() as isCar
         , GoodsProperty.InfoMoneyCode
         , 0 as Id_Postgres
    from _tmpList_Remains_byKindPackage
         left outer join  _tmpList_Bill as _tmp on _tmp.UnitId = _tmpList_Remains_byKindPackage.UnitId


         left outer join dba.Bill on Bill.Id = _tmp.BillId
         left outer join dba.GoodsProperty on GoodsProperty.Id = _tmpList_Remains_byKindPackage.GoodsPropertyId
         left outer join dba.Goods on Goods.Id = GoodsProperty.GoodsId
         left outer join dba.KindPackage on KindPackage.Id = _tmpList_Remains_byKindPackage.KindPackageId
                                        and Goods.ParentId not in(686,1670,2387,2849,5874) --  Òàðà + ÑÛÐ + ÕËÅÁ + Ñ-ÏÅÐÅÐÀÁÎÒÊÀ + ÒÓØÅÍÊÀ
         left outer join (select GoodsProperty.GoodsPropertyId, GoodsProperty.UnitId, max (BillItems.Id) as BillItemsId
                          from (select GoodsProperty.Id as GoodsPropertyId, _tmpList_Remains_byKindPackage.UnitId, max (isnull(_tmpList_Remains_byKindPackage.PartionDate,zc_DateEnd())) as PartionDate
                                from dba.GoodsProperty
                                     inner join _tmpList_Remains_byKindPackage on _tmpList_Remains_byKindPackage.GoodsPropertyId = GoodsProperty.Id
                                where GoodsProperty.InfoMoneyCode in (20201, 20202, 20205, 20301, 20302, 20303, 20304, 20305)
                                group by GoodsProperty.Id, _tmpList_Remains_byKindPackage.UnitId
                                ) as GoodsProperty
                                join dba.BillItems on BillItems.GoodsPropertyId = GoodsProperty.GoodsPropertyId
                                                  and BillItems.BillKind = zc_bkIncomeToUnit()
                                                  and BillItems.OperCount <>0
                                                  and BillItems.OperPrice <>0
                                join dba.Bill on Bill.Id = BillItems.BillId
                                             and Bill.BillDate <= GoodsProperty.PartionDate
                          group by GoodsProperty.GoodsPropertyId, GoodsProperty.UnitId
                         ) as GoodsProperty_find on GoodsProperty_find.GoodsPropertyId = _tmpList_Remains_byKindPackage.GoodsPropertyId
                                                and GoodsProperty_find.UnitId = _tmpList_Remains_byKindPackage.UnitId

         left outer join dba.BillItems as BI_find on BI_find.Id = GoodsProperty_find.BillItemsId
         -- left outer join dba.Bill as Bill_find on Bill_find.Id = BI_find.BillId

    where MovementId <> 0 
    group by Bill.Id_Postgres
           , Bill.BillNumber
           , Bill.BillDate
           , _tmpList_Remains_byKindPackage.UnitId
           , GoodsProperty.Id_Postgres
           , _tmpList_Remains_byKindPackage.PartionDate
           , KindPackage.Id_Postgres
           , GoodsProperty.InfoMoneyCode
           , BI_find.SummIn
           , BI_find.OperCount
    order by 4, 3, 5
   ;

end
go
//
-- call dba._pgSelect_Bill_Inventory_Item (zc_rvNo(), '2014-05-01', '2014-05-31')
